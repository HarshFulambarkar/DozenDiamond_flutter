import 'dart:convert';
import 'package:dozen_diamond/global/constants/shared_preferences_manager.dart';
import 'package:dozen_diamond/global/functions/http_api_helpers.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../global/constants/api_constants.dart';

class AuthenticationRestApiService {
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;

  Future<String> generateToken() async {
    var userAccessToken = await SharedPreferenceManager.getUserAccessToken();
    if (userAccessToken != null && userAccessToken.isNotEmpty && userAccessToken != "") {
      return userAccessToken;
    } else {
      try {
        var accessToken = "";
        var url = Uri.parse('${baseUrl}generateToken/');
        var payload = json.encode({
          "clientID": ApiConstant.clientID,
          "secretKey": ApiConstant.secretKey,
        });
        var response = await http.post(
          url,
          body: payload,
          headers: {"Content-Type": "application/json"},
        );
        print("accessToken response ${response.body}");
        if (httpStatusChecker(response)) {
          dynamic apiResponse = jsonDecode(response.body);
          if (apiResponse["status"] == true && apiResponse["data"] != null) {
            accessToken = apiResponse["data"]["token"];
          }
        }
        return accessToken;
      } catch (e) {
        throw e;
      }}
  }

  Future<int> getUserID() async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getInt("reg_id") ?? 0;
    return userId;
  }
}
