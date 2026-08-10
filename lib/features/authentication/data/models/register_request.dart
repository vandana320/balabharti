class RegisterRequest {
  final String email;
  final String pin;
  final bool isAdmin;

  RegisterRequest({
    required this.email,
    required this.pin,
    required this.isAdmin,
  });

  Map<String, dynamic> toJson() {
    return {"email": email, "pin": pin, "isAdmin": isAdmin};
  }
}
