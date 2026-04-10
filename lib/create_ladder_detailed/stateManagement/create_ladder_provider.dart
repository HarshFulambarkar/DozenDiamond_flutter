import 'dart:convert';
import 'dart:math';

import 'package:dozen_diamond/ZI_Search/models/selected_stock_model.dart';
import 'package:dozen_diamond/create_ladder_detailed/services/rest_api_service.dart';
import 'package:dozen_diamond/create_ladder_detailed/stateManagement/optimal_calculation.dart';
import 'package:dozen_diamond/global/functions/helper.dart';
import 'package:dozen_diamond/global/services/stock_price_listener.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../global/models/http_api_exception.dart';
import '../../global/services/num_formatting.dart';

import '../models/ladder_creation_tickers_response.dart';

import '../models/ladder_creation_screen1.dart';
import '../models/ladder_creation_screen2.dart';
import '../models/ladder_creation_screen3.dart';

import '../models/ladder_creation_screen_bundle.dart';
import '../models/stock_holding_response.dart';
import '../models/stock_recommended_parameters_response.dart';

enum StockValueType {
  targetPrice,
  minimumPrice,
  initialBuyQty,
  cashAllocatedToStock,
  stepSize,
  buySellQty,
  targetPriceMultiplier,
  initialBuyCash,
  actualInitialBuyCash
}

class CreateLadderProvider extends ChangeNotifier {

  String _selectedMode = "";

  String get selectedMode => _selectedMode;

  set selectedMode(String value) {
    _selectedMode = value;
    notifyListeners();
  }

  TextEditingController priorBuyStockPriceTextController = TextEditingController(text: "0");
  TextEditingController priorBuyStockQuantityTextController = TextEditingController(text: "0");

  Map<String, bool> _priorBuyAvailable = {};

  Map<String, bool> get priorBuyAvailable => _priorBuyAvailable;

  set priorBuyAvailable(Map<String, bool> value) {
    _priorBuyAvailable = value;
    notifyListeners();
  }

  Map<String, double> _priorBuyStockQuantity = {};

  Map<String, double> get priorBuyStockQuantity => _priorBuyStockQuantity;

  set priorBuyStockQuantity(Map<String, double> value) {
    _priorBuyStockQuantity = value;
    notifyListeners();
  }

  Map<String, double> _priorBuyStockPrice = {};

  Map<String, double> get priorBuyStockPrice => _priorBuyStockPrice;

  set priorBuyStockPrice(Map<String, double> value) {
    _priorBuyStockPrice = value;
    notifyListeners();
  }

  bool _showLadderIntroToolTip = false;

  bool get showLadderIntroToolTip => _showLadderIntroToolTip;

  set showLadderIntroToolTip(bool value) {
    _showLadderIntroToolTip = value;
    notifyListeners();
  }


  Map<String, bool>  _existingLadderExpandedBool = {};

  Map<String, bool> get existingLadderExpandedBool =>
      _existingLadderExpandedBool;

  set existingLadderExpandedBool(Map<String, bool> value) {
    _existingLadderExpandedBool = value;
    notifyListeners();
  }

  int? _stockSubscribedId;
  String? _subscribedStockPrice;

  List<LadderCreationScreenBundle> _stockLadderParameters = [];

  List<LadderCreationScreen1> _ladderCreationScreen1 = [];
  List<LadderCreationScreen2> _ladderCreationScreen2 = [];
  List<LadderCreationScreen3> _ladderCreationScreen3 = [];

  dynamic Function(dynamic)? tickListener;
  int _index = 0;
  double allocatedCashByIncreasingBuySellQty = 0.0;
  double allocatedCashByDecreasingBuySellQty = 0.0;
  late IO.Socket socket;
  int _finalDefaultBuySellQty = 0;
  double _finalStepSize = 0.0;
  double _finalCashAllocated = 0.0;
  bool _ceilBuySellQty = true;
  bool _limitCashNeeded = false;
  bool _isLimitExceeding = false;
  bool _insufficientCashAllocated = false;

  double? _accountCashForNewLadders;
  double? _accountUnallocatedCash;
  double? _accountExtraCashLeft;
  double? _accountExtraCashGenerated;

  bool _displayFormulaOfInitialBuyCash = false;
  bool _displayFormulaOfInitialBuyQuantity = false;
  bool _displayFormulaOfOrderSize = false;
  bool _displayFormulaOfCashNeeded = false;

  OptimalLadderCalculation? optimalLadderCalculation;
  double? _sumOfAssignedCashForLadder;


String _apiErrorMessage = '';

String get apiErrorMessage => _apiErrorMessage;
  set apiErrorMessage(String value) {
    _apiErrorMessage = value;
    notifyListeners();
  }
  Map<int, TextEditingController> _cashAllocatedControllerList = {};

  Map<int, TextEditingController> get cashAllocatedControllerList =>
      _cashAllocatedControllerList;

  set cashAllocatedControllerList(Map<int, TextEditingController> value) {
    _cashAllocatedControllerList = value;
  }

  List<TextEditingController> _cashAllocatedControllerListOld = [];

  List<TextEditingController> get cashAllocatedControllerListOld =>
      _cashAllocatedControllerListOld;

  List<LadderCreationScreen1> get ladderCreationScreen1 =>
      _ladderCreationScreen1;
  List<LadderCreationScreen2> get ladderCreationScreen2 =>
      _ladderCreationScreen2;
  List<LadderCreationScreen3> get ladderCreationScreen3 =>
      _ladderCreationScreen3;

  List<LadderCreationScreenBundle> get stockLadderParameters =>
      _stockLadderParameters;

  int? get stockSubscribedId => _stockSubscribedId;
  String? get subscribedStockPrice => _subscribedStockPrice;

  double? get accountCashForNewLadders => _accountCashForNewLadders;
  double? get accountUnallocatedCash => _accountUnallocatedCash;
  double? get accountExtraCashLeft => _accountExtraCashLeft;
  double? get accountExtraCashGenerated => _accountExtraCashGenerated;

  // Setting the index
  int get index => _index;
  // Parameters to be passed while creating ladder
  bool get isLimitExceeding => _isLimitExceeding;
  double get finalStepSize => _finalStepSize;
  double get finalAllocatedCash => _finalCashAllocated;
  int get finalDefaultBuySellQty => _finalDefaultBuySellQty;
  bool get ceilBuySellQty => _ceilBuySellQty;
  bool get limitCashNeeded => _limitCashNeeded;
  bool get insufficientCashAllocated => _insufficientCashAllocated;

  bool get displayFormulaOfInitialBuyCash => _displayFormulaOfInitialBuyCash;

  bool get displayFormulaOfInitialBuyQuantity =>
      _displayFormulaOfInitialBuyQuantity;

  bool get displayFormulaOfOrderSize => _displayFormulaOfOrderSize;

  bool get displayFormulaOfCashNeeded => _displayFormulaOfCashNeeded;
  Map<String, bool> _isRecommendedParametersEnabledScreen1 = {};
  Map<String, bool> get isRecommendedParametersEnabledScreen1 =>
      _isRecommendedParametersEnabledScreen1;

  set isRecommendedParametersEnabledScreen1(Map<String, bool> value) {

    _isRecommendedParametersEnabledScreen1 = value;
    notifyListeners();
    print("before calling recommended param");
    updateRecommendedParameter();

    // getUserStockAndLadder();

  }

  Map<String, bool> _isRecommendedParametersEnabledScreen3 = {};
  Map<String, bool> get isRecommendedParametersEnabledScreen3 =>
      _isRecommendedParametersEnabledScreen3;

  set isRecommendedParametersEnabledScreen3(Map<String, bool> value) {
    _isRecommendedParametersEnabledScreen3 = value;
    notifyListeners();
  }

  Map<String, bool> _recommendedParametersNotAvailable = {};
  Map<String, bool> get recommendedParametersNotAvailable =>
      _recommendedParametersNotAvailable;
  set recommendedParametersNotAvailable(Map<String, bool> value) {
    _recommendedParametersNotAvailable = value;
    notifyListeners();
  }

  set displayFormulaOfInitialBuyCash(bool value) {
    _displayFormulaOfInitialBuyCash = value;
    notifyListeners();
  }

  set displayFormulaOfInitialBuyQuantity(bool value) {
    _displayFormulaOfInitialBuyQuantity = value;
    notifyListeners();
  }

  set displayFormulaOfOrderSize(bool value) {
    _displayFormulaOfOrderSize = value;
    notifyListeners();
  }

  set displayFormulaOfCashNeeded(bool value) {
    _displayFormulaOfCashNeeded = value;
    notifyListeners();
  }

  double? get sumOfAssignedCashForLadder => _sumOfAssignedCashForLadder;

  LadderCreationScreen1 get ladderCreationParametersScreen1 =>
      _ladderCreationScreen1[index];

  LadderCreationScreen2 get ladderCreationParametersScreen2 =>
      _ladderCreationScreen2[index];

  LadderCreationScreen3 get ladderCreationParametersScreen3 =>
      _ladderCreationScreen3[index];

  String get stockSymSecurityId =>
      ladderCreationParametersScreen1.clpTicker ?? "N/A";

  double get initialBuyPrice =>
      double.tryParse(ladderCreationParametersScreen1
          .clpInitialPurchasePrice!.text
          .replaceAll(',', '')) ??
      0.0;

  double get targetPriceMultiplier =>
      double.tryParse(
          ladderCreationParametersScreen1.targetPriceMultiplier[ladderCreationParametersScreen1.clpTicker ?? ""]!.text) ??
      0.0;

  double get targetPrice =>
      double.tryParse(ladderCreationParametersScreen1.clpTargetPrice!.text
          .replaceAll(',', '')) ??
      0.0;

  double get minimumPrice =>
      double.tryParse(ladderCreationParametersScreen1.clpMinimumPrice!.text
          .replaceAll(',', '')) ??
      0.0;

  double get cashAllocated =>
      double.tryParse(ladderCreationParametersScreen2.clpCashAllocated!.text
          .replaceAll(',', '')) ??
      0.0;

  double get estInitialBuyCash =>
      double.tryParse(ladderCreationParametersScreen2.initialBuyCash!.text
          .replaceAll(',', '')) ??
      0.0;

  int get initialBuyQty =>
      int.tryParse(ladderCreationParametersScreen2.clpInitialBuyQuantity!.text
          .replaceAll(',', '')) ??
      0;

  double get actualInitialBuyCash =>
      double.tryParse(ladderCreationParametersScreen2.actualInitialBuyCash!.text
          .replaceAll(',', '')) ??
      0.0;

  double get numberOfStepsAbove =>
      double.tryParse(ladderCreationParametersScreen3.numberOfStepsAbove!.text
          .replaceAll(',', '')) ??
      0.0;

  double get stepSize =>
      double.tryParse(ladderCreationParametersScreen3.clpStepSize!.text
          .replaceAll(',', '')) ??
      0.0;

  int get numberOfStepsBelow =>
      ladderCreationParametersScreen3.numberOfStepsBelow ?? 0;

  int get buySellQty =>
      int.tryParse(ladderCreationParametersScreen3
          .clpDefaultBuySellQuantity!.text
          .replaceAll(',', '')) ??
      0;

  double get cashNeeded => ladderCreationParametersScreen3.cashNeeded ?? 0.0;

  double get calculatedNumberOfStepsAbove =>
      ladderCreationParametersScreen3.calculatedNumberOfStepsAbove ?? 0;

  double get calculatedStepSize =>
      ladderCreationParametersScreen3.calculatedStepSize ?? 0.0;

  double get cashLeft => ladderCreationParametersScreen3.cashLeft ?? 0.0;

  double get actualCashAllocated =>
      ladderCreationParametersScreen3.actualCashAllocated ?? 0.0;

  TextEditingController get initialBuyPriceController =>
      ladderCreationParametersScreen1.clpInitialPurchasePrice!;

  Map<String, TextEditingController?> get targetPriceMultiplierController =>
      ladderCreationParametersScreen1.targetPriceMultiplier; //[ladderCreationParametersScreen1.clpTicker ?? ""]!;

  TextEditingController get targetPriceController =>
      ladderCreationParametersScreen1.clpTargetPrice!;

  TextEditingController get minimumPriceController =>
      ladderCreationParametersScreen1.clpMinimumPrice!;

  TextEditingController get cashAllocatedController =>
      ladderCreationParametersScreen2.clpCashAllocated!;

  TextEditingController get initialBuyCashController =>
      ladderCreationParametersScreen2.initialBuyCash!;

  TextEditingController get initialBuyQtyController =>
      ladderCreationParametersScreen2.clpInitialBuyQuantity!;

  TextEditingController get actualInitialBuyCashController =>
      ladderCreationParametersScreen2.actualInitialBuyCash!;

  TextEditingController get numberOfStepsAboveController =>
      ladderCreationParametersScreen3.numberOfStepsAbove!;

  TextEditingController get stepSizeController =>
      ladderCreationParametersScreen3.clpStepSize!;

  TextEditingController get buySellQtyController =>
      ladderCreationParametersScreen3.clpDefaultBuySellQuantity!;

  double get k {
    if (_index >= 0 &&
        _ladderCreationScreen1.isNotEmpty &&
        targetPrice > 0 &&
        initialBuyPrice > 0) {
      return targetPrice / initialBuyPrice;
    }
    return 0;
  }

  double get k1 {
    if (k > 0 && _ladderCreationScreen1.isNotEmpty) {
      return (2 * k - 2);
    }
    return 0;
  }

  double get k2 {
    if (k > 0 && _ladderCreationScreen1.isNotEmpty) {
      return (2 * k - 1);
    }
    return 0;
  }

  String _targetPriceWarning = "";
  String _minimumPriceWarning = "";
  String _stepSizeWarning = "";
  String _cashAllocatedWarning = "";
  String _initialBuyQtyWarning = "";
  String _buySellQtyWarning = "";
  String _numberOfStepsAboveWarning = "";
  String _initialBuyCashWarning = "";

  String get targetPriceWarning => _targetPriceWarning;
  String get minimumPriceWarning => _minimumPriceWarning;
  String get stepSizeWarning => _stepSizeWarning;
  String get cashAllocatedWarning => _cashAllocatedWarning;
  String get initialBuyQtyWarning => _initialBuyQtyWarning;
  String get buySellQtyWarning => _buySellQtyWarning;
  String get numberOfStepsAboveWarning => _numberOfStepsAboveWarning;
  String get initialBuyCashWarning => _initialBuyCashWarning;

