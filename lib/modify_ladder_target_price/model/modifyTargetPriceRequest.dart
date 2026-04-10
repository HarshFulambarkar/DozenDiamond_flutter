import 'package:dozen_diamond/global/models/api_request_response.dart';

class ModifyTargetPriceRequest implements ApiRequestResponse {
  int? ladId;
  double? ladTargetPrice;
  double? ladStepSize;
  int? ladDefaultBuySellQuantity;
  double? ladCashNeeded;
  int? stockToBeBought;
  double? ladNumOfStepsAbove;
  int? ladNumOfStepsBelow;
  double? minLimitPrice;
  int? timeInMin;
  double? currentPrice;

  ModifyTargetPriceRequest(
      {this.ladId,
      this.ladTargetPrice,
      this.ladStepSize,
      this.ladDefaultBuySellQuantity,
      this.ladCashNeeded,
      this.stockToBeBought,
      this.ladNumOfStepsAbove,
      this.ladNumOfStepsBelow,
      this.minLimitPrice,
        this.timeInMin,
      this.currentPrice});

  ModifyTargetPriceRequest fromJson(Map<String, dynamic> json) {
    ladId = json['lad_id'];
    ladTargetPrice = json['lad_target_price'];
    ladStepSize = json['lad_step_size'];
    ladDefaultBuySellQuantity = json['lad_default_buy_sell_quantity'];
    ladCashNeeded = json['lad_cash_needed'];
    stockToBeBought = json['stock_to_be_bought'];
    ladNumOfStepsAbove = json['lad_num_of_steps_above'];
    ladNumOfStepsBelow = json['lad_num_of_steps_below'];
    minLimitPrice = json['minimumLimitPrice'];
    timeInMin = json['timeInMinutes'];
    currentPrice = json['currentPrice'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lad_id'] = this.ladId;
    data['lad_target_price'] = this.ladTargetPrice;
    data['lad_step_size'] = this.ladStepSize;
    data['lad_default_buy_sell_quantity'] = this.ladDefaultBuySellQuantity;
    data['lad_cash_needed'] = this.ladCashNeeded;
    data['stock_to_be_bought'] = this.stockToBeBought;
    data['lad_num_of_steps_above'] = this.ladNumOfStepsAbove;
    data['lad_num_of_steps_below'] = this.ladNumOfStepsBelow;
    data['minimumLimitPrice'] = this.minLimitPrice;
    data['timeInMinutes'] = this.timeInMin;
    data['currentPrice'] = this.currentPrice;
    return data;
  }
}
