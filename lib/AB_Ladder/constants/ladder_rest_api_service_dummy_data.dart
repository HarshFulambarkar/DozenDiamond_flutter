import 'dart:convert';

import 'package:csv/csv.dart';

import '../../global/constants/currency_constants.dart';
import '../models/get_ladder_response.dart' as getLadderResponse;
import 'package:dozen_diamond/AB_Ladder/models/stock_historical_data_response.dart';
import 'package:flutter/services.dart';

class LadderRestApiServiceDummyData {
  Future<StockHistoricalDataResponse?> loadLadderRestApiServiceDummyData(
      {required String stockName}) async {
    dynamic rawData;
    if (stockName == "MSFT") {
      rawData = await rootBundle.loadString('lib/AB_Ladder/assets/MSFT.csv');
    } else if (stockName == "GOOG") {
      rawData = await rootBundle.loadString('lib/AB_Ladder/assets/GOOG.csv');
    } else if (stockName == "AMZN") {
      rawData = await rootBundle.loadString('lib/AB_Ladder/assets/AMZN.csv');
    } else if (stockName == "AARTIIND") {
      rawData =
          await rootBundle.loadString('lib/AB_Ladder/assets/AARTIIND.csv');
    } else if (stockName == "WIPRO") {
      rawData = await rootBundle.loadString('lib/AB_Ladder/assets/WIPRO.csv');
    } else {
      rawData = await rootBundle.loadString('lib/AB_Ladder/assets/TCS.csv');
    }

    List<List<dynamic>> jsonList = CsvToListConverter().convert(rawData);

    List<Map<String, dynamic>> jsonData = csvToJson(jsonList);
    print("in side loadDummyHistoricalData");
    print(jsonData);

    Map<String, dynamic> response = {
      'status': true,
      "message": "Success",
      "data": jsonData,
      "totalCount": jsonData.length,
    };
    StockHistoricalDataResponse? historicalData =
        StockHistoricalDataResponse().fromJson(response);

    print(historicalData);

    return historicalData;
  }

  List<Map<String, dynamic>> csvToJson(List<List<dynamic>> csvData) {
    List<String> headers =
        csvData[0].map((e) => e.toString()).toList(); // First row as headers
    List<Map<String, dynamic>> jsonList = [];

    for (int i = 1; i < csvData.length; i++) {
      Map<String, dynamic> rowMap = {};
      for (int j = 0; j < headers.length; j++) {
        rowMap[headers[j]] = csvData[i][j].toString();
      }
      jsonList.add(rowMap);
    }

    return jsonList;
  }