  set updateSumOfAssignedCashForLadder(double sumOfAssignedCashForLadderBunch) {
    _sumOfAssignedCashForLadder = sumOfAssignedCashForLadderBunch;
    notifyListeners();
  }

  set updateTargetPriceWarning(String warningMessage) {
    _targetPriceWarning = warningMessage;
    notifyListeners();
  }

  set updateStepsizeWarning(String warningMessage) {
    _stepSizeWarning = warningMessage;
    notifyListeners();
  }

  set numberOfStepsAboveWarning(String warningMessage) {
    _numberOfStepsAboveWarning = warningMessage;
    notifyListeners();
  }

  set updateCashAllocatedWarning(String warningMessage) {
    _cashAllocatedWarning = warningMessage;
    notifyListeners();
  }

  set updateInitialBuyQtyWarning(String warningMessage) {
    _initialBuyQtyWarning = warningMessage;
    notifyListeners();
  }

  set updateBuySellQtyWarning(String warningMessage) {
    _buySellQtyWarning = warningMessage;
    notifyListeners();
  }

  set updateMinimumPriceWarning(String warningMessage) {
    _minimumPriceWarning = warningMessage;
    notifyListeners();
  }

  set updateStockSubscribedId(int? stockId) {
    _stockSubscribedId = stockId;
  }

  set isLimitExceeding(bool isLimitExceedingBunch) {
    _isLimitExceeding = isLimitExceedingBunch;
    notifyListeners();
  }

  set updateSubscribedStockPrice(String? newStockPrice) {
    _subscribedStockPrice = newStockPrice;
  }

  set index(int indexBunch) {
    _index = indexBunch;
  }

  double _priorBuyInitialBuyQuantity = 0;

  double get priorBuyInitialBuyQuantity => _priorBuyInitialBuyQuantity;

  set priorBuyInitialBuyQuantity(double value) {
    _priorBuyInitialBuyQuantity = value;
    notifyListeners();
  }

  double _priorBuyInitialPurchasePrice = 0;

  double get priorBuyInitialPurchasePrice => _priorBuyInitialPurchasePrice;

  set priorBuyInitialPurchasePrice(double value) {
    _priorBuyInitialPurchasePrice = value;
    notifyListeners();
  }

  double _priorBuyRateOfSell = 0;

  double get priorBuyRateOfSell => _priorBuyRateOfSell;

  set priorBuyRateOfSell(double value) {
    _priorBuyRateOfSell = value;
    notifyListeners();
  }

  double _priorBuyXDash = 0;

  double get priorBuyXDash => _priorBuyXDash;

  set priorBuyXDash(double value) {
    _priorBuyXDash = value;
    notifyListeners();
  }

  set updateCeilingBuySellQtyBool(bool ceil) {
    _ceilBuySellQty = ceil;
    updateLimitCashNeeded(false);
    _calculateBuySellQty(usingScreen2Parameters: true);

    _calculateInitialBuyQty(forLimitCash: true);
    _calculateCashNeeded();
    _calculateCashLeft(40);
    _calculateActualCashAllocated();
    notifyListeners();
  }

  set numberOfStepsAbove(double value) {
    _ladderCreationScreen3[index].numberOfStepsAbove =
        TextEditingController(text: value.toString());
    notifyListeners();
  }

  set insufficientCashAllocated(bool value) {
    _insufficientCashAllocated = value;
    notifyListeners();
  }

  List<StockRecommendedParametersData> _stockRecommendedParametersDataList = [];

  List<StockRecommendedParametersData> get stockRecommendedParametersDataList =>
      _stockRecommendedParametersDataList;

  set stockRecommendedParametersDataList(
      List<StockRecommendedParametersData> value) {
    _stockRecommendedParametersDataList = value;
  }

  Map<String, StockRecommendedParametersData> _stockRecommendedParametersData = Map();

  Map<String, StockRecommendedParametersData>
      get stockRecommendedParametersData => _stockRecommendedParametersData;

  set stockRecommendedParametersData(
      Map<String, StockRecommendedParametersData> value) {
    _stockRecommendedParametersData = value;
    notifyListeners();
  }

  void updateTargetPrice(
      String stringTargetPrice, String stringAfterDecimal, int cursorOffset) {
    String stringCompleteTargetPrice = stringTargetPrice + stringAfterDecimal;
    double? givenTargetPrice = double.tryParse(stringCompleteTargetPrice);
    double? parsedTargetPrice = double.tryParse(stringTargetPrice);
    double recommendedMultipler = double.tryParse(
            // stockRecommendedParametersData[index].targetPriceMultipler ?? "") ??
            stockRecommendedParametersData[ladderCreationParametersScreen1.clpTicker ?? ""]?.targetPriceMultipler ?? "") ??
        0;
    if (givenTargetPrice == (recommendedMultipler * initialBuyPrice)) {
      _isRecommendedParametersEnabledScreen1[ladderCreationParametersScreen1.clpTicker ?? ""] = true;
    } else {
      _isRecommendedParametersEnabledScreen1[ladderCreationParametersScreen1.clpTicker ?? ""] = false;
    }
    if (parsedTargetPrice != null &&
        parsedTargetPrice < initialBuyPrice * 1.18) {
      updateTargetPriceWarning =
          "*Target price can't be smaller than 1.18 times initial buy Price";
    } else if (parsedTargetPrice != null &&
        parsedTargetPrice > initialBuyPrice * 50) {
      updateTargetPriceWarning =
          "*Target price can't be greater than 50 times the initial buy price";
    } else {
      updateTargetPriceWarning = "";
    }
    updateCurrentStockValues(
      valueType: StockValueType.targetPrice,
      value: stringTargetPrice,
      valueAfterDecimal: stringAfterDecimal,
      cursorOffset: cursorOffset,
    );
    _calculateTargetPriceMultiplier();
    _calculateEstInitialBuyCash();
    _calculateInitialBuyQty();
    _calculateActualInitialBuyCash();

    _calculateBuySellQty(defaultValCalculations: true);
    _calculateStepSize();
    notifyListeners();

    if(selectedMode == "Prior Buy") {
      final result = priorBuyCalculation(
        R: double.tryParse(ladderCreationScreen3[index].clpStepSize!.text) ?? 0, // 1.324,
        P1: double.tryParse(priorBuyStockPriceTextController.text) ?? 0,
        P2: double.tryParse(ladderCreationParametersScreen1.currentPrice ?? "0") ?? 0,
        T: targetPrice, // double.tryParse(_stateProvider!.targetPriceController.text) ?? 0,
        C: double.tryParse(cashAllocatedControllerList[ladderCreationParametersScreen1.clpTickerId]!.text.replaceAll(",", "")) ?? 0.0,
        S1: double.tryParse(priorBuyStockQuantityTextController.text) ?? 0,
      );

      print('x (Stocks to buy at P2): ${result['x']}');
      print('P (Average Price): ${result['P']}');
      print('R (Rate of sell): ${result['R']}');
      print('Final Value: ${result['finalValue']}');
      notifyListeners();
    }



  }

  void updateMinimumPrice(
      String stringMinimumPrice, String stringAfterDecimal, int cursorOffset) {
    double? parsedMinimumPrice = double.tryParse(stringMinimumPrice);

    if (parsedMinimumPrice != null && parsedMinimumPrice > initialBuyPrice) {
      updateMinimumPriceWarning =
          "*Minimum price can't be greater than initial buy price";
    } else if (parsedMinimumPrice != null && parsedMinimumPrice < 0) {
      updateMinimumPriceWarning = "*Minimum price can't be less than zero";
    } else {
      updateMinimumPriceWarning = "";
    }
    updateCurrentStockValues(
        valueType: StockValueType.minimumPrice,
        valueAfterDecimal: stringAfterDecimal,
        value: stringMinimumPrice,
        cursorOffset: cursorOffset);

    notifyListeners();
  }

  void updateLimitCashNeeded(bool limitCashNeeded) {
    _limitCashNeeded = limitCashNeeded;
    int numberOfStepsAboveTemp =
        int.tryParse(_ladderCreationScreen3[index].numberOfStepsAbove!.text) ??
            0;
    if (limitCashNeeded) {
      if (cashLeft > cashNeeded) {
        while (true) {
          print(
              "cashLeft>cashNeeded\nnumber of steps above in while loop when the cashLeft>cashNeeded $numberOfStepsAboveTemp");
          numberOfStepsAboveTemp++;

          updateNumberOfStepsAbove(numberOfStepsAboveTemp.toString(), 0);

          _calculateInitialBuyQty(forLimitCash: true);

          _calculateStepSize(byUsingNumberOfStepsAbove: true);

          _calculateNumberOfStepsBelow();

          _calculateCashLeft(numberOfStepsAboveTemp.toDouble());

          _calculateCashNeeded();

          if (cashNeeded > cashLeft) {
            numberOfStepsAboveTemp--;
            print(
                "cashLeft>cashNeeded\nnow finally we have made it $numberOfStepsAboveTemp");
            updateNumberOfStepsAbove(numberOfStepsAboveTemp.toString(), 0);

            // double defBuySellQtyInitialBuyQty = (double.tryParse(
            //         _ladderCreationScreen3[index]
            //             .clpDefaultBuySellQuantity!
            //             .text) ??
            //     0.0);
            // _ladderCreationScreen2[index].clpInitialBuyQuantity!.text =
            //     intToUnits((defBuySellQtyInitialBuyQty * numberOfStepsAboveTemp)
            //         .floor());
            _calculateInitialBuyQty(forLimitCash: true);

            _calculateStepSize(byUsingNumberOfStepsAbove: true);

            _calculateNumberOfStepsBelow();

            _calculateCashLeft(numberOfStepsAboveTemp.toDouble());

            _calculateCashNeeded();

            _calculateInitialBuyQty(forLimitCash: true);

            break;
          }
        }
      } else {
        while (true) {
          print(
              "cashLeft<cashNeeded\nnumber of steps above in while loop when the cashNeeded>cashLeft $numberOfStepsAboveTemp");
          if (cashLeft >= cashNeeded) {
            _ladderCreationScreen3[index].numberOfStepsAbove!.text =
                intToUnits(numberOfStepsAboveTemp);

            // double defBuySellQtyInitialBuyQty = (double.tryParse(
            //         _ladderCreationScreen3[index]
            //             .clpDefaultBuySellQuantity!
            //             .text) ??
            //     0.0);
            // _ladderCreationScreen2[index].clpInitialBuyQuantity!.text =
            //     intToUnits((defBuySellQtyInitialBuyQty * numberOfStepsAboveTemp)
            //         .floor());

            _calculateInitialBuyQty(forLimitCash: true);
            _ladderCreationScreen3[index].cashLeft =
                _ladderCreationScreen3[index].cashNeeded;

            _calculateStepSize(byUsingNumberOfStepsAbove: true);

            _calculateInitialBuyQty(forLimitCash: true);
            break;
          }
          numberOfStepsAboveTemp--;
          numberOfStepsAbove = numberOfStepsAboveTemp.toDouble();
          _calculateStepSize(byUsingNumberOfStepsAbove: true);
          _calculateInitialBuyQty();
          _calculateActualInitialBuyCash();
          _calculateNumberOfStepsBelow();
          _calculateCashNeeded();
          _calculateCashLeft(numberOfStepsAboveTemp.toDouble());
        }
      }
    } else {
      numberOfStepsAbove = 40;
      _ladderCreationScreen3[index].numberOfStepsAbove!.text =
          numberOfStepsAbove.toString();
      // intToUnits(numberOfStepsAbove);
      _calculateStepSize(byUsingNumberOfStepsAbove: true);
      print("here is your initialBuyPrice: $initialBuyPrice and $stepSize");
      _calculateCashLeft(numberOfStepsAbove);
      _calculateCashNeeded();

      _calculateInitialBuyQty(forLimitCash: true);
    }
    _calculateActualCashAllocated();
    print(
        "here is the initialBuyQuantity ${_ladderCreationScreen2[index].clpInitialBuyQuantity!.text}");
    notifyListeners();
  }

  void calculateOptimalParameters({double numberOfStepsAboveTemp = 0.0}) {
    print("hello 1");
    optimalLadderCalculation = OptimalLadderCalculation(
        initialBuyQuantityValue: (int.tryParse((_ladderCreationScreen2[index]
                .clpInitialBuyQuantity!
                .text
                .replaceAll(",", ""))
            .split(".")[0])),
        initialBuyPrice: initialBuyPrice,
        numberOfStepsAboveValue: numberOfStepsAboveTemp == 0.0
            ? (numberOfStepsAbove.toDouble())
            : numberOfStepsAboveTemp,
        targetValue: targetPrice,
        priorCashAllocation: cashAllocated,
        tickerPrice: initialBuyPrice,
        selectedMode: selectedMode,
        priorBuyInitialPurchasePrice: priorBuyInitialPurchasePrice
    );

    print("initialBuyPrice: $initialBuyPrice");
    print("numberOfStepsAboveValue: $numberOfStepsAbove");
    print("targetValue: $targetPrice");
    print("priorCashAllocation: $index  ${cashAllocated}");
    print("tickerPrice: $initialBuyPrice");
    print("hello 2");
    Map<String, dynamic> listOfItems =
        optimalLadderCalculation!.calculateLadderParameter();
    _ladderCreationScreen3[index].calculatedNumberOfStepsAbove =
        listOfItems['numberOfStepsAbove'];
    _ladderCreationScreen3[index].numberOfStepsBelow =
        listOfItems['numberOfStepsBelow'];
    _ladderCreationScreen3[index].clpDefaultBuySellQuantity!.text =
        intToUnits(listOfItems['buySellQuantityValue']);
    print("hello 4");
    _ladderCreationScreen3[index].clpInitialBuyQuantity!.text =
        intToUnits(listOfItems['initialBuyQuantityValue']);
    print("hello 5");
    _ladderCreationScreen3[index].calculatedStepSize =
        listOfItems['stepSizeValue'];
    print("hello 6");
    _ladderCreationScreen3[index].cashNeeded = listOfItems['cashNeeded'];
    print("hello 7 ${_ladderCreationScreen3[index].cashNeeded}");
    _ladderCreationScreen3[index].cashLeft = listOfItems['cashLeft'];
    print("hello 8");
    _ladderCreationScreen3[index].actualCashAllocated =
        listOfItems['finalCashAllocation'];
    print("hello 9");
  }

