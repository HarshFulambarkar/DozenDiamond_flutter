import 'dart:convert';
import 'dart:io';

import 'package:dozen_diamond/global/constants/shared_preferences_manager.dart';
import 'package:flutter/services.dart';

import '../models/analytics_unsettled_closest_buy_table_response.dart';

class DummyAnalysisUnsettledClosestBuyData {
  // lib/ZH_Analysis/assets/JSON/dummy_trade_analytics_stocks.json
  //
  // lib/ZH_Analysis/assets/

  Future<AnalyticsUnsettledClosestBuyTableResponse>
      analyticsUnsettledClosestBuyTableDummy() async {
    print("in side analyticsUnsettledClosestBuyTableDummy");
    String? currency = await SharedPreferenceManager.getCountryCurrency();
    String filePath = (currency == '₹')
        ? 'lib/ZH_analysisUnsettledClosestBuy/assets/JSON/dummy_analytics_unsettled_closest_buy_table.json'
        : 'lib/ZH_analysisUnsettledClosestBuy/assets/JSON/dummy_analytics_unsettled_closest_buy_table_us.json';

    // Read the file as a string
    // String jsonString = await File(filePath).readAsString();
    String jsonString = await rootBundle.loadString(filePath);

    // Decode the JSON string into a Map
    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    // Use the fromJson method to convert the map to TradeAnalyticsStocksResponse
    AnalyticsUnsettledClosestBuyTableResponse response =
        AnalyticsUnsettledClosestBuyTableResponse().fromJson(jsonData);

    return response;
  }
}
