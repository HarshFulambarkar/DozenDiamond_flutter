import '../../global/models/api_request_response.dart';

class RegisterUserRequest implements ApiRequestResponse {
  String? firstName;
  String? lastName;
  String? password;
  String? confirmPassword;
  String? emailId;
  String? mobileNo;
  String? fcmToken;
  String? country;
  String? state;
  String? city;


  RegisterUserRequest({
    this.firstName,
    this.lastName,
    this.password,
    this.emailId,
    this.mobileNo,
    this.confirmPassword,
    this.fcmToken,
    this.country,
    this.state,
    this.city,
  });

  @override
  RegisterUserRequest fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    password = json['password'];
    confirmPassword = json['confirmPassword'];
    emailId = json['emailId'];
    mobileNo = json['mobileNo'];
    fcmToken = json['fcm_token'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['password'] = password;
    data['confirmPassword'] = confirmPassword;
    data['emailId'] = emailId;
    data['mobileNo'] = mobileNo;
    data['fcm_token'] = fcmToken;
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    return data;
  }
}
