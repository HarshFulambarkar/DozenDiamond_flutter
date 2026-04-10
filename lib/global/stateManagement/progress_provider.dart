import 'package:flutter/material.dart';

class ProgressProvider extends ChangeNotifier {
  double _progress = 0.0;

  double get progress => _progress;

  void updateProgress(double value) {
    _progress = value.clamp(0.0, 1.0);
    notifyListeners();
  }

  void resetProgress() {
    _progress = 0.0;
    notifyListeners();
  }
}
