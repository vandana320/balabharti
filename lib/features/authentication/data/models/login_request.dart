class LoginRequest {
  final String email;
  final String pin;

  LoginRequest({required this.email, required this.pin});

  Map<String, dynamic> toJson() {
    return {"email": email, "pin": pin};
  }
}
