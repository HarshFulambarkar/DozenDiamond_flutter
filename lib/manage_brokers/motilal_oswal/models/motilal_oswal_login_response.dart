class MotilalOswalLoginResponse {
  bool? status;
  String? message;
  Data? data;

  MotilalOswalLoginResponse({this.status, this.message, this.data});

  MotilalOswalLoginResponse.fromJson(Map<String, dynamic> json) {
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
  String? authToken;
  String? isAuthTokenVerified;

  Data(
      {this.status,
        this.message,
        this.errorcode,
        this.authToken,
        this.isAuthTokenVerified});

  Data.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    errorcode = json['errorcode'];
    authToken = json['AuthToken'];
    isAuthTokenVerified = json['isAuthTokenVerified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['errorcode'] = this.errorcode;
    data['AuthToken'] = this.authToken;
    data['isAuthTokenVerified'] = this.isAuthTokenVerified;
    return data;
  }
}