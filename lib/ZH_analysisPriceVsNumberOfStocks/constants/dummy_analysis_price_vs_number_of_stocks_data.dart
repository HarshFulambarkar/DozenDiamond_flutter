import 'dart:convert';
import 'dart:io';

import 'package:dozen_diamond/global/constants/shared_preferences_manager.dart';
import 'package:flutter/services.dart';

import '../../global/constants/currency_constants.dart';
import '../models/closedOrderPriceAndUnits.dart';
import '../models/ExtraCashVsPriceDataResponse.dart';

class DummyAnalysisPriceVsNumberOfStocksData {
  // lib/ZH_Analysis/assets/JSON/dummy_trade_analytics_stocks.json
  //
  // lib/ZH_Analysis/assets/

  Future<ClosedOrderPriceAndUnitsResponse>
      priceVsValueVsNumberOfStocksDummy() async {
    print("in side priceVsValueVsNumberOfStocksDummy");
    String? currency = await SharedPreferenceManager.getCountryCurrency();
    String filePath = (currency == '₹')
        ? 'lib/ZH_analysisPriceVsNumberOfStocks/assets/JSON/dummy_closed_order_price_and_units.json'
        : 'lib/ZH_analysisPriceVsNumberOfStocks/assets/JSON/dummy_closed_order_price_and_units_us.json';

    // Read the file as a string
    // String jsonString = await File(filePath).readAsString();
    String jsonString = await rootBundle.loadString(filePath);

    // Decode the JSON string into a Map
    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    // Use the fromJson method to convert the map to TradeAnalyticsStocksResponse
    ClosedOrderPriceAndUnitsResponse response =
        ClosedOrderPriceAndUnitsResponse().fromJson(jsonData);

    return response;
  }

  Future<ExtraCashVsPriceDataResponse> extraCashVsPriceOfStocksDummy() async {
    print("in side extraCashVsPriceOfStocksDummy");

    String filePath = (CurrencyConstants().currency == '₹')
        ? 'lib/ZH_analysisPriceVsNumberOfStocks/assets/JSON/dummy_extra_cash_vs_price.json'
        : 'lib/ZH_analysisPriceVsNumberOfStocks/assets/JSON/dummy_extra_cash_vs_price.json';

    // Read the file as a string
    // String jsonString = await File(filePath).readAsString();
    String jsonString = await rootBundle.loadString(filePath);

    // Decode the JSON string into a Map
    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    // Use the fromJson method to convert the map to TradeAnalyticsStocksResponse
    ExtraCashVsPriceDataResponse response =
        ExtraCashVsPriceDataResponse().fromJson(jsonData);

    print("below is lenth");

    return response;
  }
}
