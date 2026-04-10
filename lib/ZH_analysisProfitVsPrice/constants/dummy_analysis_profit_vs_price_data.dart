import 'dart:convert';
import 'dart:io';

import 'package:dozen_diamond/global/constants/shared_preferences_manager.dart';
import 'package:flutter/services.dart';

import '../../global/constants/currency_constants.dart';
import '../models/analytics_profit_vs_price_graph_response.dart';

class DummyAnalysisProfitVsPriceData {
  Future<AnalyticsProfitVsPriceGraphResponse>
      analyticsProfitVsPriceGraphDummy() async {
    print("in side analyticsProfitVsPriceGraphDummy");
    String? currency = await SharedPreferenceManager.getCountryCurrency();
    String filePath = (currency == '₹')
        ? 'lib/ZH_analysisProfitVsPrice/assets/JSON/dummy_analytics_profit_vs_price_graph.json'
        : 'lib/ZH_analysisProfitVsPrice/assets/JSON/dummy_analytics_profit_vs_price_graph_us.json';

    // Read the file as a string
    // String jsonString = await File(filePath).readAsString();
    String jsonString = await rootBundle.loadString(filePath);

    // Decode the JSON string into a Map
    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    // Use the fromJson method to convert the map to TradeAnalyticsStocksResponse
    AnalyticsProfitVsPriceGraphResponse response =
        AnalyticsProfitVsPriceGraphResponse().fromJson(jsonData);

    return response;
  }
}
