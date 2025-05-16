class User {
  final String id;
  final String name;
  final String? avatar;
  final String? email;
  final String? phone;
  final Map<String, dynamic>? additionalInfo;

  User({
    required this.id,
    required this.name,
    this.avatar,
    this.email,
    this.phone,
    this.additionalInfo,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      additionalInfo: json['additionalInfo'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'email': email,
      'phone': phone,
      'additionalInfo': additionalInfo,
    };
  }
}
