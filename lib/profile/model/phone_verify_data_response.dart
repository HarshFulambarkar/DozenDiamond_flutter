class PhoneVerifyDataResponse {
  bool? status;
  String? message;
  Success? success;

  PhoneVerifyDataResponse({this.status, this.message, this.success});

  PhoneVerifyDataResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    success =
    json['success'] != null ? new Success.fromJson(json['success']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.success != null) {
      data['success'] = this.success!.toJson();
    }
    return data;
  }
}

class Success {
  String? description;
  String? suggestion;

  Success({this.description, this.suggestion});

  Success.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    suggestion = json['suggestion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['suggestion'] = this.suggestion;
    return data;
  }
}