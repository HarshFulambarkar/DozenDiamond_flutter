
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../global/models/http_api_exception.dart';
import '../models/kotak_neo_login_response.dart';
import '../models/kotak_neo_otp_response.dart';
import '../services/kotak_neo_rest_api_service.dart';

class KotakNeoBrokersProvider extends ChangeNotifier {
  KotakNeoBrokersProvider(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  TextEditingController kotakNeoClientIdTextController = TextEditingController(text: "");
  TextEditingController kotakNeoClientPasswordTextController = TextEditingController(text: "");
  TextEditingController kotakNeoClientNumberTextController = TextEditingController(text: "");
  TextEditingController kotakNeoCUrlTextController = TextEditingController(text: "");
  TextEditingController kotakNeoClientApiPasswordTextController = TextEditingController(text: "");

  TextEditingController kotakNeoOtpTextController = TextEditingController(text: "");

  String _kotakNeoClientIdFieldError = "";

  String get kotakNeoClientIdFieldError => _kotakNeoClientIdFieldError;

  set kotakNeoClientIdFieldError(String value) {
    _kotakNeoClientIdFieldError = value;
    notifyListeners();
  }

  String _kotakNeoClientPasswordFieldError = "";

  String get kotakNeoClientPasswordFieldError =>
      _kotakNeoClientPasswordFieldError;

  set kotakNeoClientPasswordFieldError(String value) {
    _kotakNeoClientPasswordFieldError = value;
    notifyListeners();
  }

  String _kotakNeoClientNumberFieldError = "";

  String get kotakNeoClientNumberFieldError => _kotakNeoClientNumberFieldError;

  set kotakNeoClientNumberFieldError(String value) {
    _kotakNeoClientNumberFieldError = value;
    notifyListeners();
  }

  String _kotakNeoCUrlFieldError = "";

  String get kotakNeoCUrlFieldError => _kotakNeoCUrlFieldError;

  set kotakNeoCUrlFieldError(String value) {
    _kotakNeoCUrlFieldError = value;
    notifyListeners();
  }

  String _kotakNeoClientApiPasswordFieldError = "";

  String get kotakNeoClientApiPasswordFieldError =>
      _kotakNeoClientApiPasswordFieldError;

  set kotakNeoClientApiPasswordFieldError(String value) {
    _kotakNeoClientApiPasswordFieldError = value;
    notifyListeners();
  }

  String _kotakNeoOtpFieldError = "";

  String get kotakNeoOtpFieldError => _kotakNeoOtpFieldError;

  set kotakNeoOtpFieldError(String value) {
    _kotakNeoOtpFieldError = value;
    notifyListeners();
  }

  KotakNeoOtpResponse _otpResponse = KotakNeoOtpResponse();

  KotakNeoOtpResponse get otpResponse => _otpResponse;

  set otpResponse(KotakNeoOtpResponse value) {
    _otpResponse = value;
    notifyListeners();
  }

  Future<bool> sendKotakNeoOtp() async {
    try {

      Map<String, dynamic> request = {
        "client_id": kotakNeoClientIdTextController.text,
        "client_password": kotakNeoClientPasswordTextController.text,
        "client_api_password": kotakNeoClientApiPasswordTextController.text,
        "client_number": kotakNeoClientNumberTextController.text,
        "c_URL": kotakNeoCUrlTextController.text,
      };

      KotakNeoOtpResponse? res =
      await KotakNeoRestApiService().sendKotakNeoOtp(request);



      if(res.message!.toLowerCase() == "success") {
        otpResponse = res;
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

  Future<bool> doKotakNeoLogin() async {
    try {

      print(otpResponse.data!.subId);
      print(otpResponse.data!.rid);
      print(otpResponse.data!.sid);
      print(otpResponse.data!.token);
      print(otpResponse.data!.accessToken);
      print(kotakNeoOtpTextController.text);

      Map<String, dynamic> request = {
        "sub_id": otpResponse.data!.subId!,
        "rid": otpResponse.data!.rid!,
        "sid": otpResponse.data!.sid!,
        "token": otpResponse.data!.token!,
        "accessToken": otpResponse.data!.accessToken!,
        "otp": kotakNeoOtpTextController.text,
      };

      KotakNeoLoginResponse? res =
      await KotakNeoRestApiService().doKotakNeoLogin(request);



      if(res.message!.toLowerCase() == "success") {
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
}