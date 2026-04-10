import 'dart:developer';

import 'package:dozen_diamond/broker_info/models/get_customer_funds_and_margins_response.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../global/models/http_api_exception.dart';
import '../models/funds_and_margins_data.dart';
import '../models/get_all_holdings_response.dart';
import '../models/get_customer_profile_response.dart';
import '../models/get_holdings_response.dart';
import '../models/holding_data.dart';
import '../services/broker_info_rest_api_service.dart';

class BrokerInfoProvider extends ChangeNotifier {
  BrokerInfoProvider(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  String _selectedTab = "Profile"; // "Holdings", "Funds & Margins"

  String get selectedTab => _selectedTab;

  set selectedTab(String value) {
    _selectedTab = value;
    notifyListeners();
  }

  ProfileData _brokerProfileData = ProfileData();

  ProfileData get brokerProfileData => _brokerProfileData;

  set brokerProfileData(ProfileData value) {
    _brokerProfileData = value;
    notifyListeners();
  }

  FundsAndMarginsData _fundsAndMarginsData = FundsAndMarginsData();

  FundsAndMarginsData get fundsAndMarginsData => _fundsAndMarginsData;

  set fundsAndMarginsData(FundsAndMarginsData value) {
    _fundsAndMarginsData = value;
    notifyListeners();
  }

  List<HoldingData> _holdingData = <HoldingData>[];

  List<HoldingData> get holdingData => _holdingData;

  set holdingData(List<HoldingData> value) {
    _holdingData = value;
    notifyListeners();
  }

  bool _closeTimer = false;

  bool get closeTimer => _closeTimer;

  set closeTimer(bool value) {
    _closeTimer = value;
    notifyListeners();
  }

  Future<bool> getHoldings() async {
    try {

      Map<String, dynamic> request = {
        "key": "value",
      };

      GetHoldingsResponse? res =
      await BrokerInfoRestApiService().getHoldings();

      if(res!.data!.message!.toLowerCase() == "success") {
        holdingData = res.data!.data!;
        // Fluttertoast.showToast(msg: "");
        log("inside getHoldings if");
        closeTimer = false;
        return true;
      } else {
        log("inside getHoldings else");
        closeTimer = true;
        return false;
      }

    } on HttpApiException catch (err) {
      log("inside getHoldings error");
      print(err.errorSuggestion);
      print(err.errorTitle);
      print(err.errorCode);
      Fluttertoast.showToast(msg: err.errorTitle);
      closeTimer = true;
      return false;
    }
  }

  Future<bool> getAllHoldings() async {
    try {

      Map<String, dynamic> request = {
        "key": "value",
      };

      GetAllHoldingsResponse? res =
      await BrokerInfoRestApiService().getAllHoldings();

      if(res!.data!.message!.toLowerCase() == "success") {

        holdingData = res.data!.data!.holdings!;
        // Fluttertoast.showToast(msg: "");
        log("inside getAllHoldings if");
        closeTimer = false;
        return true;
      } else {
        log("inside getAllHoldings else");
        closeTimer = true;
        return false;
      }

    } on HttpApiException catch (err) {
      log("inside getAllHoldings error");
      print(err.errorSuggestion);
      print(err.errorTitle);
      print(err.errorCode);
      Fluttertoast.showToast(msg: err.errorTitle);
      closeTimer = true;
      return false;
    }
  }

  Future<bool> getCustomerFundsAndMargins() async {
    try {

      Map<String, dynamic> request = {
        "key": "value",
      };

      GetCustomerFundsAndMarginsResponse? res =
      await BrokerInfoRestApiService().getCustomerFundsAndMargins();

      if(res!.data!.message!.toLowerCase() == "success") {

        fundsAndMarginsData = res.data!.data!;
        // Fluttertoast.showToast(msg: "");

        closeTimer = false;
        return true;
      } else {
        closeTimer = true;
        return false;
      }

    } on HttpApiException catch (err) {
      print(err.errorSuggestion);
      print(err.errorTitle);
      print(err.errorCode);
      Fluttertoast.showToast(msg: err.errorTitle);
      closeTimer = true;
      return false;
    }
  }

  Future<bool> getCustomerProfile() async {
    try {

      Map<String, dynamic> request = {
        "key": "value",
      };

      GetCustomerProfileResponse? res =
      await BrokerInfoRestApiService().getCustomerProfile();

      if(res!.data!.message!.toLowerCase() == "success") {
        brokerProfileData = res.data!.data!;
        // Fluttertoast.showToast(msg: "");
        closeTimer = false;
        return true;
      } else {
        closeTimer = true;
        return false;
      }

    } on HttpApiException catch (err) {
      print(err.errorSuggestion);
      print(err.errorTitle);
      print(err.errorCode);
      Fluttertoast.showToast(msg: err.errorTitle);
      closeTimer = true;
      return false;
    }
  }

}