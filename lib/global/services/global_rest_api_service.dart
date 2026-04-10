import 'dart:convert';
import 'dart:developer';

import 'package:dozen_diamond/global/models/graded_order_list_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../authentication/services/authentication_rest_api_service.dart';
import '../../global/constants/api_constants.dart';
import '../../global/constants/app_modules.dart';
import '../../global/functions/http_api_helpers.dart';
import '../../global/models/http_api_exception.dart';

import 'package:http/http.dart' as http;

import '../constants/shared_preferences_manager.dart';
import '../models/app_config_response.dart';
import '../models/broker_totp_response.dart';
import '../models/update_graded_order_response.dart';
import '../models/user_config_data_response.dart';

class GlobalRestApiService {
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

  Future<AppConfigResponse> getAppConfig() async {
    try {
      var accessToken = await _generateToken;
      var url = Uri.parse("${baseUrl_withoutUser}app/config");
      print(url);
      var response = await http.get(url,headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });

      log("below is url of body app/config");
      print(url);
      log(response.body);
      if (httpStatusChecker(response)) {
        return AppConfigResponse.fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<GradedOrderListResponse> getGradedOrderList() async {
    try {

      // final userId = await getUserID();
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      var accessToken = await _generateToken;
      // var url = Uri.parse("${baseUrl_v2}$userId/order/getGradedOrderList");
      var url = Uri.parse("${baseUrl_v2}order/getGradedOrderList");
      print(url);
      var response = await http.get(url,headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });

      print(url);
      print(response.body);
      if (httpStatusChecker(response)) {
        return GradedOrderListResponse.fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<bool> checkServerStatus() async {
    try {
      var accessToken = await _generateToken;
      var url = Uri.parse("${baseUrl_withoutUser}health?id=${ApiConstant.healthKey}");
      print(url);
      var response = await http.get(url,headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });

      print("below is checkServerStatus");
      print(url);
      print(response.body);
      if (httpStatusChecker(response)) {
        // return AppConfigResponse.fromJson(jsonDecode(response.body));
        return true;
      } else {
        // throw HttpApiException(errorCode: 404);
        return false;
      }
    } catch (e) {
      // throw e;
      return false;
    }
  }

  Future<UserConfigDataResponse> getUserConfigData() async {

    try {
      var accessToken = await _generateToken;

      final userId = await getUserID();
      var url = Uri.parse("${baseUrl}$userId/getUserConfig");
      // var url = Uri.parse("https://2fw8x25q-3000.inc1.devtunnels.ms/api/v1/user/723/watchlist/fetch");

      var response = await http.get(url, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });

      print(url);
      print(response.body);
      if (httpStatusChecker(response)) {
        return UserConfigDataResponse.fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<BrokerTotpResponse> submitBrokerTotp(
      Map<String, dynamic>? requestBody) async {
    // String tempbaseUrl_v2 = "https://2fw8x25q-3000.inc1.devtunnels.ms/api/v1/user/";
    try {
      var accessToken = await _generateToken;

      final userId = await getUserID();
      var url = Uri.parse("$baseUrl_v2$userId/BrokerReLogin");
      // var url = Uri.parse("$tempbaseUrl_v2$userId/smcTradeCustomerAccessToken");
      var payload = json.encode(requestBody);
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });

      print(url);
      print(payload);
      print(response.body);
      if (httpStatusChecker(response)) {
        return BrokerTotpResponse.fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<UpdateGradedOrderResponse> updateGradedOrder(
      Map<String, dynamic>? requestBody) async {
    // String tempbaseUrl_v2 = "https://2fw8x25q-3000.inc1.devtunnels.ms/api/v1/user/";
    try {
      var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      // final userId = await getUserID();
      // var url = Uri.parse("$baseUrl_v2$userId/order/updateGradedOrder");
      var url = Uri.parse("${baseUrl_v2}order/updateGradedOrder");
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
        return UpdateGradedOrderResponse.fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<bool> sendTestingMail(
      Map<String, dynamic>? requestBody) async {
    // String tempbaseUrl_v2 = "https://2fw8x25q-3000.inc1.devtunnels.ms/api/v1/user/";
    try {
      var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      // final userId = await getUserID();
      // var url = Uri.parse("$baseUrl_v2$userId/order/updateGradedOrder");
      var url = Uri.parse("${baseUrl_v2}order/updateGradedOrder");
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
        // return UpdateGradedOrderResponse.fromJson(jsonDecode(response.body));
        return true;
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }
}