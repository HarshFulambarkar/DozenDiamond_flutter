import '../../global/models/api_request_response.dart';

class ReduceTradeRequest implements ApiRequestResponse {
  int? tradeId;
  String? tradeOrderPrice;
  int? tradeUnit;

  ReduceTradeRequest({this.tradeId, this.tradeOrderPrice, this.tradeUnit});

  @override
  ReduceTradeRequest fromJson(Map<String, dynamic> json) {
    tradeId = json['trade_id'];
    tradeOrderPrice = json['trade_order_price'];
    tradeUnit = json['trade_unit'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['trade_id'] = this.tradeId;
    data['trade_order_price'] = this.tradeOrderPrice;
    data['trade_unit'] = this.tradeUnit;
    return data;
  }
}
