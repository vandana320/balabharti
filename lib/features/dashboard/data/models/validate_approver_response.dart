class ValidateApproverResponse {
  final bool success;
  final String message;
  final ValidateApproverData? data;

  ValidateApproverResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ValidateApproverResponse.fromJson(Map<String, dynamic> json) {
    return ValidateApproverResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] != null
          ? ValidateApproverData.fromJson(json["data"])
          : null,
    );
  }
}

class ValidateApproverData {
  final int id;
  final String email;
  final String role;

  ValidateApproverData({
    required this.id,
    required this.email,
    required this.role,
  });

  factory ValidateApproverData.fromJson(Map<String, dynamic> json) {
    return ValidateApproverData(
      id: json["id"],
      email: json["email"] ?? "",
      role: json["role"] ?? "",
    );
  }
}
