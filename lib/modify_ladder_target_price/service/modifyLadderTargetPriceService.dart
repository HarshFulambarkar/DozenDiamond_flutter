import 'dart:convert';

import 'package:dozen_diamond/authentication/services/authentication_rest_api_service.dart';
import 'package:dozen_diamond/create_ladder_detailed/constants/http_api_constant.dart';
import 'package:dozen_diamond/global/constants/api_constants.dart';
import 'package:dozen_diamond/global/constants/app_modules.dart';
import 'package:dozen_diamond/global/functions/http_api_helpers.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:dozen_diamond/modify_ladder_target_price/model/modifyOrderSizeRequest.dart';
import 'package:dozen_diamond/modify_ladder_target_price/model/modifyOrderSizeResponse.dart';
import 'package:dozen_diamond/modify_ladder_target_price/model/modifyStepSizeRequest.dart';
import 'package:dozen_diamond/modify_ladder_target_price/model/modifyStepSizeResponse.dart';
import 'package:dozen_diamond/modify_ladder_target_price/model/modifyTargetPriceRequest.dart';
import 'package:dozen_diamond/modify_ladder_target_price/model/modifyTargetPriceResponse.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../global/constants/shared_preferences_manager.dart';

class ModifyLadderTargetPriceService {
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

  Future<ModifyTargetPriceResponse> changeTargetPrice(
      ModifyTargetPriceRequest modifyLadderPriceRequest, BuildContext context) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";
      var userId = await getUserID();
      var url =
          Uri.parse("$baseUrl_v2$userId/ladder/update/ladder-target-price");
      var payload = jsonEncode(modifyLadderPriceRequest);
      var response = await http.patch(url, body: payload, headers: {
        "Content-Type": "application/json",
        // HttpApiConstant.authorizationHeaderKeyName: accessToken,
        ApiConstant.authorizationHeaderKeyName: "${ApiConstant.bearer} $userAccessToken"
      });
      if (httpStatusChecker(response)) {
        final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
        navigationProvider.selectedIndex = 1;
        showDialog(
            context: context,
            builder: (context) {
              return showModifyLadderDialog(
                  "Ladder Target Price Modified successfully",
                  context);
            }).whenComplete(() {

        });
        return ModifyTargetPriceResponse().fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      print("error in the changeTargetPrice in service $e");
      throw e;
    }
  }


  Future<ModifyOrderSizeResponse> changeOrderSize(
      ModifyOrderSizeRequest modifyLadderPriceRequest, BuildContext context) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";
      var userId = await getUserID();
      var url = Uri.parse("$baseUrl_v2$userId/ladder/update/ladder-orderSize");
      var payload = jsonEncode(modifyLadderPriceRequest);
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
                  "Ladder Order Size Modified successfully",
                  context);
            }).whenComplete(() {
          final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
          navigationProvider.selectedIndex = 1;
        });
        return ModifyOrderSizeResponse().fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      print("error in the changeTargetPrice in service $e");
      throw e;
    }
  }

  Future<ModifyStepSizeResponse> changeStepSize(
      ModifyStepSizeRequest modifyLadderPriceRequest, BuildContext context) async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken = (await SharedPreferenceManager.getUserAccessToken()) ?? "";
      var userId = await getUserID();
      var url = Uri.parse("$baseUrl_v2$userId/ladder/update/ladder-stepSize");
      var payload = jsonEncode(modifyLadderPriceRequest);
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
                  "Ladder Step Size Modified successfully",
                  context);
            }).whenComplete(() {
          final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
          navigationProvider.selectedIndex = 1;
        });

        return ModifyStepSizeResponse().fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      print("error in the changeTargetPrice in service $e");
      throw e;
    }
  }

  Widget showModifyLadderDialog(String message, BuildContext context) {
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
