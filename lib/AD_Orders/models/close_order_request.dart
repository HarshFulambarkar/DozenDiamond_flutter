import '../../global/models/api_request_response.dart';

class CloseOrderRequest implements ApiRequestResponse {
  String? orderId;
  String? orderType;

  CloseOrderRequest({this.orderId, this.orderType});

  @override
  CloseOrderRequest fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderType = json['order_type'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = this.orderId;
    data['order_type'] = this.orderType;
    return data;
  }
}
