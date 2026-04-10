import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../functions/utils.dart';
import '../models/app_config_response.dart';
import '../models/graded_order_data.dart';
import '../models/graded_order_list_response.dart';
import '../models/http_api_exception.dart';
import '../models/update_graded_order_response.dart';
import '../services/global_rest_api_service.dart';

class AppConfigProvider extends ChangeNotifier {
  AppConfigProvider(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  AppConfigResponse _appConfigData = AppConfigResponse();

  AppConfigResponse get appConfigData => _appConfigData;

  set appConfigData(AppConfigResponse value) {
    _appConfigData = value;
    notifyListeners();
  }

  List<GradedOrderData> _gradedOrderData = [];

  List<GradedOrderData> get gradedOrderData => _gradedOrderData;

  set gradedOrderData(List<GradedOrderData> value) {
    _gradedOrderData = value;
    notifyListeners();
  }

  String _limitPrice = "null";

  String get limitPrice => _limitPrice;

  set limitPrice(String value) {
    _limitPrice = value;
    notifyListeners();
  }

  String _limitPriceTimeInMin = "null";

  String get limitPriceTimeInMin => _limitPriceTimeInMin;

  set limitPriceTimeInMin(String value) {
    _limitPriceTimeInMin = value;
    notifyListeners();
  }

  String _limitPriceErrorText = "";

  String get limitPriceErrorText => _limitPriceErrorText;

  set limitPriceErrorText(String value) {
    _limitPriceErrorText = value;
    notifyListeners();
  }

  String _limitPriceTimeInMinErrorText = "";

  String get limitPriceTimeInMinErrorText => _limitPriceTimeInMinErrorText;

  set limitPriceTimeInMinErrorText(String value) {
    _limitPriceTimeInMinErrorText = value;
    notifyListeners();
  }

  handleAppUpdate(BuildContext context) async {
    print("in handle app update");
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    int buildNumber = int.parse(packageInfo.buildNumber);
    print("below is build details");
    print(buildNumber);

    String updateUrl = "";
    int appBuildNumber = 0;
    bool forceUpdate = true;

    if (Platform.isIOS) {
      forceUpdate = appConfigData.data?.iosForceUpdate ?? false;
      updateUrl = appConfigData.data?.iosUpdateUrl ??
          "https://apps.apple.com/in/app/dozen-diamonds-kosh/id6739197055";
      appBuildNumber = appConfigData.data?.iosBuildNumber ?? 0;
    } else {
      forceUpdate = appConfigData.data?.androidForceUpdate ?? false;
      updateUrl = appConfigData.data?.androidUpdateUrl ??
          "https://play.google.com/store/apps/details?id=com.dozen_diamonds.kosh&hl=en";
      appBuildNumber = appConfigData.data?.androidBuildNumber ?? 0;
    }

    print(buildNumber);
    print(appBuildNumber);

    if (buildNumber < appBuildNumber) {
      Utility().showUpdate(context, forceUpdate.toString(), updateUrl);
    }
  }

  Future<bool> getAppConfig() async {
    print("inside getAppConfig");
    try {
      AppConfigResponse? res = await GlobalRestApiService().getAppConfig();

      appConfigData = res;
      print("below is dataddd");
      print(appConfigData.data?.logo?.ddUrl);
      print(appConfigData.data?.versionServer);
      print(appConfigData.data?.versionBackend);
      print(appConfigData.data?.versionFrontend);
      print(appConfigData.data?.iosUpdateUrl);
      print(appConfigData.data?.iosBuildNumber);
      print(appConfigData.data?.androidUpdateUrl);
      print(appConfigData.data?.androidBuildNumber);

      return true;
    } on HttpApiException catch (err) {
      print(err.errorSuggestion);
      print(err.errorTitle);
      print(err.errorCode);
      return false;
    }
  }

  Future<bool> checkServerStatus() async {
    print("inside checkServerStatus");
    try {
      bool res = await GlobalRestApiService().checkServerStatus();

      return res;
    } on HttpApiException catch (err) {
      print(err.errorSuggestion);
      print(err.errorTitle);
      print(err.errorCode);
      return false;
    }
  }

  Future<bool> getGradedOrderList(BuildContext context) async {
    print("inside getGradedOrderList");
    try {
      GradedOrderListResponse? res = await GlobalRestApiService().getGradedOrderList();

      gradedOrderData = res.data ?? [];
      print("below is datadddddd");
      print(gradedOrderData.length);

      for(int i=0; i<gradedOrderData.length; i++) {
        Utility().minLimitPriceAndTimeInMinDialog(
            context,
            gradedOrderData[i].type.toString(),
            gradedOrderData[i].orderId.toString(),
            gradedOrderData[i].message.toString()
        );
      }


      return true;
    } on HttpApiException catch (err) {
      print(err.errorSuggestion);
      print(err.errorTitle);
      print(err.errorCode);
      return false;
    }
  }

  Future<bool> updateGradedOrder(String orderId, double minLimitPrice, int timeInMin) async {
    try {

      Map<String, dynamic> request = {
        "orderId": orderId,
        "minimumLimitPrice": minLimitPrice,
        "timeInMinutes": timeInMin
      };

      UpdateGradedOrderResponse res = await GlobalRestApiService().updateGradedOrder(request);

      if (res.status ?? false) {


        Fluttertoast.showToast(msg: "Order updated");
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
