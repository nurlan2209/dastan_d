const express = require("express");
const {
  register,
  login,
  refresh,
  getMe,
} = require("../controllers/authController");
const router = express.Router();
const auth = require("../middleware/authMiddleware");

router.post("/register", register);
router.post("/login", login);
router.post("/refresh", refresh);
router.get("/me", auth, getMe);

module.exports = router;
