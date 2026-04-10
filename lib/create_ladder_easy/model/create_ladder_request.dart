
import '../../global/models/api_request_response.dart';

class CreateLadderRequest extends ApiRequestResponse {
  int? ladTickerId;
  double? ladCashAllocated;
  double? ladMinimumPrice;
  int? ladInitialBuyQuantity;
  int? ladDefaultBuySellQuantity;
  double? ladTargetPrice;
  int? ladNumOfStepsAbove;
  int? ladNumOfStepsBelow;
  double? ladCashNeeded;
  double? ladInitialBuyPrice;
  double? ladStepSize;

  CreateLadderRequest(
      {this.ladTickerId,
      this.ladCashAllocated,
      this.ladMinimumPrice,
      this.ladInitialBuyQuantity,
      this.ladDefaultBuySellQuantity,
      this.ladTargetPrice,
      this.ladNumOfStepsAbove,
      this.ladNumOfStepsBelow,
      this.ladCashNeeded,
      this.ladInitialBuyPrice,
      this.ladStepSize});

  CreateLadderRequest fromJson(Map<String, dynamic> json) {
    ladTickerId = json['lad_ticker_id'];
    ladCashAllocated = json['lad_cash_allocated'];
    ladMinimumPrice = json['lad_minimum_price'];
    ladInitialBuyQuantity = json['lad_initial_buy_quantity'];
    ladDefaultBuySellQuantity = json['lad_default_buy_sell_quantity'];
    ladTargetPrice = json['lad_target_price'];
    ladNumOfStepsAbove = json['lad_num_of_steps_above'];
    ladNumOfStepsBelow = json['lad_num_of_steps_below'];
    ladCashNeeded = json['lad_cash_needed'];
    ladInitialBuyPrice = json['lad_initial_buy_price'];
    ladStepSize = json['lad_step_size'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lad_ticker_id'] = this.ladTickerId;
    data['lad_cash_allocated'] = this.ladCashAllocated;
    data['lad_minimum_price'] = this.ladMinimumPrice;
    data['lad_initial_buy_quantity'] = this.ladInitialBuyQuantity;
    data['lad_default_buy_sell_quantity'] = this.ladDefaultBuySellQuantity;
    data['lad_target_price'] = this.ladTargetPrice;
    data['lad_num_of_steps_above'] = this.ladNumOfStepsAbove;
    data['lad_num_of_steps_below'] = this.ladNumOfStepsBelow;
    data['lad_cash_needed'] = this.ladCashNeeded;
    data['lad_initial_buy_price'] = this.ladInitialBuyPrice;
    data['lad_step_size'] = this.ladStepSize;
    return data;
  }
}
