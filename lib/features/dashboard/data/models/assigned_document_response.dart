import 'assigned_document_model.dart';

class AssignedDocumentResponse {
  final bool success;
  final List<AssignedDocumentModel> data;

  AssignedDocumentResponse({required this.success, required this.data});

  factory AssignedDocumentResponse.fromJson(Map<String, dynamic> json) {
    return AssignedDocumentResponse(
      success: json["success"] ?? false,
      data: (json["data"] as List<dynamic>? ?? [])
          .map((e) => AssignedDocumentModel.fromJson(e))
          .toList(),
    );
  }
}
