import '../../global/models/api_request_response.dart';

class WithdrawCashResponse extends ApiRequestResponse {
  bool? status;
  String? message;

  WithdrawCashResponse({this.status, this.message});

  WithdrawCashResponse fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}