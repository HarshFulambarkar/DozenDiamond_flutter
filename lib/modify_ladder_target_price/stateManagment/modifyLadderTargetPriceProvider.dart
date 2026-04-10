import 'dart:math';

import 'package:dozen_diamond/modify_ladder_target_price/model/modifyOrderSizeRequest.dart';
import 'package:dozen_diamond/modify_ladder_target_price/model/modifyStepSizeRequest.dart';
import 'package:dozen_diamond/modify_ladder_target_price/model/modifyTargetPriceRequest.dart';
import 'package:dozen_diamond/modify_ladder_target_price/service/modifyLadderTargetPriceService.dart';
import 'package:flutter/material.dart';

import '../../AB_Ladder/models/ladder_list_model.dart';

class ModifyLadderTargetPriceProvider extends ChangeNotifier {
  int _ladId = 0;
  int get ladId => _ladId;
  set ladId(int ladIdBunch) {
    _ladId = ladIdBunch;
    notifyListeners();
  }

  bool _targetPriceCheckbox = false;
  bool get targetPriceCheckBox => _targetPriceCheckbox;
  set targetPriceCheckBox(bool targetPriceCheckBoxBunch) {
    _targetPriceCheckbox = targetPriceCheckBoxBunch;
    notifyListeners();
  }

  int _initialBuyExecuted = 0;
  int get initialBuyExecuted => _initialBuyExecuted;
  set initialBuyExecuted(int initialBuyExecutedBunch) {
    _initialBuyExecuted = initialBuyExecutedBunch;
    notifyListeners();
  }

  int _initialBuyQuantity = 0;
  int get initialBuyQuantity => _initialBuyQuantity;
  set initialBuyQuantity(int initialBuyQuantityBunch) {
    _initialBuyQuantity = initialBuyQuantityBunch;
    notifyListeners();
  }

  double _cashAllocated = 0.0;
  double get cashAllocated => _cashAllocated;
  set cashAllocated(double cashAllocatedBunch) {
    _cashAllocated = cashAllocatedBunch;
    notifyListeners();
  }

  double _cashNeeded = 0.0;
  double get cashNeeded => _cashNeeded;
  set cashNeeded(double cashNeededBunch) {
    _cashNeeded = cashNeededBunch;
    notifyListeners();
  }

  double _newCashNeeded = 0.0;
  double get newCashNeeded => _newCashNeeded;
  set newCashNeeded(double newCashNeededBunch) {
    _newCashNeeded = newCashNeededBunch;
    notifyListeners();
  }

  double _modifiedTargetPrice = 0.0;
  double get modifiedTargetPrice => _modifiedTargetPrice;
  set modifiedTargetPrice(double modifiedTargetPriceBunch) {
    _modifiedTargetPrice = modifiedTargetPriceBunch;
    notifyListeners();
  }

  TextEditingController modifiedTargetPriceController = TextEditingController();

  int _quantitiesOwned = 0;
  int get quantitiesOwned => _quantitiesOwned;
  set quantitiesOwned(int quantitiesOwnedBunch) {
    _quantitiesOwned = quantitiesOwnedBunch;
    notifyListeners();
  }

  double _targetPrice = 0.0;
  double get targetPrice => _targetPrice;
  set targetPrice(double targetPriceBunch) {
    _targetPrice = targetPriceBunch;
    notifyListeners();
  }

  double _currentPrice = 0.0;
  double get currentPrice => _currentPrice;
  set currentPrice(double currentPriceBunch) {
    _currentPrice = currentPriceBunch;
    notifyListeners();
  }

  int _stocksToBuy = 0;
  int get stocksToBuy => _stocksToBuy;
  set stocksToBuy(int stocksToBuyBunch) {
    _stocksToBuy = stocksToBuyBunch;
    notifyListeners();
  }

  int _stocksToSell = 0;
  int get stocksToSell => _stocksToSell;
  set stocksToSell(int stocksToSellBunch) {
    _stocksToSell = stocksToSellBunch;
    notifyListeners();
  }

  double _stepSize = 0.0;
  double get stepSize => _stepSize;
  set stepSize(double stepSizeBunch) {
    _stepSize = stepSizeBunch;
    notifyListeners();
  }

  double _newStepSize = 0.0;
  double get newStepSize => _newStepSize;
  set newStepSize(double newStepSizeBunch) {
    _newStepSize = newStepSizeBunch;
    notifyListeners();
  }

