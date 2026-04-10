import 'dart:convert';
import 'package:dozen_diamond/ZB_accountInfoBar/models/get_account_details_response.dart';
import 'package:dozen_diamond/create_ladder_detailed/constants/dummy_user_stock_and_ladder_data.dart';
import 'package:dozen_diamond/create_ladder_detailed/constants/message_constant.dart';
import 'package:dozen_diamond/create_ladder_detailed/models/ladder_creation_stock_list.dart';
import 'package:dozen_diamond/create_ladder_detailed/models/ladder_creation_parameter_values.dart';
import 'package:dozen_diamond/create_ladder_detailed/models/reset_creation_stock_list.dart';
import 'package:dozen_diamond/create_ladder_detailed/models/stock_recommended_parameters_response.dart';
import 'package:dozen_diamond/global/constants/api_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../authentication/services/authentication_rest_api_service.dart';
import '../../global/constants/app_modules.dart';
import '../../global/constants/shared_preferences_manager.dart';
import '../../global/functions/http_api_helpers.dart';
import '../../global/models/http_api_exception.dart';
import '../constants/http_api_constant.dart';
import '../models/copy_ladder_request.dart';
import '../models/copy_ladder_response.dart';
import '../models/ladder_creation_parameter_values_request.dart';
import '../models/ladder_creation_stock_list_with_parameters.dart';
import '../models/ladder_creation_tickers_response.dart';
import '../models/ladder_details_request.dart';
import '../models/ladder_details_response.dart';
import '../models/stock_holding_response.dart';

class RestApiService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl_v2 = ApiConstant.baseUrl_v2;
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;

  Future<String> get _generateToken => authentication.generateToken();
  MessageConstant constMessage = MessageConstant();

  Future<int> getUserID() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getInt("reg_id") ?? 0;
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
        print("getUserStockAndLadderWithParameters response: ${response.body}");
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
      // var url = Uri.parse("$baseUrl$userId/get-ladder-details");
      var url = Uri.parse("$baseUrl_v2$userId/get-ladder-details");
      // var url = Uri.parse("$baseUrl_v2$userId/ladder-implementation/fetch");
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

Future<LadderCreationTickerResponse> fetchLadderCreationTickers(
      List<TextEditingController> cashAllocatedControllerList,
      {bool cashAllocatedChanged = false}) async {
    try {
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";
      var userId = await getUserID();

      var url = Uri.parse("$baseUrl_v2$userId/ladder-creation-ticker/fetch");
      var response = await http.get(url, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });
      
      print("ladder creation ticker response status: ${response.statusCode}");
      print("ladder creation ticker response body: ${response.body.toString()}");
      
      var result = LadderCreationTickerResponse().fromJson(jsonDecode(response.body));
      
      if (result.data?.ladderCreationTickerList != null) {
        for (int i = 0; i < result.data!.ladderCreationTickerList!.length; i++) {
          var tickerData = result.data!.ladderCreationTickerList;
          if (!cashAllocatedChanged) {
            tickerData?[i].ssCashAllocated = ((double.tryParse(
                            result.data?.accountCashForNewLadders ?? "0.0") ??
                        0.0) /
                    (tickerData.length))
                .toStringAsFixed(2);
          } else {
            print("here is the else statement of ${cashAllocatedControllerList[i].text}");
            tickerData?[i].ssCashAllocated = cashAllocatedControllerList[i].text;
          }
        }
      }
      
      if (httpStatusChecker(response)) {
        return result;
      } else {
        // Handle error with status code
        String errorMessage = "Server error: ${response.statusCode}";
        if (response.statusCode == 500) {
          errorMessage = "Server error. Please try again later.";
        } else if (response.statusCode == 404) {
          errorMessage = "Data not found.";
        }
        
        throw HttpApiException(
          errorCode: response.statusCode,
          errorTitle: "Error ${response.statusCode}",
          errorSuggestion: errorMessage,
        );
      }
    } catch (e) {
      print("Error in the fetchLadderCreationTickers function $e");
      // Just rethrow the error - don't return dummy data
      throw e;
    }
  }

  Future<StockRecommendedParametersResponse> addStockRecommendationParameters(
      Map<String, dynamic> request) async {
    try {
      // var accessToken = await _generateToken;

      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      // var userId = await getUserID();
      // var url = Uri.parse("$baseUrl_v2$userId/stock-recommendation/parameters");
      var url = Uri.parse("${baseUrl_v2}stock-recommendation/parameters");
      var payload = json.encode(request);
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });
      print("below is recommanded parameter data");
      print(url);
      print(payload);
      print(response.body);
      if (httpStatusChecker(response)) {
        return StockRecommendedParametersResponse.fromJson(
            jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<StockRecommendedParametersResponse> reorderStockListOrder(
      Map<String, dynamic> request) async {
    try {
      // var accessToken = await _generateToken;

      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      var userId = await getUserID();
      var url = Uri.parse("${baseUrl_v2}$userId/ladder/reorder-selected-stocks");
      var payload = json.encode(request);
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });
      print("below is recommanded parameter data");
      print(url);
      print(payload);
      print(response.body);
      if (httpStatusChecker(response)) {
        return StockRecommendedParametersResponse.fromJson(
            jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<StockHoldingResponse> getPriorBuyStockHoldings(
      Map<String, dynamic> request) async {
    try {
      // var accessToken = await _generateToken;

      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      // var userId = await getUserID();
      // var url = Uri.parse("$baseUrl_v2$userId/stock-recommendation/parameters");
      var url = Uri.parse("${baseUrl_v2}priorBuy/getHoldingsOfAStock");
      var payload = json.encode(request);
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken
        // ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
        ApiConstant.authorizationHeaderKeyName: "$userAccessToken"
      });
      print("below is stock holding data");
      print(url);
      print(payload);
      print(response.body);
      if (httpStatusChecker(response)) {
        return StockHoldingResponse.fromJson(
            jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  // Future<StockRecommendedParametersResponse> addStockRecommendationParameters(
  //     Map<String, dynamic>? requestBody) async {
  //   // String tempbaseUrl_v2 = "https://2fw8x25q-3000.inc1.devtunnels.ms/api/v1/user/";
  //   try {
  //     var accessToken = await _generateToken;
  //
  //     final userId = await getUserID();
  //     var url = Uri.parse("$baseUrl_v2$userId/stock-recommendation/parameters");
  //     // var url = Uri.parse("https://2fw8x25q-3000.inc1.devtunnels.ms/api/v1/user/959/watchlist/add");
  //     var payload = json.encode(requestBody);
  //     var response = await http.post(url, body: payload, headers: {
  //       "Content-Type": "application/json",
  //       ApiConstant.authorizationHeaderKeyName: accessToken,
  //     });
  //
  //     print("below is addStockRecommendationParameters");
  //     print(url);
  //     print(payload);
  //     print(response.body);
  //     if (httpStatusChecker(response)) {
  //       return StockRecommendedParametersResponse.fromJson(jsonDecode(response.body));
  //
  //     } else {
  //       throw HttpApiException(errorCode: 404);
  //     }
  //   } catch (e) {
  //     throw e;
  //   }
  // }
}
