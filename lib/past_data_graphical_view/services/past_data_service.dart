import 'dart:convert';

import 'package:dozen_diamond/AB_Ladder/constants/ladder_rest_api_service_dummy_data.dart';
import 'package:dozen_diamond/AB_Ladder/models/stock_historical_data_request.dart';
import 'package:dozen_diamond/AB_Ladder/models/stock_historical_data_response.dart';
import 'package:dozen_diamond/authentication/services/authentication_rest_api_service.dart';
import 'package:dozen_diamond/global/constants/api_constants.dart';
import 'package:dozen_diamond/global/constants/app_modules.dart';
import 'package:dozen_diamond/global/functions/http_api_helpers.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PastDataGraphicalViewService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl_v2 = ApiConstant.baseUrl_v2;
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;

  Future<String> get _generateToken => authentication.generateToken();
  Future<int> get _getUserID => authentication.getUserID();

  Future<StockHistoricalDataResponse?> getStockHistoricalData(
      StockHistoricalDataRequest stockData) async {
    try {
      var accessToken = await _generateToken;

      final userId = await _getUserID;

      var url = Uri.parse("$baseUrl_v2$userId/past-data");
      var payload = json.encode(stockData.toJson());
      print("payload: $payload");
      var response = await http.post(
        url,
        body: payload,
        headers: {
          "Content-Type": "application/json",
          ApiConstant.authorizationHeaderKeyName: accessToken,
        },
      );
      print("Heloooooooo");
      if (httpStatusChecker(response)) {
        print("here is the if of the return");
        return StockHistoricalDataResponse()
            .fromJson(jsonDecode(response.body));
      } else {
        print("in else part");
        if (kDebugMode || kIsWeb) {
          return LadderRestApiServiceDummyData()
              .loadLadderRestApiServiceDummyData(
                  stockName: stockData.symbolName!);
        } else {
          throw HttpApiException(errorCode: 404);
        }
      }
    } on HttpApiException catch (e) {
      print("Couldn't find the post 😱");

      return null;
    } catch (e) {
      if (kDebugMode || kIsWeb) {
        return LadderRestApiServiceDummyData()
            .loadLadderRestApiServiceDummyData(
                stockName: stockData.symbolName!);
      } else {
        throw e;
      }
    }
  }
}
