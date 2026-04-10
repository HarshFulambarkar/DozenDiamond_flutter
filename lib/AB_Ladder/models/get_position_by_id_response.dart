import '../../global/models/api_request_response.dart';

class GetPositionByIdResponse implements ApiRequestResponse {
  bool? status;
  String? message;
  Success? success;
  Data? data;

  GetPositionByIdResponse({this.status, this.message, this.success, this.data});
  @override
  GetPositionByIdResponse fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    success = json['success'] != null
        ? new Success().fromJson(json['success'])
        : null;
    data = json['data'] != null ? new Data().fromJson(json['data']) : null;
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.success != null) {
      data['success'] = this.success!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Success implements ApiRequestResponse {
  String? description;
  String? suggestion;

  Success({this.description, this.suggestion});
  @override
  Success fromJson(Map<String, dynamic> json) {
    description = json['description'];
    suggestion = json['suggestion'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['suggestion'] = this.suggestion;
    return data;
  }
}

class Data implements ApiRequestResponse {
  int? posId;
  int? posTotalBuyQty;
  String? posStockName;
  String? posLadName;
  int? userId;
  String? posStatus;
  int? ladId;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.posId,
      this.posTotalBuyQty,
      this.posStockName,
      this.posLadName,
      this.userId,
      this.posStatus,
      this.ladId,
      this.createdAt,
      this.updatedAt});
  @override
  Data fromJson(Map<String, dynamic> json) {
    posId = json['pos_id'];
    posTotalBuyQty = json['pos_total_buy_qty'];
    posStockName = json['pos_stock_name'];
    posLadName = json['pos_lad_name'];
    userId = json['user_id'];
    posStatus = json['pos_status'];
    ladId = json['lad_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pos_id'] = this.posId;
    data['pos_total_buy_qty'] = this.posTotalBuyQty;
    data['pos_stock_name'] = this.posStockName;
    data['pos_lad_name'] = this.posLadName;
    data['user_id'] = this.userId;
    data['pos_status'] = this.posStatus;
    data['lad_id'] = this.ladId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
