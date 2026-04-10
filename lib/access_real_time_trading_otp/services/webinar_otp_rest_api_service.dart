import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../authentication/services/authentication_rest_api_service.dart';
import '../../global/constants/api_constants.dart';
import '../../global/constants/app_modules.dart';
import '../../global/constants/shared_preferences_manager.dart';
import '../../global/functions/http_api_helpers.dart';
import '../../global/models/http_api_exception.dart';
import '../models/webinar_otp_data_response.dart';
import 'package:http/http.dart' as http;

class WebinarOtpRestApiService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl_v2 = ApiConstant.baseUrl_v2;
  static const baseUrl_withoutUser = ApiConstant.baseUrl_withoutUser;
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;

  Future<String> get _generateToken => authentication.generateToken();

  Future<int> getUserID() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getInt("reg_id") ?? 0;
    return userId;
  }

  Future<WebinarOtpDataResponse> verifyWebinarOtp(Map<String, dynamic> requestBody) async {

    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await getUserID();
      // var url = Uri.parse("${baseUrl}$userId/validateWebinarOtp");
      var url = Uri.parse("${baseUrl}validateWebinarOtp");

      var payload = json.encode(requestBody);

      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });

      print(url);
      print(response.body);
      if (httpStatusChecker(response)) {
        return WebinarOtpDataResponse().fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }
}