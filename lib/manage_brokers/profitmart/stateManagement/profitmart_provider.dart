import 'package:dozen_diamond/manage_brokers/smc/models/smc_otp_response.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../global/models/http_api_exception.dart';
import '../models/profitmart_login_reponse.dart';
import '../services/profitmart_rest_api_service.dart';

class ProfitmartProvider extends ChangeNotifier {
  ProfitmartProvider(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  TextEditingController profitmartUserIdTextController = TextEditingController(text: "");
  TextEditingController profitmartPasswordTextController = TextEditingController(text: "");
  TextEditingController profitmartDOBTextController = TextEditingController(text: "");
  TextEditingController profitmartVendorCodeTextController = TextEditingController(text: "");
  TextEditingController profitmartVendorKeyTextController = TextEditingController(text: "");

  String _profitmartUserIdFieldError = "";

  String get profitmartUserIdFieldError => _profitmartUserIdFieldError;

  set profitmartUserIdFieldError(String value) {
    _profitmartUserIdFieldError = value;
    notifyListeners();
  }

  String _profitmartPasswordFieldError = "";

  String get profitmartPasswordFieldError => _profitmartPasswordFieldError;

  set profitmartPasswordFieldError(String value) {
    _profitmartPasswordFieldError = value;
    notifyListeners();
  }

  String _profitmartDOBFieldError = "";

  String get profitmartDOBFieldError => _profitmartDOBFieldError;

  set profitmartDOBFieldError(String value) {
    _profitmartDOBFieldError = value;
    notifyListeners();
  }

  String _profitmartVendorCodeFieldError = "";

  String get profitmartVendorCodeFieldError => _profitmartVendorCodeFieldError;

  set profitmartVendorCodeFieldError(String value) {
    _profitmartVendorCodeFieldError = value;
    notifyListeners();
  }

  String _profitmartVendorKeyFieldError = "";

  String get profitmartVendorKeyFieldError => _profitmartVendorKeyFieldError;

  set profitmartVendorKeyFieldError(String value) {
    _profitmartVendorKeyFieldError = value;
    notifyListeners();
  }

  bool _buttonLoading = false;

  bool get buttonLoading => _buttonLoading;

  set buttonLoading(bool value) {
    _buttonLoading = value;
    notifyListeners();
  }

  Future<bool> doProfitmartLogin() async {
    try {
      buttonLoading = true;
      print("before calling profitmart login");
      Map<String, dynamic> request = {
        "userid": profitmartUserIdTextController.text,
        "pwd": profitmartPasswordTextController.text,
        "factor2": profitmartDOBTextController.text,
        "vc": profitmartVendorCodeTextController.text,
        "vendor_key": profitmartVendorKeyTextController.text,
      };

      print("before calling profitmart login");

      ProfitmartLoginResponse? res =
      await ProfitmartRestApiService().doProfitmartLogin(request);

      print("after calling profitmart login");

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
