const User = require("../models/User");
const bcrypt = require("bcryptjs");

const getAllUsers = async (req, res) => {
  try {
    const { role } = req.query;
    const filter = role ? { role } : {};
    const users = await User.find(filter).select("-password");
    res.json(users);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.getAllUsers = getAllUsers; // ← ДОБАВЬ ЭТУ СТРОКУ

exports.getUserById = async (req, res) => {
  try {
    const user = await User.findById(req.params.id).select("-password");
    if (!user) return res.status(404).json({ message: "User not found" });
    res.json(user);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.createUser = async (req, res) => {
  try {
    const { name, fullName, email, password, role, phone, phoneNumber } = req.body;

    // Проверяем наличие имени
    const userName = fullName || name;
    if (!userName) {
      return res.status(400).json({ error: "Имя обязательно" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const user = await User.create({
      fullName: userName,
      email,
      password: hashedPassword,
      role,
      phoneNumber: phoneNumber || phone || "",
      emailVerified: true,
    });
    res.status(201).json(user);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.updateUser = async (req, res) => {
  try {
    const updates = { ...req.body };

    // Преобразуем name в fullName если есть
    if (updates.name && !updates.fullName) {
      updates.fullName = updates.name;
      delete updates.name;
    }

    // Преобразуем phone в phoneNumber если есть
    if (updates.phone && !updates.phoneNumber) {
      updates.phoneNumber = updates.phone;
      delete updates.phone;
    }

    if (updates.password) {
      updates.password = await bcrypt.hash(updates.password, 10);
    }

    const user = await User.findByIdAndUpdate(req.params.id, updates, {
      new: true,
    }).select("-password");
    res.json(user);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.deleteUser = async (req, res) => {
  try {
    await User.findByIdAndDelete(req.params.id);
    res.json({ message: "User deleted" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Блокировка/разблокировка пользователя (только для админа)
exports.toggleUserStatus = async (req, res) => {
  try {
    const user = await User.findById(req.params.id);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    user.isActive = !user.isActive;
    await user.save();

    res.json({
      message: user.isActive ? "User activated" : "User blocked",
      user: {
        id: user._id,
        name: user.fullName,
        email: user.email,
        isActive: user.isActive,
      },
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
