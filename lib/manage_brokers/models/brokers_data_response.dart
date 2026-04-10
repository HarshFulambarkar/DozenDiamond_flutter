import 'broker_data.dart';

class BrokersDataResponse {
  bool? status;
  String? message;
  List<BrokerData>? data;

  BrokersDataResponse({this.status, this.message, this.data});

  BrokersDataResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <BrokerData>[];
      json['data'].forEach((v) {
        data!.add(new BrokerData.fromJson(v));
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