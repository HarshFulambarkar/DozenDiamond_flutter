class ResetPasswordLinkRequest {
  String? newpassword;
  String? confirmPassword;
  String? otp;

  ResetPasswordLinkRequest({this.newpassword, this.confirmPassword, this.otp});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['newPassword'] = newpassword;
    data['confirmPassword'] = confirmPassword;
    return data;
  }
}
