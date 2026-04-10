import 'dart:convert';

import 'package:dozen_diamond/global/constants/shared_preferences_manager.dart';
import 'package:flutter/services.dart';

import '../models/all_trade_analytics_response.dart';

class DummyAnalysisTradeAnalyticsData {
  // lib/ZH_Analysis/assets/JSON/dummy_trade_analytics_stocks.json
  //
  // lib/ZH_Analysis/assets/

  Future<AllTradeAnalyticsResponse> allTradeAnalyticsTableDummy() async {
    print("in side tradeAnalyticStockListDummy");
    String? currency = await SharedPreferenceManager.getCountryCurrency();
    String filePath = (currency == '₹')
        ? 'lib/ZH_analysisTradeAnalytics/assets/JSON/dummy_all_trade_analytics_table.json'
        : 'lib/ZH_analysisTradeAnalytics/assets/JSON/dummy_all_trade_analytics_table_us.json';

    // Read the file as a string
    // String jsonString = await File(filePath).readAsString();
    String jsonString = await rootBundle.loadString(filePath);

    // Decode the JSON string into a Map
    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    // Use the fromJson method to convert the map to TradeAnalyticsStocksResponse
    AllTradeAnalyticsResponse response =
        AllTradeAnalyticsResponse().fromJson(jsonData);

    return response;
  }
}
