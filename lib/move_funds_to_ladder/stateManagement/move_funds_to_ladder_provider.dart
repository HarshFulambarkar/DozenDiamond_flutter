import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../model/ladder_list_model.dart';
import '../model/move_funds_to_ladder_request.dart';
import '../services/move_funds_to_ladder_service.dart';

class MoveFundsToLadderProvider extends ChangeNotifier {
  MoveFundsToLadderProvider(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  double availableCashInAccount = 1000000;
  // double target = 8630.30;
  // double cashAlreadyAllocated = 975223.90;
  // double stepSize = 113.56;
  // int orderSize = 4;
  // int currentStockOwn = 156;
  // double cashNeeded = 319321.10;

  String _selectedLadderId = "";

  String get selectedLadderId => _selectedLadderId;

  set selectedLadderId(String value) {
    _selectedLadderId = value;
    notifyListeners();
  }

  Ladder _selectedLadderL1 = Ladder(
    ladId: 0,
    ladUserId: 0,
    ladTicker: '',
    ladName: '',
    ladStatus: FilterOption.inactive,
    ladTickerId: 0,
    ladExchange: '',
    ladTradingMode: '',
    ladCashAllocated: '',
    ladCashGain: '',
    ladCashLeft: '',
    ladLastTradePrice: 0,
    ladLastTradeOrderPrice: 0,
    ladMinimumPrice: '',
    ladExtraCashGenerated: '',
    ladExtraCashLeft: '',
    ladRealizedProfit: '',
    ladInitialBuyQuantity: 0,
    ladDefaultBuySellQuantity: 0,
    ladTargetPrice: '',
    ladNumOfStepsAbove: 0,
    ladNumOfStepsBelow: 0,
    ladCashNeeded: '',
    ladInitialBuyPrice: '',
    ladCurrentQuantity: 0,
    ladInitialBuyExecuted: 0,
  );

  Ladder get selectedLadderL1 => _selectedLadderL1;

  set selectedLadderL1(Ladder value) {
    _selectedLadderL1 = value;
    notifyListeners();
  }

  Ladder _selectedLadderL2 = Ladder(
    ladId: 0,
    ladUserId: 0,
    ladTicker: '',
    ladName: '',
    ladStatus: FilterOption.inactive,
    ladTickerId: 0,
    ladExchange: '',
    ladTradingMode: '',
    ladCashAllocated: '',
    ladCashGain: '',
    ladCashLeft: '',
    ladLastTradePrice: 0,
    ladLastTradeOrderPrice: 0,
    ladMinimumPrice: '',
    ladExtraCashGenerated: '',
    ladExtraCashLeft: '',
    ladRealizedProfit: '',
    ladInitialBuyQuantity: 0,
    ladDefaultBuySellQuantity: 0,
    ladTargetPrice: '',
    ladNumOfStepsAbove: 0,
    ladNumOfStepsBelow: 0,
    ladCashNeeded: '',
    ladInitialBuyPrice: '',
    ladCurrentQuantity: 0,
    ladInitialBuyExecuted: 0,
  );

  Ladder get selectedLadderL2 => _selectedLadderL2;

  set selectedLadderL2(Ladder value) {
    _selectedLadderL2 = value;
    notifyListeners();
  }

  List<Ladder> _ladderList = [
    Ladder(
      ladId: 370,
      ladUserId: 717,
      ladDefinitionId: 428,
      ladPositionId: 167,
      ladTicker: 'TCS',
      ladName: '001',
      ladStatus: FilterOption.active,
      ladTickerId: 9418,
      ladExchange: 'BSE',
      ladTradingMode: 'SIMULATION',
      ladCashAllocated: '494571.00',
      ladCashGain: '-329714.00',
      ladCashLeft: '494571.00',
      ladLastTradePrice: 4282.00,
      ladLastTradeOrderPrice: 0,
      ladMinimumPrice: '0.00',
      ladExtraCashGenerated: '0.00',
      ladExtraCashLeft: '',
      ladRealizedProfit: '0.00',
      ladInitialBuyQuantity: 77,
      ladDefaultBuySellQuantity: 1,
      ladTargetPrice: '8564.00',
      ladNumOfStepsAbove: 40,
      ladNumOfStepsBelow: 77,
      ladCashNeeded: '164857.00',
      ladInitialBuyPrice: '4282.00',
      ladCurrentQuantity: 77,
      ladInitialBuyExecuted: 1,
    ),
    Ladder(
      ladId: 371,
      ladUserId: 717,
      ladDefinitionId: 429,
      ladPositionId: null,
      ladTicker: 'TCS',
      ladName: '002',
      ladStatus: FilterOption.active,
      ladTickerId: 9418,
      ladExchange: 'BSE',
      ladTradingMode: 'SIMULATION',
      ladCashAllocated: '398226.00',
      ladCashGain: '-265484.00',
      ladCashLeft: '398226.00',
      ladLastTradePrice: 4282.00,
      ladLastTradeOrderPrice: 0,
      ladMinimumPrice: '0.00',
      ladExtraCashGenerated: '0.00',
      ladExtraCashLeft: '',
      ladRealizedProfit: '0.00',
      ladInitialBuyQuantity: 62,
      ladDefaultBuySellQuantity: 1,
      ladTargetPrice: '8564.00',
      ladNumOfStepsAbove: 40,
      ladNumOfStepsBelow: 62,
      ladCashNeeded: '132742.00',
      ladInitialBuyPrice: '4282.00',
      ladCurrentQuantity: 62,
      ladInitialBuyExecuted: 1,
    ),
  ];


  List<Ladder> get ladderList => _ladderList;

  set ladderList(List<Ladder> value) {
    _ladderList = value;
    notifyListeners();
  }


  // -------------------------------------

  int _quantitiesLadder1 = 0;
  int get quantitiesLadder1 => _quantitiesLadder1;
  set quantitiesLadder1(int quantitiesLadderBunch) {
    _quantitiesLadder1 = quantitiesLadderBunch;
    notifyListeners();
  }

  int _quantitiesLadder2 = 0;
  int get quantitiesLadder2 => _quantitiesLadder2;
  set quantitiesLadder2(int quantitiesLadder2Bunch) {
    _quantitiesLadder2 = quantitiesLadder2Bunch;
    notifyListeners();
  }

  double _targetPrice = 0.0;
  double get targetPrice => _targetPrice;
  set targetPrice(double targetPriceBunch) {
    _targetPrice = targetPriceBunch;
    notifyListeners();
  }

  double _cashNeededLadder1 = 0.0;
  double get cashNeededLadder1 => _cashNeededLadder1;
  set cashNeededLadder1(double cashNeededLadder1Bunch) {
    _cashNeededLadder1 = cashNeededLadder1Bunch;
    notifyListeners();
  }

  double _cashNeededLadder2 = 0.0;
  double get cashNeededLadder2 => _cashNeededLadder2;
  set cashNeededLadder2(double cashNeededLadder2Bunch) {
    _cashNeededLadder2 = cashNeededLadder2Bunch;
    notifyListeners();
  }

  double _stepSizeLadder1 = 0.0;
  double get stepSizeLadder1 => _stepSizeLadder1;
  set stepSizeLadder1(double stepSizeLadder1Bunch) {
    _stepSizeLadder1 = stepSizeLadder1Bunch;
    notifyListeners();
  }

  double _stepSizeLadder2 = 0.0;
  double get stepSizeLadder2 => _stepSizeLadder2;
  set stepSizeLadder2(double stepSizeLadder2Bunch) {
    _stepSizeLadder2 = stepSizeLadder2Bunch;
    notifyListeners();
  }

  bool _cashNeededIsGreater = false;
  bool get cashNeededIsGreater => _cashNeededIsGreater;
  set cashNeededIsGreater(bool cashNeededIsGreaterBunch) {
    _cashNeededIsGreater = cashNeededIsGreaterBunch;
    notifyListeners();
  }

  double _currentPrice = 0.0;

  double get currentPrice => _currentPrice;

  set currentPrice(double value) {
    _currentPrice = value;
    notifyListeners();
  }

  int _newOrderSize = 0;
  int get newOrderSize => _newOrderSize;
  set newOrderSize(int newOrderSizeBunch) {
    _newOrderSize = newOrderSizeBunch;
    notifyListeners();
  }

  double _newStepSize = 0.0;
  double get newStepSize => _newStepSize;
  set newStepSize(double newStepSizeBunch) {
    _newStepSize = newStepSizeBunch;
    notifyListeners();
  }

  double _newNumberofStepsAbove = 0.0;
  double get newNumberofStepsAbove => _newNumberofStepsAbove;
  set newNumberofStepsAbove(double newNumberofStepsAboveBunch) {
    _newNumberofStepsAbove = newNumberofStepsAboveBunch;
    notifyListeners();
  }

  int _newNumberofStepsBelow = 0;
  int get newNumberofStepsBelow => _newNumberofStepsBelow;
  set newNumberofStepsBelow(int newNumberofStepsBelowBunch) {
    _newNumberofStepsBelow = newNumberofStepsBelowBunch;
    notifyListeners();
  }

  double _newCashNeeded = 0;
  double get newCashNeeded => _newCashNeeded;
  set newCashNeeded(double newCashNeededBunch) {
    _newCashNeeded = newCashNeededBunch;
    notifyListeners();
  }

  Future<bool> assignValueAndCallMoveToLadder() async {

    print("inside assignValueAndCallMoveToLadder");

    quantitiesLadder1 = selectedLadderL1.ladCurrentQuantity;
    quantitiesLadder2 = selectedLadderL2.ladCurrentQuantity;

    cashNeededLadder1 = double.parse(selectedLadderL1.ladCashNeeded);
    cashNeededLadder2 = double.parse(selectedLadderL2.ladCashNeeded);

    stepSizeLadder1 = (double.parse(selectedLadderL1.ladTargetPrice) - double.parse(selectedLadderL1.ladInitialBuyPrice)) / selectedLadderL1.ladNumOfStepsAbove;

    targetPrice = double.parse(selectedLadderL1.ladTargetPrice);
    return moveToLadder();

  }

  int _quantities = 0;

  int get quantities => _quantities;

  set quantities(int value) {
    _quantities = value;
    notifyListeners();
  }

  Future<bool> moveToLadder() async {
    print("inside moveToLadder");
    quantities = (quantitiesLadder1 + quantitiesLadder2);
    // double cashNeededCalculated =
    //     (quantities * (currentPrice * currentPrice)) / (2 * (targetPrice - currentPrice));
    double cashNeededSum = cashNeededLadder1 + cashNeededLadder2;

    print("quantitiesLadder1 = ${quantitiesLadder1}");
    print("quantitiesLadder2 = ${quantitiesLadder2}");
    print("quantities = ${quantities}");
    print("currentPrice = ${currentPrice}");
    print("targetPrice = ${targetPrice}");
    print("cashNeededLadder1 = ${cashNeededLadder1}");
    print("cashNeededLadder2 = ${cashNeededLadder2}");
    print("cashNeededSum = ${cashNeededSum}");


    // if (cashNeededCalculated > cashNeededSum) {
    //   print("inside first if");
    //   cashNeededIsGreater = true;
    // }
    // if (!cashNeededIsGreater || cashNeededIsGreater) {
    //
    // }

    print("inside if");
    newOrderSize =
        ((quantities / (targetPrice - currentPrice)) * stepSizeLadder1).floor();

    print("newOrderSize = ${newOrderSize}");
    newNumberofStepsAbove = quantities / newOrderSize;

    print("newNumberofStepsAbove = ${newNumberofStepsAbove}");
    newStepSize = (targetPrice - currentPrice) / newNumberofStepsAbove;

    print("newStepSize = ${newStepSize}");
    newNumberofStepsBelow = (currentPrice / newStepSize).floor();

    print("newNumberofStepsBelow = ${newNumberofStepsBelow}");
    newCashNeeded = currentPrice / 2 * newNumberofStepsBelow * newOrderSize;

    print("newCashNeeded = ${newCashNeeded}");

    if (newCashNeeded > cashNeededSum) {
      print("inside first if");
      selectedLadderId = "";
      cashNeededIsGreater = true;

      return false;
    } else {
      cashNeededIsGreater = false;
      // cashNeededIsGreater = true;
      // selectedLadderId = "";

      return true;
      // return false;
    }
    // newCashNeeded - cashNeededSum
  }

  Future<bool> moveFundsToLadder() async {
    try {
      MoveFundsToLadderRequest moveFundsToLadder;
      moveFundsToLadder = MoveFundsToLadderRequest(
          to_lad_id: selectedLadderL1.ladId,
          from_lad_id: selectedLadderL2.ladId,
          total_quantity: quantities,
          sell_units: 0,
          new_cash_needed: newCashNeeded,
          new_order_size: newOrderSize,
          new_step_size: newStepSize,
          new_number_of_steps_above: newNumberofStepsAbove,
          new_number_of_steps_below: newNumberofStepsBelow,
      );

      await MoveFundsToLadderService()
          .moveFundsToLadder(moveFundsToLadder);

      return true;
    } catch (e) {
      print("error in the addCashToLadder function in the provider $e");
      // throw e;
      return false;
    }
  }
}
