import 'package:dozen_diamond/global/models/api_request_response.dart';

class ToggleCountryRequest extends ApiRequestResponse {
  String? country;

  ToggleCountryRequest({this.country});

  ToggleCountryRequest fromJson(Map<String, dynamic> json) {
    country = json['country'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    return data;
  }
}
