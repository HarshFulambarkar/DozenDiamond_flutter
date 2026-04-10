import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utility {

  static String amountFormat(double amount) {
    var formatter = NumberFormat('#,##,##,##,000.00');
    return formatter.format(amount);
  }

  double multiplyBy1Point2(double amount) {
    return amount * 1.2;
  }

  int calculateInitialBuyQuantityMaxValue(double targetPrice, double initialBuyPrice, double priorAllocation, double currentPrice) {

    double k = targetPrice / initialBuyPrice;
    double C = priorAllocation;
    double P = currentPrice;

    int initialBuyQuantityMaxValue = (((2 * k) - 2)/((2 * k) - 1)*C/P).toInt();

    print("below is initialBuyQuantityMaxValue");
    print(targetPrice);
    print(initialBuyPrice);
    print(priorAllocation);
    print(currentPrice);
    print(initialBuyQuantityMaxValue);

    return initialBuyQuantityMaxValue;

  }

  // double initialBuyCash(double targetPrice, double initialBuyPrice, double priorAllocation) {
  //
  //   double k = targetPrice / initialBuyPrice;
  //
  //   double initialBuyCashValue = priorAllocation * (((2 * k) - 2)/((2 * k) - 1));
  //
  //   return initialBuyCashValue;
  // }

}