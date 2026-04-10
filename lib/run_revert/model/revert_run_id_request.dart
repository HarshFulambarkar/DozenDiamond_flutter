import 'package:dozen_diamond/global/models/api_request_response.dart';

class RevertRunIdRequest implements ApiRequestResponse {
  int? runId;

  RevertRunIdRequest({this.runId});

  RevertRunIdRequest fromJson(Map<String, dynamic> json) {
    runId = json['run_id'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['run_id'] = this.runId;
    return data;
  }
}
