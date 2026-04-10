import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../global/models/http_api_exception.dart';
import '../models/shoonya_login_reponse.dart';
import '../services/shoonya_rest_api_service.dart';

class ShoonyaBrokersProvider extends ChangeNotifier {
  ShoonyaBrokersProvider(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  bool _buttonLoading = false;

  bool get buttonLoading => _buttonLoading;

  set buttonLoading(bool value) {
    _buttonLoading = value;
    notifyListeners();
  }

  TextEditingController shoonyaUserIdTextController = TextEditingController();
  TextEditingController shoonyaPasswordTextController = TextEditingController();
  TextEditingController shoonyaTotpSecretTextController = TextEditingController();
  TextEditingController shoonyaVendorCodeTextController = TextEditingController();
  TextEditingController shoonyaApiKeyTextController = TextEditingController();
  TextEditingController shoonyaIMEITextController = TextEditingController();

  String _shoonyaUserIdFieldError = "";

  String get shoonyaUserIdFieldError => _shoonyaUserIdFieldError;

  set shoonyaUserIdFieldError(String value) {
    _shoonyaUserIdFieldError = value;
    notifyListeners();
  }

  String _shoonyaPasswordFieldError = "";

  String get shoonyaPasswordFieldError => _shoonyaPasswordFieldError;

  set shoonyaPasswordFieldError(String value) {
    _shoonyaPasswordFieldError = value;
    notifyListeners();
  }

  String _shoonyaTotpSecretFieldError = "";

  String get shoonyaTotpSecretFieldError => _shoonyaTotpSecretFieldError;

  set shoonyaTotpSecretFieldError(String value) {
    _shoonyaTotpSecretFieldError = value;
    notifyListeners();
  }

  String _shoonyaVendorCodeFieldError = "";

  String get shoonyaVendorCodeFieldError => _shoonyaVendorCodeFieldError;

  set shoonyaVendorCodeFieldError(String value) {
    _shoonyaVendorCodeFieldError = value;
    notifyListeners();
  }

  String _shoonyaApiKeyFieldError = "";

  String get shoonyaApiKeyFieldError => _shoonyaApiKeyFieldError;

  set shoonyaApiKeyFieldError(String value) {
    _shoonyaApiKeyFieldError = value;
    notifyListeners();
  }

  String _shoonyaIMEIFieldError = "";

  String get shoonyaIMEIFieldError => _shoonyaIMEIFieldError;

  set shoonyaIMEIFieldError(String value) {
    _shoonyaIMEIFieldError = value;
    notifyListeners();
  }

  Future<bool> doShoonyaLogin() async {
    try {
      buttonLoading = true;
      Map<String, dynamic> request = {
        "userid": shoonyaUserIdTextController.text,
        "pwd": shoonyaPasswordTextController.text,
        "totp_secret": shoonyaTotpSecretTextController.text,
        "vc": shoonyaVendorCodeTextController.text,
        "apiKey": shoonyaApiKeyTextController.text,
        "imei": shoonyaIMEITextController.text,
      };


      ShoonyaLoginResponse? res =
      await ShoonyaRestApiService().doShoonyaLogin(request);

      if (res.message!.toLowerCase() == "success" || res.message!.toLowerCase() == "shoonya login successful") {
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

}