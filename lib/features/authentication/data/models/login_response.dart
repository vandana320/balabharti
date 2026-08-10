class LoginResponse {
  final bool success;
  final String message;
  final UserData? data;

  LoginResponse({required this.success, required this.message, this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json["success"],

      message: json["message"],

      data: json["data"] == null ? null : UserData.fromJson(json["data"]),
    );
  }
}

class UserData {
  final int id;
  final String email;
  final String role;

  UserData({required this.id, required this.email, required this.role});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(id: json["id"], email: json["email"], role: json["role"]);
  }
}
