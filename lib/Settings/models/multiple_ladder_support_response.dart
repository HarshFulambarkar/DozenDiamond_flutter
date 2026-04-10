import '../../global/models/api_request_response.dart';

class MultipleLadderSupportResponse implements ApiRequestResponse {
  List<int>? data;
  bool? status;
  String? msg;

  MultipleLadderSupportResponse({this.data, this.status, this.msg});

  @override
  MultipleLadderSupportResponse fromJson(Map<String, dynamic> json) {
    data = json['data'].cast<int>();
    status = json['status'];
    msg = json['msg'];
    return this;
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
