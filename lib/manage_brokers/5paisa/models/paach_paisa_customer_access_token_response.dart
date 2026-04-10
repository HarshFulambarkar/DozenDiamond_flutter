class PaachPaiseCustomerAccessTokenResponse {
  bool? status;
  String? message;
  Data? data;

  PaachPaiseCustomerAccessTokenResponse({this.status, this.message, this.data});

  PaachPaiseCustomerAccessTokenResponse.fromJson(Map<String, dynamic> json) {
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
  String? brokerName;

  Data({this.brokerName});

  Data.fromJson(Map<String, dynamic> json) {
    brokerName = json['broker_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['broker_name'] = this.brokerName;
    return data;
  }
}