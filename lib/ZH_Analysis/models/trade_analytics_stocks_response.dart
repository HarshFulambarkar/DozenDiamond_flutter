import 'package:dozen_diamond/global/models/api_request_response.dart';

class TradeAnalyticsStocksResponse implements ApiRequestResponse {
  bool? status;
  String? message;
  Success? success;
  List<String>? data;

  TradeAnalyticsStocksResponse(
      {this.status, this.message, this.success, this.data});

  TradeAnalyticsStocksResponse fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    success = json['success'] != null
        ? new Success().fromJson(json['success'])
        : null;
    data = json['data'].cast<String>();
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.success != null) {
      data['success'] = this.success!.toJson();
    }
    data['data'] = this.data;
    return data;
  }
}

class Success implements ApiRequestResponse {
  String? description;
  String? suggestion;

  Success({this.description, this.suggestion});

  Success fromJson(Map<String, dynamic> json) {
    description = json['description'];
    suggestion = json['suggestion'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['suggestion'] = this.suggestion;
    return data;
  }
}