  int _orderSize = 0;
  int get orderSize => _orderSize;
  set orderSize(int orderSizeBunch) {
    _orderSize = orderSizeBunch;
    notifyListeners();
  }

  int _newOrderSize = 0;
  int get newOrderSize => _newOrderSize;
  set newOrderSize(int newOrderSizeBunch) {
    _newOrderSize = newOrderSizeBunch;
    notifyListeners();
  }

  double _numberOfStepsAbove = 0.0;
  double get numberOfStepsAbove => _numberOfStepsAbove;
  set numberOfStepsAbove(double numberOfStepsAboveBunch) {
    _numberOfStepsAbove = numberOfStepsAboveBunch;
    notifyListeners();
  }

  double _newNumberOfStepsAbove = 0.0;
  double get newNumberOfStepsAbove => _newNumberOfStepsAbove;
  set newNumberOfStepsAbove(double newNumberOfStepsAboveBunch) {
    _newNumberOfStepsAbove = newNumberOfStepsAboveBunch;
    notifyListeners();
  }

  int _numberOfStepsBelow = 0;
  int get numberOfStepsBelow => _numberOfStepsBelow;
  set numberOfStepsBelow(int numberOfStepsBelowBunch) {
    _numberOfStepsBelow = numberOfStepsBelowBunch;
    notifyListeners();
  }

  int _newNumberOfStepsBelow = 0;
  int get newNumberOfStepsBelow => _newNumberOfStepsBelow;
  set newNumberOfStepsBelow(int newNumberOfStepsBelowBunch) {
    _newNumberOfStepsBelow = newNumberOfStepsBelowBunch;
    notifyListeners();
  }

  bool _stepSizeCheckBox = false;
  bool get stepSizeCheckBox => _stepSizeCheckBox;
  set stepSizeCheckBox(bool stepSizeCheckBoxBunch) {
    _stepSizeCheckBox = stepSizeCheckBoxBunch;
    notifyListeners();
  }

  double _modifiedStepSize = 0.0;
  double get modifiedStepSize => _modifiedStepSize;
  set modifiedStepSize(double modifiedStepSizeBunch) {
    _modifiedStepSize = modifiedStepSizeBunch;
    notifyListeners();
  }

  double _calculatedStepSize = 0.0;
  double get calculatedStepSize => _calculatedStepSize;
  set calculatedStepSize(double calculatedStepSizeBunch) {
    _calculatedStepSize = calculatedStepSizeBunch;
    notifyListeners();
  }

  TextEditingController modifiedStepSizeController = TextEditingController();

  bool _orderSizeCheckBox = false;
  bool get orderSizeCheckBox => _orderSizeCheckBox;
  set orderSizeCheckBox(bool orderSizeCheckBoxBunch) {
    _orderSizeCheckBox = orderSizeCheckBoxBunch;
    notifyListeners();
  }

  int _modifiedOrderSize = 0;
  int get modifiedOrderSize => _modifiedOrderSize;
  set modifiedOrderSize(int modifiedOrderSizeBunch) {
    _modifiedOrderSize = modifiedOrderSizeBunch;
    notifyListeners();
  }

  TextEditingController modifiedOrderSizeController = TextEditingController();

  String _targetPriceError = "";

  String get targetPriceError => _targetPriceError;

  set targetPriceError(String value) {
    _targetPriceError = value;
    notifyListeners();
  }

  String _stepSizeError = "";

  String get stepSizeError => _stepSizeError;

  set stepSizeError(String value) {
    _stepSizeError = value;
    notifyListeners();
  }

  String _limitPrice = "null";

  String get limitPrice => _limitPrice;

  set limitPrice(String value) {
    _limitPrice = value;
    notifyListeners();
  }

  String _limitPriceTimeInMin = "null";

  String get limitPriceTimeInMin => _limitPriceTimeInMin;

  set limitPriceTimeInMin(String value) {
    _limitPriceTimeInMin = value;
    notifyListeners();
  }

  String _limitPriceErrorText = "";

  String get limitPriceErrorText => _limitPriceErrorText;

  set limitPriceErrorText(String value) {
    _limitPriceErrorText = value;
    notifyListeners();
  }

  String _limitPriceTimeInMinErrorText = "";

  String get limitPriceTimeInMinErrorText => _limitPriceTimeInMinErrorText;

  set limitPriceTimeInMinErrorText(String value) {
    _limitPriceTimeInMinErrorText = value;
    notifyListeners();
  }

  late Ladder _selectedLadder;

  Ladder get selectedLadder => _selectedLadder;

