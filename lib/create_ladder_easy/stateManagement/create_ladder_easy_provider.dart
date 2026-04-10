import 'package:dozen_diamond/create_ladder_detailed/stateManagement/optimal_calculation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../create_ladder_detailed/models/stock_recommended_parameters_response.dart';
import '../../global/models/http_api_exception.dart';
import '../model/create_ladder_request.dart';
import '../model/create_ladder_response.dart';
import '../model/ladder_creation_tickers_response.dart';
import '../services/rest_api_service.dart';
import '../utils/utility.dart';

class CreateLadderEasyProvider extends ChangeNotifier {
  CreateLadderEasyProvider(this.navigatorKey);

  late OptimalLadderCalculation optimalLadderCalculation;
  final GlobalKey<NavigatorState> navigatorKey;

  TextEditingController targetPriceMultiplierTextEditingController =
  TextEditingController(text: "");

  TextEditingController targetTextEditingController =
      TextEditingController(text: "");

  TextEditingController initialBuyQuantityTextEditingController =
      TextEditingController(text: "");

  TextEditingController numberOfStepsAboveTextEditingController =
      TextEditingController(text: "");

  TextEditingController stepSizeTextEditingController =
    TextEditingController(text: "");

  double _numberOfStepAboveForSlider = 0.0;

  double get numberOfStepAboveForSlider => _numberOfStepAboveForSlider;

  set numberOfStepAboveForSlider(double value) {
    _numberOfStepAboveForSlider = value;
    notifyListeners();
  }

  bool _updateCheckbox = false;

  bool get updateCheckbox => _updateCheckbox;

  set updateCheckbox(bool value) {
    _updateCheckbox = value;
    notifyListeners();
  }

  bool _enableTargetButton = false;

  bool get enableTargetButton => _enableTargetButton;

  set enableTargetButton(bool value) {
    _enableTargetButton = value;
    notifyListeners();
  }

  bool _enableTargetPriceMultiplierButton = false;

  bool get enableTargetPriceMultiplierButton =>
      _enableTargetPriceMultiplierButton;

  set enableTargetPriceMultiplierButton(bool value) {
    _enableTargetPriceMultiplierButton = value;
    notifyListeners();
  }

  bool _enableStepSizeButton = false;

  bool get enableStepSizeButton => _enableStepSizeButton;

  set enableStepSizeButton(bool value) {
    _enableStepSizeButton = value;
    notifyListeners();
  }

  bool _enableInitialBuyQuantityButton = false;

  bool get enableInitialBuyQuantityButton => _enableInitialBuyQuantityButton;

  set enableInitialBuyQuantityButton(bool value) {
    _enableInitialBuyQuantityButton = value;
    notifyListeners();
  }

  bool _enableNumberOfStepsAboveButton = false;

  bool get enableNumberOfStepsAboveButton => _enableNumberOfStepsAboveButton;

  set enableNumberOfStepsAboveButton(bool value) {
    _enableNumberOfStepsAboveButton = value;
    notifyListeners();
  }

  String _targetErrorText = '';

  String get targetErrorText => _targetErrorText;

  set targetErrorText(String value) {
    _targetErrorText = value;
    notifyListeners();
  }

  String _targetPriceMultiplierErrorText = "";

  String get targetPriceMultiplierErrorText => _targetPriceMultiplierErrorText;

  set targetPriceMultiplierErrorText(String value) {
    _targetPriceMultiplierErrorText = value;
    notifyListeners();
  }

  String _stepSizeErrorText = "";

  String get stepSizeErrorText => _stepSizeErrorText;

  set stepSizeErrorText(String value) {
    _stepSizeErrorText = value;
    notifyListeners();
  }

  String _initialBuyErrorText = "";

  String get initialBuyErrorText => _initialBuyErrorText;

  set initialBuyErrorText(String value) {
    _initialBuyErrorText = value;
    notifyListeners();
  }

  String _numberOfStepAboveErrorText = "";

  String get numberOfStepAboveErrorText => _numberOfStepAboveErrorText;

  set numberOfStepAboveErrorText(String value) {
    _numberOfStepAboveErrorText = value;
    notifyListeners();
  }

  double _targetValue = 0.0;

  double get targetValue => _targetValue;

  set targetValue(double value) {
    _targetValue = value;
    notifyListeners();
  }

