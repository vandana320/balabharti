import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';

import '../models/login_request.dart';
import '../models/login_response.dart';

import '../models/register_request.dart';
import '../models/change_password_request.dart';
import '../models/common_response.dart';
import '../models/register_response.dart';

class AuthRemoteDataSource {
  final ApiClient _client = ApiClient();

  /*
  -----------------------------------------
  LOGIN
  -----------------------------------------
  */

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final Response response = await _client.dio.post(
        ApiConstants.login,

        data: request.toJson(),
      );

      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return LoginResponse.fromJson(e.response!.data);
      }

      throw Exception(e.message);
    }
  }

  /*
  -----------------------------------------
  REGISTER
  -----------------------------------------
  */

  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await _client.dio.post(
        ApiConstants.register,
        data: request.toJson(),
      );

      return RegisterResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return RegisterResponse.fromJson(e.response!.data);
      }

      throw Exception(e.message);
    }
  }

  /*
  -----------------------------------------
  CHANGE PASSWORD
  -----------------------------------------
  */

  Future<CommonResponse> changePassword(ChangePasswordRequest request) async {
    try {
      final Response response = await _client.dio.post(
        ApiConstants.changePassword,

        data: request.toJson(),
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
