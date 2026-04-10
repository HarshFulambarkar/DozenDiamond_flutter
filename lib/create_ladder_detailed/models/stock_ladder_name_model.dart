import 'package:dozen_diamond/create_ladder_detailed/models/ladder_model.dart';
import 'package:flutter/material.dart';

class StockLadderNameModel {
  String? clpStockName;
  List<LadderModel>? stockLadders;
  int? clpId;
  int? clpStockId;
  bool? isLadderCreated;
  TextEditingController? clpTargetPrice;
  TextEditingController? clpMinimumPrice;
  TextEditingController? clpInitialPurchasePrice;
  TextEditingController? clpDefaultBuySellQuantity;
  TextEditingController? clpInitialBuyQuantity;
  TextEditingController? clpCashAllocated;
  TextEditingController? clpStepSize;
  TextEditingController? targetPriceMultiplier;
  TextEditingController? numberOfStepsAbove;
  int? numberOfStepsBelow;
  TextEditingController? initialBuyCash;
  TextEditingController? actualInitialBuyCash;
  TextEditingController? cashNeeded;
  TextEditingController? cashLeft;
  TextEditingController? actualCashAllocated;
  int? ladId;
  int? symSecurityCode;

  StockLadderNameModel({
    required this.clpStockName,
    required this.stockLadders,
    required this.clpId,
    required this.clpStockId,
    required this.isLadderCreated,
    required this.clpTargetPrice,
    required this.clpMinimumPrice,
    required this.clpInitialPurchasePrice,
    required this.clpDefaultBuySellQuantity,
    required this.clpInitialBuyQuantity,
    required this.clpCashAllocated,
    required this.clpStepSize,
    required this.symSecurityCode,
    required this.targetPriceMultiplier,
    required this.initialBuyCash,
    required this.numberOfStepsAbove,
    required this.numberOfStepsBelow,
    required this.actualInitialBuyCash,
    required this.cashNeeded,
    required this.cashLeft,
    required this.actualCashAllocated,
    this.ladId,
  });
}


//   int? clpStockId;
//   bool? isLadderCreated;
//   String? clpTargetPrice;
//   String? clpMinimumPrice;
//   String? clpInitialPurchasePrice;
//   int? clpDefaultBuySellQuantity;
//   int? clpInitialBuyQuantity;
//   String? clpCashAllocated;
//   String? clpStockName;
//   List<LadderName>? ladderName;