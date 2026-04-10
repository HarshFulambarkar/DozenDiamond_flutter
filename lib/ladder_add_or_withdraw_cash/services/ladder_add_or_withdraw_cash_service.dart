import 'dart:convert';

import 'package:dozen_diamond/authentication/services/authentication_rest_api_service.dart';
import 'package:dozen_diamond/global/constants/api_constants.dart';
import 'package:dozen_diamond/global/constants/app_modules.dart';
import 'package:dozen_diamond/ladder_add_or_withdraw_cash/models/addCashRequest.dart';
import 'package:dozen_diamond/ladder_add_or_withdraw_cash/models/addCashResponse.dart';
import 'package:dozen_diamond/ladder_add_or_withdraw_cash/models/withdrawCashRequest.dart';
import 'package:dozen_diamond/ladder_add_or_withdraw_cash/models/withdrawCashResponse.dart';
import 'package:http/http.dart' as http;

import '../../global/constants/shared_preferences_manager.dart';

class LadderAddOrWithdrawCashService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl_v2 = ApiConstant.baseUrl_v2;
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;

  Future<String> get _generateToken => authentication.generateToken();
  Future<int> get _getUserID => authentication.getUserID();

  Future<AddCashResponse> addCashToLadderService(
      AddCashRequest addCashRequest) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";
      var userId = await _getUserID;
      print("here is the request of the addCash ${jsonEncode(addCashRequest)}");
      var payload = jsonEncode(addCashRequest);

      var url = Uri.parse("$baseUrl_v2$userId/ladder/add-cash");
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });
      print("payload ${response.body}");
      return AddCashResponse();
    } catch (e) {
      throw e;
    }
  }

  Future<WithdrawCashResponse> withdrawCashToLadderService(
      WithdrawCashRequest withdrawCashRequest) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";
      var userId = await _getUserID;

      var payload = jsonEncode(withdrawCashRequest);

      var url = Uri.parse("$baseUrl_v2$userId/ladder/withdraw-cash");
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });
      print("payload ${response.body}");
      return WithdrawCashResponse();
    } catch (e) {
      throw e;
    }
  }
}
