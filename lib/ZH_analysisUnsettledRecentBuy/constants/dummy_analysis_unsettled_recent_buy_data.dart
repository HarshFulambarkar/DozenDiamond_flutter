import 'dart:convert';
import 'dart:io';

import 'package:dozen_diamond/global/constants/shared_preferences_manager.dart';
import 'package:flutter/services.dart';

import '../models/analytics_unsettled_recent_buy_table_response.dart';

class DummyAnalysisUnsettledRecentBuyData {
  Future<AnalyticsUnsettledRecentBuyTableResponse>
      analyticsUnsettledRecentBuyTableDummy() async {
    print("in side analyticsUnsettledRecentBuyTableDummy");
    String? currency = await SharedPreferenceManager.getCountryCurrency();
    String filePath = (currency == '₹')
        ? 'lib/ZH_analysisUnsettledRecentBuy/assets/JSON/dummy_analytics_unsettled_recent_buy_table.json'
        : 'lib/ZH_analysisUnsettledRecentBuy/assets/JSON/dummy_analytics_unsettled_recent_buy_table_us.json';

    // Read the file as a string
    // String jsonString = await File(filePath).readAsString();
    String jsonString = await rootBundle.loadString(filePath);

    // Decode the JSON string into a Map
    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    // Use the fromJson method to convert the map to TradeAnalyticsStocksResponse
    AnalyticsUnsettledRecentBuyTableResponse response =
        AnalyticsUnsettledRecentBuyTableResponse().fromJson(jsonData);

    return response;
  }
}
