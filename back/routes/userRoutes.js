const express = require("express");
const {
  getAllUsers,
  getUserById,
  createUser,
  updateUser,
  deleteUser,
  toggleUserStatus,
} = require("../controllers/userController");
const auth = require("../middleware/authMiddleware");
const role = require("../middleware/roleMiddleware");
const router = express.Router();

router.get("/", auth, role("admin"), getAllUsers);
router.get("/:id", auth, getUserById);
router.post("/", auth, role("admin"), createUser);
router.put("/:id", auth, role("admin"), updateUser);
router.delete("/:id", auth, role("admin"), deleteUser);
router.patch("/:id/toggle-status", auth, role("admin"), toggleUserStatus);

module.exports = router;
