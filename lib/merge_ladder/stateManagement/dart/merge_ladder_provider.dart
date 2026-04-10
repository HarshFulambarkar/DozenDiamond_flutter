
import 'package:flutter/material.dart';

import '../../model/ladder_list_model.dart';

class MergeLadderProvider extends ChangeNotifier {
  MergeLadderProvider(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  double availableCashInAccount = 1000000;
  // double target = 8630.30;
  // double cashAlreadyAllocated = 975223.90;
  // double stepSize = 113.56;
  // int orderSize = 4;
  double currentPrice = 4437.44;
  // int currentStockOwn = 156;
  // double cashNeeded = 319321.10;

  String _selectedLadderId = "";

  String get selectedLadderId => _selectedLadderId;

  set selectedLadderId(String value) {
    _selectedLadderId = value;
    notifyListeners();
  }

  // Ladder _selectedLadderL1 = Ladder(
  //   ladId: 369,
  //   ladUserId: 717,
  //   ladDefinitionId: 428,
  //   ladPositionId: 167,
  //   ladTicker: 'TCS',
  //   ladName: '001',
  //   ladStatus: FilterOption.active,
  //   ladTickerId: 9418,
  //   ladExchange: 'BSE',
  //   ladTradingMode: 'SIMULATION',
  //   ladCashAllocated: '494571.00',
  //   ladCashGain: '-329714.00',
  //   ladCashLeft: '494571.00',
  //   ladLastTradePrice: 4282.00,
  //   ladLastTradeOrderPrice: 0,
  //   ladMinimumPrice: '0.00',
  //   ladExtraCashGenerated: '0.00',
  //   ladExtraCashLeft: '',
  //   ladRealizedProfit: '0.00',
  //   ladInitialBuyQuantity: 77,
  //   ladDefaultBuySellQuantity: 1,
  //   ladTargetPrice: '8564.00',
  //   ladNumOfStepsAbove: 40,
  //   ladNumOfStepsBelow: 77,
  //   ladCashNeeded: '164857.00',
  //   ladInitialBuyPrice: '4282.00',
  //   ladCurrentQuantity: 77,
  //   ladInitialBuyExecuted: 1,
  // );

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
      ladCashAssigned: "0"
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
    ladCashAssigned: "0"
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
      ladCashAssigned: '494571.00',
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
      ladCashAssigned: '398226.00',
    ),
  ];


  List<Ladder> get ladderList => _ladderList;

  set ladderList(List<Ladder> value) {
    _ladderList = value;
    notifyListeners();
  }

  double r1 = 0;
  double r2 = 0;
  double _targetPrice3 = 0;

  double get targetPrice3 => _targetPrice3;

  set targetPrice3(double value) {
    _targetPrice3 = value;
    notifyListeners();
  }

  double _initialBuyPrice3 = 0;

  double get initialBuyPrice3 => _initialBuyPrice3;

  set initialBuyPrice3(double value) {
    _initialBuyPrice3 = value;
    notifyListeners();
  }

  int _initialQuantity3 = 0;

  int get initialQuantity3 => _initialQuantity3;

  set initialQuantity3(int value) {
    _initialQuantity3 = value;
    notifyListeners();
  }

  double _cashNeeded3 = 0;

  double get cashNeeded3 => _cashNeeded3;

  set cashNeeded3(double value) {
    _cashNeeded3 = value;
    notifyListeners();
  }

  int _defaultQuantity3 = 0;

  int get defaultQuantity3 => _defaultQuantity3;

  set defaultQuantity3(int value) {
    _defaultQuantity3 = value;
    notifyListeners();
  }

  double _stepSize3 = 0;

  double get stepSize3 => _stepSize3;

  set stepSize3(double value) {
    _stepSize3 = value;
    notifyListeners();
  }

  double ratio3 = 0;

  double _NaOptimalL3 = 0;


  double get NaOptimalL3 => _NaOptimalL3;

  set NaOptimalL3(double value) {
    _NaOptimalL3 = value;
    notifyListeners();
  } // calculation starts here

  void calculateRatios() {
    print("inside calculateRatios");
    print(selectedLadderL1.ladCurrentQuantity);
    print(selectedLadderL2.ladCurrentQuantity);
    r1 = selectedLadderL1.ladCurrentQuantity / (double.parse(selectedLadderL1.ladTargetPrice) - double.parse(selectedLadderL1.ladInitialBuyPrice));
    r2 = selectedLadderL2.ladCurrentQuantity / (double.parse(selectedLadderL2.ladTargetPrice) - double.parse(selectedLadderL2.ladInitialBuyPrice));

    print(r1);
    print(r2);
  }

  void calculateTargetPrice3() {
    targetPrice3 = (selectedLadderL1.ladInitialBuyQuantity + selectedLadderL2.ladInitialBuyQuantity + (currentPrice * r1) + (currentPrice * r2)) / (r1 + r2);
  }

  void calculateInitialBuyPrice3() {
    initialBuyPrice3 = (double.parse(selectedLadderL1.ladInitialBuyPrice) * r1 + double.parse(selectedLadderL2.ladInitialBuyPrice) * r2) /
        (r1 + r2);
  }

  void calculateInitialQuantity3() {
    print("inside calculateInitialQuantity3");
    print(selectedLadderL1.ladInitialBuyQuantity);
    print(selectedLadderL2.ladInitialBuyQuantity);
    initialQuantity3 = selectedLadderL1.ladInitialBuyQuantity + selectedLadderL2.ladInitialBuyQuantity;
  }

  void calculateCashNeeded3() {
    cashNeeded3 = double.parse((double.parse(selectedLadderL1.ladCashNeeded) + double.parse(selectedLadderL2.ladCashNeeded)).toStringAsFixed(2));
  }

  void calculateOptimalNaAndDefaultQuantity3() {
    print("inside calculateOptimalNaAndDefaultQuantity3");
    print(initialQuantity3);
    int Na = 40;
    double smallestDifference = double.infinity;
    int optimalNa = Na;
    int optimalD3 = 0;

    // Iterating Na below and above the starting Na value (10 steps each)
    for (int i = -10; i <= 10; i++) {
      int NaTest = Na + i;
      if (NaTest <= 0) continue;

      int d3 = (initialQuantity3 / NaTest).floor();
      int i3Temp = d3 * NaTest;
      double difference = (initialQuantity3 - i3Temp).floorToDouble();

      if (difference < smallestDifference) {
        smallestDifference = difference;
        optimalNa = NaTest;
        optimalD3 = d3;
      }
    }

    // Assigning the best-found values to defaultQuantity3 and NaOptimal
    defaultQuantity3 = optimalD3;
    double NaOptimal = initialQuantity3 / defaultQuantity3;
    NaOptimalL3 = NaOptimal;
    print('Optimal Na: $NaOptimal, Default Quantity d3: $defaultQuantity3');
  }

  void calculateRatio3() {
    ratio3 = r1 + r2;
  }

  void calculateFinalCashNeeded3() {
    cashNeeded3 = double.parse((((currentPrice * currentPrice) * ratio3) / 2).toStringAsFixed(2));
  }

  void calculateStepSize3() {
    print(targetPrice3);
    print(initialBuyPrice3);
    print(NaOptimalL3);
    double stepSize = (targetPrice3 - initialBuyPrice3) / NaOptimalL3; //defaultQuantity3;
    stepSize3 = double.parse(stepSize.toStringAsFixed(2));
    print('Step Size S3: $stepSize');
  }

  void calculateQuantitiesHold3() {
    int quantitiesHold3 = selectedLadderL1.ladCurrentQuantity + selectedLadderL2.ladCurrentQuantity;
    print('Quantities Hold Q3: $quantitiesHold3');
  }

  void mergeLadders() {
    calculateRatios();
    calculateTargetPrice3();
    calculateInitialBuyPrice3();
    calculateInitialQuantity3();
    calculateCashNeeded3();
    calculateOptimalNaAndDefaultQuantity3();
    calculateRatio3();
    calculateFinalCashNeeded3();
    calculateStepSize3();
    calculateQuantitiesHold3();
  }


  // calculation end here







