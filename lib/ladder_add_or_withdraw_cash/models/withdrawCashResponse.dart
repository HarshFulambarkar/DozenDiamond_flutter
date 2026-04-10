import '../../global/models/api_request_response.dart';

class WithdrawCashResponse implements ApiRequestResponse {
  String? message;
  bool? status;
  Success? success;

  WithdrawCashResponse({this.message, this.status, this.success});
  @override
  WithdrawCashResponse fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    success = json['success'] != null
        ? new Success().fromJson(json['success'])
        : null;
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.success != null) {
      data['success'] = this.success!.toJson();
    }
    return data;
  }
}

class Success implements ApiRequestResponse {
  String? description;
  String? suggestion;

  Success({this.description, this.suggestion});
  @override
  Success fromJson(Map<String, dynamic> json) {
    description = json['description'];
    suggestion = json['suggestion'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['suggestion'] = this.suggestion;
    return data;
  }
}
