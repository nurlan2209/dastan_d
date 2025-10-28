const express = require("express");
const {
  createReview,
  getReviews,
  deleteReview,
} = require("../controllers/reviewController");
const auth = require("../middleware/authMiddleware");
const role = require("../middleware/roleMiddleware");
const router = express.Router();

router.post("/", auth, role("client"), createReview);
router.get("/", auth, getReviews);
router.delete("/:id", auth, role("admin"), deleteReview);

module.exports = router;
