class PriceVsValueVsNoOfStocksRequest {
  String? stockName;
  String? startDate;
  String? endDate;

  PriceVsValueVsNoOfStocksRequest(
      {this.stockName, this.startDate, this.endDate});

  PriceVsValueVsNoOfStocksRequest.fromJson(Map<String, dynamic> json) {
    stockName = json['stock_name'];
    startDate = json['startDate'];
    endDate = json['endDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stock_name'] = this.stockName;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    return data;
  }
}
