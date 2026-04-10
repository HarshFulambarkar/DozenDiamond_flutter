class LadderCreationParameterValues {
  String? msg;
  bool? status;
  Data? data;

  LadderCreationParameterValues({this.msg, this.status, this.data});

  LadderCreationParameterValues.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
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
  String? clpStockName;

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
      this.clpStockName});

  Data.fromJson(Map<String, dynamic> json) {
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
    clpStockName = json['clp_stock_name'];
  }

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
    data['clp_stock_name'] = this.clpStockName;
    return data;
  }
}
