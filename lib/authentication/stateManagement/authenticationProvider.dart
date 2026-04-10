import 'package:flutter/material.dart';
import 'dart:async';

class AuthenticationProvider extends ChangeNotifier {
  AuthenticationProvider(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  TextEditingController _forgotPasswordEmailController =
      TextEditingController();
  int _countdown = 0;
  Timer? _timer;

  bool _showResendCode = false;

  bool get showResendCode => _showResendCode;
  set showResendCode(bool value) {
    _showResendCode = value;
    notifyListeners();
  }

  TextEditingController get forgotPasswordEmailController =>
      _forgotPasswordEmailController;

  set forgotPasswordEmailController(TextEditingController value) {
    _forgotPasswordEmailController = value;
    notifyListeners();
  }

  int get countdown => _countdown;

  void startCountdown() {
    _countdown = 30;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown > 1) {
        _countdown--;
        notifyListeners();
      } else {
        showResendCode = true;

        timer.cancel();
      }
    });
  }

  void resetCountdown() {
    _timer?.cancel();
    _countdown = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _forgotPasswordEmailController.dispose();
    super.dispose();
  }
}
