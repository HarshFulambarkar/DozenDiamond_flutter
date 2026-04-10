import 'dart:convert';
import 'package:dozen_diamond/ZH_analysisPriceVsNumberOfStocks/models/analyticsRequest.dart';
import 'package:dozen_diamond/ZH_analysisPriceVsNumberOfStocks/models/closedOrderPriceAndUnits.dart';
import 'package:dozen_diamond/ZH_analysisPriceVsNumberOfStocks/models/priceVsValueVsNOSRequest.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../ZH_Analysis/models/csv_download_response.dart';
import '../../global/constants/app_modules.dart';
import 'package:dozen_diamond/global/constants/api_constants.dart';

import '../../authentication/services/authentication_rest_api_service.dart';
import '../../global/constants/shared_preferences_manager.dart';
import '../../global/functions/http_api_helpers.dart';
import '../../global/models/http_api_exception.dart';
import '../constants/dummy_analysis_price_vs_number_of_stocks_data.dart';
import '../models/ExtraCashVsPriceDataResponse.dart';

class PriceVsValueVsNoOfStocks {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl_v2 = ApiConstant.baseUrl_v2;
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;

  Future<String> get _generateToken => authentication.generateToken();
  Future<int> get _getUserID => authentication.getUserID();

  Future<ExtraCashVsPriceDataResponse> extraCashVsPriceOfStocks(
      AnalyticsRequest analyticsRequest) async {
    try {
      // var _accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";
      var userId = await _getUserID;
      var uri = Uri.parse("$baseUrl_v2$userId/analytics/extraCashVsPrice");
      var payload = json.encode(analyticsRequest.toJson());
      var response = await http.post(uri, body: payload, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: _accessToken
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });
      if (httpStatusChecker(response)) {
        var apiResponse = json.decode(response.body);
        return ExtraCashVsPriceDataResponse().fromJson(apiResponse);
      } else {
        return ExtraCashVsPriceDataResponse();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<ClosedOrderPriceAndUnitsResponse?> priceVsValueVsNumberOfStocks(
      PriceVsValueVsNoOfStocksRequest stockData) async {
    try {
      var _accessToken = await _generateToken;

      var userId = await _getUserID;
      var payload = json.encode(stockData.toJson());
      Uri url =
          Uri.parse("$baseUrl$userId/stock/analytics/price-vs-value-vs-units");
      print(payload);
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: _accessToken
      });
      print("below is priceVsValueVsNumberOfStocks");
      print(url);
      print(payload);
      print(response.body);
      if (httpStatusChecker(response)) {
        var apiResponse = json.decode(response.body);
        return ClosedOrderPriceAndUnitsResponse().fromJson(apiResponse);
      } else {
        if (kDebugMode || kIsWeb) {
          return DummyAnalysisPriceVsNumberOfStocksData()
              .priceVsValueVsNumberOfStocksDummy();
        } else {
          throw HttpApiException(errorCode: 404);
        }
      }
    } catch (e) {
      if (kDebugMode || kIsWeb) {
        return DummyAnalysisPriceVsNumberOfStocksData()
            .priceVsValueVsNumberOfStocksDummy();
      } else {
        throw e;
      }
    }
  }

// Future<AverageCostVsPriceResponse?> aver

//   Future<ProfitVsPriceAnalyticsCsvResponse?> profitVsPriceAnalyticsCsv(
//       ProfitVsPriceAnalyticsCsvRequest stockData) async {
//     try {
//       var accessToken = await _generateToken;

//       final userId = await _getUserID;
//       var url = Uri.parse(
//           "$baseUrl$userId/stock/analytics/profit-vs-price/downloadCsv");

//       var payload = jsonEncode(stockData.toJson());

//       var response = await http.post(
//         url,
//         body: payload,
//         headers: {
//           "Content-Type": "application/json",
//           ApiConstant.authorizationHeaderKeyName: accessToken,
//         },
//       );

//       if (httpStatusChecker(response)) {
//         dynamic apiResponse = jsonDecode(response.body);

//         return ProfitVsPriceAnalyticsCsvResponse().fromJson(apiResponse);
//       } else {
//         throw HttpApiException(errorCode: 404);
//       }
//     } catch (e) {
//       throw HttpApiException(errorCode: 404);
//     }
//   }

  Future<CsvDownloadResponse?> stockExtraCashVsPriceAnalyticsCsv(
      stockData) async {
    print("inside stockExtraCashVsPriceAnalyticsCsv");
    print(stockData);
    try {
      print("inside try");
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";
      print("below is token");
      // print(accessToken);

      final userId = await _getUserID;
      var url = Uri.parse(
          "$baseUrl_v2$userId/analytics/extraCash-vs-price/downloadCsv");

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
