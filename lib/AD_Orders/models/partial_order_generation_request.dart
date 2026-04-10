class PartialOrderGenerationRequest {
  int? orderId;
  int? ladId;
  int? securityCode;
  String? orderType;
  String? orderStockName;
  String? orderLadderName;
  String? orderStepSize;
  int? orderDefQty;
  List<String>? orderUnits;
  List<String>? orderEntry;
  List<String>? orderRemainingCash;
  List<String>? afterOrderCashGain;

  PartialOrderGenerationRequest(
      {this.orderId,
      this.ladId,
      this.securityCode,
      this.orderType,
      this.orderStockName,
      this.orderLadderName,
      this.orderStepSize,
      this.orderDefQty,
      this.orderUnits,
      this.orderEntry,
      this.orderRemainingCash,
      this.afterOrderCashGain});

  PartialOrderGenerationRequest.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    ladId = json['lad_id'];
    securityCode = json['security_code'];
    orderType = json['order_type'];
    orderStockName = json['order_stock_name'];
    orderLadderName = json['order_ladder_name'];
    orderStepSize = json['order_step_size'];
    orderDefQty = json['order_def_qty'];
    orderUnits = json['order_units'].cast<String>();
    orderEntry = json['order_entry'].cast<String>();
    orderRemainingCash = json['order_remaining_cash'].cast<String>();
    afterOrderCashGain = json['after_order_cash_gain'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['lad_id'] = this.ladId;
    data['security_code'] = this.securityCode;
    data['order_type'] = this.orderType;
    data['order_stock_name'] = this.orderStockName;
    data['order_ladder_name'] = this.orderLadderName;
    data['order_step_size'] = this.orderStepSize;
    data['order_def_qty'] = this.orderDefQty;
    data['order_units'] = this.orderUnits;
    data['order_entry'] = this.orderEntry;
    data['order_remaining_cash'] = this.orderRemainingCash;
    data['after_order_cash_gain'] = this.afterOrderCashGain;
    return data;
  }
}
