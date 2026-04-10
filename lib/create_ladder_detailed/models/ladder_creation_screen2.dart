import 'package:flutter/material.dart';

class LadderCreationScreen2 {
  int? clpTickerId;
  TextEditingController? initialPurchasePrice;
  TextEditingController? targetPrice;
  TextEditingController? targetPriceMultiplier;
  TextEditingController? clpCashAllocated;
  TextEditingController? initialBuyCash;
  TextEditingController? clpInitialBuyQuantity;
  TextEditingController? actualInitialBuyCash;
  String? clpExchange;

  LadderCreationScreen2({
    required this.clpTickerId,
    this.initialPurchasePrice,
    this.targetPrice,
    this.targetPriceMultiplier,
    required this.clpCashAllocated,
    required this.initialBuyCash,
    required this.clpInitialBuyQuantity,
    required this.actualInitialBuyCash,
    required this.clpExchange,
  });
}
