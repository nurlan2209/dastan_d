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
      name: json['fullName'] ?? json['name'] ?? '',
      email: json['email'],
      role: json['role'],
      rating: (json['rating'] ?? 0).toDouble(),
      phone: json['phoneNumber'] ?? json['phone'],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': name,
      'email': email,
      'role': role,
      'rating': rating,
      'phoneNumber': phone,
      'isActive': isActive,
    };
  }
}
