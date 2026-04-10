import 'package:dozen_diamond/manage_brokers/smc/models/smc_otp_response.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../global/models/http_api_exception.dart';
import '../models/angle_one_login_response.dart';
import '../models/angle_one_logout_response.dart';
import '../services/angle_one_rest_api_service.dart';

class AngleOneBrokersProvider extends ChangeNotifier {
  AngleOneBrokersProvider(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  TextEditingController angleOneClientCodeTextController =
      TextEditingController(text: "");
  TextEditingController angleOnePasswordTextController =
      TextEditingController(text: "");
  TextEditingController angleOneApiKeyTextController =
      TextEditingController(text: "");
  // TextEditingController angleOneTotpKeyTextController = TextEditingController(text: "");
  TextEditingController angleOneQRKeyTextController = TextEditingController(text: "");

  String _angleOneClientCodeFieldError = "";

  String get angleOneClientCodeFieldError => _angleOneClientCodeFieldError;

  set angleOneClientCodeFieldError(String value) {
    _angleOneClientCodeFieldError = value;
    notifyListeners();
  }

  String _angleOnePasswordFieldError = "";

  String get angleOnePasswordFieldError => _angleOnePasswordFieldError;

  set angleOnePasswordFieldError(String value) {
    _angleOnePasswordFieldError = value;
    notifyListeners();
  }

  String _angleOneApiKeyFieldError = "";

  String get angleOneApiKeyFieldError => _angleOneApiKeyFieldError;

  set angleOneApiKeyFieldError(String value) {
    _angleOneApiKeyFieldError = value;
    notifyListeners();
  }

  String _angleOneTotpFieldError = "";

  String get angleOneTotpFieldError => _angleOneTotpFieldError;

  set angleOneTotpFieldError(String value) {
    _angleOneTotpFieldError = value;
    notifyListeners();
  }

  bool _buttonLoading = false;

  bool get buttonLoading => _buttonLoading;

  set buttonLoading(bool value) {
    _buttonLoading = value;
    notifyListeners();
  }

  Future<bool> doAngleOneLogin() async {
    try {
      buttonLoading = true;
      print("before calling angle one login");
      Map<String, dynamic> request = {
        "client_code": angleOneClientCodeTextController.text,
        "password": angleOnePasswordTextController.text,
        "api_key": angleOneApiKeyTextController.text,
        // "totp": angleOneTotpKeyTextController.text,
        "qr_key": angleOneQRKeyTextController.text,
      };

      print("before calling angle one login");

      AngleOneLoginResponse? res =
          await AngleOneRestApiService().doAngleOneLogin(request);

      print("after calling angle one login");

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

  Future<bool> doAngleOneLogout() async {
    try {
      Map<String, dynamic> request = {
        "clientcode": angleOneClientCodeTextController.text,
      };

      AngleOneLogoutResponse? res =
          await AngleOneRestApiService().doAngleOneLogout(request);

      if (res.message!.toLowerCase() == "access token generated successfully") {
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
