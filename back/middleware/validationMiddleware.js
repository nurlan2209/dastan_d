const { body, param, query, validationResult } = require("express-validator");

// Middleware для проверки результатов валидации
const validate = (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({
      success: false,
      message: "Ошибка валидации данных",
      errors: errors.array().map((err) => ({
        field: err.path,
        message: err.msg,
      })),
    });
  }
  next();
};

// Валидация регистрации
const validateRegister = [
  body("fullName")
    .optional()
    .trim()
    .isLength({ min: 2, max: 50 })
    .withMessage("Имя должно быть от 2 до 50 символов"),
  body("name")
    .optional()
    .trim()
    .isLength({ min: 2, max: 50 })
    .withMessage("Имя должно быть от 2 до 50 символов"),
  body("email")
    .trim()
    .notEmpty()
    .withMessage("Email обязателен")
    .isEmail()
    .withMessage("Некорректный формат email")
    .normalizeEmail(),
  body("password")
    .notEmpty()
    .withMessage("Пароль обязателен")
    .isLength({ min: 6 })
    .withMessage("Пароль должен содержать минимум 6 символов"),
  body("role")
    .optional()
    .isIn(["client", "photographer", "admin"])
    .withMessage("Некорректная роль"),
  body("phoneNumber")
    .optional()
    .matches(/^\+?[0-9\s]{10,20}$/)
    .withMessage("Некорректный формат телефона"),
  body("phone")
    .optional()
    .matches(/^\+?[0-9\s]{10,20}$/)
    .withMessage("Некорректный формат телефона"),
  validate,
];

// Валидация входа
const validateLogin = [
  body("email")
    .trim()
    .notEmpty()
    .withMessage("Email обязателен")
    .isEmail()
    .withMessage("Некорректный формат email")
    .normalizeEmail(),
  body("password").notEmpty().withMessage("Пароль обязателен"),
  validate,
];

// Валидация обновления токена
const validateRefreshToken = [
  body("refreshToken").notEmpty().withMessage("Refresh token обязателен"),
  validate,
];

// Валидация создания заказа
const validateCreateOrder = [
  body("service")
    .trim()
    .notEmpty()
    .withMessage("Услуга обязательна")
    .isLength({ max: 100 })
    .withMessage("Название услуги слишком длинное"),
  body("date")
    .notEmpty()
    .withMessage("Дата обязательна")
    .isISO8601()
    .withMessage("Некорректный формат даты"),
  body("location")
    .optional()
    .trim()
    .isLength({ max: 200 })
    .withMessage("Адрес слишком длинный"),
  body("price")
    .notEmpty()
    .withMessage("Цена обязательна")
    .isNumeric()
    .withMessage("Цена должна быть числом")
    .custom((value) => value >= 0)
    .withMessage("Цена не может быть отрицательной"),
  body("comment")
    .optional()
    .trim()
    .isLength({ max: 500 })
    .withMessage("Комментарий слишком длинный"),
  validate,
];

// Валидация обновления заказа
const validateUpdateOrder = [
  param("id").isMongoId().withMessage("Некорректный ID заказа"),
  body("service")
    .optional()
    .trim()
    .isLength({ max: 100 })
    .withMessage("Название услуги слишком длинное"),
  body("date")
    .optional()
    .isISO8601()
    .withMessage("Некорректный формат даты"),
  body("location")
    .optional()
    .trim()
    .isLength({ max: 200 })
    .withMessage("Адрес слишком длинный"),
  body("price")
    .optional()
    .isNumeric()
    .withMessage("Цена должна быть числом")
    .custom((value) => value >= 0)
    .withMessage("Цена не может быть отрицательной"),
  body("status")
    .optional()
    .isIn(["new", "assigned", "in_progress", "completed", "cancelled", "archived"])
    .withMessage("Некорректный статус"),
  body("photographerId")
    .optional()
    .isMongoId()
    .withMessage("Некорректный ID фотографа"),
  body("comment")
    .optional()
    .trim()
    .isLength({ max: 500 })
    .withMessage("Комментарий слишком длинный"),
  validate,
];

// Валидация ID в параметрах
const validateMongoId = [
  param("id").isMongoId().withMessage("Некорректный ID"),
  validate,
];

