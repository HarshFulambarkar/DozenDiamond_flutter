import 'package:dozen_diamond/global/models/api_request_response.dart';

class LadderCreationStockList implements ApiRequestResponse {
  String? message;
  bool? status;

  LadderCreationStockList({this.message, this.status});
  @override
  LadderCreationStockList fromJson(Map<String, dynamic> json) {
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
