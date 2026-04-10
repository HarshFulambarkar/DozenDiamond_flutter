import 'package:dozen_diamond/Settings/models/toggle_country_request.dart';
import 'package:dozen_diamond/Settings/services/settings_rest_api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyConstants extends ChangeNotifier {
  bool _isCountryUsa = false;
  String? _currency;
  String? _selectedCountry;

  // Shared Preferences key
  static const String isCountryUsaKey = 'isCountryUsa';

  // Getter for isCountryUsa
  bool get isCountryUsa => _isCountryUsa;

  // Setter for isCountryUsa with notifyListeners and storing in SharedPreferences
  set isCountryUsa(bool value) {
    _isCountryUsa = value;
    _updateCurrencyAndCountry();
    _saveIsCountryUsaToPreferences(); // Save the value to SharedPreferences
    notifyListeners();
    setCountryInDatabase();
  }

  // Getter for currency
  String get currency => _currency ?? '\$'; // Defaults to ₹ if null

  // Getter for selectedCountry
  String get selectedCountry =>
      _selectedCountry ?? 'India'; // Defaults to India if null

  // Constructor
  CurrencyConstants() {
    _loadIsCountryUsaFromPreferences(); // Load the saved value on initialization
  }

  // Private method to update currency and country based on isCountryUsa value
  void _updateCurrencyAndCountry() {
    _currency = _isCountryUsa ? "\$" : "₹";
    _selectedCountry = _isCountryUsa ? "USA" : "India";
  }

  Future<void> _saveIsCountryUsaToPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(isCountryUsaKey, _isCountryUsa);
  }

  Future<void> _loadIsCountryUsaFromPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _isCountryUsa = prefs.getBool(isCountryUsaKey) ?? false;
    _updateCurrencyAndCountry();
    notifyListeners();
  }

  Future<void> setCountryInDatabase() async {
    String selectedCountryTemp = selectedCountry == "India" ? "INDIA" : "USA";
    await SettingRestApiService()
        .toggleCountry(ToggleCountryRequest(country: selectedCountryTemp));
  }
}

Future<bool> getIsCountryUsaFromPreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return !(prefs.getBool('isCountryUsa') ?? false);
}

class CurrencyIcon extends StatelessWidget {
  final double size; // Add size as a parameter
  final Color color; // Add color as a parameter

  const CurrencyIcon({
    Key? key,
    this.size = 24.0, // Provide default size
    this.color = Colors.black, // Provide default color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      (Provider.of<CurrencyConstants>(context).currency == "₹")
          ? Icons.currency_rupee_sharp
          : Icons.attach_money,
      // Icons.attach_money,
      size: size, // Use the size parameter
      color: color, // Use the color parameter
    );
  }
}
