import 'package:dozen_diamond/manage_brokers/smc/models/smc_otp_response.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../global/models/http_api_exception.dart';
import '../models/sharekhan_login_response.dart';
import '../services/sharekhan_rest_api_service.dart';

class SharekhanProvider extends ChangeNotifier {
  SharekhanProvider(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  TextEditingController sharekhanApiKeyTextController = TextEditingController(
    text: "",
  );
  TextEditingController sharekhanSecretKeyTextController =
  TextEditingController(text: "");
  TextEditingController sharekhanLoginIdTextController = TextEditingController(
    text: "",
  );
  TextEditingController sharekhanTotpSecretTextController =
  TextEditingController(text: "");

  TextEditingController sharekhanPasswordTextController = TextEditingController(
    text: "",
  );

  String _sharekhanApiKeyFieldError = "";

  String get sharekhanApiKeyFieldError => _sharekhanApiKeyFieldError;

  set sharekhanApiKeyFieldError(String value) {
    _sharekhanApiKeyFieldError = value;
    notifyListeners();
  }

  String _sharekhanSecretKeyFieldError = "";

  String get sharekhanSecretKeyFieldError => _sharekhanSecretKeyFieldError;

  set sharekhanSecretKeyFieldError(String value) {
    _sharekhanSecretKeyFieldError = value;
    notifyListeners();
  }

  String _sharekhanLoginIdFieldError = "";

  String get sharekhanLoginIdFieldError => _sharekhanLoginIdFieldError;

  set sharekhanLoginIdFieldError(String value) {
    _sharekhanLoginIdFieldError = value;
    notifyListeners();
  }

  String _sharekhanTotpSecretFieldError = "";

  String get sharekhanTotpSecretFieldError => _sharekhanTotpSecretFieldError;

  set sharekhanTotpSecretFieldError(String value) {
    _sharekhanTotpSecretFieldError = value;
    notifyListeners();
  }

  String _sharekhanPasswordFieldError = "";

  String get sharekhanPasswordFieldError => _sharekhanPasswordFieldError;

  set sharekhanPasswordFieldError(String value) {
    _sharekhanPasswordFieldError = value;
    notifyListeners();
  }

  bool _buttonLoading = false;

  bool get buttonLoading => _buttonLoading;

  set buttonLoading(bool value) {
    _buttonLoading = value;
    notifyListeners();
  }

  String _baseUrl =
      "https://api.sharekhan.com/skapi/auth/login.html?state=12345&version_id=1005&api_key=";

  String get baseUrl => _baseUrl;

  set baseUrl(String value) {
    _baseUrl = value;
    notifyListeners();
  }

  String _redirectUrl = "";

  String get redirectUrl => _redirectUrl;

  set redirectUrl(String value) {
    _redirectUrl = value;
    notifyListeners();
  }

  Future<bool> doSharekhanLogin() async {
    try {
      buttonLoading = true;
      print("before calling sharekhan login");
      Map<String, dynamic> request = {
        "apiKey": sharekhanApiKeyTextController.text,
        "secretKey": sharekhanSecretKeyTextController.text,
        "loginId": sharekhanLoginIdTextController.text,
        "password": sharekhanPasswordTextController.text,
        "totpSecret": sharekhanTotpSecretTextController.text,
        "versionId": "1005",
        "state": "12345",
      };

      print("before calling sharekhan login");

      SharekhanLoginResponse? res = await SharekhanRestApiService()
          .doSharekhanLogin(request);

      print("after calling sharekhan login");

      if (res.message!.toLowerCase() == "success") {
        buttonLoading = false;
        Fluttertoast.showToast(msg: res.message ?? "");
        return true;
      } else {
        buttonLoading = false;
        return false;
      }

      return false;
    } on HttpApiException catch (err) {
      buttonLoading = false;
      print(err.errorSuggestion);
      print(err.errorTitle);
      print(err.errorCode);
      Fluttertoast.showToast(msg: err.errorTitle);
      return false;
    }
  }

// Future<bool> doAngleOneLogout() async {
//   try {
//     Map<String, dynamic> request = {
//       "clientcode": angleOneClientCodeTextController.text,
//     };
//
//     AngleOneLogoutResponse? res =
//     await AngleOneRestApiService().doAngleOneLogout(request);
//
//     if (res.message!.toLowerCase() == "access token generated successfully") {
//       Fluttertoast.showToast(msg: res.message ?? "");
//       return true;
//     } else {
//       return false;
//     }
//
//     return false;
//   } on HttpApiException catch (err) {
//     print(err.errorSuggestion);
//     print(err.errorTitle);
//     print(err.errorCode);
//     Fluttertoast.showToast(msg: err.errorTitle);
//     return false;
//   }
// }
}