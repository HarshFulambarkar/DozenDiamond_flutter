import 'package:dozen_diamond/global/models/api_request_response.dart';

class ToggleCountryResponse extends ApiRequestResponse {
  bool? status;
  String? message;
  List<int>? data;

  ToggleCountryResponse({this.status, this.message, this.data});

  ToggleCountryResponse fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'].cast<int>();
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['data'] = this.data;
    return data;
  }
}
