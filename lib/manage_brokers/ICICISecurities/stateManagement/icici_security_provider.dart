
import 'package:dozen_diamond/manage_brokers/ICICISecurities/models/icici_securities_login_response.dart';
import 'package:dozen_diamond/manage_brokers/ICICISecurities/services/icici_securities_rest_api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../global/models/http_api_exception.dart';

class IciciSecurityBrokersProvider extends ChangeNotifier {

  IciciSecurityBrokersProvider(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  TextEditingController iciciSecurityApiKeyTextController = TextEditingController(text: "");
  TextEditingController iciciSecurityApiSecretKeyTextController = TextEditingController(text: "");
  TextEditingController iciciSecurityApiSessionKeyTextController = TextEditingController(text: "");

  String _iciciSecurityApiKeyFieldError = "";

  String get iciciSecurityApiKeyFieldError => _iciciSecurityApiKeyFieldError;

  set iciciSecurityApiKeyFieldError(String value) {
    _iciciSecurityApiKeyFieldError = value;
    notifyListeners();
  }

  String _iciciSecurityApiSecretKeyFieldError = "";

  String get iciciSecurityApiSecretKeyFieldError =>
      _iciciSecurityApiSecretKeyFieldError;

  set iciciSecurityApiSecretKeyFieldError(String value) {
    _iciciSecurityApiSecretKeyFieldError = value;
    notifyListeners();
  }

  String _iciciSecurityApiSessionKeyFieldError = "";


  String get iciciSecurityApiSessionKeyFieldError =>
      _iciciSecurityApiSessionKeyFieldError;

  set iciciSecurityApiSessionKeyFieldError(String value) {
    _iciciSecurityApiSessionKeyFieldError = value;
    notifyListeners();
  }

  Future<bool> doIciciSecurityLogin() async {
    try {

      Map<String, dynamic> request = {
        "api_key": iciciSecurityApiKeyTextController.text,
        "api_secret_key": iciciSecurityApiSecretKeyTextController.text,
        "api_session_key": iciciSecurityApiSessionKeyTextController.text,
      };

      IciciSecuritiesLoginResponse? res =
      await IciciSecuritiesRestApiService().doIciciSecuritiesLogin(request);



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