  double _targetPriceMultiplierValue = 1.2;

  double get targetPriceMultiplierValue => _targetPriceMultiplierValue;

  set targetPriceMultiplierValue(double value) {
    _targetPriceMultiplierValue = value;

    notifyListeners();
  }

  String? _ticker = "";

  String get ticker => _ticker!;

  set ticker(String value) {
    _ticker = value;
    notifyListeners();
  }

  String? _tickerId = "";

  String get tickerId => _tickerId!;

  set tickerId(String value) {
    _tickerId = value;
    notifyListeners();
  }

  double? _tickerPrice = 0.0;

  double get tickerPrice => _tickerPrice!;

  set tickerPrice(double value) {
    _tickerPrice = value;
    notifyListeners();
  }

  double? _initialBuyPrice = 0.0;

  double get initialBuyPrice => _initialBuyPrice!;

  set initialBuyPrice(double value) {
    _initialBuyPrice = value;
    notifyListeners();
  }

  double? _priorCashAllocation = 0.0;

  double get priorCashAllocation => _priorCashAllocation!;

  set priorCashAllocation(double value) {
    _priorCashAllocation = value;
    notifyListeners();
  }

  int _initialBuyQuantityValue = 0;

  int get initialBuyQuantityValue => _initialBuyQuantityValue;

  set initialBuyQuantityValue(int value) {
    _initialBuyQuantityValue = value;
    notifyListeners();
  }

  int _buySellQuantityValue = 0;

  int get buySellQuantityValue => _buySellQuantityValue;

  set buySellQuantityValue(int value) {
    _buySellQuantityValue = value;
    notifyListeners();
  }

  double? _cashLeft;

  double? get cashLeft => _cashLeft;

  set cashLeft(double? cashLeftBunch) {
    _cashLeft = cashLeftBunch;
    notifyListeners();
  }

  double _numberOfStepsAboveValue = 0.0;

  double get numberOfStepsAboveValue => _numberOfStepsAboveValue;

  set numberOfStepsAboveValue(double value) {
    _numberOfStepsAboveValue = value;
    notifyListeners();
  }

  double _stepSizeValue = 0.0;

  double get stepSizeValue => _stepSizeValue;

  set stepSizeValue(double value) {
    _stepSizeValue = value;

    notifyListeners();
  }

  int _numberOfStepsBelow = 0;

  int get numberOfStepsBelow => _numberOfStepsBelow;

  set numberOfStepsBelow(int value) {
    _numberOfStepsBelow = value;
    notifyListeners();
  }

  double _averagePurchasePrice = 0.0;

  double get averagePurchasePrice => _averagePurchasePrice;

  set averagePurchasePrice(double value) {
    _averagePurchasePrice = value;
    notifyListeners();
  }

  double _cashNeeded = 0.0;

  double get cashNeeded => _cashNeeded;

  set cashNeeded(double value) {
    _cashNeeded = value;
  }

  double _finalCashAllocation = 0.0;

  double get finalCashAllocation => _finalCashAllocation;

  set finalCashAllocation(double value) {
    _finalCashAllocation = value;
    notifyListeners();
  }

  double _initialBuyCash = 0.0;

  double get initialBuyCash => _initialBuyCash;

  set initialBuyCash(double value) {
    _initialBuyCash = value;
    notifyListeners();
  }

  double _currentPrice = 0.0;

  double get currentPrice => _currentPrice;

  set currentPrice(double value) {
    _currentPrice = value;
    notifyListeners();
  }

  List<LadderDetails> _ladderDetailsList = <LadderDetails>[];

  List<LadderDetails> get ladderDetailsList => _ladderDetailsList;

  List<Map<String, dynamic>> _listOfValues = [];

  List<Map<String, dynamic>> get listOfValues => _listOfValues;

  set listOfValues(List<Map<String, dynamic>> value) {
    _listOfValues = value;
    notifyListeners();
  }

  set ladderDetailsList(List<LadderDetails> value) {
    _ladderDetailsList = value;
    notifyListeners();
  }

  bool _isTargetPriceAvailable = false;

  bool get isTargetPriceAvailable => _isTargetPriceAvailable;

  set isTargetPriceAvailable(bool value) {
    _isTargetPriceAvailable = value;
    notifyListeners();
  }

