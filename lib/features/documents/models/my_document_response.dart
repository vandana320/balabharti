import 'my_document_model.dart';

class MyDocumentResponse {
  final bool success;

  final List<MyDocumentModel> data;

  MyDocumentResponse({required this.success, required this.data});

  factory MyDocumentResponse.fromJson(Map<String, dynamic> json) {
    return MyDocumentResponse(
      success: json["success"] ?? false,

      data: (json["data"] as List<dynamic>? ?? [])
          .map((e) => MyDocumentModel.fromJson(e))
          .toList(),
    );
  }
}