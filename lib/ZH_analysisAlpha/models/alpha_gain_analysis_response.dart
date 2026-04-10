import 'package:dozen_diamond/global/models/api_request_response.dart';

class AlphaGainAnalysisResponse implements ApiRequestResponse {
  List<Data>? data;
  String? msg;
  bool? status;

  AlphaGainAnalysisResponse({this.data, this.msg, this.status});

  @override
  AlphaGainAnalysisResponse fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data().fromJson(v));
      });
    }
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
    data['msg'] = this.msg;
    data['status'] = this.status;
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
  String? alphaGain;

  Data(
      {this.tradeNumber,
      this.price,
      this.type,
      this.stocksHeld,
      this.sumOfCashGain,
      this.profit,
      this.alpha,
      this.alphaGain});

  @override
  Data fromJson(Map<String, dynamic> json) {
    tradeNumber = json['trade_number'];
    price = json['price'];
    type = json['type'];
    stocksHeld = json['stocks_held'];
    sumOfCashGain = json['sum_of_cash_gain'];
    profit = json['profit'];
    alpha = json['alpha'];
    alphaGain = json['alpha_gain'];
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
    data['alpha_gain'] = this.alphaGain;
    return data;
  }
}
