class AngleOneLogoutResponse {
  bool? status;
  String? message;
  Data? data;

  AngleOneLogoutResponse({this.status, this.message, this.data});

  AngleOneLogoutResponse.fromJson(Map<String, dynamic> json) {
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
  bool? status;
  String? message;
  String? errorcode;
  String? data;

  Data({this.status, this.message, this.errorcode, this.data});

  Data.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    errorcode = json['errorcode'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['errorcode'] = this.errorcode;
    data['data'] = this.data;
    return data;
  }
}