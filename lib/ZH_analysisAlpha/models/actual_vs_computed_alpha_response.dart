import 'package:dozen_diamond/global/models/api_request_response.dart';

class ActualVscomputedAlphaResponse implements ApiRequestResponse {
  bool? status;
  String? message;
  Success? success;
  List<Data>? data;

  ActualVscomputedAlphaResponse({this.status, this.message, this.success});

  ActualVscomputedAlphaResponse fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data().fromJson(v));
      });
    }
    message = json['message'];
    success = json['success'] != null
        ? new Success().fromJson(json['success'])
        : null;
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.success != null) {
      data['success'] = this.success!.toJson();
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
  String? price;
  String? type;
  int? stocksHeld;
  int? sumOfCashGain;
  String? profit;
  String? alpha;

  Data(
      {this.tradeNumber,
      this.price,
      this.type,
      this.stocksHeld,
      this.sumOfCashGain,
      this.profit,
      this.alpha});

  @override
  Data fromJson(Map<String, dynamic> json) {
    tradeNumber = json['trade_number'];
    price = json['price'];
    type = json['type'];
    stocksHeld = json['stocks_held'];
    sumOfCashGain = json['sum_of_cash_gain'];
    profit = json['profit'];
    alpha = json['alpha'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['trade_number'] = this.tradeNumber;
    data['price'] = this.price;
    data['type'] = this.type;
    data['stocks_held'] = this.stocksHeld;
    data['sum_of_cash_gain'] = this.sumOfCashGain;
    data['profit'] = this.profit;
    data['alpha'] = this.alpha;
    return data;
  }
}
