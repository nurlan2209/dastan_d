const Review = require("../models/Review");
const User = require("../models/User");
const { sendNotification } = require("../utils/socketHandler");

exports.createReview = async (req, res) => {
  try {
    const review = await Review.create({ ...req.body, clientId: req.user.id });

    const reviews = await Review.find({
      photographerId: req.body.photographerId,
    });
    const avgRating =
      reviews.reduce((sum, r) => sum + r.rating, 0) / reviews.length;
    await User.findByIdAndUpdate(req.body.photographerId, {
      rating: avgRating,
    });

    sendNotification(
      req.body.photographerId,
      "Вы получили новый отзыв",
      "review"
    );

    res.status(201).json(review);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getReviews = async (req, res) => {
  try {
    const filter = req.query.photographerId
      ? { photographerId: req.query.photographerId }
      : {};
    const reviews = await Review.find(filter).populate(
      "clientId photographerId",
      "name"
    );
    res.json(reviews);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
