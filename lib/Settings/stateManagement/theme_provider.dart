import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeController { Dark, Light }

enum TextScaleFactorController {Small, Medium, Large}

class ThemeProvider extends ChangeNotifier {
  bool _defaultTheme = false;
  final String _themeKey = 'defaultTheme';
  final String _themeControllerKey = 'themeController';




  TextScaleFactorController _textScaleFactorController = TextScaleFactorController.Small;

  TextScaleFactorController get textScaleFactorController =>
      _textScaleFactorController;

  set textScaleFactorController(TextScaleFactorController value) {
    _textScaleFactorController = value;
    notifyListeners();
  }

  ThemeController _themeController = ThemeController.Dark;
  //enum created themeController
  // <-- old login-->
  // List<String> _themeController=['Dark','Light'];
  // String _themeControllerChanger='light';
// String get themeControllerChanger => _themeControllerChanger;
  // List<String> get themeController => _themeController;
  // set themeControllerChanger(String themeControllerChangerBunch){
  //   _themeControllerChanger = themeControllerChangerBunch;
  //   _saveTheme();
  //   notifyListeners();
  // }
  // <-->

  ThemeProvider() {
    _loadTheme();
    _loadScaleFactor(); // load saved scale on init
  }

  void _loadScaleFactor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    textScaleFactor = prefs.getDouble('textScaleFactor') ?? 0.9;

    if(textScaleFactor == 1.1) {
      textScaleFactorController = TextScaleFactorController.Large;
    } else if(textScaleFactor == 1.0) {
      textScaleFactorController = TextScaleFactorController.Medium;
    } else {
      textScaleFactorController = TextScaleFactorController.Small;
    }
    notifyListeners();
  }

  ThemeController get themeController => _themeController;

  set themeController(ThemeController themeControllerBunch) {
    _themeController = themeControllerBunch;
    _saveThemeController();
    notifyListeners();
  }

  bool get defaultTheme => _defaultTheme;

  set defaultTheme(bool defaultThemeBunch) {
    _defaultTheme = defaultThemeBunch;
    _saveTheme();
    notifyListeners();
  }

  Future<void> _saveTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _defaultTheme);
  }

  void saveScaleFactor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('textScaleFactor', textScaleFactor);
  }

  Future<bool> isDefaultTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? true;
  }

  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _defaultTheme = prefs.getBool(_themeKey) ?? false;
    _themeController = _stringToThemeController(
        prefs.getString(_themeControllerKey) ?? 'Dark');
    notifyListeners();
  }

  Future<void> _saveThemeController() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _themeControllerKey, _themeControllerToString(_themeController));
  }

  String _themeControllerToString(ThemeController themeController) {
    return themeController.toString().split('.').last;
  }

  ThemeController _stringToThemeController(String themeControllerString) {
    return ThemeController.values.firstWhere(
        (e) => e.toString().split('.').last == themeControllerString,
        orElse: () => ThemeController.Dark);
  }

  double _textScaleFactor = 0.9;

  double get textScaleFactor => _textScaleFactor;

  set textScaleFactor(double value) {
    _textScaleFactor = value;
    notifyListeners();
  }
}
