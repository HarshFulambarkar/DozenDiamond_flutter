class AnalysisAlphaGainVsOpenPriceResponse {
  bool? status;
  String? message;
  Success? success;
  List<Data>? data;

  AnalysisAlphaGainVsOpenPriceResponse({this.status, this.message, this.success, this.data});

  AnalysisAlphaGainVsOpenPriceResponse.fromJson(Map<String, dynamic> json) {
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
  double? alpha5Gain;
  double? alpha10Gain;
  int? tradeNumber;

  Data(
      {this.price,
        this.stockOwn,
        this.alpha5Gain,
        this.alpha10Gain,
        this.tradeNumber});

  Data.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    stockOwn = json['stock_own'];
    alpha5Gain = (json['alpha_5_gain'] == null)?null:json['alpha_5_gain'].toDouble();
    alpha10Gain = (json['alpha_10_gain'] == null)?null:json['alpha_10_gain'].toDouble();
    tradeNumber = json['trade_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['stock_own'] = this.stockOwn;
    data['alpha_5_gain'] = this.alpha5Gain;
    data['alpha_10_gain'] = this.alpha10Gain;
    data['trade_number'] = this.tradeNumber;
    return data;
  }
}