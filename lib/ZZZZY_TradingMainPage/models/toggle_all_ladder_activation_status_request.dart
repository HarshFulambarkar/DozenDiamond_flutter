import '../../global/models/api_request_response.dart';

class ToggleAllLadderActivationStatusRequest implements ApiRequestResponse {
  String? ladStatus;

  ToggleAllLadderActivationStatusRequest({this.ladStatus});

  @override
  ToggleAllLadderActivationStatusRequest fromJson(Map<String, dynamic> json) {
    ladStatus = json['lad_status'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lad_status'] = this.ladStatus;
    return data;
  }
}
