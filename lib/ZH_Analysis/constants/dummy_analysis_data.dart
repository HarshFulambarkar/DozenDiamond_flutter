import 'dart:convert';
import 'dart:io';

import 'package:dozen_diamond/global/constants/shared_preferences_manager.dart';
import 'package:flutter/services.dart';

import '../../global/constants/currency_constants.dart';
import '../models/trade_analytics_stocks_response.dart';

class DummyAnalysisData {
  // lib/ZH_Analysis/assets/JSON/dummy_trade_analytics_stocks.json
  //
  // lib/ZH_Analysis/assets/

  Future<TradeAnalyticsStocksResponse> tradeAnalyticStockListDummy() async {
    print("in side tradeAnalyticStockListDummy");
    String? currency = await SharedPreferenceManager.getCountryCurrency();
    String filePath = (currency == '₹')
        ? 'lib/ZH_Analysis/assets/JSON/dummy_trade_analytics_stocks.json'
        : 'lib/ZH_Analysis/assets/JSON/dummy_trade_analytics_stocks_us.json';

    // Read the file as a string
    // String jsonString = await File(filePath).readAsString();
    String jsonString = await rootBundle.loadString(filePath);

    // Decode the JSON string into a Map
    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    // Use the fromJson method to convert the map to TradeAnalyticsStocksResponse
    TradeAnalyticsStocksResponse response =
        TradeAnalyticsStocksResponse().fromJson(jsonData);

    return response;
  }
}
