class GradedOrderData {
  String? type;
  int? orderId;
  String? message;

  GradedOrderData({this.type, this.orderId, this.message});

  GradedOrderData.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    orderId = json['orderId'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['orderId'] = this.orderId;
    data['message'] = this.message;
    return data;
  }
}