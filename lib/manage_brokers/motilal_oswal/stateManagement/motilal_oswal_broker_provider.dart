
import 'package:dozen_diamond/manage_brokers/motilal_oswal/models/motilal_oswal_login_response.dart';
import 'package:dozen_diamond/manage_brokers/motilal_oswal/models/motilal_oswal_logout_response.dart';
import 'package:dozen_diamond/manage_brokers/motilal_oswal/models/motilal_oswal_verify_otp_response.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../global/models/http_api_exception.dart';
import '../services/motilal_oswal_rest_api_service.dart';

class MotilalOswalBrokersProvider extends ChangeNotifier {
  MotilalOswalBrokersProvider(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  TextEditingController motilalOswalUserIdTextController = TextEditingController(text: "");
  TextEditingController motilalOswalPasswordTextController = TextEditingController(text: "");
  TextEditingController motilalOswalTwoFATextController = TextEditingController(text: "");
  TextEditingController motilalOswalApiKeyTextController = TextEditingController(text: "");

  TextEditingController motilalOswalOtpTextController = TextEditingController(text: "");

  String _motilalOswalUserIdFieldError = "";

  String get motilalOswalUserIdFieldError => _motilalOswalUserIdFieldError;

  set motilalOswalUserIdFieldError(String value) {
    _motilalOswalUserIdFieldError = value;
    notifyListeners();
  }

  String _motilalOswalPasswordFieldError = "";

  String get motilalOswalPasswordFieldError => _motilalOswalPasswordFieldError;

  set motilalOswalPasswordFieldError(String value) {
    _motilalOswalPasswordFieldError = value;
    notifyListeners();
  }

  String _motilalOswalTwoFAFieldError = "";

  String get motilalOswalTwoFAFieldError => _motilalOswalTwoFAFieldError;

  set motilalOswalTwoFAFieldError(String value) {
    _motilalOswalTwoFAFieldError = value;
    notifyListeners();
  }

  String _motilalOswalApiKeyFieldError = "";

  String get motilalOswalApiKeyFieldError => _motilalOswalApiKeyFieldError;

  set motilalOswalApiKeyFieldError(String value) {
    _motilalOswalApiKeyFieldError = value;
    notifyListeners();
  }

  String _motilalOswalOtpFieldError = "";

  String get motilalOswalOtpFieldError => _motilalOswalOtpFieldError;

  set motilalOswalOtpFieldError(String value) {
    _motilalOswalOtpFieldError = value;
    notifyListeners();
  }

  MotilalOswalLoginResponse _motilalOswalLoginResponse = MotilalOswalLoginResponse();

  MotilalOswalLoginResponse get motilalOswalLoginResponse =>
      _motilalOswalLoginResponse;

  set motilalOswalLoginResponse(MotilalOswalLoginResponse value) {
    _motilalOswalLoginResponse = value;
  }

  Future<bool> motilalOswalLogin() async {
    try {

      Map<String, dynamic> request = {
        "userid": motilalOswalUserIdTextController.text,
        "password": motilalOswalPasswordTextController.text,
        "twoFA": motilalOswalTwoFATextController.text,
        "apiKey": motilalOswalApiKeyTextController.text,
      };

      MotilalOswalLoginResponse? res =
      await MotilalOswalRestApiService().motilalOswalLogin(request);



      if(res.message!.toLowerCase() == "success") {
        motilalOswalLoginResponse = res;
        Fluttertoast.showToast(msg: res.message ?? "");
        return true;
      } else {
        return false;
      }

    } on HttpApiException catch (err) {
      print(err.errorSuggestion);
      print(err.errorTitle);
      print(err.errorCode);
      Fluttertoast.showToast(msg: err.errorTitle);
      return false;
    }
  }

  Future<bool> motilalOswalVerifyOtp() async {
    try {

      Map<String, dynamic> request = {
        "otp": motilalOswalOtpTextController.text,
      };

      MotilalOswalVerifyOtpResponse? res =
      await MotilalOswalRestApiService().motilalOswalVerifyOtp(request);



      if(res.message!.toLowerCase() == "SuccessFully Login in MotilalOswal") {
        Fluttertoast.showToast(msg: res.message ?? "");
        return true;
      } else {
        return false;
      }

    } on HttpApiException catch (err) {
      print(err.errorSuggestion);
      print(err.errorTitle);
      print(err.errorCode);
      Fluttertoast.showToast(msg: err.errorTitle);
      return false;
    }
  }

  Future<bool> doMotilalOswalLogout() async {
    try {

      Map<String, dynamic> request = {


      };

      MotilalOswalLogoutResponse? res =
      await MotilalOswalRestApiService().doMotilalOswalLogout(request);

      if(res.message!.toLowerCase() == "logout successfull") {
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