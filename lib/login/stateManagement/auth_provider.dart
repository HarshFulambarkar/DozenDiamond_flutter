import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../authentication/services/authentication_rest_api_service.dart';
import '../../global/constants/api_constants.dart';
import '../../global/constants/shared_preferences_manager.dart';
import '../../global/functions/http_api_helpers.dart';
import '../../global/models/http_api_exception.dart';
import '../models/login_user_response.dart';
import '../services/login_rest_api_service.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  AuthProvider(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  final secureStorage = const FlutterSecureStorage();

  bool _googleLoginButtonClick = false;

  bool get googleLoginButtonClick => _googleLoginButtonClick;

  set googleLoginButtonClick(bool value) {
    _googleLoginButtonClick = value;
    notifyListeners();
  }

  Future<LoginUserResponse?> loginWithGoogle(bool isSignup) async {
    print("inside login with google");
    final googleAccount = await LoginRestApiService().signInWithGoogle();
    // final googleAccount = await LoginRestApiService().signOutGoogle();
    print("below is googleAccount");
    print(googleAccount);
    googleLoginButtonClick = false;
    if (googleAccount != null) {
      print("inside googleAccount if condition");
      final auth = await googleAccount.authentication;
      final idToken = auth.idToken;

      String fcmToken = await SharedPreferenceManager.getFCMToken() ?? "";
      print("below is idToken");
      print(idToken);
      print(googleAccount.authentication);
      // Send token to your Node.js backend for verification

      AuthenticationRestApiService authentication = AuthenticationRestApiService();
      String token = await authentication.generateToken();
      // final response = await http.post(Uri.parse("${ApiConstant.domain}/user/auth/google"),
      // final response = await http.post(Uri.parse("${ApiConstant.domain}/user/auth/googleSignUp"),

      // String url = "${ApiConstant.domain}/user/auth/googleSignIn";
      String url = "${ApiConstant.domain}/user/auth/google";

      // if(isSignup) {
      //   url = "${ApiConstant.domain}/user/auth/googleSignUp";
      // }
      final response = await http.post(Uri.parse("${url}"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': token,
          },
          body: json.encode({
            'google_token': idToken,
            'fcm_token': fcmToken,
          }));

      print("below is after response");
      print(response.body);
      if (httpStatusChecker(response)) {
        dynamic apiResponse = jsonDecode(response.body);

        LoginUserResponse data = LoginUserResponse().fromJson(apiResponse);

        print("before saving issuper");
        print(data.data!.isSuper);
        SharedPreferenceManager.saveUserAccessToken(data.data!.token ?? "");
        SharedPreferenceManager.saveIsSuper(data.data!.isSuper ?? false);

        return LoginUserResponse().fromJson(apiResponse);
      } else {
        throw HttpApiException(errorCode: 404);
      }
      if (response.statusCode == 200) {
        // _user = json.decode(response.body);
        notifyListeners();
        // return true;
      }
    }
    // return false;
  }

  Future<bool> loginWithFacebook() async {
    final fbResult = await LoginRestApiService().signInWithFacebook();
    if (fbResult != null) {
      final fbAccessToken = fbResult['accessToken'];

      // Send token to your Node.js backend for verification
      final response = await http.post(Uri.parse('backendUrl'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'provider': 'facebook', 'token': fbAccessToken}));

      if (response.statusCode == 200) {
        // _user = json.decode(response.body);
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  Future<LoginUserResponse> loginWithApple(bool isSignup) async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Store user data securely
      await secureStorage.write(key: 'userIdentifier', value: credential.userIdentifier);
      await secureStorage.write(key: 'email', value: credential.email);
      await secureStorage.write(key: 'name', value: credential.givenName ?? '');

      print("Signed in userIdentifier: ${credential.userIdentifier}");
      print("Signed in userToken: ${credential.identityToken}");
      print("Signed in as: ${credential.email}");

      if (credential.identityToken != "") {

        String fcmToken = await SharedPreferenceManager.getFCMToken() ?? "";
        // Send token to your Node.js backend for verification

        AuthenticationRestApiService authentication = AuthenticationRestApiService();
        String token = await authentication.generateToken();
        // final response = await http.post(Uri.parse("${ApiConstant.domain}/user/auth/google"),
        // final response = await http.post(Uri.parse("${ApiConstant.domain}/user/auth/googleSignUp"),

        // String url = "${ApiConstant.domain}/user/auth/googleSignIn";
        String url = "${ApiConstant.domain}/user/auth/apple";

        // if(isSignup) {
        //   url = "${ApiConstant.domain}/user/auth/googleSignUp";
        // }
        final response = await http.post(Uri.parse("${url}"),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': token,
            },
            body: json.encode({
              'apple_token': credential.identityToken,
              'fcm_token': fcmToken,
            }));

        print("below is after response");
        print(response.body);
        if (httpStatusChecker(response)) {
          dynamic apiResponse = jsonDecode(response.body);

          LoginUserResponse data = LoginUserResponse().fromJson(apiResponse);

          print("before saving issuper");
          print(data.data!.isSuper);
          SharedPreferenceManager.saveUserAccessToken(data.data!.token ?? "");
          SharedPreferenceManager.saveIsSuper(data.data!.isSuper ?? false);

          return LoginUserResponse().fromJson(apiResponse);
        } else {
          throw HttpApiException(errorCode: 404);
        }
        if (response.statusCode == 200) {
          // _user = json.decode(response.body);
          notifyListeners();
          // return true;
        }
      }

      return LoginUserResponse();
      // return true;
    } catch (error) {
      print("Apple Sign-In error: $error");

      return LoginUserResponse();
      // return false;
    }
  }

}