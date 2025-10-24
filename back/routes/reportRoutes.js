const express = require("express");
const {
  getStatistics,
  exportPDF,
  exportCSV,
} = require("../controllers/reportController");
const auth = require("../middleware/authMiddleware");
const role = require("../middleware/roleMiddleware");
const router = express.Router();

router.get("/statistics", auth, role("admin"), getStatistics);
router.get("/export/pdf", auth, role("admin"), exportPDF);
router.get("/export/csv", auth, role("admin"), exportCSV);

module.exports = router;