  Future<void> saveStocksOrder() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ids = _ladderCreationScreen1
          .map((e) => e.clpTickerId.toString())
          .toList();

      await prefs.setStringList("clp_order", ids);

      // Prepare data for backend
      List<int> reorderedList = [];
      for (int i = 0; i < _ladderCreationScreen1.length; i++) {
        reorderedList.add(_ladderCreationScreen1[i].clpTickerId!);
      }

      Map<String, dynamic> request = {'reordered_stocks_ids': reorderedList};

      // // Send to backend
      await RestApiService().reorderStockListOrder(request);

      notifyListeners();
    } catch (e) {
      print("Error saving stock order: $e");
      throw e;
    }
  }

  Future<void> restoreLocalOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final savedOrder = prefs.getStringList("clp_order");
    if (savedOrder == null) return; // nothing saved yet

    final list = _ladderCreationScreen1;

    list.sort((a, b) {
      return savedOrder
          .indexOf(a.clpTickerId.toString())
          .compareTo(savedOrder.indexOf(b.clpTickerId.toString()));
    });
  }

  void reorderStocksInList(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      --newIndex;
    }
    // LadderCreationScreenBundle item = _stockLadderParameters.removeAt(oldIndex);
    // _stockLadderParameters.insert(newIndex, item);
    print("newIndex $newIndex and oldIndex $oldIndex");
    LadderCreationScreen1 item1 = _ladderCreationScreen1.removeAt(oldIndex);
    print("newIndex ${item1.clpTicker}");
    _ladderCreationScreen1.insert(newIndex, item1);
    print("newIndex ladderCreation1 ${_ladderCreationScreen1[0].clpTicker}");

    LadderCreationScreen2 item2 = _ladderCreationScreen2.removeAt(oldIndex);
    _ladderCreationScreen2.insert(newIndex, item2);

    LadderCreationScreen3 item3 = _ladderCreationScreen3.removeAt(oldIndex);
    _ladderCreationScreen3.insert(newIndex, item3);

    TextEditingController itemCashAllocated =
        _cashAllocatedControllerListOld.removeAt(oldIndex);
    _cashAllocatedControllerListOld.insert(newIndex, itemCashAllocated);

    // cashAllocatedControllerList[item1.clpTickerId!] = _ladderCreationScreen2[oldIndex].clpCashAllocated!;

    saveStocksOrder();

    // new code start here

    double targetPriceMultiplier;

    if(stockRecommendedParametersData[ladderCreationParametersScreen1.clpTicker ?? ""] != null) {
      recommendedParametersNotAvailable[ladderCreationParametersScreen1.clpTicker ?? ""] = false;
      _isRecommendedParametersEnabledScreen1[ladderCreationParametersScreen1.clpTicker ?? ""] = true;
      // _isRecommendedParametersEnabledScreen3 = true;
      targetPriceMultiplier = double.tryParse(
          stockRecommendedParametersData[ladderCreationParametersScreen1.clpTicker ?? ""]?.targetPriceMultipler ??
              "") ??
          0.0;

      // new code starts from here
      ladderCreationParametersScreen1.targetPriceMultiplier[ladderCreationParametersScreen1.clpTicker ?? ""]!.text = targetPriceMultiplier.toString();
      updateTargetPriceMultiplier(
        ladderCreationParametersScreen1
            .targetPriceMultiplier[ladderCreationParametersScreen1.clpTicker ?? ""]!.text,
        ladderCreationParametersScreen1
            .targetPriceMultiplier[ladderCreationParametersScreen1.clpTicker ?? ""]!.text.length,
      );

      //step size code start here

      // String inputStepSize = stockRecommendedParametersData[ladderCreationParametersScreen1.clpTicker ?? ""]!.stepsSize!.toString();
      //
      // stepSizeController.value = TextEditingValue(
      //   text: inputStepSize.toString(),
      //   selection: TextSelection.fromPosition(TextPosition(
      //       offset: stepSizeController.selection.baseOffset)),
      // );
      //
      // List<String> splittedValues =
      // doublValueSplitterBydot(stepSizeController.text);
      // updateStepSize(
      //   splittedValues[0],
      //   splittedValues[1],
      //   stepSizeController.selection.baseOffset,
      // );
      //
      // if (stepSizeController.text != "" &&
      //     stepSizeController.text != "0") {


      //   numberOfStepsAboveController.text = (calculateFieldNumberOfStepAbove(
      //       double.parse(stepSizeController.text.replaceAll(",", ""))))
      //       .toString();
      // }

      // step size code end here

      // new code end here
    } else {

      _recommendedParametersNotAvailable[ladderCreationParametersScreen1.clpTicker ?? ""] = true;
      _isRecommendedParametersEnabledScreen1[ladderCreationParametersScreen1.clpTicker ?? ""] = false;
      _isRecommendedParametersEnabledScreen3[ladderCreationParametersScreen1.clpTicker ?? ""] = false;
      targetPriceMultiplier = 2;
      ladderCreationParametersScreen1.targetPriceMultiplier[ladderCreationParametersScreen1.clpTicker ?? ""]!.text = targetPriceMultiplier.toString();
      updateTargetPriceMultiplier(
        ladderCreationParametersScreen1
            .targetPriceMultiplier[ladderCreationParametersScreen1.clpTicker ?? ""]!.text,
        ladderCreationParametersScreen1
            .targetPriceMultiplier[ladderCreationParametersScreen1.clpTicker ?? ""]!.text.length,
      );
    }

    // new code end here

    notifyListeners();
  }

  void updateInitialBuyQuantity(String? stringInitialBuyQty, int cursorOffset) {
    String? processedInitialBuyQty = stringInitialBuyQty;
    int parsedInitialBuyQty = int.tryParse(stringInitialBuyQty ?? "0") ?? 0;
    int recommendedIBQ = (estInitialBuyCash / initialBuyPrice).floor();
    if (parsedInitialBuyQty > recommendedIBQ) {
      updateInitialBuyQtyWarning =
          "Entered Initial buy qty exceeding recommended initial buy qty, Either increase cash allocation or initial buy cash";
    } else {
      updateInitialBuyQtyWarning = "";
    }
    updateCurrentStockValues(
      valueType: StockValueType.initialBuyQty,
      value: processedInitialBuyQty,
      cursorOffset: cursorOffset,
    );
    _calculateBuySellQty(defaultValCalculations: true);
    _calculateStepSize();
    _calculateActualInitialBuyCash();
    _calculateNumberOfStepsAbove();
    _calculateNumberOfStepsBelow();
    _calculateCashNeeded();
    _calculateCashLeft(double.tryParse(
            _ladderCreationScreen3[index].numberOfStepsAbove?.text ?? "0") ??
        0);

    notifyListeners();
  }

  void updateInitialBuyQuantityEvenly() {
    _calculateInitialBuyQty(forLimitCash: true);
    _calculateActualCashAllocated();
    _limitCashNeeded = false;
  }

  void updateNumberOfStepsAbove(
      String? stringNumberOfStepsAbove, int cursorOffset) {
    double parsedNumberOfStepsAbove =
        double.tryParse(stringNumberOfStepsAbove ?? "") ?? 0;

    print("parse number of setps above");
    print(parsedNumberOfStepsAbove);
    optimalLadderCalculation = OptimalLadderCalculation(
        initialBuyQuantityValue: int.tryParse((_ladderCreationScreen3[index]
                .clpInitialBuyQuantity!
                .text
                .replaceAll(",", ""))
            .split(".")[0]),
        initialBuyPrice: initialBuyPrice,
        numberOfStepsAboveValue:
            double.parse(stringNumberOfStepsAbove ?? "0.0"),
        targetValue: targetPrice,
        priorCashAllocation: cashAllocated,
        tickerPrice: initialBuyPrice,
        selectedMode: selectedMode,
        priorBuyInitialPurchasePrice: priorBuyInitialPurchasePrice
    );
    print("hello 0");
    Map<String, dynamic> listOfItems =
        optimalLadderCalculation!.calculateLadderParameter();
    print(listOfItems['numberOfStepsAbove']);
    _ladderCreationScreen3[index].numberOfStepsAbove!.text =
        stringNumberOfStepsAbove.toString();
    // intToUnits(parsedNumberOfStepsAbove);
    _ladderCreationScreen3[index].numberOfStepsAbove!.selection =
        TextSelection(baseOffset: cursorOffset, extentOffset: cursorOffset);
    _ladderCreationScreen3[index].calculatedNumberOfStepsAbove =
        (listOfItems['numberOfStepsAbove']);
    _ladderCreationScreen3[index].numberOfStepsBelow =
        listOfItems['numberOfStepsBelow'];
    _ladderCreationScreen3[index].clpDefaultBuySellQuantity!.text =
        intToUnits(listOfItems['buySellQuantityValue']);
    print("hello 4");
    _ladderCreationScreen3[index].clpInitialBuyQuantity!.text =
        intToUnits(listOfItems['initialBuyQuantityValue']);
    print("hello 5");
    _ladderCreationScreen3[index].calculatedStepSize =
        listOfItems['stepSizeValue'];
    print("hello 6");
    _ladderCreationScreen3[index].cashNeeded = listOfItems['cashNeeded'];
    print("hello 7 ${_ladderCreationScreen3[index].cashNeeded}");
    _ladderCreationScreen3[index].cashLeft = listOfItems['cashLeft'];
    print("hello 8");
    _ladderCreationScreen3[index].actualCashAllocated =
        listOfItems['finalCashAllocation'];
    print("hello 9");

    notifyListeners();
  }

  void updateTargetPriceMultiplier(
      String? stringTargetPriceMultiplier, int cursorOffset) {
    // if (stockRecommendedParametersData[ladderCreationParametersScreen1.clpTicker ?? ""]?.targetPriceMultipler ==
    //     stringTargetPriceMultiplier) {
    //   // _isRecommendedParametersEnabledScreen1 = true;
    // } else {
    //   // _isRecommendedParametersEnabledScreen1 = false;
    // }
    String? processedTargetPriceMultiplier = stringTargetPriceMultiplier;
    double parsedTargetPriceMultiplier =
        double.tryParse(stringTargetPriceMultiplier ?? "0") ?? 0;
    if (parsedTargetPriceMultiplier <= 1.1) {
    } else {}
    updateCurrentStockValues(
      valueType: StockValueType.targetPriceMultiplier,
      value: processedTargetPriceMultiplier,
      cursorOffset: cursorOffset,
    );
    _calculateTargetPrice();
    _calculateInitialBuyQty();
    _calculateEstInitialBuyCash();
    _calculateActualInitialBuyCash();
    notifyListeners();

    if(selectedMode == "Prior Buy") {
      final result = priorBuyCalculation(
        R: double.tryParse(ladderCreationScreen3[index].clpStepSize!.text) ?? 0, // 1.324,
        P1: double.tryParse(priorBuyStockPriceTextController.text) ?? 0,
        P2: double.tryParse(ladderCreationParametersScreen1.currentPrice ?? "0") ?? 0,
        T: targetPrice, // double.tryParse(_stateProvider!.targetPriceController.text) ?? 0,
        C: double.tryParse(cashAllocatedControllerList[ladderCreationParametersScreen1.clpTickerId]!.text.replaceAll(",", "")) ?? 0.0,
        S1: double.tryParse(priorBuyStockQuantityTextController.text) ?? 0,
      );

      print('x (Stocks to buy at P2): ${result['x']}');
      print('P (Average Price): ${result['P']}');
      print('R (Rate of sell): ${result['R']}');
      print('Final Value: ${result['finalValue']}');
      notifyListeners();
    }

  }

  void updateCashAllocated(String? stringCashAllocated,
      String? stringAfterDecimal, int cursorOffset) {
    double parsedCashAllocated =
        double.tryParse(stringCashAllocated ?? "0.0") ?? 0.0;
    if (parsedCashAllocated != 0.0) {
      updateCurrentStockValues(
        valueType: StockValueType.cashAllocatedToStock,
        value: stringCashAllocated!,
        valueAfterDecimal: stringAfterDecimal!,
        cursorOffset: cursorOffset,
      );
      _calculateInitialBuyQty();
      _calculateEstInitialBuyCash();
      _calculateActualInitialBuyCash();
      _calculateBuySellQty(defaultValCalculations: true);
      _calculateStepSize();
      if (cashAllocated >= initialBuyPrice && initialBuyQty >= 1) {
        updateCashAllocatedWarning = "";
      } else {
        updateCashAllocatedWarning =
            "Please enter valid cash amount for ladder creation";
      }
    } else {
      updateCashAllocatedWarning =
          "Please enter valid cash amount for ladder creation";
    }

    notifyListeners();
  }

  void updateStepSize(
      String? stringStepsize, String stringAfterDecimal, int cursorOffset) {
    double parsedStepSize = double.tryParse(stringStepsize ?? "0.0") ?? 0.0;
    print("parsedStepSize $stringStepsize");
    if (parsedStepSize != 0.0) {
      updateStepsizeWarning = "";
      print("if statement for parsedStepSize");
      updateCurrentStockValues(
          valueType: StockValueType.stepSize,
          value: stringStepsize!,
          valueAfterDecimal: stringAfterDecimal,
          cursorOffset: cursorOffset);
      _calculateBuySellQty();
      if ((int.tryParse(_ladderCreationScreen3[index]
                      .clpDefaultBuySellQuantity!
                      .text
                      .replaceAll(",", "")) ??
                  0) >
              (int.tryParse(_ladderCreationScreen3[index]
                      .clpInitialBuyQuantity!
                      .text
                      .replaceAll(",", "")) ??
                  0) ||
          (targetPrice - initialBuyPrice) < stepSize) {
        if ((int.tryParse(_ladderCreationScreen3[index]
                    .clpDefaultBuySellQuantity!
                    .text
                    .replaceAll(",", "")) ??
                0) >
            (int.tryParse(_ladderCreationScreen3[index]
                    .clpInitialBuyQuantity!
                    .text
                    .replaceAll(",", "")) ??
                0)) {
          updateBuySellQtyWarning =
              "Buy/Sell quantity exceeding Initial buy quantity";
        } else {
          updateBuySellQtyWarning = "";
        }
        if ((targetPrice - initialBuyPrice) < stepSize) {
          updateStepsizeWarning =
              "Step size is exceeding difference between target price and intial buy price";
        } else {
          updateStepsizeWarning = "";
        }
      } else {
        print(
            "we have a problem $buySellQty and $initialBuyQty and price $initialBuyPrice and $targetPrice");
        optimalLadderCalculation = OptimalLadderCalculation(
            initialBuyQuantityValue: int.tryParse((_ladderCreationScreen3[index]
                    .clpInitialBuyQuantity!
                    .text
                    .replaceAll(",", ""))
                .split(".")[0]),
            initialBuyPrice: initialBuyPrice,
            numberOfStepsAboveValue: (targetPrice - initialBuyPrice) / stepSize,
            targetValue: targetPrice,
            priorCashAllocation: cashAllocated,
            tickerPrice: initialBuyPrice,
            selectedMode: selectedMode,
          priorBuyInitialPurchasePrice: priorBuyInitialPurchasePrice
        );

        Map<String, dynamic> listOfItems =
            optimalLadderCalculation!.calculateLadderParameter();

        _ladderCreationScreen3[index].calculatedNumberOfStepsAbove =
            (listOfItems['numberOfStepsAbove']);
        _ladderCreationScreen3[index].numberOfStepsBelow =
            listOfItems['numberOfStepsBelow'];
        _ladderCreationScreen3[index].clpDefaultBuySellQuantity!.text =
            intToUnits(listOfItems['buySellQuantityValue']);
        print("hello 4");
        _ladderCreationScreen3[index].clpInitialBuyQuantity!.text =
            intToUnits(listOfItems['initialBuyQuantityValue']);
        print("hello 5");
       _ladderCreationScreen3[index].calculatedStepSize =
            listOfItems['stepSizeValue'];
        print("hello 6");
        _ladderCreationScreen3[index].cashNeeded = listOfItems['cashNeeded'];
        print("hello 7 ${_ladderCreationScreen3[index].cashNeeded}");
        _ladderCreationScreen3[index].cashLeft = listOfItems['cashLeft'];
        print("hello 8");
        _ladderCreationScreen3[index].actualCashAllocated =
            listOfItems['finalCashAllocation'];
        print("hello 9");
      }
    } else {
      updateStepsizeWarning = "Please enter valid step size";
    }

    notifyListeners();
  }

  void updateBuySellQty(String? stringBuySellQty, int cursorOffset) {
    int parsedBuySellQty = int.tryParse(stringBuySellQty ?? "0") ?? 0;
    String? processedBuySellQty = stringBuySellQty;
    if (parsedBuySellQty > initialBuyQty) {
      updateBuySellQtyWarning =
          "Buy/Sell quantity exceeding Initial buy quantity";
    } else {
      updateBuySellQtyWarning = "";
    }
    if (parsedBuySellQty <= 0) {
      processedBuySellQty = "1";
    }
    updateCurrentStockValues(
      valueType: StockValueType.buySellQty,
      value: processedBuySellQty!,
      cursorOffset: cursorOffset,
    );
    _calculateStepSize();
    // _calculateNumberOfStepsAbove();
    if ((targetPrice - initialBuyPrice) < stepSize) {
      updateStepsizeWarning =
          "Step size is exceeding difference between target price and intial buy price";
    } else {
      updateStepsizeWarning = "";
    }
    notifyListeners();
  }

  void updateNumberOfStepAboveToInitial() {
    _ladderCreationScreen3[index].numberOfStepsAbove =
        TextEditingController(text: intToUnits(40));
  }

  void updateCurrentStockValues(
      {required StockValueType valueType,
      required String? value,
      String valueAfterDecimal = "",
      int cursorOffset = 1,
      int decimalDigits = 0}) {
    switch (valueType) {
      case StockValueType.initialBuyQty:
        String unitsFormattedInitialBuyQty =
            intToUnits(int.tryParse(value!.split(".")[0]) ?? 0);
        print("below is value");
        print(value);
        _ladderCreationScreen2[index].clpInitialBuyQuantity!.value =
            TextEditingValue(
          text: unitsFormattedInitialBuyQty,
          selection: TextSelection.fromPosition(
            TextPosition(
                offset: (cursorOffset -
                    (_ladderCreationScreen2[_index]
                            .clpInitialBuyQuantity!
                            .text
                            .length -
                        unitsFormattedInitialBuyQty.length)).abs()),
          ),
        );
        break;
      case StockValueType.cashAllocatedToStock:
        String inrFormattedCashAllocated = amountToInrFormatCLP(
                double.tryParse(value ?? "0.0") ?? 0.0,
                decimalDigit: decimalDigits) +
            valueAfterDecimal;
        _ladderCreationScreen2[index].clpCashAllocated!.value =
            TextEditingValue(
          text: inrFormattedCashAllocated,
          selection: TextSelection.fromPosition(
            TextPosition(offset: inrFormattedCashAllocated.length),
          ),
        );
        break;
      case StockValueType.minimumPrice:
        String inrFormattedMinimumPrice = amountToInrFormatCLP(
                double.tryParse(value ?? "0.0") ?? 0.0,
                decimalDigit: decimalDigits) +
            valueAfterDecimal;
        _ladderCreationScreen1[index].clpMinimumPrice!.value = TextEditingValue(
          text: inrFormattedMinimumPrice,
          selection: TextSelection.fromPosition(
            TextPosition(offset: inrFormattedMinimumPrice.length),
          ),
        );
        break;
      case StockValueType.targetPrice:
        String inrFormattedTargetPrice = amountToInrFormatCLP(
                double.tryParse(value ?? "0.0") ?? 0.0,
                decimalDigit: decimalDigits) +
            valueAfterDecimal;
        _ladderCreationScreen1[index].clpTargetPrice!.value = TextEditingValue(
          text: inrFormattedTargetPrice,
          selection: TextSelection.fromPosition(
            TextPosition(offset: inrFormattedTargetPrice.length),
          ),
        );
        break;
      case StockValueType.stepSize:
        String inrFormattedStepSize = amountToInrFormatCLP(
                double.tryParse(value ?? "0.0") ?? 0.0,
                decimalDigit: decimalDigits) +
            valueAfterDecimal;
        _ladderCreationScreen3[index].clpStepSize!.value = TextEditingValue(
          text: inrFormattedStepSize,
          selection: TextSelection.fromPosition(
            TextPosition(offset: inrFormattedStepSize.length),
          ),
        );
        break;
      case StockValueType.buySellQty:
        String unitsFormattedBuySellQty =
            intToUnits(int.tryParse(value ?? "1") ?? 1);
        _ladderCreationScreen3[index].clpDefaultBuySellQuantity!.value =
            TextEditingValue(
          text: unitsFormattedBuySellQty,
          selection: TextSelection.fromPosition(
            TextPosition(
                offset: cursorOffset -
                    (_ladderCreationScreen3[_index]
                            .clpDefaultBuySellQuantity!
                            .text
                            .length -
                        unitsFormattedBuySellQty.length)),
          ),
        );
        break;
      case StockValueType.targetPriceMultiplier:
        _ladderCreationScreen1[index].targetPriceMultiplier[ladderCreationParametersScreen1.clpTicker ?? ""]!.value =
            TextEditingValue(
          text: value ?? "1.1",
          selection: TextSelection.fromPosition(
            TextPosition(offset: cursorOffset),
          ),
        );
        break;
      case StockValueType.initialBuyCash:
        String inrFormattedInitialBuyCash = amountToInrFormatCLP(
                double.tryParse(value ?? "0.0") ?? 0.0,
                decimalDigit: decimalDigits) +
            valueAfterDecimal;
        _ladderCreationScreen2[index].initialBuyCash!.value = TextEditingValue(
          text: inrFormattedInitialBuyCash,
          selection: TextSelection.fromPosition(
            TextPosition(offset: inrFormattedInitialBuyCash.length),
          ),
        );
        break;
      case StockValueType.actualInitialBuyCash:
        String inrFormattedActualInitialBuyCash = amountToInrFormatCLP(
                double.tryParse(value ?? "0.0") ?? 0.0,
                decimalDigit: decimalDigits) +
            valueAfterDecimal;
        _ladderCreationScreen2[index].actualInitialBuyCash!.value =
            TextEditingValue(
          text: inrFormattedActualInitialBuyCash,
          selection: TextSelection.fromPosition(
            TextPosition(offset: inrFormattedActualInitialBuyCash.length),
          ),
        );
        break;
    }
  }

  void _calculateInitialBuyQty({forLimitCash = false}) {
    double defBuySellQtyInitialBuyQty = 0.0;
    if (forLimitCash) {
      defBuySellQtyInitialBuyQty = (double.tryParse(
              _ladderCreationScreen3[index].clpDefaultBuySellQuantity!.text) ??
          0.0);
      _ladderCreationScreen3[index].clpInitialBuyQuantity!.text =
          intToUnits((defBuySellQtyInitialBuyQty * numberOfStepsAbove).floor());

      print(
          "here is the defBuySellQty $defBuySellQtyInitialBuyQty and $numberOfStepsAbove");
    } else {
      if (targetPrice > 0 && targetPrice > initialBuyPrice) {
        _ladderCreationScreen2[index].clpInitialBuyQuantity!.text =
            intToUnits(((cashAllocated / initialBuyPrice) * (k1 / k2)).floor());
        print("breakpoint value4 ${index} :${_ladderCreationScreen2[index].clpInitialBuyQuantity!.text}");
      } else {}
    }
    print(
        "virtual ${defBuySellQtyInitialBuyQty} and $numberOfStepsAbove calculated initialBuyQty ${_ladderCreationScreen2[index].clpInitialBuyQuantity!.text}");
  }

  void _calculateTargetPrice() {
    if (targetPriceMultiplier < 1.18) {
      updateTargetPriceWarning =
          "*Target price can't be smaller than 1.18 times initial buy Price";
    } else if (targetPriceMultiplier > 50) {
      updateTargetPriceWarning =
          "*Target price can't be greater than 50 times the initial buy price";
    } else {
      updateTargetPriceWarning = "";
    }

    _ladderCreationScreen1[index].clpTargetPrice!.text = amountToInrFormatCLP(
        targetPriceMultiplier * initialBuyPrice,
        decimalDigit: 2);
  }

  void _calculateTargetPriceMultiplier() {
    _ladderCreationScreen1[index].targetPriceMultiplier[ladderCreationParametersScreen1.clpTicker ?? ""]!.text =
        (targetPrice / initialBuyPrice).toStringAsFixed(2);
  }

  void _calculateBuySellQty(
      {bool defaultValCalculations = false,
      bool usingScreen2Parameters = false}) {
    double divisor = defaultValCalculations ? 40 : numberOfStepsAbove;

    double calculatedBuySellQty = usingScreen2Parameters
        ? (double.tryParse((_ladderCreationScreen2[index]
                            .clpInitialBuyQuantity
                            ?.text ??
                        '')
                    .replaceAll(",", "")) ??
                0.0) /
            divisor
        : initialBuyQty / divisor;

    int finalBuySellQty = ceilBuySellQty
        ? calculatedBuySellQty.ceil()
        : calculatedBuySellQty.floor();

    if (finalBuySellQty <= 0) {
      finalBuySellQty = 1;
    }

    _ladderCreationScreen3[index].clpDefaultBuySellQuantity!.text =
        intToUnits(finalBuySellQty);

    print("Calculated buySellQty for initialBuyQty: $initialBuyQty, "
        "Initial Quantity screen 2 ${_ladderCreationScreen2[index].clpInitialBuyQuantity!.text} ,"
        "divisor: $divisor, "
        "finalBuySellQty: $finalBuySellQty, "
        "clpDefaultBuySellQuantity: ${_ladderCreationScreen3[index].clpDefaultBuySellQuantity!.text}");
  }

  void _calculateEstInitialBuyCash() {
    double calculatedInitialBuyCash = cashAllocated * (k1 / k2);

    _ladderCreationScreen2[index].initialBuyCash!.text =
        amountToInrFormatCLP(calculatedInitialBuyCash, decimalDigit: 2);
    print(
        "calculated initialBuyCash ${_ladderCreationScreen2[index].initialBuyCash!.text}");
  }

  void _calculateActualInitialBuyCash() {
    double calculatedActualInitialBuyCash = initialBuyQty * initialBuyPrice;
    _ladderCreationScreen2[index].actualInitialBuyCash!.text =
        amountToInrFormatCLP(calculatedActualInitialBuyCash, decimalDigit: 2);
    print(
        "calculated actualInitialBuyCash ${_ladderCreationScreen2[index].actualInitialBuyCash!.text} and ${initialBuyQty} and ${initialBuyPrice}");
  }

  void _calculateStepSize({byUsingNumberOfStepsAbove = false}) {
    if (byUsingNumberOfStepsAbove) {
      print(
          "targetPrice is $targetPrice, and NumberOfStepsAbove is $numberOfStepsAbove");
      double stepSizeTemp =
          (targetPrice - initialBuyPrice) / numberOfStepsAbove;
      stepSizeTemp = (stepSizeTemp * 100).floorToDouble() / 100;
      _ladderCreationScreen3[index].clpStepSize!.text =
          amountToInrFormatCLP((stepSizeTemp), decimalDigit: 2);
    } else {
      print("below are value of else");
      print(targetPrice);
      print(initialBuyPrice);
      print(initialBuyQty);

      if (initialBuyPrice <= 0) {
        // initialBuyPrice = 1;
        ladderCreationParametersScreen1.clpInitialPurchasePrice!.text = '1';
      }

      if (initialBuyQty <= 0) {
        ladderCreationParametersScreen2.clpInitialBuyQuantity!.text = "1";
      }

      print("initialBuyPrice");
      print(initialBuyPrice);
      print(initialBuyQty);
      print(buySellQty);
      double stepSizeTemp =
          (targetPrice - initialBuyPrice) / (initialBuyQty / buySellQty);
      stepSizeTemp = (stepSizeTemp * 100).floorToDouble() / 100;
      _ladderCreationScreen3[index].clpStepSize!.text =
          amountToInrFormatCLP((stepSizeTemp), decimalDigit: 2);
    }
    print(
        "calculated stepSize ${_ladderCreationScreen3[index].clpStepSize!.text}");
    _calculateNumberOfStepsBelow();
  }

  void _calculateNumberOfStepsBelow() {
    int numberOfStepsBelowTemp = (initialBuyPrice / stepSize).floor();
    _ladderCreationScreen3[index].numberOfStepsBelow = numberOfStepsBelowTemp;
    print(
        " calculated numberOfStepsBelow $initialBuyPrice and $targetPrice and $stepSize and $numberOfStepsAbove and ${_ladderCreationScreen3[index].numberOfStepsBelow}");
  }

  void _calculateCashNeeded() {
    print("inside _calculateCashNeeded");
    double orderSize = double.tryParse(
            _ladderCreationScreen3[index].clpDefaultBuySellQuantity!.text) ??
        0.0;
    _ladderCreationScreen3[index].cashNeeded = (orderSize *
        _ladderCreationScreen3[index].numberOfStepsBelow! *
        (initialBuyPrice / 2));
    print(
        "calculated cashNeeded check ${_ladderCreationScreen3[index].cashNeeded} and buysellQty is $orderSize and ${_ladderCreationScreen3[index].numberOfStepsBelow}");
  }

  void _calculateCashLeft(double numberOfStepsAboveTemp) {
    _ladderCreationScreen3[index].cashLeft = (cashAllocated -
        ((buySellQty * numberOfStepsAboveTemp) * initialBuyPrice));
    print("calculated cashLeft ${_ladderCreationScreen3[index].cashLeft}");
  }

  void _calculateNumberOfStepsAbove() {
    _ladderCreationScreen3[index].numberOfStepsAbove = TextEditingController(
        text: intToUnits((initialBuyQty / buySellQty).round()));
    print(
        "calculated numberOfStepsAbove ${initialBuyQty} and ${buySellQty} and ${_ladderCreationScreen3[index].numberOfStepsAbove!.text}");
  }

  void _calculateActualCashAllocated() {
    if(selectedMode == "Prior Buy") {
      // _ladderCreationScreen3[index].actualCashAllocated =
      //   ((buySellQty * numberOfStepsAbove * priorBuyInitialPurchasePrice) + cashNeeded);

      print("inside prior buy");
      print(buySellQty);
      print(numberOfStepsAbove);
      print(initialBuyPrice);
      print(cashNeeded);
      _ladderCreationScreen3[index].actualCashAllocated =
      ((buySellQty * numberOfStepsAbove * initialBuyPrice) + cashNeeded);
    } else {
      _ladderCreationScreen3[index].actualCashAllocated =
        ((buySellQty * numberOfStepsAbove * initialBuyPrice) + cashNeeded);
    }

    print(
        "calculated actualCashAllocated ${_ladderCreationScreen3[index].actualCashAllocated}");
  }

  void addListOfStocksAndLadders(
      List<LadderCreationScreenBundle> ladderCreationBundles) {
    print("inside addListOfStocksAndLadders");
    print(cashAllocatedControllerList!.toString());
    if(_ladderCreationScreen1.isNotEmpty) {

      // Extract IDs from model2List
      Set<int> model2Ids = _ladderCreationScreen1.map((e) => e.clpTickerId!).toSet();

      // Filter model1List to remove items whose subList IDs are not in model2Ids
      ladderCreationBundles.removeWhere((model1) =>
          model1.screen1List.every((sub) => !model2Ids.contains(sub.clpTickerId)));

      updateListOrder1(_ladderCreationScreen1, ladderCreationBundles.expand((bundle) => bundle.screen1List).toList());

      cashAllocatedControllerList.removeWhere((key, value) => !model2Ids.contains(key));

    } else {
      _ladderCreationScreen1 =
          ladderCreationBundles.expand((bundle) => bundle.screen1List).toList();
    }

    if(_ladderCreationScreen2.isNotEmpty) {

      print("below is reordering screen 2 data assign");
      print(index);
      print(_ladderCreationScreen2[index].clpCashAllocated!.text);

      // Extract IDs from model2List
      Set<int> model2Ids = _ladderCreationScreen1.map((e) => e.clpTickerId!).toSet();

      // Filter model1List to remove items whose subList IDs are not in model2Ids
      ladderCreationBundles.removeWhere((model1) =>
          model1.screen2List.every((sub) => !model2Ids.contains(sub.clpTickerId)));

      updateListOrder2(_ladderCreationScreen2, ladderCreationBundles.expand((bundle) => bundle.screen2List).toList());

      cashAllocatedControllerList.removeWhere((key, value) => !model2Ids.contains(key));

    } else {
      _ladderCreationScreen2 =
          ladderCreationBundles.expand((bundle) => bundle.screen2List).toList();

    }

    if(_ladderCreationScreen3.isNotEmpty) {

      // Extract IDs from model2List
      Set<int> model2Ids = _ladderCreationScreen1.map((e) => e.clpTickerId!).toSet();

      // Filter model1List to remove items whose subList IDs are not in model2Ids
      ladderCreationBundles.removeWhere((model1) =>
          model1.screen3List.every((sub) => !model2Ids.contains(sub.clpTickerId)));

      updateListOrder3(_ladderCreationScreen3, ladderCreationBundles.expand((bundle) => bundle.screen3List).toList());

      cashAllocatedControllerList.removeWhere((key, value) => !model2Ids.contains(key));
    } else {
      _ladderCreationScreen3 =
          ladderCreationBundles.expand((bundle) => bundle.screen3List).toList();
    }

    print("below is _ladderCreationScreen3");
    // print(_ladderCreationScreen3[0].clpStepSize!.text);

    double sum = 0;
    sum = cashAllocatedControllerList.values
        .map((e) => double.tryParse(e.text.replaceAll(",", "")) ?? 0.0) // Convert to int, default to 0 if parsing fails
        .reduce((a, b) => a + b); // Sum all values

    print("below is sum sum");
    print(sum);

    updateSumOfAssignedCashForLadder = sum;




    notifyListeners();
  }

  void updateListOrder1(List<LadderCreationScreen1> localList, List<LadderCreationScreen1> backendList) {
    // Create a map from backend list for quick lookup
    Map<int, LadderCreationScreen1> backendMap = {for (var item in backendList) item.clpTickerId!: item};

    // Reorder backend items based on localList order
    List<LadderCreationScreen1> updatedList = localList
        .map((localItem) => backendMap[localItem.clpTickerId] ?? localItem)
        .toList();

    // Assign the updated list back to local list
    localList.clear();
    localList.addAll(updatedList);
    // for(int i=0;i<updatedList.length; i++){
    //   localList.add(LadderCreationScreen1(
    //       clpTicker: updatedList[i].clpTicker,
    //       clpTickerId: updatedList[i].clpTickerId,
    //     ladderDetails: updatedList[i].ladderDetails,
    //     clpStockId: updatedList[i].clpStockId,
    //     clpInitialPurchasePrice: updatedList[i].clpInitialPurchasePrice,
    //     targetPriceMultiplier: updatedList[i].targetPriceMultiplier,
    //     clpTargetPrice: updatedList[i].clpTargetPrice,
    //     clpMinimumPrice: updatedList[i].clpMinimumPrice,
    //
    //   ));
    // }

    _ladderCreationScreen1 = localList;
  }

  void updateListOrder2(List<LadderCreationScreen2> localList, List<LadderCreationScreen2> backendList) {
    // Create a map from backend list for quick lookup
    Map<int, LadderCreationScreen2> backendMap = {for (var item in backendList) item.clpTickerId!: item};

    // Reorder backend items based on localList order
    List<LadderCreationScreen2> updatedList = localList
        .map((localItem) => backendMap[localItem.clpTickerId] ?? localItem)
        .toList();

    // Assign the updated list back to local list
    localList.clear();
    // for(int i=0;i<updatedList.length; i++){
    //   localList.add(LadderCreationScreen2(
    //     clpTickerId: updatedList[i].clpTickerId,
    //     initialPurchasePrice: updatedList[i].initialPurchasePrice,
    //
    //
    //   ));
    // }
    localList.addAll(updatedList);

    _ladderCreationScreen2 = localList;
  }

  void updateListOrder3(List<LadderCreationScreen3> localList, List<LadderCreationScreen3> backendList) {
    // Create a map from backend list for quick lookup
    Map<int, LadderCreationScreen3> backendMap = {for (var item in backendList) item.clpTickerId!: item};

    // Reorder backend items based on localList order
    List<LadderCreationScreen3> updatedList = localList
        .map((localItem) => backendMap[localItem.clpTickerId] ?? localItem)
        .toList();

    // Assign the updated list back to local list
    localList.clear();
    localList.addAll(updatedList);

    _ladderCreationScreen3 = localList;
  }

  void removeSingleStockAndLadders(int index) {

    cashAllocatedControllerList.remove(_ladderCreationScreen1[index].clpTickerId!);
    _ladderCreationScreen1.removeAt(index);
    _ladderCreationScreen2.removeAt(index);
    _ladderCreationScreen3.removeAt(index);
    _cashAllocatedControllerListOld.removeAt(index);
    double sum = 0;
    for (int i = 0; i < cashAllocatedControllerList.length; i++) {
      // String textValue = cashAllocatedControllerListOld[i].text ?? "0.0";
      String textValue = cashAllocatedControllerList[_ladderCreationScreen1[i].clpTickerId!]!.text ?? "0.0";

      double parsedValue =
          double.tryParse(textValue.replaceAll(",", "")) ?? 0.0;

      sum += parsedValue;
      updateSumOfAssignedCashForLadder = sum;
    }
    notifyListeners();
  }

  void resetIbqToEstInitialBuyCashQty() {
    if (initialBuyQtyWarning.length > 0) {

//       double initialBuyCash = double.tryParse(ladderCreationParametersScreen2.initialBuyCash!.text
//           .replaceAll(",", "")) ??
//           0.0;
//       double initialBuyPriceValue = initialBuyPrice;
//
// // Calculate the result without flooring
//       double result = initialBuyCash / initialBuyPriceValue;
//
//       _ladderCreationScreen2[index].clpInitialBuyQuantity!.text = result.toString();

      _ladderCreationScreen2[index].clpInitialBuyQuantity!.text =
          intToUnits(((cashAllocated / initialBuyPrice) * (k1 / k2)).floor());
      print("breakpoint value5 ${index} :${_ladderCreationScreen2[index].clpInitialBuyQuantity!.text}");

      print("below is clpInitialBuyQuantity");
      print(_ladderCreationScreen2[index].clpInitialBuyQuantity!.text);
      _calculateActualInitialBuyCash();
      updateInitialBuyQtyWarning = "";
      notifyListeners();
    }
  }

  void clearAllStockAndLadders() {
    _ladderCreationScreen1.clear();
    notifyListeners();
  }

  void listenLtpOfStock(StockPriceListener stockPriceListener) {
    socket = stockPriceListener.socket!;
    tickListener = (socketData) {
      int parsedId = int.parse(jsonDecode(socketData['sym_security_code']));
      if (parsedId == stockSubscribedId) {
        updateSubscribedStockPrice = amountToInrFormatCLP(
            int.parse(socketData['stock_current_price']) / 100,
            decimalDigit: 2);
      }
      for (int i = 0; i < _ladderCreationScreen1.length; i++) {
        if (_ladderCreationScreen1[i].clpTickerId == parsedId) {
          _ladderCreationScreen1[i].clpInitialPurchasePrice!.text =
              amountToInrFormatCLP(
                  int.parse(socketData['stock_current_price']) / 100,
                  decimalDigit: 2);
          break;
        }
      }
      notifyListeners();
    };

    socket.on('tick', tickListener!);
  }

  void stopListenLtpOfStocks() {
    socket.off('tick', tickListener!);
  }

  Future<void> changeCashAllocated() async {
    for (int i = 0; i < _cashAllocatedControllerList.length; i++) {
      // Debugging prints for clpTargetPrice and clpInitialPurchasePrice
      print(
          "Target Price (Screen 1, Index $i): ${_ladderCreationScreen1[i].clpTargetPrice!.text}");
      print(
          "Initial Purchase Price (Screen 1, Index $i): ${_ladderCreationScreen1[i].clpInitialPurchasePrice!.text}");

      double kTemp = (double.tryParse(
                  (_ladderCreationScreen1[i].clpTargetPrice!.text)
                      .replaceAll(",", "")) ??
              0.0) /
          (double.tryParse(
                  (_ladderCreationScreen1[i].clpInitialPurchasePrice!.text)
                      .replaceAll(",", "")) ??
              0.0);

      print("kTemp for Index $i: $kTemp");

      _ladderCreationScreen2[i].clpCashAllocated!.text =
          // (_cashAllocatedControllerListOld[i].text);
          (_cashAllocatedControllerList[_ladderCreationScreen1[i].clpTickerId]!.text);

      // Debugging prints for clpCashAllocated
      print(
          "Cash Allocated (Screen 2, Index $i): ${_ladderCreationScreen2[i].clpCashAllocated!.text}");

      double initialBuyCash = (((2 * kTemp) - 2) / ((2 * kTemp) - 1)) *
          (double.tryParse((_ladderCreationScreen2[i].clpCashAllocated!.text)
                  .replaceAll(",", "")) ??
              0.0);

      // Debugging initial buy calculations
      print("Initial Buy Cash for Index $i: $initialBuyCash");

      print("below is value value ${i}");
      print(_ladderCreationScreen2[i].initialPurchasePrice!.text);
      double initialBuyPriceValue = double.tryParse(_ladderCreationScreen2[i].initialPurchasePrice!.text.replaceAll(",", '')) ?? initialBuyPrice;
      // int initialBuyQty = (initialBuyCash / initialBuyPrice).floor();
      int initialBuyQty = (initialBuyCash / initialBuyPriceValue).floor();
      print("Initial Buy Quantity for Index $i: ${initialBuyQty}");

      // double actualInitialBuyCash = initialBuyQty * initialBuyPrice;
      double actualInitialBuyCash = initialBuyQty * initialBuyPriceValue;
      print("Actual Initial Buy Cash for Index $i: $actualInitialBuyCash");
      print(_ladderCreationScreen3[i].numberOfStepsAbove!.text);

      // Debugging buy/sell quantity calculations
      int buySellQty = (initialBuyQty /
              (double.parse(_ladderCreationScreen3[i].numberOfStepsAbove!.text) ??
                  0))
          .ceil();
      print("Buy/Sell Quantity for Index $i: $buySellQty");

      double cashNeeded = buySellQty *
          numberOfStepsBelow *
          // (initialBuyPrice / targetPriceMultiplier);
          (initialBuyPriceValue / targetPriceMultiplier);
      print("Cash Needed for Index $i: $cashNeeded");

      print(
          "NumberOfStepsBelow for Index $i: $numberOfStepsBelow and ${_ladderCreationScreen3[i].numberOfStepsBelow}");
      // double cashLeft = cashAllocated - initialBuyQty * initialBuyPrice;
      double cashLeft = cashAllocated - initialBuyQty * initialBuyPriceValue;
      print("Cash Left for Index $i: $cashLeft");

      double actualCashAllocated =
          // (initialBuyQty * initialBuyPrice) + cashNeeded;
          (initialBuyQty * initialBuyPriceValue) + cashNeeded;

      print("Actual Cash Allocated for Index $i: $actualCashAllocated");

      // Assigning values back to the UI elements with additional prints
      _ladderCreationScreen2[i].initialBuyCash!.text =
          initialBuyCash.toStringAsFixed(2);
      _ladderCreationScreen2[i].clpInitialBuyQuantity!.text =
          initialBuyQty.toStringAsFixed(2);
      print("breakpoint value6 ${i} :${_ladderCreationScreen2[i].clpInitialBuyQuantity!.text}");
      _ladderCreationScreen2[i].actualInitialBuyCash!.text =
          actualInitialBuyCash.toStringAsFixed(2);

      print(
          "Screen 2 Initial Buy Cash: ${_ladderCreationScreen2[i].initialBuyCash!.text}");
      print(
          "Screen 2 Initial Buy Quantity: ${_ladderCreationScreen2[i].clpInitialBuyQuantity!.text}");
      print(
          "Screen 2 Actual Initial Buy Cash: ${_ladderCreationScreen2[i].actualInitialBuyCash!.text}");

      _ladderCreationScreen3[i].clpDefaultBuySellQuantity!.text =
          buySellQty.toString();
      _ladderCreationScreen3[i].cashNeeded = cashNeeded;
      _ladderCreationScreen3[i].cashLeft = cashLeft;
      _ladderCreationScreen3[i].actualCashAllocated = actualCashAllocated;

      print(
          "Screen 3 Default Buy/Sell Quantity: ${_ladderCreationScreen3[i].clpDefaultBuySellQuantity!.text}");
      print("Screen 3 Cash Needed: ${_ladderCreationScreen3[i].cashNeeded}");
      print("Screen 3 Cash Left: ${_ladderCreationScreen3[i].cashLeft}");
      print(
          "Screen 3 Actual Cash Allocated: ${_ladderCreationScreen3[i].actualCashAllocated}");
    }
  }

  LadderCreationTickerResponse tempLadderCreationTickerData = LadderCreationTickerResponse();
  assignValueInRecommendedParameters() {
    getUserStockAndLadder();
  }

  updateRecommendedParameter() {

    double targetPriceMultiplier;

    print("inside updateRecommendedParameter");
    print(_isRecommendedParametersEnabledScreen1);
    print(stockRecommendedParametersData[ladderCreationParametersScreen1.clpTicker ?? ""] != null);
    print(stockRecommendedParametersData[ladderCreationParametersScreen1.clpTicker ?? ""]);


    if(_isRecommendedParametersEnabledScreen1[ladderCreationParametersScreen1.clpTicker ?? ""] ?? false) {
      print("inside if");
      if(stockRecommendedParametersData[ladderCreationParametersScreen1.clpTicker ?? ""] != null) {
        print("inside if if");
        recommendedParametersNotAvailable[ladderCreationParametersScreen1.clpTicker ?? ""] = false;
        // _isRecommendedParametersEnabledScreen1 = false;
        targetPriceMultiplier = double.tryParse(
            stockRecommendedParametersData[ladderCreationParametersScreen1.clpTicker ?? ""]?.targetPriceMultipler ??
                "") ??
            0.0;

        // new code starts from here
        ladderCreationParametersScreen1.targetPriceMultiplier[ladderCreationParametersScreen1.clpTicker ?? ""]!.text = targetPriceMultiplier.toString();
        updateTargetPriceMultiplier(
          ladderCreationParametersScreen1
              .targetPriceMultiplier[ladderCreationParametersScreen1.clpTicker ?? ""]!.text,
          ladderCreationParametersScreen1
              .targetPriceMultiplier[ladderCreationParametersScreen1.clpTicker ?? ""]!.text.length,
        );

        // new code end here
      } else {

        print("inside if else");

        _recommendedParametersNotAvailable[ladderCreationParametersScreen1.clpTicker ?? ""] = true;
        // _isRecommendedParametersEnabledScreen1 = false;
        targetPriceMultiplier = 2;
      }
    } else {
      print("inside else");
      // _isRecommendedParametersEnabledScreen1 = true;
    }


  }

  updateRecommendedParameterScreen3() {
    if(isRecommendedParametersEnabledScreen3[ladderCreationParametersScreen1.clpTicker ?? ""] ?? false) {

      if(stockRecommendedParametersData[ladderCreationParametersScreen1.clpTicker ?? ""] != null) {

        String inputStepAbove = stockRecommendedParametersData[ladderCreationParametersScreen1.clpTicker ?? ""]!.stepsAbove!.toString();

        if(((double.tryParse(inputStepAbove) ?? 0) < minStepAbove) || ((double.tryParse(inputStepAbove) ?? 0) > maxStepAbove)) {

          recommendedParametersNotAvailable[ladderCreationParametersScreen1.clpTicker ?? ""] = true;

          if((double.tryParse(inputStepAbove) ?? 0) < minStepAbove) {
            inputStepAbove = minStepAbove.toStringAsFixed(2);
            numberOfStepsAboveController.text = minStepAbove.toStringAsFixed(2);
          }

          if((double.tryParse(inputStepAbove) ?? 0) > maxStepAbove) {
            inputStepAbove = maxStepAbove.toStringAsFixed(2);
            numberOfStepsAboveController.text = maxStepAbove.toStringAsFixed(2);
          }

        } else {
          numberOfStepsAboveController.text = inputStepAbove;
        }
       

        if(selectedMode == "Prior Buy") {
          print("updateRecommendedParameterScreen3 prior buy");
          final result = priorBuyCalculation(
            R: double.tryParse(ladderCreationScreen3[index].clpStepSize!.text) ?? 0, // 1.324,
            P1: double.tryParse(priorBuyStockPriceTextController.text) ?? 0,
            P2: double.tryParse(ladderCreationParametersScreen1.currentPrice ?? "0") ?? 0,
            T: targetPrice, // double.tryParse(_stateProvider!.targetPriceController.text) ?? 0,
            C: actualCashAllocated, // double.tryParse(cashAllocatedControllerList[ladderCreationParametersScreen1.clpTickerId]!.text.replaceAll(",", "")) ?? 0.0,
            S1: double.tryParse(priorBuyStockQuantityTextController.text) ?? 0,
          );

          print("after calling prior buy");

          calculatePriorBuyStepSize(targetPrice: targetPrice, stepAbove: double.tryParse(numberOfStepsAboveController.text) ?? 40);
          print("after calling calculatePriorBuyStepSize");
          calculatePriorBuyOrderSize(stepAbove: double.tryParse(numberOfStepsAboveController.text) ?? 40);
        } else {
          updateNumberOfStepsAbove(
            inputStepAbove,
            numberOfStepsAboveController.selection.baseOffset,
          );
        }


        if (numberOfStepsAboveController.text != "" &&
            numberOfStepsAboveController.text != "0") {

          if(selectedMode == "Prior Buy") {

          } else {
            stepSizeController.text = (calculateFieldStepSize(double.parse(numberOfStepsAboveController.text)))
                .toStringAsFixed(2);

            calculateStepSize(
                stepAbove: double.tryParse(numberOfStepsAboveController.text) ?? 0,
                initialPurchasePrice: initialBuyPrice
            );
          }

        }


      } else {
        recommendedParametersNotAvailable[ladderCreationParametersScreen1.clpTicker ?? ""] = true;
      }



    } else {
      if(selectedMode == "Prior Buy") {
        final result = priorBuyCalculation(
          R: double.tryParse(ladderCreationScreen3[index].clpStepSize!.text) ?? 0, // 1.324,
          P1: double.tryParse(priorBuyStockPriceTextController.text) ?? 0,
          P2: double.tryParse(ladderCreationParametersScreen1.currentPrice ?? "0") ?? 0,
          T: targetPrice, // double.tryParse(_stateProvider!.targetPriceController.text) ?? 0,
          C: actualCashAllocated, // double.tryParse(cashAllocatedControllerList[ladderCreationParametersScreen1.clpTickerId]!.text.replaceAll(",", "")) ?? 0.0,
          S1: double.tryParse(priorBuyStockQuantityTextController.text) ?? 0,
        );

        print('x (Stocks to buy at P2): ${result['x']}');
        print('P (Average Price): ${result['P']}');
        print('R (Rate of sell): ${result['R']}');
        print('Final Value: ${result['finalValue']}');
        notifyListeners();

        numberOfStepsAboveController.text = maxStepAbove.toStringAsFixed(2);

        if (numberOfStepsAboveController.text != "" &&
            numberOfStepsAboveController.text != "0") {
          calculatePriorBuyStepSize(
              targetPrice: targetPrice,
              stepAbove: double.tryParse(numberOfStepsAboveController.text) ?? 0
          );
          calculatePriorBuyOrderSize(
              stepAbove: double.tryParse(numberOfStepsAboveController.text) ?? 0
          );
        } else {
          calculatePriorBuyStepSize(
              targetPrice: targetPrice,
              stepAbove: 40
          );
          calculatePriorBuyOrderSize(
              stepAbove: 40
          );
        }

      } else {

        if(((double.tryParse(numberOfStepsAboveController.text) ?? 0) < minStepAbove) || ((double.tryParse(numberOfStepsAboveController.text) ?? 0) > maxStepAbove)) {
          numberOfStepsAboveController.text = maxStepAbove.toStringAsFixed(2);

          updateNumberOfStepsAbove(
            numberOfStepsAboveController.text,
            numberOfStepsAboveController.selection.baseOffset,
          );

          if (numberOfStepsAboveController.text != "" &&
              numberOfStepsAboveController.text != "0") {

            if(selectedMode == "Prior Buy") {

            } else {
              stepSizeController.text = (calculateFieldStepSize(double.parse(numberOfStepsAboveController.text)))
                  .toStringAsFixed(2);

              calculateStepSize(
                  stepAbove: double.tryParse(numberOfStepsAboveController.text) ?? 0,
                  initialPurchasePrice: initialBuyPrice
              );
            }

          }

        }

      }
    }
  }

  Future<bool> getUserStockAndLadder(
      {bool cashAllocatedChanged = false}) async {

    try {

      LadderCreationTickerResponse? value = await RestApiService()
          .fetchLadderCreationTickers(cashAllocatedControllerListOld,
          cashAllocatedChanged: cashAllocatedChanged);


      _accountCashForNewLadders =
          double.tryParse(value.data?.accountCashForNewLadders ?? "0.0") ?? 0.0;
      _accountUnallocatedCash =
          double.tryParse(value.data?.accountUnallocatedCash ?? "0.0") ?? 0.0;
      _accountExtraCashLeft =
          double.tryParse(value.data?.accountExtraCashLeft ?? "0.0") ?? 0.0;
      _accountExtraCashGenerated =
          double.tryParse(value.data?.accountExtraCashGenerated ?? "0.0") ??
              0.0;

      if (value.data!.ladderCreationTickerList != null &&
          value.data!.ladderCreationTickerList!.isNotEmpty) {
        if(cashAllocatedControllerList.isEmpty) {
          cashAllocatedControllerList.clear();
        }

        List<LadderCreationScreenBundle> ladderCreationBundleTemp = [];
        int dataIndex = 0;
        for (var tickerAndLadderData in value.data!.ladderCreationTickerList!) {
          print("calculated which values inputs $tickerAndLadderData");
          int numberOfStepsAbove = 40;
          Map<String, double> targetPriceMultiplier = {};
          // _isRecommendedParametersEnabledScreen1 = true;
          print("here here here");
          print(stockRecommendedParametersData);
          print(stockRecommendedParametersData[value.data!.ladderCreationTickerList![index].ssTicker!]);
          print(_ladderCreationScreen1.isNotEmpty);
          print(_ladderCreationScreen1.length > index);
          // print(
          //     "here is the index of the stock ${stockRecommendedParametersData[ladderCreationParametersScreen1.clpTicker ?? ""]?.ddSrpId} ${_isRecommendedParametersEnabledScreen1} and ${stockRecommendedParametersData[ladderCreationParametersScreen1.clpTicker ?? ""]?.ddSrpId != null} ${index} and ${stockRecommendedParametersData.length}");
          if ((_isRecommendedParametersEnabledScreen1[value.data!.ladderCreationTickerList![index].ssTicker!] ?? false) &&
              _ladderCreationScreen1.isNotEmpty && _ladderCreationScreen1.length > index
          // stockRecommendedParametersData.length > index &&
          // stockRecommendedParametersData[value.data!.ladderCreationTickerList![index].ssTicker ?? ""]?.ddSrpId != null
          ) {
            print("isdie this one");
            _recommendedParametersNotAvailable[ladderCreationParametersScreen1.clpTicker ?? ""] = false;
            // print(
            //     "hello there targetPrice ${stockRecommendedParametersData[ladderCreationParametersScreen1.clpTicker ?? ""]?.targetPriceMultipler}");
            if(stockRecommendedParametersData[ladderCreationParametersScreen1.clpTicker ?? ""] != null) {
              recommendedParametersNotAvailable[ladderCreationParametersScreen1.clpTicker ?? ""] = false;
              _isRecommendedParametersEnabledScreen1[ladderCreationParametersScreen1.clpTicker ?? ""] = true;
              _isRecommendedParametersEnabledScreen3[ladderCreationParametersScreen1.clpTicker ?? ""] = true;
              // _isRecommendedParametersEnabledScreen3 = true;
              targetPriceMultiplier[tickerAndLadderData.ssTicker ?? ""] = double.tryParse(
                  stockRecommendedParametersData[ladderCreationParametersScreen1.clpTicker ?? ""]?.targetPriceMultipler ??
                      "") ??
                  0.0;

              // new code starts from here
              ladderCreationParametersScreen1.targetPriceMultiplier[ladderCreationParametersScreen1.clpTicker ?? ""]!.text = targetPriceMultiplier[tickerAndLadderData.ssTicker ?? ""].toString();
              updateTargetPriceMultiplier(
                ladderCreationParametersScreen1
                    .targetPriceMultiplier[ladderCreationParametersScreen1.clpTicker ?? ""]!.text,
                ladderCreationParametersScreen1
                    .targetPriceMultiplier[ladderCreationParametersScreen1.clpTicker ?? ""]!.text.length,
              );

              // String inputStepSize = stockRecommendedParametersData[ladderCreationParametersScreen1.clpTicker ?? ""]!.stepsSize!.toString();
              //
              // stepSizeController.value = TextEditingValue(
              //   text: inputStepSize.toString(),
              //   selection: TextSelection.fromPosition(TextPosition(
              //       offset: stepSizeController.selection.baseOffset)),
              // );
              //
              // List<String> splittedValues =
              // doublValueSplitterBydot(stepSizeController.text);
              // updateStepSize(
              //   splittedValues[0],
              //   splittedValues[1],
              //   stepSizeController.selection.baseOffset,
              // );
              //
              // if (stepSizeController.text != "" &&
              //     stepSizeController.text != "0") {
              //   numberOfStepsAboveController.text = (calculateFieldNumberOfStepAbove(
              //       double.parse(stepSizeController.text.replaceAll(",", ""))))
              //       .toString();
              // }

              // new code end here
            } else {

              _recommendedParametersNotAvailable[ladderCreationParametersScreen1.clpTicker ?? ""] = true;
              _isRecommendedParametersEnabledScreen1[ladderCreationParametersScreen1.clpTicker ?? ""] = false;
              _isRecommendedParametersEnabledScreen3[ladderCreationParametersScreen1.clpTicker ?? ""] = false;
              targetPriceMultiplier[tickerAndLadderData.ssTicker ?? ""] = 2;
            }

          } else if(stockRecommendedParametersData[value.data!.ladderCreationTickerList![index].ssTicker ?? ""]?.ddSrpId != null) {

            _recommendedParametersNotAvailable[value.data!.ladderCreationTickerList![index].ssTicker ?? ""] = false;
            print("inside here else");
            _isRecommendedParametersEnabledScreen1[value.data!.ladderCreationTickerList![index].ssTicker!] = true;
            _isRecommendedParametersEnabledScreen3[value.data!.ladderCreationTickerList![index].ssTicker!] = true;
            targetPriceMultiplier[tickerAndLadderData.ssTicker ?? ""] = double.tryParse(
                stockRecommendedParametersData[value.data!.ladderCreationTickerList![index].ssTicker ?? ""]?.targetPriceMultipler ??
                    "") ??
                0.0;

          } else if (stockRecommendedParametersData[value.data!.ladderCreationTickerList![index].ssTicker ?? ""]?.ddSrpId == null) {
            print("hello in the onChanged of the 1415");
            _recommendedParametersNotAvailable[value.data!.ladderCreationTickerList![index].ssTicker ?? ""] = true;
            _isRecommendedParametersEnabledScreen1[value.data!.ladderCreationTickerList![index].ssTicker!] = false;
            _isRecommendedParametersEnabledScreen3[value.data!.ladderCreationTickerList![index].ssTicker!] = false;
            targetPriceMultiplier[tickerAndLadderData.ssTicker ?? ""] = 2;
          } else {
            targetPriceMultiplier[tickerAndLadderData.ssTicker ?? ""] = 2;
          }
          double initialBuyPrice =
              double.tryParse(tickerAndLadderData.ssCurrentPrice ?? "0.0") ??
                  0.0;
          double minimumPrice = 0.0;
          double targetPrice = (targetPriceMultiplier[tickerAndLadderData.ssTicker ?? ""]! * (initialBuyPrice));
          double k = targetPrice / initialBuyPrice;
          print("cashAllocated is here ${tickerAndLadderData.ssCashAllocated}");
          double cashAllocated = double.tryParse(
              (tickerAndLadderData.ssCashAllocated ?? "0.0")
                  .replaceAll(",", "")) ??
              0.0;

          print("cashAllocated is here in a varaible $cashAllocated");
          print(cashAllocatedControllerList.length != value.data!.ladderCreationTickerList!.length);
          // if(cashAllocatedControllerList.length != value.data!.ladderCreationTickerList!.length) {

          if(_ladderCreationScreen1.isEmpty) {
            print("inside if");
            cashAllocatedControllerListOld.add(TextEditingController(
              text: amountToInrFormatCLP(cashAllocated,
                  decimalDigit: 2, showSymbol: false),
            ));

            cashAllocatedControllerList[tickerAndLadderData.ssTickerId!] = TextEditingController(
              text: amountToInrFormatCLP(cashAllocated,
                  decimalDigit: 2, showSymbol: false),
            );
            print(cashAllocatedControllerList[tickerAndLadderData.ssTickerId!]!.text);
          } else {
            // if(_ladderCreationScreen1.isNotEmpty){
            //   value.data!.ladderCreationTickerList![dataIndex].ssCashAllocated = _ladderCreationScreen1[dataIndex].;
            //   tickerAndLadderData.ssCashAllocated = cashAllocatedControllerList[dataIndex].text;
            // }
            print("inside else");
            // value.data!.ladderCreationTickerList![dataIndex].ssCashAllocated = cashAllocatedControllerList[dataIndex].text;
            // tickerAndLadderData.ssCashAllocated = cashAllocatedControllerList[dataIndex].text;
            value.data!.ladderCreationTickerList![dataIndex].ssCashAllocated = cashAllocatedControllerList[tickerAndLadderData.ssTickerId!]!.text;
            tickerAndLadderData.ssCashAllocated = cashAllocatedControllerList[tickerAndLadderData.ssTickerId!]!.text;
          }

          cashAllocated = double.tryParse(
              (tickerAndLadderData.ssCashAllocated ?? "0.0")
                  .replaceAll(",", "")) ??
              0.0;

          print("after assign cash allocated");
          print(cashAllocated);
          dataIndex++;

          double initialBuyCash =
              (((2 * k) - 2) / ((2 * k) - 1)) * cashAllocated;
          int initialBuyQty = (initialBuyCash / initialBuyPrice).floor();
          double actualInitialBuyCash = initialBuyQty * initialBuyPrice;
          // Calculations for LadderCreationScreen3
          double stepSize =
          ((targetPrice - initialBuyPrice) / numberOfStepsAbove);
          print("here is the stepsize $stepSize");
          print("here is the initialBuyPrice $initialBuyPrice");
          // stepSize = (stepSize * 100).floorToDouble() / 100;

          // new_min_step_size = ((200 * (target_price - initial_purchase_price)) / initial_buy_quentity) * (1/2)

          // stepSize = double.parse(sqrt((((200 * (targetPrice - (initialBuyPrice))) / (double.tryParse(initialBuyQty.toString()) ?? 0.0)) * (1/2))).toStringAsFixed(2));

          int numberOfStepsBelow = (initialBuyPrice / stepSize).floor();
          int buySellQty = (initialBuyQty / numberOfStepsAbove).ceil();
          double cashNeeded = buySellQty *
              numberOfStepsBelow *
              (initialBuyPrice / targetPriceMultiplier[tickerAndLadderData.ssTicker ?? ""]!);
          double cashLeft = cashAllocated - initialBuyQty * initialBuyPrice;
          double actualCashAllocated =
              (initialBuyQty * initialBuyPrice) + cashNeeded;
          print("calculated all the values: "
              "numberOfStepsAbove: $numberOfStepsAbove, "
              "targetPriceMultiplier: $targetPriceMultiplier, "
              "initialBuyPrice: $initialBuyPrice, "
              "minimumPrice: $minimumPrice, "
              "targetPrice: $targetPrice, "
              "k: $k, "
              "cashAllocated: $cashAllocated, "
              "initialBuyCash: $initialBuyCash, "
              "initialBuyQty: $initialBuyQty, "
              "actualInitialBuyCash: $actualInitialBuyCash, "
              "stepSize: $stepSize, "
              "numberOfStepsBelow: $numberOfStepsBelow, "
              "buysellQty: $buySellQty"
              "cashNeeded: $cashNeeded, "
              "cashLeft: $cashLeft, "
              "actualCashAllocated: $actualCashAllocated");

          // Create LadderCreationScreen1 instance

          LadderCreationScreen1 screen1 = LadderCreationScreen1(
            clpTickerId: tickerAndLadderData.ssTickerId,
            clpTicker: tickerAndLadderData.ssTicker,
            currentPrice: tickerAndLadderData.ssCurrentPrice,
            clpExchange: tickerAndLadderData.ssExchange,
            ladderDetails: tickerAndLadderData.ladderDetails?.map((ladderData) {
              return LadderDetails(
                ladId: ladderData.ladId,
                ladUserId: ladderData.ladUserId,
                ladTicker: ladderData.ladTicker,
                ladName: ladderData.ladName,
                ladStatus: ladderData.ladStatus,
                ladTickerId: ladderData.ladTickerId,
                ladExchange: ladderData.ladExchange,
                ladCashAllocated: ladderData.ladCashAllocated,
                ladMinimumPrice: ladderData.ladMinimumPrice,
                ladExtraCashGenerated: ladderData.ladExtraCashGenerated,
                ladExtraCashLeft: ladderData.ladExtraCashLeft,
                ladInitialBuyQuantity: ladderData.ladInitialBuyQuantity,
                ladDefaultBuySellQuantity: ladderData.ladDefaultBuySellQuantity,
                ladTargetPrice: ladderData.ladTargetPrice,
                ladInitialBuyPrice: ladderData.ladInitialBuyPrice,
                ladDefinitionId: ladderData.ladDefinitionId,
                ladNumOfStepsAbove: ladderData.ladNumOfStepsAbove,

              );
            }).toList(),
            clpStockId: tickerAndLadderData.ssId,
            clpInitialPurchasePrice: TextEditingController(
                text: amountStringSplittedFormatted(
                    tickerAndLadderData.ssCurrentPrice)),
            targetPriceMultiplier: targetPriceMultiplier.map((key, value) {
              return MapEntry(key, TextEditingController(text: value.toString()));
            }),
            // targetPriceMultiplier: {
            //   tickerAndLadderData.ssTicker ?? "":
            //   TextEditingController(
            //       text: targetPriceMultiplier[tickerAndLadderData.ssTicker ?? ""]!.toStringAsFixed(2))
            // },
            clpTargetPrice: TextEditingController(
                text: amountStringSplittedFormatted(
                    targetPrice.toStringAsFixed(2))),
            clpMinimumPrice: TextEditingController(
                text: amountStringSplittedFormatted(minimumPrice.toString())),
          );

          // Create LadderCreationScreen2 instance
          LadderCreationScreen2 screen2 = LadderCreationScreen2(
            clpExchange: tickerAndLadderData.ssExchange,
            initialPurchasePrice: TextEditingController(
                text: amountStringSplittedFormatted(
                    tickerAndLadderData.ssCurrentPrice)),
            clpTickerId: tickerAndLadderData.ssTickerId,
            targetPrice: TextEditingController(
                text: amountStringSplittedFormatted(
                    targetPrice.toStringAsFixed(2))),
            targetPriceMultiplier: TextEditingController(
                text: targetPriceMultiplier[tickerAndLadderData.ssTicker ?? ""]!.toStringAsFixed(2)),
            clpCashAllocated: TextEditingController(
                text: amountStringSplittedFormatted(
                    (tickerAndLadderData.ssCashAllocated!)
                        .replaceAll(",", ""))),
            initialBuyCash: TextEditingController(
                text: amountStringSplittedFormatted(
                    initialBuyCash.toStringAsFixed(2))),
            clpInitialBuyQuantity:
            TextEditingController(text: intToUnits(initialBuyQty)),
            actualInitialBuyCash: TextEditingController(
                text: amountStringSplittedFormatted(
                    actualInitialBuyCash.toStringAsFixed(2))),
          );
          // Create LadderCreationScreen3 instance
          LadderCreationScreen3 screen3 = LadderCreationScreen3(
            clpExchange: tickerAndLadderData.ssExchange,
            clpTickerId: tickerAndLadderData.ssTickerId,
            numberOfStepsAbove:
            TextEditingController(text: intToUnits(numberOfStepsAbove)),
            clpStepSize: TextEditingController(
                text:
                amountStringSplittedFormatted(stepSize.toStringAsFixed(2))),
            numberOfStepsBelow: numberOfStepsBelow,
            clpDefaultBuySellQuantity:
            TextEditingController(text: buySellQty.toString()),
            cashNeeded: cashNeeded,
            cashLeft: cashLeft,
            actualCashAllocated: actualCashAllocated,
          );

          // Add to the bundle list
          LadderCreationScreenBundle bundle = LadderCreationScreenBundle(
            screen1List: [screen1],
            screen2List: [screen2],
            screen3List: [screen3],
          );
          ladderCreationBundleTemp.add(bundle);

          // add prior buy call and api here

          try {

            Map<String, dynamic> request = {
              // 'data': dataList,
              'stock_name': value.data!.ladderCreationTickerList![index].ssTicker!,
              'stock_exchange': value.data!.ladderCreationTickerList![index].ssExchange!,
            };

            StockHoldingResponse res =
            await RestApiService().getPriorBuyStockHoldings(request);

            // if(res.message!.toLowerCase() == "success") {
            if (res.status!) {

              priorBuyAvailable[res.data!.stockName!] = true;
              priorBuyStockPrice[res.data!.stockName!] = res.data!.averagePrice!.toDouble();
              priorBuyStockQuantity[res.data!.stockName!] = res.data!.quantity!.toDouble();

              priorBuyStockPriceTextController.text = priorBuyStockPrice[res.data!.stockName!]!.toStringAsFixed(0);
              priorBuyStockQuantityTextController.text = priorBuyStockQuantity[res.data!.stockName!]!.toStringAsFixed(0);
              // otpResponse = res;

            } else {

              priorBuyAvailable[res.data!.stockName!] = false;
              priorBuyStockPrice[res.data!.stockName!] = 0;
              priorBuyStockQuantity[res.data!.stockName!] = 0;

            }

          } catch (e) {

          }

          // sjfsdjfdsl


        }
        double sum = 0;
        for (int i = 0; i < cashAllocatedControllerList.length; i++) {
          // String textValue = cashAllocatedControllerListOld[i].text ?? "0.0";
          // String textValue = cashAllocatedControllerList[_ladderCreationScreen1[i].clpTickerId]!.text ?? "0.0";
          //
          // double parsedValue =
          //     double.tryParse(textValue.replaceAll(",", "")) ?? 0.0;
          //
          // sum += parsedValue;
          print(cashAllocatedControllerList.toString());
          sum = cashAllocatedControllerList.values
              .map((e) => double.tryParse(e.text.replaceAll(",", "")) ?? 0.0) // Convert to int, default to 0 if parsing fails
              .reduce((a, b) => a + b); // Sum all values

          print("below is sum sum");
          print(sum);

          updateSumOfAssignedCashForLadder = sum;
        }
        // Now add the complete list of bundles

        addListOfStocksAndLadders(ladderCreationBundleTemp);
        notifyListeners();
        apiErrorMessage = '';
        return false;
      } else {
        return true;
      }


    }on HttpApiException catch (err) {
    // 🔥 ADD THIS - Set the error message
    apiErrorMessage = err.errorSuggestion;
    print("Error in getUserStockAndLadder: ${err.errorSuggestion}");
    return true;
  } catch (e) {
    apiErrorMessage = "Unexpected error: $e";
    print("Unexpected error in getUserStockAndLadder: $e");
    return true;
  } 
  }

  double calculateFieldStepSize(double numberOfStepsAboveValue) {
    // var stepSize = ((targetPrice - initialBuyPrice) / numberOfStepsAboveValue);
    // return stepSize;
    return calculatedStepSize;
  }

  double calculateFieldNumberOfStepAbove(double stepSize) {
    // var numberOfStepsAboveValue = (targetPrice - initialBuyPrice) / stepSize;
    // return numberOfStepsAboveValue.round();
    return calculatedNumberOfStepsAbove;
  }

  Future<bool> stockRecommendationParameters(
      List<SelectedTickerModel> selectedTickers) async {
    try {
      // print("here is the selected Tickers ${selectedTickers[0].ssTicker}");
      // List<Map<String, dynamic>> dataList = [];

      List<String> dataList = [];
      for (int i = 0; i < selectedTickers.length; i++) {
        // Map<String, dynamic> data = {
        //   "ss_id": selectedTickers[i].ssId,
        // };
        // dataList.add(data);
        print("here is the selected Tickers ${selectedTickers[i].ssTicker}");
        dataList.add(selectedTickers[i].ssTicker.toString());
      }

      Map<String, dynamic> request = {
        // 'data': dataList,
        'ticker': dataList,
      };

      StockRecommendedParametersResponse res =
          await RestApiService().addStockRecommendationParameters(request);

      // if(res.message!.toLowerCase() == "success") {
      if (res.status! && res.data != null) {
        stockRecommendedParametersDataList = res.data!;

        print("inside stockRecommendationParameters");
        print(stockRecommendedParametersDataList.length);

        for(int i=0; i<stockRecommendedParametersDataList.length; i++) {
          print(stockRecommendedParametersDataList[i].ticker);
          stockRecommendedParametersData[stockRecommendedParametersDataList[i].ticker ?? ""] = stockRecommendedParametersDataList[i];
        }
        // otpResponse = res;
        return true;
      } else {
        return false;
      }
    } on HttpApiException catch (err) {
      print(err.errorSuggestion);
      print(err.errorTitle);
      print(err.errorCode);
      return false;
    }
  }

  bool checkforBrokerkerage() {
    int orderSize = double.parse(buySellQtyController.text.replaceAll(",", "")).toInt();
    double stepSize = calculatedStepSize;
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

  /// Calculates Prior Buy values based on given parameters.
  ///
  /// Parameters:
  /// [R] = Rate of sell (Step Size)
  /// [P1] = Price of prior buy
  /// [P2] = Current price
  /// [T] = Target price
  /// [C] = Allocated Cash
  /// [S1] = Number of stocks prior buy
  ///
  /// Returns a Map containing:
  /// - 'x': Number of stocks to buy at P2
  /// - 'P': Average price for ladder
  /// - 'R': Rate of sell (recalculated)
  /// - 'finalValue': Final value of stocks to buy/sell at P2
  Map<String, double> priorBuyCalculation({
    required double R,
    required double P1,
    required double P2,
    required double T,
    required double C,
    required double S1,
  }) {

    print('R (Rate of sell (Step Size)): ${R}');
    print('P1 (Price of prior buy): ${P1}');
    print('P2 (Current price): ${P2}');
    print('T (Target price): ${T}'); // - this can chcange in reverse
    print('C (Allocated Cash): ${C}'); // and this can change in reverse
    print('S1 (Number of stocks prior buy): ${S1}');
    print("--------------------------------------------------------------------------------");
    // Step 1: Calculate a, b, c
    double a = P2 * (2 * T - P2);
    double b = (S1 * (2 * T * (P1 + P2) - 2 * P1 * P2) - 2 * C * (T - P2));
    double c = (S1 * P1 * (2 * T - P1) - 2 * C * (T - P1)) * S1;

    print("a : ${a}");
    print("b : ${b}");
    print("c : ${c}");
    // Step 2: Calculate discriminant (b² - 4ac)
    double discriminant = pow(b, 2) - 4 * a * c;

    print("discriminant : ${discriminant}");
    // Step 3: Calculate x using quadratic formula
    if (discriminant < 0) {
      throw Exception("No real solution for x (discriminant < 0)");
    }
    double sqrtDisc = sqrt(discriminant);
    double x1 = (-b + sqrtDisc) / (2 * a);
    double x2 = (-b - sqrtDisc) / (2 * a);

    print("sqrtDisc : ${sqrtDisc}");
    print("x1 : $x1");
    print("x2 : $x2");
    // We'll assume the positive x makes practical sense (number of stocks)
    // double x = x1 > 0 ? x1 : x2;
    double x = x1 > x2 ? x1 : x2;

    // Step 4: Calculate P (average price)
    double P = (S1 * P1 + x * P2) / (S1 + x);

    // Step 5: Calculate R (rate of sell)
    // R = ((S1 + x) * T - P) / (pow(S1 + x, 2) / (S1 * T + x * T - S1 * P1 - x * P2));
    R = (S1 + x) / (T - P);

    // Step 6: Final value of stocks to buy or sell at P2
    // double finalValue = S1 + x - R * P2 - P - S1;
    double finalValue = x - R * (P2 - P);

    priorBuyInitialPurchasePrice = P;
    priorBuyInitialBuyQuantity = finalValue;
    priorBuyRateOfSell = R;
    priorBuyXDash = x;

    print("below is priorBuyInitialBuyQuantity");
    print(priorBuyInitialBuyQuantity);
    print("P");
    print(priorBuyInitialPurchasePrice);

    return {
      'x': x,
      'P': P,
      'R': R,
      'finalValue': finalValue,
    };
  }

  Future<double> calculatePriorBuyStepAbove({
    required double targetPrice,
    required double stepSize
  }) async {

    print("print inside calculatePriorBuyStepAbove");
    print(targetPrice);
    print(stepSize);

    double stepAbove = (targetPrice - priorBuyInitialPurchasePrice) / stepSize;

    numberOfStepsAboveController.text = stepAbove.toStringAsFixed(2);
    print(numberOfStepsAboveController.text);

    return stepAbove;
  }

  Future<double> calculateStepSize({
    required double stepAbove,
    required double initialPurchasePrice
  }) async {
    double stepSize = (targetPrice - initialPurchasePrice) / stepAbove;

    stepSizeController.text = stepSize.toStringAsFixed(2);
    ladderCreationParametersScreen3.calculatedStepSize = stepSize;

    return stepSize;
  }

  Future<double> calculateStepAbove({
    required double stepSize,
    required double initialPurchasePrice
  }) async {

    double stepAbove = (targetPrice - initialPurchasePrice) / stepSize;

    numberOfStepsAboveController.text = stepAbove.toStringAsFixed(2);

    double stepSizeTemp = (targetPrice - initialPurchasePrice) / stepAbove;

    ladderCreationParametersScreen3.calculatedStepSize = stepSizeTemp;
    // numberOfStepsAbove = stepSize.toStringAsFixed(2);
    // ladderCreationParametersScreen3.calculatedStepSize = stepSize;

    return stepAbove;
  }

  Future<double> calculatePriorBuyStepSize({
    required double targetPrice,
    required double stepAbove
  }) async {

    print("print inside calculatePriorBuyStepSize");
    print(targetPrice);
    print(stepAbove);

    double stepSize = (targetPrice - priorBuyInitialPurchasePrice) / stepAbove;
    stepSizeController.text = stepSize.roundTo2().toStringAsFixed(2);

    double calculatedStepAbove = ((targetPrice - priorBuyInitialPurchasePrice) / stepSize).roundTo2();

    ladderCreationParametersScreen3.calculatedNumberOfStepsAbove = calculatedStepAbove;
    ladderCreationParametersScreen3.numberOfStepsBelow = (priorBuyInitialPurchasePrice / stepSize).floor();

    print(stepSizeController.text);
    print(ladderCreationParametersScreen3.calculatedNumberOfStepsAbove);
    print(ladderCreationParametersScreen3.numberOfStepsBelow);
    return stepSize;
  }

  Future<double> calculatePriorBuyOrderSize({
    required double stepAbove
  }) async {

    print("print inside calculatePriorBuyStepSize");
    print(stepAbove);

    // double orderSize = ((double.tryParse(priorBuyStockQuantityTextController.text) ?? 0) + priorBuyXDash) / stepAbove;
    double orderSize = (double.tryParse(stepSizeController.text) ?? 0) * priorBuyRateOfSell;

    orderSize = orderSize.floorToDouble();

    double calculatedStepSize = orderSize / priorBuyRateOfSell;

    buySellQtyController.text = orderSize.toStringAsFixed(2);

    ladderCreationParametersScreen3.calculatedStepSize = calculatedStepSize;

    print(buySellQtyController.text);
    print(ladderCreationParametersScreen3.calculatedStepSize);

    return orderSize;
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

  double _minStepAbove = 15;

  double get minStepAbove => _minStepAbove;

  set minStepAbove(double value) {
    _minStepAbove = value;
    notifyListeners();
  }

  double _maxStepAbove = 0;

  double get maxStepAbove => _maxStepAbove;

  set maxStepAbove(double value) {
    _maxStepAbove = value;
    notifyListeners();
  }

  Future<double> calculateMinStepSize ({
    required double currentPrice,
    required double capital,
    required double targetPrice
  }) async {

    double minStepSizeTemp = sqrt(200 * (currentPrice / capital) * (targetPrice - (currentPrice / 2)));

    minStepSize = minStepSizeTemp;
    return minStepSize;
  }

  Future<double> calculateMaxStepSize({
    required double currentPrice,
    required double capital,
    required double targetPrice
  }) async {

    double maxStepSizeTemp = (targetPrice - currentPrice) / 15;

    maxStepSize = maxStepSizeTemp;

    return maxStepSize;
  }

  Future<double> calculateMaxStepAbove({
    required double currentPrice,
    required double targetPrice,
    required double minStepSize
  }) async {

    double maxStepAboveTemp = (targetPrice - currentPrice) / minStepSize;

    maxStepAbove = maxStepAboveTemp;

    return maxStepAbove;
  }

  Future<double> calculateMinStepAbove({
    required double currentPrice,
    required double targetPrice,
    required double maxStepSize
  }) async {

    double minStepAboveTemp = (targetPrice - currentPrice) / maxStepSize;

    minStepAbove = minStepAboveTemp;

    return minStepAbove;
  }

  double _minRatio = 0;

  double get minRatio => _minRatio;

  set minRatio(double value) {
    _minRatio = value;
    notifyListeners();
  }

  double _maxRatio = 0;

  double get maxRatio => _maxRatio;

  set maxRatio(double value) {
    _maxRatio = value;
    notifyListeners();
  }

  Future<double> calculatePriorBuyStockQuantityAndCapitalMinRatio({
    required double currentPrice,
    required double targetPrice,
    required double priorStockPrice
  }) async {

    double z = (1 - (currentPrice / targetPrice));

    double minRatio = ((priorStockPrice - currentPrice) * (1 - sqrt(1 -pow(z, 2)))) / pow(z, 2);

    return minRatio;
  }

  Future<double> calculatePriorBuyStockQuantityAndCapitalMaxRatio({
    required double currentPrice,
    required double targetPrice,
    required double priorStockPrice
  }) async {

    print("calculatePriorBuyStockQuantityAndCapitalMaxRatio");
    print(currentPrice);
    print(targetPrice);
    print(priorStockPrice);

    double z = (1 - (currentPrice / targetPrice));

    print(z);

    double maxRatioTemp = ((priorStockPrice - currentPrice) * (1 + sqrt(1 -pow(z, 2)))) / pow(z, 2);

    print(maxRatioTemp);

    maxRatio = maxRatioTemp;

    return maxRatioTemp;
  }

  Future<double> calculateMinCapitalForPriorBuy({
    required double maxRatioTemp,
    required double priorStockQuantity,
  }) async {

   double minC = maxRatioTemp * priorStockQuantity;

    return minC;
  }

  Future<double> calculateMaxPriorBuyStocks({
    required double maxRatioTemp,
    required double capital,
  }) async {

    double maxP = capital / maxRatioTemp;

    return maxP;
  }



}
