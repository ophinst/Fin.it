class User {
  final String uid;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? image;
  final String? balance;
  final String? points;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.uid,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.image,
    this.balance,
    this.points,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      image: json['image'],
      balance: json['balance'] != null ? json['balance'].toDouble() : null,
      points: json['points'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}