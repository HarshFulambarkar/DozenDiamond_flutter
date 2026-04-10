import '../../global/models/api_request_response.dart';

class ForgotPasswordRequest implements ApiRequestResponse {
  String? email;

  ForgotPasswordRequest({this.email});

  @override
  ForgotPasswordRequest fromJson(Map<String, dynamic> json) {
    email = json['email'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    return data;
  }
}
