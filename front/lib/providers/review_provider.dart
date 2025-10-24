import 'package:flutter/material.dart';
import '../models/review_model.dart';
import '../services/review_service.dart';

class ReviewProvider with ChangeNotifier {
  final ReviewService _reviewService = ReviewService();
  List<Review> _reviews = [];
  bool _isLoading = false;

  List<Review> get reviews => _reviews;
  bool get isLoading => _isLoading;

  Future<void> fetchReviews({String? photographerId}) async {
    _isLoading = true;
    notifyListeners();

    _reviews = await _reviewService.getReviews(photographerId: photographerId);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createReview(Map<String, dynamic> reviewData) async {
    await _reviewService.createReview(reviewData);
    await fetchReviews();
  }
}
