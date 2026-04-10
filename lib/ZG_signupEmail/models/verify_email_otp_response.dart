import '../../global/models/api_request_response.dart';

class VerifyEmailOtpResponse implements ApiRequestResponse {
  Data? data;
  bool? status;
  String? msg;

  VerifyEmailOtpResponse({this.data, this.status, this.msg});

  @override
  VerifyEmailOtpResponse fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data().fromJson(json['data']) : null;
    status = json['status'];
    msg = json['msg'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['status'] = this.status;
    data['msg'] = this.msg;
    return data;
  }
}

class Data implements ApiRequestResponse {
  int? regId;
  String? regUsername;
  String? regMpin;

  Data({
    this.regId,
    this.regUsername,
    this.regMpin,
  });

  @override
  Data fromJson(Map<String, dynamic> json) {
    regId = json['reg_id'];
    regUsername = json['reg_username'];
    regMpin = json['reg_mpin'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reg_id'] = this.regId;
    data['reg_username'] = this.regUsername;
    data['reg_mpin'] = this.regMpin;
    return data;
  }
}
