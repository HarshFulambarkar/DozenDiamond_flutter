import 'funds_and_margins_data.dart';

class GetCustomerFundsAndMarginsResponse {
  Data? data;

  GetCustomerFundsAndMarginsResponse({this.data});

  GetCustomerFundsAndMarginsResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  bool? status;
  String? message;
  String? errorcode;
  FundsAndMarginsData? data;

  Data({this.status, this.message, this.errorcode, this.data});

  Data.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    errorcode = json['errorcode'];
    data = json['data'] != null ? new FundsAndMarginsData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['errorcode'] = this.errorcode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

