const express = require("express");
const {
  createOrder,
  getOrders,
  getOrderById,
  updateOrder,
  deleteOrder,
} = require("../controllers/orderController");
const auth = require("../middleware/authMiddleware");
const role = require("../middleware/roleMiddleware");
const router = express.Router();

router.post("/", auth, role("client"), createOrder);
router.get("/", auth, getOrders);
router.get("/:id", auth, getOrderById);
router.put("/:id", auth, role("admin", "photographer"), updateOrder);
router.delete("/:id", auth, role("admin"), deleteOrder);

module.exports = router;
