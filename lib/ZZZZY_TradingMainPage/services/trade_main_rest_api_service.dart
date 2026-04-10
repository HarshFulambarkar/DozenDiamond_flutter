import 'dart:convert';
import 'package:dozen_diamond/AB_Ladder/models/toggle_laddder_activation_status_response.dart';
import 'package:dozen_diamond/ZZZZY_TradingMainPage/models/get_trade_menu_button_visibility_response.dart';
import 'package:dozen_diamond/ZZZZY_TradingMainPage/models/inactive_all_ladder_response.dart';
import 'package:dozen_diamond/ZZZZY_TradingMainPage/models/is_any_ladder_active_response.dart';
import 'package:dozen_diamond/global/functions/http_api_helpers.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';

import '../../global/constants/app_modules.dart';
import '../../authentication/services/authentication_rest_api_service.dart';
import '../../global/constants/api_constants.dart';
import 'package:http/http.dart' as http;

import '../../global/constants/shared_preferences_manager.dart';
import '../models/activate_all_ladder_response.dart';
import '../models/active_ladder_simulation_tickers_response.dart';
import '../models/activity_csv_response.dart';
import '../models/get_current_trading_status_response.dart';
import '../models/start_stop_smart_api_websocket_response.dart';
import '../models/start_trading_request.dart';
import '../models/start_trading_response.dart';
import '../models/toggle_all_ladder_activation_status_request.dart';

class TradeMainRestApiService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;
  static const baseUrl_v2 = ApiConstant.baseUrl_v2;

  Future<String> get _generateToken => authentication.generateToken();
  Future<int> get _getUserID => authentication.getUserID();

  Future<ActiveLadderSimulationTickersResponse?>
      fetchActiveLaddersimulationTickers() async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";
      final userId = await _getUserID;
      var url = Uri.parse("$baseUrl_v2$userId/active-simulator-tickers/fetch");

      var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          // ApiConstant.authorizationHeaderKeyName: accessToken,
          ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
        },
      );

      if (httpStatusChecker(response)) {
        dynamic apiResponse = jsonDecode(response.body);
        return ActiveLadderSimulationTickersResponse().fromJson(apiResponse);
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<GetCurrentTradingStatusResponse?> getTradingStatus() async {
    try {
      var accessToken = await _generateToken;

      final userId = await _getUserID;
      var url = Uri.parse("$baseUrl$userId/activity/status");
      var response = await http.get(url, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });
      if (httpStatusChecker(response)) {
        return GetCurrentTradingStatusResponse()
            .fromJson(json.decode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<ActivateAllLadderResponse?> activateAllLadder() async {
    try {
      var accessToken = await _generateToken;

      final userId = await _getUserID;
      var url = Uri.parse("$baseUrl2$userId/ladders/activate-all");

      var response = await http.put(url, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });
      if (httpStatusChecker(response)) {
        return ActivateAllLadderResponse().fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<ActivityCsvResponse?> activityDownloadCsv() async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await _getUserID;
      // var url = Uri.parse("$baseUrl$userId/activity/csv");
      var url = Uri.parse("$baseUrl_v2$userId/activity/downloadActivityCsv");
      var response = await http.get(url, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });
      if (httpStatusChecker(response)) {
        return ActivityCsvResponse().fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<StartTradingResponse?> startTrading(
      StartTradingRequest startTradingRequest) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";
      final userId = await _getUserID;
      var payload = json.encode(startTradingRequest.toJson());
      var url = Uri.parse("$baseUrl_v2$userId/ladder/start-stop-trading");
      var response = await http.patch(url, body: payload, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });
      if (httpStatusChecker(response)) {
        return StartTradingResponse().fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<StartStopSmartApiWebsocketResponse> startStopSmartApiWebsocket(
      Map<String, dynamic>? requestBody) async {

    try {
      var accessToken = await _generateToken;

      final userId = await _getUserID;
      var url = Uri.parse("$baseUrl_v2$userId/smart-api/websocket");
      // var url = Uri.parse("$tempbaseUrl_v2$userId/smcTradeCustomerToken");
      var payload = json.encode(requestBody);
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });

      print(url);
      print(payload);
      print(response.body);
      if (httpStatusChecker(response)) {
        return StartStopSmartApiWebsocketResponse.fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<IsAnyLadderActiveResponse?> isAnyLadderActive() async {
    try {
      var accessToken = await _generateToken;

      var userId = await _getUserID;
      var url = Uri.parse('$baseUrl2$userId/ladders/is-any-ladder-active');
      var response = await http.get(url, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });

      if (httpStatusChecker(response)) {
        return IsAnyLadderActiveResponse().fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<InActiveAllLadderResponse> deactiveAllLadder() async {
    try {
      var accessToken = await _generateToken;

      var userId = await _getUserID;
      var url = Uri.parse('$baseUrl2$userId/ladders/inactive-all');
      var response = await http.put(url, headers: {
        "content-type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken
      });
      if (httpStatusChecker(response)) {
        return InActiveAllLadderResponse().fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<ToggleLadderActivationStatusResponse> allLadderToggleActivationStatus(
      ToggleAllLadderActivationStatusRequest requestBody) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      var userId = await _getUserID;
      var url = Uri.parse(
          '$baseUrl_v2$userId/ladder-implementation/update-status/all-ladders');
      var response = await http.patch(
        url,
        headers: {
          "content-type": "application/json",
          // ApiConstant.authorizationHeaderKeyName: accessToken
          ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
        },
        body: json.encode(requestBody.toJson()),
      );
      if (httpStatusChecker(response)) {
        return ToggleLadderActivationStatusResponse()
            .fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<GetTradeMenuButtonVisibilityResponse>
      getTradeMenuButtonVisibility() async {
    try {
      var accessToken = await _generateToken;

      final userId = await _getUserID;
      var url = Uri.parse('$baseUrl$userId/check-csv-status');
      var response = await http.get(url, headers: {
        "content-type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });
      if (httpStatusChecker(response)) {
        return GetTradeMenuButtonVisibilityResponse()
            .fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }
}
