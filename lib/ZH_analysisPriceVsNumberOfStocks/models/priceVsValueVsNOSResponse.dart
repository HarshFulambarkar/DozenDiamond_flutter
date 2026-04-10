import 'package:dozen_diamond/global/models/api_request_response.dart';

class PriceVsValueVsNoOfStocksResponse implements ApiRequestResponse {
  bool? status;
  String? message;
  List<Data>? data;

  PriceVsValueVsNoOfStocksResponse({this.status, this.message, this.data});

  PriceVsValueVsNoOfStocksResponse fromJson(Map<String, dynamic> json) {
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
  int? tradeId;
  int? units;
  String? stockName;
  String? tradeType;
  int? unitsDuringTrade;
  String? executionPrice;
  String? createdAt;
  String? tradeValueAtTime;

  Data(
      {this.tradeId,
      this.units,
      this.stockName,
      this.tradeType,
      this.unitsDuringTrade,
      this.executionPrice,
      this.createdAt,
      this.tradeValueAtTime});

  Data fromJson(Map<String, dynamic> json) {
    tradeId = json['trade_id'];
    units = json['units'];
    stockName = json['stock_name'];
    tradeType = json['trade_type'];
    unitsDuringTrade = json['units_during_trade'];
    executionPrice = json['execution_price'];
    createdAt = json['createdAt'];
    tradeValueAtTime = json['trade_value_at_time'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trade_id'] = this.tradeId;
    data['units'] = this.units;
    data['stock_name'] = this.stockName;
    data['trade_type'] = this.tradeType;
    data['units_during_trade'] = this.unitsDuringTrade;
    data['execution_price'] = this.executionPrice;
    data['createdAt'] = this.createdAt;
    data['trade_value_at_time'] = this.tradeValueAtTime;
    return data;
  }
}
