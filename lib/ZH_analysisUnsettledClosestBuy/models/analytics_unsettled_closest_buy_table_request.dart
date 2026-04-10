import 'package:dozen_diamond/global/models/api_request_response.dart';

class AnalyticsUnsettledClosestBuyTableRequest implements ApiRequestResponse {
  String? stockName;
  String? startDate;
  String? endDate;

  AnalyticsUnsettledClosestBuyTableRequest({this.stockName,  this.startDate, this.endDate});

  @override
  AnalyticsUnsettledClosestBuyTableRequest fromJson(Map<String, dynamic> json) {
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
