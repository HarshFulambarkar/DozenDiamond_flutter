import 'holding_data.dart';

class GetHoldingsResponse {
  GetHoldingsData? data;

  GetHoldingsResponse({this.data});

  GetHoldingsResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new GetHoldingsData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class GetHoldingsData {
  bool? status;
  String? message;
  String? errorcode;
  List<HoldingData>? data;

  GetHoldingsData({this.status, this.message, this.errorcode, this.data});

  GetHoldingsData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    errorcode = json['errorcode'];
    if (json['data'] != null) {
      data = <HoldingData>[];
      json['data'].forEach((v) {
        data!.add(new HoldingData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['errorcode'] = this.errorcode;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

