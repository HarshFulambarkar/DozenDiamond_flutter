import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../global/constants/app_modules.dart';
import 'package:dozen_diamond/global/constants/api_constants.dart';

import '../../authentication/services/authentication_rest_api_service.dart';
import '../../global/functions/http_api_helpers.dart';
import '../../global/models/http_api_exception.dart';
import '../constants/dummy_analysis_trade_analytics_data.dart';
import '../models/all_trade_analytics_csv_request.dart';
import '../models/all_trade_analytics_csv_response.dart';
import '../models/all_trade_analytics_request.dart';
import '../models/all_trade_analytics_response.dart';

class AnalysisTradeAnalyticsRestApiService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;

  Future<String> get _generateToken => authentication.generateToken();
  Future<int> get _getUserID => authentication.getUserID();

  Future<AllTradeAnalyticsResponse> allTradeAnalyticsTable(
      AllTradeAnalyticsRequest stockData) async {
    try {
      var accessToken = await _generateToken;

      final userId = await _getUserID;
      var payload = json.encode(stockData.toJson());
      var url = Uri.parse("$baseUrl$userId/stock/analytic-table/allTradeList");
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });

      if (httpStatusChecker(response)) {
        return AllTradeAnalyticsResponse().fromJson(jsonDecode(response.body));
      } else {
        if (kDebugMode || kIsWeb) {
          return DummyAnalysisTradeAnalyticsData()
              .allTradeAnalyticsTableDummy();
        } else {
          throw HttpApiException(errorCode: 404);
        }
      }
    } catch (e) {
      if (kDebugMode || kIsWeb) {
        return DummyAnalysisTradeAnalyticsData().allTradeAnalyticsTableDummy();
      } else {
        throw e;
      }
    }
  }

  Future<AllTradeAnalyticsCsvResponse?> allTradeAnalyticsCsv(
      AllTradeAnalyticsCsvRequest stockData) async {
    try {
      var accessToken = await _generateToken;

      final userId = await _getUserID;
      var url = Uri.parse(
          "$baseUrl$userId/stock/analytic-table/allTradeList/downloadcsv");

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
        return AllTradeAnalyticsCsvResponse().fromJson(apiResponse);
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }
}
