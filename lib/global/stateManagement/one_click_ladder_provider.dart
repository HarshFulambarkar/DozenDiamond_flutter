import 'package:dozen_diamond/DD_Navigation/stateManagement/navigation_provider.dart';
import 'package:dozen_diamond/ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
import 'package:dozen_diamond/global/functions/helper.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:dozen_diamond/past_data_graphical_view/statemangement/past_data_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../AB_Ladder/models/create_ladder_request.dart';
import '../../AB_Ladder/models/create_ladder_response.dart';
import '../../AB_Ladder/services/ladder_rest_api_service.dart';
import '../../ZI_Search/models/selected_stock_model.dart';
import '../../create_ladder_detailed/stateManagement/create_ladder_provider.dart';

class OneClickLadderProvider extends ChangeNotifier {

  double _targetPriceMultiplier = 1.5;

  double get targetPriceMultiplier => _targetPriceMultiplier;

  set targetPriceMultiplier(double value) {
    _targetPriceMultiplier = value;
    notifyListeners();
  }

  double _cashAllocated = 500000;

  double get cashAllocated => _cashAllocated;

  set cashAllocated(double value) {
    _cashAllocated = value;
    notifyListeners();
  }

  double _initialBuyPrice = 0.0;

  double get initialBuyPrice => _initialBuyPrice;

  set initialBuyPrice(double value) {
    _initialBuyPrice = value;
    notifyListeners();
  }

  double _targetPrice = 0.0;

  double get targetPrice => _targetPrice;

  set targetPrice(double value) {
    _targetPrice = value;
    notifyListeners();
  }

  double _initialBuyCash = 0.0;

  double get initialBuyCash => _initialBuyCash;

  set initialBuyCash(double value) {
    _initialBuyCash = value;
    notifyListeners();
  }

  double _actualInitialBuyCash = 0.0;

  double get actualInitialBuyCash => _actualInitialBuyCash;

  set actualInitialBuyCash(double value) {
    _actualInitialBuyCash = value;
    notifyListeners();
  }

  int _initialBuyQty = 0;

  int get initialBuyQty => _initialBuyQty;

  set initialBuyQty(int value) {
    _initialBuyQty = value;
    notifyListeners();
  }

  double _stepSize = 0.0;

  double get stepSize => _stepSize;

  set stepSize(double value) {
    _stepSize = value;
    notifyListeners();
  }

  double _numberOfStepsAbove = 40;

  double get numberOfStepsAbove => _numberOfStepsAbove;

  set numberOfStepsAbove(double value) {
    _numberOfStepsAbove = value;
    notifyListeners();
  }

  int _numberOfStepsBelow = 0;

  int get numberOfStepsBelow => _numberOfStepsBelow;

  set numberOfStepsBelow(int value) {
    _numberOfStepsBelow = value;
  }

  int _buySellQty = 0;

  int get buySellQty => _buySellQty;

  set buySellQty(int value) {
    _buySellQty = value;
    notifyListeners();
  }

  double _cashNeeded = 0;

  double get cashNeeded => _cashNeeded;

  set cashNeeded(double value) {
    _cashNeeded = value;
    notifyListeners();
  }

  double _cashLeft = 0;

  double get cashLeft => _cashLeft;

  set cashLeft(double value) {
    _cashLeft = value;
    notifyListeners();
  }

  double _actualCashAllocated = 0;

  double get actualCashAllocated => _actualCashAllocated;

  set actualCashAllocated(double value) {
    _actualCashAllocated = value;
    notifyListeners();
  }

  bool _isButtonLoading = false;

  bool get isButtonLoading => _isButtonLoading;

  set isButtonLoading(bool value) {
    _isButtonLoading = value;
    notifyListeners();
  }

  Future<void> creteOneClickLadderCalculation(int tickerId, String ticker, double tickerPrice, BuildContext context) async {


    try {

      CreateLadderProvider? createLadderProvider;

      createLadderProvider = Provider.of<CreateLadderProvider>(context, listen: false);

      await createLadderProvider.stockRecommendationParameters([SelectedTickerModel(ssTicker: ticker)]);

      if(createLadderProvider.stockRecommendedParametersData[ticker] != null) {
        targetPriceMultiplier = double.tryParse(createLadderProvider.stockRecommendedParametersData[ticker]?.targetPriceMultipler ?? "0.0") ?? 0.0;
        numberOfStepsAbove = (double.tryParse(createLadderProvider.stockRecommendedParametersData[ticker]!.stepsAbove.toString()) ?? 40);
      }

      targetPrice = targetPriceMultiplier * tickerPrice;
      initialBuyPrice = tickerPrice;
      // double k = targetPrice / initialBuyPrice;
      // initialBuyCash = (((2 * k) - 2) / ((2 * k) - 1)) * cashAllocated;
      initialBuyCash = cashAllocated * (((2 * targetPriceMultiplier) - 2)/ ((2 * targetPriceMultiplier) - 1));
      initialBuyQty = (initialBuyCash / initialBuyPrice).floor();
      actualInitialBuyCash = initialBuyQty * initialBuyPrice;
      stepSize = ((targetPrice - initialBuyPrice) / numberOfStepsAbove).roundTo2();
      numberOfStepsBelow = (initialBuyPrice / stepSize).floor();
      buySellQty = (initialBuyQty / numberOfStepsAbove).floor();
      // cashNeeded = buySellQty * numberOfStepsBelow * (initialBuyPrice / targetPriceMultiplier);
      cashNeeded = numberOfStepsBelow * (initialBuyPrice / 2) * buySellQty;
      cashLeft = cashAllocated - initialBuyQty * initialBuyPrice;
      actualCashAllocated = (initialBuyQty * initialBuyPrice) + cashNeeded;

      // double extraCash = await getExtraCashPerMonthOfAStock(
      //     stockName: ticker,
      //     initialBuyPrice: tickerPrice,
      //     targetPrice: targetPrice,
      //     noOfStepsAbove: numberOfStepsAbove,
      //     noOfStepsBelow: numberOfStepsBelow,
      //     defaultBuySellQty: buySellQty,
      //     stepSize: stepSize,
      //     initialBuyQty: initialBuyQty);
      //
      // CreateLadderResponse? res = await LadderRestApiService().createLadder(
      //   CreateLadderRequest(
      //       ladTickerId: tickerId,
      //       ladDefaultBuySellQuantity: buySellQty,
      //       ladInitialBuyQuantity: initialBuyQty,
      //       ladInitialBuyPrice: initialBuyPrice,
      //       ladMinimumPrice: 0,
      //       ladTargetPrice: targetPrice,
      //       ladCashAllocated: actualCashAllocated,
      //       ladCashNeeded: cashNeeded,
      //       ladNumOfStepsAbove: numberOfStepsAbove,
      //       ladNumOfStepsBelow: numberOfStepsBelow,
      //       ladStepSize: stepSize,
      //       targetPriceMultiplier: targetPriceMultiplier,
      //       continueTradingAfterHittingTargetPrice: true,
      //       ladCashAssigned: actualCashAllocated,
      //       estimatedExtraCashPerMonth: extraCash
      //   ),
      //   isOneClick: true,
      // );
      //
      // Fluttertoast.showToast(msg: res!.message!);

    } on HttpApiException catch (err) {

      showDialog(
        context: context,
        builder: (context) {
          return errorDialog(err.errorTitle, context);
        },
      );

    }

  }