  Map<String, StockRecommendedParametersData> _stockRecommendedParametersDataEasyLadderCreate = {};

  Map<String, StockRecommendedParametersData>
  get stockRecommendedParametersDataEasyLadderCreate => _stockRecommendedParametersDataEasyLadderCreate;

  set stockRecommendedParametersDataEasyLadderCreate(
      Map<String, StockRecommendedParametersData> value) {
    _stockRecommendedParametersDataEasyLadderCreate = value;
    notifyListeners();
  }

  Map<String, bool> _isRecommendedParametersEnabledTargetPriceMultiplier = {};

  Map<String, bool> get isRecommendedParametersEnabledTargetPriceMultiplier =>
      _isRecommendedParametersEnabledTargetPriceMultiplier;

  set isRecommendedParametersEnabledTargetPriceMultiplier(
      Map<String, bool> value) {
    _isRecommendedParametersEnabledTargetPriceMultiplier = value;
    notifyListeners();
  }

  Map<String, bool> _isRecommendedParametersEnabledStepSize = {};

  Map<String, bool> get isRecommendedParametersEnabledStepSize =>
      _isRecommendedParametersEnabledStepSize;

  set isRecommendedParametersEnabledStepSize(Map<String, bool> value) {
    _isRecommendedParametersEnabledStepSize = value;
    notifyListeners();
  }

  String? _tickerExchange = "";

  String get tickerExchange => _tickerExchange!;

  set tickerExchange(String value) {
    _tickerExchange = value;
    notifyListeners();
  }

  void resetValue() {
    initialBuyQuantityValue = 0;
    numberOfStepAboveForSlider = 0;
    numberOfStepsAboveValue = 0;
  }

  void validateTargetPriceMultiplierValue(value) {

    // isRecommendedParametersEnabledTargetPriceMultiplier[ticker] = false;
    if (value != "") {

      if ((double.parse(value) >= 1.2) &&
          (double.parse(value) <= 50)) {
        enableTargetPriceMultiplierButton = true;
        targetPriceMultiplierValue = double.parse(value);
        targetPriceMultiplierErrorText = '';
      // } else if (double.parse(value) <= ((double.tryParse(targetTextEditingController.text.replaceAll(",", "")) ?? 0.0) - (double.tryParse(initialBuyPrice.toString().replaceAll(",", "")) ?? 0.0))) {
      //   enableStepSizeButton = true;
      //   stepSizeValue = double.parse(value);
      //   targetErrorText = '';
      } else if (double.parse(value) < 1.2) {
        enableTargetPriceMultiplierButton = false;
        targetPriceMultiplierValue = 1.2;
        targetPriceMultiplierErrorText = "Please enter value in range";
      } else if (double.parse(value) > 50) {
        enableTargetPriceMultiplierButton = false;
        targetPriceMultiplierValue = 50; //double.parse(value);
        targetPriceMultiplierErrorText = "Please enter value in range";
      } else {
        enableTargetPriceMultiplierButton = false;
        targetPriceMultiplierValue = double.parse(value);
        targetPriceMultiplierErrorText =
        "Please enter valid value";
      }
    } else {
      enableStepSizeButton = false;
      stepSizeErrorText = "";
      stepSizeValue = 0.0;
    }
    updateCheckbox = false;
  }

