import 'dart:convert';

import 'package:dozen_diamond/AC_trades/models/get_all_unsettled_trade_list_response.dart'
    as getAllUnsettledTrades;

import '../../global/constants/currency_constants.dart';

class TradesRestApiServiceDummyData {
  Future<getAllUnsettledTrades.GetAllUnsettledTradeListResponse?>
      getUnsettledTradesDummyData(
          CurrencyConstants currencyConstantsProvider) async {
    String jsonString;

    if (currencyConstantsProvider.currency == "₹") {
      jsonString =
          '''{
                      "status": true,
                      "message": "Success",
                      "data": [
                        {
                          "trade_id": 12345,
                          "trade_unit": 10,
                          "trade_stock_name": "TCS",
                          "trade_ladder_name": "Ladder 1",
                          "user_id": 67890,
                          "trade_exe_price": "100.50",
                          "trade_type": "BUY",
                          "trade_delete": 0,
                          "trade_status": 1,
                          "price_change": "1.25",
                          "trade_ticket_num": "TICKET123",
                          "is_replicated_trade": false,
                          "lad_id": 234,
                          "order_id": null,
                          "status": "completed",
                          "security_code": "SEC123",
                          "createdAt": "2024-09-13T12:34:56.789Z",
                          "updatedAt": "2024-09-13T12:34:56.789Z",
                          "stock_current_price": "102.75",
                          "trade_buy_cost": "1010.50"
                        }
                      ]
                    }
                ''';
    } else {
      jsonString =
          '''{
                      "status": true,
                      "message": "Success",
                      "data": [
                        {
                          "trade_id": 12345,
                          "trade_unit": 507,
                          "trade_stock_name": "Microsoft Corp",
                          "trade_ladder_name": "Ladder 001",
                          "user_id": 67890,
                          "trade_exe_price": "430.59",
                          "trade_type": "BUY",
                          "trade_delete": 0,
                          "trade_status": 1,
                          "price_change": "-22.1",
                          "trade_ticket_num": "454ds54dsa53",
                          "is_replicated_trade": false,
                          "lad_id": 234,
                          "order_id": null,
                          "status": "completed",
                          "security_code": "SEC123",
                          "createdAt": "2024-09-13T12:34:56.789Z",
                          "updatedAt": "2024-09-13T12:34:56.789Z",
                          "stock_current_price": "408.51",
                          "trade_buy_cost": "218309.13"
                        },
                         {
                          "trade_id": 12345,
                          "trade_unit": 13,
                          "trade_stock_name": "Microsoft Corp",
                          "trade_ladder_name": "Ladder 001",
                          "user_id": 67890,
                          "trade_exe_price": "419.55",
                          "trade_type": "BUY",
                          "trade_delete": 0,
                          "trade_status": 1,
                          "price_change": "-11.04",
                          "trade_ticket_num": "454ds54dsa53",
                          "is_replicated_trade": false,
                          "lad_id": 234,
                          "order_id": null,
                          "status": "completed",
                          "security_code": "SEC123",
                          "createdAt": "2024-09-13T12:44:56.789Z",
                          "updatedAt": "2024-09-13T12:44:56.789Z",
                          "stock_current_price": "408.51",
                          "trade_buy_cost": "5454.14"
                        },
                         {
                          "trade_id": 12345,
                          "trade_unit": 13,
                          "trade_stock_name": "Alphabet Inc",
                          "trade_ladder_name": "Ladder 001",
                          "user_id": 67890,
                          "trade_exe_price": "408.51",
                          "trade_type": "BUY",
                          "trade_delete": 0,
                          "trade_status": 1,
                          "price_change": "0",
                          "trade_ticket_num": "454ds54dsa53",
                          "is_replicated_trade": false,
                          "lad_id": 234,
                          "order_id": null,
                          "status": "completed",
                          "security_code": "SEC123",
                          "createdAt": "2024-09-13T12:54:56.789Z",
                          "updatedAt": "2024-09-13T12:54:56.789Z",
                          "stock_current_price": "163.67",
                          "trade_buy_cost": "5310.61"
                        }, 
                        {
                          "trade_id": 12345,
                          "trade_unit": 507,
                          "trade_stock_name": "Amazon.com Inc",
                          "trade_ladder_name": "Ladder 001",
                          "user_id": 67890,
                          "trade_exe_price": "408.51",
                          "trade_type": "BUY",
                          "trade_delete": 0,
                          "trade_status": 1,
                          "price_change": "-22.1",
                          "trade_ticket_num": "454ds54dsa53",
                          "is_replicated_trade": false,
                          "lad_id": 234,
                          "order_id": null,
                          "status": "completed",
                          "security_code": "SEC123",
                          "createdAt": "2024-09-13T12:34:56.789Z",
                          "updatedAt": "2024-09-13T12:34:56.789Z",
                          "stock_current_price": "189.90",
                          "trade_buy_cost": "218309.13"
                        }
                      ]
                    }
                ''';
    }

    getAllUnsettledTrades.GetAllUnsettledTradeListResponse value =
        getAllUnsettledTrades.GetAllUnsettledTradeListResponse()
            .fromJson(jsonDecode(jsonString));
    print("value ${value.toJson()}");
    return value;
  }
}
