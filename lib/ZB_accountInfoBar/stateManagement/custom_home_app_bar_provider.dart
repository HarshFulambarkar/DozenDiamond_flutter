import 'dart:convert';
import 'dart:developer';

import 'package:dozen_diamond/ZB_accountInfoBar/models/account_info_bar_details_response.dart';
import 'package:dozen_diamond/ZB_accountInfoBar/models/account_info_bar_field_visibility.dart';
import 'package:dozen_diamond/ZB_accountInfoBar/services/account_info_bar_rest_api_service.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomHomeAppBarProvider extends ChangeNotifier {
  AccountInfoBarDetailsResponse? _getUserAccountDetails;
  AccountInfoBarFieldVisibility _accountInfoBarFieldVisibility =
      AccountInfoBarFieldVisibility();
  bool _isExpanded = false;
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Dozen Diamonds',
    packageName: 'Unknown',
    version: '',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );
  double _accountInfoBarHeight = 370;

  double get accountInfoBarHeight => _accountInfoBarHeight;

  bool? get isExpanded => _isExpanded;

  String _frontendVersion = "";
  String _backendVersion = "";
  String _databaseVersion = "";

  String get frontendVersion => _frontendVersion;
  String get backendVersion => _backendVersion;
  String get databaseVersion => _databaseVersion;

  PackageInfo get packageInfo => _packageInfo;

  AccountInfoBarFieldVisibility get accountInfoBarFieldVisibility =>
      _accountInfoBarFieldVisibility;

  AccountInfoBarRestApiService _accountInfoBarRestApiService =
      AccountInfoBarRestApiService();

  Future<void> callInitialApi() async {
    try {
      _frontendVersion = "1";
      _backendVersion = "2";
      _databaseVersion = "2";
      await fetchUserAccountDetails();
      await getAppPackageInfo();
    } on HttpApiException catch (err) {
      print(err.errorTitle);
    }
  }

  void getFieldVisibilityOfAccountInfoBar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("account_info_bar_field_visibility")) {
      _accountInfoBarFieldVisibility = AccountInfoBarFieldVisibility().fromJson(
          jsonDecode(prefs.getString("account_info_bar_field_visibility")!));
      adjustAccountInfoBarHeight();
      notifyListeners();
    } else {
      prefs.setString("account_info_bar_field_visibility",
          jsonEncode(AccountInfoBarFieldVisibility().toJson()));
      adjustAccountInfoBarHeight();
      notifyListeners();
    }
  }

  void adjustAccountInfoBarHeight() {
    _accountInfoBarHeight = 370;

    _accountInfoBarHeight +=
        _accountInfoBarFieldVisibility.numberOfFieldsVisible() * 25;
  }

  void updateAccountInfoBarFieldVisibility(
      AccountInfoBarFieldVisibility newFieldVisibility) async {
    _accountInfoBarFieldVisibility = newFieldVisibility;
    adjustAccountInfoBarHeight();
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("account_info_bar_field_visibility",
        jsonEncode(_accountInfoBarFieldVisibility.toJson()));
  }

  void onTapOfAppBar() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }

  Future<void> getAppPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    _packageInfo = info;
    notifyListeners();
  }

  AccountInfoBarDetailsResponse? get getUserAccountDetails =>
      _getUserAccountDetails;

  Future<bool> fetchUserAccountDetails() async {
    try {
      _getUserAccountDetails =
          await _accountInfoBarRestApiService.getUserAccountDetails();
      notifyListeners();
      if (_getUserAccountDetails!.status!) {
        return true;
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      log(e.toString());
      throw e;
    }
  }
}
