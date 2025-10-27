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
const {
  validateCreateOrder,
  validateUpdateOrder,
  validateMongoId,
} = require("../middleware/validationMiddleware");
const router = express.Router();

router.post("/", auth, role("client"), validateCreateOrder, createOrder);
router.get("/", auth, getOrders);
router.get("/:id", auth, validateMongoId, getOrderById);
router.put(
  "/:id",
  auth,
  role("admin", "photographer"),
  validateUpdateOrder,
  updateOrder
);
router.delete("/:id", auth, role("admin"), validateMongoId, deleteOrder);

module.exports = router;
