import 'package:dozen_diamond/profile/model/profile_data.dart';

class UpdateProfileDataResponse {
  bool? status;
  String? message;
  ProfileData? data;

  UpdateProfileDataResponse({this.status, this.message, this.data});

  UpdateProfileDataResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new ProfileData.fromJson(json['data']) : null;
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