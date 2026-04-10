import 'package:dozen_diamond/global/models/api_request_response.dart';

class ModifyStepSizeRequest implements ApiRequestResponse {
  int? ladId;
  double? ladStepSize;
  double? ladCashNeeded;
  double? ladNumOfStepsAbove;
  int? ladNumOfStepsBelow;
  int? ladDefaultBuySellQuantity;

  ModifyStepSizeRequest(
      {this.ladId,
      this.ladStepSize,
      this.ladCashNeeded,
      this.ladNumOfStepsAbove,
      this.ladNumOfStepsBelow,
      this.ladDefaultBuySellQuantity});

  ModifyStepSizeRequest fromJson(Map<String, dynamic> json) {
    ladId = json['lad_id'];
    ladStepSize = json['lad_step_size'];
    ladCashNeeded = json['lad_cash_needed'];
    ladNumOfStepsAbove = json['lad_num_of_steps_above'];
    ladNumOfStepsBelow = json['lad_num_of_steps_below'];
    ladDefaultBuySellQuantity = json['lad_default_buy_sell_quantity'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lad_id'] = this.ladId;
    data['lad_step_size'] = this.ladStepSize;
    data['lad_cash_needed'] = this.ladCashNeeded;
    data['lad_num_of_steps_above'] = this.ladNumOfStepsAbove;
    data['lad_num_of_steps_below'] = this.ladNumOfStepsBelow;
    data['lad_default_buy_sell_quantity'] = this.ladDefaultBuySellQuantity;
    return data;
  }
}
