import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  int _previousSelectedIndex = 0;

  int get selectedIndex => _selectedIndex;
  int get previousSelectedIndex => _previousSelectedIndex;

  set selectedIndex(int value) {
    previousSelectedIndex = selectedIndex;
    print("Machhar $previousSelectedIndex $value");
    _selectedIndex = value;
    notifyListeners();
  }

  set previousSelectedIndex(int index) {
    _previousSelectedIndex = index;
    notifyListeners();
  }

  bool _displayFilterDialog = true;

  bool get displayFilterDialog => _displayFilterDialog;

  set displayFilterDialog(bool value) {
    _displayFilterDialog = value;
    notifyListeners();
  }

  void onItemTapped(int index,
      {bool displayFilterDialogInPortfolioPage = true}) {
    displayFilterDialog = displayFilterDialogInPortfolioPage;

    selectedIndex = index;

    notifyListeners();
  }
}
