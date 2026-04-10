import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../authentication/services/authentication_rest_api_service.dart';
import '../../global/constants/api_constants.dart';
import '../../global/constants/app_modules.dart';
import 'package:http/http.dart' as http;

import '../../global/functions/http_api_helpers.dart';
import '../../global/models/http_api_exception.dart';
import '../model/phone_verify_data_response.dart';
import '../model/profile_data_response.dart';
import '../model/update_profile_data_response.dart';

class ProfileRestApiService {

  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl_v2 = ApiConstant.baseUrl_v2;
  static const baseUrl_withoutUser = ApiConstant.baseUrl_withoutUser;
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;

  Future<String> get _generateToken => authentication.generateToken();

  Future<int> getUserID() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getInt("reg_id") ?? 0;
    return userId;
  }

  Future<ProfileDataResponse> getProfileData() async {

    try {
      var accessToken = await _generateToken;

      final userId = await getUserID();
      var url = Uri.parse("${baseUrl_v2}$userId/getProfileDetails");
      // var url = Uri.parse("https://2fw8x25q-3000.inc1.devtunnels.ms/api/v1/user/723/watchlist/fetch");

      var response = await http.get(url, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });

      print(url);
      print(response.body);
      if (httpStatusChecker(response)) {
        return ProfileDataResponse.fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<UpdateProfileDataResponse> updateProfileData(Map<String, dynamic> requestBody) async {

    try {
      var accessToken = await _generateToken;

      final userId = await getUserID();
      var url = Uri.parse("${baseUrl_v2}$userId/updateProfileDetails");

      var payload = json.encode(requestBody);

      var response = await http.put(url, body: payload, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });

      print(url);
      print(response.body);
      if (httpStatusChecker(response)) {
        return UpdateProfileDataResponse.fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<PhoneVerifyDataResponse> sendVerifyPhoneNumberOtp(Map<String, dynamic> requestBody) async {

    try {
      var accessToken = await _generateToken;

      final userId = await getUserID();
      // var url = Uri.parse("${baseUrl_v2}$userId/updateProfileDetails");
      var url = Uri.parse("${baseUrl}$userId/Sendsms");

      var payload = json.encode(requestBody);

      // var response = await http.get(url, headers: {
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });

      print(url);
      print(response.body);
      if (httpStatusChecker(response)) {
        return PhoneVerifyDataResponse.fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<PhoneVerifyDataResponse> verifyPhoneNumber(Map<String, dynamic> requestBody) async {

    try {
      var accessToken = await _generateToken;

      final userId = await getUserID();
      // var url = Uri.parse("${baseUrl_v2}$userId/updateProfileDetails");
      var url = Uri.parse("${baseUrl}$userId/phoneverify");

      var payload = json.encode(requestBody);

      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });

      print(url);
      print(response.body);
      if (httpStatusChecker(response)) {
        return PhoneVerifyDataResponse.fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

}