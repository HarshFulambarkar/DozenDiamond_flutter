import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../global/constants/app_modules.dart';
import 'package:dozen_diamond/global/constants/api_constants.dart';

import '../../authentication/services/authentication_rest_api_service.dart';
import '../../global/constants/shared_preferences_manager.dart';
import '../../global/functions/http_api_helpers.dart';
import '../../global/models/http_api_exception.dart';
import '../constants/dummy_analysis_profit_vs_price_data.dart';
import '../models/analytics_profit_vs_price_graph_request.dart';
import '../models/analytics_profit_vs_price_graph_response.dart';
import '../models/csv_download_response.dart';
import '../models/profit_vs_price_analytics_csv_request.dart';
import '../models/profit_vs_price_analytics_csv_response.dart';

class AnalysisProfitVsPriceRestApiService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl_v2 = ApiConstant.baseUrl_v2;
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;

  Future<String> get _generateToken => authentication.generateToken();
  Future<int> get _getUserID => authentication.getUserID();

  Future<AnalyticsProfitVsPriceGraphResponse?> analyticsProfitVsPriceGraph(
      AnalyticsProfitVsPriceGraphRequest stockData) async {
    try {
      // var _accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      var userId = await _getUserID;
      var payload = json.encode(stockData.toJson());
      Uri url = Uri.parse(
          "$baseUrl_v2$userId/analytics/profitVsPrice");
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: _accessToken
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });
      print("${response.body} here is the response hello $url");
      if (httpStatusChecker(response)) {
        var apiResponse = json.decode(response.body);
        return AnalyticsProfitVsPriceGraphResponse().fromJson(apiResponse);
      } else {
        if (kDebugMode || kIsWeb) {
          return DummyAnalysisProfitVsPriceData()
              .analyticsProfitVsPriceGraphDummy();
        } else {
          throw HttpApiException(errorCode: 404);
        }
      }
    } catch (e) {
      if (kDebugMode || kIsWeb) {
        return DummyAnalysisProfitVsPriceData()
            .analyticsProfitVsPriceGraphDummy();
      } else {
        throw e;
      }
    }
  }

  Future<ProfitVsPriceAnalyticsCsvResponse?> profitVsPriceAnalyticsCsv(
      String graphType, stockData) async {
    print("inside profitVsPriceAnalyticsCsv");
    print(stockData);
    try {
      print("inside try");
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";
      print("below is token");
      // print(accessToken);

      final userId = await _getUserID;

      var url = Uri.parse(
        // "$baseUrl_v2$userId/analytics/profit-vs-price/downloadCsv");
          "$baseUrl_v2$userId/analytics/NoOfStock-vs-price/downloadCsv");
      if(graphType == "Number of stocks vs Open Order Price") {
        url = Uri.parse(
          // "$baseUrl_v2$userId/analytics/profit-vs-price/downloadCsv");
            "$baseUrl_v2$userId/analytics/NoOfStock-vs-price/downloadCsv");
      } else {
        url = Uri.parse(
          "$baseUrl_v2$userId/analytics/profit-vs-price/downloadCsv");
            // "$baseUrl_v2$userId/analytics/NoOfStock-vs-price/downloadCsv");
      }


      var payload = jsonEncode(stockData);

      print("below is payload");
      print(payload);

      var response = await http.post(
        url,
        body: payload,
        headers: {
          "Content-Type": "application/json",
          // ApiConstant.authorizationHeaderKeyName: accessToken,
          ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
        },
      );

      print("below is response");
      print(response);

      if (httpStatusChecker(response)) {
        dynamic apiResponse = jsonDecode(response.body);

        return ProfitVsPriceAnalyticsCsvResponse().fromJson(apiResponse);
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw HttpApiException(errorCode: 404);
    }
  }

  Future<CsvDownloadResponse?> stockValueVsPriceAnalyticsCsv(
      stockData) async {
    print("inside stockValueVsPriceAnalyticsCsv");
    print(stockData);
    try {
      print("inside try");
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";
      print("below is token");
      // print(accessToken);

      final userId = await _getUserID;
      var url = Uri.parse(
          "$baseUrl_v2$userId/analytics/stockValue-vs-price/downloadCsv");

      var payload = jsonEncode(stockData);

      print("below is payload");
      print(payload);

      var response = await http.post(
        url,
        body: payload,
        headers: {
          "Content-Type": "application/json",
          // ApiConstant.authorizationHeaderKeyName: accessToken,
          ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
        },
      );

      print("below is response");
      print(response);

      if (httpStatusChecker(response)) {
        dynamic apiResponse = jsonDecode(response.body);

        return CsvDownloadResponse().fromJson(apiResponse);
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw HttpApiException(errorCode: 404);
    }
  }

  Future<CsvDownloadResponse?> stockValueVsNumberOfStockAnalyticsCsv(
      stockData) async {
    print("inside stockValueVsNumberOfStockAnalyticsCsv");
    print(stockData);
    try {
      print("inside try");
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";
      print("below is token");
      // print(accessToken);

      final userId = await _getUserID;
      var url = Uri.parse(
          "$baseUrl_v2$userId/analytics/numberOfStocks-vs-stockValue/downloadCsv");

      var payload = jsonEncode(stockData);

      print("below is payload");
      print(payload);

      var response = await http.post(
        url,
        body: payload,
        headers: {
          "Content-Type": "application/json",
          // ApiConstant.authorizationHeaderKeyName: accessToken,
          ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
        },
      );

      print("below is response");
      print(response);

      if (httpStatusChecker(response)) {
        dynamic apiResponse = jsonDecode(response.body);

        return CsvDownloadResponse().fromJson(apiResponse);
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw HttpApiException(errorCode: 404);
    }
  }
}
