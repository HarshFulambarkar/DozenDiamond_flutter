import 'dart:convert';

import 'package:dozen_diamond/AA_positions/models/get_all_open_position_response.dart'
    as getAllOpenPositionsResponse;

import '../../global/constants/currency_constants.dart';

class PositionRestApiServiceDummyData {
  Future<getAllOpenPositionsResponse.GetAllOpenPositionsResponse?>
      getOpenPositionsDummyData(
          CurrencyConstants currencyConstantsProvider) async {
    String jsonString;
    if (currencyConstantsProvider.currency == "₹") {
      jsonString =
          '''
                    {
                      "status": true,
                      "message": "Open positions fetched successfully",
                      "success": {
                        "description": "All open positions are fetched successfully",
                        "suggestion": "Review and monitor open positions"
                      },
                      "data": [
                        {
                          "pos_id": 101,
                          "pos_total_buy_qty": 100,
                          "pos_stock_name": "TCS",
                          "pos_lad_name": "Ladder 1",
                          "user_id": 12345,
                          "pos_status": "active",
                          "lad_id": 2001,
                          "createdAt": "2024-09-15T12:34:56.789Z",
                          "updatedAt": "2024-09-16T14:45:23.123Z",
                          "pos_ttl_p_l": "500.00",
                           "pos_unrealized_profit": "11338.83",
                          "pos_realized_profit": "11338.83",
                          "total_return": "5%",
                              "pos_average_purchase_price": "429.78",
                          "average_purchase_cost": "10.00",
                           "cash_spent": "229073.88",
                          "cash_allocated": "327463.7",
                          "current_price": "4551.00",
                          "total_cost": "1000.00"
                        }
                      ]
                    }
                ''';
    } else {
      jsonString =
          ''' {
                      "status": true,
                      "message": "Open positions fetched successfully",
                      "success": {
                        "description": "All open positions are fetched successfully",
                        "suggestion": "Review and monitor open positions"
                      },
                      "data": [
                        {
                          "pos_id": 101,
                          "pos_total_buy_qty": 533,
                          "pos_stock_name": "Microsoft Corp",
                          "pos_lad_name": "Ladder 1",
                          "user_id": 12345,
                          "pos_status": "active",
                          "lad_id": 2001,
                          "createdAt": "2024-09-15T12:34:56.789Z",
                          "updatedAt": "2024-09-16T14:45:23.123Z",
                          "pos_ttl_p_l": "0.0",
                          "pos_unrealized_profit": "-11338.83",
                          "pos_realized_profit": "0.0",
                          "pos_average_purchase_price": "429.78",
                             "cash_spent": "229073.88",
                          "cash_allocated": "327463.7",
                          "current_price": "408.51",
                          "total_return": "5",
                          "average_purchase_cost": "10.00",
                          "total_cost": "1000.00"
                        },
                        {
                          "pos_id": 102,
                          "pos_total_buy_qty": 50,
                          "pos_stock_name": "Alphabet Inc",
                          "pos_lad_name": "Ladder 2",
                          "user_id": 12346,
                          "pos_status": "pending",
                          "lad_id": 2002,
                          "createdAt": "2024-09-14T10:22:33.456Z",
                          "updatedAt": "2024-09-15T11:33:45.789Z",
                          "pos_ttl_p_l": "250.00",
                           "cash_spent": "429.78",
                          "cash_allocated": "429.78",
                           "pos_unrealized_profit": "11338.83",
                               "pos_average_purchase_price": "429.78",
                          "pos_realized_profit": "11338.83",
                          "total_return": "2.5%",
                          "average_purchase_cost": "20.00",
                          "current_price": "163.67",
                          "total_cost": "500.00"
                        },
                        {
                          "pos_id": 102,
                          "pos_total_buy_qty": 50,
                          "pos_stock_name": "Amazon.com Inc",
                          "pos_lad_name": "Ladder 2",
                          "user_id": 12346,
                          "pos_status": "pending",
                          "lad_id": 2002,
                          "createdAt": "2024-09-14T10:22:33.456Z",
                          "updatedAt": "2024-09-15T11:33:45.789Z",
                              "pos_average_purchase_price": "429.78",
                          "pos_ttl_p_l": "250.00",
                           "cash_spent": "429.78",
                          "cash_allocated": "429.78",
                           "pos_unrealized_profit": "11338.83",
                          "pos_realized_profit": "11338.83",
                          "total_return": "2.5%",
                          "average_purchase_cost": "20.00",
                          "current_price": "189.90.00",
                          "total_cost": "500.00"
                        }
                      ]
                    }
                ''';
    }

    getAllOpenPositionsResponse.GetAllOpenPositionsResponse value =
        getAllOpenPositionsResponse.GetAllOpenPositionsResponse()
            .fromJson(jsonDecode(jsonString));
    return value;
  }
}
