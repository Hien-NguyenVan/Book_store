class UserData {
  final String userId;
  final String email;
  final String role;

  UserData({
    required this.userId,
    required this.email,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'role': role,
    };
  }

  static UserData fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json['userId'],
      email: json['email'],
      role: json['role'],
    );
  }
}