  void validateStepSizeValue(value) {

    // isRecommendedParametersEnabledStepSize[ticker] = false;
    if (value != "") {

      if ((double.parse(value) > (((double.tryParse(targetTextEditingController.text.replaceAll(",", "")) ?? 0.0) - (double.tryParse(initialBuyPrice.toString().replaceAll(",", "")) ?? 0.0)) / (double.tryParse(initialBuyQuantityTextEditingController.text.replaceAll(",", "")) ?? 0.0))) &&
          (double.parse(value) <= ((double.tryParse(targetTextEditingController.text.replaceAll(",", "")) ?? 0.0) - (double.tryParse(initialBuyPrice.toString().replaceAll(",", "")) ?? 0.0)))) {
        enableStepSizeButton = true;
        stepSizeValue = double.parse(value);
        stepSizeErrorText = '';
        // } else if (double.parse(value) <= ((double.tryParse(targetTextEditingController.text.replaceAll(",", "")) ?? 0.0) - (double.tryParse(initialBuyPrice.toString().replaceAll(",", "")) ?? 0.0))) {
        //   enableStepSizeButton = true;
        //   stepSizeValue = double.parse(value);
        //   targetErrorText = '';
      } else if (double.parse(value) <= (((double.tryParse(targetTextEditingController.text.replaceAll(",", "")) ?? 0.0) - (double.tryParse(initialBuyPrice.toString().replaceAll(",", "")) ?? 0.0)) / (double.tryParse(initialBuyQuantityTextEditingController.text.replaceAll(",", "")) ?? 0.0))) {
        enableStepSizeButton = false;
        stepSizeValue = 0.0;
        stepSizeErrorText = "Please enter value in range";
      } else if (double.parse(value) > ((double.tryParse(targetTextEditingController.text.replaceAll(",", "")) ?? 0.0) - (double.tryParse(initialBuyPrice.toString().replaceAll(",", "")) ?? 0.0))) {
        enableStepSizeButton = false;
        stepSizeValue = double.parse(value);
        stepSizeErrorText = "Please enter value in range";
      } else {
        enableStepSizeButton = false;
        stepSizeValue = double.parse(value);
        stepSizeErrorText =
        "Please enter valid value";
      }
    } else {
      enableStepSizeButton = false;
      stepSizeErrorText = "";
      stepSizeValue = 0.0;
    }
    updateCheckbox = false;
  }


  void validateTargetValue(value) {
    if (value != "") {
      if (double.parse(value) >
          Utility().multiplyBy1Point2(tickerPrice ?? 0.0)) {
        enableTargetButton = true;
        targetValue = double.parse(value);
        targetErrorText = '';
        _isTargetPriceAvailable = true;
      } else if (double.parse(value) <= 0) {
        enableTargetButton = false;
        targetValue = 0.0;
        targetErrorText = "Please enter non zero value";
        _isTargetPriceAvailable = false;
      } else {
        enableTargetButton = false;
        targetValue = 0.0;
        targetErrorText =
            "Target Can not be less then 1.2 times of current price";
        _isTargetPriceAvailable = false;
      }
    } else {
      enableTargetButton = false;
      targetErrorText = "";
      targetValue = 0.0;
    }
    updateCheckbox = false;
  }

  void validateNumberOfStepsAbove() {
    if (numberOfStepsAboveTextEditingController.text != "") {
      if (int.parse(numberOfStepsAboveTextEditingController.text) <= 0 ||
          int.parse(numberOfStepsAboveTextEditingController.text) >
              initialBuyQuantityValue) {
        numberOfStepAboveErrorText =
            "Invalid number of steps above or zero value";
      } else {
        numberOfStepAboveErrorText = "";
        enableNumberOfStepsAboveButton = true;
        numberOfStepsAboveValue =
            double.parse(numberOfStepsAboveTextEditingController.text);
        numberOfStepAboveForSlider = numberOfStepsAboveValue;
      }
    } else {
      numberOfStepAboveErrorText = "";
      enableNumberOfStepsAboveButton = false;
    }
    updateCheckbox = false;
  }

  void validateInitialBuyQuantityValue(value) {
    if (value != "") {
      if (double.parse(value) <=
          Utility().calculateInitialBuyQuantityMaxValue(
            targetValue,
            tickerPrice!,
            priorCashAllocation!,
            tickerPrice!,
          )) {
        print("below value");
        print(value);

        if (double.parse(value) <= 0) {
          enableInitialBuyQuantityButton = false;
          initialBuyQuantityValue = 0;
          initialBuyErrorText = "Enter non zero value";
        } else {
          enableInitialBuyQuantityButton = true;
          initialBuyQuantityValue = int.parse(value);
          initialBuyErrorText = '';
        }
      } else {
        enableInitialBuyQuantityButton = false;
        initialBuyQuantityValue = 0;
        initialBuyErrorText = "Invalid Initial Buy Quantity";
      }
    } else {
      enableInitialBuyQuantityButton = false;
      initialBuyErrorText = "";
      initialBuyQuantityValue = 0;
    }
    updateCheckbox = false;
  }

