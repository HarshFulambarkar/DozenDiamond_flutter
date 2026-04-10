import '../../global/models/api_request_response.dart';

class ReplicateTradeRequest implements ApiRequestResponse {
  int? tradeId;
  String? tradeExePrice;
  int? tradeUnit;

  ReplicateTradeRequest({this.tradeId, this.tradeExePrice, this.tradeUnit});

  @override
  ReplicateTradeRequest fromJson(Map<String, dynamic> json) {
    tradeId = json['trade_id'];
    tradeExePrice = json['trade_exe_price'];
    tradeUnit = json['trade_unit'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['trade_id'] = this.tradeId;
    data['trade_exe_price'] = this.tradeExePrice;
    data['trade_unit'] = this.tradeUnit;
    return data;
  }
}
