import 'package:dozen_diamond/global/models/api_request_response.dart';

class ResetCompleteSimulationResponse implements ApiRequestResponse {
  String? msg;
  bool? status;
  List<int>? data;

  ResetCompleteSimulationResponse({this.msg, this.status, this.data});
  @override
  ResetCompleteSimulationResponse fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    status = json['status'];
    data = json['data'].cast<int>();
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['status'] = this.status;
    data['data'] = this.data;
    return data;
  }
}
