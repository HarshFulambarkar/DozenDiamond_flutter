import '../../global/models/api_request_response.dart';

class UpdateLadderResponse implements ApiRequestResponse {
  List<int>? data;
  bool? status;
  String? msg;

  UpdateLadderResponse({this.data, this.status, this.msg});

  @override
  UpdateLadderResponse fromJson(Map<String, dynamic> json) {
    return UpdateLadderResponse(
      data: json['data'] != null ? json['data'].cast<int>() : [],
      status: json['status'],
      msg: json['msg'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = this.data;
    data['status'] = status;
    data['msg'] = msg;
    return data;
  }
}
