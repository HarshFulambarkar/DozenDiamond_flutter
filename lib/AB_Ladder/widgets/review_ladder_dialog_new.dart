import 'dart:async';

import 'package:dozen_diamond/AB_Ladder/stateManagement/buy_sell_provider.dart';
import 'package:dozen_diamond/AB_Ladder/widgets/stockladder1_new.dart';
import 'package:dozen_diamond/ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:dozen_diamond/past_data_graphical_view/statemangement/past_data_provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Settings/stateManagement/theme_provider.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/functions/utils.dart';
import '../../global/services/num_formatting.dart';
import '../../global/widgets/custom_container.dart';
import '../../localization/translation_keys.dart';
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

class ReviewLadderDialogNew extends StatefulWidget {
  final int tickerId;
  final double initialyProvidedTargetPrice;
  final String stockName;
  final String stockExchange;
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

  ReviewLadderDialogNew({
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
    this.stockExchange = "",
  }) : super(key: key);

  @override
  State<ReviewLadderDialogNew> createState() => _ReviewLadderDialogNewState();
}

class _ReviewLadderDialogNewState extends State<ReviewLadderDialogNew> {
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
  Utility.showLoadingDialog();
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
    
    // ✅ Round extraCash to 2 decimal places
    extraCash = double.parse(extraCash.toStringAsFixed(2));
    
    // ✅ Round stepSize to 2 decimal places
    double roundedStepSize = double.parse(_stepSize.toStringAsFixed(2));
    
