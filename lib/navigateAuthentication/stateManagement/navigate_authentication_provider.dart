import 'package:flutter/material.dart';

class NavigateAuthenticationProvider extends ChangeNotifier {
  NavigateAuthenticationProvider(this.navigatorKey);
  final GlobalKey<NavigatorState> navigatorKey;

  int _previousIndex = 0;

  int get previousIndex => _previousIndex;

  set previousIndex(int value) {
    _previousIndex = value;
    notifyListeners();
  }

  int _selectedIndex = 1;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  int _regId = 0;

  int get regId => _regId;

  set regId(int value) {
    _regId = value;
    notifyListeners();
  }

  String _selectedEmail = "";

  String get selectedEmail => _selectedEmail;

  set selectedEmail(String value) {
    _selectedEmail = value;
    notifyListeners();
  }

  String _forgotPasswordOtp = "";

  String get forgotPasswordOtp => _forgotPasswordOtp;

  set forgotPasswordOtp(String value) {
    _forgotPasswordOtp = value;
    notifyListeners();
  }
}