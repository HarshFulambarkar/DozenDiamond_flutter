import 'dart:convert';

import '../../global/constants/app_modules.dart';
import 'package:dozen_diamond/ZZZZ_main/models/PushNotificationResponse.dart';
import 'package:dozen_diamond/authentication/services/authentication_rest_api_service.dart';
import 'package:dozen_diamond/create_ladder_detailed/constants/http_api_constant.dart';
import 'package:dozen_diamond/global/constants/api_constants.dart';
import 'package:dozen_diamond/global/functions/http_api_helpers.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class MainFileService {
  AppModule appModule = AppModule();
  static const baseUrl = ApiConstant.baseUrl;

  Future<int> getUserID() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getInt("reg_id") ?? 0;
    return userId;
  }

  Future<String> get _generateToken =>
      AuthenticationRestApiService().generateToken();

  Future<PushNotificationResponse> pushNotificationResponse(
      String userNotificationToken) async {
    try {
      var accessToken = await _generateToken;

      final userId = await getUserID();
      var url = Uri.parse("$baseUrl$userId/create-device-id");
      var payload = json.encode({"token": userNotificationToken});
      var response = await http.post(url, body: payload, headers: {
        "Content-type": "application/json",
        HttpApiConstant.authorizationHeaderKeyName: accessToken,
      });
      if (httpStatusChecker(response)) {
        return PushNotificationResponse().fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }
}
