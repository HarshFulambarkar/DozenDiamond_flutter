import 'package:dozen_diamond/global/models/api_request_response.dart';

class ActiveLadderSimulationTickersResponse implements ApiRequestResponse {
  bool? status;
  String? message;
  List<Data>? data;

  ActiveLadderSimulationTickersResponse({this.status, this.message, this.data});

  @override
  ActiveLadderSimulationTickersResponse fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data().fromJson(v));
      });
    }
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data implements ApiRequestResponse {
  int? ladTickerId;
  String? ladTicker;
  double? ladInitialBuyPrice;
  double? ladCurrentPrice;
  double? ladStepSize;
  String? ladExchange;

  Data(
      {this.ladTickerId,
      this.ladTicker,
      this.ladInitialBuyPrice,
      this.ladCurrentPrice,
      this.ladStepSize,
      this.ladExchange});

  @override
  Data fromJson(Map<String, dynamic> json) {
    ladTickerId = json['lad_ticker_id'];
    ladTicker = json['lad_ticker'];
    ladInitialBuyPrice = (json['lad_initial_buy_price'] == null)?0:json['lad_initial_buy_price'].toDouble();
    ladCurrentPrice = (json['lad_current_price'] == null)?0:json['lad_current_price'].toDouble();
    ladStepSize = (json['lad_step_size'] == null)?0:json['lad_step_size'].toDouble();
    ladExchange = (json['lad_exchange'] == null)?"":json['lad_exchange'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lad_ticker_id'] = this.ladTickerId;
    data['lad_ticker'] = this.ladTicker;
    data['lad_initial_buy_price'] = this.ladInitialBuyPrice;
    data['lad_current_price'] = this.ladCurrentPrice;
    data['lad_step_size'] = this.ladStepSize;
    return data;
  }
}
