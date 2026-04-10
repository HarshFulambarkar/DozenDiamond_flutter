class KotakNeoOtpResponse {
  bool? status;
  String? message;
  Data? data;

  KotakNeoOtpResponse({this.status, this.message, this.data});

  KotakNeoOtpResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String? sid;
  String? rid;
  String? greetingName;
  String? subId;
  String? token;
  String? accessToken;

  Data(
      {this.sid,
        this.rid,
        this.greetingName,
        this.subId,
        this.token,
        this.accessToken});

  Data.fromJson(Map<String, dynamic> json) {
    sid = json['sid'];
    rid = json['rid'];
    greetingName = json['greetingName'];
    subId = json['sub_id'];
    token = json['token'];
    accessToken = json['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sid'] = this.sid;
    data['rid'] = this.rid;
    data['greetingName'] = this.greetingName;
    data['sub_id'] = this.subId;
    data['token'] = this.token;
    data['accessToken'] = this.accessToken;
    return data;
  }
}