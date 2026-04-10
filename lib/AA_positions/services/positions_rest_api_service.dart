import 'dart:convert';
import 'package:dozen_diamond/AA_positions/constants/position_rest_api_service_dummy_data.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:dozen_diamond/global/functions/http_api_helpers.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../global/constants/app_modules.dart';
import 'package:dozen_diamond/global/constants/api_constants.dart';

import '../../authentication/services/authentication_rest_api_service.dart';
import '../../global/constants/shared_preferences_manager.dart';
import '../models/close_position_request.dart';
import '../models/close_position_response.dart';
import '../models/get_all_open_position_response.dart';
import '../models/user_position_download_csv_response.dart';

class PositionRestApiService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;
  static const baseUrl_v2 = ApiConstant.baseUrl_v2;

  Future<String> get _generateToken => authentication.generateToken();
  Future<int> get _getUserID => authentication.getUserID();

  Future<GetAllOpenPositionsResponse?> getAllOpenPositions(
      CurrencyConstants currencyConstantsProvider) async {
    try {
      // var accessToken = await authentication.generateToken();
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await authentication.getUserID();
      Uri url = Uri.parse("$baseUrl_v2$userId/open-positions/fetch-all");
      var response = await http.get(url, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      }).timeout(
        ApiConstant.timeoutDuration,
        onTimeout: () {
          throw HttpApiException(
            errorCode: 408,
          );
        },
      );

      if (httpStatusChecker(response)) {
        return GetAllOpenPositionsResponse()
            .fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      if (kDebugMode || kIsWeb) {
        return PositionRestApiServiceDummyData()
            .getOpenPositionsDummyData(currencyConstantsProvider);
      } else {
        throw e;
      }
    }
  }

  Future<ClosePositionResponse> closePosition(
      ClosePositionRequest closePositon) async {
    try {
      // var accessToken = await authentication.generateToken();
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await authentication.getUserID();
      var payload = json.encode(closePositon.toJson());
      var url = Uri.parse("$baseUrl_v2$userId/position/close");
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      }).timeout(
        ApiConstant.timeoutDuration,
        onTimeout: () {
          throw HttpApiException(
            errorCode: 408,
          );
        },
      );

      print("below is data of position close api");
      print(url);
      print(payload);
      print(response.body);
      if (httpStatusChecker(response)) {
        return ClosePositionResponse().fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<UserPositionDownloadCsvResponse?> userPositonDownloadCsv() async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await _getUserID;
      // var url = Uri.parse("$baseUrl$userId/position/downloadCsv");
      var url = Uri.parse("$baseUrl_v2$userId/position/downloadCsv");
      var response = await http.get(url, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      }).timeout(
        ApiConstant.timeoutDuration,
        onTimeout: () {
          throw HttpApiException(
            errorCode: 408,
          );
        },
      );

      if (httpStatusChecker(response)) {
        return UserPositionDownloadCsvResponse()
            .fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }
}
