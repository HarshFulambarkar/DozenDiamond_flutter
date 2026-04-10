import 'package:flutter/material.dart';

class LadderCreationScreen3 {
  TextEditingController? numberOfStepsAbove;
  TextEditingController? clpStepSize;
  int? numberOfStepsBelow;
  TextEditingController? clpDefaultBuySellQuantity;
  double? cashNeeded;
  double? cashLeft;
  double? actualCashAllocated;

  LadderCreationScreen3(
      {required this.numberOfStepsAbove,
      required this.clpStepSize,
      required this.numberOfStepsBelow,
      required this.clpDefaultBuySellQuantity,
      required this.cashNeeded,
      required this.cashLeft,
      required this.actualCashAllocated});
}
