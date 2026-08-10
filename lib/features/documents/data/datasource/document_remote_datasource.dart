import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';

import '../../models/my_document_response.dart';

class DocumentRemoteDataSource {
  final ApiClient _client = ApiClient();

  /*
  ------------------------------------------
  My Documents
  ------------------------------------------
  */

  Future<MyDocumentResponse> getMyDocuments(String email) async {
    try {
      final Response response = await _client.dio.get(
        "${ApiConstants.myDocuments}/$email",
      );

      return MyDocumentResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return MyDocumentResponse.fromJson(e.response!.data);
      }

      throw Exception(e.message);
    }
  }

  /*
  ------------------------------------------
  Download Signed PDF
  ------------------------------------------
  */

  Future<Response> downloadSignedPdf(int documentId) async {
    try {
      final Response response = await _client.dio.get(
        "${ApiConstants.downloadPdf}/$documentId",

        options: Options(responseType: ResponseType.bytes),
      );

      return response;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
