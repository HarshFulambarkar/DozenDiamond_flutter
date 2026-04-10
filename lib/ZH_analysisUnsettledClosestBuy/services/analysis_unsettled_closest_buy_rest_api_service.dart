import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../global/constants/app_modules.dart';
import 'package:dozen_diamond/global/constants/api_constants.dart';

import '../../authentication/services/authentication_rest_api_service.dart';
import '../../global/constants/shared_preferences_manager.dart';
import '../../global/functions/http_api_helpers.dart';
import '../../global/models/http_api_exception.dart';
import '../constants/dummy_analysis_unsettled_closest_buy_data.dart';
import '../models/analysis_unsettle_closest_buy_response.dart';
import '../models/analytics_unsettled_closest_buy_table_request.dart';
import '../models/analytics_unsettled_closest_buy_table_response.dart';
import '../models/unsettled_closest_buy_csv_request.dart';
import '../models/unsettled_closest_buy_csv_response.dart';

class AnalysisUnsettledClosestBuyRestApiService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl_v2 = ApiConstant.baseUrl_v2;
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;

  Future<String> get _generateToken => authentication.generateToken();
  Future<int> get _getUserID => authentication.getUserID();

  Future<AnalyticsUnsettledClosestBuyTableResponse?>
      analyticsUnsettledClosestBuyTable(
          AnalyticsUnsettledClosestBuyTableRequest stockData,
          bool recentSorting) async {
    try {
      var accessToken = await _generateToken;

      final userId = await _getUserID;

      var url = Uri.parse(
          "$baseUrl$userId/stock/analytic/unsettled-buy?sort=closest");

      var payload = jsonEncode(stockData.toJson());
      var response = await http.post(
        url,
        body: payload,
        headers: {
          "Content-Type": "application/json",
          ApiConstant.authorizationHeaderKeyName: accessToken,
        },
      );

      if (httpStatusChecker(response)) {
        dynamic apiResponse = jsonDecode(response.body);
        return AnalyticsUnsettledClosestBuyTableResponse()
            .fromJson(apiResponse);
      } else {
        if (kDebugMode || kIsWeb) {
          return DummyAnalysisUnsettledClosestBuyData()
              .analyticsUnsettledClosestBuyTableDummy();
        } else {
          throw HttpApiException(errorCode: 404);
        }
      }
    } catch (e) {
      if (kDebugMode || kIsWeb) {
        return DummyAnalysisUnsettledClosestBuyData()
            .analyticsUnsettledClosestBuyTableDummy();
      } else {
        throw e;
      }
    }
  }

  Future<AnalysisUnsettleClosestBuyResponse>
  analyticsUnsettledClosestBuyTableNew(
      AnalyticsUnsettledClosestBuyTableRequest stockData,
      bool recentSorting) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await _getUserID;

      var url = Uri.parse(
          "$baseUrl_v2$userId/analytics/unsettled-closed-buys");

      var payload = jsonEncode(stockData.toJson());
      var response = await http.post(
        url,
        body: payload,
        headers: {
          "Content-Type": "application/json",
          // ApiConstant.authorizationHeaderKeyName: accessToken,
          ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
        },
      );

      if (httpStatusChecker(response)) {
        dynamic apiResponse = jsonDecode(response.body);
        return AnalysisUnsettleClosestBuyResponse
            .fromJson(apiResponse);
      } else {
        if (kDebugMode || kIsWeb) {
          // return AnalysisUnsettleClosestBuyResponse()
          //     .analyticsUnsettledClosestBuyTableDummy();
          throw HttpApiException(errorCode: 404);
        } else {
          throw HttpApiException(errorCode: 404);
        }
      }
    } catch (e) {
      if (kDebugMode || kIsWeb) {
        // return DummyAnalysisUnsettledClosestBuyData()
        //     .analyticsUnsettledClosestBuyTableDummy();
        throw e;
      } else {
        throw e;
      }
    }
  }

  Future<UnsettledClosestBuyCsvResponse> unsettledClosestBuysCsvRequest(
      UnsettledClosestBuyCsvRequest stockName) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await _getUserID;
      var payload = json.encode(stockName.toJson());
      var url = Uri.parse(
          "$baseUrl_v2$userId/analytics/unsettled-closed-buys/downloadCsv");
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });

      if (httpStatusChecker(response)) {
        return UnsettledClosestBuyCsvResponse()
            .fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }
}
