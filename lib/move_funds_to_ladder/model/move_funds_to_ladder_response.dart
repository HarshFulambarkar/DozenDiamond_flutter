import '../../global/models/api_request_response.dart';

class MoveFundsToLadderResponse implements ApiRequestResponse {
  String? message;
  bool? status;

  MoveFundsToLadderResponse({this.message, this.status});
  @override
  MoveFundsToLadderResponse fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];

    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;

    return data;
  }
}
