import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../global/models/http_api_exception.dart';
import '../models/broker_data.dart';
import '../models/broker_dynamic_field_data.dart';
import '../models/brokers_data_response.dart';
import '../services/manage_brokers_rest_api_service.dart';

class ManageBrokersProvider extends ChangeNotifier {
  ManageBrokersProvider(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  TextEditingController searchBrokerTextEditingController =
      TextEditingController(text: "");

  // List<String> brokerList = [
  //   "Upstox",
  //   "ICICI Securities",
  //   "IIFL",
  //   "Angel One",
  //   "Zerodha",
  // ];

  List<BrokerData> _brokerList = [
    // BrokerData(
    //   brokerListId: 1,
    //   brokerName: "Upstox",
    //   brokerImage: "lib/manage_brokers/assets/upstox.jpeg",
    //   isIntegratedIntoSystem: false,
    //   isLoggedIn: false,
    // ),
    // BrokerData(
    //   brokerListId: 2,
    //   brokerName: "ICICI Securities",
    //   brokerImage: "lib/manage_brokers/assets/icici.png",
    //   isIntegratedIntoSystem: false,
    //   isLoggedIn: false,
    // ),
    // BrokerData(
    //   brokerListId: 3,
    //   brokerName: "Kotak Neo",
    //   brokerImage: "lib/manage_brokers/assets/kotak_neo.png",
    //   isIntegratedIntoSystem: false,
    //   isLoggedIn: false,
    // ),
    // BrokerData(
    //   brokerListId: 4,
    //   brokerName: "SMC",
    //   brokerImage: "lib/manage_brokers/assets/smc_logo.png",
    //   isIntegratedIntoSystem: false,
    //   isLoggedIn: false,
    // ),
    // BrokerData(
    //   brokerListId: 5,
    //   brokerName: "5Paisa",
    //   brokerImage: "lib/manage_brokers/assets/paach_paisa_logo.png",
    //   isIntegratedIntoSystem: false,
    //   isLoggedIn: false,
    // ),
    // BrokerData(
    //   brokerListId: 6,
    //   brokerName: "IIFL",
    //   brokerImage: "lib/manage_brokers/assets/iifl.png",
    //   isIntegratedIntoSystem: false,
    //   isLoggedIn: false,
    // ),
    // BrokerData(
    //   brokerListId: 7,
    //   brokerName: "Angel One",
    //   brokerImage: "lib/manage_brokers/assets/angel_one.png",
    //   isIntegratedIntoSystem: false,
    //   isLoggedIn: false,
    // ),
    // BrokerData(
    //   brokerListId: 8,
    //   brokerName: "Motilal Oswal",
    //   brokerImage: "lib/manage_brokers/assets/motilal_oswal.jpg",
    //   isIntegratedIntoSystem: false,
    //   isLoggedIn: false,
    // ),
    // BrokerData(
    //   brokerListId: 9,
    //   brokerName: "Zerodha",
    //   brokerImage: "lib/manage_brokers/assets/zerodha.jpeg",
    //   isIntegratedIntoSystem: false,
    //   isLoggedIn: false,
    // ),
    // BrokerData(
    //   brokerListId: 10,
    //   brokerName: "Sharekhan",
    //   brokerImage: "lib/manage_brokers/assets/sherkhan.jpg",
    //   isIntegratedIntoSystem: false,
    //   isLoggedIn: false,
    // ),
  ];

  List<BrokerData> get brokerList => _brokerList;

  set brokerList(List<BrokerData> value) {
    _brokerList = value;
    notifyListeners();
  }

  List<BrokerData> _searchedBrokerList = [];

  List<BrokerData> get searchedBrokerList => _searchedBrokerList;

  set searchedBrokerList(List<BrokerData> value) {
    _searchedBrokerList = value;
    notifyListeners();
  }

  BrokerData _selectedBroker = BrokerData();

  BrokerData get selectedBroker => _selectedBroker;

  set selectedBroker(BrokerData value) {
    _selectedBroker = value;
    notifyListeners();
  }

  List<BrokerDynamicFieldData> _selectedBrokerFields = [];

  List<BrokerDynamicFieldData> get selectedBrokerFields =>
      _selectedBrokerFields;

  set selectedBrokerFields(List<BrokerDynamicFieldData> value) {
    _selectedBrokerFields = value;
    notifyListeners();
  }

  bool _buttonLoading = false;

  bool get buttonLoading => _buttonLoading;

  set buttonLoading(bool value) {
    _buttonLoading = value;
    notifyListeners();
  }

  void searchBrokers(String query) {
    final filtered = brokerList.where((broker) {
      final brokerName = broker.brokerName?.toLowerCase() ?? '';
      final input = query.toLowerCase();
      return brokerName.contains(input);
    }).toList();

    searchedBrokerList = filtered;
  }

  Future<bool> fetchBrokers() async {
    try {
      BrokersDataResponse? res = await ManageBrokersRestApiService()
          .getBrokers();

      if (res.status == true && res.data != null) {
        brokerList = res.data ?? brokerList;

        notifyListeners();
        return true;
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<bool> doBrokerLogin(
    String apiEndPoint,
    Map<String, dynamic> request,
  ) async {
    try {
      buttonLoading = true;

      bool res = await ManageBrokersRestApiService().doBrokerLogin(
        apiEndPoint,
        request,
      );

      print("after calling angle one login");

      if (res == true) {
        buttonLoading = false;
        // Fluttertoast.showToast(msg: res.message ?? "");
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
    // return false;
  }
}
