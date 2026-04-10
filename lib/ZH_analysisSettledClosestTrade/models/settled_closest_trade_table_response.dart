import 'package:dozen_diamond/global/models/api_request_response.dart';

class SettledClosestTradeTableResponse implements ApiRequestResponse {
  List<Data>? data;
  String? totalProfit;
  String? msg;
  bool? status;

  SettledClosestTradeTableResponse(
      {this.data, this.totalProfit, this.msg, this.status});

  @override
  SettledClosestTradeTableResponse fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data().fromJson(v));
      });
    }
    totalProfit = json['total_profit'];
    msg = json['msg'];
    status = json['status'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['total_profit'] = this.totalProfit;
    data['msg'] = this.msg;
    data['status'] = this.status;
    return data;
  }
}

class Data implements ApiRequestResponse {
  int? tradeNumber;
  String? purchasePrice;
  String? salePrice;
  int? shares;
  String? type;
  String? profit;
  String? purchaseDate;

  Data(
      {this.tradeNumber,
      this.purchasePrice,
      this.salePrice,
      this.shares,
      this.type,
      this.profit,
      this.purchaseDate});

  @override
  Data fromJson(Map<String, dynamic> json) {
    tradeNumber = json['trade_number'];
    purchasePrice = json['purchase_price'];
    salePrice = json['sale_price'];
    shares = json['shares'];
    type = json['type'];
    profit = json['profit'];
    purchaseDate = json['purchase_date'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['trade_number'] = this.tradeNumber;
    data['purchase_price'] = this.purchasePrice;
    data['sale_price'] = this.salePrice;
    data['shares'] = this.shares;
    data['type'] = this.type;
    data['profit'] = this.profit;
    data['purchase_date'] = this.purchaseDate;
    return data;
  }
}
