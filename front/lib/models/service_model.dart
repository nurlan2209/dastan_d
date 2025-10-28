class Service {
  final String id;
  final String name;
  final String description;
  final double price;
  final int duration; // в минутах
  final bool isActive;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    this.isActive = true,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['_id'],
      name: json['name'],
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      duration: json['duration'] as int,
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'duration': duration,
      'isActive': isActive,
    };
  }
}
