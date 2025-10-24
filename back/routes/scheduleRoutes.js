const express = require("express");
const {
  createSchedule,
  getSchedule,
  updateSchedule,
  deleteSchedule,
} = require("../controllers/scheduleController");
const auth = require("../middleware/authMiddleware");
const role = require("../middleware/roleMiddleware");
const router = express.Router();

router.post("/", auth, role("photographer"), createSchedule);
router.get("/", auth, getSchedule);
router.put("/:id", auth, role("photographer"), updateSchedule);
router.delete("/:id", auth, role("photographer"), deleteSchedule);

module.exports = router;
