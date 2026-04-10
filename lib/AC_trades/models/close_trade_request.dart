import '../../global/models/api_request_response.dart';

class CloseTradeRequest implements ApiRequestResponse {
  int? tradeId;
  bool? repurchaseAfterSale;

  CloseTradeRequest({this.tradeId, this.repurchaseAfterSale});

  @override
  CloseTradeRequest fromJson(Map<String, dynamic> json) {
    return CloseTradeRequest(
      tradeId: json['trade_id'],
      repurchaseAfterSale: json['repurchase_after_sale'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['trade_id'] = this.tradeId;
    data['repurchase_after_sale'] = this.repurchaseAfterSale;
    return data;
  }
}
