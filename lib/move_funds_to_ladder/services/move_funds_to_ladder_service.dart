import 'dart:convert';

import '../../authentication/services/authentication_rest_api_service.dart';
import '../../global/constants/api_constants.dart';
import '../../global/constants/app_modules.dart';
import 'package:http/http.dart' as http;

import '../../global/constants/shared_preferences_manager.dart';
import '../model/move_funds_to_ladder_request.dart';
import '../model/move_funds_to_ladder_response.dart';

class MoveFundsToLadderService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl_v2 = ApiConstant.baseUrl_v2;
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;

  Future<String> get _generateToken => authentication.generateToken();
  Future<int> get _getUserID => authentication.getUserID();

  Future<MoveFundsToLadderResponse> moveFundsToLadder(
      MoveFundsToLadderRequest addCashRequest) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";
      var userId = await _getUserID;
      print("here is the request of the addCash ${jsonEncode(addCashRequest)}");
      var payload = jsonEncode(addCashRequest);

      // var url = Uri.parse("https://jhthkkgf-3000.inc1.devtunnels.ms/api/v1/user/$userId/ladder/update/move-funds-to-ladder");
      var url = Uri.parse("$baseUrl_v2$userId/ladder/update/move-funds-to-ladder");
      var response = await http.patch(url, body: payload, headers: {
        "Content-Type": "application/json",
        // ApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });
      print("payload ${response.body}");
      return MoveFundsToLadderResponse();
    } catch (e) {
      throw e;
    }
  }
}