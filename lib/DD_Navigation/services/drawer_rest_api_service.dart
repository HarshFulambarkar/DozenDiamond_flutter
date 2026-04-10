import 'dart:convert';

import 'package:dozen_diamond/DD_Navigation/models/reset_complete_simulation_response.dart';
import 'package:dozen_diamond/global/functions/http_api_helpers.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';

import '../../global/constants/app_modules.dart';
import '../../authentication/services/authentication_rest_api_service.dart';
import '../../global/constants/api_constants.dart';
import 'package:http/http.dart' as http;

import '../../global/constants/shared_preferences_manager.dart';

class DrawerRestApiService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl_v2 = ApiConstant.baseUrl_v2;
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;

  Future<String> get _generateToken => authentication.generateToken();
  Future<int> get _getUserID => authentication.getUserID();

  Future<ResetCompleteSimulationResponse?> resetCompleteSimulation() async {
    try {
      // var accessToken = await _generateToken;

      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      var userId = await _getUserID;

      var url = Uri.parse("$baseUrl_v2$userId/account/reset");

      var response = await http.delete(url, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });
      if (httpStatusChecker(response)) {
        return ResetCompleteSimulationResponse()
            .fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<bool?> resetWithRetainAccount(
      Map<String, dynamic>? requestBody) async {
    try {
      // var accessToken = await _generateToken;

      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      var userId = await _getUserID;

      var url = Uri.parse("$baseUrl_v2$userId/account/reset-retain-ladder");

      var payload = json.encode(requestBody);
      print(payload);
      var response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          // ApiConstant.authorizationHeaderKeyName: accessToken,
          ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
        },
        body: payload,
      );
      if (httpStatusChecker(response)) {
        return true;
        // return ResetCompleteSimulationResponse()
        //     .fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }
}
