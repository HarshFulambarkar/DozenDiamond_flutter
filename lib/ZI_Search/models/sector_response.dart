import 'package:dozen_diamond/global/models/api_request_response.dart';

class SectorResponse implements ApiRequestResponse {
  bool? status;
  String? message;
  List<Data>? data;

  SectorResponse({this.status, this.message, this.data});

  SectorResponse fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data().fromJson(v));
      });
    }
    return this;
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

class Data implements ApiRequestResponse {
  int? secId;
  String? secName;

  Data({this.secId, this.secName});

  Data fromJson(Map<String, dynamic> json) {
    secId = json['sec_id'];
    secName = json['sec_name'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sec_id'] = this.secId;
    data['sec_name'] = this.secName;
    return data;
  }
}
