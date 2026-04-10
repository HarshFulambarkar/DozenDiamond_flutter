import 'dart:async';

import 'package:dozen_diamond/AB_Ladder/stateManagement/buy_sell_provider.dart';
import 'package:dozen_diamond/ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:dozen_diamond/past_data_graphical_view/statemangement/past_data_provider.dart';

import '../../Settings/stateManagement/theme_provider.dart';
import '../../global/services/num_formatting.dart';
import '../models/create_ladder_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../models/create_ladder_response.dart';
import '../models/delete_ladder_request.dart';
import '../../AB_ladder/models/ladder_list_model.dart';
import '../../AB_ladder/widgets/line_chart_sample4.dart';
import '../../AB_ladder/widgets/stockladder1.dart';

import '../models/toggle_laddder_activation_status_request.dart';
import '../services/ladder_rest_api_service.dart';

class CurrentStepSize {
  double currentStepSize = 5.0;
}

bool _isVisible = true;

var noOfSharesBoughtAndSoldAtEveryStep = 2.0;

class ReviewLadderDialog extends StatefulWidget {
  final int tickerId;
  final double initialyProvidedTargetPrice;
  final String stockName;
  final String initialPurchasePrice;
  final String currentStockPrice;
  final double minimumPriceForUpdateLadder;
  final double allocatedCash;
  final Function? updateLadderList;
  final int? ladderId;
  final String? ladStatus;
  final String? ladderName;
  final bool? isMarketOrder;
  final int setDefaultBuySellQty;
  final int initialBuyQty;
  final bool? newLadder;
  final int? symSecurityCode;
  final double stepSize;
  final double cashNeeded;
  final double numberOfStepsAbove;
  final int numberOfStepsBelow;
  final double actualCashAllocated;
  final double actualInitialBuyCash;
  final double ladTargetPriceMultiplier;
  final bool inTradePage;
  final double assignedCash;

  ReviewLadderDialog({
    Key? key,
    this.inTradePage = false,
    required this.initialyProvidedTargetPrice,
    required this.numberOfStepsAbove,
    required this.numberOfStepsBelow,
    required this.actualInitialBuyCash,
    this.initialPurchasePrice = "0.0",
    required this.currentStockPrice,
    required this.allocatedCash,
    this.stockName = "",
    required this.tickerId,
    required this.stepSize,
    this.minimumPriceForUpdateLadder = 0.0,
    this.updateLadderList,
    this.ladderId,
    this.ladStatus,
    this.ladderName,
    required this.cashNeeded,
    this.isMarketOrder = false,
    required this.initialBuyQty,
    required this.setDefaultBuySellQty,
    this.newLadder = true,
    this.symSecurityCode,
    required this.actualCashAllocated,
    this.ladTargetPriceMultiplier = 0,
    this.assignedCash = 0,
  }) : super(key: key);

  @override
  State<ReviewLadderDialog> createState() => _ReviewLadderDialogState();
}

class _ReviewLadderDialogState extends State<ReviewLadderDialog> {
  late TradeMainProvider tradeMainProvider;
  late ThemeProvider themeProvider;
  ScrollController _dialogBoxScrollController = ScrollController();
  BuySellProvider? _buySellProvider;
  var graphicalModeEnable = false;
  double _initialBuyPrice = 0.0;
  double _stepSize = 0.0;
  double _minimumPrice = 0.0;
  double _targetPrice = 0.0;
  int _noOfStepsAboveInitialPurchasePrice = 0;
  int _noOfStepsBelowPurchasePrice = 0;
  int _initialBuyQty = 0;
  int _defaultBuySellQty = 0;
  bool _loadingHistoricalData = true;
  bool _symbolDataAvailable = true;
  bool _continueTradingAfterHittingTargetPrice = false;

  final List<double> _ladderLinesValueAboveCP = [];
  final List<double> _ladderLinesValueBelowCP = [];
  final List<String> _stoocksBoughtSoldQtyAboveCp = [];
  final List<String> _stoocksBoughtSoldQtyBelowCp = [];
  final List<int> _stocksHeldAboveCP = [];
  final List<int> _stocksHeldBelowCP = [];

  VoidCallback? _updateSrollToCpCellFunction;

