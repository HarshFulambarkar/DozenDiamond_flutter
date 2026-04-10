import 'dart:convert';
import 'dart:io';

import 'package:dozen_diamond/global/constants/shared_preferences_manager.dart';
import 'package:flutter/services.dart';

import '../../global/constants/currency_constants.dart';
import '../models/actual_vs_computed_alpha_response.dart';

class DummyAnalysisAlphaData {
  // lib/ZH_Analysis/assets/JSON/dummy_trade_analytics_stocks.json
  //
  // lib/ZH_Analysis/assets/

  Future<ActualVscomputedAlphaResponse> actualVscomputedAlphaDummy() async {
    print("in side actualVscomputedAlphaDummy");

    String? currency = await SharedPreferenceManager.getCountryCurrency();
    String filePath = (currency == '₹')
        ? 'lib/ZH_analysisAlpha/assets/JSON/dummy_actual_vs_computed_alpha.json'
        : 'lib/ZH_analysisAlpha/assets/JSON/dummy_actual_vs_computed_alpha_us.json';

    // Read the file as a string
    // String jsonString = await File(filePath).readAsString();
    String jsonString = await rootBundle.loadString(filePath);

    // Decode the JSON string into a Map
    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    // Use the fromJson method to convert the map to TradeAnalyticsStocksResponse
    ActualVscomputedAlphaResponse response =
        ActualVscomputedAlphaResponse().fromJson(jsonData);

    return response;
  }
}
