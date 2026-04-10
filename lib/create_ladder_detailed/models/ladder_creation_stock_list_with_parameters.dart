import 'package:dozen_diamond/global/models/api_request_response.dart';

class LadderCreationStockListWithParameters implements ApiRequestResponse {
  bool? status;
  String? message;
  Success? success;
  List<Data>? data;

  LadderCreationStockListWithParameters(
      {this.status, this.message, this.success, this.data});
  @override
  LadderCreationStockListWithParameters fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    success = json['success'] != null
        ? new Success().fromJson(json['success'])
        : null;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data().fromJson(v));
      });
    }
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
      data['data'] = this.data!.map((v) => v.toJson()).toList();
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
  int? clpId;
  int? clpUserId;
  int? clpStockId;
  bool? isLadderCreated;
  String? clpTargetPrice;
  String? clpMinimumPrice;
  String? clpInitialPurchasePrice;
  int? clpDefaultBuySellQuantity;
  int? clpInitialBuyQuantity;
  String? clpCashAllocated;
  String? clpStepSize;
  Null ladId;
  String? clpStockName;
  int? symSecurityCode;
  List<LadderName>? ladderName;

  Data(
      {this.clpId,
      this.clpUserId,
      this.clpStockId,
      this.isLadderCreated,
      this.clpTargetPrice,
      this.clpMinimumPrice,
      this.clpInitialPurchasePrice,
      this.clpDefaultBuySellQuantity,
      this.clpInitialBuyQuantity,
      this.clpCashAllocated,
      this.clpStepSize,
      this.ladId,
      this.clpStockName,
      this.symSecurityCode,
      this.ladderName});
  @override
  Data fromJson(Map<String, dynamic> json) {
    clpId = json['clp_id'];
    clpUserId = json['clp_user_id'];
    clpStockId = json['clp_stock_id'];
    isLadderCreated = json['is_ladder_created'];
    clpTargetPrice = json['clp_target_price'];
    clpMinimumPrice = json['clp_minimum_price'];
    clpInitialPurchasePrice = json['clp_initial_purchase_price'];
    clpDefaultBuySellQuantity = json['clp_default_buy_sell_quantity'];
    clpInitialBuyQuantity = json['clp_initial_buy_quantity'];
    clpCashAllocated = json['clp_cash_allocated'];
    clpStepSize = json['clp_step_size'];
    ladId = json['lad_id'];
    clpStockName = json['clp_stock_name'];
    symSecurityCode = json['sym_security_code'];
    if (json['ladderName'] != null) {
      ladderName = <LadderName>[];
      json['ladderName'].forEach((v) {
        ladderName!.add(new LadderName().fromJson(v));
      });
    }
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clp_id'] = this.clpId;
    data['clp_user_id'] = this.clpUserId;
    data['clp_stock_id'] = this.clpStockId;
    data['is_ladder_created'] = this.isLadderCreated;
    data['clp_target_price'] = this.clpTargetPrice;
    data['clp_minimum_price'] = this.clpMinimumPrice;
    data['clp_initial_purchase_price'] = this.clpInitialPurchasePrice;
    data['clp_default_buy_sell_quantity'] = this.clpDefaultBuySellQuantity;
    data['clp_initial_buy_quantity'] = this.clpInitialBuyQuantity;
    data['clp_cash_allocated'] = this.clpCashAllocated;
    data['clp_step_size'] = this.clpStepSize;
    data['lad_id'] = this.ladId;
    data['clp_stock_name'] = this.clpStockName;
    data['sym_security_code'] = this.symSecurityCode;
    if (this.ladderName != null) {
      data['ladderName'] = this.ladderName!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LadderName implements ApiRequestResponse {
  int? ladId;
  String? ladLadderName;
  String? ladStatus;
  String? ladStockName;

  LadderName(
      {this.ladId, this.ladLadderName, this.ladStatus, this.ladStockName});
  @override
  LadderName fromJson(Map<String, dynamic> json) {
    ladId = json['lad_id'];
    ladLadderName = json['lad_ladder_name'];
    ladStatus = json['lad_status'];
    ladStockName = json['lad_stock_name'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lad_id'] = this.ladId;
    data['lad_ladder_name'] = this.ladLadderName;
    data['lad_status'] = this.ladStatus;
    data['lad_stock_name'] = this.ladStockName;
    return data;
  }
}
