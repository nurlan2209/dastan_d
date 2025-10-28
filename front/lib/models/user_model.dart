class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final double rating;
  final String? phone;
  final bool isActive;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.rating = 0.0,
    this.phone,
    this.isActive = true,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      rating: (json['rating'] ?? 0).toDouble(),
      phone: json['phone'],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
      'rating': rating,
      'phone': phone,
      'isActive': isActive,
    };
  }
}
