import 'generate_order_data.dart';

class GenerateOrderDataResponse {
  String? message;
  bool? status;
  GenerateOrderData? data;

  GenerateOrderDataResponse({this.message, this.status, this.data});

  GenerateOrderDataResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? new GenerateOrderData.fromJson(json['data']) : null;
    // if (json['data'] != null) {
    //   data = <GenerateOrderData>[];
    //   json['data'].forEach((v) {
    //     data!.add(new GenerateOrderData.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

