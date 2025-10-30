const bcrypt = require("bcryptjs");
const User = require("../models/User");
const {
  generateAccessToken,
  generateRefreshToken,
  verifyToken,
} = require("../utils/tokenUtils");

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

const register = async (req, res) => {
  try {
    const { name, email, password, role, phone } = req.body;

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
      name,
      email,
      password: hashedPassword,
      role: role || "client",
      phone: phone || "",
    });

    await user.save();

    // Генерируем токены для автоматического входа
    const accessToken = generateAccessToken(user._id, user.role);
    const refreshToken = generateRefreshToken(user._id);

    res.status(201).json({
      message: "Регистрация успешна",
      accessToken,
      refreshToken,
      role: user.role,
      userId: user._id,
      name: user.name,
      email: user.email
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.register = register; // ← ДОБАВЬ ЭТУ СТРОКУ

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email });
    if (!user || !(await bcrypt.compare(password, user.password))) {
      return res.status(401).json({ message: "Invalid credentials" });
    }
    const accessToken = generateAccessToken(user._id, user.role);
    const refreshToken = generateRefreshToken(user._id);
    res.json({ accessToken, refreshToken, role: user.role, userId: user._id });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.refresh = async (req, res) => {
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

exports.getMe = async (req, res) => {
  try {
    const user = await User.findById(req.user.id).select("-password");
    res.json(user);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