  set selectedLadder(Ladder value) {
    _selectedLadder = value;
    notifyListeners();
  }

  int modifyTargetPrice() {
    if (targetPriceCheckBox) {
      targetPriceCheckBox = false;
      stocksToBuy = 0;
      stocksToSell = 0;
      newOrderSize = 0;
      newNumberOfStepsAbove = 0.0;
      newNumberOfStepsBelow = 0;
      newStepSize = 0.0;
      newCashNeeded = 0.0;
      return -1;
    }

    double r = orderSize / stepSize;
    print(orderSize);
    print(stepSize);
    print("below is r");
    print(r);
    if (modifiedTargetPrice > targetPrice) {
      // stocksToBuy = ((quantitiesOwned * currentPrice) *
      //         (modifiedTargetPrice - targetPrice) /
      //         ((targetPrice - currentPrice) *
      //             (2 * modifiedTargetPrice - currentPrice)))
      //     .floor();
      stocksToBuy =
          (r *
              (((modifiedTargetPrice - currentPrice) *
                  (targetPrice - currentPrice / 2) /
                  (modifiedTargetPrice - currentPrice / 2)) -
                  (targetPrice - currentPrice)))
              .floor();
      newOrderSize =
          ((quantitiesOwned + stocksToBuy) / (modifiedTargetPrice - currentPrice) * stepSize)
              .ceil();
      print("in if 1");
      print(quantitiesOwned);
      print(stocksToBuy);
      print(newOrderSize);
      print("-------------------------");
      // newNumberOfStepsAbove = (quantitiesOwned + stocksToBuy) / newOrderSize;
      newNumberOfStepsAbove = (modifiedTargetPrice - currentPrice) / stepSize;
    } else if (modifiedTargetPrice < targetPrice) {
      print("before stocksToSell");
      print(quantitiesOwned);
      print(targetPrice);
      print(modifiedTargetPrice);
      print(stepSize);
      print(currentPrice);
      print("-------------------------");
      // stocksToSell = ((quantitiesOwned * currentPrice) *
      //         (modifiedTargetPrice - targetPrice) /
      //         ((targetPrice - currentPrice) *
      //             (2 * modifiedTargetPrice - currentPrice)))
      //     .ceil();
      stocksToSell =
          (r *
              (((modifiedTargetPrice - currentPrice) *
                  (targetPrice - currentPrice / 2) /
                  (modifiedTargetPrice - currentPrice / 2)) -
                  (targetPrice - currentPrice)))
              .ceil();
      print("before newOrderSize");
      // print((r * (((modifiedTargetPrice - currentPrice) * (targetPrice - currentPrice / 2) / (modifiedTargetPrice - currentPrice / 2)) - (targetPrice - currentPrice))));
      print(stocksToSell);
      print(quantitiesOwned);
      print(stocksToBuy);
      print(modifiedTargetPrice);
      print(stepSize);
      print(currentPrice);
      print(targetPrice);
      print("-------------------------");
      // newOrderSize = ((quantitiesOwned + stocksToBuy) /
      //         (modifiedTargetPrice - currentPrice) *
      //         stepSize)
      //     .floor();
      newOrderSize =
          ((quantitiesOwned + stocksToSell) /
              (modifiedTargetPrice - currentPrice) *
              stepSize)
              .floor();

      print("in if 2");
      print(quantitiesOwned);
      print(stocksToSell);
      print(newOrderSize);
      print("-------------------------");
      // newNumberOfStepsAbove = (quantitiesOwned + stocksToSell) / newOrderSize;
      newNumberOfStepsAbove = (modifiedTargetPrice - currentPrice) / stepSize;
    }
    print(modifiedTargetPrice);
    print(currentPrice);
    print(newNumberOfStepsAbove);
    print("-------------------------");

    // newStepSize = (modifiedTargetPrice - currentPrice) / newNumberOfStepsAbove;
    newStepSize = stepSize;
    print(currentPrice);
    print(newStepSize);
    newNumberOfStepsBelow = (currentPrice / newStepSize).floor();
    // newCashNeeded = newNumberOfStepsBelow * newOrderSize * currentPrice / 2;
    newCashNeeded =
        (currentPrice / newStepSize) * newOrderSize * currentPrice / 2;
    targetPriceCheckBox = true;
    return 1;
  }

