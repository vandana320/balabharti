import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../models/upload_document_request.dart';
import '../../models/upload_response.dart';

class UploadRemoteDataSource {
  final ApiClient _client = ApiClient();

  Future<UploadResponse> uploadDocuments(UploadDocumentRequest request) async {
    try {
      final FormData formData = FormData();

      formData.fields.add(MapEntry("uploadedBy", request.uploadedBy));

      for (final document in request.documents) {
        formData.files.add(
          MapEntry(
            "documents",

            await MultipartFile.fromFile(
              document.file.path,

              filename: document.file.path.split("/").last,
            ),
          ),
        );

        formData.fields.add(
          MapEntry("approverEmails", jsonEncode(document.approverEmails)),
        );

        formData.fields.add(
          MapEntry(
            "approvalBoxConfig",
            jsonEncode(
              document.approvalBoxConfig.map((e) => e.toJson()).toList(),
            ),
          ),
        );
      }

      final Response response = await _client.dio.post(
        ApiConstants.uploadDocument,

        data: formData,

        options: Options(contentType: "multipart/form-data"),
      );

      return UploadResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return UploadResponse.fromJson(e.response!.data);
      }

      throw Exception(e.message);
    }
  }
}
