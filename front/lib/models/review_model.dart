class Review {
  final String id;
  final String orderId;
  final String clientId;
  final String photographerId;
  final int rating;
  final String? comment;

  Review({
    required this.id,
    required this.orderId,
    required this.clientId,
    required this.photographerId,
    required this.rating,
    this.comment,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    // Функция для извлечения ID из объекта или строки
    String extractId(dynamic value) {
      if (value is String) {
        return value;
      } else if (value is Map) {
        // Если это объект с _id или $oid
        return value['_id']?.toString() ?? value['\$oid']?.toString() ?? value.toString();
      }
      return value.toString();
    }

    return Review(
      id: extractId(json['_id']),
      orderId: extractId(json['orderId']),
      clientId: extractId(json['clientId']),
      photographerId: extractId(json['photographerId']),
      rating: json['rating'] is int ? json['rating'] : (json['rating'] as num).toInt(),
      comment: json['comment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'photographerId': photographerId,
      'rating': rating,
      'comment': comment,
    };
  }
}