  Future<void> calculateLadderParameter(BuildContext context) async {
    if (targetTextEditingController.text.isEmpty ||
        initialBuyQuantityTextEditingController.text.isEmpty ||
        numberOfStepsAboveTextEditingController.text.isEmpty ||
        stepSizeTextEditingController.text.isEmpty) {
      print("in if of calculateLadderParameter");
      // showDialog(
      //   context: navigatorKey.currentContext!,
      //   builder: (context) {
      //     return alertDialog(
      //         "Insert all the values";
      //     );
      //   });
    } else {
      optimalLadderCalculation = OptimalLadderCalculation(
          initialBuyQuantityValue:
              int.parse(initialBuyQuantityTextEditingController.text),
          initialBuyPrice: initialBuyPrice,
          numberOfStepsAboveValue: numberOfStepsAboveValue.toDouble(),
          targetValue: targetValue,
          priorCashAllocation: priorCashAllocation,
          tickerPrice: tickerPrice,
          selectedMode: "Easy",
          priorBuyInitialPurchasePrice: 0
      );
      print("number of steps above ${numberOfStepsAboveValue}");
      Map<String, dynamic> listOfItems =
          optimalLadderCalculation.calculateLadderParameter();
      print("here is the listItems $listOfItems");
      // print("we go here 0");
      // calculations();
      // calculateOptimalParameters();
      // print("we go here 1");
      // numberOfStepsAboveValue = 40;
      // print("we go here 2");
      // buySellQuantityValue =
      //     (int.parse(initialBuyQuantityTextEditingController.text) /
      //             numberOfStepsAboveValue)
      //         .floor();

      // calculations();
      // calculateOptimalParameters();
      // print(
      //     "we go here 3 ${listOfValues[0]['cashNeeded']} and ${listOfValues[1]['cashNeeded']}");

      numberOfStepsAboveValue = listOfItems['numberOfStepsAbove'];
      numberOfStepsBelow = listOfItems['numberOfStepsBelow'];
      buySellQuantityValue = listOfItems['buySellQuantityValue'];
      initialBuyQuantityValue = listOfItems['initialBuyQuantityValue'];
      stepSizeValue = listOfItems['stepSizeValue'];
      averagePurchasePrice = listOfItems['averagePurchasePrice'];
      cashNeeded = listOfItems['cashNeeded'];
      cashLeft = listOfItems['cashLeft'];
      finalCashAllocation = listOfItems['finalCashAllocation'];
      initialBuyCash = listOfItems['initialBuyCash'];

      //   buySellQuantityValue = listOfValues[1]['buySellQuantityValue'];
      //   initialBuyQuantityValue = listOfValues[1]['initialBuyQuantityValue'];
      //   stepSizeValue = listOfValues[1]['stepSizeValue'];
      //   averagePurchasePrice = listOfValues[1]['averagePurchasePrice'];
      //   cashNeeded = listOfValues[1]['cashNeeded'];
      //   cashLeft = listOfValues[1]['cashLeft'];
      //   finalCashAllocation = listOfValues[1]['finalCashAllocation'];
      // }
      // initialBuyQuantityValue = buySellQuantityValue * numberOfStepsAboveValue;

      if (finalCashAllocation < (priorCashAllocation! * 0.8)) {
        // show pop up

        showDialog(
            context: context, //navigatorKey.currentContext!,
            builder: (context) {
              return alertDialog(context,
                  "Your entries are using less than 80% of your cash allocation. Consider adjusting them for optimal use.");
            });
      } else {
        // await ceilCheckNumberOfStepsRequireToUtilizeMaxCashLeft(
        //   tempNumOfStepsAbove: numberOfStepsAboveValue,
        //   buySellQty: buySellQuantityValue,
        //   avgPurchasePrice: averagePurchasePrice,
        // );
      }
    }
  }

  // // Future<void> ceilCheckNumberOfStepsRequireToUtilizeMaxCashLeft(
  //     {required int tempNumOfStepsAbove,
  //     required int buySellQty,
  //     required double avgPurchasePrice}) async {
  //   print("inisde of ceilCheckNumberOfStepsRequireToUtilizeMaxCashLeft");
  //   // print(tempNumOfStepsAbove);

  //   int tempInitialBuyQty = tempNumOfStepsAbove * buySellQty;
  //   print(tempNumOfStepsAbove);
  //   // print(buySellQty);
  //   // print(" tempInitialBuyQty = $tempInitialBuyQty");

