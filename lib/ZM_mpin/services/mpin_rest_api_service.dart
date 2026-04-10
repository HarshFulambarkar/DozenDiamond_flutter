import 'dart:convert';

import '../../global/constants/app_modules.dart';
import '../../authentication/services/authentication_rest_api_service.dart';
import '../../global/constants/api_constants.dart';
import 'package:http/http.dart' as http;

import '../../global/constants/shared_preferences_manager.dart';
import '../../global/functions/http_api_helpers.dart';
import '../../global/models/http_api_exception.dart';
import '../models/get_mpin_request.dart';
import '../models/get_mpin_response.dart';
import '../models/get_validate_mpin_request.dart';
import '../models/get_validate_mpin_response.dart';

class MpinRestApiService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;

  Future<String> get _generateToken => authentication.generateToken();

  Future<GetMpinResponse?> generateNewMpinRequest(
      GetMpinRequest getMpinRequest) async {
    try {
      var accessToken = await _generateToken;

      var url = Uri.parse("${baseUrl}generateMpin/");
      var payload = json.encode(
        {
          "userId": getMpinRequest.userId,
          "mPinNo": getMpinRequest.mPinNo,
          "confirmMpinNo": getMpinRequest.confirmMpinNo,
        },
      );
      var response = await http.post(
        url,
        body: payload,
        headers: {
          "Content-Type": "application/json",
          ApiConstant.authorizationHeaderKeyName: accessToken,
        },
      );
      if (httpStatusChecker(response)) {
        dynamic apiResponse = jsonDecode(response.body);
        return GetMpinResponse().fromJson(apiResponse);
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<GetValidateMpinResponse?> getValidateMpin(
      GetValidateMpinRequest getValidateMpinRequest) async {
    try {
      var accessToken = await _generateToken;

      var url = Uri.parse("${baseUrl}validateMpin/");

      String fcmToken = await SharedPreferenceManager.getFCMToken() ?? "";

      var payload = json.encode(
        {
          "userId": getValidateMpinRequest.userId,
          "mPinNo": getValidateMpinRequest.mPinNo,
          "fcm_token": fcmToken,
        },
      );
      var response = await http.post(
        url,
        body: payload,
        headers: {
          "Content-Type": "application/json",
          ApiConstant.authorizationHeaderKeyName: accessToken,
        },
      );
      if (httpStatusChecker(response)) {
        dynamic apiResponse = jsonDecode(response.body);
        return GetValidateMpinResponse().fromJson(apiResponse);
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }
}
