import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../authentication/services/authentication_rest_api_service.dart';
import '../../create_ladder_detailed/constants/dummy_user_stock_and_ladder_data.dart';
import '../../global/constants/api_constants.dart';
import '../../global/constants/app_modules.dart';
import '../../global/constants/shared_preferences_manager.dart';
import '../../global/functions/http_api_helpers.dart';
import '../../global/models/http_api_exception.dart';
import '../model/create_ladder_request.dart';
import '../model/create_ladder_response.dart';
import '../model/ladder_creation_tickers_response.dart';
import 'package:http/http.dart' as http;

class RestApiService {
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

  Future<LadderCreationTickerResponse> fetchLadderCreationTickers() async {
    print("insdie fetchLadderCreationTickers");
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      var userId = await getUserID();

      var url = Uri.parse("$baseUrl_v2$userId/ladder-creation-ticker/fetch");
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
      for (int i = 0; i < result.data!.ladderCreationTickerList!.length; i++) {
        print("inside for ");
        var tickerData = result.data!.ladderCreationTickerList;

        print(result.data?.accountCashForNewLadders);
        print(tickerData?.length);

        tickerData?[i].ssCashAllocated =
            ((double.tryParse(result.data?.accountCashForNewLadders ?? "0.0") ??
                        0.0) /
                    (tickerData.length))
                .toStringAsFixed(2);

        print(tickerData?[i].ssCashAllocated);
      }
      if (httpStatusChecker(response)) {
        return result;
      } else {
        if (kDebugMode || kIsWeb) {
          // return DummyUserStockAndLadderData().getDummyUserStockAndLadder() ;
          throw HttpApiException(errorCode: 404);
        } else {
          throw HttpApiException(errorCode: 404);
        }

        // throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      print("Error in the fetchLadderCreationTickers function $e");
      if (kDebugMode || kIsWeb) {
        // return DummyUserStockAndLadderData().getDummyUserStockAndLadder();
        throw e;
      } else {
        throw e;
      }
    }
  }

  Future<CreateLadderResponse?> createLadder(
      CreateLadderRequest createLadderRequest) async {
    try {
      // var accessToken = await _generateToken;

      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await _getUserID;
      var url = Uri.parse("$baseUrl_v2$userId/ladder/create");
      var payload = json.encode(createLadderRequest.toJson());
      var response = await http.post(
        url,
        body: payload,
        headers: {
          "Content-Type": "application/json",
          // ApiConstant.authorizationHeaderKeyName: accessToken,
          ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
        },
      );
      print("here is the payload of the rest api function $payload");
      print("respone of the createLadder rest api function ${response.body}");
      if (httpStatusChecker(response)) {
        return CreateLadderResponse().fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      print("error in the createLadder rest api $e");
    }
  }
}
