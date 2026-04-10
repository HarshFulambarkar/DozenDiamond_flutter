import '../../global/models/api_request_response.dart';

class ResetCreationStockList implements ApiRequestResponse {
  bool? status;
  String? message;
  Null data;

  ResetCreationStockList({this.status, this.message, this.data});
  @override
  ResetCreationStockList fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['data'] = this.data;
    return data;
  }
}
