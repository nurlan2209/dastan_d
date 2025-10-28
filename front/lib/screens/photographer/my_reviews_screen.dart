import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/review_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/rating_widget.dart';

class PhotographerReviewsScreen extends StatefulWidget {
  const PhotographerReviewsScreen({super.key});

  @override
  State<PhotographerReviewsScreen> createState() =>
      _PhotographerReviewsScreenState();
}

class _PhotographerReviewsScreenState extends State<PhotographerReviewsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReviews();
    });
  }

  Future<void> _loadReviews() async {
    final authProvider = context.read<AuthProvider>();
    final reviewProvider = context.read<ReviewProvider>();

    try {
      // Загружаем отзывы для текущего фотографа
      await reviewProvider.fetchReviews(
        photographerId: authProvider.user?.id,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки отзывов: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои отзывы'),
      ),
      body: Consumer2<ReviewProvider, AuthProvider>(
        builder: (context, reviewProvider, authProvider, child) {
          if (reviewProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (reviewProvider.reviews.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.rate_review_outlined,
                      size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text(
                    'У вас пока нет отзывов',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Отзывы появятся после завершения заказов',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          // Вычисляем средний рейтинг
          final reviews = reviewProvider.reviews;
          final avgRating = reviews.isEmpty
              ? 0.0
              : reviews.map((r) => r.rating).reduce((a, b) => a + b) /
                  reviews.length;

          return Column(
            children: [
              // Блок со статистикой
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                color: Colors.blue.shade50,
                child: Column(
                  children: [
                    const Text(
                      'Ваш рейтинг',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 40),
                        const SizedBox(width: 8),
                        Text(
                          avgRating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Всего отзывов: ${reviews.length}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),

              // Список отзывов
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadReviews,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RatingWidget(rating: review.rating),
                                  Text(
                                    'Заказ ID: ${review.orderId.substring(review.orderId.length - 6)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              if (review.comment != null &&
                                  review.comment!.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                const Divider(),
                                const SizedBox(height: 8),
                                Text(
                                  review.comment!,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
