class AnalysisAlphaVsOpenPriceResponse {
  bool? status;
  String? message;
  Success? success;
  List<Data>? data;

  AnalysisAlphaVsOpenPriceResponse({this.status, this.message, this.success, this.data});

  AnalysisAlphaVsOpenPriceResponse.fromJson(Map<String, dynamic> json) {
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
  double? price;
  int? stockOwn;
  double? alpha5;
  double? alpha10;
  int? tradeNumber;

  Data(
      {this.price, this.stockOwn, this.alpha5, this.alpha10, this.tradeNumber});

  Data.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    stockOwn = json['stock_own'];
    alpha5 = (json['alpha5'] == null)?null:json['alpha5'].toDouble();
    alpha10 = (json['alpha10'] == null)?null:json['alpha10'].toDouble();
    tradeNumber = json['trade_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['stock_own'] = this.stockOwn;
    data['alpha5'] = this.alpha5;
    data['alpha10'] = this.alpha10;
    data['trade_number'] = this.tradeNumber;
    return data;
  }
}