import 'package:dozen_diamond/global/models/api_request_response.dart';

class AllTradeAnalyticsResponse implements ApiRequestResponse {
  bool? status;
  String? message;
  Success? success;
  List<Data>? data;

  AllTradeAnalyticsResponse(
      {this.status, this.message, this.success, this.data});

  AllTradeAnalyticsResponse fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    success = json['success'] != null
        ? new Success().fromJson(json['success'])
        : null;
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
    if (this.success != null) {
      data['success'] = this.success!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Success implements ApiRequestResponse {
  String? description;
  String? suggestion;

  Success({this.description, this.suggestion});

  Success fromJson(Map<String, dynamic> json) {
    description = json['description'];
    suggestion = json['suggestion'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['suggestion'] = this.suggestion;
    return data;
  }
}

class Data implements ApiRequestResponse {
  int? tradeNumber;
  String? stockName;
  int? bought;
  String? price;
  String? cost;
  String? profit;
  String? purchaseDate;

  Data(
      {this.tradeNumber,
      this.stockName,
      this.bought,
      this.price,
      this.cost,
      this.profit,
      this.purchaseDate});

  Data fromJson(Map<String, dynamic> json) {
    tradeNumber = json['trade_number'];
    stockName = json['stock_name'];
    bought = json['bought'];
    price = json['price'];
    cost = json['cost'];
    profit = json['profit'];
    purchaseDate = json['purchase_date'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trade_number'] = this.tradeNumber;
    data['stock_name'] = this.stockName;
    data['bought'] = this.bought;
    data['price'] = this.price;
    data['cost'] = this.cost;
    data['profit'] = this.profit;
    data['purchase_date'] = this.purchaseDate;
    return data;
  }
}