// List<LadderListModel> stockLadders = [
  //   LadderListModel(
  //     stockName: 'TCS',
  //     currentPrice: "5000.00",
  //     ladders: [
  //       Ladder(
  //           ladId: 351,
  //           ladUserId: 717,
  //           ladDefinitionId: 406,
  //           ladPositionId: null,
  //           ladTicker: 'TCS',
  //           ladName: '001',
  //           ladStatus: FilterOption.active,
  //           ladTickerId: 9418,
  //           ladExchange: 'BSE',
  //           ladTradingMode: 'SIMULATION',
  //           ladCashAllocated: '495000.0',
  //           ladCashGain: '75.76',
  //           ladCashLeft: '0.0',
  //           ladLastTradePrice: 495000.0,
  //           ladLastTradeOrderPrice: 0.0,
  //           ladMinimumPrice: '0.0',
  //           ladExtraCashGenerated: '0.0',
  //           ladExtraCashLeft: '',
  //           ladRealizedProfit: '0.0',
  //           ladInitialBuyQuantity: 66,
  //           ladDefaultBuySellQuantity: 1,
  //           ladTargetPrice: '10000.0',
  //           ladNumOfStepsAbove: 40,
  //           ladNumOfStepsBelow: 40,
  //           ladCashNeeded: '165000.0',
  //           ladInitialBuyPrice: '5000.0',
  //           ladCurrentQuantity: 0,
  //           ladInitialBuyExecuted: 0
  //       )
  //     ]
  //
  //   ),
  //
  //   LadderListModel(
  //       stockName: 'ATGL',
  //       currentPrice: "5000.00",
  //       ladders: [
  //         Ladder(
  //             ladId: 352,
  //             ladUserId: 717,
  //             ladDefinitionId: 407,
  //             ladPositionId: null,
  //             ladTicker: 'ATGL',
  //             ladName: '001',
  //             ladStatus: FilterOption.active,
  //             ladTickerId: 6144,
  //             ladExchange: 'BSE',
  //             ladTradingMode: 'SIMULATION',
  //             ladCashAllocated: '495000.0',
  //             ladCashGain: '75.76',
  //             ladCashLeft: '0.0',
  //             ladLastTradePrice: 495000.0,
  //             ladLastTradeOrderPrice: 0.0,
  //             ladMinimumPrice: '0.0',
  //             ladExtraCashGenerated: '0.0',
  //             ladExtraCashLeft: '',
  //             ladRealizedProfit: '0.0',
  //             ladInitialBuyQuantity: 66,
  //             ladDefaultBuySellQuantity: 1,
  //             ladTargetPrice: '10000.0',
  //             ladNumOfStepsAbove: 40,
  //             ladNumOfStepsBelow: 40,
  //             ladCashNeeded: '165000.0',
  //             ladInitialBuyPrice: '5000.0',
  //             ladCurrentQuantity: 0,
  //             ladInitialBuyExecuted: 0
  //         )
  //       ]
  //
  //   )
  // ];
}