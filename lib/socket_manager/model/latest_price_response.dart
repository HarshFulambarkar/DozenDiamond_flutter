class LatestPriceResponse {
  bool? status;
  String? message;
  List<LatestPriceData>? data;

  LatestPriceResponse({this.status, this.message, this.data});

  LatestPriceResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <LatestPriceData>[];
      json['data'].forEach((v) {
        data!.add(new LatestPriceData.fromJson(v));
      });
    }
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

class LatestPriceData {
  int? tickerId;
  String? tickerPrice;
  String? tickerName;

  LatestPriceData({this.tickerId, this.tickerPrice, this.tickerName});

  LatestPriceData.fromJson(Map<String, dynamic> json) {
    tickerId = json['ticker_id'];
    tickerPrice = json['ticker_price'];
    tickerName = json['ticker_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ticker_id'] = this.tickerId;
    data['ticker_price'] = this.tickerPrice;
    data['ticker_name'] = this.tickerName;
    return data;
  }
}