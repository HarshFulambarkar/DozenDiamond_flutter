import 'package:dozen_diamond/global/models/api_request_response.dart';

class MoveFundsToLadderRequest implements ApiRequestResponse {
  int? to_lad_id;
  int? from_lad_id;
  int? total_quantity;
  int? sell_units;
  double? new_cash_needed;
  int? new_order_size;
  double? new_step_size;
  double? new_number_of_steps_above;
  int? new_number_of_steps_below;

  MoveFundsToLadderRequest(
      {this.to_lad_id,
        this.from_lad_id,
        this.total_quantity,
        this.sell_units,
        this.new_cash_needed,
        this.new_order_size,
        this.new_step_size,
        this.new_number_of_steps_above,
        this.new_number_of_steps_below});

  MoveFundsToLadderRequest fromJson(Map<String, dynamic> json) {
    to_lad_id = json['to_lad_id'];
    from_lad_id = json['from_lad_id'];
    total_quantity = json['total_quantity'];
    sell_units = json['sell_units'];
    new_cash_needed = json['new_cash_needed'];
    new_order_size = json['new_order_size'];
    new_step_size = json['new_step_size'];
    new_number_of_steps_above = json['new_number_of_steps_above'];
    new_number_of_steps_below = json['new_number_of_steps_below'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['to_lad_id'] = this.to_lad_id;
    data['from_lad_id'] = this.from_lad_id ?? 0;
    data['total_quantity'] = this.total_quantity ?? 0;
    data['sell_units'] = this.sell_units;
    data['new_cash_needed'] = this.new_cash_needed ?? 0;
    data['new_order_size'] = this.new_order_size ?? 0;
    data['new_step_size'] = this.new_step_size ?? 0.0;
    data['new_number_of_steps_above'] = this.new_number_of_steps_above;
    data['new_number_of_steps_below'] = this.new_number_of_steps_below;
    return data;
  }
}