    print("here is the extraCash that is sending ${extraCash}");
    print("here is the stepSize that is sending ${roundedStepSize}");
    
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
          ladStepSize: roundedStepSize, // ✅ Use rounded stepSize
          targetPriceMultiplier: widget.ladTargetPriceMultiplier,
          continueTradingAfterHittingTargetPrice:
              _continueTradingAfterHittingTargetPrice,
          ladCashAssigned: widget.assignedCash,
          estimatedExtraCashPerMonth: extraCash), // ✅ extraCash is already rounded
    );
    Utility.hideLoadingDialog();
    Navigator.of(context).pop("ladderCreated");

    Fluttertoast.showToast(msg: res!.message!);
  } on HttpApiException catch (err) {
    Utility.hideLoadingDialog();
    print("error in the createLadder function $err");
    showDialog(
      context: context,
      builder: (context) {
        return errorDialog(err.errorTitle);
      },
    ).then((onValue) {
      Utility.hideLoadingDialog();
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

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    double screenWidth = screenWidthRecognizer(context);
    return SafeArea(
      child: Center(
        child: Container(
          height: 850,
          width: screenWidth,
          decoration: BoxDecoration(
            color: (themeProvider.defaultTheme)?Colors.white:Color(0xff2c2c31),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        TranslationKeys.simulationReviewLadder,
                        style: TextStyle(
                          fontFamily: 'Britanica',
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                        ),
                      ),

                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          color: (themeProvider.defaultTheme)?Colors.black:Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                buildTabularAndGraphicalTabViewSection(context, screenWidth),
                SizedBox(
                  height: 20,
                ),
                buildStockDetails(context, screenWidth),
                SizedBox(
                  height: 20,
                ),
                (graphicalModeEnable)
                    ? (!_symbolDataAvailable)
                        ? buildNoGraphicalDataFound(context, screenWidth)
                        : buildGraphicalViewSection(context, screenWidth)
                    : buildTabularViewSection(context, screenWidth),
                SizedBox(
                  height: 20,
                ),
                (widget.inTradePage)
                    ? Container()
                    : buildBottomButtonSection(context, screenWidth),
                (widget.inTradePage)
                    ? Container()
                    : SizedBox(
                        height: 20,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTabularAndGraphicalTabViewSection(
      BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: CustomContainer(
              onTap: () {
                if (_ladderLinesValueAboveCP.isNotEmpty ||
                    _ladderLinesValueBelowCP.isNotEmpty) {
                  setState(() {
                    graphicalModeEnable = false;
                    Future.delayed(const Duration(milliseconds: 100))
                        .then((value) => setState(() {}));
                  });
                } else {
                  Fluttertoast.showToast(msg: "Please update ladder!");
                }
              },
              paddingEdge: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              padding: 0,
              backgroundColor:
                  (graphicalModeEnable) ? Color(0xff1d1d1f) : Color(0xff1a94f2),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8.0),
                  child: Text(
                    TranslationKeys.tabularView,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: (graphicalModeEnable)
                          ? Color(0xffa2b0bc)
                          : Color(0xfff0f0f0),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: CustomContainer(
              onTap: () {
                if (_ladderLinesValueAboveCP.isNotEmpty ||
                    _ladderLinesValueBelowCP.isNotEmpty) {
                  setState(() {
                    graphicalModeEnable = true;
                    Future.delayed(const Duration(milliseconds: 100))
                        .then((value) => setState(() {}));
                  });
                } else {
                  Fluttertoast.showToast(msg: "Please update ladder!");
                }
              },
              paddingEdge: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              padding: 0,
              backgroundColor:
                  (graphicalModeEnable) ? Color(0xff1a94f2) : Color(0xff1d1d1f),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8.0),
                  child: Text(
                    TranslationKeys.graphicalView,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: (graphicalModeEnable)
                          ? Color(0xfff0f0f0)
                          : Color(0xffa2b0bc),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildStockDetails(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 22, right: 22.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                TranslationKeys.stock,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                ),
              ),
              Row(
                children: [
                  Text(
                    widget.stockName,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                    ),
                  ),

                  CustomContainer(
                    backgroundColor: Color(0xff3a2d7f),
                    borderRadius: 20,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8.0,
                        top: 3,
                        bottom: 3,
                      ),
                      child: Text(
                        // "BSE",
                        widget.stockExchange,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color(0xfff0f0f0),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                TranslationKeys.price,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                ),
              ),
              Text(
                numToComma(double.tryParse(widget.currentStockPrice)),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTabularViewSection(BuildContext context, double screenWidth) {
    return Column(
      children: [
        buildTabularViewTableSection(context, screenWidth),
        SizedBox(
          height: 20,
        ),
        buildTabularViewLadderDetailsSection(context, screenWidth),
      ],
    );
  }

  Widget rowElements(String text1, String text2, String text3,
      {bool currentPriceCell = false, Key? key, bool formatToComma = false}) {
    return IntrinsicHeight(
      key: key,
      child: Row(children: [
        Flexible(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xff1d1d1f), //Color(0xff2c2c31),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
              ),
              border: Border.all(
                  color: Color(0xff2c2c31),
                  // color: (themeProvider.defaultTheme)
                  //     ?Colors.black:Colors.white,
                  width: 1),
            ),
            // decoration: BoxDecoration(
            //   color: Colors.transparent,
            //   border: Border.all(
            //       color: (themeProvider.defaultTheme)
            //           ?Colors.black:Colors.white,
            //       width: 0.5),
            // ),
            child: Text(
              text1,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  color: Color(0xfff0f0f0),
                  // color: (themeProvider.defaultTheme)
                  //     ?Colors.green:Colors.greenAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
        Flexible(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xff1d1d1f), //Color(0xff2c2c31),
              // borderRadius: BorderRadius.only(
              //   topLeft: Radius.circular(10),
              // ),
              border: Border.all(
                  color: Color(0xff2c2c31),
                  // color: (themeProvider.defaultTheme)
                  //     ?Colors.black:Colors.white,
                  width: 1),
            ),
            // decoration: BoxDecoration(
            //   color: Colors.transparent,
            //   border: Border.all(
            //       color: (themeProvider.defaultTheme)
            //           ?Colors.black:Colors.white,
            //       width: 0.5),
            // ),
            child: Text(
              text2,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  color: Color(0xfff0f0f0),
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
              // style: TextStyle(
              //     color: (themeProvider.defaultTheme)
              //         ?Colors.green:Colors.greenAccent,
              //     fontSize: 15),
            ),
          ),
        ),
        Flexible(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xff1d1d1f), //Color(0xff2c2c31),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
              ),
              border: Border.all(
                  color: Color(0xff2c2c31),
                  // color: (themeProvider.defaultTheme)
                  //     ?Colors.black:Colors.white,
                  width: 1),
            ),
            // decoration: BoxDecoration(
            //   color: Colors.transparent,
            //   border: Border.all(
            //       color: (themeProvider.defaultTheme)
            //           ?Colors.black:Colors.white,
            //       width: 0.5),
            // ),
            child: Text(
              text3,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  color: Color(0xfff0f0f0),
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
              // style: TextStyle(
              //     color: (themeProvider.defaultTheme)
              //         ?Colors.green:Colors.greenAccent, fontSize: 15),
            ),
          ),
        ),
      ]),
    );
  }

  Widget buildTabularViewTableSection(
      BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16.0),
      child: Column(
        children: [
          rowElements("Stocks\nHeld", "Stocks\nBought/Sold", "Stock\nPrice"),
          Visibility(
            visible: _isVisible,
            child: StockLadder1New(
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
          ),
        ],
      ),
    );
  }

  Widget buildTabularViewLadderDetailsSection(
      BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16.0),
      child: Consumer<BuySellProvider>(builder: (_, stateProvider, __) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  TranslationKeys.targetPrice,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                ),
                Text(
                  "${amountToInrFormat(context, _targetPrice)}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  TranslationKeys.initialPurchasePrice,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                ),
                Text(
                  "${amountToInrFormat(context, _initialBuyPrice)}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  TranslationKeys.initialBuyQuantity,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                ),
                Text(
                  "${intToUnits(_initialBuyQty)}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  TranslationKeys.orderSize,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                ),
                Text(
                  // "${stateProvider.sharesBoughtSoldPerTrade}",
                  "${_defaultBuySellQty}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  TranslationKeys.stepSize,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                ),
                Text(
                  "${amountToInrFormat(context, _stepSize)}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  TranslationKeys.cashNeeded,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                ),
                Text(
                  "${widget.cashNeeded.toStringAsFixed(2)}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  TranslationKeys.allocatedCash,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                ),
                Text(
                  "${amountToInrFormat(context, widget.actualCashAllocated)}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        );
      }),
    );
  }

  Widget buildGraphicalViewSection(BuildContext context, double screenWidth) {
    return Column(
      children: [
        buildGraphicalViewGraphSection(context, screenWidth),
        SizedBox(
          height: 20,
        ),
        buildGraphicalViewLadderDetailSection(context, screenWidth)
      ],
    );
  }

  Widget buildGraphicalViewGraphSection(
      BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16.0),
      child: Visibility(
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
              currentStockPrice:
                  double.tryParse(widget.currentStockPrice) ?? 0.0,
              stepSize: _stepSize,
              defaultBuySellQty: _defaultBuySellQty,
              initialBuyQty: _initialBuyQty,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGraphicalViewLadderDetailSection(
      BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16.0),
      child: Consumer<BuySellProvider>(builder: (_, stateProvider, __) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  TranslationKeys.simulationDuration,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                ),
                Text(
                  "${stateProvider.simulationDuration}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  TranslationKeys.orderSize,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                ),
                Text(
                  "${stateProvider.sharesBoughtSoldPerTrade}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  TranslationKeys.ordersBuySell,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                ),
                Text(
                  "${stateProvider.buyInSimulation} / ${stateProvider.sellInSimulation}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  TranslationKeys.stocksSold,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                ),
                Text(
                stateProvider.sellInSimulation.toStringAsFixed(2),
                  // (stateProvider.buyInSimulation >
                  //         stateProvider.sellInSimulation)
                  //     ? "Stocks bought"
                  //     : "Stocks sold",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  TranslationKeys.tradesCashGain,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                ),
                Text(
                  amountToInrFormat(
                          context, stateProvider.simulationTradesCashGain) ??
                      "N/A",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  (stateProvider.buyInSimulation >
                          stateProvider.sellInSimulation)
                      ? TranslationKeys.averageBuyPrice
                      : TranslationKeys.averageSellPrice,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                ),
                Text(
                  stateProvider.netShareQty != 0
                      ? amountToInrFormat(
                              context,
                              -stateProvider.simulationTradesCashGain /
                                  stateProvider.netShareQty) ??
                          "N/A"
                      : "0",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  TranslationKeys.extraCashPerOrder,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                ),
                Text(
                  "${amountToInrFormat(context, stateProvider.extraCashInSimulation)} (${amountToInrFormat(context, (_defaultBuySellQty * _stepSize) / 2)})",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Estimated total brokerage",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                ),
                Text(
                  "${amountToInrFormat(context, _buySellProvider!.totalBrokerage)}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Estimated Brokerage per exec order",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                ),
                Text(
                  "${amountToInrFormat(context, _buySellProvider!.averageBrokerage)}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        );
      }),
    );
  }

  Widget buildBottomButtonSection(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        // CustomContainer(
        //   padding: 0,
        //   paddingEdge: EdgeInsets.zero,
        //   margin: EdgeInsets.zero,
        //   borderRadius: 12,
        //   backgroundColor: Colors.transparent, //Color(0xfff0f0f0),
        //   onTap: () async {
        //     _updateLadder(useDefaultBuySellQty: true);
        //   },
        //   child: Padding(
        //     padding:
        //         const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8.0),
        //     child: Text(
        //         // TranslationKeys.createLadder,
        //         TranslationKeys.updateLadder,
        //         style: GoogleFonts.poppins(
        //           fontSize: 14.5,
        //           fontWeight: FontWeight.w500,
        //           color: Color(0xfff0f0f0),
        //         )),
        //   ),
        // ),
        CustomContainer(
          padding: 0,
          paddingEdge: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          borderRadius: 12,
          backgroundColor: Color(0xfff0f0f0),
          onTap: () async {
            showDialog(
              context: context,
              builder: (context) {
                return continueTradingAfterTargetDialog(
                    "Do you want to continue trading after ladder hit the target price");
              },
            );
          },
          child: Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8.0),
            child: Text(
                // TranslationKeys.createLadder,
                TranslationKeys.saveLadder,
                style: GoogleFonts.poppins(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff000000),
                )),
          ),
        ),
      ]),
    );
  }

  Widget buildNoGraphicalDataFound(BuildContext context, double screenWidth) {
    return CustomContainer(
      height: 400,
      width: screenWidth - 40,
      backgroundColor: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "lib/global/assets/images/graph_image.png",
            height: 100,
          ),
          Text(
            TranslationKeys.graphUnavailable,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Color(0xfff0f0f0),
            ),
          ),
          Text(
            TranslationKeys.weCouldntFindHistoricalDataForThisStock,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color(0xffa2b0bc),
            ),
          )
        ],
      ),
    );
  }
}
