import 'graded_order_data.dart';

class GradedOrderListResponse {
  bool? status;
  String? message;
  List<GradedOrderData>? data;

  GradedOrderListResponse({this.status, this.message, this.data});

  GradedOrderListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <GradedOrderData>[];
      json['data'].forEach((v) {
        data!.add(new GradedOrderData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

