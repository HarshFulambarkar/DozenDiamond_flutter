import 'dart:convert';
import 'dart:developer';

import 'package:dozen_diamond/authentication/services/authentication_rest_api_service.dart';
import 'package:dozen_diamond/global/constants/api_constants.dart';
import 'package:dozen_diamond/global/constants/shared_preferences_manager.dart';
import 'package:dozen_diamond/global/functions/http_api_helpers.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:dozen_diamond/global/models/reminder_request_model.dart';
import 'package:dozen_diamond/global/models/reminder_response_model.dart';
import 'package:dozen_diamond/reminders/models/reminder_data_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReminderRestApiService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  static const baseUrl_v2 = ApiConstant.baseUrl_v2;
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;

  Future<String> get _generateToken => authentication.generateToken();
  Future<int> get _getUserID => authentication.getUserID();

  Future<ReminderResponseModel> setReminderApiService({
    required String reminderTime,
    required String reminderMessage,
  }) async {
    try {
      // var accessToken = await _generateToken;

      String userAccessToken =
          (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      // var userId = await _getUserID;
      print(reminderTime);
      ReminderRequestModel reminderModel = ReminderRequestModel(
        message: reminderMessage,
        scheduledDateTime: reminderTime,
        // userId: userId,
      );
      // var url = Uri.parse("$baseUrl_v2$userId/settings/switch-trading-mode");
      var url = Uri.parse("${baseUrl_v2}reminder/create");
      var payload = json.encode(reminderModel.toJson());
      var response = await http.post(
        body: payload,
        url,
        headers: {
          'Content-Type': 'application/json',
          // ApiConstant.authorizationHeaderKeyName: accessToken
          ApiConstant.authorizationHeaderKeyName:
              "${ApiConstant.bearer} $userAccessToken",
        },
      );

      print(response.body);
      if (httpStatusChecker(response)) {
        return (ReminderResponseModel().fromJson(jsonDecode(response.body)));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<ReminderDataResponse> getReminders() async {
    try {
      // var accessToken = await _generateToken;
      String userAccessToken =
          (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      var url = Uri.parse("${baseUrl_v2}reminder/all");
      var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          // ApiConstant.authorizationHeaderKeyName: accessToken,
          ApiConstant.authorizationHeaderKeyName:
              "${ApiConstant.bearer} $userAccessToken",
        },
      );

      print(url);
      log(response.body);

      if (httpStatusChecker(response)) {
        return ReminderDataResponse.fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<ReminderUpdateDeleteDataResponse> updateReminder({
    required int reminderId,
    required String reminderTime,
    required String reminderMessage,
  }) async {
    try {
      String userAccessToken =
          (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      print(reminderTime);
      ReminderRequestModel reminderModel = ReminderRequestModel(
        message: reminderMessage,
        scheduledDateTime: reminderTime,
      );

      var url = Uri.parse("${baseUrl_v2}reminder/update/$reminderId");
      var payload = json.encode(reminderModel.toJson());
      var response = await http.patch(
        body: payload,
        url,
        headers: {
          'Content-Type': 'application/json',
          // ApiConstant.authorizationHeaderKeyName: accessToken
          ApiConstant.authorizationHeaderKeyName:
              "${ApiConstant.bearer} $userAccessToken",
        },
      );

      log(response.body);
      if (httpStatusChecker(response)) {
        return (ReminderUpdateDeleteDataResponse.fromJson(jsonDecode(response.body)));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<ReminderUpdateDeleteDataResponse> deleteReminder({required int reminderId}) async {
    try {
      String userAccessToken =
          (await SharedPreferenceManager.getUserAccessToken()) ?? "";

      var url = Uri.parse("${baseUrl_v2}reminder/delete/$reminderId");
      var response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          ApiConstant.authorizationHeaderKeyName:
              "${ApiConstant.bearer} $userAccessToken",
        },
      );

      print(response.body);
      if (httpStatusChecker(response)) {
        return (ReminderUpdateDeleteDataResponse.fromJson(jsonDecode(response.body)));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }
}
