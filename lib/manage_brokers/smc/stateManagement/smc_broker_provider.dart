
import 'package:dozen_diamond/manage_brokers/smc/models/smc_otp_response.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../global/models/http_api_exception.dart';
import '../models/smc_login_response.dart';
import '../models/smc_secret_key_response.dart';
import '../services/smc_rest_api_service.dart';

class SmcBrokersProvider extends ChangeNotifier {
  SmcBrokersProvider(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  TextEditingController smcClientIdTextController = TextEditingController(text: "");
  TextEditingController smcPasswordTextController = TextEditingController(text: "");
  TextEditingController smcApiKeyTextController = TextEditingController(text: "");

  TextEditingController smcOtpTextController = TextEditingController(text: "");

  TextEditingController smcSecretKeyTextController = TextEditingController(text: "");

  String _smcClientIdFieldError = "";

  String get smcClientIdFieldError => _smcClientIdFieldError;

  set smcClientIdFieldError(String value) {
    _smcClientIdFieldError = value;
    notifyListeners();
  }

  String _smcPasswordFieldError = "";

  String get smcPasswordFieldError => _smcPasswordFieldError;

  set smcPasswordFieldError(String value) {
    _smcPasswordFieldError = value;
    notifyListeners();
  }

  String _smcApiKeyFieldError = "";

  String get smcApiKeyFieldError => _smcApiKeyFieldError;

  set smcApiKeyFieldError(String value) {
    _smcApiKeyFieldError = value;
    notifyListeners();
  }

  String _smcOtpFieldError = "";

  String get smcOtpFieldError => _smcOtpFieldError;

  set smcOtpFieldError(String value) {
    _smcOtpFieldError = value;
    notifyListeners();
  }

  String _smcSecretKeyFieldError = "";


  String get smcSecretKeyFieldError => _smcSecretKeyFieldError;

  set smcSecretKeyFieldError(String value) {
    _smcSecretKeyFieldError = value;
    notifyListeners();
  }

  Future<bool> sendSmcOtp() async {
    try {

      Map<String, dynamic> request = {
        "client_id": smcClientIdTextController.text,
        "password": smcPasswordTextController.text,
        "api_key": smcApiKeyTextController.text,
      };

      SmcOtpResponse? res =
      await SmcRestApiService().sendSmcOtp(request);



      if(res.message!.toLowerCase() == "success") {
        // otpResponse = res;
        Fluttertoast.showToast(msg: res.message ?? "");
        return true;
      } else {
        return false;
      }

      return false;

    } on HttpApiException catch (err) {
      print(err.errorSuggestion);
      print(err.errorTitle);
      print(err.errorCode);
      Fluttertoast.showToast(msg: err.errorTitle);
      return false;
    }
  }

  Future<bool> sendSmcSecretKey() async {
    try {

      Map<String, dynamic> request = {
        "client_id": smcClientIdTextController.text,
        "api_key": smcApiKeyTextController.text,
        "otp": smcOtpTextController.text,
      };

      SmcSecretKeyResponse? res =
      await SmcRestApiService().sendSmcSecretKey(request);



      if(res.message!.toLowerCase() == "success") {
        // otpResponse = res;
        Fluttertoast.showToast(msg: res.message ?? "");
        return true;
      } else {
        return false;
      }

      return false;

    } on HttpApiException catch (err) {
      print(err.errorSuggestion);
      print(err.errorTitle);
      print(err.errorCode);
      Fluttertoast.showToast(msg: err.errorTitle);
      return false;
    }
  }

  Future<bool> doSmcLogin() async {
    try {

      Map<String, dynamic> request = {
        "secret_key": smcSecretKeyTextController.text,
        "api_key": smcApiKeyTextController.text,

      };

      SmcLoginResponse? res =
      await SmcRestApiService().doSmcLogin(request);

      if(res.message!.toLowerCase() == "access token generated successfully") {
        Fluttertoast.showToast(msg: res.message ?? "");
        return true;
      } else {
        return false;
      }

      return false;

    } on HttpApiException catch (err) {
      print(err.errorSuggestion);
      print(err.errorTitle);
      print(err.errorCode);
      Fluttertoast.showToast(msg: err.errorTitle);
      return false;
    }
  }
}