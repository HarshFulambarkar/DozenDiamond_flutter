import 'package:dozen_diamond/global/models/api_request_response.dart';

class ActualVscomputedAlphaRequest implements ApiRequestResponse {
  String? stockName;
  int? month;

  ActualVscomputedAlphaRequest({this.stockName, this.month});

  @override
  ActualVscomputedAlphaRequest fromJson(Map<String, dynamic> json) {
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
