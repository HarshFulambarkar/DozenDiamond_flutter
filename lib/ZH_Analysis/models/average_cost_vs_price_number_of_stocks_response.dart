class AverageCostVsPriceNumberOfStocksResponse {
  bool? status;
  String? message;
  Success? success;
  List<Data>? data;

  AverageCostVsPriceNumberOfStocksResponse({this.status, this.message, this.success, this.data});

  AverageCostVsPriceNumberOfStocksResponse.fromJson(Map<String, dynamic> json) {
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
  double? averageCost;
  double? price;
  int? numberOfStocks;
  String? type;


  Data(
      {this.tradeNumber,
        this.stockName,
        this.averageCost,
        this.price,
        this.numberOfStocks,
        this.type
      });

  Data.fromJson(Map<String, dynamic> json) {
    tradeNumber = json['trade_number'];
    stockName = json['stock_name'];
    averageCost = json['average cost'].toDouble();
    price = json['price'].toDouble();
    numberOfStocks = json['number_of_stocks'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trade_number'] = this.tradeNumber;
    data['stock_name'] = this.stockName;
    data['average cost'] = this.averageCost;
    data['price'] = this.price;
    data['number_of_stocks'] = this.numberOfStocks;
    data['type'] = this.type;
    return data;
  }
}