class MotilalOswalVerifyOtpResponse {
  bool? status;
  String? message;
  Data? data;

  MotilalOswalVerifyOtpResponse({this.status, this.message, this.data});

  MotilalOswalVerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? status;
  String? message;
  String? errorcode;

  Data({this.status, this.message, this.errorcode});

  Data.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    errorcode = json['errorcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['errorcode'] = this.errorcode;
    return data;
  }
}