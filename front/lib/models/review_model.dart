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
    return Review(
      id: json['_id'],
      orderId: json['orderId'],
      clientId: json['clientId'],
      photographerId: json['photographerId'],
      rating: json['rating'],
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
