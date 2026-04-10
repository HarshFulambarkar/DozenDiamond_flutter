import 'dart:convert';
import '../../global/constants/app_modules.dart';
import '../../authentication/services/authentication_rest_api_service.dart';
import '../../global/constants/api_constants.dart';
import 'package:http/http.dart' as http;

import '../../global/functions/http_api_helpers.dart';
import '../../global/models/http_api_exception.dart';
import '../models/verify_email_otp_request.dart';
import '../models/verify_email_otp_response.dart';
import '../models/verify_email_request.dart';
import '../models/verify_email_response.dart';

class SignupEmailRestApiService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;

  Future<String> get _generateToken => authentication.generateToken();

  Future<VerifyEmailResponse?> verifyEmail(
      VerifyEmailRequest verifyEmailRequest) async {
    try {
      var accessToken = await _generateToken;

      var url = Uri.parse("${baseUrl}resendotp");
      var payload = json.encode(verifyEmailRequest.toJson());
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });
      if (httpStatusChecker(response)) {
        return VerifyEmailResponse().fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<VerifyEmailOtpResponse?> verifyEmailOtp(
      VerifyEmailOtpRequest verifyEmailOtpRequest) async {
    try {
      var accessToken = await _generateToken;

      var url = Uri.parse("${baseUrl}emailverify/${verifyEmailOtpRequest.otp}");
      var response = await http.patch(url, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });
      if (httpStatusChecker(response)) {
        return VerifyEmailOtpResponse().fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }
}
