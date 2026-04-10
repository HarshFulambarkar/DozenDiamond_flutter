import 'dart:convert';
import 'package:dozen_diamond/F_Funds/models/account_cash_details_response.dart';
import 'package:dozen_diamond/F_Funds/models/get_ladders_funds_info_response.dart';
import 'package:dozen_diamond/F_Funds/models/get_user_account_details_respone_addFunds.dart';
import 'package:dozen_diamond/global/functions/http_api_helpers.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:http/http.dart' as http;

import '../../global/constants/app_modules.dart';
import 'package:dozen_diamond/global/constants/api_constants.dart';

import '../../authentication/services/authentication_rest_api_service.dart';
import '../../global/constants/shared_preferences_manager.dart';
import '../../ladder_add_or_withdraw_cash/models/withdrawCashResponse.dart';
import '../models/add_funds_to_user_account_request.dart';
import '../models/add_funds_to_user_account_response.dart';

class FundsRestApiService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl_v2 = ApiConstant.baseUrl_v2;
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;

  Future<String> get _generateToken => authentication.generateToken();
  Future<int> get _getUserID => authentication.getUserID();

  Future<AddFundsToUserAccountResponse?> addFundsToUserPaperAccount(
      AddFundsToUserAccountRequest requestBody) async {
    try {
      // var accessToken = await _generateToken;

      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      var userId = await _getUserID;
      var url = Uri.parse("$baseUrl_v2$userId/account/addfunds");
      var payload = json.encode(requestBody);
      var response = await http.post(
        url,
        body: payload,
        headers: {
          "Content-Type": "application/json",
          // ApiConstant.authorizationHeaderKeyName: accessToken,
          ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
        },
      );

      if (httpStatusChecker(response)) {
        final apiResponse = json.decode(response.body);
        return AddFundsToUserAccountResponse().fromJson(apiResponse);
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<GetUserAccountDetailsResponse?> getUserAccountDetails() async {
    try {
      // var accessToken = await _generateToken;

      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await _getUserID;
      var url = Uri.parse("$baseUrl_v2$userId/account-cash-details/fetch");
      var response = await http.get(url, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
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

  Future<GetLadderResponse?> getLadder() async {
    try {
      var accessToken = await _generateToken;

      final userId = await _getUserID;
      var url = Uri.parse("$baseUrl2$userId/ladder");
      var response = await http.get(url, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });

      if (httpStatusChecker(response)) {
        return GetLadderResponse().fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<AccountCashDetailsResponse?> getAccountCashDetails() async {
    try {
      // var accessToken = await _generateToken;

      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      var userId = await _getUserID;

      var url = Uri.parse("$baseUrl_v2$userId/account-cash-details/fetch");

      var response = await http.get(url, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });

      if (httpStatusChecker(response)) {
        return AccountCashDetailsResponse().fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: response.statusCode);
      }
    } catch (err) {
      print(
          "Error in the getAccountCashDetails function in the funds rest api service $err");
    }
    return null;
  }

  Future<WithdrawCashResponse> withdrawExtraCash(Map<String, dynamic>? requestBody) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await _getUserID;
      var url = Uri.parse("$baseUrl_v2$userId/withdrawFunds/extra-cash");
      var payload = json.encode(requestBody);

      print(url);
      print(payload);
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });
      if (httpStatusChecker(response)) {
        return WithdrawCashResponse()
            .fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<WithdrawCashResponse> withdrawAvailableCash(Map<String, dynamic>? requestBody) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await _getUserID;
      var url = Uri.parse("$baseUrl_v2$userId/withdrawFunds/available-cash");
      var payload = json.encode(requestBody);
      print(url);
      print(payload);
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });
      if (httpStatusChecker(response)) {
        return WithdrawCashResponse()
            .fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }
}
