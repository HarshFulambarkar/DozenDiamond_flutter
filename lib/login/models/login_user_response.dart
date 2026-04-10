import '../../global/models/api_request_response.dart';

class LoginUserResponse implements ApiRequestResponse {
  bool? status;
  Data? data;
  String? message;

  LoginUserResponse({this.status, this.data, this.message});

  @override
  LoginUserResponse fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data().fromJson(json['data']) : null;
    message = json['message'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data implements ApiRequestResponse {
  int? regId;
  String? regUsername;
  bool? regMpinExist;
  String? regEmail;
  String? regAccountStatus;
  bool? isSuper;
  bool? emailVerified;
  bool? phoneVerified;
  String? token;

  Data({this.regId, this.regUsername, this.regMpinExist, this.token, this.emailVerified, this.phoneVerified});

  @override
  Data fromJson(Map<String, dynamic> json) {
    regId = json['reg_id'];
    regUsername = json['reg_username'];
    regMpinExist = json['reg_mpin_exist'];
    regEmail = json['reg_email'] ?? "";
    regAccountStatus = json['reg_account_status'] ?? "";
    isSuper = (json['is_super'] == null)
                ? false
                : (json['is_super'].toString() == 'false')
                    ? false : true;
    emailVerified = (json['email_verified'] == null)
        ? true
        : (json['email_verified'].toString() == 'false')
        ? false : true;
    phoneVerified = (json['phone_verified'] == null)
        ? true
        : (json['phone_verified'].toString() == 'false')
        ? false : true;
    token = json['token'] ?? "";
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reg_id'] = this.regId;
    data['reg_username'] = this.regUsername;
    data['reg_mpin_exist'] = this.regMpinExist;
    data['reg_email'] = this.regEmail;
    data['reg_account_status'] = this.regAccountStatus;
    data['is_super'] = this.isSuper;
    data['email_verified'] = this.emailVerified;
    data['phone_verified'] = this.phoneVerified;
    data['token'] = this.token;
    return data;
  }
}
