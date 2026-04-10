import 'package:dozen_diamond/global/models/api_request_response.dart';

class CopyLadderRequest implements ApiRequestResponse {
  int? clpId;
  int? ladId;

  CopyLadderRequest({this.clpId, this.ladId});

  @override
  CopyLadderRequest fromJson(Map<String, dynamic> json) {
    clpId = json['clp_id'];
    ladId = json['lad_id'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clp_id'] = this.clpId;
    data['lad_id'] = this.ladId;
    return data;
  }
}
