import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../global/constants/app_modules.dart';
import 'package:dozen_diamond/global/constants/api_constants.dart';

import '../../authentication/services/authentication_rest_api_service.dart';
import '../../global/functions/http_api_helpers.dart';
import '../../global/models/http_api_exception.dart';
import '../constants/dummy_analysis_alpha_data.dart';
import '../models/actual_vs_computed_alpha_csv_request.dart';
import '../models/actual_vs_computed_alpha_csv_response.dart';
import '../models/actual_vs_computed_alpha_request.dart';
import '../models/actual_vs_computed_alpha_response.dart';
import '../models/alpha_gain_analysis_request.dart';
import '../models/alpha_gain_analysis_response.dart';
import '../models/alpha_gain_csv_request.dart';
import '../models/alpha_gain_csv_response.dart';

class AnalysisAlphaRestApiService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;

  Future<String> get _generateToken => authentication.generateToken();
  Future<int> get _getUserID => authentication.getUserID();

  Future<AlphaGainAnalysisResponse?> alphaGainAnalysis(
      AlphaGainAnalysisRequest stockData) async {
    try {
      var accessToken = await _generateToken;

      final userId = await _getUserID;
      var url = Uri.parse("$baseUrl$userId/stock/analytics/alpha-gain");

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
        return AlphaGainAnalysisResponse().fromJson(apiResponse);
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<ActualVscomputedAlphaResponse?> actualVsCalculatedAlpha(
      ActualVscomputedAlphaRequest stockData) async {
    try {
      var accessToken = await _generateToken;

      final userId = await _getUserID;
      var url = Uri.parse("$baseUrl$userId/stock/analytics/actual-vs-compute");

      var payload = jsonEncode(stockData.toJson());
      print(" body: $payload");
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
        return ActualVscomputedAlphaResponse().fromJson(apiResponse);
      } else {
        if (kDebugMode || kIsWeb) {
          return DummyAnalysisAlphaData().actualVscomputedAlphaDummy();
        } else {
          throw HttpApiException(errorCode: 404);
        }
      }
    } catch (e) {
      if (kDebugMode || kIsWeb) {
        return DummyAnalysisAlphaData().actualVscomputedAlphaDummy();
      } else {
        throw e;
      }
    }
  }

  Future<ActualVsComputedAlphaCsvResponse?> actualVsComputedAlphaCsv(
      ActualVsComputedAlphaCsvRequest stockData) async {
    try {
      var accessToken = await _generateToken;

      final userId = await _getUserID;
      var url = Uri.parse(
          "$baseUrl$userId/stock/analytics/actual-vs-compute/downloadcsv");

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
        return ActualVsComputedAlphaCsvResponse().fromJson(apiResponse);
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<AlphaGainCsvResponse?> alphaGainCsv(
      AlphaGainCsvRequest stockData) async {
    try {
      var accessToken = await _generateToken;

      final userId = await _getUserID;
      var url =
          Uri.parse("$baseUrl$userId/stock/analytics/alpha-gain/downloadcsv");

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
        return AlphaGainCsvResponse().fromJson(apiResponse);
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }
}
