import '../../global/models/api_request_response.dart';

class TotalPositionTradeActionRequest implements ApiRequestResponse {
  int? tradeId;
  String? tradeOrderPrice;
  int? tradeUnit;
  String? tradeType;

  TotalPositionTradeActionRequest({
    this.tradeId,
    this.tradeOrderPrice,
    this.tradeUnit,
    this.tradeType,
  });

  @override
  TotalPositionTradeActionRequest fromJson(Map<String, dynamic> json) {
    tradeId = json['trade_id'];
    tradeOrderPrice = json['trade_order_price'];
    tradeUnit = json['trade_unit'];
    tradeType = json['trade_type'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['trade_id'] = this.tradeId;
    data['trade_order_price'] = this.tradeOrderPrice;
    data['trade_unit'] = this.tradeUnit;
    data['trade_type'] = this.tradeType;
    return data;
  }
}
