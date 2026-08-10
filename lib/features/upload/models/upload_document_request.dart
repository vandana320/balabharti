import 'upload_document_model.dart';

class UploadDocumentRequest {
  final String uploadedBy;
  final List<UploadDocumentModel> documents;

  UploadDocumentRequest({required this.uploadedBy, required this.documents});
}
