import 'dart:convert';
import 'package:dozen_diamond/global/functions/http_api_helpers.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:http/http.dart' as http;

import '../../global/constants/app_modules.dart';
import 'package:dozen_diamond/global/constants/api_constants.dart';

import '../../authentication/services/authentication_rest_api_service.dart';
import '../../global/constants/shared_preferences_manager.dart';
import '../models/get_new_user_activity_response.dart';

class ActivityRestApiService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl_v2 = ApiConstant.baseUrl_v2;
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;

  Future<String> get _generateToken => authentication.generateToken();
  Future<int> get _getUserID => authentication.getUserID();

  Future<GetNewUserActivityResponse?> getNewUserActivity(
      String sortType, String sortAs, String levelType) async {
    print("inside getNewUserActivity");
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";
      final userId = await _getUserID;
      var url = Uri.parse(
          "$baseUrl_v2$userId/activity/fetch-all?sortType=$sortType&sortAs=$sortAs&levelType=$levelType");
      var response = await http.get(url, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });
      print(url);
      print(response.body);
      if (httpStatusChecker(response)) {
        return GetNewUserActivityResponse().fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }
}
