class SendAadhaarOtpResponse {
  String? requestId;
  int? status;
  Data? data;
  int? timestamp;
  String? path;

  SendAadhaarOtpResponse(
      {this.requestId, this.status, this.data, this.timestamp, this.path});

  SendAadhaarOtpResponse.fromJson(Map<String, dynamic> json) {
    requestId = json['request_id'];
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    timestamp = json['timestamp'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['request_id'] = this.requestId;
    data['status'] = this.status;
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
  String? message;
  String? transactionId;

  Data({this.code, this.message, this.transactionId});

  Data.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    transactionId = json['transaction_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['transaction_id'] = this.transactionId;
    return data;
  }
}