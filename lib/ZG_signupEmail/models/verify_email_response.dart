import '../../global/models/api_request_response.dart';

class VerifyEmailResponse implements ApiRequestResponse {
  bool? status;
  String? message;

  VerifyEmailResponse({this.status, this.message});

  @override
  VerifyEmailResponse fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = status;
    data['message'] = message;
    return data;
  }
}
