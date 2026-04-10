import 'package:flutter/material.dart';

class ReviewStocksModel {
  int? ladId;
  int? userId;
  String? ladLadderName;
  String? ladStockName;
  int? ladInitialBuyQuantity;
  String? ladInitialPurchasePrice;
  String? ladTargetPrice;
  int? ladDefaultBuySellQuantity;
  String? ladMinimumPrice;
  String? ladStatus;
  bool? ladMarketOrder;
  String? ladCashNeeded;
  String? ladMaxPurchaseCashGain;
  String? ladAvailableCash;
  String? ladCashInitialAllocated;
  int? ladStocksBoughtAfterInitalPurchase;
  String? ladCashGainForNewStock;
  String? ladCashGainForAllStock;
  String? ladCashGainForInitialPurchase;
  String? ladStepSize;
  bool? ladReinvestProfit;
  bool? ladTradingStatus;
  int? isDeleted;
  String? ladCreatedAt;
  String? createdAt;
  String? updatedAt;
  bool? ladderExist;
  bool? isNewLadder;
  String? currentPrice;
  TextEditingController? allocatedAmountController;

  ReviewStocksModel(
      {this.ladId,
      this.userId,
      this.ladLadderName,
      this.ladStockName,
      this.ladInitialBuyQuantity,
      this.ladInitialPurchasePrice,
      this.ladTargetPrice,
      this.ladDefaultBuySellQuantity,
      this.ladMinimumPrice,
      this.ladStatus,
      this.ladMarketOrder,
      this.ladCashNeeded,
      this.ladMaxPurchaseCashGain,
      this.ladAvailableCash,
      this.ladCashInitialAllocated,
      this.ladStocksBoughtAfterInitalPurchase,
      this.ladCashGainForNewStock,
      this.ladCashGainForAllStock,
      this.ladCashGainForInitialPurchase,
      this.ladStepSize,
      this.ladReinvestProfit,
      this.ladTradingStatus,
      this.isDeleted,
      this.ladCreatedAt,
      this.createdAt,
      this.updatedAt,
      this.ladderExist,
      this.isNewLadder,
      this.allocatedAmountController,
      this.currentPrice});
}
