const express = require("express");
const router = express.Router();
const serviceController = require("../controllers/serviceController");
const auth = require("../middleware/authMiddleware");
const role = require("../middleware/roleMiddleware");

// Получить все услуги (доступно всем авторизованным пользователям)
router.get("/", auth, serviceController.getServices);

// Получить одну услугу
router.get("/:id", auth, serviceController.getServiceById);

// Создать услугу (только для админа)
router.post("/", auth, role("admin"), serviceController.createService);

// Обновить услугу (только для админа)
router.put("/:id", auth, role("admin"), serviceController.updateService);

// Удалить услугу (только для админа)
router.delete(
  "/:id",
  auth,
  role("admin"),
  serviceController.deleteService
);

module.exports = router;