  //   double tempInitialPurchaseCashGain = tempInitialBuyQty * initialBuyPrice!;
  //   // print(tempInitialBuyQty);
  //   // print(initialBuyPrice);
  //   // print(" tempInitialPurchaseCashGain = $tempInitialPurchaseCashGain");

  //   double cashLeft = priorCashAllocation! - tempInitialPurchaseCashGain;
  //   // print(priorCashAllocation);
  //   // print(tempInitialPurchaseCashGain);
  //   // print(" cashLeft = $cashLeft");

  //   double tempStepSize =
  //       (targetValue - initialBuyPrice!) / tempNumOfStepsAbove;
  //   // print(targetValue);
  //   // print(initialBuyPrice);
  //   // print(tempNumOfStepsAbove);
  //   // print(" tempStepSize = $tempStepSize");

  //   double stocksToBeBoughtInFuture =
  //       (initialBuyPrice! / tempStepSize).floorToDouble() * buySellQty;
  //   // print(initialBuyPrice);
  //   // print(tempStepSize);
  //   // print(buySellQty);
  //   // print(" stocksToBeBoughtInFuture = $stocksToBeBoughtInFuture");

  //   double cashNeeded = avgPurchasePrice * stocksToBeBoughtInFuture;
  //   // print(avgPurchasePrice);
  //   // print(stocksToBeBoughtInFuture);
  //   // print(" cashNeeded = $cashNeeded");

  //   print("final check");
  //   print("tempNumOfStepsAbove $tempNumOfStepsAbove");
  //   print("cashNeeded $cashNeeded");
  //   print("cashLeft $cashLeft");
  //   print("condition ${cashNeeded < cashLeft}");

  //   if (cashNeeded < cashLeft) {
  //     print("in if of ciel");
  //     initialBuyQuantityValue = tempInitialBuyQty;
  //     stepSizeValue = tempStepSize;
  //     finalCashAllocation =
  //         (initialBuyQuantityValue * initialBuyPrice!) + cashNeeded;

  //     numberOfStepsAboveValue = tempNumOfStepsAbove;

  //     initialBuyCash = initialBuyQuantityValue * tickerPrice!;

  //     // return tempNumOfStepsAbove;
  //   } else {
  //     return ceilCheckNumberOfStepsRequireToUtilizeMaxCashLeft(
  //         tempNumOfStepsAbove: tempNumOfStepsAbove - 1,
  //         buySellQty: buySellQty,
  //         avgPurchasePrice: avgPurchasePrice);
  //   }
  // }

  // Future<bool> getUserStockAndLadder() async {
  //   print("inside getUserStockAndLadder");
  //   try {
  //     LadderCreationTickerResponse? value =
  //     await RestApiService().fetchLadderCreationTickers();

  //     if (value.data!.ladderCreationTickerList != null &&
  //         value.data!.ladderCreationTickerList!.isNotEmpty) {

  //       for (var tickerAndLadderData in value.data!.ladderCreationTickerList!) {

  //         ladderDetailsList.add(
  //             LadderDetails(
  //                 ladTickerId: tickerAndLadderData.ssTickerId,
  //                 ladTicker: tickerAndLadderData.ssTicker,
  //                 ladInitialBuyPrice: tickerAndLadderData.ssCurrentPrice,
  //                 ladCashAllocated: tickerAndLadderData.ssCashAllocated,
  //             )
  //         );

  //       }
  //       notifyListeners();
  //       return false;
  //     } else {
  //       return true;
  //     }
  //   } catch (e) {
  //     print("error caught in the getUserStockAndLadder api");
  //     throw e;
  //   }
  // }

