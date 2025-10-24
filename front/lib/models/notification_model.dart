class NotificationModel {
  final String id;
  final String userId;
  final String message;
  final String type;
  final bool read;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.message,
    required this.type,
    required this.read,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'],
      userId: json['userId'],
      message: json['message'],
      type: json['type'],
      read: json['read'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
