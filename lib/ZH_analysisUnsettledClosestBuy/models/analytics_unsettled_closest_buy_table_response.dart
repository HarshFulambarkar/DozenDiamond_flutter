import 'package:dozen_diamond/global/models/api_request_response.dart';

class AnalyticsUnsettledClosestBuyTableResponse implements ApiRequestResponse {
  List<Data>? data;
  String? settledBuyProfit;
  String? unsettledCash;
  int? unsettledStocks;
  String? averageUnsettledCost;
  String? currentPrice;
  String? message;
  bool? status;

  AnalyticsUnsettledClosestBuyTableResponse(
      {this.data,
      this.settledBuyProfit,
      this.unsettledCash,
      this.unsettledStocks,
      this.averageUnsettledCost,
      this.currentPrice,
      this.message,
      this.status});

  @override
  AnalyticsUnsettledClosestBuyTableResponse fromJson(
      Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data().fromJson(v));
      });
    }
    settledBuyProfit = json['settled_buy_profit'];
    unsettledCash = json['unsettled_cash'];
    unsettledStocks = json['unsettled_stocks'];
    averageUnsettledCost = json['average_unsettled_cost'];
    currentPrice = json['current_price'];
    message = json['message'];
    status = json['status'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['settled_buy_profit'] = this.settledBuyProfit;
    data['unsettled_cash'] = this.unsettledCash;
    data['unsettled_stocks'] = this.unsettledStocks;
    data['average_unsettled_cost'] = this.averageUnsettledCost;
    data['current_price'] = this.currentPrice;
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Data implements ApiRequestResponse {
  int? tradeNumber;
  String? stockName;
  String? price;
  int? bought;
  String? type;
  String? gain;

  Data(
      {this.tradeNumber,
      this.stockName,
      this.price,
      this.bought,
      this.type,
      this.gain});

  @override
  Data fromJson(Map<String, dynamic> json) {
    tradeNumber = json['trade_number'];
    stockName = json['stock_name'];
    price = json['price'];
    bought = json['bought'];
    type = json['type'];
    gain = json['gain'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['trade_number'] = this.tradeNumber;
    data['stock_name'] = this.stockName;
    data['price'] = this.price;
    data['bought'] = this.bought;
    data['type'] = this.type;
    data['gain'] = this.gain;
    return data;
  }
}
