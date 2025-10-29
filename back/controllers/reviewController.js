const Review = require("../models/Review");
const User = require("../models/User");

exports.createReview = async (req, res) => {
  try {
    const review = await Review.create({ ...req.body, clientId: req.user.id });

    const reviews = await Review.find({
      photographerId: req.body.photographerId,
    });
    const avgRating =
      reviews.reduce((sum, r) => sum + r.rating, 0) / reviews.length;

    // Обновляем рейтинг И количество отзывов
    await User.findByIdAndUpdate(req.body.photographerId, {
      rating: avgRating,
      reviewsCount: reviews.length,
    });

    // Преобразуем ObjectId в строки для фронтенда
    const reviewData = {
      _id: review._id.toString(),
      orderId: review.orderId.toString(),
      clientId: review.clientId.toString(),
      photographerId: review.photographerId.toString(),
      rating: review.rating,
      comment: review.comment,
      createdAt: review.createdAt,
    };

    res.status(201).json(reviewData);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getReviews = async (req, res) => {
  try {
    const filter = req.query.photographerId
      ? { photographerId: req.query.photographerId }
      : {};
    const reviews = await Review.find(filter)
      .populate("clientId photographerId", "name")
      .populate("orderId", "service date")
      .sort({ createdAt: -1 });
    res.json(reviews);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Удалить отзыв (для админа - модерация)
exports.deleteReview = async (req, res) => {
  try {
    const review = await Review.findByIdAndDelete(req.params.id);
    if (!review) {
      return res.status(404).json({ message: "Review not found" });
    }

    // Пересчитать рейтинг фотографа после удаления отзыва
    const reviews = await Review.find({
      photographerId: review.photographerId,
    });

    let avgRating = 0;
    if (reviews.length > 0) {
      avgRating =
        reviews.reduce((sum, r) => sum + r.rating, 0) / reviews.length;
    }

    await User.findByIdAndUpdate(review.photographerId, {
      rating: avgRating,
      reviewsCount: reviews.length,
    });

    res.json({ message: "Review deleted successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