// Валидация создания пользователя (админ)
const validateCreateUser = [
  body("fullName")
    .optional()
    .trim()
    .isLength({ min: 2, max: 50 })
    .withMessage("Имя должно быть от 2 до 50 символов"),
  body("name")
    .optional()
    .trim()
    .isLength({ min: 2, max: 50 })
    .withMessage("Имя должно быть от 2 до 50 символов"),
  body("email")
    .trim()
    .notEmpty()
    .withMessage("Email обязателен")
    .isEmail()
    .withMessage("Некорректный формат email")
    .normalizeEmail(),
  body("password")
    .notEmpty()
    .withMessage("Пароль обязателен")
    .isLength({ min: 6 })
    .withMessage("Пароль должен содержать минимум 6 символов"),
  body("role")
    .notEmpty()
    .withMessage("Роль обязательна")
    .isIn(["client", "photographer", "admin"])
    .withMessage("Некорректная роль"),
  body("phoneNumber")
    .optional()
    .matches(/^\+?[0-9\s]{10,20}$/)
    .withMessage("Некорректный формат телефона"),
  body("phone")
    .optional()
    .matches(/^\+?[0-9\s]{10,20}$/)
    .withMessage("Некорректный формат телефона"),
  validate,
];

// Валидация обновления пользователя
const validateUpdateUser = [
  param("id").isMongoId().withMessage("Некорректный ID пользователя"),
  body("fullName")
    .optional()
    .trim()
    .isLength({ min: 2, max: 50 })
    .withMessage("Имя должно быть от 2 до 50 символов"),
  body("name")
    .optional()
    .trim()
    .isLength({ min: 2, max: 50 })
    .withMessage("Имя должно быть от 2 до 50 символов"),
  body("email")
    .optional()
    .trim()
    .isEmail()
    .withMessage("Некорректный формат email")
    .normalizeEmail(),
  body("role")
    .optional()
    .isIn(["client", "photographer", "admin"])
    .withMessage("Некорректная роль"),
  body("phoneNumber")
    .optional()
    .matches(/^\+?[0-9\s]{10,20}$/)
    .withMessage("Некорректный формат телефона"),
  body("phone")
    .optional()
    .matches(/^\+?[0-9\s]{10,20}$/)
    .withMessage("Некорректный формат телефона"),
  validate,
];

// Валидация создания отзыва
const validateCreateReview = [
  body("orderId")
    .notEmpty()
    .withMessage("ID заказа обязателен")
    .isMongoId()
    .withMessage("Некорректный ID заказа"),
  body("photographerId")
    .notEmpty()
    .withMessage("ID фотографа обязателен")
    .isMongoId()
    .withMessage("Некорректный ID фотографа"),
  body("rating")
    .notEmpty()
    .withMessage("Рейтинг обязателен")
    .isInt({ min: 1, max: 5 })
    .withMessage("Рейтинг должен быть от 1 до 5"),
  body("comment")
    .optional()
    .trim()
    .isLength({ max: 500 })
    .withMessage("Комментарий слишком длинный"),
  validate,
];

// Валидация создания расписания
const validateCreateSchedule = [
  body("date")
    .notEmpty()
    .withMessage("Дата обязательна")
    .isISO8601()
    .withMessage("Некорректный формат даты"),
  body("startTime")
    .notEmpty()
    .withMessage("Время начала обязательно")
    .matches(/^([01]?[0-9]|2[0-3]):[0-5][0-9]$/)
    .withMessage("Некорректный формат времени (HH:MM)"),
  body("endTime")
    .notEmpty()
    .withMessage("Время окончания обязательно")
    .matches(/^([01]?[0-9]|2[0-3]):[0-5][0-9]$/)
    .withMessage("Некорректный формат времени (HH:MM)"),
  body("available")
    .optional()
    .isBoolean()
    .withMessage("Доступность должна быть boolean"),
  validate,
];

module.exports = {
  validate,
  validateRegister,
  validateLogin,
  validateRefreshToken,
  validateCreateOrder,
  validateUpdateOrder,
  validateMongoId,
  validateCreateUser,
  validateUpdateUser,
  validateCreateReview,
  validateCreateSchedule,
};
