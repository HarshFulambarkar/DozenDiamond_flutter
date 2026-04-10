import 'package:dozen_diamond/global/models/api_request_response.dart';

class LadderDetailsRequest implements ApiRequestResponse {
  int? ladId;

  LadderDetailsRequest({this.ladId});

  @override
  LadderDetailsRequest fromJson(Map<String, dynamic> json) {
    ladId = json['lad_id'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lad_id'] = this.ladId;
    return data;
  }
}
