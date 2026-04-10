import 'package:dozen_diamond/global/models/api_request_response.dart';

class AddCashRequest implements ApiRequestResponse {
  int? ladId;
  int? stocksToBeBought;
  double? newCashAdded;
  double? newCashNeeded;
  int? newInitialBuyQuantity;
  int? time;
  double? newStepSize;
  int? newOrderSize;
  double? minLimitPrice;
  int? timeInMin;

  AddCashRequest(
      {this.ladId,
      this.stocksToBeBought,
      this.newCashAdded,
      this.newCashNeeded,
      this.newInitialBuyQuantity,
      this.newStepSize,
      this.newOrderSize,
      this.time,
        this.minLimitPrice,
        this.timeInMin
      });

  AddCashRequest fromJson(Map<String, dynamic> json) {
    ladId = json['lad_id'];
    stocksToBeBought = json['stocks_to_be_bought'];
    newCashAdded = json['new_cash_added'];
    newCashNeeded = json['new_cash_needed'];
    newInitialBuyQuantity = json['new_initial_buy_quantity'];
    newOrderSize = json['new_order_size'];
    newStepSize = json['new_step_size'];
    time = json['time'];
    minLimitPrice = json['minimumLimitPrice'];
    timeInMin = json['timeInMinutes'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lad_id'] = this.ladId;
    data['stocks_to_be_bought'] = this.stocksToBeBought ?? 0;
    data['new_cash_added'] = this.newCashAdded ?? 0;
    data['new_cash_needed'] = this.newCashNeeded;
    data['new_initial_buy_quantity'] = this.newInitialBuyQuantity ?? 0;
    data['new_order_size'] = this.newOrderSize ?? 0;
    data['new_step_size'] = this.newStepSize ?? 0.0;
    data['time'] = this.time;
    data['minimumLimitPrice'] = this.minLimitPrice;
    data['timeInMinutes'] = this.timeInMin;
    return data;
  }
}
