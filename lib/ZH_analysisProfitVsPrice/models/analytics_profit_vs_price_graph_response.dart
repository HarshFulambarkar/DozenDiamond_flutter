import 'package:dozen_diamond/global/models/api_request_response.dart';

class AnalyticsProfitVsPriceGraphResponse implements ApiRequestResponse {
  bool? status;
  String? message;
  Success? success;
  List<Data>? data;

  AnalyticsProfitVsPriceGraphResponse(
      {this.status, this.message, this.success, this.data});

  AnalyticsProfitVsPriceGraphResponse fromJson(Map<String, dynamic> json) {
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
  int? units;
  String? type;
  double? cashGain;
  double? price;

  Data(
      {this.tradeNumber,
      this.stockName,
      this.units,
      this.type,
      this.cashGain,
      this.price});

  Data fromJson(Map<String, dynamic> json) {
    tradeNumber = json['trade_number'];
    stockName = json['stock_name'];
    units = int.tryParse(json['Units'].toString());
    type = json['type'];
    cashGain = double.tryParse(json['cash gain'].toString());
    price = double.tryParse(json['price'].toString());
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trade_number'] = this.tradeNumber;
    data['stock_name'] = this.stockName;
    data['Units'] = this.units;
    data['type'] = this.type;
    data['cash gain'] = this.cashGain;
    data['price'] = this.price;
    return data;
  }
}
