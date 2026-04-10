class TradeTableResponse {
  bool? status;
  String? message;
  Success? success;
  List<TradeDataData>? data;
  Total? total;

  TradeTableResponse(
      {this.status, this.message, this.success, this.data, this.total});

  TradeTableResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    success =
    json['success'] != null ? new Success.fromJson(json['success']) : null;
    if (json['data'] != null) {
      data = <TradeDataData>[];
      json['data'].forEach((v) {
        data!.add(new TradeDataData.fromJson(v));
      });
    }
    total = json['total'] != null ? new Total.fromJson(json['total']) : null;
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
    if (this.total != null) {
      data['total'] = this.total!.toJson();
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

class TradeDataData {
  int? tradeNumber;
  String? stockName;
  double? price;
  int? units;
  double? cashGain;
  String? timestamp;

  TradeDataData(
      {this.tradeNumber,
        this.stockName,
        this.price,
        this.units,
        this.cashGain,
        this.timestamp});

  TradeDataData.fromJson(Map<String, dynamic> json) {
    tradeNumber = json['trade_number'];
    stockName = json['stock_name'];
    price = json['price'].toDouble();
    units = json['units'];
    cashGain = json['cash_gain'].toDouble();
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trade_number'] = this.tradeNumber;
    data['stock_name'] = this.stockName;
    data['price'] = this.price;
    data['units'] = this.units;
    data['cash_gain'] = this.cashGain;
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class Total {
  double? netCashGain;
  int? netStockBought;
  int? netStockSold;

  Total({this.netCashGain, this.netStockBought, this.netStockSold});

  Total.fromJson(Map<String, dynamic> json) {
    netCashGain = json['net_cash_gain'].toDouble();
    netStockBought = json['net_stock_bought'];
    netStockSold = json['net_stock_sold'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['net_cash_gain'] = this.netCashGain;
    data['net_stock_bought'] = this.netStockBought;
    data['net_stock_sold'] = this.netStockSold;
    return data;
  }
}