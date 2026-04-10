import 'package:dozen_diamond/manage_brokers/smc/models/smc_otp_response.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../global/models/http_api_exception.dart';
import '../models/zerodha_login_response.dart';
import '../services/zerodha_rest_api_service.dart';

class ZerodhaProvider extends ChangeNotifier {
  ZerodhaProvider(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  TextEditingController zerodhaApiKeyTextController = TextEditingController(text: "");
  TextEditingController zerodhaApiSecretTextController = TextEditingController(text: "");
  TextEditingController zerodhaRquestTokenTextController = TextEditingController(text: "");

  String _zerodhaApiKeyFieldError = "";

  String get zerodhaApiKeyFieldError => _zerodhaApiKeyFieldError;

  set zerodhaApiKeyFieldError(String value) {
    _zerodhaApiKeyFieldError = value;
    notifyListeners();
  }

  String _zerodhaApiSecretFieldError = "";

  String get zerodhaApiSecretFieldError => _zerodhaApiSecretFieldError;

  set zerodhaApiSecretFieldError(String value) {
    _zerodhaApiSecretFieldError = value;
    notifyListeners();
  }

  String _zerodhaRquestTokenFieldError = "";

  String get zerodhaRquestTokenFieldError => _zerodhaRquestTokenFieldError;

  set zerodhaRquestTokenFieldError(String value) {
    _zerodhaRquestTokenFieldError = value;
    notifyListeners();
  }

  bool _buttonLoading = false;

  bool get buttonLoading => _buttonLoading;

  set buttonLoading(bool value) {
    _buttonLoading = value;
    notifyListeners();
  }

  String _baseUrl = "https://kite.zerodha.com/connect/login?api_key=";

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

  Future<bool> doZerodhaLogin() async {
    try {
      buttonLoading = true;
      print("before calling zerodha login");
      Map<String, dynamic> request = {
        "api_key": zerodhaApiKeyTextController.text,
        "api_secret": zerodhaApiSecretTextController.text,
        "request_token": zerodhaRquestTokenTextController.text,
      };

      print("before calling zerodha login");

      ZerodhaLoginResponse? res =
      await ZerodhaRestApiService().doZerodhaLogin(request);

      print("after calling zerodha login");

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
