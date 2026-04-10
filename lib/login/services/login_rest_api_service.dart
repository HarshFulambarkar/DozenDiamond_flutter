import 'dart:convert';
import 'dart:io';

import 'package:dozen_diamond/global/constants/shared_preferences_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../../global/constants/app_modules.dart';
import '../../authentication/services/authentication_rest_api_service.dart';
import '../../global/constants/api_constants.dart';
import 'package:http/http.dart' as http;

import '../../global/functions/http_api_helpers.dart';
import '../../global/models/http_api_exception.dart';
import '../../login/models/forgot_password_request.dart';
import '../../login/models/forgot_password_response.dart';
import '../../login/models/login_user_request.dart';
import '../../login/models/login_user_response.dart';
import '../models/reset_password_link_request.dart';
import '../models/reset_password_link_response.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginRestApiService {
  AuthenticationRestApiService authentication = AuthenticationRestApiService();
  AppModule appModule = AppModule();
  static const baseUrl = ApiConstant.baseUrl;
  static const baseUrl1 = ApiConstant.baseUrl1;
  static const baseUrl2 = ApiConstant.baseUrl2;

  Future<int> get _getUserID => authentication.getUserID();

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn(
  //   // clientId: "http://1044513120066-ilfrajov5ie6iipjgt3apco53j67flq7.apps.googleusercontent.com",
  //   // serverClientId: "1044513120066-omqslede5hcqoot6pn4okdn8ccsfvr6t.apps.googleusercontent.com",
  // );

  Future<String> get _generateToken => authentication.generateToken();

  Future<ForgotPasswordResponse?> forgotPassword(
      ForgotPasswordRequest forgotPasswordRequest) async {
    try {
      var accessToken = await _generateToken;

      var url = Uri.parse("${baseUrl}forgetpassword");
      // var url = Uri.parse("https://api-app.dozendiamonds.com/user/forgetpassword");
      var payload = json.encode(forgotPasswordRequest.toJson());
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });
      print("below is response");
      print(response);
      if (httpStatusChecker(response)) {
        return ForgotPasswordResponse().fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<ResetPasswordLinkResponse?> resetPasswordLink(
      ResetPasswordLinkRequest resetPasswordLinkRequest) async {
    try {
      var accessToken = await _generateToken;

      var url =
          Uri.parse("$baseUrl/resetpassword/${resetPasswordLinkRequest.otp}");
      var payload = json.encode(resetPasswordLinkRequest.toJson());
      var response = await http.patch(url, body: payload, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });
      if (httpStatusChecker(response)) {
        return ResetPasswordLinkResponse().fromJson(jsonDecode(response.body));
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<LoginUserResponse?> getLoginUser(LoginUserRequest getLoginUserRequest) async {
    try {
      var accessToken = await _generateToken;
      print("here is the accesstoken ${accessToken}");
      var url = Uri.parse("${baseUrl}login/");

      String fcmToken = await SharedPreferenceManager.getFCMToken() ?? "";
      var payload = json.encode(
        {
          "useremail": getLoginUserRequest.useremail,
          "password": getLoginUserRequest.password,
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

        LoginUserResponse data = LoginUserResponse().fromJson(apiResponse);

        print("before saving issuper");
        print(data.data!.isSuper);
        SharedPreferenceManager.saveIsSuper(data.data!.isSuper ?? false);
        SharedPreferenceManager.saveUserAccessToken(data.data!.token ?? "");

        return LoginUserResponse().fromJson(apiResponse);
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<bool> verifyOtpForResetPassword(
      Map<String, dynamic>? requestBody) async {
    try {
      var accessToken = await _generateToken;

      // var payload = json.encode(partialOrderGenerationRequest.toJson());
      var payload = json.encode(requestBody);
      print(payload);

      var url = Uri.parse("${baseUrl}verifyOtpForResetPassword");
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });
      print(response.body);
      if (httpStatusChecker(response)) {
        return true;
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }


  Future<bool> resetPassword(
      Map<String, dynamic>? requestBody) async {
    try {
      var accessToken = await _generateToken;

      // var payload = json.encode(partialOrderGenerationRequest.toJson());
      var payload = json.encode(requestBody);
      print(payload);

      var url = Uri.parse("${baseUrl}resetPassword");
      var response = await http.post(url, body: payload, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });
      print(response.body);
      if (httpStatusChecker(response)) {
        return true;
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      if(kIsWeb == false){
        if(Platform.isAndroid) {
          print("inside android google sign initialize");
          await _googleSignIn.initialize(
            // clientId: "486769585980-snk3mckvbc5c9tus8ajs1fj613cflgp5.apps.googleusercontent.com",
            // serverClientId: "http://486769585980-snk3mckvbc5c9tus8ajs1fj613cflgp5.apps.googleusercontent.com",

            // clientId: "486769585980-31u32d5bjk1o0n4104ao25dpfi6qus8o.apps.googleusercontent.com",
            // serverClientId: "http://486769585980-31u32d5bjk1o0n4104ao25dpfi6qus8o.apps.googleusercontent.com",

            // clientId: "486769585980-pj9lp06mgjos8p881s7eh08k4ngp233l.apps.googleusercontent.com",
            // serverClientId: "http://486769585980-pj9lp06mgjos8p881s7eh08k4ngp233l.apps.googleusercontent.com",

            clientId: "http://486769585980-31u32d5bjk1o0n4104ao25dpfi6qus8o.apps.googleusercontent.com",
            serverClientId: "486769585980-9pdlherrdr1ihv8tbp8v1qgjip1r070n.apps.googleusercontent.com",

            // clientId: "http://1044513120066-ilfrajov5ie6iipjgt3apco53j67flq7.apps.googleusercontent.com",
            // serverClientId: "1044513120066-omqslede5hcqoot6pn4okdn8ccsfvr6t.apps.googleusercontent.com",
          );
        }
      }

      final GoogleSignInAccount? account = await _googleSignIn.authenticate();

      // final GoogleSignInAccount? account = await _googleSignIn.signIn(
      //
      // );
      print("below is null");
      print(account);
      return account;
    } catch (error) {
      print("Google sign in error: $error");
      return null;
    }
  }

  Future<void> signOutGoogle() async {
    print("inside signOutGoogle");
    await _googleSignIn.signOut();
    await _googleSignIn.disconnect();
    print("after signOutGoogle");
  }

  Future<Map<String, dynamic>?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        // Get the user data
        final userData = await FacebookAuth.instance.getUserData();
        // The access token can be obtained as well:
        final accessToken = result.accessToken?.tokenString;
        // You can include the access token with the userData if needed
        return {'userData': userData, 'accessToken': accessToken};
      } else {
        print("Facebook login failed: ${result.status}");
        return null;
      }
    } catch (error) {
      print("Facebook sign in error: $error");
      return null;
    }
  }

  Future<void> logOutFacebook() async {
    await FacebookAuth.instance.logOut();
  }

  Future<bool> deleteAccount(
      Map<String, dynamic>? requestBody) async {
    try {
      var accessToken = await _generateToken;

      // var payload = json.encode(partialOrderGenerationRequest.toJson());
      var payload = json.encode(requestBody);
      print(payload);

      final userId = await _getUserID;

      var url = Uri.parse("${baseUrl}${userId}/update-account-status");
      var response = await http.put(url, headers: {
        "Content-Type": "application/json",
        ApiConstant.authorizationHeaderKeyName: accessToken,
      });
      print(response.body);
      if (httpStatusChecker(response)) {
        return true;
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }
}
