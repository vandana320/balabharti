class ApiErrorResponse {
  final bool success;
  final String message;
  final int? statusCode;

  const ApiErrorResponse({
    required this.success,
    required this.message,
    this.statusCode,
  });

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) {
    return ApiErrorResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "Something went wrong",
      statusCode: json["statusCode"],
    );
  }

  Map<String, dynamic> toJson() {
    return {"success": success, "message": message, "statusCode": statusCode};
  }
}
