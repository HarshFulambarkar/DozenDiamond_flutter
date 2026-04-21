import 'dart:convert';

import 'package:dozen_diamond/AA_positions/models/user_position_download_csv_response.dart';
import 'package:dozen_diamond/AB_Ladder/models/user_ladder_download_csv_response.dart';
import 'package:dozen_diamond/AC_trades/models/user_trade_download_csv_response.dart';
import 'package:dozen_diamond/AD_Orders/models/user_order_download_csv_response.dart';
import 'package:dozen_diamond/authentication/services/authentication_rest_api_service.dart';
import 'package:dozen_diamond/global/constants/api_constants.dart';
import 'package:dozen_diamond/global/constants/shared_preferences_manager.dart';
import 'package:dozen_diamond/global/functions/http_api_helpers.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DownloadRestApiService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  static const baseUrl_v2 = ApiConstant.baseUrl_v2;
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;

  Future<String> get _generateToken => authentication.generateToken();
  Future<int> get _getUserID => authentication.getUserID();

  Future<UserPositionDownloadCsvResponse?> userPositonDownloadCsv() async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken =
          (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await _getUserID;
      // var url = Uri.parse("$baseUrl$userId/position/downloadCsv");
      var url = Uri.parse("$baseUrl_v2$userId/position/downloadCsv");
      var response = await http
          .get(
            url,
            headers: {
              "Content-Type": "application/json",
              // ApiConstant.authorizationHeaderKeyName: accessToken,
              ApiConstant.authorizationHeaderKeyName:
                  "${ApiConstant.bearer} $userAccessToken",
            },
          )
          .timeout(
            ApiConstant.timeoutDuration,
            onTimeout: () {
              throw HttpApiException(errorCode: 408);
            },
          );

      if (httpStatusChecker(response)) {
        return UserPositionDownloadCsvResponse().fromJson(
          jsonDecode(response.body),
        );
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<UserOrderDownloadCsvResponse?> userOrderDownloadCsv() async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken =
          (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await _getUserID;
      // var url = Uri.parse("$baseUrl$userId/ladder/openorder/downloadCsv");
      var url = Uri.parse("$baseUrl_v2$userId/order/downloadCsv");
      var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          // ApiConstant.authorizationHeaderKeyName: accessToken,
          ApiConstant.authorizationHeaderKeyName:
              "${ApiConstant.bearer} $userAccessToken",
        },
      );

      if (httpStatusChecker(response)) {
        return UserOrderDownloadCsvResponse().fromJson(
          jsonDecode(response.body),
        );
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<UserLadderDownloadCsvResponse?> userLadderDownloadCsv() async {
    try {
      // var accessToken = await _generateToken;

      final userId = await _getUserID;
      String userAccessToken =
          (await SharedPreferenceManager.getUserAccessToken()) ?? "";
      // var url = Uri.parse("$baseUrl2$userId/ladder/csv");
      var url = Uri.parse("$baseUrl_v2$userId/ladder/downloadCsv");
      var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          // ApiConstant.authorizationHeaderKeyName: accessToken,
          ApiConstant.authorizationHeaderKeyName:
              "${ApiConstant.bearer} $userAccessToken",
        },
      );

      if (httpStatusChecker(response)) {
        return UserLadderDownloadCsvResponse().fromJson(
          jsonDecode(response.body),
        );
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<bool> userLadderExecutedOrderDownloadCsv(data) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken =
          (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await _getUserID;
      // var url = Uri.parse("$baseUrl2$userId/ladder/csv");
      var url = Uri.parse("$baseUrl_v2$userId/order/downloadExecutedOrderCsv");

      var payload = jsonEncode(data);
      var response = await http.post(
        url,
        body: payload,
        headers: {
          "Content-Type": "application/json",
          // ApiConstant.authorizationHeaderKeyName: accessToken,
          ApiConstant.authorizationHeaderKeyName:
              "${ApiConstant.bearer} $userAccessToken",
        },
      );

      if (httpStatusChecker(response)) {
        return true;
        // return UserLadderDownloadCsvResponse()
        //     .fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<bool> userLadderAllOrderDownloadCsv(data) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken =
          (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await _getUserID;
      // var url = Uri.parse("$baseUrl2$userId/ladder/csv");
      var url = Uri.parse("$baseUrl_v2$userId/order/downloadAllOrderCsv");

      var payload = jsonEncode(data);
      var response = await http.post(
        url,
        body: payload,
        headers: {
          "Content-Type": "application/json",
          // ApiConstant.authorizationHeaderKeyName: accessToken,
          ApiConstant.authorizationHeaderKeyName:
              "${ApiConstant.bearer} $userAccessToken",
        },
      );

      if (httpStatusChecker(response)) {
        return true;
        // return UserLadderDownloadCsvResponse()
        //     .fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<UserTradeDownloadCsvResponse?> userTradeDownloadCsv() async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken =
          (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await _getUserID;
      // var url = Uri.parse("$baseUrl$userId/activity/trading/downloadCsv");
      var url = Uri.parse("$baseUrl_v2$userId/trade/downloadCsv");
      var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          // ApiConstant.authorizationHeaderKeyName: accessToken,
          ApiConstant.authorizationHeaderKeyName:
              "${ApiConstant.bearer} $userAccessToken",
        },
      );
      if (httpStatusChecker(response)) {
        return UserTradeDownloadCsvResponse().fromJson(
          jsonDecode(response.body),
        );
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }
}
