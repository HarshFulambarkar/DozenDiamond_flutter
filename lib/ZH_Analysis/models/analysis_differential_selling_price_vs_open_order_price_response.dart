class AnalysisDifferentialSellingPriceVsOpenOrderPriceResponse {
  bool? status;
  String? message;
  Success? success;
  List<Data>? data;

  AnalysisDifferentialSellingPriceVsOpenOrderPriceResponse({this.status, this.message, this.success, this.data});

  AnalysisDifferentialSellingPriceVsOpenOrderPriceResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    success =
    json['success'] != null ? new Success.fromJson(json['success']) : null;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
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

class Success {
  String? description;
  String? suggestion;

  Success({this.description, this.suggestion});

  Success.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    suggestion = json['suggestion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['suggestion'] = this.suggestion;
    return data;
  }
}

class Data {
  int? tradeNumber;
  String? stockName;
  double? cumulativeCashGain;
  double? price;
  int? stockOwn;
  double? differentialSellingPrice;

  Data(
      {this.tradeNumber,
        this.stockName,
        this.cumulativeCashGain,
        this.price,
        this.stockOwn,
        this.differentialSellingPrice});

  Data.fromJson(Map<String, dynamic> json) {
    tradeNumber = json['trade_number'];
    stockName = json['stock_name'];
    cumulativeCashGain = json['cumulative_cash_gain'];
    price = json['price'];
    stockOwn = json['stock_own'];
    differentialSellingPrice = json['differential_selling_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trade_number'] = this.tradeNumber;
    data['stock_name'] = this.stockName;
    data['cumulative_cash_gain'] = this.cumulativeCashGain;
    data['price'] = this.price;
    data['stock_own'] = this.stockOwn;
    data['differential_selling_price'] = this.differentialSellingPrice;
    return data;
  }
}