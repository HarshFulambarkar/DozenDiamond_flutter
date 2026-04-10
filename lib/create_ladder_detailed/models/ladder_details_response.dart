import 'package:dozen_diamond/global/models/api_request_response.dart';

class LadderDetailsResponse implements ApiRequestResponse {
  bool? status;
  String? message;
  Success? success;
  LaddersDetail? laddersDetail;

  LadderDetailsResponse(
      {this.status, this.message, this.success, this.laddersDetail});
  @override
  LadderDetailsResponse fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    success = json['success'] != null
        ? new Success().fromJson(json['success'])
        : null;
    laddersDetail = json['data'] != null
        ? new LaddersDetail().fromJson(json['data'])
        : null;
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
    if (this.laddersDetail != null) {
      data['data'] = this.laddersDetail!.toJson();
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

class LaddersDetail implements ApiRequestResponse {
  String? ladLadderName;
  String? ladStockName;
  int? ladInitialBuyQuantity;
  String? ladInitialPurchasePrice;
  String? ladTargetPrice;
  int? ladDefaultBuySellQuantity;
  String? ladMinimumPrice;
  String? ladStatus;
  String? ladCashInitialAllocated;
  String? ladStepSize;

  LaddersDetail(
      {this.ladLadderName,
      this.ladStockName,
      this.ladInitialBuyQuantity,
      this.ladInitialPurchasePrice,
      this.ladTargetPrice,
      this.ladDefaultBuySellQuantity,
      this.ladMinimumPrice,
      this.ladStatus,
      this.ladCashInitialAllocated,
      this.ladStepSize});
  @override
  LaddersDetail fromJson(Map<String, dynamic> json) {
    ladLadderName = json['lad_ladder_name'];
    ladStockName = json['lad_stock_name'];
    ladInitialBuyQuantity = json['lad_initial_buy_quantity'];
    ladInitialPurchasePrice = json['lad_initial_purchase_price'];
    ladTargetPrice = json['lad_target_price'];
    ladDefaultBuySellQuantity = json['lad_default_buy_sell_quantity'];
    ladMinimumPrice = json['lad_minimum_price'];
    ladStatus = json['lad_status'];
    ladCashInitialAllocated = json['lad_cash_initial_allocated'];
    ladStepSize = json['lad_step_size'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lad_ladder_name'] = this.ladLadderName;
    data['lad_stock_name'] = this.ladStockName;
    data['lad_initial_buy_quantity'] = this.ladInitialBuyQuantity;
    data['lad_initial_purchase_price'] = this.ladInitialPurchasePrice;
    data['lad_target_price'] = this.ladTargetPrice;
    data['lad_default_buy_sell_quantity'] = this.ladDefaultBuySellQuantity;
    data['lad_minimum_price'] = this.ladMinimumPrice;
    data['lad_status'] = this.ladStatus;
    data['lad_cash_initial_allocated'] = this.ladCashInitialAllocated;
    data['lad_step_size'] = this.ladStepSize;
    return data;
  }
}
