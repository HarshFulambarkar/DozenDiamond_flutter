import 'aadhaar_data.dart';

class SubmitAadhaarOtpResponse {
  String? requestId;
  Data? data;
  int? timestamp;
  String? path;

  SubmitAadhaarOtpResponse({this.requestId, this.data, this.timestamp, this.path});

  SubmitAadhaarOtpResponse.fromJson(Map<String, dynamic> json) {
    requestId = json['request_id'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    timestamp = json['timestamp'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['request_id'] = this.requestId;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['timestamp'] = this.timestamp;
    data['path'] = this.path;
    return data;
  }
}

class Data {
  String? code;
  String? transactionId;
  String? message;
  String? shareCode;
  AadhaarData? aadhaarData;

  Data(
      {this.code,
        this.transactionId,
        this.message,
        this.shareCode,
        this.aadhaarData});

  Data.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    transactionId = json['transaction_id'];
    message = json['message'];
    shareCode = json['share_code'];
    aadhaarData = json['aadhaar_data'] != null
        ? new AadhaarData.fromJson(json['aadhaar_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['transaction_id'] = this.transactionId;
    data['message'] = this.message;
    data['share_code'] = this.shareCode;
    if (this.aadhaarData != null) {
      data['aadhaar_data'] = this.aadhaarData!.toJson();
    }
    return data;
  }
}