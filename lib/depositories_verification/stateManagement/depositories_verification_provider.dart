import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../global/models/http_api_exception.dart';
import '../models/check_depositories_verification_status_response.dart';
import '../models/get_depositories_verification_status_response.dart';
import '../services/depositories_verification_rest_api_service.dart';

class DepositoriesVerificationProvider extends ChangeNotifier {
  DepositoriesVerificationProvider(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  String _depositoriesVerificationStatus = "not_authorized";

  String get depositoriesVerificationStatus => _depositoriesVerificationStatus;

  set depositoriesVerificationStatus(String value) {
    _depositoriesVerificationStatus = value;
    notifyListeners();
  }

  String _depositoriesVerificationMessage = "Not Authorized";

  String get depositoriesVerificationMessage =>
      _depositoriesVerificationMessage;

  set depositoriesVerificationMessage(String value) {
    _depositoriesVerificationMessage = value;
    notifyListeners();
  }

  Future<bool> getDepositoriesVerificationStatus() async {
    try {
      // Map<String, dynamic> request = {
      //   "client_code": angleOneClientCodeTextController.text,
      //   "password": angleOnePasswordTextController.text,
      //   "api_key": angleOneApiKeyTextController.text,
      //   "totp": angleOneTotpKeyTextController.text,
      // };

      GetDepositoriesVerificationStatusResponse? res =
      await DepositoriesVerificationRestApiService().getDepositoriesVerificationStatus();

      if(res.status == null) {
        return false;
      }

      if (res.status!) {
        // Fluttertoast.showToast(msg: res.message ?? "");
        depositoriesVerificationStatus = res.data!.brokerStatus ?? "not_authorized";
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

  Future<bool> checkDepositoriesVerificationStatus() async {
    try {
      Map<String, dynamic> request = {
        "nsdl_csdl_status": "YES",
      };

      CheckDepositoriesVerificationStatusResponse? res =
      await DepositoriesVerificationRestApiService().checkDepositoriesVerificationStatus(request);

      if (res.status!) {
        // Fluttertoast.showToast(msg: res.message ?? "");
        depositoriesVerificationStatus = res.data!.brokerStatus ?? "not_authorized";

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