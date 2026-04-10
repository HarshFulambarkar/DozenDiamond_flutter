import 'package:flutter/material.dart';

class LadderCreationScreen3 {
  // Initialized within the class, no need to pass via constructor.
  int? clpTickerId;
  TextEditingController clpInitialBuyQuantity;
  TextEditingController? numberOfStepsAbove;
  double? calculatedNumberOfStepsAbove;
  TextEditingController? clpStepSize;
  double? calculatedStepSize;
  int? numberOfStepsBelow;
  TextEditingController? clpDefaultBuySellQuantity;
  double? cashNeeded;
  double? cashLeft;
  double? actualCashAllocated;
  String? clpExchange;

  LadderCreationScreen3({
    TextEditingController? clpInitialBuyQuantity, // Optional initialization
    int? calculatedNumberOfStepsAbove,
    double? calculateStepSize,
    required this.clpTickerId,
    required this.numberOfStepsAbove,
    required this.clpStepSize,
    required this.numberOfStepsBelow,
    required this.clpDefaultBuySellQuantity,
    required this.cashNeeded,
    required this.cashLeft,
    required this.actualCashAllocated,
    required this.clpExchange,
  }) : clpInitialBuyQuantity = clpInitialBuyQuantity ??
            TextEditingController(text: "0"); // Non-const initialization
}
