import 'dart:convert';

import 'package:dozen_diamond/authentication/services/authentication_rest_api_service.dart';
import 'package:dozen_diamond/create_ladder_detailed/constants/http_api_constant.dart';
import 'package:dozen_diamond/global/constants/api_constants.dart';
import 'package:dozen_diamond/global/constants/app_modules.dart';
import 'package:dozen_diamond/global/functions/http_api_helpers.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:dozen_diamond/merge_ladder/model/merge_ladder_request.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../global/constants/shared_preferences_manager.dart';

class MergeLadderService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl_v2 = ApiConstant.baseUrl_v2;
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;

  Future<String> get _generateToken => authentication.generateToken();
  Future<int> getUserID() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getInt("reg_id") ?? 0;
    return userId;
  }

  Future<void> saveMergedLadder(MergeLadderRequest mergeLadderRequest, BuildContext context) async {
    try {
      // var accessToken = await _generateToken;

      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      final userId = await getUserID();

      var url = Uri.parse("$baseUrl_v2$userId/ladder/merge");
      // var url =
      //     Uri.parse("http://localhost:3000/api/v1/user/$userId/ladder/merge");
      var payload = json.encode(mergeLadderRequest);
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        // HttpApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });
      print("here is the response of merging ladder ${response.body}");
      if (httpStatusChecker(response)) {
        showDialog(
            context: context,
            builder: (context) {
              return showMergeLadderDialog(
                  "Ladder merge successfully",
                  context);
            }).whenComplete(() {
            final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
            navigationProvider.selectedIndex = 1;
        });
        // return UpstoxLoginResponse.fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Widget showMergeLadderDialog(String message, BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF15181F),
      // title: Text("Info", style: TextStyle(color: Colors.white)),
      content: Text(
          "$message", style: TextStyle(color: Colors.white)),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
              navigationProvider.selectedIndex = 1;

            },
            child: Text("OK")),
      ],
    );
  }
}
