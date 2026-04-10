import 'package:dozen_diamond/broker_info/models/total_holding_data.dart';

import 'holding_data.dart';

class GetAllHoldingsResponse {
  GetAllHoldingsData? data;

  GetAllHoldingsResponse({this.data});

  GetAllHoldingsResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new GetAllHoldingsData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class GetAllHoldingsData {
  bool? status;
  String? message;
  String? errorcode;
  Data? data;

  GetAllHoldingsData({this.status, this.message, this.errorcode, this.data});

  GetAllHoldingsData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    errorcode = json['errorcode'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  List<HoldingData>? holdings;
  Totalholding? totalholding;

  Data({this.holdings, this.totalholding});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['holdings'] != null) {
      holdings = <HoldingData>[];
      json['holdings'].forEach((v) {
        holdings!.add(new HoldingData.fromJson(v));
      });
    }
    totalholding = json['totalholding'] != null
        ? new Totalholding.fromJson(json['totalholding'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.holdings != null) {
      data['holdings'] = this.holdings!.map((v) => v.toJson()).toList();
    }
    if (this.totalholding != null) {
      data['totalholding'] = this.totalholding!.toJson();
    }
    return data;
  }
}