  double _progress = 0.0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _buySellProvider = Provider.of(context, listen: false);
    getHistoricalData();
    assignInitialValuesToVariables();
    _startProgress();
  }

  void _startProgress() {
    const duration = Duration(milliseconds: 100);
    _timer = Timer.periodic(duration, (Timer timer) {
      setState(() {
        if (_progress >= 1) {
          _timer.cancel();
        } else {
          _progress += 0.01;
        }
      });
    });
  }

  void assignInitialValuesToVariables() {
    _initialBuyPrice = double.tryParse(widget.initialPurchasePrice) ?? 0.0;
    _stepSize = widget.stepSize;
    _minimumPrice = widget.minimumPriceForUpdateLadder;
    _targetPrice = widget.initialyProvidedTargetPrice;
    _noOfStepsAboveInitialPurchasePrice = widget.numberOfStepsAbove.toInt();
    _noOfStepsBelowPurchasePrice = widget.numberOfStepsBelow;
    _initialBuyQty = widget.initialBuyQty;
    _defaultBuySellQty = widget.setDefaultBuySellQty;

    _updateLadder(useDefaultBuySellQty: false);
  }

  @override
  void dispose() {
    super.dispose();
    _buySellProvider!.clearHistoricalData();
    _buySellProvider!.resetAllVariable();

    _timer.cancel();
  }

  void getHistoricalData() async {
    try {
      await _buySellProvider!.getHistoricalDataOfStock(widget.stockName!);
      _loadingHistoricalData = false;
      _updateState();
    } on HttpApiException catch (err) {
      if (err.errorCode == 404 &&
          err.errorTitle == "The symbol name is not found.") {
        _loadingHistoricalData = false;
        _symbolDataAvailable = false;
        _updateState();
      } else {
        print(err);
      }
    }
  }

  void updateCpCellSrollFunction(VoidCallback fun) {
    _updateSrollToCpCellFunction = fun;
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  void ladderLinesValue() {
    print("in side ladderLinesValue");
    print(_noOfStepsAboveInitialPurchasePrice);
    _ladderLinesValueAboveCP.add(_initialBuyPrice.toDouble());
    var tempSum = _initialBuyPrice + _stepSize;
    _ladderLinesValueAboveCP.insert(0, tempSum.toDouble());
    for (var i = 1; i < _noOfStepsAboveInitialPurchasePrice; i++) {
      print(i);

      if (i == _noOfStepsAboveInitialPurchasePrice - 1) {
        print("below is step size");
        print(_stepSize);

        // tempSum = tempSum + _stepSize;
        tempSum += _stepSize;
        // tempSum = double.parse(tempSum.toStringAsFixed(2)) + double.parse(_stepSize.toStringAsFixed(2));
        _ladderLinesValueAboveCP.insert(0, tempSum.toDouble());

        // tempSum = double.parse(tempSum.toStringAsFixed(2)) + ((double.parse(widget.numberOfStepsAbove.toStringAsFixed(0)) - double.parse(_noOfStepsAboveInitialPurchasePrice.toStringAsFixed(2))) * double.parse(_stepSize.toStringAsFixed(2)));
        tempSum = tempSum +
            ((widget.numberOfStepsAbove - _noOfStepsAboveInitialPurchasePrice) *
                _stepSize);

        // _ladderLinesValueAboveCP.insert(0, tempSum.toDouble());
        _ladderLinesValueAboveCP.insert(0, _targetPrice.toDouble());
      } else {
        // tempSum = tempSum + _stepSize;
        tempSum += _stepSize;
        // tempSum = double.parse(tempSum.toStringAsFixed(2)) + double.parse(_stepSize.toStringAsFixed(2));
        _ladderLinesValueAboveCP.insert(0, tempSum.toDouble());
      }
    }
    var tempSum1 = _initialBuyPrice - _stepSize;
    _ladderLinesValueBelowCP.add(tempSum1.toDouble());
    for (var i = 1; i < _noOfStepsBelowPurchasePrice; i++) {
      tempSum1 -= _stepSize;
      if (tempSum1 > 0) {
        if (tempSum1 >= _minimumPrice) {
          _ladderLinesValueBelowCP.add(tempSum1.toDouble());
        }
      }
    }
    _stocksHeldAboveCP.add(_initialBuyQty.toInt());
    var tempSum2 = _initialBuyQty.toInt() - _defaultBuySellQty;

    _stocksHeldAboveCP.insert(0, tempSum2);
    for (var i = 1; i < _noOfStepsAboveInitialPurchasePrice; i++) {
      if (i == _noOfStepsAboveInitialPurchasePrice - 1) {
        tempSum2 -= _defaultBuySellQty;
        _stocksHeldAboveCP.insert(0, tempSum2);

        tempSum2 = tempSum2 - (widget.initialBuyQty + tempSum2);
        _stocksHeldAboveCP.insert(0, tempSum2);
      } else {
        tempSum2 -= _defaultBuySellQty;
        _stocksHeldAboveCP.insert(0, tempSum2);
      }
    }
    var tempSum3 = _initialBuyQty.toInt() + _defaultBuySellQty;
    _stocksHeldBelowCP.add(tempSum3);
    for (var i = 1; i < _noOfStepsBelowPurchasePrice; i++) {
      tempSum3 += _defaultBuySellQty;
      _stocksHeldBelowCP.add(tempSum3);
    }

    for (var i = 0; i < _ladderLinesValueAboveCP.length; i++) {
      _stoocksBoughtSoldQtyAboveCp.add(_defaultBuySellQty.toString());
    }
    for (var i = 0; i < _ladderLinesValueBelowCP.length; i++) {
      _stoocksBoughtSoldQtyBelowCp.add(_defaultBuySellQty.toString());
    }
    if (_stocksHeldAboveCP.first < 0) {
      final tempSb = _stocksHeldAboveCP[1].toString();
      _stocksHeldAboveCP.replaceRange(0, 1, [0]);
      _stoocksBoughtSoldQtyAboveCp.replaceRange(0, 1, [tempSb]);
    } else if ((_stocksHeldAboveCP.first != 0 &&
        _stocksHeldAboveCP.first <
            double.parse(_stoocksBoughtSoldQtyAboveCp.first))) {
      _stocksHeldAboveCP.first = 0;
      _stoocksBoughtSoldQtyAboveCp.first = _stocksHeldAboveCP[1].toString();
    }
    final lastLLV = _ladderLinesValueBelowCP.last;
    final result = lastLLV - _minimumPrice;
    final halfStepSize = _stepSize / 2;
    if (result >= halfStepSize) {
      final tempLastShbcp = _stocksHeldBelowCP.last;
      _stocksHeldBelowCP.add(tempLastShbcp + _defaultBuySellQty);
      _stoocksBoughtSoldQtyBelowCp.add(_defaultBuySellQty.toString());
      _ladderLinesValueBelowCP.add(_minimumPrice);
    }
  }

  void _updateLadder({bool useDefaultBuySellQty = true}) {
    _ladderLinesValueAboveCP.clear();
    _ladderLinesValueBelowCP.clear();
    _stoocksBoughtSoldQtyAboveCp.clear();
    _stoocksBoughtSoldQtyBelowCp.clear();
    _stocksHeldAboveCP.clear();
    _stocksHeldBelowCP.clear();
    ladderLinesValue();
    graphicalModeEnable = false;
    if (_updateSrollToCpCellFunction != null) {
      _updateSrollToCpCellFunction!();
      Future.delayed(const Duration(milliseconds: 100))
          .then((value) => setState(_updateSrollToCpCellFunction!));
    }
  }

  List<LadderListModel> ladderList = [];

  void deleteLadder() async {
    try {
      if (widget.ladStatus == "ACTIVE") {
        await LadderRestApiService().toggleLadderActivationStatus(
          ToggleLadderActivationStatusRequest(
              ladId: widget.ladderId,
              ladStatus: "INACTIVE",
              ladReinvestExtraCash: false),
        );
      }
      String? res =
          await LadderRestApiService().deleteLadder(DeleteLadderRequest(
        ladId: widget.ladderId,
      ));
      Fluttertoast.showToast(msg: res);
      Navigator.pop(context);
      widget.updateLadderList!();
    } on HttpApiException catch (err) {
      print(err);
    }
  }

  Future<void> createLadderRequest() async {
    try {
      double extraCash = await getExtraCashPerMonthOfAStock(
          stockName: widget.stockName,
          initialBuyPrice: double.tryParse(widget.initialPurchasePrice) ?? 0.0,
          targetPrice: _targetPrice,
          noOfStepsAbove: widget.numberOfStepsAbove,
          noOfStepsBelow: widget.numberOfStepsBelow,
          defaultBuySellQty: _defaultBuySellQty,
          stepSize: _stepSize,
          initialBuyQty: _initialBuyQty);
      print("here is the extraCash that is sending ${extraCash}");
      CreateLadderResponse? res = await LadderRestApiService().createLadder(
        CreateLadderRequest(
            ladTickerId: widget.tickerId,
            ladDefaultBuySellQuantity: _defaultBuySellQty,
            ladInitialBuyQuantity: _initialBuyQty,
            ladInitialBuyPrice: double.tryParse(widget.initialPurchasePrice),
            ladMinimumPrice: 0,
            ladTargetPrice: _targetPrice,
            ladCashAllocated: widget.allocatedCash,
            ladCashNeeded: widget.cashNeeded,
            ladNumOfStepsAbove: widget.numberOfStepsAbove,
            ladNumOfStepsBelow: widget.numberOfStepsBelow,
            ladStepSize: _stepSize,
            targetPriceMultiplier: widget.ladTargetPriceMultiplier,
            continueTradingAfterHittingTargetPrice:
                _continueTradingAfterHittingTargetPrice,
            ladCashAssigned: widget.assignedCash,
            estimatedExtraCashPerMonth: extraCash),
      );
      Navigator.of(context).pop("ladderCreated");

      Fluttertoast.showToast(msg: res!.message!);
    } on HttpApiException catch (err) {
      print("error in the createLadder function $err");
      showDialog(
        context: context,
        builder: (context) {
          return errorDialog(err.errorTitle);
        },
      ).then((onValue) {
        if (onValue == 'ladderCreated') {
          Navigator.of(context).pop("ladderCreated");
        }
      });
    }
  }

  Widget errorDialog(String msg) {
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
                        Navigator.of(context).pop("ladderCreated");
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

  Widget continueTradingAfterTargetDialog(String msg) {
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
              color: (themeProvider.defaultTheme)
                  ? Color(0XFFF5F5F5)
                  : Colors.black,
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
                  style: TextStyle(
                    color: (themeProvider.defaultTheme)
                        ? Colors.black
                        : Colors.white,
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
                        _continueTradingAfterHittingTargetPrice = true;
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return saveLadderAlertDialog("Save the ladder?");
                          },
                        );
                      },
                      child: Text(
                        "Yes",
                        style: TextStyle(
                          color: (themeProvider.defaultTheme)
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _continueTradingAfterHittingTargetPrice = false;
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return saveLadderAlertDialog("Save the ladder?");
                          },
                        );
                      },
                      child: const Text(
                        "No",
                        style: TextStyle(
                          color: Colors.red,
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

  Widget saveLadderAlertDialog(String msg) {
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
              color: (themeProvider.defaultTheme)
                  ? Color(0XFFF5F5F5)
                  : Colors.black,
              borderRadius: BorderRadius.circular(
                20,
              ),
              border: Border.all(
                color:
                    (themeProvider.defaultTheme) ? Colors.black : Colors.white,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  msg,
                  style: TextStyle(
                    color: (themeProvider.defaultTheme)
                        ? Colors.black
                        : Colors.white,
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
                        createLadderRequest();
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(
                          color: (themeProvider.defaultTheme)
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.red,
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

  Widget generatedRowWithTextFeild({
    required String title,
    String? hint,
    double? minVal,
    double? maxVal,
    TextEditingController? tEC,
    void Function(String)? onSubmit,
    void Function(String)? onChange,
    bool? readOnly,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 30,
          width: 80,
          child: TextFormField(
            onChanged: onChange,
            controller: tEC,
            onFieldSubmitted: onSubmit,
            style: const TextStyle(
              color: Colors.white,
            ),
            keyboardType: TextInputType.datetime,
            readOnly: readOnly ?? false,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            decoration: InputDecoration(
              hintText: hint,
              errorStyle: const TextStyle(
                color: Colors.white,
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0.7,
                  color: Colors.white,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.white,
                ),
              ),
              hintStyle: const TextStyle(color: Colors.white),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 0,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget noOfTradesProfit(String title, String val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          val,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF0099CC),
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget generateRowWithText([String? title1, String? val1]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            "$title1",
          ),
        ),
        Flexible(
          // flex: 2,
          child: Text(
            "${amountToInrFormat(context, double.tryParse(val1 ?? "0.0"))}",
          ),
        ),
      ],
    );
  }

  Widget checkBox(bool values, void Function(bool?)? onChanges) {
    return Align(
      child: SizedBox(
        width: 20,
        height: 20,
        child: Theme(
          data: ThemeData(unselectedWidgetColor: Colors.white),
          child: Checkbox(
            value: values,
            onChanged: onChanges,
          ),
        ),
      ),
    );
  }

  Widget updateLadderBtn() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            side: const BorderSide(
              color: Color(0xFF0099CC),
            ),
          ),
          onPressed: () {
            setState(
              () {
                _updateLadder(useDefaultBuySellQty: true);
              },
            );
          },
          child: const Text(
            'Update Ladder',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF0099CC)),
          ),
        ),
      ),
    );
  }

  Widget requestReviewBtn() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            side: const BorderSide(
              color: Color(0xFF0099CC),
            ),
          ),
          onPressed: () {
            Fluttertoast.showToast(msg: "This feature will unlock soon!");
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: const Text(
                  'Req Review',
                  style: TextStyle(color: Color(0xFF0099CC)),
                ),
              ),
              Icon(Icons.lock, color: Color(0xFF0099CC), size: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget saveLadderBtn() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5),
        child: ElevatedButton(
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            side: BorderSide(
              color: (themeProvider.defaultTheme)
                  ? Colors.green
                  : Color(0xFF0099CC),
            ),
          ),
          onPressed: () {
            // showDialog(
            //   context: context,
            //   builder: (context) {
            //     return saveLadderAlertDialog("Save the ladder?");
            //   },
            // );
            showDialog(
              context: context,
              builder: (context) {
                return continueTradingAfterTargetDialog(
                    "Do you want to continue trading after ladder hit the target price");
              },
            );
          },
          child: Text(
            'Save Ladder',
            textAlign: TextAlign.center,
            style: TextStyle(
                color:
                    (themeProvider.defaultTheme) ? Colors.white : Colors.white),
          ),
        ),
      ),
    );
  }

  Widget goBackButton() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5),
        child: ElevatedButton(
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            side: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Go back',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget deleteLadderBtn() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
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
                                      "Are you sure you want to delete ladder?",
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            deleteLadder();
                                          },
                                          child: const Text(
                                            "Delete ladder",
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            "Cancel",
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
                      });
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                icon: Icon(Icons.delete),
                label: Text("Delete ladder")),
          )
        ],
      ),
    );
  }

  Widget ladderTitleWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: (themeProvider.defaultTheme)
                      ? Colors.black
                      : Colors.white,
                )),
            Text(
              "Simulation / Review Ladder",
              style: TextStyle(
                color:
                    (themeProvider.defaultTheme) ? Colors.black : Colors.white,
              ),
            ),
          ],
        ),
        stockNameTitle(),
        stockPriceGraphicalViewToggleBtn(),
        historicalDataAvailabilityWarning(),
        SizedBox(height: 10),
        if (!graphicalModeEnable)
          rowElements("Stocks\nHeld", "Stocks\nBought/Sold", "Stock\nPrice"),
      ],
    );
  }

  Widget stockNameTitle() {
    return Row(
      children: [
        SizedBox(width: 20),
        Text(
          widget.stockName,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: (themeProvider.defaultTheme) ? Colors.black : Colors.white,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget stockPriceGraphicalViewToggleBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 22),
            height: 40,
            child: Text(
              "Price: ${numToComma(double.tryParse(widget.currentStockPrice))}",
              style: TextStyle(
                color:
                    (themeProvider.defaultTheme) ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
        _loadingHistoricalData
            ? SizedBox(
                child: CircularProgressIndicator(),
                height: 15,
                width: 15,
              )
            : !_symbolDataAvailable
                ? SizedBox(
                    height: 40,
                  )
                : Container(
                    margin: EdgeInsets.only(right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          graphicalModeEnable
                              ? "Tabular View"
                              : "Graphical View",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: (themeProvider.defaultTheme)
                                ? Colors.black
                                : Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        Switch(
                          inactiveTrackColor: Colors.grey,
                          inactiveThumbColor: Colors.white,
                          activeColor: const Color(0xFF0099CC),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: graphicalModeEnable,
                          onChanged: (value) {
                            if (_ladderLinesValueAboveCP.isNotEmpty ||
                                _ladderLinesValueBelowCP.isNotEmpty) {
                              setState(() {
                                graphicalModeEnable = value;
                                Future.delayed(
                                        const Duration(milliseconds: 100))
                                    .then((value) => setState(() {}));
                              });
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Please update ladder!");
                            }
                          },
                        ),
                      ],
                    ),
                  ),
      ],
    );
  }

  Widget graphicalModeBuySellChart() {
    return Visibility(
      visible: _isVisible,
      child: Container(
        margin: const EdgeInsets.only(right: 13),
        height: MediaQuery.of(context).size.height * 0.35,
        child: Theme(
          data: (themeProvider.defaultTheme)
              ? ThemeData.light()
              : ThemeData.dark(),
          child: LineChartSample4(
            ladderLineValuesAboveCp: _ladderLinesValueAboveCP,
            ladderLineValuesBelowCp: _ladderLinesValueBelowCP,
            stockName: widget.stockName,
            firstPurchasePrice: _initialBuyPrice,
            currentStockPrice: double.tryParse(widget.currentStockPrice) ?? 0.0,
            stepSize: _stepSize,
            defaultBuySellQty: _defaultBuySellQty,
            initialBuyQty: _initialBuyQty,
          ),
        ),
      ),
    );
  }

  Widget tabularModeLadderChart() {
    return Visibility(
      visible: _isVisible,
      child: StockLadder1(
        updateScrollToCpCellFunction: updateCpCellSrollFunction,
        stepSize: _stepSize,
        currentStockPrice: _initialBuyPrice,
        targetPrice: _targetPrice,
        initialBuyQty: _initialBuyQty,
        firstPurchasePrice: _initialBuyPrice,
        ladderLinesValueAboveCP: _ladderLinesValueAboveCP,
        ladderLinesValueBelowCP: _ladderLinesValueBelowCP,
        noOfStepsAbovePurchasePrice: _noOfStepsAboveInitialPurchasePrice,
        noOfStepsBelowPurchasePrice: _noOfStepsBelowPurchasePrice,
        stocksHeldAboveCP: _stocksHeldAboveCP,
        stocksHeldBelowCP: _stocksHeldBelowCP,
        stoocksBoughtSoldQtyBelowCp: _stoocksBoughtSoldQtyBelowCp,
        stoocksBoughtSoldQtyAboveCp: _stoocksBoughtSoldQtyAboveCp,
        defaultBuySellQty: _defaultBuySellQty,
      ),
    );
  }

  Widget targetPriceWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Target Price"),
        Text("${amountToInrFormat(context, _targetPrice)}"),
      ],
    );
  }

  Widget initialPurchasePriceWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Initial purchase price",
          textAlign: TextAlign.center,
        ),
        Text(
          "${amountToInrFormat(context, _initialBuyPrice)}",
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget rowElements(String text1, String text2, String text3,
      {bool currentPriceCell = false, Key? key, bool formatToComma = false}) {
    return IntrinsicHeight(
      key: key,
      child: Row(children: [
        SizedBox(
          width: 23,
        ),
        Flexible(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                  color: (themeProvider.defaultTheme)
                      ? Colors.black
                      : Colors.white,
                  width: 0.5),
            ),
            child: Text(
              text1,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: (themeProvider.defaultTheme)
                      ? Colors.green
                      : Colors.greenAccent,
                  fontSize: 15),
            ),
          ),
        ),
        Flexible(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                  color: (themeProvider.defaultTheme)
                      ? Colors.black
                      : Colors.white,
                  width: 0.5),
            ),
            child: Text(
              text2,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: (themeProvider.defaultTheme)
                      ? Colors.green
                      : Colors.greenAccent,
                  fontSize: 15),
            ),
          ),
        ),
        Flexible(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                  color: (themeProvider.defaultTheme)
                      ? Colors.black
                      : Colors.white,
                  width: 0.5),
            ),
            child: Text(
              text3,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: (themeProvider.defaultTheme)
                      ? Colors.green
                      : Colors.greenAccent,
                  fontSize: 15),
            ),
          ),
        ),
        SizedBox(
          width: 33,
        ),
      ]),
    );
  }

  Widget initialBuyQtyWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Initial Buy Qty",
          textAlign: TextAlign.center,
        ),
        Text(
          "${intToUnits(_initialBuyQty)}",
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget defaultBuySellQtyWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Order Size"),
        Text(intToUnits(_defaultBuySellQty)),
      ],
    );
  }

  Widget minimumPriceWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Minimum Price"),
        Text(amountToInrFormat(context, _minimumPrice) ?? "0")
      ],
    );
  }

  Widget stepSizeWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Step size",
          textAlign: TextAlign.center,
        ),
        Text(
          "${amountToInrFormat(context, _stepSize)}",
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget simulationDurationWidget(BuySellProvider stateProvider) {
    return Row(
      children: [
        const Expanded(
          flex: 2,
          child: Text(
            "Simulation duration",
            // style: TextStyle(
            //   fontWeight: FontWeight.bold,
            //   color: Colors.white,
            //   fontSize: 16,
            // ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              "${stateProvider.simulationDuration}",
              // style: const TextStyle(
              //   color: Color(0xFF0099CC),
              //   fontWeight: FontWeight.bold,
              //   fontSize: 18,
              // ),
            ),
          ),
        ),
      ],
    );
  }

  Widget sharesBoughtSoldPerTradeWidget(BuySellProvider stateProvider) {
    return Row(
      children: [
        const Expanded(
          flex: 2,
          child: Text(
            "Order size",
            // style: TextStyle(
            //   fontWeight: FontWeight.bold,
            //   color: Colors.white,
            //   fontSize: 16,
            // ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              "${stateProvider.sharesBoughtSoldPerTrade}",
              // style: const TextStyle(
              //   color: Color(0xFF0099CC),
              //   fontWeight: FontWeight.bold,
              //   fontSize: 18,
              // ),
            ),
          ),
        ),
      ],
    );
  }

  Widget tradesBuySellWidget(BuySellProvider stateProvider) {
    return Row(
      children: [
        const Expanded(
          flex: 2,
          child: Text(
            "Orders(Buys/Sells)",
            // style: TextStyle(
            //   fontWeight: FontWeight.bold,
            //   color: Colors.white,
            //   fontSize: 16,
            // ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              "${stateProvider.buyInSimulation} / ${stateProvider.sellInSimulation}",
              // style: const TextStyle(
              //   color: Color(0xFF0099CC),
              //   fontWeight: FontWeight.bold,
              //   fontSize: 18,
              // ),
            ),
          ),
        ),
      ],
    );
  }

  Widget stocksBoughtOrSoldAfterInitialPurchase(BuySellProvider stateProvider) {
    bool numberOfBuyTradesHigherThanSell =
        stateProvider.buyInSimulation > stateProvider.sellInSimulation;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            numberOfBuyTradesHigherThanSell ? "Stocks bought" : "Stocks sold",
            // style: TextStyle(
            //   fontWeight: FontWeight.bold,
            //   color: Colors.white,
            //   fontSize: 16,
            // ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              "${intToUnits(stateProvider.netShareQty)}",
              // style: const TextStyle(
              //   color: Color(0xFF0099CC),
              //   fontWeight: FontWeight.bold,
              //   fontSize: 18,
              // ),
            ),
          ),
        ),
      ],
    );
  }

  Widget tradesCashGainWidget(BuySellProvider stateProvider) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            "Trades cash gain",
            // style: TextStyle(
            //   fontWeight: FontWeight.bold,
            //   color: Colors.white,
            //   fontSize: 16,
            // ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              amountToInrFormat(
                      context, stateProvider.simulationTradesCashGain) ??
                  "N/A",
              // style: TextStyle(
              //   color: Color(0xFF0099CC),
              //   fontWeight: FontWeight.bold,
              //   fontSize: 18,
              // ),
            ),
          ),
        ),
      ],
    );
  }

  Widget averagePurchasePriceWidget(BuySellProvider stateProvider) {
    bool numberOfBuyTradesHigherThanSell =
        stateProvider.buyInSimulation > stateProvider.sellInSimulation;
    return Row(
      children: [
        Expanded(
          child: Text(
            numberOfBuyTradesHigherThanSell
                ? "Average buy price"
                : "Average sell price",
            // style: TextStyle(
            //   fontWeight: FontWeight.bold,
            //   color: Colors.white,
            //   fontSize: 16,
            // ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              stateProvider.netShareQty != 0
                  ? amountToInrFormat(
                          context,
                          -stateProvider.simulationTradesCashGain /
                              stateProvider.netShareQty) ??
                      "N/A"
                  : "0",
              // style: TextStyle(
              //   color: Color(0xFF0099CC),
              //   fontWeight: FontWeight.bold,
              //   fontSize: 18,
              // ),
            ),
          ),
        ),
      ],
    );
  }

  Widget extraCashWidget(BuySellProvider stateProvider) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "Ext. cash (per order)",
            // style: TextStyle(
            //   fontWeight: FontWeight.bold,
            //   color: Colors.white,
            //   fontSize: 16,
            // ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              "${amountToInrFormat(context, stateProvider.extraCashInSimulation)} (${amountToInrFormat(context, (_defaultBuySellQty * _stepSize) / 2)})",
              // style: TextStyle(
              //   color: Color(0xFF0099CC),
              //   fontWeight: FontWeight.bold,
              //   fontSize: 18,
              // ),
            ),
          ),
        ),
      ],
    );
  }

  Widget costPerAllStocks(BuySellProvider stateProvider) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            "Cost/Stock for all stock",
            // style: TextStyle(
            //   fontWeight: FontWeight.bold,
            //   color: Colors.white,
            //   fontSize: 16,
            // ),
          ),
        ),
        Text(
          amountToInrFormat(
                  context,
                  ((_initialBuyQty * stateProvider.firstBuyingTrade) +
                          stateProvider.simulationTradesCashGain) /
                      (_initialBuyQty + _defaultBuySellQty)) ??
              "N/A",
          style: TextStyle(
            color: (((_initialBuyQty * stateProvider.firstBuyingTrade) +
                                stateProvider.simulationTradesCashGain) /
                            _initialBuyQty +
                        _defaultBuySellQty) <
                    0
                ? Colors.redAccent
                : Colors.white,
            // fontWeight: FontWeight.bold,
            // fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget initPurrCostWidget() {
    return generateRowWithText(
        "Init. purch. cost", widget.actualInitialBuyCash.toString());
  }

  Widget cashNeededWidget() {
    return generateRowWithText("Cash needed", widget.cashNeeded.toString());
  }

  Widget allocatedCashWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Alloc. Cash",
          textAlign: TextAlign.center,
        ),
        Text(
          "${amountToInrFormat(context, widget.allocatedCash)}",
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget maxPurchaseCost() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Alloc. Cash",
          textAlign: TextAlign.center,
        ),
        Text(
          "${amountToInrFormat(context, widget.actualCashAllocated)}",
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  List<Widget> ladderTabularView() {
    return [
      targetPriceWidget(),
      const SizedBox(
        height: 5,
      ),
      initialPurchasePriceWidget(),
      const SizedBox(
        height: 10,
      ),
      initialBuyQtyWidget(),
      const SizedBox(
        height: 10,
      ),
      defaultBuySellQtyWidget(),
      const SizedBox(
        height: 5,
      ),
      // minimumPriceWidget(),
      // const SizedBox(
      //   height: 10,
      // ),
      stepSizeWidget(),
      const SizedBox(
        height: 15,
      ),
      initPurrCostWidget(),
      const SizedBox(
        height: 15,
      ),
      cashNeededWidget(),
      const SizedBox(
        height: 15,
      ),
      maxPurchaseCost(),
      const SizedBox(
        height: 10,
      ),
      // allocatedCashWidget(),
      // const SizedBox(
      //   height: 10,
      // ),
    ];
  }

  List<Widget> ladderBackTestTabularView(BuySellProvider stateProvider) {
    return [
      simulationDurationWidget(stateProvider),
      const SizedBox(
        height: 10,
      ),
      sharesBoughtSoldPerTradeWidget(stateProvider),
      const SizedBox(
        height: 10,
      ),
      tradesBuySellWidget(stateProvider),
      const SizedBox(
        height: 10,
      ),
      stocksBoughtOrSoldAfterInitialPurchase(stateProvider),
      const SizedBox(
        height: 10,
      ),
      tradesCashGainWidget(stateProvider),
      const SizedBox(
        height: 10,
      ),
      averagePurchasePriceWidget(stateProvider),
      const SizedBox(
        height: 10,
      ),
      extraCashWidget(stateProvider),
      const SizedBox(
        height: 10,
      ),
    ];
  }

  Widget historicalDataAvailabilityWarning() {
    return _loadingHistoricalData
        ? SizedBox()
        : !_symbolDataAvailable
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "Historical data not available for simulation",
                  style: TextStyle(
                      color: (themeProvider.defaultTheme)
                          ? Colors.redAccent
                          : Colors.yellow,
                      fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              )
            : SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        titlePadding: EdgeInsets.only(top: 7, left: 7, right: 7),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
          side: BorderSide(
            color:
                (themeProvider.defaultTheme) ? Colors.black : Color(0XFFF5F5F5),
            width: 1,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        backgroundColor: (themeProvider.defaultTheme)
            ? Colors.white
            : const Color(0xFF15181F),
        title: ladderTitleWidget(),
        content: StatefulBuilder(
          builder: (BuildContext context,
              void Function(void Function()) localsetState) {
            return Scrollbar(
              controller: _dialogBoxScrollController,
              child: SingleChildScrollView(
                controller: _dialogBoxScrollController,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (graphicalModeEnable) const SizedBox(height: 20),
                      if (graphicalModeEnable)
                        graphicalModeBuySellChart()
                      else
                        tabularModeLadderChart(),
                      if (!graphicalModeEnable)
                        const SizedBox(
                          height: 18,
                        ),
                      Consumer<BuySellProvider>(
                        builder: (_, stateProvider, __) {
                          return SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                if (!graphicalModeEnable)
                                  ...ladderTabularView(),
                                if (graphicalModeEnable)
                                  ...ladderBackTestTabularView(stateProvider),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        actions: [
          Column(
            children: [
              widget.inTradePage
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        goBackButton(),
                      ],
                    )
                  : Row(
                      children: [
                        updateLadderBtn(),
                        requestReviewBtn(),
                        saveLadderBtn(),
                      ],
                    ),
              if (!widget.newLadder!) deleteLadderBtn()
            ],
          )
        ],
      ),
    );
  }

  Widget progressBar(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${(_progress * 10).toStringAsFixed(1)} seconds',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          LinearProgressIndicator(value: _progress),
        ],
      ),
    );
  }
}

class NumericalRangeFormatter extends TextInputFormatter {
  final double? min;
  final double? max;

  NumericalRangeFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '') {
      if (min != null) {
        return TextEditingValue().copyWith(
          text: min!.toStringAsFixed(2),
          selection:
              TextSelection.collapsed(offset: min!.toStringAsFixed(0).length),
        );
      } else {
        return TextEditingValue().copyWith(
            text: "0.00", selection: TextSelection.collapsed(offset: 0));
      }
    }
    if (min != null && double.parse(newValue.text) < min!) {
      return TextEditingValue().copyWith(
        text: min!.toStringAsFixed(2),
        selection:
            TextSelection.collapsed(offset: min!.toStringAsFixed(0).length),
      );
    } else if (max != null && double.parse(newValue.text) > max!) {
      return TextEditingValue().copyWith(
        text: max!.toStringAsFixed(2),
        selection:
            TextSelection.collapsed(offset: max!.toStringAsFixed(0).length),
      );
    } else {
      return newValue;
    }
  }
}
