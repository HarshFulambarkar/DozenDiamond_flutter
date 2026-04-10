import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../ZH_analysisProfitVsPrice/models/csv_download_response.dart';
import '../../global/constants/app_modules.dart';
import 'package:dozen_diamond/global/constants/api_constants.dart';

import '../../authentication/services/authentication_rest_api_service.dart';
import '../../global/constants/shared_preferences_manager.dart';
import '../../global/functions/http_api_helpers.dart';
import '../../global/models/http_api_exception.dart';
import '../models/alpha_vs_open_price_request.dart';
import '../models/analysis_alpha_vs_open_price_response.dart';

class AnalysisAlphaVsOpenPriceRestApiService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl_v2 = ApiConstant.baseUrl_v2;
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;

  Future<String> get _generateToken => authentication.generateToken();
  Future<int> get _getUserID => authentication.getUserID();


  Future<AnalysisAlphaVsOpenPriceResponse?> analyticsAlphaVsOpenPriceGraph(
      AlphaVsOpenPriceRequest stockData) async {
    try {
      // var _accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      var userId = await _getUserID;
      var payload = json.encode(stockData.toJson());
      Uri url = Uri.parse(
          "$baseUrl_v2$userId/analytics/price-vs-alpha");
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: _accessToken
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });
      print("${response.body} here is the response hello $url");
      if (httpStatusChecker(response)) {
        var apiResponse = json.decode(response.body);
        return AnalysisAlphaVsOpenPriceResponse.fromJson(apiResponse);
      } else {

        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {

      throw e;
    }
  }

  Future<CsvDownloadResponse?> alphaVsOpenPriceAnalyticsCsv(
      stockData) async {
    print("inside alphaVsOpenPriceAnalyticsCsv");
    print(stockData);
    try {
      print("inside try");
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";
      print("below is token");
      // print(accessToken);

      final userId = await _getUserID;
      var url = Uri.parse(
          "$baseUrl_v2$userId/analytics/alpha-vs-price/downloadCsv");

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
