import 'package:dozen_diamond/global/models/api_request_response.dart';

class StockHistoricalDataResponse implements ApiRequestResponse {
  bool? status;
  String? message;
  Success? success;
  int? totalCount;
  List<Data>? data;

  StockHistoricalDataResponse(
      {this.status, this.message, this.success, this.totalCount, this.data});
  @override
  StockHistoricalDataResponse fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    success = json['Success'] != null
        ? new Success().fromJson(json['Success'])
        : null;
    totalCount = json['totalCount'] ?? 0;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data().fromJson(v));
      });
    }else{
      data = [];
    }
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.success != null) {
      data['Success'] = this.success!.toJson();
    }
    data['totalCount'] = this.totalCount;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Success implements ApiRequestResponse {
  String? suggestion;
  String? description;

  Success({this.suggestion, this.description});
  @override
  Success fromJson(Map<String, dynamic> json) {
    suggestion = json['suggestion'];
    description = json['description'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['suggestion'] = this.suggestion;
    data['description'] = this.description;
    return data;
  }
}

class Data implements ApiRequestResponse {
  String? ticker;
  String? date;
  String? close;
  String? time;

  Data({this.ticker, this.date, this.close, this.time});
  @override
  Data fromJson(Map<String, dynamic> json) {
    ticker = json['Ticker'];
    date = json['Date'];
    close = json['Close'];
    time = json['Time'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Ticker'] = this.ticker;
    data['Date'] = this.date;
    data['Close'] = this.close;
    data['Time'] = this.time;
    return data;
  }
}
