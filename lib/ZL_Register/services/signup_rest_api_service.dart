import 'dart:convert';

import '../../global/constants/app_modules.dart';
import '../../authentication/services/authentication_rest_api_service.dart';
import '../../global/constants/api_constants.dart';
import 'package:http/http.dart' as http;

import '../../global/functions/http_api_helpers.dart';
import '../../global/models/http_api_exception.dart';
import '../models/get_registered_user_response.dart';
import '../models/get_resgistered_user_request.dart';

class SignupRestApiService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;

  Future<String> get _generateToken => authentication.generateToken();

  Future<RegisterUserResponse?> getRegisteredUser(
      RegisterUserRequest getRegisteredUserRequest) async {
    try {
      var accessToken = await _generateToken;
      if (accessToken.isEmpty) {
        return RegisterUserResponse(
          message: appModule.dataStrings.genericError,
        );
      } else {
        var url = Uri.parse("${baseUrl}register/");
        var payload = getRegisteredUserRequest.toJson();
        var response = await http.post(
          url,
          body: json.encode(payload),
          headers: {
            "Content-Type": "application/json",
            ApiConstant.authorizationHeaderKeyName: accessToken,
          },
        );
        if (httpStatusChecker(response)) {
          dynamic apiResponse = jsonDecode(response.body);
          return RegisterUserResponse().fromJson(apiResponse);
        } else {
          throw HttpApiException(errorCode: 404);
        }
      }
    } catch (e) {
      throw e;
    }
  }
}
