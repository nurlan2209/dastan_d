const express = require("express");
const { createReview, getReviews } = require("../controllers/reviewController");
const auth = require("../middleware/authMiddleware");
const role = require("../middleware/roleMiddleware");
const router = express.Router();

router.post("/", auth, role("client"), createReview);
router.get("/", auth, getReviews);

module.exports = router;
