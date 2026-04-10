import 'package:dozen_diamond/global/models/api_request_response.dart';

class AnalyticsUnsettledRecentBuyTableRequest implements ApiRequestResponse {
  String? stockName;
  String? startDate;
  String? endDate;

  AnalyticsUnsettledRecentBuyTableRequest({this.stockName, this.startDate, this.endDate});

  @override
  AnalyticsUnsettledRecentBuyTableRequest fromJson(Map<String, dynamic> json) {
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
