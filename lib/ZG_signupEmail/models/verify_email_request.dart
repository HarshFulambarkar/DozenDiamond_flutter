import '../../global/models/api_request_response.dart';

class VerifyEmailRequest implements ApiRequestResponse {
  String? email;

  VerifyEmailRequest({this.email});

  @override
  VerifyEmailRequest fromJson(Map<String, dynamic> json) {
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
