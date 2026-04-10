import 'package:dozen_diamond/global/models/api_request_response.dart';

class ClosedOrderPriceAndUnitsResponse implements ApiRequestResponse {
  bool? status;
  String? message;
  List<Data>? data;

  ClosedOrderPriceAndUnitsResponse({this.status, this.message, this.data});

  ClosedOrderPriceAndUnitsResponse fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data().fromJson(v));
      });
    }
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data implements ApiRequestResponse {
  int? id;
  int? units;
  String? stockName;
  String? type;
  String? executionPrice;
  String? createdAt;

  Data(
      {this.id,
      this.units,
      this.stockName,
      this.type,
      this.executionPrice,
      this.createdAt});

  Data fromJson(Map<String, dynamic> json) {
    id = json['id'];
    units = json['units'];
    stockName = json['stock_name'];
    type = json['type'];
    executionPrice = json['execution_price'];
    createdAt = json['createdAt'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['units'] = this.units;
    data['stock_name'] = this.stockName;
    data['type'] = this.type;
    data['execution_price'] = this.executionPrice;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
