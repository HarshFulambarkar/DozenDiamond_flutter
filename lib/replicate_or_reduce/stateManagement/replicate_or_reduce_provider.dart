import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../global/models/http_api_exception.dart';
import '../model/reduce_response.dart';
import '../model/replicate_response.dart';
import '../services/rest_api_service.dart';

class ReplicateOrReduceProvider extends ChangeNotifier {
  ReplicateOrReduceProvider(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  String _selectedReplicateOrReduceOptions = "Replicate";

  String get selectedReplicateOrReduceOptions =>
      _selectedReplicateOrReduceOptions;

  set selectedReplicateOrReduceOptions(String value) {
    _selectedReplicateOrReduceOptions = value;
    notifyListeners();
  }

  String _selectedTradeId = "";

  String get selectedTradeId => _selectedTradeId;

  set selectedTradeId(String value) {
    _selectedTradeId = value;
    notifyListeners();
  }

  TextEditingController replicateUnitsTextEditingController = TextEditingController(text: "");
  TextEditingController replicateSellPriceTextEditingController = TextEditingController(text: "");

  String _replicateUnitesFieldErrorText = "";

  String get replicateUnitesFieldErrorText => _replicateUnitesFieldErrorText;

  set replicateUnitesFieldErrorText(String value) {
    _replicateUnitesFieldErrorText = value;
    notifyListeners();
  }

  String _replicateSellPriceFieldErrorText = "";

  String get replicateSellPriceFieldErrorText =>
      _replicateSellPriceFieldErrorText;

  set replicateSellPriceFieldErrorText(String value) {
    _replicateSellPriceFieldErrorText = value;
  }

  TextEditingController reduceUnitsTextEditingController = TextEditingController(text: "");
  TextEditingController reduceSellPriceTextEditingController = TextEditingController(text: "");

  String _reduceUnitesFieldErrorText = "";

  String get reduceUnitesFieldErrorText => _reduceUnitesFieldErrorText;

  set reduceUnitesFieldErrorText(String value) {
    _reduceUnitesFieldErrorText = value;
    notifyListeners();
  }

  String _reduceSellPriceFieldErrorText = "";

  String get reduceSellPriceFieldErrorText => _reduceSellPriceFieldErrorText;

  set reduceSellPriceFieldErrorText(String value) {
    _reduceSellPriceFieldErrorText = value;
    notifyListeners();
  }

  Future<bool> replicateTrade() async {
    try {

      Map<String, dynamic> request = {
        "trade_id": selectedTradeId,
        "unit": replicateUnitsTextEditingController.text,
        "follow_up_price": replicateSellPriceTextEditingController.text,
      };

      ReplicateResponse? res =
      await ReplicateOrReduceRestApiService().replicateTrade(request);

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

  Future<bool> reduceTrade() async {
    try {

      Map<String, dynamic> request = {
        "trade_id": selectedTradeId,
        "price": reduceSellPriceTextEditingController.text,
        "unit": reduceUnitsTextEditingController.text,
      };

      ReduceResponse? res =
      await ReplicateOrReduceRestApiService().reduceTrade(request);

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