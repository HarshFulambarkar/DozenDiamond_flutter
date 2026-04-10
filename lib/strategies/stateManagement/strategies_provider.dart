import 'package:flutter/material.dart';

class StrategiesProvider extends ChangeNotifier {
  StrategiesProvider(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  List<String> _strategyList = [
    "Stressless trading method (STM)",
    "Stressless Cash Less Method (SCM)",
    "Adaptive STM (ASTM)",
    "Suppressed STM (SSTM)",
    "Leverage STM (LSTM)",
    "AI STM",
    "Upside Unbalanced STM (UUSTM)",
    "TSTM (Two-stock STM)"
  ];

  List<String> get strategyList => _strategyList;

  set strategyList(List<String> value) {
    _strategyList = value;
    notifyListeners();
  }
}
