import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/broker_totp_response.dart';
import '../models/http_api_exception.dart';
import '../models/user_config_data.dart';
import '../models/user_config_data_response.dart';
import '../services/global_rest_api_service.dart';

class UserConfigProvider extends ChangeNotifier {
  UserConfigProvider(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  UserConfigData _userConfigData = UserConfigData();

  UserConfigData get userConfigData => _userConfigData;

  set userConfigData(UserConfigData value) {
    _userConfigData = value;
    notifyListeners();
  }

  TextEditingController brokerTotpController = TextEditingController();

  String _brokerTotpError = "";

  String get brokerTotpError => _brokerTotpError;

  set brokerTotpError(String value) {
    _brokerTotpError = value;
    notifyListeners();
  }

  Future<void> getUserConfigData() async {

    print("inside getUserConfigData");
    try {

      UserConfigDataResponse? res =
      await GlobalRestApiService().getUserConfigData();

      if(res.status!) {
        userConfigData = res.data!;
      } else {

      }
    } catch (e) {

      throw e;
    }

  }

  Future<bool> submitBrokerTotp(BuildContext context) async {
    try {
      Map<String, dynamic> request = {
        "totp": brokerTotpController.text,
      };

      BrokerTotpResponse? res =
      await GlobalRestApiService().submitBrokerTotp(request);

      if (res.message!.toLowerCase() == "success") {
        brokerTotpController.clear();
        Navigator.pop(context);
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