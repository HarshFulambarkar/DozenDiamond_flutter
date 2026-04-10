import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../global/services/num_formatting.dart';

import '../../global/services/stock_price_listener.dart';
import '../models/ladder_creation_screen2.dart';
import '../models/ladder_creation_screen3.dart';
import '../models/ladder_creation_screen_bundle.dart';
import '../models/ladder_creation_tickers_response.dart';

import '../models/ladder_creation_screen1.dart';

import '../service/rest_api_service.dart';

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

  double? _accountCashForNewLadders;
  double? _accountUnallocatedCash;
  double? _accountExtraCashLeft;
  double? _accountExtraCashGenerated;

  List<TextEditingController> _cashAllocatedControllerList = [];

  List<TextEditingController> get cashAllocatedControllerList =>
      _cashAllocatedControllerList;

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
          ladderCreationParametersScreen1.targetPriceMultiplier!.text) ??
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

  int get numberOfStepsAbove =>
      int.tryParse(ladderCreationParametersScreen3.numberOfStepsAbove!.text
          .replaceAll(',', '')) ??
      0;

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

  double get cashLeft => ladderCreationParametersScreen3.cashLeft ?? 0.0;

  double get actualCashAllocated =>
      ladderCreationParametersScreen3.actualCashAllocated ?? 0.0;

  TextEditingController get initialBuyPriceController =>
      ladderCreationParametersScreen1.clpInitialPurchasePrice!;

  TextEditingController get targetPriceMultiplierController =>
      ladderCreationParametersScreen1.targetPriceMultiplier!;

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

  set updateCeilingBuySellQtyBool(bool ceil) {
    _ceilBuySellQty = ceil;
    updateLimitCashNeeded(false);
    _calculateBuySellQty();

    _calculateCashLeft(40);

    notifyListeners();
  }

  set numberOfStepsAbove(int value) {
    _ladderCreationScreen3[index].numberOfStepsAbove =
        TextEditingController(text: intToUnits(value));
    notifyListeners();
  }

  void updateTargetPrice(
      String stringTargetPrice, String stringAfterDecimal, int cursorOffset) {
    double? parsedTargetPrice = double.tryParse(stringTargetPrice);
    if (parsedTargetPrice != null &&
        parsedTargetPrice < initialBuyPrice * 1.2) {
      updateTargetPriceWarning =
          "*Target price can't be smaller than 1.2 times initial buy Price";
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
    _calculateActualInitialBuyCash();
    _calculateInitialBuyQty();
    _calculateBuySellQty(defaultValCalculations: true);
    _calculateStepSize();
    notifyListeners();
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

          _calculateCashLeft(numberOfStepsAboveTemp);

          _calculateCashNeeded(numberOfStepsAboveTemp);

          if (cashNeeded > cashLeft) {
            numberOfStepsAboveTemp--;
            print(
                "cashLeft>cashNeeded\nnow finally we have made it $numberOfStepsAboveTemp");
            updateNumberOfStepsAbove(numberOfStepsAboveTemp.toString(), 0);

            double defBuySellQtyInitialBuyQty = (double.tryParse(
                    _ladderCreationScreen3[index]
                        .clpDefaultBuySellQuantity!
                        .text) ??
                0.0);
            _ladderCreationScreen2[index].clpInitialBuyQuantity!.text =
                intToUnits((defBuySellQtyInitialBuyQty * numberOfStepsAboveTemp)
                    .floor());
            // _calculateInitialBuyQty(forLimitCash: true);

            _calculateStepSize(byUsingNumberOfStepsAbove: true);

            _calculateNumberOfStepsBelow();

            _calculateCashLeft(numberOfStepsAboveTemp);

            _calculateCashNeeded(numberOfStepsAboveTemp);

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

            double defBuySellQtyInitialBuyQty = (double.tryParse(
                    _ladderCreationScreen3[index]
                        .clpDefaultBuySellQuantity!
                        .text) ??
                0.0);
            _ladderCreationScreen2[index].clpInitialBuyQuantity!.text =
                intToUnits((defBuySellQtyInitialBuyQty * numberOfStepsAboveTemp)
                    .floor());

            _ladderCreationScreen3[index].cashLeft =
                _ladderCreationScreen3[index].cashNeeded;
            _calculateStepSize(byUsingNumberOfStepsAbove: true);
            break;
          }
          numberOfStepsAboveTemp--;

          _calculateCashLeft(numberOfStepsAboveTemp);
          print("here is the updateLimitCashNeeded cashLeft $cashLeft");
          _calculateCashNeeded(numberOfStepsAboveTemp);
          print("here is the updateLimitCashNeeded cashNeeded $cashNeeded");
        }
      }
    } else {
      numberOfStepsAbove = 40;
      _ladderCreationScreen3[index].numberOfStepsAbove!.text =
          intToUnits(numberOfStepsAbove);

      _calculateCashLeft(numberOfStepsAbove);
      _calculateCashNeeded(numberOfStepsAbove);
      _calculateStepSize(byUsingNumberOfStepsAbove: true);
      _calculateInitialBuyQty(forLimitCash: true);
    }
    _calculateActualCashAllocated();
    print(
        "here is the initialBuyQuantity ${_ladderCreationScreen2[index].clpInitialBuyQuantity!.text}");
    notifyListeners();
  }

  void reorderStocksInList(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      --newIndex;
    }
    // LadderCreationScreenBundle item = _stockLadderParameters.removeAt(oldIndex);
    // _stockLadderParameters.insert(newIndex, item);

    LadderCreationScreen1 item1 = _ladderCreationScreen1.removeAt(oldIndex);
    _ladderCreationScreen1.insert(newIndex, item1);

    LadderCreationScreen2 item2 = _ladderCreationScreen2.removeAt(oldIndex);
    _ladderCreationScreen2.insert(newIndex, item2);

    LadderCreationScreen3 item3 = _ladderCreationScreen3.removeAt(oldIndex);
    _ladderCreationScreen3.insert(newIndex, item3);

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
    _calculateCashNeeded(int.tryParse(
            _ladderCreationScreen3[index].numberOfStepsAbove?.text ?? "0") ??
        0);
    _calculateCashLeft(int.tryParse(
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
    int parsedNumberOfStepsAbove =
        int.tryParse(stringNumberOfStepsAbove ?? "") ?? 0;

    _ladderCreationScreen3[index].numberOfStepsAbove!.text =
        intToUnits(parsedNumberOfStepsAbove);
    notifyListeners();
  }

  void updateTargetPriceMultiplier(
      String? stringTargetPriceMultiplier, int cursorOffset) {
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
    if (parsedStepSize != 0.0) {
      updateCurrentStockValues(
          valueType: StockValueType.stepSize,
          value: stringStepsize!,
          valueAfterDecimal: stringAfterDecimal,
          cursorOffset: cursorOffset);
      _calculateBuySellQty();
      if (buySellQty > initialBuyQty) {
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
            intToUnits(int.tryParse(value ?? "0") ?? 0);
        _ladderCreationScreen2[index].clpInitialBuyQuantity!.value =
            TextEditingValue(
          text: unitsFormattedInitialBuyQty,
          selection: TextSelection.fromPosition(
            TextPosition(
                offset: cursorOffset -
                    (_ladderCreationScreen2[_index]
                            .clpInitialBuyQuantity!
                            .text
                            .length -
                        unitsFormattedInitialBuyQty.length)),
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
        _ladderCreationScreen1[index].targetPriceMultiplier!.value =
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
      _ladderCreationScreen2[index].clpInitialBuyQuantity!.text =
          intToUnits((defBuySellQtyInitialBuyQty * numberOfStepsAbove).floor());
    } else {
      if (targetPrice > 0 && targetPrice > initialBuyPrice) {
        _ladderCreationScreen2[index].clpInitialBuyQuantity!.text =
            intToUnits(((cashAllocated / initialBuyPrice) * (k1 / k2)).floor());
      } else {}
    }
    print(
        "virtual ${defBuySellQtyInitialBuyQty} and $numberOfStepsAbove calculated initialBuyQty ${_ladderCreationScreen2[index].clpInitialBuyQuantity!.text}");
  }

  void _calculateTargetPrice() {
    if (targetPriceMultiplier < 1.2) {
      updateTargetPriceWarning =
          "*Target price can't be smaller than 1.2 times initial buy Price";
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
    _ladderCreationScreen1[index].targetPriceMultiplier!.text =
        (targetPrice / initialBuyPrice).toStringAsFixed(2);
  }

  void _calculateBuySellQty({bool defaultValCalculations = false}) {
    int divisor = defaultValCalculations ? 40 : numberOfStepsAbove;

    double calculatedBuySellQty = initialBuyQty / divisor;

    int finalBuySellQty = ceilBuySellQty
        ? calculatedBuySellQty.ceil()
        : calculatedBuySellQty.floor();

    if (finalBuySellQty <= 0) {
      finalBuySellQty = 1;
    }

    _ladderCreationScreen3[index].clpDefaultBuySellQuantity!.text =
        intToUnits(finalBuySellQty);

    print("Calculated buySellQty for initialBuyQty: $initialBuyQty, "
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
        "calculated actualInitialBuyCash ${_ladderCreationScreen2[index].actualInitialBuyCash}");
  }

  void _calculateStepSize({byUsingNumberOfStepsAbove = false}) {
    if (byUsingNumberOfStepsAbove) {
      print(
          "targetPrice is $targetPrice, and NumberOfStepsAbove is $numberOfStepsAbove");
      _ladderCreationScreen3[index].clpStepSize!.text = amountToInrFormatCLP(
          ((targetPrice - initialBuyPrice) / numberOfStepsAbove),
          decimalDigit: 2);
    } else {
      _ladderCreationScreen3[index].clpStepSize!.text = amountToInrFormatCLP(
          ((targetPrice - initialBuyPrice) /
              (initialBuyQty / buySellQty).floor()),
          decimalDigit: 2);
    }
    print(
        "calculated stepSize ${_ladderCreationScreen3[index].clpStepSize!.text}");
    _calculateNumberOfStepsBelow();
  }

  void _calculateNumberOfStepsBelow() {
    int numberOfStepsBelowTemp = (initialBuyPrice / stepSize).floor();
    _ladderCreationScreen3[index].numberOfStepsBelow = numberOfStepsBelowTemp;
    print(
        " calculated numberOfStepsBelow $initialBuyPrice and $targetPrice and $initialBuyPrice and $numberOfStepsAbove and ${_ladderCreationScreen3[index].numberOfStepsBelow}");
  }

  void _calculateCashNeeded(int numberOfStepsAboveTemp) {
    print("inside _calculateCashNeeded222");
    _calculateBuySellQty();
    _ladderCreationScreen3[index].cashNeeded =
        (buySellQty * numberOfStepsAboveTemp * (initialBuyPrice / 2));
    print("calculated cashNeeded ${_ladderCreationScreen3[index].cashNeeded}");
  }

  void _calculateCashLeft(int numberOfStepsAboveTemp) {
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
    _ladderCreationScreen3[index].actualCashAllocated =
        ((buySellQty * numberOfStepsAbove * initialBuyPrice) + cashNeeded);
    print(
        "calculated actualCashAllocated ${_ladderCreationScreen3[index].actualCashAllocated}");
  }

  void addListOfStocksAndLadders(
      List<LadderCreationScreenBundle> ladderCreationBundles) {
    _ladderCreationScreen1 =
        ladderCreationBundles.expand((bundle) => bundle.screen1List).toList();
    _ladderCreationScreen2 =
        ladderCreationBundles.expand((bundle) => bundle.screen2List).toList();
    _ladderCreationScreen3 =
        ladderCreationBundles.expand((bundle) => bundle.screen3List).toList();

    notifyListeners();
  }

  void removeSingleStockAndLadders(int index) {
    if (_index >= 0) {
      _index = -1;
    }
    _stockLadderParameters.removeAt(index);
    _ladderCreationScreen1.removeAt(index);
    _ladderCreationScreen2.removeAt(index);
    _ladderCreationScreen3.removeAt(index);
    notifyListeners();
  }

  void resetIbqToEstInitialBuyCashQty() {
    if (initialBuyQtyWarning.length > 0) {
      _ladderCreationScreen2[index].clpInitialBuyQuantity!.text =
          intToUnits(((cashAllocated / initialBuyPrice) * (k1 / k2)).floor());
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

  Future<bool> getUserStockAndLadder() async {
    print("inside getUserStockAndLadder");
    try {
      LadderCreationTickerResponse? value =
          await RestApiService().fetchLadderCreationTickers();

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
        cashAllocatedControllerList.clear();
        List<LadderCreationScreenBundle> ladderCreationBundleTemp = [];
        for (var tickerAndLadderData in value.data!.ladderCreationTickerList!) {
          int numberOfStepsAbove = 40;
          double targetPriceMultiplier = 2;
          double initialBuyPrice =
              double.tryParse(tickerAndLadderData.ssCurrentPrice ?? "0.0") ??
                  0.0;
          double minimumPrice = 0.0;
          double targetPrice = (targetPriceMultiplier * (initialBuyPrice));
          double k = targetPrice / initialBuyPrice;
          double cashAllocated =
              double.tryParse(tickerAndLadderData.ssCashAllocated ?? "0.0") ??
                  0.0;
          cashAllocatedControllerList.add(TextEditingController(
            text: amountToInrFormatCLP(cashAllocated,
                decimalDigit: 2, showSymbol: false),
          ));
          double initialBuyCash =
              (((2 * k) - 2) / ((2 * k) - 1)) * cashAllocated;
          int initialBuyQty = (initialBuyCash / initialBuyPrice).floor();
          double actualInitialBuyCash = initialBuyQty * initialBuyPrice;
          // Calculations for LadderCreationScreen3
          double stepSize =
              (targetPrice - initialBuyPrice) / numberOfStepsAbove;
          int numberOfStepsBelow = (initialBuyPrice / stepSize).floor();
          int buySellQty = (initialBuyQty / numberOfStepsAbove).ceil();
          double cashNeeded = buySellQty *
              numberOfStepsBelow *
              (initialBuyPrice / targetPriceMultiplier);
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
            targetPriceMultiplier: TextEditingController(text: "2.00"),
            clpTargetPrice: TextEditingController(
                text: amountStringSplittedFormatted(
                    targetPrice.toStringAsFixed(2))),
            clpMinimumPrice: TextEditingController(
                text: amountStringSplittedFormatted(minimumPrice.toString())),
          );
          // Create LadderCreationScreen2 instance
          LadderCreationScreen2 screen2 = LadderCreationScreen2(
            initialPurchasePrice: TextEditingController(
                text: amountStringSplittedFormatted(
                    tickerAndLadderData.ssCurrentPrice)),
            targetPrice: TextEditingController(
                text: amountStringSplittedFormatted(
                    targetPrice.toStringAsFixed(2))),
            targetPriceMultiplier: TextEditingController(text: "2.00"),
            clpCashAllocated: TextEditingController(
                text: amountStringSplittedFormatted(
                    tickerAndLadderData.ssCashAllocated)),
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
        }

        // Now add the complete list of bundles
        addListOfStocksAndLadders(ladderCreationBundleTemp);
        notifyListeners();
        return false;
      } else {
        return true;
      }
    } catch (e) {
      print("error caught in the getUserStockAndLadder api");
      throw e;
    }
  }
}
