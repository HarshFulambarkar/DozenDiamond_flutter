import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../../../../authentication/services/authentication_rest_api_service.dart';
import '../../../../global/constants/api_constants.dart';
import '../../../../global/constants/app_modules.dart';
import '../../../../global/functions/http_api_helpers.dart';
import '../../../../global/models/http_api_exception.dart';
import '../models/kotak_neo_login_response.dart';
import '../models/kotak_neo_otp_response.dart';

class KotakNeoRestApiService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl_v2 = ApiConstant.baseUrl_v2;
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;

  Future<String> get _generateToken => authentication.generateToken();

  Future<int> getUserID() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getInt("reg_id") ?? 0;
    return userId;
  }

  Future<KotakNeoOtpResponse> sendKotakNeoOtp(
      Map<String, dynamic>? requestBody) async {
    try {
      var accessToken = await _generateToken;

      final userId = await getUserID();
      var url = Uri.parse("$baseUrl_v2$userId/kotak-neo/send-otp");
      var payload = json.encode(requestBody);
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });

      print("below is kotak neo login response");
      print(url);
      print(payload);
      print(response.body);
      if (httpStatusChecker(response)) {
        return KotakNeoOtpResponse.fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<KotakNeoLoginResponse> doKotakNeoLogin(
      Map<String, dynamic>? requestBody) async {
    try {
      var accessToken = await _generateToken;

      final userId = await getUserID();
      var url = Uri.parse("$baseUrl_v2$userId/kotak-neo/login/otp");
      var payload = json.encode(requestBody);
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });

      print("below is kotak neo login response");
      print(url);
      print(payload);
      print(response.body);
      if (httpStatusChecker(response)) {
        return KotakNeoLoginResponse.fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

}