  Future<bool> creteOneClickLadder(int tickerId, String ticker, double tickerPrice, BuildContext context) async {


    // try {

      // CreateLadderProvider? createLadderProvider;
      //
      // createLadderProvider = Provider.of<CreateLadderProvider>(context, listen: false);
      //
      // await createLadderProvider.stockRecommendationParameters([SelectedTickerModel(ssTicker: ticker)]);
      //
      // if(createLadderProvider.stockRecommendedParametersData[ticker] != null) {
      //   targetPriceMultiplier = double.tryParse(createLadderProvider.stockRecommendedParametersData[ticker]?.targetPriceMultipler ?? "0.0") ?? 0.0;
      //   numberOfStepsAbove = (double.tryParse(createLadderProvider.stockRecommendedParametersData[ticker]!.stepsAbove.toString()) ?? 40);
      // }
      //
      // targetPrice = targetPriceMultiplier * tickerPrice;
      // initialBuyPrice = tickerPrice;
      // double k = targetPrice / initialBuyPrice;
      // initialBuyCash = (((2 * k) - 2) / ((2 * k) - 1)) * cashAllocated;
      // initialBuyQty = (initialBuyCash / initialBuyPrice).floor();
      // actualInitialBuyCash = initialBuyQty * initialBuyPrice;
      // stepSize = ((targetPrice - initialBuyPrice) / numberOfStepsAbove);
      // numberOfStepsBelow = (initialBuyPrice / stepSize).floor();
      // buySellQty = (initialBuyQty / numberOfStepsAbove).ceil();
      // cashNeeded = buySellQty * numberOfStepsBelow * (initialBuyPrice / targetPriceMultiplier);
      // cashLeft = cashAllocated - initialBuyQty * initialBuyPrice;
      // actualCashAllocated = (initialBuyQty * initialBuyPrice) + cashNeeded;

      print("before is after extra cash");

      // double extraCash = await getExtraCashPerMonthOfAStock(
      //     stockName: ticker,
      //     initialBuyPrice: tickerPrice,
      //     targetPrice: targetPrice,
      //     noOfStepsAbove: numberOfStepsAbove,
      //     noOfStepsBelow: numberOfStepsBelow,
      //     defaultBuySellQty: buySellQty,
      //     stepSize: stepSize,
      //     initialBuyQty: initialBuyQty);

      double extraCash = (buySellQty * stepSize) / 2;

      print("this is after extra cash");

      CreateLadderResponse? res = await LadderRestApiService().createLadder(
        CreateLadderRequest(
            ladTickerId: tickerId,
            ladDefaultBuySellQuantity: buySellQty,
            ladInitialBuyQuantity: initialBuyQty,
            ladInitialBuyPrice: initialBuyPrice,
            ladMinimumPrice: 0,
            ladTargetPrice: targetPrice,
            ladCashAllocated: actualCashAllocated,
            ladCashNeeded: cashNeeded,
            ladNumOfStepsAbove: numberOfStepsAbove,
            ladNumOfStepsBelow: numberOfStepsBelow,
            ladStepSize: stepSize,
            targetPriceMultiplier: targetPriceMultiplier,
            continueTradingAfterHittingTargetPrice: true,
            ladCashAssigned: actualCashAllocated,
            estimatedExtraCashPerMonth: extraCash
        ),
        isOneClick: true,
      );

      Fluttertoast.showToast(msg: res!.message!);

      return true;

    // } on HttpApiException catch (err) {
    //
    //   showDialog(
    //     context: context,
    //     builder: (context) {
    //       return errorDialog(err.errorTitle, context);
    //     },
    //   );
    //
    //   return false;
    //
    // }

  }

  Widget errorDialog(String msg, BuildContext context) {
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
}