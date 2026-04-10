import 'dart:convert';

import 'package:dozen_diamond/AB_Ladder/stateManagement/ladder_provider.dart';
import 'package:dozen_diamond/DD_Navigation/stateManagement/navigation_provider.dart';
import 'package:dozen_diamond/Empty_ladder/models/cashEmptyLadderRequest.dart';
import 'package:dozen_diamond/Empty_ladder/models/cashEmptyLadderResponse.dart';
import 'package:dozen_diamond/authentication/services/authentication_rest_api_service.dart';
import 'package:dozen_diamond/create_ladder_detailed/constants/http_api_constant.dart';
import 'package:dozen_diamond/global/constants/api_constants.dart';
import 'package:dozen_diamond/global/constants/app_modules.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:dozen_diamond/global/functions/http_api_helpers.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../global/constants/shared_preferences_manager.dart';

class EmptyLadderService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl_v2 = ApiConstant.baseUrl_v2;
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;

  Future<String> get _generateToken => authentication.generateToken();
  Future<int> get _getUserID => authentication.getUserID();

  Future<CashEmptyLadderResponse> cashEmptyLadder(
      CashEmptyLadderRequest cashEmptyLadderRequest,
      BuildContext context) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";
      var userId = await _getUserID;
      var url = Uri.parse("$baseUrl_v2$userId/ladder/update/make-cash-empty");
      var payload = jsonEncode(cashEmptyLadderRequest);
      var response = await http.patch(url, body: payload, headers: {
        "Content-Type": "application/json",
        // HttpApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });
      if (httpStatusChecker(response)) {
        showDialog(
            context: context,
            builder: (context) {
              return showModifyLadderDialog(
                  "Successfully emptied the cash from the ladder", context);
            }).then((value) {
          Navigator.pop(context);
        });
        print("here in the code");

        return CashEmptyLadderResponse().fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Widget showModifyLadderDialog(String message, BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF15181F),
      // title: Text("Info", style: TextStyle(color: Colors.white)),
      content: Text("$message", style: TextStyle(color: Colors.white)),
      actions: [
        ElevatedButton(
            onPressed: () async {
              final currencyConstantsProvider =
                  Provider.of<CurrencyConstants>(context, listen: false);
              final ladderProvider =
                  Provider.of<LadderProvider>(context, listen: false);
              await ladderProvider!.fetchAllLadder(currencyConstantsProvider!);
              Navigator.pop(context);
              final navigationProvider =
                  Provider.of<NavigationProvider>(context, listen: false);
              navigationProvider.selectedIndex = 1;
            },
            child: Text("OK")),
      ],
    );
  }
}
