import 'dart:convert';
import 'dart:developer';

import 'package:dozen_diamond/depositories_verification/models/get_depositories_verification_status_response.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../authentication/services/authentication_rest_api_service.dart';
import '../../global/constants/api_constants.dart';
import '../../global/constants/app_modules.dart';
import '../../global/constants/shared_preferences_manager.dart';
import '../../global/functions/http_api_helpers.dart';
import '../../global/models/http_api_exception.dart';
import '../models/check_depositories_verification_status_response.dart';

class DepositoriesVerificationRestApiService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl_v2 = ApiConstant.baseUrl_v2;
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;

  Future<String> get _generateToken => authentication.generateToken();

  Future<int> get _getUserID => authentication.getUserID();

  Future<int> getUserID() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getInt("reg_id") ?? 730;
    return userId;
  }

  Future<GetDepositoriesVerificationStatusResponse> getDepositoriesVerificationStatus() async {
    print("inside getDepositoriesVerificationStatus");
    try {
      // var accessToken = await _generateToken;

      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      var userId = await getUserID();

      // var url = Uri.parse("$baseUrl_v2$userId/settings/fetchCSDL-NSDL-authenication");
      // var url = Uri.parse("${baseUrl_v2}settings/fetchCSDL-NSDL-authenication");
      var url = Uri.parse("${baseUrl_v2}settings/fetchCDSL-NSDL-authentication");
      var response = await http.get(url, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });
      var result =
      GetDepositoriesVerificationStatusResponse.fromJson(jsonDecode(response.body));

      print("befor for ");
      // print(accessToken);
      log(response.body);

      print(url);
      print(jsonDecode(response.body));
      print(response.body);

      if (httpStatusChecker(response)) {
        return result;
      } else {
        if (kDebugMode || kIsWeb) {
          // return DummyUserStockAndLadderData().getDummyUserStockAndLadder() ;
          throw HttpApiException(errorCode: 404);
        } else {
          throw HttpApiException(errorCode: 404);
        }

        // throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      print("Error in the fetchLadderCreationTickers function $e");
      if (kDebugMode || kIsWeb) {
        // return DummyUserStockAndLadderData().getDummyUserStockAndLadder();
        throw e;
      } else {
        throw e;
      }
    }
  }

  Future<CheckDepositoriesVerificationStatusResponse> checkDepositoriesVerificationStatus(
      Map<String, dynamic>? requestBody) async {
    print("inside checkDepositoriesVerificationStatus");
    // String tempbaseUrl_v2 = "https://2fw8x25q-3000.inc1.devtunnels.ms/api/v1/user/";
    try {
      // var accessToken = await _generateToken;

      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await getUserID();
      // var url = Uri.parse("$baseUrl_v2$userId/settings/CSDL-NSDL-authenication");
      // var url = Uri.parse("${baseUrl_v2}settings/CSDL-NSDL-authenication");
      var url = Uri.parse("${baseUrl_v2}settings/CDSL-NSDL-authentication");
      // var url = Uri.parse("$tempbaseUrl_v2$userId/smcTradeCustomerAccessToken");
      var payload = json.encode(requestBody);
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });

      print(url);
      print(payload);
      print(response.body);
      if (httpStatusChecker(response)) {
        return CheckDepositoriesVerificationStatusResponse.fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

}