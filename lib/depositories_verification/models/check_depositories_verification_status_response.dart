class CheckDepositoriesVerificationStatusResponse {
  bool? status;
  String? message;
  Data? data;

  CheckDepositoriesVerificationStatusResponse({this.status, this.message, this.data});

  CheckDepositoriesVerificationStatusResponse.fromJson(Map<String, dynamic> json) {
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
  String? brokerStatus;

  Data({this.brokerStatus});

  Data.fromJson(Map<String, dynamic> json) {
    brokerStatus = json['broker_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['broker_status'] = this.brokerStatus;
    return data;
  }
}