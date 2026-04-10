
class AlphaGainVsOpenPriceRequest {
  String? stockName;
  String? startDate;
  String? endDate;

  AlphaGainVsOpenPriceRequest(
      {this.stockName, this.startDate, this.endDate});

  AlphaGainVsOpenPriceRequest fromJson(Map<String, dynamic> json) {
    stockName = json['stock_name'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stock_name'] = this.stockName;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    return data;
  }
}