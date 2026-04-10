import 'package:dozen_diamond/global/models/api_request_response.dart';

class CashEmptyLadderRequest extends ApiRequestResponse {
  int? ladId;

  CashEmptyLadderRequest({this.ladId});

  CashEmptyLadderRequest fromJson(Map<String, dynamic> json) {
    ladId = json['lad_id'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lad_id'] = this.ladId;
    return data;
  }
}
