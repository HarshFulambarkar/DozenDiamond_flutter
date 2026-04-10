import 'package:dozen_diamond/global/models/api_request_response.dart';

class UnsettledRecentBuyCsvRequest implements ApiRequestResponse {
  String? stockName;
  String? startDate;
  String? endDate;

  UnsettledRecentBuyCsvRequest({this.stockName, this.startDate, this.endDate});

  @override
  UnsettledRecentBuyCsvRequest fromJson(Map<String, dynamic> json) {
    stockName = json['stock_name'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stock_name'] = this.stockName;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    return data;
  }
}
