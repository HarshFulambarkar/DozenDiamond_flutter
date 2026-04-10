import 'package:dozen_diamond/global/models/api_request_response.dart';

class StockHistoricalDataRequest implements ApiRequestResponse {
  String? symbolName;
  int? monthframe;
  String? exchange;

  StockHistoricalDataRequest({this.symbolName, this.monthframe, this.exchange});
  @override
  StockHistoricalDataRequest fromJson(Map<String, dynamic> json) {
    symbolName = json['symbolName'];
    monthframe = json['monthframe'];
    exchange = json['exchange'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['symbolName'] = this.symbolName;
    data['monthframe'] = this.monthframe;
    data['exchange'] = this.exchange;
    return data;
  }
}