  Widget alertDialog(BuildContext context, String msg) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 10,
              left: 20,
              right: 20,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(
                20,
              ),
              border: Border.all(
                color: Colors.white,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  msg,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "OK",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  refreshLadderValues() {
    targetTextEditingController.clear();
    initialBuyQuantityTextEditingController.clear();
    numberOfStepsAboveTextEditingController.clear();
    stepSizeTextEditingController.clear();
    targetPriceMultiplierTextEditingController.clear();

    updateCheckbox = false;
    enableTargetButton = false;
    enableInitialBuyQuantityButton = false;
    enableNumberOfStepsAboveButton = false;
    enableStepSizeButton = false;
    enableTargetPriceMultiplierButton = false;

    targetErrorText = '';
    initialBuyErrorText = '';
    numberOfStepAboveErrorText = '';
    stepSizeErrorText = "";
    targetPriceMultiplierErrorText = "";

    targetValue = 0.0;
    ticker = '';
    tickerId = '';
    tickerPrice = 0.0;
    initialBuyPrice = 0.0;
    priorCashAllocation = 0.0;
    initialBuyQuantityValue = 0;
    buySellQuantityValue = 0;
    numberOfStepsAboveValue = 0;
    stepSizeValue = 0.0;
    numberOfStepsBelow = 0;
    averagePurchasePrice = 0.0;
    cashNeeded = 0.0;
    finalCashAllocation = 0.0;
    initialBuyCash = 0.0;

    stepSizeValue = 0.0;
    targetPriceMultiplierValue = 0.0;

  }

  bool checkforBrokerkerage() {
    int orderSize = int.parse(buySellQuantityValue.toString());
    double stepSize = stepSizeValue;
    double currentPrice = initialBuyPrice;

    double brokerage = findBrokeragePerExeOrder(orderSize, currentPrice);
    final charges = {
      'ST': 0.1, // 0.1%
      'Transaction_Charges': {'NSE': 0.00297}, // 0.05%
      'SEBI_Chargers': 0.00001, // 0.0001%
      'GST': 18, // 18%
      'IPFT': 0.0001, // 0.001%
      "Stamp_Duty":0.015, // 0.003%
    };


    final taxes = calculateCharges(
      units: orderSize,
      price: currentPrice,
      charges: charges,
      isBuy: true,
      brokerage: brokerage,
    );

    double totalCharges = brokerage + (taxes["total"] ?? 0.0);
    bool showPopUp = extraCashCheckWithBrokerage(
      orderSize,
      stepSize,
      totalCharges,
    );
    print("Are we going to showPopUp: ${showPopUp}");

    return showPopUp;
  }

  double findBrokeragePerExeOrder(int orderSize, double currentPrice) {
    try {
      double orderExecutionCost = orderSize * currentPrice;
      double calculatedBrokerage = orderExecutionCost * 0.1 / 100;
      if (calculatedBrokerage > 20) {
        return 20;
      } else if (calculatedBrokerage < 2) {
        return 2;
      } else {
        return calculatedBrokerage;
      }
    } catch (error) {
      print("Error in the find Brokerage per exe order: ${error}");
      throw error;
    }
  }

  bool extraCashCheckWithBrokerage(
      int orderSize,
      double stepSize,
      double brokerage,
      ) {
    try {
      bool isBrokerageMoreThan40Percent = false;
      double extraCashPerExeOrder = (orderSize * stepSize) / 2;

      double percentage = (brokerage / extraCashPerExeOrder * 100);

      if (percentage > 40) {
        isBrokerageMoreThan40Percent = true;
      }

      return isBrokerageMoreThan40Percent;
    } catch (error) {
      return false;
      throw error;
    }
  }


  double twoDecimal(double value) {
    return double.parse(value.toStringAsFixed(2));
  }

  Map<String, double> calculateCharges({
    required int units,
    required double price,
    required Map<String, dynamic> charges,
    required bool isBuy,
    double brokerage = 0,
  }) {
    final cost = units * price;

    final stt = twoDecimal((cost * charges['ST']) / 100);
    final transactionCharges = twoDecimal(
      (cost * charges['Transaction_Charges']['NSE']) / 100,
    );
    final sebiCharges = twoDecimal((cost * charges['SEBI_Chargers']) / 100);

    final gstBase =
        ((brokerage + transactionCharges + sebiCharges) * charges['GST']) / 100;
    final extraGst = isBuy ? 0 : (20 * 18) / 100; // GST on DP Charges for sell
    final gst = twoDecimal(gstBase + extraGst);

    final ipft = twoDecimal((cost * charges['IPFT']) / 100);
    final stampOrDpCharges = twoDecimal(
      isBuy ? (cost * charges['Stamp_Duty']) / 100 : 20,
    );

    final total = twoDecimal(
      stt + transactionCharges + sebiCharges + gst + ipft + stampOrDpCharges,
    );
    return {
      'stt': stt,
      'transactionCharges': transactionCharges,
      'sebiCharges': sebiCharges,
      'gst': gst,
      'ipft': ipft,
      'stampOrDpCharges': stampOrDpCharges,
      'total': total,
    };
  }
}
