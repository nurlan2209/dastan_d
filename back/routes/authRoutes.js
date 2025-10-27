const express = require("express");
const {
  register,
  login,
  refresh,
  getMe,
} = require("../controllers/authController");
const router = express.Router();
const auth = require("../middleware/authMiddleware");
const {
  validateRegister,
  validateLogin,
  validateRefreshToken,
} = require("../middleware/validationMiddleware");

router.post("/register", validateRegister, register);
router.post("/login", validateLogin, login);
router.post("/refresh", validateRefreshToken, refresh);
router.get("/me", auth, getMe);

module.exports = router;
