import '../../global/models/api_request_response.dart';

class GetNewUserActivityResponse implements ApiRequestResponse {
  List<Data>? data;
  bool? status;
  String? message;

  GetNewUserActivityResponse({this.data, this.status, this.message});

  @override
  GetNewUserActivityResponse fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data().fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['msg'] = message;
    return data;
  }
}

class Data implements ApiRequestResponse {
  int? actId;
  String? actMessageTitle;
  String? actTitleColor;
  ActMessageSubtitle? actMessageSubtitle;
  String? actType;
  int? userId;
  int? actLevel;
  String? createdAt;
  String? updatedAt;
  bool? isExpanded = false;

  Data({
    this.actId,
    this.actMessageTitle,
    this.actTitleColor,
    this.actMessageSubtitle,
    this.actType,
    this.userId,
    this.actLevel,
    this.createdAt,
    this.updatedAt,
    this.isExpanded = false,
  });

  @override
  Data fromJson(Map<String, dynamic> json) {
    actId = json['act_id'];
    actMessageTitle = json['act_message_title'];
    actTitleColor = json['act_title_color'];
    actMessageSubtitle = json['act_message_subtitle'] != null
        ? ActMessageSubtitle().fromJson(json['act_message_subtitle'])
        : null;
    actType = json['act_type'];
    userId = json['user_id'];
    actLevel = json['act_level'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    isExpanded = false;
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['act_id'] = actId;
    data['act_message_title'] = actMessageTitle;
    data['act_title_color'] = actTitleColor;
    if (actMessageSubtitle != null) {
      data['act_message_subtitle'] = actMessageSubtitle!.toJson();
    }
    data['act_type'] = actType;
    data['user_id'] = userId;
    data['act_level'] = actLevel;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class ActMessageSubtitle implements ApiRequestResponse {
  double? tradeExePrice;
  int? buyQuantity;
  int? sellQuantity;
  double? profit;
  String? ticketNumber;
  double? currentPrice;
  double? totalReturn;
  int? totalQuantity;
  double? newSellEntry;
  double? newBuyEntry;
  int? newSellQty;
  int? newBuyQty;
  double? sellEntry;
  double? buyEntry;
  double? targetPrice;
  double? minimumPrice;
  String? stepSize;
  double? initialPurchasePrice;
  double? ladAmount;
  String? ladder01 = "";
  String? ladder02 = "";
  String? ladderName = "";

  ActMessageSubtitle({
    this.tradeExePrice,
    this.buyQuantity,
    this.sellQuantity,
    this.profit,
    this.ticketNumber,
    this.currentPrice,
    this.newSellEntry,
    this.sellEntry,
    this.newSellQty,
    this.totalReturn,
    this.totalQuantity,
    this.newBuyEntry,
    this.buyEntry,
    this.newBuyQty,
    this.targetPrice,
    this.minimumPrice,
    this.stepSize,
    this.initialPurchasePrice,
    this.ladAmount,
    this.ladder01,
    this.ladder02,
    this.ladderName,
  });

  @override
  ActMessageSubtitle fromJson(Map<String, dynamic> json) {
    tradeExePrice = double.tryParse(json['trade_exe_price'].toString()) ?? 0.0;
    buyQuantity = int.tryParse(json['buyQuantity'].toString()) ?? 0;
    sellQuantity = json['sellQuantity'];
    profit =
        (json['profit'] == null ||
            json['profit'] == "null" ||
            json['profit'] == "")
        ? 0.0
        : double.parse(json['profit'].toString());
    totalQuantity = int.tryParse(json['totalQuantity'].toString()) ?? 0;
    totalReturn = double.tryParse(json['totalReturn'].toString()) ?? 0.0;
    ticketNumber = json['ticketNumber'].toString();
    currentPrice = double.tryParse(json['currentPrice'].toString()) ?? 0.0;
    sellEntry = double.tryParse(json['sell_entry'].toString()) ?? 0.0;
    buyEntry = double.tryParse(json['buy_entry'].toString()) ?? 0.0;
    newSellEntry = double.tryParse(json['new_sell_entry'].toString()) ?? 0.0;
    newBuyEntry = double.tryParse(json['new_buy_entry'].toString()) ?? 0.0;
    newSellQty = int.tryParse(json['new_sell_qty'].toString()) ?? 0;
    newBuyQty = int.tryParse(json['new_buy_qty'].toString()) ?? 0;
    targetPrice = double.tryParse(json['target_price'].toString()) ?? 0.0;
    minimumPrice = double.tryParse(json['minimum_price'].toString()) ?? 0.0;
    stepSize = double.tryParse(
      json['step_size'].toString(),
    )?.toStringAsFixed(2);
    initialPurchasePrice =
        double.tryParse(json['initial_purchase_price'].toString()) ?? 0.0;
    ladAmount = double.tryParse(json['lad_amount'].toString()) ?? 0.0;
    ladder01 = json['ladder_01'].toString();
    ladder02 = json['ladder_02'].toString();
    ladderName = json['ladderName'].toString();
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['trade_exe_price'] = tradeExePrice;
    data['buyQuantity'] = buyQuantity;
    data['totalQuantity'] = totalQuantity;
    data['totalReturn'] = totalReturn;
    data['sellQuantity'] = sellQuantity;
    data['profit'] = profit;
    data['ticketNumber'] = ticketNumber;
    data['currentPrice'] = currentPrice;
    data['sell_entry'] = sellEntry;
    data['buy_entry'] = buyEntry;
    data['new_sell_entry'] = newSellEntry;
    data['new_buy_entry'] = newBuyEntry;
    data['new_sell_qty'] = newSellQty;
    data['new_buy_qty'] = newBuyQty;
    data['target_price'] = targetPrice;
    data['minimum_price'] = minimumPrice;
    data['step_size'] = stepSize;
    data['initial_purchase_price'] = initialPurchasePrice;
    data['lad_amount'] = ladAmount;
    data['ladder_01'] = ladder01;
    data['ladder_02'] = ladder02;
    data['ladderName'] = ladderName;
    return data;
  }
}
