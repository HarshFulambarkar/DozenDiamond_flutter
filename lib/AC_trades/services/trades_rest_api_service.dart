import 'dart:convert';
import 'package:dozen_diamond/AC_trades/constants/trades_rest_api_dummy_data.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:dozen_diamond/global/functions/http_api_helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../global/constants/app_modules.dart';
import 'package:dozen_diamond/global/constants/api_constants.dart';

import '../../authentication/services/authentication_rest_api_service.dart';
import '../../global/constants/shared_preferences_manager.dart';
import '../../global/models/http_api_exception.dart';
import '../models/close_trade_request.dart';
import '../models/close_trade_response.dart';
import '../models/get_all_unsettled_trade_list_response.dart';
import '../models/reduce_trade_request.dart';
import '../models/reduce_trade_response.dart';
import '../models/replicate_trade_request.dart';
import '../models/replicate_trade_response.dart';
import '../models/total_position_trade_action_request.dart';
import '../models/total_position_trade_action_response.dart';
import '../models/user_trade_download_csv_response.dart';

class TradesRestApiService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;
  static const baseUrl_v2 = ApiConstant.baseUrl_v2;

  Future<String> get _generateToken => authentication.generateToken();
  Future<int> get _getUserID => authentication.getUserID();

  Future<GetAllUnsettledTradeListResponse?> getAllUnsettledTradeList(
      CurrencyConstants currencyConstantsProvider, Map<String, dynamic> request) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";
// {{baseurl}}/api/v1/user/{{id}}/unsettled-trades/fetch-all
      final userId = await _getUserID;
      var payload = json.encode(request);
      var url = Uri.parse("$baseUrl_v2$userId/unsettled-trades/fetch-all");
      // var response = await http.get(url, headers: {
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });

      if (httpStatusChecker(response)) {
        return GetAllUnsettledTradeListResponse()
            .fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      print("paneer1 $e");
      if (kDebugMode || kIsWeb) {
        return TradesRestApiServiceDummyData()
            .getUnsettledTradesDummyData(currencyConstantsProvider);
      } else {
        throw e;
      }
    }
  }

  Future<TotalPositionTradeActionResponse> totalPositionTradeAction(
      TotalPositionTradeActionRequest totalPositionTradeAction) async {
    try {
      var accessToken = await _generateToken;

      final userId = await _getUserID;
      var payload = json.encode(totalPositionTradeAction.toJson());
      var url = Uri.parse("$baseUrl$userId/trade/totalunit");
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });
      if (httpStatusChecker(response)) {
        return TotalPositionTradeActionResponse()
            .fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<CloseTradeResponse?> closeTradeById(
      CloseTradeRequest requestBody) async {
    try {
      var accessToken = await _generateToken;

      var userId = await _getUserID;
      var url = Uri.parse("$baseUrl$userId/trade/close-trade");
      var payload = json.encode(requestBody);
      var response = await http.post(
        url,
        body: payload,
        headers: {
          "Content-Type": "application/json",
          ApiConstant.authorizationHeaderKeyName: accessToken,
        },
      );

      if (httpStatusChecker(response)) {
        final apiResponse = json.decode(response.body);
        return CloseTradeResponse().fromJson(apiResponse);
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<ReduceTradeResponse> reduceTrade(
      ReduceTradeRequest reduceTradeRequest) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await _getUserID;
      var payload = json.encode(reduceTradeRequest.toJson());
      var url = Uri.parse("$baseUrl$userId/trade/reduce");
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });
      if (httpStatusChecker(response)) {
        return ReduceTradeResponse().fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<ReplicateTradeResponse> replicateTrade(
      ReplicateTradeRequest replicateTradeRequest) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await _getUserID;
      var payload = json.encode(replicateTradeRequest.toJson());
      var url = Uri.parse("$baseUrl$userId/trade/replicate");
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });
      if (httpStatusChecker(response)) {
        return ReplicateTradeResponse().fromJson(jsonDecode(response.body));
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
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await _getUserID;
      // var url = Uri.parse("$baseUrl$userId/activity/trading/downloadCsv");
      var url = Uri.parse("$baseUrl_v2$userId/trade/downloadCsv");
      var response = await http.get(url, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });
      if (httpStatusChecker(response)) {
        return UserTradeDownloadCsvResponse()
            .fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }
}
