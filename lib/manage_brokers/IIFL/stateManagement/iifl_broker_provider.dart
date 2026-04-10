
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../global/models/http_api_exception.dart';
import '../models/iifl_login_response.dart';
import '../services/iifl_rest_api_service.dart';

class IIFLBrokersProvider extends ChangeNotifier {

  IIFLBrokersProvider(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  TextEditingController iiflClientIdTextController = TextEditingController(text: "");
  TextEditingController iiflSecretKeyTextController = TextEditingController(text: "");
  TextEditingController iiflCodeTextController = TextEditingController(text: "");

  String _iiflClientIdFieldError = "";

  String get iiflClientIdFieldError => _iiflClientIdFieldError;

  set iiflClientIdFieldError(String value) {
    _iiflClientIdFieldError = value;
    notifyListeners();
  }

  String _iiflSecretKeyFieldError = "";

  String get iiflSecretKeyFieldError => _iiflSecretKeyFieldError;

  set iiflSecretKeyFieldError(String value) {
    _iiflSecretKeyFieldError = value;
    notifyListeners();
  }

  String _iiflCodeFieldError = "";

  String get iiflCodeFieldError => _iiflCodeFieldError;

  set iiflCodeFieldError(String value) {
    _iiflCodeFieldError = value;
    notifyListeners();
  }


  Future<bool> doIiflLogin() async {
    try {

      Map<String, dynamic> request = {
        "client_id": iiflClientIdTextController.text,
        "client_secret": iiflSecretKeyTextController.text,
        "code": iiflCodeTextController.text,
      };

      IiflLoginResponse? res =
      await IiflRestApiService().doIiflLogin(request);



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