  int modifyStepSize() {
    if (stepSizeCheckBox) {
      newOrderSize = 0;
      newNumberOfStepsAbove = 0.0;
      calculatedStepSize = 0.0;
      newNumberOfStepsBelow = 0;
      newCashNeeded = 0.0;
      stepSizeCheckBox = false;
      return -1;
    }
    double p = (selectedLadder.ladInitialBuyExecuted == 1)
        ? selectedLadder.ladLastTradeOrderPrice
        : selectedLadder.ladInitialBuyPrice;

    print("below is p");
    print(selectedLadder.ladInitialBuyExecuted);
    print(selectedLadder.ladLastTradeOrderPrice);
    print(selectedLadder.ladInitialBuyPrice);
    print(selectedLadder.ladId);
    print(p);
    double tempNumberOfStepsAbove = (targetPrice - p) / stepSize;

    print(tempNumberOfStepsAbove);
    print(orderSize);
    print(stepSize);
    print(targetPrice);

    newOrderSize = (modifiedStepSize * orderSize / stepSize).ceil();
    // newNumberOfStepsAbove = numberOfStepsAbove * orderSize / newOrderSize;
    newNumberOfStepsAbove = tempNumberOfStepsAbove * orderSize / newOrderSize;
    // calculatedStepSize = (targetPrice - currentPrice) / newNumberOfStepsAbove;
    calculatedStepSize = (targetPrice - p) / newNumberOfStepsAbove;
    // newNumberOfStepsBelow = (currentPrice / calculatedStepSize).floor();
    newNumberOfStepsBelow = (p / calculatedStepSize).floor();
    // newCashNeeded = currentPrice / 2 * newOrderSize * newNumberOfStepsBelow;
    // newCashNeeded = currentPrice / 2 * newOrderSize * (currentPrice / calculatedStepSize);
    newCashNeeded = p / 2 * newOrderSize * (p / calculatedStepSize);
    stepSizeCheckBox = true;
    return 0;
  }

  int modifyOrderSize() {
    if (orderSizeCheckBox) {
      newNumberOfStepsAbove = 0.0;
      newStepSize = 0.0;
      newNumberOfStepsBelow = 0;
      newCashNeeded = 0.0;
      orderSizeCheckBox = false;
      return -1;
    }

    double p = (selectedLadder.ladInitialBuyExecuted == 1)
        ? selectedLadder.ladLastTradeOrderPrice
        : selectedLadder.ladInitialBuyPrice;
    double tempNumberOfStepsAbove = (targetPrice - p) / stepSize;

    print("D $modifiedOrderSize");
    // newNumberOfStepsAbove = numberOfStepsAbove * orderSize / modifiedOrderSize;
    newNumberOfStepsAbove =
        tempNumberOfStepsAbove * orderSize / modifiedOrderSize;
    print(
      "modifiedOrder is $tempNumberOfStepsAbove and $newNumberOfStepsAbove",
    );
    // newStepSize = (targetPrice - currentPrice) / newNumberOfStepsAbove;
    newStepSize = (targetPrice - p) / newNumberOfStepsAbove;
    print("modifiedOrder is $newStepSize  ${(targetPrice - p)}");
    // newNumberOfStepsBelow = (currentPrice / newStepSize).floor();
    newNumberOfStepsBelow = (p / newStepSize).floor();
    print("modifiedOrder is $newNumberOfStepsBelow");
    newCashNeeded =
    // currentPrice / 2 * modifiedOrderSize * newNumberOfStepsBelow;
    // currentPrice / 2 * modifiedOrderSize * (currentPrice / newStepSize);
    p / 2 * modifiedOrderSize * (p / newStepSize);
    print("modifiedOrder $newCashNeeded");
    print("below is p/newStepSize");
    print(p / newStepSize);
    print(p);
    print(newStepSize);
    print(modifiedOrderSize);
    orderSizeCheckBox = true;
    return 0;
  }

  bool isModifyingTargetPrice = false;
  void modifyTargetPriceBusinessLogic(BuildContext context) async {
    isModifyingTargetPrice = true;
    notifyListeners();
    try {
      double? tempLimitPrice = null;
      int? timeInMin = null;

      tempLimitPrice = double.tryParse(limitPrice);
      timeInMin = int.tryParse(limitPriceTimeInMin);

      ModifyTargetPriceRequest _modifyTargetPriceRequest =
      ModifyTargetPriceRequest(
        ladCashNeeded: newCashNeeded,
        ladDefaultBuySellQuantity: newOrderSize,
        ladId: ladId,
        ladNumOfStepsAbove: newNumberOfStepsAbove,
        ladNumOfStepsBelow: newNumberOfStepsBelow,
        ladStepSize: newStepSize,
        ladTargetPrice: modifiedTargetPrice,
        stockToBeBought: modifiedTargetPrice > targetPrice
            ? stocksToBuy
            : stocksToSell,
        minLimitPrice: tempLimitPrice,
        timeInMin: timeInMin,
        currentPrice: currentPrice,
      );
      await ModifyLadderTargetPriceService().changeTargetPrice(
        _modifyTargetPriceRequest,
        context,
      );
    } catch (e) {
      print("Error while modifying step size: $e");
      // optionally show a snackbar / dialog here
    } finally {
      isModifyingTargetPrice = false;
      notifyListeners();
    }
  }

