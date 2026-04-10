import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

import '../../global/constants/currency_constants.dart';
import '../models/account_cash_details_response.dart';

class DummyFundsData {

  // lib/ZH_Analysis/assets/JSON/dummy_trade_analytics_stocks.json
  //
  // lib/ZH_Analysis/assets/



  Future<AccountCashDetailsResponse> accountCashDetailsDummy() async {
    print("in side tradeAnalyticStockListDummy");

    String filePath = (CurrencyConstants().currency == '₹')
        ?'lib/F_Funds/assets/JSON/dummy_account_cash_details.json'
        :'lib/F_Funds/assets/JSON/dummy_account_cash_details_us.json';

    // Read the file as a string
    // String jsonString = await File(filePath).readAsString();
    String jsonString = await rootBundle.loadString(filePath);

    // Decode the JSON string into a Map
    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    // Use the fromJson method to convert the map to TradeAnalyticsStocksResponse
    AccountCashDetailsResponse response = AccountCashDetailsResponse().fromJson(jsonData);

    return response;
  }
}