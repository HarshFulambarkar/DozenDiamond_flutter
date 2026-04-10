import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../authentication/services/authentication_rest_api_service.dart';
import '../../create_ladder_detailed/constants/dummy_user_stock_and_ladder_data.dart';
import '../../global/constants/api_constants.dart';
import '../../global/constants/app_modules.dart';
import '../../global/functions/http_api_helpers.dart';
import '../../global/models/http_api_exception.dart';
import 'package:http/http.dart' as http;

import '../model/fetch_run_id_response.dart';
import '../model/revert_run_id_response.dart';
import '../model/revert_run_id_request.dart';

class RunRevertService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl_v2 = ApiConstant.baseUrl_v2;
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;

  Future<String> get _generateToken => authentication.generateToken();
  Future<int> get _getUserID => authentication.getUserID();

  Future<int> getUserID() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getInt("reg_id") ?? 730;
    return userId;
  }

  Future<FetchRunIdResponse> getAllRunOfAUser({
    required int page,
    required int limit,
  }) async {
    try {
      print("at the ln 38");
      var accessToken = await _generateToken;

      final userId = await _getUserID;
      final url = Uri.parse(
        "$baseUrl_v2$userId/recent-run/fetch-all?page=$page&limit=$limit",
      );
      var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          ApiConstant.authorizationHeaderKeyName: accessToken,
        },
      );

      print("here is the url getAllRunOfAUser $url");
      print("here is the body getAllRunOfAUser ${response.body}");
      if (httpStatusChecker(response)) {
        return FetchRunIdResponse().fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }


  Future<RevertRunIdResponse> revertTheRunIdOfAUser(
      RevertRunIdRequest revertRunIdRequest) async {
    try {
      var accessToken = await _generateToken;

      final userId = await getUserID();
      var url = Uri.parse("$baseUrl_v2$userId/recent-run/update");
      var payload = json.encode(revertRunIdRequest);
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });
      print("here is the url revertTheRunIdOfAUser $url");
      print("here is the body revertTheRunIdOfAUser ${response.body}");
      print("here is the body revertTheRunIdOfAUser ${payload}");

      if (httpStatusChecker(response)) {
        return RevertRunIdResponse().fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }
}
