const express = require("express");
const {
  getSummary,
  getStatistics,
  exportPDF,
  exportCSV,
  getPhotographerPayments,
} = require("../controllers/reportController");
const auth = require("../middleware/authMiddleware");
const role = require("../middleware/roleMiddleware");
const router = express.Router();

router.get("/summary", auth, role("admin"), getSummary);
router.get("/statistics", auth, role("admin"), getStatistics);
router.get("/export/pdf", auth, role("admin"), exportPDF);
router.get("/export/csv", auth, role("admin"), exportCSV);
router.get("/photographer-payments", auth, role("admin"), getPhotographerPayments);

module.exports = router;
