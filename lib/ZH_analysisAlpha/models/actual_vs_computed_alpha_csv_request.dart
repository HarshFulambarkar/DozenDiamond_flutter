import 'package:dozen_diamond/global/models/api_request_response.dart';

class ActualVsComputedAlphaCsvRequest implements ApiRequestResponse {
  String? stockName;
  int? month;

  ActualVsComputedAlphaCsvRequest({this.stockName, this.month});

  @override
  ActualVsComputedAlphaCsvRequest fromJson(Map<String, dynamic> json) {
    stockName = json['stock_name'];
    month = json['month'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stock_name'] = this.stockName;
    data['month'] = this.month;
    return data;
  }
}
