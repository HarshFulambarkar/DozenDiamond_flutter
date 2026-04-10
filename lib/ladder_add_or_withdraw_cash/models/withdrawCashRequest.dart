import 'package:dozen_diamond/global/models/api_request_response.dart';

class WithdrawCashRequest implements ApiRequestResponse {
  int? ladId;
  int? stocksToBeSold;
  double? newCashWithdraw;
  double? newCashNeeded;
  double? newStepSize;
  int? newOrderSize;
  int? newInitialBuyQuantity;
  int? time;
  double? minLimitPrice;
  int? timeInMin;

  WithdrawCashRequest(
      {this.ladId,
      this.stocksToBeSold,
      this.newCashWithdraw,
      this.newStepSize,
      this.newInitialBuyQuantity,
      this.newCashNeeded,
      this.newOrderSize,
      this.time,
        this.minLimitPrice,
        this.timeInMin
      });

  WithdrawCashRequest fromJson(Map<String, dynamic> json) {
    ladId = json['lad_id'];
    stocksToBeSold = json['stocks_to_be_bought'];
    newCashWithdraw = json['new_cash_added'];
    newStepSize = json['new_step_size'];
    newCashNeeded = json['new_cash_needed'];
    newInitialBuyQuantity = json['new_initial_buy_quantity'];
    newOrderSize = json['new_order_size'];
    time = json['time'];
    minLimitPrice = json['minimumLimitPrice'];
    timeInMin = json['timeInMinutes'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lad_id'] = this.ladId;
    data['stocks_to_be_sold'] = this.stocksToBeSold ?? 0;
    data['new_cash_withdraw'] = this.newCashWithdraw ?? 0;
    data['new_cash_needed'] = this.newCashNeeded ?? 0;
    data['new_step_size'] = newStepSize ?? 0;
    data['new_initial_buy_quantity'] = newInitialBuyQuantity ?? 0;
    data['new_order_size'] = newOrderSize ?? 0;
    data['time'] = this.time;
    data['minimumLimitPrice'] = this.minLimitPrice;
    data['timeInMinutes'] = this.timeInMin;
    return data;
  }
}