  bool isModifyingOrderSize = false;
  void modifyOrderSizeBusinessLogic(BuildContext context) async {
    isModifyingOrderSize = true;
    notifyListeners();
    try {
      ModifyOrderSizeRequest _modifyOrderSizeRequest = ModifyOrderSizeRequest(
        ladCashNeeded: newCashNeeded,
        ladDefaultBuySellQuantity: modifiedOrderSize,
        ladId: ladId,
        ladNumOfStepsAbove: newNumberOfStepsAbove,
        ladNumOfStepsBelow: newNumberOfStepsBelow,
        ladStepSize: newStepSize,
      );
      var returnVar = await ModifyLadderTargetPriceService().changeOrderSize(
        _modifyOrderSizeRequest,
        context,
      );
      print("here is the returned variable $returnVar");
    } catch (e) {
      print("Error while modifying step size: $e");
      // optionally show a snackbar / dialog here
    } finally {
      isModifyingOrderSize = false;
      notifyListeners();
    }
  }

  bool isModifyingStepSize = false;
  void modifyStepSizeBusinessLogic(BuildContext context) async {
    isModifyingStepSize = true;
    notifyListeners();
    print("isModifyingStepSize $isModifyingStepSize");
    try {
      ModifyStepSizeRequest _modifyStepSizeRequest = ModifyStepSizeRequest(
        ladCashNeeded: newCashNeeded,
        ladDefaultBuySellQuantity: newOrderSize,
        ladId: ladId,
        ladNumOfStepsAbove: newNumberOfStepsAbove,
        ladNumOfStepsBelow: newNumberOfStepsBelow,
        ladStepSize: calculatedStepSize,
      );
      await ModifyLadderTargetPriceService().changeStepSize(
        _modifyStepSizeRequest,
        context,
      );
    } catch (e) {
      print("Error while modifying step size: $e");
      // optionally show a snackbar / dialog here
    } finally {
      isModifyingStepSize = false;
      notifyListeners();
      print("isModifyingStepSize $isModifyingStepSize");
    }
  }

  double _minK = 1.2;

  double get minK => _minK;

  set minK(double value) {
    _minK = value;
    notifyListeners();
  }

  Future<double> calculateMinimumK(double capital) async {

    double eMin = 100;

    double Sa = 15;

    double minKTemp = (1 + ((pow(Sa, 2) * eMin) / capital) + sqrt(pow(((pow(Sa, 2) * eMin) / capital), 2) + ((pow(Sa, 2) * eMin) / capital)));

    // double minK = (1 + ((pow(Misa, 2) * 100) / capital)) + sqrt((pow(Misa, 2) * 100) / capital);
    minKTemp = minKTemp + 0.01;

    minK = minKTemp;

    print("below is calculateMinimumK");
    print(minK);
    return minKTemp;
  }

  double _minStepSize = 0;

  double get minStepSize => _minStepSize;

  set minStepSize(double value) {
    _minStepSize = value;
    notifyListeners();
  }

  double _maxStepSize = 0;

  double get maxStepSize => _maxStepSize;

  set maxStepSize(double value) {
    _maxStepSize = value;
    notifyListeners();
  }

  Future<double> calculateMinStepSize ({
    required double currentPrice,
    required double capital,
    required double targetPrice
  }) async {

    double minStepSizeTemp = sqrt(200 * (currentPrice / capital) * (targetPrice - (currentPrice / 2)));

    minStepSize = minStepSizeTemp;

    print("below is minStepSize");
    print(minStepSize);

    return minStepSize;
  }

  Future<double> calculateMaxStepSize({
    required double currentPrice,
    required double capital,
    required double targetPrice
  }) async {

    double maxStepSizeTemp = (targetPrice - currentPrice) / 15;

    maxStepSize = maxStepSizeTemp;

    print("below is maxStepSize");
    print(maxStepSize);

    return maxStepSize;
  }

}