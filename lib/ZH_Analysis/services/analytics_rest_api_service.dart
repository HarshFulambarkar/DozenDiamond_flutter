import 'dart:convert';
import 'package:dozen_diamond/ZH_Analysis/models/price_vs_ladder_value_request.dart';
import 'package:dozen_diamond/ZH_Analysis/models/price_vs_ladder_value_response.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../ZH_analysisProfitVsPrice/models/csv_download_response.dart';
import '../../global/constants/app_modules.dart';
import 'package:dozen_diamond/global/constants/api_constants.dart';

import '../../authentication/services/authentication_rest_api_service.dart';
import '../../global/constants/shared_preferences_manager.dart';
import '../../global/functions/http_api_helpers.dart';
import '../../global/models/http_api_exception.dart';
import '../constants/dummy_analysis_data.dart';
import '../models/analysis_differential_selling_price_vs_open_order_price_response.dart';
import '../models/average_cost_vs_price_number_of_stocks_response.dart';
import '../models/graph_data_request.dart';
import '../models/trade_analytics_stocks_response.dart';

class AnalyticsRestApiService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl_v2 = ApiConstant.baseUrl_v2;
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;

  Future<String> get _generateToken => authentication.generateToken();
  Future<int> get _getUserID => authentication.getUserID();

  Future<TradeAnalyticsStocksResponse?> tradeAnalyticStockList(Map<String, dynamic>? requestBody) async {
    try {
      var _accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";
      if (_accessToken.isEmpty) {
        throw HttpApiException(errorCode: 404);
      } else {
        var payload = json.encode(requestBody);
        var userId = await _getUserID;
        var url = Uri.parse("$baseUrl_v2$userId/analytics");
        var response = await http.post(url, headers: {
        // var response = await http.get(url, headers: {
          "Content-Type": "application/json",
          // ApiConstant.authorizationHeaderKeyName: _accessToken
          ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
        },
          body: payload,
        );
        print("response body is here ${response.body}");
        if (httpStatusChecker(response)) {
          final apiResponse = json.decode(response.body);
          return TradeAnalyticsStocksResponse().fromJson(apiResponse);
        } else {
          if (kDebugMode || kIsWeb) {
            return DummyAnalysisData().tradeAnalyticStockListDummy();
          } else {
            throw HttpApiException(errorCode: 404);
          }
        }
      }
    } catch (e) {
      if (kDebugMode || kIsWeb) {
        return DummyAnalysisData().tradeAnalyticStockListDummy();
      } else {
        throw e;
      }
    }
  }


  Future<PriceVsLadderValueResponse?> analyticsPriceVsLadderValueGraph(
      PriceVsLadderValueRequest stockData) async {
    try {
      // var _accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      var userId = await _getUserID;
      var payload = json.encode(stockData.toJson());
      Uri url = Uri.parse(
          "$baseUrl_v2$userId/analytics/price-vs-laddersValue");
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: _accessToken
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });
      print("${response.body} here is the response hello $url");
      if (httpStatusChecker(response)) {
        var apiResponse = json.decode(response.body);
        return PriceVsLadderValueResponse().fromJson(apiResponse);
      } else {
        // if (kDebugMode || kIsWeb) {
        //   return DummyAnalysisProfitVsPriceData()
        //       .analyticsProfitVsPriceGraphDummy();
        // } else {
        //   throw HttpApiException(errorCode: 404);
        // }
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      // if (kDebugMode || kIsWeb) {
      //   return DummyAnalysisProfitVsPriceData()
      //       .analyticsProfitVsPriceGraphDummy();
      // } else {
      //   throw e;
      // }
      throw e;
    }
  }

  Future<AverageCostVsPriceNumberOfStocksResponse?> analyticsAverageCostVsPriceNumberOfStocksGraph(
      GraphDataRequest stockData) async {
    try {
      // var _accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      var userId = await _getUserID;
      var payload = json.encode(stockData.toJson());
      Uri url = Uri.parse(
          "$baseUrl_v2$userId/analytics/getAverageCostVsPrice");
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: _accessToken
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });
      print("${response.body} here is the response hello $url");
      if (httpStatusChecker(response)) {
        var apiResponse = json.decode(response.body);
        return AverageCostVsPriceNumberOfStocksResponse.fromJson(apiResponse);
      } else {
        // if (kDebugMode || kIsWeb) {
        //   return DummyAnalysisProfitVsPriceData()
        //       .analyticsProfitVsPriceGraphDummy();
        // } else {
        //   throw HttpApiException(errorCode: 404);
        // }
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      // if (kDebugMode || kIsWeb) {
      //   return DummyAnalysisProfitVsPriceData()
      //       .analyticsProfitVsPriceGraphDummy();
      // } else {
      //   throw e;
      // }
      throw e;
    }
  }

  Future<CsvDownloadResponse?> stockLaddersValueVsPriceAnalyticsCsv(
      stockData) async {
    print("inside stockLaddersValueVsPriceAnalyticsCsv");
    print(stockData);
    try {
      print("inside try");
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";
      print("below is token");
      // print(accessToken);

      final userId = await _getUserID;
      var url = Uri.parse(
          "$baseUrl_v2$userId/analytics/laddersValue-vs-price/downloadCsv");

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

  Future<CsvDownloadResponse?> stockAverageCostVsNumberOfStocksAnalyticsCsv(
      stockData) async {
    print("inside stockAverageCostVsNumberOfStocksAnalyticsCsv");
    print(stockData);
    try {
      print("inside try");
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";
      print("below is token");
      // print(accessToken);

      final userId = await _getUserID;
      var url = Uri.parse(
          "$baseUrl_v2$userId/analytics/averageCost-vs-numberOfStocks/downloadCsv");

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

  Future<CsvDownloadResponse?> stockAverageCostVsPriceAnalyticsCsv(
      stockData) async {
    print("inside stockAverageCostVsPriceAnalyticsCsv");
    print(stockData);
    try {
      print("inside try");
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";
      print("below is token");
      // print(accessToken);

      final userId = await _getUserID;
      var url = Uri.parse(
          "$baseUrl_v2$userId/analytics/averageCost-vs-price/downloadCsv");

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

  Future<AnalysisDifferentialSellingPriceVsOpenOrderPriceResponse?> analysisDifferentialSellingPriceVsOpenOrderPriceGraph(
      GraphDataRequest stockData) async {
    try {
      // var _accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      var userId = await _getUserID;
      var payload = json.encode(stockData.toJson());
      Uri url = Uri.parse(
          "$baseUrl_v2$userId/analytics/differentialSellingPrice-vs-openOrderPrice");
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: _accessToken
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });
      print("${response.body} here is the response hello $url");
      if (httpStatusChecker(response)) {
        var apiResponse = json.decode(response.body);
        return AnalysisDifferentialSellingPriceVsOpenOrderPriceResponse.fromJson(apiResponse);
      } else {
        // if (kDebugMode || kIsWeb) {
        //   return DummyAnalysisProfitVsPriceData()
        //       .analyticsProfitVsPriceGraphDummy();
        // } else {
        //   throw HttpApiException(errorCode: 404);
        // }
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      // if (kDebugMode || kIsWeb) {
      //   return DummyAnalysisProfitVsPriceData()
      //       .analyticsProfitVsPriceGraphDummy();
      // } else {
      //   throw e;
      // }
      throw e;
    }
  }

  Future<CsvDownloadResponse?> differentialSellingPriceVsOpenOrderPriceAnalyticsCsv(
      stockData) async {
    print("inside differentialSellingPriceVsOpenOrderPriceAnalyticsCsv");
    print(stockData);
    try {
      print("inside try");
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";
      print("below is token");
      // print(accessToken);

      final userId = await _getUserID;
      var url = Uri.parse(
          "$baseUrl_v2$userId/analytics/differentialSelling-vs-price/downloadCsv");

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
