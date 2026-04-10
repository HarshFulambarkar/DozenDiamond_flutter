import 'dart:convert';
import 'package:dozen_diamond/AD_Orders/constants/order_rest_api_services_dummy_data.dart';
import 'package:dozen_diamond/AD_Orders/models/cancel_order_response.dart';
import 'package:dozen_diamond/AD_Orders/models/get_all_open_order_list_response.dart';
import 'package:dozen_diamond/AD_Orders/models/partial_order_generation_request.dart';
import 'package:dozen_diamond/AD_Orders/models/partial_order_generation_response.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:dozen_diamond/global/functions/http_api_helpers.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../global/constants/app_modules.dart';
import 'package:dozen_diamond/global/constants/api_constants.dart';

import '../../authentication/services/authentication_rest_api_service.dart';
import '../../global/constants/shared_preferences_manager.dart';
import '../models/close_order_request.dart';
import '../models/close_order_response.dart';
import '../models/user_order_download_csv_response.dart';

class OrdersRestApiService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl_v2 = ApiConstant.baseUrl_v2;
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;

  Future<String> get _generateToken => authentication.generateToken();
  Future<int> get _getUserID => authentication.getUserID();

  Future<GetAllOpenOrderListResponse?> getAllStockOrderList(
      CurrencyConstants currencyConstantsProvider) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await _getUserID;
      var url = Uri.parse("$baseUrl_v2$userId/order/fetch-all");
      var response = await http.get(url, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });
      if (httpStatusChecker(response)) {
        return GetAllOpenOrderListResponse()
            .fromJson(jsonDecode(response.body));
      } else {
        throw Exception(appModule.dataStrings.genericError);
      }
    } catch (e) {
      if (kDebugMode || kIsWeb) {
        return OrderRestApiServiceDummyData()
            .getOpenOrdersDummyData(currencyConstantsProvider);
      } else {
        throw e;
      }
    }
  }

  Future<GetAllOpenOrderListResponse?> getAllStockHiddenOrderList(
      CurrencyConstants currencyConstantsProvider) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await _getUserID;
      var url = Uri.parse("$baseUrl_v2$userId/cashHolding-order/fetch-all?isSuper=true");
      var response = await http.get(url, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });
      if (httpStatusChecker(response)) {
        return GetAllOpenOrderListResponse()
            .fromJson(jsonDecode(response.body));
      } else {
        throw Exception(appModule.dataStrings.genericError);
      }
    } catch (e) {
      if (kDebugMode || kIsWeb) {
        return OrderRestApiServiceDummyData()
            .getOpenOrdersDummyData(currencyConstantsProvider);
      } else {
        throw e;
      }
    }
  }

  Future<CloseOrderResponse> closeOrder(CloseOrderRequest closeOrder) async {
    try {
      var accessToken = await _generateToken;

      final userId = await _getUserID;
      var payload = json.encode(closeOrder.toJson());
      var url = Uri.parse("$baseUrl$userId/ladder/openorder/close");
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });
      if (httpStatusChecker(response)) {
        return CloseOrderResponse().fromJson(jsonDecode(response.body));
      } else {
        throw Exception(appModule.dataStrings.genericError);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<UserOrderDownloadCsvResponse?> userOrderDownloadCsv() async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await _getUserID;
      // var url = Uri.parse("$baseUrl$userId/ladder/openorder/downloadCsv");
      var url = Uri.parse("$baseUrl_v2$userId/order/downloadCsv");
      var response = await http.get(url, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });

      if (httpStatusChecker(response)) {
        return UserOrderDownloadCsvResponse()
            .fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<PartialOrderGenerationResponse> partialOrderGeneration(
      Map<String, dynamic>? requestBody) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await _getUserID;
      // var payload = json.encode(partialOrderGenerationRequest.toJson());
      var payload = json.encode(requestBody);
      print(payload);
      // var url = Uri.parse("$baseUrl_v2$userId/ladder/openorder/partial-order");
      var url = Uri.parse("$baseUrl_v2$userId/order/partial-order");
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });
      print(response.body);
      if (httpStatusChecker(response)) {
        return PartialOrderGenerationResponse()
            .fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<CancelOrderResponse> cancelOrder(
      Map<String, dynamic>? requestBody) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await _getUserID;
      // var payload = json.encode(partialOrderGenerationRequest.toJson());
      var payload = json.encode(requestBody);
      print(payload);
      // var url = Uri.parse("$baseUrl_v2$userId/ladder/openorder/partial-order");
      var url = Uri.parse("$baseUrl_v2$userId/order/cancelOpenOrder");
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });
      print(response.body);
      if (httpStatusChecker(response)) {
        return CancelOrderResponse
            .fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }
}
