class StockHoldingResponse {
  bool? status;
  String? message;
  Data? data;

  StockHoldingResponse({this.status, this.message, this.data});

  StockHoldingResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? stockName;
  String? stockExchange;
  int? quantity;
  double? averagePrice;

  Data({this.stockName, this.stockExchange, this.quantity, this.averagePrice});

  Data.fromJson(Map<String, dynamic> json) {
    stockName = json['stock_name'];
    stockExchange = json['stock_exchange'];
    quantity = json['quantity'];
    averagePrice = json['average_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stock_name'] = this.stockName;
    data['stock_exchange'] = this.stockExchange;
    data['quantity'] = this.quantity;
    data['average_price'] = this.averagePrice;
    return data;
  }
}