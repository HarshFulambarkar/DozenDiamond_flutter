import 'dart:convert';
import 'dart:io';

import 'package:dozen_diamond/global/constants/shared_preferences_manager.dart';
import 'package:flutter/services.dart';

import '../models/settled_closest_trade_table_response.dart';

class DummyAnalysisSettledClosestTradeData {
  Future<SettledClosestTradeTableResponse>
      settledClosestTradeTableDummy() async {
    print("in side settledClosestTradeTableDummy");
    String? currency = await SharedPreferenceManager.getCountryCurrency();
    String filePath = (currency == '₹')
        ? 'lib/ZH_analysisSettledClosestTrade/assets/JSON/dummy_settled_closest_trade_table_stocks.json'
        : 'lib/ZH_analysisSettledClosestTrade/assets/JSON/dummy_settled_closest_trade_table_stocks_us.json';

    // Read the file as a string
    // String jsonString = await File(filePath).readAsString();
    String jsonString = await rootBundle.loadString(filePath);

    // Decode the JSON string into a Map
    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    // Use the fromJson method to convert the map to TradeAnalyticsStocksResponse
    SettledClosestTradeTableResponse response =
        SettledClosestTradeTableResponse().fromJson(jsonData);

    return response;
  }
}
