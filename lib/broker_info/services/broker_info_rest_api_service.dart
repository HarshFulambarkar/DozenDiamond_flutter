import 'dart:convert';

import 'package:dozen_diamond/authentication/services/authentication_rest_api_service.dart';
import 'package:dozen_diamond/broker_info/models/get_holdings_response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../global/constants/api_constants.dart';
import '../../global/constants/app_modules.dart';
import '../../global/functions/http_api_helpers.dart';
import '../../global/models/http_api_exception.dart';
import '../models/get_all_holdings_response.dart';
import '../models/get_customer_funds_and_margins_response.dart';
import '../models/get_customer_profile_response.dart';

class BrokerInfoRestApiService {

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

  Future<GetHoldingsResponse?> getHoldings() async {
    try {
      var accessToken = await _generateToken;

      final userId = await _getUserID;
      var url = Uri.parse("$baseUrl_v2$userId/angelOneCustomerPortfolioGetHoldings");
      // var payload = json.encode(createLadderRequest.toJson());
      var response = await http.get(
        url,
        // body: payload,
        headers: {
          "Content-Type": "application/json",
          ApiConstant.authorizationHeaderKeyName: accessToken,
        },
      );

      print("after getting angelOneCustomerPortfolioGetHoldings");
      print(url);
      print(response.body);

      if (httpStatusChecker(response)) {
        return GetHoldingsResponse.fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      print("error in the rest api $e");
      throw HttpApiException(errorCode: 404);
    }
  }

  Future<GetAllHoldingsResponse?> getAllHoldings() async {
    try {
      var accessToken = await _generateToken;

      final userId = await _getUserID;
      var url = Uri.parse("$baseUrl_v2$userId/angelOneCustomerPortfolioGetAllHoldings");
      // var payload = json.encode(createLadderRequest.toJson());
      var response = await http.get(
        url,
        // body: payload,
        headers: {
          "Content-Type": "application/json",
          ApiConstant.authorizationHeaderKeyName: accessToken,
        },
      );

      print("after getting angelOneCustomerPortfolioGetAllHoldings");
      print(url);
      print(response.body);

      if (httpStatusChecker(response)) {
        return GetAllHoldingsResponse.fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      print("error in the rest api $e");
      throw HttpApiException(errorCode: 404);
    }
  }

  Future<GetCustomerFundsAndMarginsResponse?> getCustomerFundsAndMargins() async {
    try {
      var accessToken = await _generateToken;

      final userId = await _getUserID;
      var url = Uri.parse("$baseUrl_v2$userId/angelOneCustomerFundsAndMargins");
      // var payload = json.encode(createLadderRequest.toJson());
      var response = await http.get(
        url,
        // body: payload,
        headers: {
          "Content-Type": "application/json",
          ApiConstant.authorizationHeaderKeyName: accessToken,
        },
      );

      print("after getting angelOneCustomerFundsAndMargins");
      print(url);
      print(response.body);

      if (httpStatusChecker(response)) {
        return GetCustomerFundsAndMarginsResponse.fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      print("error in the rest api $e");
    }
  }

  Future<GetCustomerProfileResponse?> getCustomerProfile() async {
    try {
      var accessToken = await _generateToken;

      final userId = await _getUserID;
      var url = Uri.parse("$baseUrl_v2$userId/angelOneCustomerProfile");
      // var payload = json.encode(createLadderRequest.toJson());
      var response = await http.get(
        url,
        // body: payload,
        headers: {
          "Content-Type": "application/json",
          ApiConstant.authorizationHeaderKeyName: accessToken,
        },
      );

      print("after getting angelOneCustomerProfile");
      print(url);
      print(response.body);

      if (httpStatusChecker(response)) {
        return GetCustomerProfileResponse.fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      print("error in the rest api $e");
    }
  }
}