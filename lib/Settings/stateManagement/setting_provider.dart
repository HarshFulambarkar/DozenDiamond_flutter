import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/settings_rest_api_service.dart';

class SettingProvider extends ChangeNotifier {
  String _selectedLadderCreationType = "advance";

  String get selectedLadderCreationType => _selectedLadderCreationType;

  SettingProvider() {
    _loadSelectedLadderCreationType();
  }

  TextEditingController subjectTextEditingController = TextEditingController(text: "");
  TextEditingController messageTextEditingController = TextEditingController(text: "");

  String _selectedContactSupportCategory = "Select Category";

  String get selectedContactSupportCategory => _selectedContactSupportCategory;

  set selectedContactSupportCategory(String value) {
    _selectedContactSupportCategory = value;
    notifyListeners();
  }

  dynamic _bugImage;

  dynamic get bugImage => _bugImage;

  set bugImage(dynamic value) {
    _bugImage = value;
    notifyListeners();
  }

  set selectedLadderCreationType(String value) {
    _selectedLadderCreationType = value;
    _saveSelectedLadderCreationType(value);
    notifyListeners();
  }

  bool _isThemeExpanded = true;

  bool get isThemeExpanded => _isThemeExpanded;

  set isThemeExpanded(bool value) {
    _isThemeExpanded = value;
    notifyListeners();
  }

  bool _isTradingOptionsExpanded = true;

  bool get isTradingOptionsExpanded => _isTradingOptionsExpanded;

  set isTradingOptionsExpanded(bool value) {
    _isTradingOptionsExpanded = value;
    notifyListeners();
  }

  bool _isCountryOptionsExpanded = true;

  bool get isCountryOptionsExpanded => _isCountryOptionsExpanded;

  set isCountryOptionsExpanded(bool value) {
    _isCountryOptionsExpanded = value;
    notifyListeners();
  }

  bool _isLadderOptionExpanded = true;

  bool get isLadderOptionExpanded => _isLadderOptionExpanded;

  set isLadderOptionExpanded(bool value) {
    _isLadderOptionExpanded = value;
    notifyListeners();
  }

  Future<void> _loadSelectedLadderCreationType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedLadderCreationType =
        prefs.getString('selectedLadderCreationType') ?? "advance";
    notifyListeners();
  }

  Future<void> _saveSelectedLadderCreationType(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLadderCreationType', value);
  }

  Future<String> sendContactSupportMain(String subject, String message) async {
    Map<String, dynamic> request = {
      "subject": subject,
      "message": message,
      "category": selectedContactSupportCategory,
    };
    var response = await SettingRestApiService().SendContactSupport(
      request,
      bugImage,
    );

    _selectedContactSupportCategory = "Select Category";
    _bugImage = null;
    print("reset data");
    return response;
  }

}
