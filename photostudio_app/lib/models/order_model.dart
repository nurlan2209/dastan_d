class Order {
  final String id;
  final String clientId;
  final String? photographerId;
  final String service;
  final DateTime date;
  final String location;
  final String status;
  final double price;
  final String? result;
  final String? comment;

  Order({
    required this.id,
    required this.clientId,
    this.photographerId,
    required this.service,
    required this.date,
    required this.location,
    required this.status,
    required this.price,
    this.result,
    this.comment,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'],
      clientId: json['clientId'] is String
          ? json['clientId']
          : json['clientId']['_id'],
      photographerId: json['photographerId'] == null
          ? null
          : (json['photographerId'] is String
                ? json['photographerId']
                : json['photographerId']['_id']),
      service: json['service'],
      date: DateTime.parse(json['date']),
      location: json['location'],
      status: json['status'],
      price: (json['price'] is int) ? json['price'].toDouble() : json['price'],
      result: json['result'],
      comment: json['comment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clientId': clientId,
      'photographerId': photographerId,
      'service': service,
      'date': date.toIso8601String(),
      'location': location,
      'status': status,
      'price': price,
      'result': result,
      'comment': comment,
    };
  }
}
