import 'dart:convert';
import 'dart:developer';

import 'package:dozen_diamond/create_ladder_detailed/constants/dummy_user_stock_and_ladder_data.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../F_Funds/models/get_user_account_details_respone_addFunds.dart';
import '../../authentication/services/authentication_rest_api_service.dart';
import '../../create_ladder_detailed/constants/http_api_constant.dart';
import '../../create_ladder_detailed/constants/message_constant.dart';
import '../../global/constants/api_constants.dart';
import '../../global/constants/app_modules.dart';
import '../../global/constants/shared_preferences_manager.dart';
import '../../global/functions/http_api_helpers.dart';
import '../../global/models/http_api_exception.dart';
import '../models/copy_ladder_request.dart';
import '../models/copy_ladder_response.dart';
import '../models/ladder_creation_parameter_values.dart';
import '../models/ladder_creation_parameter_values_request.dart';
import '../models/ladder_creation_stock_list.dart';
import '../models/ladder_creation_stock_list_with_parameters.dart';
import '../models/ladder_creation_tickers_response.dart';
import '../models/ladder_details_request.dart';
import '../models/ladder_details_response.dart';
import '../models/reset_creation_stock_list.dart';

class RestApiService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl_v1 = ApiConstant.baseUrl_v2;
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;

  Future<String> get _generateToken => authentication.generateToken();
  MessageConstant constMessage = MessageConstant();

  Future<int> getUserID() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getInt("reg_id") ?? 730;
    return userId;
  }

  Future<LadderCreationStockListWithParameters?>
      getUserStockAndLadderWithParameters() async {
    try {
      var accessToken = await _generateToken;

      final userId = await getUserID();
      var url = Uri.parse("$baseUrl$userId/get-ladder-creation-stock-list");
      var response = await http.get(url, headers: {
        "Content-Type": "application/json",
        HttpApiConstant.authorizationHeaderKeyName: accessToken,
      });
      if (httpStatusChecker(response)) {
        return LadderCreationStockListWithParameters()
            .fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<LadderCreationStockList?> deleteUserStockFromCreationStockList(
      int? userClpID) async {
    try {
      var accessToken = await _generateToken;

      final userId = await getUserID();
      var url = Uri.parse("$baseUrl$userId/ladder-creation-parameter/delete");
      var payload = json.encode({"clp_id": userClpID});
      var response = await http.delete(url, body: payload, headers: {
        "Content-Type": "application/json",
        HttpApiConstant.authorizationHeaderKeyName: accessToken,
      });
      if (httpStatusChecker(response)) {
        return LadderCreationStockList().fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<ResetCreationStockList> resetCreationStockList() async {
    try {
      var accessToken = await _generateToken;

      final userId = await getUserID();
      var url = Uri.parse("$baseUrl$userId/ladder-creation-all-stock/reset");
      var response = await http.put(url, headers: {
        "Content-Type": "application/json",
        HttpApiConstant.authorizationHeaderKeyName: accessToken,
      });
      if (httpStatusChecker(response)) {
        return ResetCreationStockList().fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<LadderCreationParameterValues> getLadderPrices(
      LadderCreationParameterValuesRequest
          ladderCreationParameterValuesRequest) async {
    try {
      var accessToken = await _generateToken;

      final userId = await getUserID();
      var url =
          Uri.parse("$baseUrl$userId/get-ladder-creation-stock-parameters");
      var payload =
          jsonEncode({"clp_id": ladderCreationParameterValuesRequest.clpId});
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        HttpApiConstant.authorizationHeaderKeyName: accessToken,
      });
      if (httpStatusChecker(response)) {
        return LadderCreationParameterValues.fromJson(
            jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<GetUserAccountDetailsResponse?> getUserAccountDetails() async {
    try {
      var accessToken = await _generateToken;

      final userId = await getUserID();
      var url = Uri.parse("$baseUrl$userId/account");
      var response = await http.get(url, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });
      if (httpStatusChecker(response)) {
        return GetUserAccountDetailsResponse()
            .fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<LadderDetailsResponse> getLadderDetails(
      LadderDetailsRequest ladderDetailsRequest) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await getUserID();
      var url = Uri.parse("$baseUrl$userId/get-ladder-details");
      var payload = json.encode(ladderDetailsRequest.toJson());
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });
      if (httpStatusChecker(response)) {
        return LadderDetailsResponse().fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<CopyLadderResponse> copyLadderParameters(
      CopyLadderRequest copyLadderRequest) async {
    try {
      var accessToken = await _generateToken;

      var userId = await getUserID();
      var url =
          Uri.parse("$baseUrl$userId/ladder-creation-parameter/replicate");
      var payload = json.encode(copyLadderRequest.toJson());
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken
      });
      if (httpStatusChecker(response)) {
        return CopyLadderResponse().fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<LadderCreationTickerResponse> fetchLadderCreationTickers() async {
    print("insdie fetchLadderCreationTickers");
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      var userId = await getUserID();

      var url = Uri.parse("$baseUrl_v1$userId/ladder-creation-ticker/fetch");
      var response = await http.get(url, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });
      var result =
          LadderCreationTickerResponse().fromJson(jsonDecode(response.body));

      print("befor for ");
      // print(accessToken);
      log(response.body);
      print(url);
      print(result.data!.accountCashForNewLadders!);
      for (int i = 0; i < result.data!.ladderCreationTickerList!.length; i++) {
        print("inside for ");
        var tickerData = result.data!.ladderCreationTickerList;
        tickerData?[i].ssCashAllocated =
            ((double.tryParse(result.data?.accountCashForNewLadders ?? "0.0") ??
                        0.0) /
                    (tickerData.length))
                .toStringAsFixed(2);
      }
      if (httpStatusChecker(response)) {
        return result;
      } else {
        if (kDebugMode || kIsWeb) {
          return DummyUserStockAndLadderData().getDummyUserStockAndLadder();
        } else {
          throw HttpApiException(errorCode: 404);
        }

        // throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      print("Error in the fetchLadderCreationTickers function $e");
      if (kDebugMode || kIsWeb) {
        return DummyUserStockAndLadderData().getDummyUserStockAndLadder();
      } else {
        throw e;
      }
    }
  }
}
