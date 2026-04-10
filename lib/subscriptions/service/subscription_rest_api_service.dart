import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../authentication/services/authentication_rest_api_service.dart';
import '../../global/constants/api_constants.dart';
import '../../global/constants/app_modules.dart';
import '../../global/constants/shared_preferences_manager.dart';
import '../../global/functions/http_api_helpers.dart';
import '../../global/models/http_api_exception.dart';
import '../models/generate_order_data_response.dart';
import '../models/subscribe_data_response.dart';

import 'package:http/http.dart' as http;

import '../models/subscribed_data_response.dart';
import '../models/subscription_plan_data_response.dart';
import '../models/verify_payment_response.dart';
import '../models/verify_subscription_payment_response.dart';

class SubscriptionRestApiService {
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

  Future<SubscribeDataResponse> subscribe(
      Map<String, dynamic>? requestBody) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await getUserID();
      // var url = Uri.parse("$baseUrl_v2$userId/subscribe");
      var url = Uri.parse("${baseUrl_v2}subscribe");

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
        return SubscribeDataResponse.fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<SubscriptionPlanDataResponse> getSubscriptionPlans() async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await getUserID();
      // var url = Uri.parse("$baseUrl_v2$userId/subscription-plans");
      // var url = Uri.parse("${baseUrl_v2}subscription-plans");
      var url = Uri.parse("${baseUrl_v2}subscription/plans");
      var response = await http.get(url, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });

      print(url);
      print(response.body);
      if (httpStatusChecker(response)) {
        return SubscriptionPlanDataResponse.fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<GenerateOrderDataResponse> createOrder(
      Map<String, dynamic>? requestBody) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await getUserID();
      // var url = Uri.parse("$baseUrl_v2$userId/create-order");
      // var url = Uri.parse("${baseUrl_v2}create-order");
      var url = Uri.parse("${baseUrl_v2}subscription/create-order");
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
        return GenerateOrderDataResponse.fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<VerifyPaymentResponse> verifyPayment(
      Map<String, dynamic>? requestBody) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await getUserID();
      // var url = Uri.parse("$baseUrl_v2$userId/verify-payment");
      // var url = Uri.parse("${baseUrl_v2}verify-payment");
      var url = Uri.parse("${baseUrl_v2}subscription/verify-payment");
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
        return VerifyPaymentResponse.fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<VerifySubscriptionPaymentResponse> verifySubscription(
      Map<String, dynamic>? requestBody) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await getUserID();
      // var url = Uri.parse("$baseUrl_v2$userId/verfiysubscribe");
      var url = Uri.parse("${baseUrl_v2}verfiysubscribe");
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
        return VerifySubscriptionPaymentResponse.fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<SubscribedDataResponse> getSubscribedDetails() async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await getUserID();
      // var url = Uri.parse("$baseUrl_v2$userId/get-subscription-details");
      var url = Uri.parse("${baseUrl_v2}verfiysubscribe");

      var response = await http.get(url, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });

      print(url);
      print(response.body);
      if (httpStatusChecker(response)) {
        return SubscribedDataResponse.fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

}