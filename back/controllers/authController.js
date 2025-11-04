const bcrypt = require("bcryptjs");
const User = require("../models/User");
const VerificationCode = require("../models/VerificationCode");
const {
  generateAccessToken,
  generateRefreshToken,
  verifyToken,
} = require("../utils/tokenUtils");
const {
  generateVerificationCode,
  sendPasswordResetEmail,
} = require("../services/emailService");

// Функция валидации пароля
const validatePassword = (password) => {
  // Минимум 6 символов
  if (password.length < 6) {
    return { valid: false, message: "Пароль должен содержать минимум 6 символов" };
  }

  // Проверка на наличие заглавной буквы
  if (!/[A-ZА-ЯЁ]/.test(password)) {
    return { valid: false, message: "Пароль должен начинаться с заглавной буквы" };
  }

  // Проверка на наличие специального символа
  if (!/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)) {
    return { valid: false, message: "Пароль должен содержать специальный символ (!@#$%^&* и т.д.)" };
  }

  return { valid: true };
};

// Регистрация пользователя
const register = async (req, res) => {
  try {
    const { name, fullName, email, password, role, phone, phoneNumber } = req.body;

    // Проверяем наличие имени
    const userName = fullName || name;
    if (!userName) {
      return res.status(400).json({ message: "Имя обязательно" });
    }

    // Валидация пароля
    const passwordValidation = validatePassword(password);
    if (!passwordValidation.valid) {
      return res.status(400).json({ message: passwordValidation.message });
    }

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ message: "Email уже используется" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = new User({
      fullName: userName,
      email,
      password: hashedPassword,
      role: role || "client",
      phoneNumber: phoneNumber || phone || "",
      emailVerified: true,
    });

    await user.save();

    // Генерируем токены для автоматического входа
    const accessToken = generateAccessToken(user._id, user.role);
    const refreshToken = generateRefreshToken(user._id);

    res.status(201).json({
      message: "Регистрация успешна!",
      accessToken,
      refreshToken,
      role: user.role,
      userId: user._id,
      name: user.fullName,
      email: user.email
    });
  } catch (error) {
    console.error("Ошибка регистрации:", error);
    res.status(500).json({ message: error.message });
  }
};

// Вход в систему
const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!user || !(await bcrypt.compare(password, user.password))) {
      return res.status(401).json({ message: "Неверный email или пароль" });
    }

    const accessToken = generateAccessToken(user._id, user.role);
    const refreshToken = generateRefreshToken(user._id);

    res.json({
      accessToken,
      refreshToken,
      role: user.role,
      userId: user._id,
      name: user.fullName,
      email: user.email
    });
  } catch (err) {
    console.error("Ошибка входа:", err);
    res.status(500).json({ error: err.message });
  }
};

// Запрос на сброс пароля
const forgotPassword = async (req, res) => {
  try {
    const { email } = req.body;

    if (!email) {
      return res.status(400).json({ message: "Email обязателен" });
    }

    const user = await User.findOne({ email });
    if (!user) {
      // Из соображений безопасности не сообщаем, что пользователь не найден
      return res.json({
        message: "Если указанный email зарегистрирован, на него отправлен код для сброса пароля"
      });
    }

    // Генерируем код
    const code = generateVerificationCode();
    const expiresAt = new Date(Date.now() + 5 * 60 * 1000);

    // Удаляем старые коды
    await VerificationCode.deleteMany({ email, type: "password_reset" });

    const verificationCode = new VerificationCode({
      email,
      code,
      type: "password_reset",
      expiresAt,
    });

    await verificationCode.save();

    // Отправляем email
    await sendPasswordResetEmail(email, code);

    res.json({
      message: "Если указанный email зарегистрирован, на него отправлен код для сброса пароля"
    });
  } catch (error) {
    console.error("Ошибка запроса сброса пароля:", error);
    res.status(500).json({ message: error.message });
  }
};

// Сброс пароля
const resetPassword = async (req, res) => {
  try {
    const { email, code, newPassword } = req.body;

    if (!email || !code || !newPassword) {
      return res.status(400).json({ message: "Email, код и новый пароль обязательны" });
    }

    // Валидация нового пароля
    const passwordValidation = validatePassword(newPassword);
    if (!passwordValidation.valid) {
      return res.status(400).json({ message: passwordValidation.message });
    }

    // Находим код подтверждения
    const verificationCode = await VerificationCode.findOne({
      email,
      code,
      type: "password_reset",
      isUsed: false,
    });

    if (!verificationCode) {
      return res.status(400).json({ message: "Неверный код подтверждения" });
    }

    // Проверяем срок действия
    if (new Date() > verificationCode.expiresAt) {
      await VerificationCode.deleteOne({ _id: verificationCode._id });
      return res.status(400).json({ message: "Код подтверждения истек" });
    }

    // Находим пользователя и обновляем пароль
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ message: "Пользователь не найден" });
    }

    const hashedPassword = await bcrypt.hash(newPassword, 10);
    user.password = hashedPassword;
    await user.save();

    // Удаляем использованный код
    await VerificationCode.deleteOne({ _id: verificationCode._id });

    res.json({ message: "Пароль успешно изменен" });
  } catch (error) {
    console.error("Ошибка сброса пароля:", error);
    res.status(500).json({ message: error.message });
  }
};

// Обновление токена
const refresh = async (req, res) => {
  try {
    const { refreshToken } = req.body;
    const decoded = verifyToken(refreshToken, true);
    const user = await User.findById(decoded.id);
    if (!user) {
      return res.status(403).json({ message: "Invalid refresh token" });
    }
    const accessToken = generateAccessToken(user._id, user.role);
    res.json({ accessToken, role: user.role, userId: user._id });
  } catch (err) {
    res.status(403).json({ message: "Invalid refresh token" });
  }
};

// Получение информации о текущем пользователе
const getMe = async (req, res) => {
  try {
    const user = await User.findById(req.user.id).select("-password");
    res.json(user);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

module.exports = {
  register,
  login,
  forgotPassword,
  resetPassword,
  refresh,
  getMe,
};
