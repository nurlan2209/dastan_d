const express = require("express");
const router = express.Router();
const serviceController = require("../controllers/serviceController");
const { protect, authorize } = require("../middleware/auth");

// Получить все услуги (доступно всем авторизованным пользователям)
router.get("/", protect, serviceController.getServices);

// Получить одну услугу
router.get("/:id", protect, serviceController.getServiceById);

// Создать услугу (только для админа)
router.post("/", protect, authorize("admin"), serviceController.createService);

// Обновить услугу (только для админа)
router.put("/:id", protect, authorize("admin"), serviceController.updateService);

// Удалить услугу (только для админа)
router.delete(
  "/:id",
  protect,
  authorize("admin"),
  serviceController.deleteService
);

module.exports = router;
