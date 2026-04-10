import 'package:dozen_diamond/global/models/api_request_response.dart';

class ModifyOrderSizeRequest implements ApiRequestResponse {
  int? ladId;
  int? ladDefaultBuySellQuantity;
  double? ladCashNeeded;
  double? ladNumOfStepsAbove;
  int? ladNumOfStepsBelow;
  double? ladStepSize;

  ModifyOrderSizeRequest(
      {this.ladId,
      this.ladDefaultBuySellQuantity,
      this.ladCashNeeded,
      this.ladNumOfStepsAbove,
      this.ladNumOfStepsBelow,
      this.ladStepSize});

  ModifyOrderSizeRequest fromJson(Map<String, dynamic> json) {
    ladId = json['lad_id'];
    ladDefaultBuySellQuantity = json['lad_default_buy_sell_quantity'];
    ladCashNeeded = json['lad_cash_needed'];
    ladNumOfStepsAbove = json['lad_num_of_steps_above'];
    ladNumOfStepsBelow = json['lad_num_of_steps_below'];
    ladStepSize = json['lad_step_size'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lad_id'] = this.ladId;
    data['lad_default_buy_sell_quantity'] = this.ladDefaultBuySellQuantity;
    data['lad_cash_needed'] = this.ladCashNeeded;
    data['lad_num_of_steps_above'] = this.ladNumOfStepsAbove;
    data['lad_num_of_steps_below'] = this.ladNumOfStepsBelow;
    data['lad_step_size'] = this.ladStepSize;
    return data;
  }
}
