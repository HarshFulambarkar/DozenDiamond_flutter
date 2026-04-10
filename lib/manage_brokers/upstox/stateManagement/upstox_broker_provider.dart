
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../global/models/http_api_exception.dart';
import '../models/upstox_login_response.dart';
import '../services/upstox_rest_api_service.dart';

class UpstoxBrokersProvider extends ChangeNotifier {
  UpstoxBrokersProvider(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  TextEditingController upstoxClientIdTextController = TextEditingController(text: "");
  TextEditingController upstoxSecretKeyTextController = TextEditingController(text: "");
  TextEditingController upstoxCodeTextController = TextEditingController(text: "");

  String _upstoxClientIdFieldError = "";

  String get upstoxClientIdFieldError => _upstoxClientIdFieldError;

  set upstoxClientIdFieldError(String value) {
    _upstoxClientIdFieldError = value;
    notifyListeners();
  }

  String _upstoxSecretKeyFieldError = "";

  String get upstoxSecretKeyFieldError => _upstoxSecretKeyFieldError;

  set upstoxSecretKeyFieldError(String value) {
    _upstoxSecretKeyFieldError = value;
    notifyListeners();
  }

  String _upstoxCodeFieldError = "";

  String get upstoxCodeFieldError => _upstoxCodeFieldError;

  set upstoxCodeFieldError(String value) {
    _upstoxCodeFieldError = value;
    notifyListeners();
  }


  Future<bool> doUpstoxLogin() async {
    try {

      Map<String, dynamic> request = {
        "client_id": upstoxClientIdTextController.text,
        "client_secret": upstoxSecretKeyTextController.text,
        "code": upstoxCodeTextController.text,
      };

      UpstoxLoginResponse? res =
      await UpstoxRestApiService().doUpstoxLogin(request);



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