  Future<getLadderResponse.GetLadderResponse?> getLadderDummyData(
      CurrencyConstants currencyConstantsProvider) async {
    String jsonString;
    print("here is the currency ${currencyConstantsProvider.currency}");
    if (currencyConstantsProvider.currency == "₹") {
      jsonString =
          '''{
                              "status":true,
                              "message":"Ladder fetched successfully",
                              "data":[
                                {
                                  "stock_name":"WIPRO",
                                  "current_price":"550.65",
                                  "ladder_data":[
                                    {
                                      "lad_id":78,
                                      "lad_user_id":721,
                                      "lad_definition_id":101,
                                      "lad_position_id":null,
                                      "lad_ticker":"WIPRO",
                                      "lad_name":"001",
                                      "lad_status":"INACTIVE",
                                      "lad_ticker_id":4036,
                                      "lad_exchange":"BSE",
                                      "lad_trading_mode":"SIMULATION",
                                      "lad_cash_allocated":"327086.10",
                                      "lad_cash_gain":"0.00",
                                      "lad_cash_left":"327086.10",
                                      "lad_last_trade_price":null,
                                      "lad_last_trade_order_price":null,
                                      "lad_minimum_price":"0.00",
                                      "lad_extra_cash_generated":"0.00",
                                      "lad_extra_cash_left":"0.00",
                                      "lad_realized_profit":"0.00",
                                      "lad_initial_buy_quantity":396,
                                      "lad_default_buy_sell_quantity":11,
                                      "lad_target_price":"1101.30",
                                      "lad_num_of_steps_above":36,
                                      "lad_num_of_steps_below":35,
                                      "lad_cash_needed":"109028.70",
                                      "lad_initial_buy_price":"550.65",
                                      "lad_current_quantity":0,
                                      "lad_initial_buy_executed":0,
                                      "lad_recent_trade_id":null
                                    }
                                  ]
                                },
                                {
                                  "stock_name":"TCS",
                                  "current_price":"4517.85",
                                  "ladder_data":[
                                    {
                                      "lad_id":79,
                                      "lad_user_id":721,
                                      "lad_definition_id":102,
                                      "lad_position_id":null,
                                      "lad_ticker":"TCS",
                                      "lad_name":"001",
                                      "lad_status":"INACTIVE",
                                      "lad_ticker_id":3637,
                                      "lad_exchange":"BSE",
                                      "lad_trading_mode":"SIMULATION",
                                      "lad_cash_allocated":"325285.20",
                                      "lad_cash_gain":"0.00",
                                      "lad_cash_left":"325285.20",
                                      "lad_last_trade_price":null,
                                      "lad_last_trade_order_price":null,
                                      "lad_minimum_price":"0.00",
                                      "lad_extra_cash_generated":"0.00",
                                      "lad_extra_cash_left":"0.00",
                                      "lad_realized_profit":"0.00",
                                      "lad_initial_buy_quantity":48,
                                      "lad_default_buy_sell_quantity":2,
                                      "lad_target_price":"9035.70",
                                      "lad_num_of_steps_above":24,
                                      "lad_num_of_steps_below":24,
                                      "lad_cash_needed":"108428.40",
                                      "lad_initial_buy_price":"4517.85",
                                      "lad_current_quantity":0,
                                      "lad_initial_buy_executed":0,
                                      "lad_recent_trade_id":null
                                    }
                                  ]
                                },
                                {
                                  "stock_name":"AARTIIND",
                                  "current_price":"568.95",
                                  "ladder_data":[
                                    {
                                      "lad_id":80,
                                      "lad_user_id":721,
                                      "lad_definition_id":103,
                                      "lad_position_id":null,
                                      "lad_ticker":"AARTIIND",
                                      "lad_name":"001",
                                      "lad_status":"INACTIVE",
                                      "lad_ticker_id":53,
                                      "lad_exchange":"BSE",
                                      "lad_trading_mode":"SIMULATION",
                                      "lad_cash_allocated":"332835.75",
                                      "lad_cash_gain":"0.00",
                                      "lad_cash_left":"332835.75",
                                      "lad_last_trade_price":null,
                                      "lad_last_trade_order_price":null,
                                      "lad_minimum_price":"0.00",
                                      "lad_extra_cash_generated":"0.00",
                                      "lad_extra_cash_left":"0.00",
                                      "lad_realized_profit":"0.00",
                                      "lad_initial_buy_quantity":390,
                                      "lad_default_buy_sell_quantity":10,
                                      "lad_target_price":"1137.90",
                                      "lad_num_of_steps_above":39,
                                      "lad_num_of_steps_below":38,
                                      "lad_cash_needed":"110945.25",
                                      "lad_initial_buy_price":"568.95",
                                      "lad_current_quantity":0,
                                      "lad_initial_buy_executed":0,
                                      "lad_recent_trade_id":null
                                    }
                                  ]
                                }
                              ]
                            }''';
    } else {
      jsonString =
          '''{
                              "status":true,
                              "message":"Ladder fetched successfully",
                              "data":[
                                {
                                  "stock_name":"Microsoft Corp",
                                  "current_price":"430.59",
                                  "ladder_data":[
                                    {
                                      "lad_id":78,
                                      "lad_user_id":721,
                                      "lad_definition_id":101,
                                      "lad_position_id":null,
                                      "lad_ticker":"MSFT",
                                      "lad_name":"001",
                                      "lad_status":"INACTIVE",
                                      "lad_ticker_id":4036,
                                      "lad_exchange":"NASDAQ",
                                      "lad_trading_mode":"SIMULATION",
                                      "lad_cash_allocated":"327463.695",
                                      "lad_cash_gain":"-229073.88",
                                      "lad_cash_left":"327086.10",
                                      "lad_last_trade_price":null,
                                      "lad_last_trade_order_price":null,
                                      "lad_minimum_price":"0.00",
                                      "lad_extra_cash_generated":"143.53",
                                      "lad_extra_cash_left":"143.53",
                                      "lad_realized_profit":"0.00",
                                      "lad_initial_buy_quantity":507,
                                      "lad_default_buy_sell_quantity":13,
                                      "lad_target_price":"861.18",
                                      "lad_num_of_steps_above":39,
                                      "lad_num_of_steps_below":39,
                                      "lad_cash_needed":"109154.565",
                                      "lad_initial_buy_price":"430.59",
                                      "lad_current_quantity":533,
                                      "lad_initial_buy_executed":0,
                                      "lad_recent_trade_id":null
                                    }
                                  ]
                                },
                                {
                                  "stock_name":"Alphabet Inc",
                                  "current_price":"163.67",
                                  "ladder_data":[
                                    {
                                      "lad_id":79,
                                      "lad_user_id":721,
                                      "lad_definition_id":102,
                                      "lad_position_id":null,
                                      "lad_ticker":"GOOG",
                                      "lad_name":"001",
                                      "lad_status":"INACTIVE",
                                      "lad_ticker_id":3637,
                                      "lad_exchange":"NASDAQ",
                                      "lad_trading_mode":"SIMULATION",
                                      "lad_cash_allocated":"333527.22",
                                      "lad_cash_gain":"-227906.6123",
                                      "lad_cash_left":"105620.6077",
                                      "lad_last_trade_price":null,
                                      "lad_last_trade_order_price":null,
                                      "lad_minimum_price":"0.00",
                                      "lad_extra_cash_generated":"73.09384615",
                                      "lad_extra_cash_left":"73.09384615",
                                      "lad_realized_profit":"0.00",
                                      "lad_initial_buy_quantity":1404,
                                      "lad_default_buy_sell_quantity":36,
                                      "lad_target_price":"316.74",
                                      "lad_num_of_steps_above":39,
                                      "lad_num_of_steps_below":39,
                                      "lad_cash_needed":"105547.5138",
                                      "lad_initial_buy_price":"158.37",
                                      "lad_current_quantity":1440,
                                      "lad_initial_buy_executed":0,
                                      "lad_recent_trade_id":null
                                    }
                                  ]
                                },
                                {
                                  "stock_name":"Amazon.com Inc",
                                  "current_price":"189.90",
                                  "ladder_data":[
                                    {
                                      "lad_id":80,
                                      "lad_user_id":721,
                                      "lad_definition_id":103,
                                      "lad_position_id":null,
                                      "lad_ticker":"AMZN",
                                      "lad_name":"001",
                                      "lad_status":"INACTIVE",
                                      "lad_ticker_id":53,
                                      "lad_exchange":"NASDAQ",
                                      "lad_trading_mode":"SIMULATION",
                                      "lad_cash_allocated":"335682",
                                      "lad_cash_gain":"-223788",
                                      "lad_cash_left":"111894",
                                      "lad_last_trade_price":null,
                                      "lad_last_trade_order_price":null,
                                      "lad_minimum_price":"0.00",
                                      "lad_extra_cash_generated":"0.00",
                                      "lad_extra_cash_left":"0.00",
                                      "lad_realized_profit":"0.00",
                                      "lad_initial_buy_quantity":1200,
                                      "lad_default_buy_sell_quantity":30,
                                      "lad_target_price":"372.98",
                                      "lad_num_of_steps_above":40,
                                      "lad_num_of_steps_below":40,
                                      "lad_cash_needed":"111894",
                                      "lad_initial_buy_price":"186.49",
                                      "lad_current_quantity":1200,
                                      "lad_initial_buy_executed":0,
                                      "lad_recent_trade_id":null
                                    }
                                  ]
                                }
                              ]
                            }''';
    }

    getLadderResponse.GetLadderResponse value =
        getLadderResponse.GetLadderResponse().fromJson(jsonDecode(jsonString));

    return value;
  }
}
