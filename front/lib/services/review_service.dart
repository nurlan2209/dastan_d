import '../models/review_model.dart';
import 'api_service.dart';

class ReviewService {
  final ApiService _api = ApiService();

  Future<List<Review>> getReviews({String? photographerId}) async {
    final queryParams = photographerId != null
        ? '?photographerId=$photographerId'
        : '';
    final response = await _api.get('/reviews$queryParams');
    return (response.data as List)
        .map((json) => Review.fromJson(json))
        .toList();
  }

  Future<Review> createReview(Map<String, dynamic> reviewData) async {
    final response = await _api.post('/reviews', data: reviewData);
    return Review.fromJson(response.data);
  }

  Future<void> deleteReview(String reviewId) async {
    await _api.delete('/reviews/$reviewId');
  }
}
