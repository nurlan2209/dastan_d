const express = require("express");
const {
  register,
  verifyEmail,
  resendVerificationCode,
  login,
  forgotPassword,
  resetPassword,
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
router.post("/verify-email", verifyEmail);
router.post("/resend-verification", resendVerificationCode);
router.post("/login", validateLogin, login);
router.post("/forgot-password", forgotPassword);
router.post("/reset-password", resetPassword);
router.post("/refresh", validateRefreshToken, refresh);
router.get("/me", auth, getMe);

module.exports = router;
