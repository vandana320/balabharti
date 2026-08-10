class SignatureResponse {
  final bool success;
  final SignatureData? data;

  SignatureResponse({required this.success, this.data});

  factory SignatureResponse.fromJson(Map<String, dynamic> json) {
    return SignatureResponse(
      success: json["success"] ?? false,
      data: json["data"] != null ? SignatureData.fromJson(json["data"]) : null,
    );
  }
}

class SignatureData {
  final String filename;
  final String url;

  SignatureData({required this.filename, required this.url});

  factory SignatureData.fromJson(Map<String, dynamic> json) {
    return SignatureData(
      filename: json["filename"] ?? "",
      url: json["url"] ?? "",
    );
  }
}
