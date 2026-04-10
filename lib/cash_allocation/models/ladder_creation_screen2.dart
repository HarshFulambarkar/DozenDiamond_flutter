import 'package:flutter/material.dart';

class LadderCreationScreen2 {
  TextEditingController? initialPurchasePrice;
  TextEditingController? targetPrice;
  TextEditingController? targetPriceMultiplier;
  TextEditingController? clpCashAllocated;
  TextEditingController? initialBuyCash;
  TextEditingController? clpInitialBuyQuantity;
  TextEditingController? actualInitialBuyCash;

  LadderCreationScreen2({
    this.initialPurchasePrice,
    this.targetPrice,
    this.targetPriceMultiplier,
    required this.clpCashAllocated,
    required this.initialBuyCash,
    required this.clpInitialBuyQuantity,
    required this.actualInitialBuyCash,
  });
}
