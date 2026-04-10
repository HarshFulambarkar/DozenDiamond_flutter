import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../global/models/http_api_exception.dart';
import '../models/paach_paisa_customer_access_token_response.dart';
import '../models/paach_paisa_customer_request_token_response.dart';
import '../services/paach_paisa_rest_api_service.dart';

class PaachPaisaBrokersProvider extends ChangeNotifier {
  PaachPaisaBrokersProvider(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  TextEditingController paachPaisaClientIdTextController = TextEditingController(text: "");
  TextEditingController paachPaisaApiKeyTextController = TextEditingController(text: "");
  TextEditingController paachPaisaTotpTextController = TextEditingController(text: "");
  TextEditingController paachPaisaPinTextController = TextEditingController(text: "");

  TextEditingController paachPaisaKeyTextController = TextEditingController(text: "");
  TextEditingController paachPaisaEncryKeyTextController = TextEditingController(text: "");
  TextEditingController paachPaisaUserIdTextController = TextEditingController(text: "");

  String _paachPaisaClientIdFieldError = "";

  String get paachPaisaClientIdFieldError => _paachPaisaClientIdFieldError;

  set paachPaisaClientIdFieldError(String value) {
    _paachPaisaClientIdFieldError = value;
    notifyListeners();
  }

  String _paachPaisaApiKeyFieldError = "";

  String get paachPaisaApiKeyFieldError => _paachPaisaApiKeyFieldError;

  set paachPaisaApiKeyFieldError(String value) {
    _paachPaisaApiKeyFieldError = value;
    notifyListeners();
  }

  String _paachPaisaTotpFieldError = "";

  String get paachPaisaTotpFieldError => _paachPaisaTotpFieldError;

  set paachPaisaTotpFieldError(String value) {
    _paachPaisaTotpFieldError = value;
    notifyListeners();
  }

  String _paachPaisaPinFieldError = "";

  String get paachPaisaPinFieldError => _paachPaisaPinFieldError;

  set paachPaisaPinFieldError(String value) {
    _paachPaisaPinFieldError = value;
    notifyListeners();
  }

  String _paachPaisaKeyFieldError = "";

  String get paachPaisaKeyFieldError => _paachPaisaKeyFieldError;

  set paachPaisaKeyFieldError(String value) {
    _paachPaisaKeyFieldError = value;
    notifyListeners();
  }

  String _paachPaisaEncryKeyFieldError = "";

  String get paachPaisaEncryKeyFieldError => _paachPaisaEncryKeyFieldError;

  set paachPaisaEncryKeyFieldError(String value) {
    _paachPaisaEncryKeyFieldError = value;
    notifyListeners();
  }

  String _paachPaisaUserIdFieldError = "";

  String get paachPaisaUserIdFieldError => _paachPaisaUserIdFieldError;

  set paachPaisaUserIdFieldError(String value) {
    _paachPaisaUserIdFieldError = value;
    notifyListeners();
  }

  Future<bool> sendPaachPaisaOtp() async {
    try {

      Map<String, dynamic> request = {
        "Email_ID": paachPaisaClientIdTextController.text,
        "Key": paachPaisaApiKeyTextController.text,
        "TOTP": paachPaisaTotpTextController.text,
        "PIN": paachPaisaPinTextController.text,
      };

      PaachPaiseCustomerRequestTokenResponse? res =
      await PaachPaisaRestApiService().sendPaachPaisaOtp(request);



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

  Future<bool> doPaachPaisaLogin() async {
    try {

      Map<String, dynamic> request = {
        "Key": paachPaisaKeyTextController.text,
        "EncryKey": paachPaisaEncryKeyTextController.text,
        "UserId": paachPaisaUserIdTextController.text
      };

      PaachPaiseCustomerAccessTokenResponse? res =
      await PaachPaisaRestApiService().doPaachPaisaLogin(request);



      if(res.message!.toLowerCase() == "success") {
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