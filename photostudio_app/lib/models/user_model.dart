class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final double rating;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.rating = 0.0,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      rating: (json['rating'] ?? 0).toDouble(),
    );
  }
}
