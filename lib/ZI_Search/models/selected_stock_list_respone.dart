import 'package:dozen_diamond/ZI_Search/models/selected_stock_model.dart';

class SelectedStockListResponse {
  bool? status;
  String? message;
  Success? success;
  List<SelectedTickerModel>? data = [];

  SelectedStockListResponse(
      {this.status, this.message, this.success, this.data});

  SelectedStockListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    success =
        json['success'] != null ? new Success.fromJson(json['success']) : null;
    if (json['data'] != null) {
      data = <SelectedTickerModel>[];
      json['data'].forEach((v) {
        data!.add(new SelectedTickerModel().fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.success != null) {
      data['success'] = this.success!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Success {
  String? description;
  String? suggestion;

  Success({this.description, this.suggestion});

  Success.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    suggestion = json['suggestion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['suggestion'] = this.suggestion;
    return data;
  }
}
