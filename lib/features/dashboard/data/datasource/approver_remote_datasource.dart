import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';

import '../../../../shared/models/common_response.dart';
import '../models/approve_request.dart';
import '../models/assigned_document_response.dart';
import '../models/signature_response.dart';
import '../models/validate_approver_request.dart';
import '../models/validate_approver_response.dart';

class ApproverRemoteDataSource {
  final ApiClient _client = ApiClient();

  /*
  ------------------------------------------
  Validate Approver
  ------------------------------------------
  */

  Future<ValidateApproverResponse> validateApprover(
    ValidateApproverRequest request,
  ) async {
    try {
      final Response response = await _client.dio.post(
        ApiConstants.validateApprover,
        data: request.toJson(),
      );

      debugPrint("Validate Request: ${request.toJson()}");
      debugPrint("Validate Response: ${response.data}");

      return ValidateApproverResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        print("Dio Exception");
        print(e);
        print(e.response?.data);
        return ValidateApproverResponse.fromJson(e.response!.data);
      }

      throw Exception(e.message);
    }
  }

  /*
  ------------------------------------------
  Assigned Documents
  ------------------------------------------
  */

  Future<AssignedDocumentResponse> getAssignedDocuments(int adminId) async {
    final url = "${ApiConstants.assignedDocuments}/$adminId";

    debugPrint("GET -> $url");

    final response = await _client.dio.get(url);

    debugPrint(response.data.toString());

    return AssignedDocumentResponse.fromJson(response.data);
  }

  /*
  ------------------------------------------
  Last Signature
  ------------------------------------------
  */

  Future<SignatureResponse> getLastSignature(int adminId) async {
    final url = "${ApiConstants.signature}/$adminId";

    debugPrint("GET -> $url");

    final response = await _client.dio.get(url);

    return SignatureResponse.fromJson(response.data);
  }

  /*
  ------------------------------------------
  Approve / Reject
  ------------------------------------------
  */

  Future<CommonResponse> approveDocument(ApproveRequest request) async {
    try {
      final Map<String, dynamic> data = {
        "documentId": request.documentId,
        "status": request.status,
        "approvalDateTime": request.approvalDateTime,
        "approvedBy": request.approvedBy,
      };

      /// Upload new signature
      if (request.signature != null) {
        data["signature"] = await MultipartFile.fromFile(
          request.signature!.path,
          filename: request.signature!.path.split("/").last,
        );
      }

      /// Use previously saved signature
      if (request.savedSignatureFilename != null &&
          request.savedSignatureFilename!.isNotEmpty) {
        data["savedSignatureFilename"] = request.savedSignatureFilename;
      }

      final formData = FormData.fromMap(data);

      final Response response = await _client.dio.post(
        ApiConstants.approveDocument,
        data: formData,
      );

      return CommonResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return CommonResponse.fromJson(e.response!.data);
      }

      throw Exception(e.message);
    }
  }
}
