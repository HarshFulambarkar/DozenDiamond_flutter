import 'package:dozen_diamond/AB_Ladder/models/ladder_list_model.dart';
import 'package:dozen_diamond/AB_Ladder/stateManagement/ladder_provider.dart';
import 'package:dozen_diamond/AB_Ladder/widgets/review_ladder_dialog.dart';
import 'package:dozen_diamond/Empty_ladder/models/cashEmptyLadderRequest.dart';
import 'package:dozen_diamond/Empty_ladder/services/emptyLadderService.dart';
import 'package:dozen_diamond/Empty_ladder/stateManagement/emptyLadderProvider.dart';
import 'package:dozen_diamond/F_Funds/stateManagement/funds_provider.dart';
import 'package:dozen_diamond/ZB_accountInfoBar/stateManagement/custom_home_app_bar_provider.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:dozen_diamond/merge_ladder/stateManagement/dart/merge_ladder_provider.dart';
import 'package:dozen_diamond/merge_ladder/model/ladder_list_model.dart'
    as merge_ladder;
import 'package:dozen_diamond/move_funds_to_ladder/model/ladder_list_model.dart'
    as move_funds_to_ladder;
import 'package:dozen_diamond/modify_ladder_target_price/stateManagment/modifyLadderTargetPriceProvider.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
import '../../global/functions/utils.dart';
import '../../global/models/http_api_exception.dart';
import 'package:provider/provider.dart';
import '../../ZZZZY_tradingMainPage/services/trade_main_rest_api_service.dart';
import '../../global/functions/helper.dart';
import '../../global/widgets/custom_container.dart';
import '../../global/widgets/my_text_field.dart';
import '../../global/widgets/shimmer_loading_view.dart';
import '../../ladder_add_or_withdraw_cash/stateManagement/ladder_add_or_withdraw_cash_provider.dart';
import '../../move_funds_to_ladder/stateManagement/move_funds_to_ladder_provider.dart';
import '../../socket_manager/stateManagement/web_socket_service_provider.dart';
import '../models/delete_ladder_request.dart';
import '../models/toggle_laddder_activation_status_request.dart';
import 'package:flutter/material.dart';
import 'package:dozen_diamond/ZB_accountInfoBar/stateManagement/custom_home_app_bar_provider.dart';

import '../../global/services/num_formatting.dart';
import '../services/ladder_rest_api_service.dart';
import 'package:auto_size_text/auto_size_text.dart';

class LadderTab extends StatefulWidget {
  LadderTab(
      {super.key,
      required this.initiallyExpanded,
      required this.ladderlist,
      required this.ladderDataRequest,
      this.selectedTicker});

  final bool initiallyExpanded;
  final List ladderlist;
  final Function ladderDataRequest;
  final String? selectedTicker;

  @override
  State<LadderTab> createState() => _LadderTabState();
}

class _LadderTabState extends State<LadderTab> {
  late bool value1 = true;
  bool? tradingStatus;
  bool isError = false;
  LadderProvider? _ladderProvider;
  TradeMainProvider? _tradeMainProvider;
  CurrencyConstants? _currencyConstantsProvider;
  late ThemeProvider themeProvider;
  bool modifyBtnClick = false;
  bool reinvestExtraCash = false;
  CustomHomeAppBarProvider? _customHomeAppBarProvider;
  late LadderAddOrWithdrawCashProvider ladderAddOrWithdrawCashProvider;
  late EmptyLadderProvider emptyLadderProvider;
  late MergeLadderProvider mergeLadderProvider;
  late NavigationProvider navigationProvider;
  // late FundsProvider fundsProvider;
  late CustomHomeAppBarProvider customHomeAppBarProvider;
  late LadderProvider ladderProvider;
  late ModifyLadderTargetPriceProvider modifyLadderTargetPriceProvider;
  late MoveFundsToLadderProvider moveFundsToLadderProvider;
  late WebSocketServiceProvider webSocketServiceProvider;

  @override
  void initState() {
    super.initState();
    _ladderProvider = Provider.of<LadderProvider>(context, listen: false);
    _tradeMainProvider = Provider.of<TradeMainProvider>(context, listen: false);
    _customHomeAppBarProvider = Provider.of(context, listen: false);
    _currencyConstantsProvider =
        Provider.of<CurrencyConstants>(context, listen: false);
    callInitialApi();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void callInitialApi() {
    _ladderProvider!
        .fetchAllLadder(_currencyConstantsProvider!)
        .then((value) {})
        .catchError((err) {
      print(err);
    });
  }

  void toggleLadderActivation(Ladder ladderInfo, bool isInActive,
      {FilterOption filterOption = FilterOption.all,
      int indexOfStockFilterChange = -1}) async {
    try {
      await LadderRestApiService()
          .toggleLadderActivationStatus(ToggleLadderActivationStatusRequest(
        ladId: ladderInfo.ladId,
        ladStatus: isInActive ? "ACTIVE" : "INACTIVE",
        ladReinvestExtraCash: false,
      ));
      // While Deactivating a single ladder due to pop black screen was appearing
      // if (isInActive) Navigator.pop(context);
      await _tradeMainProvider!.getActiveLadderTickers(context);
      await _ladderProvider!.fetchAllLadder(_currencyConstantsProvider!,
          filterOption: filterOption,
          indexOfStockFilterChange: indexOfStockFilterChange);
      await _tradeMainProvider!.getTradeMenuButtonsVisibilityStatus();
      await _customHomeAppBarProvider!.fetchUserAccountDetails();
    } on HttpApiException catch (err) {
      // Navigator.canPop(context);
      print("iside eorrr accestiopn");
      print(err.errorTitle);
      print(err.errorSuggestion);
    }
  }

  void toggleLadderStatus(int indexOfStock, FilterOption stockFilterOption,
      Ladder ladderInfo, FilterOption ladderStatus, bool isInActive) async {
    if (ladderStatus == FilterOption.inactive) {
      modifyBtnClick = false;
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
                    color: (themeProvider.defaultTheme)
                        ? Colors.white
                        : Colors.black,
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                    border: Border.all(
                      color: (themeProvider.defaultTheme)
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Reinvest extra cash?",
                            style: TextStyle(
                              color: (themeProvider.defaultTheme)
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                          Theme(
                            data:
                                ThemeData(unselectedWidgetColor: Colors.white),
                            child: StatefulBuilder(
                              builder: (context, localSetState) => Checkbox(
                                activeColor: Colors.blue,
                                value: reinvestExtraCash,
                                onChanged: (value) {
                                  localSetState(() {
                                    reinvestExtraCash = value ?? false;
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              toggleLadderActivation(ladderInfo, isInActive,
                                  filterOption: stockFilterOption,
                                  indexOfStockFilterChange: indexOfStock);
                            },
                            child: const Text(
                              "Ok",
                              style: TextStyle(color: Color(0xFF0099CC)),
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
        },
      );
    } else {
      modifyBtnClick = false;
      String dialogMessage = "Are you sure you want to deactivate the ladder ?";
      showCustomAlertDialogFromHelper(context, dialogMessage, () async {
        toggleLadderActivation(ladderInfo, false,
            filterOption: stockFilterOption,
            indexOfStockFilterChange: indexOfStock);
      });
    }
  }

  void refreshAfterDeleteLddr() {
    if (mounted) {
      callInitialApi();
    }
  }

  void modifyLadder(Ladder modifyLadderInfo) async {
    TradeMainRestApiService().getTradingStatus().then((res) {
      modifyBtnClick = false;
      if (res?.status == true) {
        if (res?.data?.regTradingStatus == true) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.transparent,
              content: Container(
                padding: const EdgeInsets.only(
                  top: 20,
                  bottom: 10,
                  left: 20,
                  right: 20,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: (themeProvider.defaultTheme)
                      ? Colors.white
                      : Colors.black,
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                  border: Border.all(
                    color: (themeProvider.defaultTheme)
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Trading Status is currently active. To Modify the Ladder please stop trading first.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: (themeProvider.defaultTheme)
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "OK",
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => modifyLadderDialog(modifyLadderInfo),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Something went wrong!",
            ),
          ),
        );
      }
    });
  }

  Widget modifyLadderDialog(Ladder modifyLadderInfo) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      content: Column(
        mainAxisSize: MainAxisSize.min,
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
              color: (themeProvider.defaultTheme) ? Colors.white : Colors.black,
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
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                      color: Colors.white,
                    ),
                    Text(
                      "Modify ladder",
                      style: TextStyle(
                        color: (themeProvider.defaultTheme)
                            ? Colors.black
                            : Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  onTap: () {
                    Fluttertoast.showToast(msg: "feature locked");
                    //   Navigator.pop(context);
                    //   showDialog(
                    //     context: context,
                    //     builder: (context) {
                    //       return ReviewLadderDialog(
                    //           symSecurityId: modifyLadderInfo.ladStockName,
                    //           initialyProvidedTargetPrice: modifyLadderInfo.targetPrice,
                    //           currentStockPrice:
                    //               modifyLadderInfo.currentPrice.toString(),
                    //           setDefaultBuySellQty:
                    //               modifyLadderInfo.defaultBuySellQty,
                    //           allocatedCash:
                    //               modifyLadderInfo.ladCashInitialAllocated,
                    //           stockName: modifyLadderInfo.ladStockName,
                    //           initialPurchasePrice: modifyLadderInfo
                    //               .initialPurchasePrice
                    //               .toString(),
                    //           minimumPriceForUpdateLadder:
                    //               modifyLadderInfo.minimumPrice,
                    //           newLadder: false,
                    //           updateLadderList: refreshAfterDeleteLddr,
                    //           ladStatus:
                    //               modifyLadderInfo.status == FilterOption.active
                    //                   ? "ACTIVE"
                    //                   : "INACTIVE",
                    //           ladderId: modifyLadderInfo.ladderId,
                    //           ladderName: modifyLadderInfo.ladName);
                    //     },
                    //   );
                    //
                  },
                  leading: const Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                  title: const Text(
                    "Edit ladder",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildModifyOptions(
      BuildContext context, Ladder ladderData, LadderListModel stockLadder) {
    double screenWidth = screenWidthRecognizer(context);
    modifyBtnClick = false;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.only(bottom: 5),
        width: screenWidth,
        decoration: BoxDecoration(
          color: (themeProvider.defaultTheme)
              ? Colors.white
              : Color(
                  0xFF15181F), //value.defaultTheme ? Colors.white : Color(0xFF15181F),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: (themeProvider.defaultTheme) ? Colors.black : Colors.white54,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Icon(
                      Icons.close,
                      color: (themeProvider.defaultTheme)
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 10,
                  ),
                  child: const Text(
                    "Modify Options",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: 12,
                )
              ],
            ),
            Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                margin: EdgeInsets.zero,
                color: Colors.transparent,
                child: ListTile(
                  dense: true,
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                    color: (themeProvider.defaultTheme) // value.defaultTheme
                        ? Colors.black
                        : Colors.white,
                  ),
                  title: Text(
                    "Add Cash to ladder",
                    style: TextStyle(
                      fontSize: 16,
                      color: (themeProvider.defaultTheme) // value.defaultTheme
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    ladderAddOrWithdrawCashProvider.ladId =
                        ladderData.ladId ?? 0;
                    ladderAddOrWithdrawCashProvider.initialBuyExecuted =
                        ladderData.ladInitialBuyExecuted == 1 ? true : false;
                    ladderAddOrWithdrawCashProvider.initialBuyQuantity =
                        ladderData.ladInitialBuyQuantity;
                    await ladderAddOrWithdrawCashProvider.resetValues(context);

                    print(
                        "below is account unallocated cash of add cash to ladder");
                    // print(fundsProvider.accountCashDetails?.data?.accountUnallocatedCash);

                    ladderAddOrWithdrawCashProvider.availableCashInAccount =
                        customHomeAppBarProvider.getUserAccountDetails?.data
                                ?.accountUnallocatedCash ??
                            8000; // add this value from api later

                    // ladderAddOrWithdrawCashProvider.availableCashInAccount =
                    //     double.parse(fundsProvider.accountCashDetails?.data
                    //             ?.accountUnallocatedCash ??
                    //         '8000'); // add this value from api later

                    print(
                        ladderAddOrWithdrawCashProvider.availableCashInAccount);
                    ladderAddOrWithdrawCashProvider.target =
                        double.parse(ladderData.ladTargetPrice.toString());
                    ladderAddOrWithdrawCashProvider.cashAlreadyAllocated =
                        double.parse(ladderData.ladCashAllocated.toString());
                    ladderAddOrWithdrawCashProvider.numberOfStepsAbove =
                        ladderData.ladNumOfStepsAbove;
                    ladderAddOrWithdrawCashProvider.numberOfStepsBelow =
                        ladderData.ladNumOfStepsBelow;
                    ladderAddOrWithdrawCashProvider.orderSize =
                        ladderData.ladDefaultBuySellQuantity;
                    ladderAddOrWithdrawCashProvider.currentPrice = double.parse(
                        stockLadder.currentPrice.toString() ??
                            '0'); //4437; // add this value from api later
                    ladderAddOrWithdrawCashProvider.currentStockOwn =
                        ladderData.ladCurrentQuantity;
                    ladderAddOrWithdrawCashProvider.cashNeeded =
                        double.parse(ladderData.ladCashNeeded.toString());
                    ladderAddOrWithdrawCashProvider.extraCashGenerated =
                        double.parse(
                            ladderData.ladExtraCashGenerated.toString());
                    ladderAddOrWithdrawCashProvider.stepSize =
                        ladderData.ladStepSize;
                    ladderAddOrWithdrawCashProvider.isWithdraw = false;

                    navigationProvider.previousSelectedIndex =
                        navigationProvider.selectedIndex;
                    navigationProvider.selectedIndex = 10;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.zero,
                color: Colors.transparent,
                child: ListTile(
                  dense: true,
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                    color: (themeProvider.defaultTheme) // value.defaultTheme
                        ? Colors.black
                        : Colors.white,
                  ),
                  title: Text(
                    "Withdraw Cash from ladder",
                    style: TextStyle(
                      fontSize: 16,
                      color: (themeProvider.defaultTheme) // value.defaultTheme
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);

                    await ladderAddOrWithdrawCashProvider.resetValues(context);
                    ladderAddOrWithdrawCashProvider.ladId =
                        ladderData.ladId ?? 0;

                    ladderAddOrWithdrawCashProvider.availableCashInAccount =
                        customHomeAppBarProvider.getUserAccountDetails?.data
                                ?.accountUnallocatedCash ??
                            1000000;

                    // ladderAddOrWithdrawCashProvider.availableCashInAccount =
                    //     double.parse(fundsProvider.accountCashDetails?.data
                    //             ?.accountUnallocatedCash ??
                    //         '1000000'); // add this value from api later

                    ladderAddOrWithdrawCashProvider.target =
                        double.parse(ladderData.ladTargetPrice.toString());
                    ladderAddOrWithdrawCashProvider.cashAlreadyAllocated =
                        double.parse(ladderData.ladCashAllocated.toString());
                    ladderAddOrWithdrawCashProvider.stepSize =
                        ladderData.ladStepSize;
                    // (double.parse(ladderData.ladTargetPrice.toString()) -
                    //         double.parse(
                    //             ladderData.ladInitialBuyPrice.toString())) /
                    //     ladderData.ladNumOfStepsAbove;
                    ladderAddOrWithdrawCashProvider.initialBuyExecuted =
                        ladderData.ladInitialBuyExecuted == 1 ? true : false;
                    ladderAddOrWithdrawCashProvider.numberOfStepsAbove =
                        ladderData.ladNumOfStepsAbove;
                    ladderAddOrWithdrawCashProvider.numberOfStepsBelow =
                        ladderData.ladNumOfStepsBelow;
                    ladderAddOrWithdrawCashProvider.initialBuyQuantity =
                        ladderData.ladInitialBuyQuantity;
                    ladderAddOrWithdrawCashProvider.orderSize =
                        ladderData.ladDefaultBuySellQuantity;
                    ladderAddOrWithdrawCashProvider.currentPrice = double.parse(
                        stockLadder.currentPrice.toString() ??
                            '0'); //4437; // add this value from api later
                    ladderAddOrWithdrawCashProvider.currentStockOwn =
                        ladderData.ladCurrentQuantity;
                    ladderAddOrWithdrawCashProvider.cashNeeded =
                        double.parse(ladderData.ladCashNeeded.toString());
                    ladderAddOrWithdrawCashProvider.extraCashGenerated =
                        double.parse(
                            ladderData.ladExtraCashGenerated.toString());

                    ladderAddOrWithdrawCashProvider.isWithdraw = true;

                    navigationProvider.previousSelectedIndex =
                        navigationProvider.selectedIndex;
                    navigationProvider.selectedIndex = 10;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.zero,
                color: Colors.transparent,
                child: ListTile(
                  dense: true,
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                    color: (themeProvider.defaultTheme) // value.defaultTheme
                        ? Colors.black
                        : Colors.white,
                  ),
                  title: Text(
                    "Merge two ladders",
                    style: TextStyle(
                      fontSize: 16,
                      color: (themeProvider.defaultTheme) // value.defaultTheme
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);

                    print(ladderData.ladStatus);
                    print(ladderData.ladCurrentQuantity);
                    print(ladderData.ladTicker);

// if (ladderData.ladCurrentQuantity > 0) {
                    if (stockLadder.ladders.length >= 2) {
                      // if(true) {

                      List<Ladder> initialBoughtLadderList = stockLadder.ladders
                          .where((ladder) => (ladder.ladCurrentQuantity > 0 &&
                              ladder.ladId != ladderData.ladId))
                          .toList();

                      if (initialBoughtLadderList.isNotEmpty &&
                          ladderData.ladCurrentQuantity > 0) {
                        mergeLadderProvider.availableCashInAccount =
                            customHomeAppBarProvider.getUserAccountDetails?.data
                                    ?.accountUnallocatedCash ??
                                1000000;

                        // mergeLadderProvider.availableCashInAccount =
                        //     double.parse(fundsProvider.accountCashDetails?.data
                        //             ?.accountUnallocatedCash ??
                        //         '1000000'); // add this value from api later

                        mergeLadderProvider.currentPrice = double.parse(
                            stockLadder.currentPrice.toString() ??
                                '0'); //4437; // add this value from api later

                        await storeValueInLadderL1(context, ladderData);

                        await storeValueInLadderList(
                            context, initialBoughtLadderList);

                        navigationProvider.previousSelectedIndex =
                            navigationProvider.selectedIndex;
                        navigationProvider.selectedIndex = 11;
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => mergeLadderAlertDialog(context,
                              "You can't add ladder who's initial buy does not take place or Ladder reached his target price"),
                        );
                        // showDialog(
                        //   context: context,
                        //   builder: (context) => mergeLadderAlertDialog(context,
                        //       "You should have more then 1 ladders of same stock to merge ladders with initial buy done"),
                        // );
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => mergeLadderAlertDialog(context,
                            "You should have more than 1 ladders of same stock to merge ladders with initial buy done"),
                      );
                      // showDialog(
                      //   context: context,
                      //   builder: (context) => mergeLadderAlertDialog(context,
                      //       "You can't add ladder who's initial buy does not take place or Ladder reached his target price"),
                      // );
                    }
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.zero,
                color: Colors.transparent,
                child: ListTile(
                  dense: true,
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                    color: (themeProvider.defaultTheme) // value.defaultTheme
                        ? Colors.black
                        : Colors.white,
                  ),
                  title: Text(
                    "Adjust Target",
                    style: TextStyle(
                      fontSize: 16,
                      color: (themeProvider.defaultTheme) // value.defaultTheme
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    modifyLadderTargetPriceProvider.ladId =
                        ladderData.ladId ?? 0;
                    modifyLadderTargetPriceProvider.currentPrice =
                        stockLadder.currentPrice;
                    modifyLadderTargetPriceProvider.cashAllocated =
                        ladderData.ladCashAllocated;
                    modifyLadderTargetPriceProvider.initialBuyExecuted =
                        ladderData.ladInitialBuyExecuted;
                    modifyLadderTargetPriceProvider.initialBuyQuantity =
                        ladderData.ladInitialBuyQuantity;
                    modifyLadderTargetPriceProvider.targetPrice =
                        ladderData.ladTargetPrice;
                    modifyLadderTargetPriceProvider.stepSize =
                        ladderData.ladStepSize;
                    modifyLadderTargetPriceProvider.orderSize =
                        ladderData.ladDefaultBuySellQuantity;
                    modifyLadderTargetPriceProvider.quantitiesOwned =
                        ladderData.ladCurrentQuantity;
                    modifyLadderTargetPriceProvider.cashNeeded =
                        ladderData.ladCashNeeded;
                    modifyLadderTargetPriceProvider.numberOfStepsAbove =
                        ladderData.ladNumOfStepsAbove;
                    navigationProvider.previousSelectedIndex =
                        navigationProvider.selectedIndex;
                    navigationProvider.selectedIndex = 14;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.zero,
                color: Colors.transparent,
                child: ListTile(
                  dense: true,
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                    color: (themeProvider.defaultTheme) // value.defaultTheme
                        ? Colors.black
                        : Colors.white,
                  ),
                  title: Text(
                    "Adjust step size",
                    style: TextStyle(
                      fontSize: 16,
                      color: (themeProvider.defaultTheme) // value.defaultTheme
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    modifyLadderTargetPriceProvider.ladId =
                        ladderData.ladId ?? 0;
                    modifyLadderTargetPriceProvider.currentPrice =
                        stockLadder.currentPrice;
                    modifyLadderTargetPriceProvider.cashAllocated =
                        ladderData.ladCashAllocated;
                    modifyLadderTargetPriceProvider.initialBuyExecuted =
                        ladderData.ladInitialBuyExecuted;
                    modifyLadderTargetPriceProvider.initialBuyQuantity =
                        ladderData.ladInitialBuyQuantity;
                    modifyLadderTargetPriceProvider.targetPrice =
                        ladderData.ladTargetPrice;
                    modifyLadderTargetPriceProvider.stepSize =
                        ladderData.ladStepSize;
                    modifyLadderTargetPriceProvider.orderSize =
                        ladderData.ladDefaultBuySellQuantity;
                    modifyLadderTargetPriceProvider.quantitiesOwned =
                        ladderData.ladCurrentQuantity;
                    modifyLadderTargetPriceProvider.cashNeeded =
                        ladderData.ladCashNeeded;
                    modifyLadderTargetPriceProvider.numberOfStepsAbove =
                        ladderData.ladNumOfStepsAbove;
                    modifyLadderTargetPriceProvider.selectedLadder = ladderData;
                    navigationProvider.previousSelectedIndex =
                        navigationProvider.selectedIndex;
                    navigationProvider.selectedIndex = 15;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.zero,
                color: Colors.transparent,
                child: ListTile(
                  dense: true,
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                    color: (themeProvider.defaultTheme) // value.defaultTheme
                        ? Colors.black
                        : Colors.white,
                  ),
                  title: Text(
                    "Adjust order size",
                    style: TextStyle(
                      fontSize: 16,
                      color: (themeProvider.defaultTheme) // value.defaultTheme
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    modifyLadderTargetPriceProvider.ladId =
                        ladderData.ladId ?? 0;
                    modifyLadderTargetPriceProvider.currentPrice =
                        stockLadder.currentPrice;
                    modifyLadderTargetPriceProvider.cashAllocated =
                        ladderData.ladCashAllocated;
                    modifyLadderTargetPriceProvider.initialBuyExecuted =
                        ladderData.ladInitialBuyExecuted;
                    modifyLadderTargetPriceProvider.initialBuyQuantity =
                        ladderData.ladInitialBuyQuantity;
                    modifyLadderTargetPriceProvider.targetPrice =
                        ladderData.ladTargetPrice;
                    modifyLadderTargetPriceProvider.stepSize =
                        ladderData.ladStepSize;
                    modifyLadderTargetPriceProvider.orderSize =
                        ladderData.ladDefaultBuySellQuantity;
                    modifyLadderTargetPriceProvider.quantitiesOwned =
                        ladderData.ladCurrentQuantity;
                    modifyLadderTargetPriceProvider.cashNeeded =
                        ladderData.ladCashNeeded;
                    modifyLadderTargetPriceProvider.numberOfStepsAbove =
                        ladderData.ladNumOfStepsAbove;
                    modifyLadderTargetPriceProvider.selectedLadder = ladderData;
                    navigationProvider.previousSelectedIndex =
                        navigationProvider.selectedIndex;
                    navigationProvider.selectedIndex = 16;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.zero,
                color: Colors.transparent,
                child: ListTile(
                  dense: true,
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                    color: (themeProvider.defaultTheme) // value.defaultTheme
                        ? Colors.black
                        : Colors.white,
                  ),
                  title: Text(
                    "Move Funds to Ladder",
                    style: TextStyle(
                      fontSize: 16,
                      color: (themeProvider.defaultTheme) // value.defaultTheme
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);

                    if (stockLadder.ladders.length >= 2) {
                      List<Ladder> initialBoughtLadderList = stockLadder.ladders
                          .where((ladder) => (ladder.ladCurrentQuantity > 0 &&
                              ladder.ladId != ladderData.ladId))
                          .toList();

                      if (initialBoughtLadderList.isNotEmpty &&
                          ladderData.ladCurrentQuantity > 0) {
                        moveFundsToLadderProvider.availableCashInAccount =
                            customHomeAppBarProvider.getUserAccountDetails?.data
                                    ?.accountUnallocatedCash ??
                                1000000;

                        // moveFundsToLadderProvider.availableCashInAccount =
                        //     double.parse(fundsProvider.accountCashDetails?.data
                        //         ?.accountUnallocatedCash ??
                        //         '1000000'); // add this value from api later

                        print("below is move funds to ladder current price");

                        moveFundsToLadderProvider.currentPrice = stockLadder
                            .currentPrice; //4437; // add this value from api later

                        await storeValueInLadderL1ForMoveFundsToLadder(
                            context, ladderData);

                        await storeValueInLadderListForMoveFundsToLadder(
                            context, initialBoughtLadderList);

                        navigationProvider.previousSelectedIndex =
                            navigationProvider.selectedIndex;
                        navigationProvider.selectedIndex = 17;
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => mergeLadderAlertDialog(context,
                              "You can't move funds to ladder who's initial buy does not take place or Ladder reached his target price"),
                        );
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => mergeLadderAlertDialog(context,
                            "You should have more than 1 ladders of same stock to move funds to ladders with initial buy done"),
                      );
                    }

                    // modifyLadderTargetPriceProvider.ladId =
                    //     ladderData.ladId ?? 0;
                    // modifyLadderTargetPriceProvider.currentPrice =
                    //     stockLadder.currentPrice;
                    // modifyLadderTargetPriceProvider.cashAllocated =
                    //     ladderData.ladCashAllocated;
                    // modifyLadderTargetPriceProvider.initialBuyExecuted =
                    //     ladderData.ladInitialBuyExecuted;
                    // modifyLadderTargetPriceProvider.initialBuyQuantity =
                    //     ladderData.ladInitialBuyQuantity;
                    // modifyLadderTargetPriceProvider.targetPrice =
                    //     ladderData.ladTargetPrice;
                    // modifyLadderTargetPriceProvider.stepSize =
                    //     ladderData.ladStepSize;
                    // modifyLadderTargetPriceProvider.orderSize =
                    //     ladderData.ladDefaultBuySellQuantity;
                    // modifyLadderTargetPriceProvider.quantitiesOwned =
                    //     ladderData.ladCurrentQuantity;
                    // modifyLadderTargetPriceProvider.cashNeeded =
                    //     ladderData.ladCashNeeded;
                    // modifyLadderTargetPriceProvider.numberOfStepsAbove =
                    //     ladderData.ladNumOfStepsAbove;
                    // navigationProvider.previousSelectedIndex =
                    //     navigationProvider.selectedIndex;
                    // navigationProvider.selectedIndex = 16;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.zero,
                color: Colors.transparent,
                child: ListTile(
                  dense: true,
                  title: Text(
                    ladderData.ladStatus != FilterOption.cashEmpty
                        ? "Make Ladder Cash Empty"
                        : "Put Cash in empty ladder",
                    style: TextStyle(
                      fontSize: 16,
                      color: (themeProvider.defaultTheme) // value.defaultTheme
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                  onTap: () async {
                    emptyLadderProvider.ladStatus = ladderData.ladStatus;
                    ladderData.ladStatus != FilterOption.cashEmpty
                        ? await emptyLadderDialog(context, ladderData)
                        : Fluttertoast.showToast(
                            msg: "These Feature is locked");
                    Navigator.pop(context);
                    // putCashLadderDialog(context, ladderData);
                  },
                ),
              ),
              TextButton(
                onPressed: () async {
                  // deleteLadder(ladderData);
                  if (ladderData.ladStatus == FilterOption.inactive) {
                    Navigator.pop(context);

                    if (ladderData.ladCurrentQuantity <= 0) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return deleteLadderAlertDialog(
                              "You sure you want to delete this ladder?",
                              ladderData);
                        },
                      );
                    } else {
                      deleteLadderDialog(ladderData);
                    }
                  } else {}

                  // showDialog(
                  //   context: context,
                  //   builder: (context) {
                  //     return deleteLadderAlertDialog(
                  //         "You sure you want to delete this ladder?",
                  //         ladderData);
                  //   },
                  // );
                },
                child: Text(
                  (ladderData.ladStatus == FilterOption.inactive)
                      ? "Delete ladder"
                      : "Delete ladder (Deactivate ladder before delete)",
                  style: TextStyle(
                    color: (ladderData.ladStatus == FilterOption.inactive)
                        ? Colors.red
                        : Colors.grey,
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Future<void> putCashLadderDialog(BuildContext context, Ladder ladderData) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog();
        });
  }

  Future<void> emptyLadderDialog(BuildContext context, Ladder ladderData) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor:
                (themeProvider.defaultTheme) ? Colors.white : Colors.black,
            title: Text("Make Ladder Cash Empty"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                    "Making the ladder cash empty will deallocated the funds from the ladder and the ladder will deactive"),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10, left: 20.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () async {
                            await EmptyLadderService().cashEmptyLadder(
                                CashEmptyLadderRequest(ladId: ladderData.ladId),
                                context);
                          },
                          child: Text("Proceed",
                              style: TextStyle(color: Colors.red))),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancel")),
                    ],
                  ),
                )
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
              side: const BorderSide(
                color: Colors.white,
                width: 1,
              ),
            ),
          );
        });
  }

  Future<void> deleteLadderDialog(Ladder ladderData) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setStateSB) {
            return AlertDialog(
              title: Text(
                'Delete Ladder',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text('Select Product type'),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  //
                  // buildLimitAndMarketDropDown(context, setStateSB),

                  SizedBox(
                    height: 5,
                  ),

                  Text('Enter Minimum Limit Price'),

                  SizedBox(
                    height: 5,
                  ),
                  (ladderProvider.showLimitPriceTextField)
                      ? buildLimitPriceTextField(context)
                      : Container(),

                  SizedBox(
                    height: 10,
                  ),

                  Text('Enter Time in Min'),

                  SizedBox(
                    height: 5,
                  ),
                  buildLimitPriceTimeInMinTextField(context),
                ],
              ),
              actions: [
                Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () async {
                            // ClosePositionRequest closePositionReq;
                            // stockName = stock;

                            if (ladderProvider.selectedProductType == "LIMIT" && (ladderProvider.limitPrice == 'null' || ladderProvider.limitPriceTimeInMin == 'null')) {

                              if(ladderProvider.limitPrice == 'null') {
                                ladderProvider.limitPriceErrorText = "Please enter min limit price";
                              }

                              if(ladderProvider.limitPriceTimeInMin == 'null') {
                                ladderProvider.limitPriceTimeInMinErrorText = "Please enter time in min";
                              }
                            } else {
                              if (ladderProvider.selectedProductType ==
                                  "LIMIT") {
                                // closePositionReq = ClosePositionRequest(
                                //     postnId: int.parse(positionId ?? "0"),
                                //     productType: positionProvider.selectedProductType,
                                //     limitPrice: double.parse(positionProvider.limitPrice)
                                // );
                              } else {
                                // closePositionReq = ClosePositionRequest(
                                //   postnId: int.parse(positionId ?? "0"),
                                //   productType: positionProvider.selectedProductType,
                                //   limitPrice: null,
                                // );
                              }
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return deleteLadderAlertDialog(
                                      "You sure you want to delete this ladder?",
                                      ladderData);
                                },
                              );
                              // closePositionRequest(closePositionReq);
                            }

                            setStateSB(() {});
                          },
                          child: Text(
                              'Proceed',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                        ),
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(
                          color: Colors.blue,
                        )),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                )
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
                side: const BorderSide(
                  color: Colors.white,
                  width: 1,
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              backgroundColor: const Color(0xFF15181F),
            );
          });
        });
  }

  Widget buildLimitPriceTextField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        SizedBox(
          height: 40,
          child: MyTextField(
            isFilled: true,
            fillColor: (themeProvider.defaultTheme)
                ?Color(0xffCACAD3):Color(0xff2c2c31),
            borderColor: (themeProvider.defaultTheme)
                ?Color(0xffCACAD3):Color(0xff2c2c31),
            textStyle: TextStyle(
              color: (themeProvider.defaultTheme)
                  ?Colors.black:Colors.white,
            ),
            maxLength: 9,
            elevation: 0,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
            // textStyle: (themeProvider.defaultTheme)
            //     ? TextStyle(color: Colors.black)
            //     : kBodyText,
            // borderColor: Color(0xff2c2c31),
            margin: EdgeInsets.zero,
            focusedBorderColor: ((ladderProvider.limitPriceErrorText != ""))
                ? Color(0xffd41f1f)
                : Color(0xff5cbbff),
            counterText: "",
            textInputFormatters: [
              FilteringTextInputFormatter.digitsOnly

              // FilteringTextInputFormatter.allow(
              //   RegExp(r'^[0-9,\.]+$'),
              // ),
            ],
            borderRadius: 8,

            labelText: '',
            onChanged: (value) {
              print(value);

              if (value.isEmpty) {
                ladderProvider.limitPrice = 'null';
              } else {
                ladderProvider.limitPrice = value;
              }
            },
          ),
        ),
        // MyTextField(
        //   textInputFormatters: <TextInputFormatter>[
        //     FilteringTextInputFormatter.digitsOnly
        //   ],
        //   borderRadius: 5,
        //
        //   currencyFormat: false,
        //   isFilled: true,
        //   elevation: 0,
        //   isLabelEnabled: false,
        //   borderWidth: 1,
        //   fillColor: Colors.transparent,
        //   contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
        //
        //   onChanged: (value) {
        //     print(value);
        //
        //     if (value.isEmpty) {
        //       ladderProvider.limitPrice = 'null';
        //     } else {
        //       ladderProvider.limitPrice = value;
        //     }
        //   },
        //   borderColor: Colors.white,
        //   labelText: "Enter Price",
        //   hintText: "Enter Price",
        //   maxLength: 9,
        //   counterText: "",
        //
        //   overrideHintText: true,
        //
        //   focusedBorderColor: Colors.white,
        //   isPasswordField: false,
        //
        //   isEnabled: true,
        //   // showLeadingWidget: true,
        //
        //   keyboardType: TextInputType.number,
        //
        //   validator: (value) {},
        // ),
        (ladderProvider.limitPriceErrorText == "")
            ? Container()
            : Text(ladderProvider.limitPriceErrorText,
                style: TextStyle(color: Colors.red))
      ],
    );
  }

  Widget buildLimitPriceTimeInMinTextField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 40,
          child: MyTextField(
            isFilled: true,
            fillColor: (themeProvider.defaultTheme)
                ?Color(0xffCACAD3):Color(0xff2c2c31),
            borderColor: (themeProvider.defaultTheme)
                ?Color(0xffCACAD3):Color(0xff2c2c31),
            textStyle: TextStyle(
              color: (themeProvider.defaultTheme)
                  ?Colors.black:Colors.white,
            ),
            maxLength: 4,
            elevation: 0,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
            // textStyle: (themeProvider.defaultTheme)
            //     ? TextStyle(color: Colors.black)
            //     : kBodyText,
            // borderColor: Color(0xff2c2c31),
            margin: EdgeInsets.zero,
            focusedBorderColor: ((ladderProvider.limitPriceTimeInMinErrorText != ""))
                ? Color(0xffd41f1f)
                : Color(0xff5cbbff),
            counterText: "",
            textInputFormatters: [
              FilteringTextInputFormatter.digitsOnly

              // FilteringTextInputFormatter.allow(
              //   RegExp(r'^[0-9,\.]+$'),
              // ),
            ],
            borderRadius: 8,

            labelText: '',
            onChanged: (value) {
              print(value);

              print(value);

              if (value.isEmpty) {
                ladderProvider.limitPriceTimeInMin = 'null';
              } else {
                ladderProvider.limitPriceTimeInMin = value;
              }
            },
          ),
        ),

        // MyTextField(
        //   textInputFormatters: <TextInputFormatter>[
        //     FilteringTextInputFormatter.digitsOnly
        //   ],
        //   borderRadius: 5,
        //
        //   currencyFormat: false,
        //   isFilled: true,
        //   elevation: 0,
        //   isLabelEnabled: false,
        //   borderWidth: 1,
        //   fillColor: Colors.transparent,
        //   contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
        //
        //   onChanged: (value) {
        //     print(value);
        //
        //     if (value.isEmpty) {
        //       positionProvider.limitPrice = 'null';
        //     } else {
        //       positionProvider.limitPrice = value;
        //     }
        //   },
        //   borderColor: Colors.white,
        //   labelText: "Enter Price",
        //   hintText: "Enter Price",
        //   maxLength: 9,
        //   counterText: "",
        //
        //   overrideHintText: true,
        //
        //   focusedBorderColor: Colors.white,
        //   isPasswordField: false,
        //
        //   isEnabled: true,
        //   // showLeadingWidget: true,
        //
        //   keyboardType: TextInputType.number,
        //
        //   validator: (value) {},
        // ),
        (ladderProvider.limitPriceTimeInMinErrorText == "")
            ? Container()
            : Text(ladderProvider.limitPriceTimeInMinErrorText,
            style: TextStyle(color: Colors.red))
      ],
    );
  }

  Widget buildLimitAndMarketDropDown(BuildContext context, setStateSB) {
    return IgnorePointer(
      ignoring: true,
      child: CustomContainer(
        borderColor: Colors.white,
        borderWidth: 1,
        backgroundColor: Colors.transparent,
        height: 40,
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8.0),
          child: DropdownButtonHideUnderline(
              child: DropdownButton<String?>(
            onChanged: (String? value) {
              // tradeMainState.updateSelectedTickerForSimulation =
              //     value;
              ladderProvider.selectedProductType = value!;

              print(ladderProvider.selectedProductType);

              if (ladderProvider.selectedProductType == "MARKET") {
                ladderProvider.limitPrice = 'null';
              }

              if (ladderProvider.selectedProductType == "LIMIT") {
                ladderProvider.showLimitPriceTextField = true;
              } else {
                ladderProvider.showLimitPriceTextField = false;
              }
              setStateSB(() {});
            },
            dropdownColor: Colors.black,
            value: ladderProvider.selectedProductType,
                icon: Container(),
            items: ladderProvider.productType
                .map((sortType) => DropdownMenuItem<String>(
                      child: Text(sortType!),
                      value: sortType,
                    ))
                .toList(),
          )),
        ),
      ),
    );
  }

  Widget mergeLadderAlertDialog(BuildContext context, String message) {
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
              color: (themeProvider.defaultTheme) ? Colors.white : Colors.black,
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
                  message,
                  style: TextStyle(
                    color: (themeProvider.defaultTheme)
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Ok",
                    style: TextStyle(color: Color(0xFF0099CC)),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  storeValueInLadderL1(BuildContext context, Ladder ladderData) {
    mergeLadderProvider.selectedLadderL1 = merge_ladder.Ladder(
        ladId: ladderData.ladId ?? 0,
        ladUserId: ladderData.ladUserId ?? 0,
        ladDefinitionId: ladderData.ladDefinitionId,
        ladPositionId: ladderData.ladPositionId,
        ladTicker: ladderData.ladTicker,
        ladName: ladderData.ladName,
        ladStatus: (ladderData.ladStatus == FilterOption.active)
            ? merge_ladder.FilterOption.active
            : merge_ladder.FilterOption.inactive,
        ladTickerId: ladderData.ladTickerId ?? 0,
        ladExchange: ladderData.ladExchange,
        ladTradingMode: ladderData.ladTradingMode,
        ladCashAllocated: ladderData.ladCashAllocated.toString(),
        ladCashGain: ladderData.ladCashGain.toString(),
        ladCashLeft: ladderData.ladCashLeft.toString(),
        ladLastTradePrice: ladderData.ladLastTradePrice,
        ladLastTradeOrderPrice: ladderData.ladLastTradeOrderPrice,
        ladMinimumPrice: ladderData.ladMinimumPrice.toString(),
        ladExtraCashGenerated: ladderData.ladExtraCashGenerated.toString(),
        ladExtraCashLeft: ladderData.ladExtraCashLeft.toString(),
        ladRealizedProfit: ladderData.ladRealizedProfit.toString(),
        ladInitialBuyQuantity: ladderData.ladInitialBuyQuantity,
        ladDefaultBuySellQuantity: ladderData.ladDefaultBuySellQuantity,
        ladTargetPrice: ladderData.ladTargetPrice.toString(),
        ladNumOfStepsAbove: ladderData.ladNumOfStepsAbove,
        ladNumOfStepsBelow: ladderData.ladNumOfStepsBelow,
        ladCashNeeded: ladderData.ladCashNeeded.toString(),
        ladInitialBuyPrice: ladderData.ladInitialBuyPrice.toString(),
        ladCurrentQuantity: ladderData.ladCurrentQuantity,
        ladInitialBuyExecuted: ladderData.ladInitialBuyExecuted,
        ladCashAssigned: ladderData.ladCashAssigned);
  }

  storeValueInLadderList(BuildContext context, List<Ladder> ladderDataList) {
    mergeLadderProvider.ladderList.clear();
    for (int i = 0; i < ladderDataList.length; i++) {
      mergeLadderProvider.ladderList.add(merge_ladder.Ladder(
          ladId: ladderDataList[i].ladId ?? 0,
          ladUserId: ladderDataList[i].ladUserId ?? 0,
          ladDefinitionId: ladderDataList[i].ladDefinitionId,
          ladPositionId: ladderDataList[i].ladPositionId,
          ladTicker: ladderDataList[i].ladTicker,
          ladName: ladderDataList[i].ladName,
          ladStatus: (ladderDataList[i].ladStatus == FilterOption.active)
              ? merge_ladder.FilterOption.active
              : merge_ladder.FilterOption.inactive,
          ladTickerId: ladderDataList[i].ladTickerId ?? 0,
          ladExchange: ladderDataList[i].ladExchange,
          ladTradingMode: ladderDataList[i].ladTradingMode,
          ladCashAllocated: ladderDataList[i].ladCashAllocated.toString(),
          ladCashGain: ladderDataList[i].ladCashGain.toString(),
          ladCashLeft: ladderDataList[i].ladCashLeft.toString(),
          ladLastTradePrice: ladderDataList[i].ladLastTradePrice,
          ladLastTradeOrderPrice: ladderDataList[i].ladLastTradeOrderPrice,
          ladMinimumPrice: ladderDataList[i].ladMinimumPrice.toString(),
          ladExtraCashGenerated:
              ladderDataList[i].ladExtraCashGenerated.toString(),
          ladExtraCashLeft: ladderDataList[i].ladExtraCashLeft.toString(),
          ladRealizedProfit: ladderDataList[i].ladRealizedProfit.toString(),
          ladInitialBuyQuantity: ladderDataList[i].ladInitialBuyQuantity,
          ladDefaultBuySellQuantity:
              ladderDataList[i].ladDefaultBuySellQuantity,
          ladTargetPrice: ladderDataList[i].ladTargetPrice.toString(),
          ladNumOfStepsAbove: ladderDataList[i].ladNumOfStepsAbove,
          ladNumOfStepsBelow: ladderDataList[i].ladNumOfStepsBelow,
          ladCashNeeded: ladderDataList[i].ladCashNeeded.toString(),
          ladInitialBuyPrice: ladderDataList[i].ladInitialBuyPrice.toString(),
          ladCurrentQuantity: ladderDataList[i].ladCurrentQuantity,
          ladInitialBuyExecuted: ladderDataList[i].ladInitialBuyExecuted,
          ladCashAssigned: ladderDataList[i].ladCashAssigned));
    }
  }

  Widget ladderUi(
      {required LadderListModel stockLadder,
      required Ladder ladderData,
      required ThemeProvider value,
      required LadderProvider ladderState,
      required int stockIndex,
      required int ladderIndex,
      required LadderListModel stockData}) {
// double tempStepSize =
//     ((double.tryParse(ladderData.ladTargetPrice) ?? 0.0) - (double.tryParse(ladderData.ladInitialBuyPrice) ?? 0.0)) /
//     (ladderData.ladNumOfStepsAbove != 0 ? ladderData.ladNumOfStepsAbove : 1);

    // double lastTradePrice = 0.0;
    // lastTradePrice = ladderData.ladLastStepPrice != null
    //     ? ladderData.ladLastStepPrice!
    //     : ladderData.initialPurchasePrice;

    return Column(
      children: [
        InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            if (mounted) {
              ladderState.toggleVisibilityOfLadderBtns(stockIndex, ladderIndex);
            }
          },
          child: Container(
            margin: const EdgeInsets.only(left: 7, right: 7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "${stockData.stockName} ${ladderData.ladName}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: !value.defaultTheme
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                Text(
                                  " (${ladderData.ladExchange})",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: !value.defaultTheme
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  ladderData.ladStatus == FilterOption.active
                                      ? "(Active)"
                                      : ladderData.ladStatus ==
                                              FilterOption.inactive
                                          ? "(Inactive)"
                                          : "(Cash Empty)",
                                  style: TextStyle(
                                    color: stockData.selectedFilter ==
                                            FilterOption.active
                                        ? Colors.orange
                                        : stockData.selectedFilter ==
                                                FilterOption.inactive
                                            ? Colors.blue
                                            : stockData.selectedFilter ==
                                                    FilterOption.all
                                                ? Colors.green
                                                : Colors.purple,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "CSV : ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: themeProvider.defaultTheme
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                                CustomContainer(
                                  padding: 0,
                                  margin: EdgeInsets.zero,
                                  backgroundColor: Colors.blue,
                                  // backgroundColor: themeProvider.defaultTheme
                                  //     ? Colors.blue
                                  //     : Color(0xFF0099CC),
                                  borderRadius: 50,
                                  width: 60,
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                              "Are you sure you want to download Executed orders ?",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            content: Container(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "* An email containing a CSV document will be sent to the registered email ID.",
                                                    style: TextStyle(
                                                        color:
                                                            Colors.greenAccent),
                                                  )
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        Map<String, dynamic>
                                                            data = {
                                                          "lad_id": ladderData
                                                                  .ladId ??
                                                              "",
                                                          "stock_name":
                                                              stockData
                                                                  .stockName
                                                        };
                                                        LadderRestApiService()
                                                            .userLadderExecutedOrderDownloadCsv(
                                                                data)
                                                            .then((value) {
                                                          Navigator.pop(
                                                              context);
                                                          Fluttertoast.showToast(
                                                              msg: "success");
                                                        }).catchError((err) {
                                                          Navigator.pop(
                                                              context);
                                                          print(err);
                                                        });
                                                      },
                                                      child: Text('OK',
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: OutlinedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Cancel',
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        side: BorderSide(
                                                            color: Colors.blue),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                ],
                                              )
                                            ],
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              side: const BorderSide(
                                                color: Colors.white,
                                                width: 1,
                                              ),
                                            ),
                                            actionsAlignment:
                                                MainAxisAlignment.center,
                                            backgroundColor:
                                                const Color(0xFF15181F),
                                          );
                                        });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: FittedBox(
                                      child: AutoSizeText(
                                        "Exc. Orders",
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        style: TextStyle(color: Colors.white
                                            // color: themeProvider.defaultTheme
                                            //     ? Colors.blue
                                            //     : Color(0xFF0099CC),
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  " / ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: themeProvider.defaultTheme
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                                CustomContainer(
                                  padding: 0,
                                  margin: EdgeInsets.zero,
                                  backgroundColor: Colors.blue,
                                  // backgroundColor: themeProvider.defaultTheme
                                  //     ? Colors.blue
                                  //     : Color(0xFF0099CC),
                                  borderRadius: 50,
                                  width: 60,
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                              "Are you sure you want to download All orders ?",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            content: Container(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "* An email containing a CSV document will be sent to the registered email ID.",
                                                    style: TextStyle(
                                                        color:
                                                            Colors.greenAccent),
                                                  )
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        Map<String, dynamic>
                                                            data = {
                                                          "lad_id": ladderData
                                                                  .ladId ??
                                                              "",
                                                          "stock_name":
                                                              stockData
                                                                  .stockName
                                                        };
                                                        LadderRestApiService()
                                                            .userLadderAllOrderDownloadCsv(
                                                                data)
                                                            .then((value) {
                                                          Navigator.pop(
                                                              context);
                                                          Fluttertoast.showToast(
                                                              msg: "success");
                                                        }).catchError((err) {
                                                          Navigator.pop(
                                                              context);
                                                          print(err);
                                                        });
                                                      },
                                                      child: Text('OK',
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: OutlinedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Cancel',
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        side: BorderSide(
                                                            color: Colors.blue),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                ],
                                              )
                                            ],
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              side: const BorderSide(
                                                color: Colors.white,
                                                width: 1,
                                              ),
                                            ),
                                            actionsAlignment:
                                                MainAxisAlignment.center,
                                            backgroundColor:
                                                const Color(0xFF15181F),
                                          );
                                        });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: FittedBox(
                                      child: AutoSizeText(
                                        " All Orders ",
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        style: TextStyle(color: Colors.white
                                            // color: themeProvider.defaultTheme
                                            //     ? Colors.blue
                                            //     : Color(0xFF0099CC),
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    print("icon tapped");
                                    ladderState.toggleAllValueVisible(
                                        stockIndex, ladderIndex);
                                  },
                                  child: Icon(
                                    (ladderData.isAllValueVisible)
                                        ? Icons.arrow_drop_down
                                        : Icons.arrow_drop_up,
                                    color: (themeProvider.defaultTheme)
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),

                (ladderData.isAllValueVisible)
                    ? Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Min./Initial/Target price: ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: !value.defaultTheme
                                        ? Colors.yellow[200]
                                        : Colors.purple[400],
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  "${amountToInrFormat(context, ladderData.ladMinimumPrice)}/${amountToInrFormat(context, ladderData.ladInitialBuyPrice)}/${amountToInrFormat(context, ladderData.ladTargetPrice)}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: !value.defaultTheme
                                        ? Colors.yellow[200]
                                        : Colors.purple[400],
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Cash gain/Needed: ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: !value.defaultTheme
                                        ? Colors.green
                                        : Colors.green[800],
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  "${amountToInrFormat(context, ladderData.ladCashGain)}/${amountToInrFormat(context, ladderData.ladCashNeeded)}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: !value.defaultTheme
                                        ? Colors.green
                                        : Colors.green[800],
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Alloc. Cash/Extra:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: !value.defaultTheme
                                        ? Colors.green
                                        : Colors.green[800],
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  "${amountToInrFormat(context, ladderData.ladCashAllocated)}/${amountToInrFormat(context, ladderData.ladExtraCashGenerated)}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: !value.defaultTheme
                                        ? Colors.green
                                        : Colors.green[800],
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Realized profit/ Total Profit:",
                                  // "",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: !value.defaultTheme
                                        ? Colors.green
                                        : Colors.green[800],
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  "${amountToInrFormat(context, ladderData.ladRealizedProfit)} / ${amountToInrFormat(context, (ladderData.ladCurrentQuantity * stockData.currentPrice) + ladderData.ladCashGain)}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: !value.defaultTheme
                                        ? Colors.green
                                        : Colors.green[800],
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Container(),

                Container(
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Number of steps above/below:",
                        // "",
                        style: TextStyle(
                          fontSize: 16,
                          color: !value.defaultTheme
                              ? Color.fromARGB(255, 222, 142, 13)
                              : Color.fromARGB(255, 226, 98, 43),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        "${((ladderData.ladCurrentQuantity == 0 ? ladderData.ladInitialBuyQuantity : ladderData.ladCurrentQuantity) / ladderData.ladDefaultBuySellQuantity).toStringAsFixed(2)}/${(stockData.currentPrice == 0 || ladderData.ladStepSize == 0)?"NA":(stockData.currentPrice / ladderData.ladStepSize).floor()}",
                        // "${ladderData.ladCurrentQuantity} ${ladderData.ladInitialBuyQuantity} ${ladderData.ladCurrentQuantity} ${ladderData.ladDefaultBuySellQuantity} ${stockData.currentPrice} ${ladderData.ladStepSize}",
                        style: TextStyle(
                          fontSize: 16,
                          color: !value.defaultTheme
                              ? Color.fromARGB(255, 222, 142, 13)
                              : Color.fromARGB(255, 226, 98, 43),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Steps/Price Moved:",
                        style: TextStyle(
                          fontSize: 16,
                          color: !value.defaultTheme
                              ? Color.fromARGB(255, 222, 142, 13)
                              : Color.fromARGB(255, 226, 98, 43),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        "${((stockData.currentPrice - ladderData.ladInitialBuyPrice) / ladderData.ladStepSize).toStringAsFixed(2)}/${(stockData.currentPrice - ladderData.ladInitialBuyPrice).toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 16,
                          color: !value.defaultTheme
                              ? Color.fromARGB(255, 222, 142, 13)
                              : Color.fromARGB(255, 226, 98, 43),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),

                (ladderData.isAllValueVisible)
                    ? Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Ladder number: ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: !value.defaultTheme
                                        ? Colors.indigo[200]
                                        : Colors.indigo[800],
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  "${ladderData.ladId}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: !value.defaultTheme
                                        ? Colors.indigo[200]
                                        : Colors.indigo[800],
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Step Size: ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: !value.defaultTheme
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  "${amountToInrFormat(context, ladderData.ladStepSize)}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: !value.defaultTheme
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Qty init/buysell/current",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: !value.defaultTheme
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  "${ladderData.ladInitialBuyQuantity}/ ${ladderData.ladDefaultBuySellQuantity}/ ${ladderData.ladCurrentQuantity}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: !value.defaultTheme
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Ladder exe. orders/ open orders",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: !value.defaultTheme
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  "${ladderData.ladExecutedOrders} / ${ladderData.ladOpenOrders}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: !value.defaultTheme
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Time To Recover Investment In Years",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: !value.defaultTheme
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  (ladderData.timeToRecoverInvestmentInYears! <=
                                          0)
                                      ? "NA"
                                      : "${ladderData.timeToRecoverInvestmentInYears}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: !value.defaultTheme
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Time To Recover Losses In Days",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: !value.defaultTheme
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  (ladderData.timeToRecoverLossesInDays! <= 0)
                                      ? "NA"
                                      : "${ladderData.timeToRecoverLossesInDays}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: !value.defaultTheme
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "No. of Trades/Month",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: !value.defaultTheme
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  "${ladderData.noOfTradesPerMonth}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: !value.defaultTheme
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Amount Already Recovered",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: !value.defaultTheme
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  "${ladderData.amountAlreadyRecovered}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: !value.defaultTheme
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Actual Brokerage/Other Charges",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: !value.defaultTheme
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  "${amountToInrFormat(context, ladderData.actualBrokerageCost)}/${amountToInrFormat(context, ladderData.otherBrokerageCharges)}",
                                  // "${ladderData.amountAlreadyRecovered}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: !value.defaultTheme
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Container()

                // if (ladderData.status == FilterOption.active) ...[
                //   if (ladderData.reinvestProfit == true)
                //     const Text(
                //       "(Reinvest extra cash)",
                //       style: TextStyle(color: Colors.blueAccent),
                //     )
                //   else if (ladderData.reinvestProfit == false)
                //     const Text(
                //       "(Does not reinvest extra cash)",
                //       style: TextStyle(color: Colors.blueAccent),
                //     ),
                // ],
              ],
            ),
          ),
        ),
        SizedBox(
          height: 7,
        ),
        if (ladderData.isVisible)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 7,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return ReviewLadderDialog(
                            inTradePage: true,
                            stockName: (ladderData.ladTicker),
                            tickerId: ladderData.ladTickerId ?? 0,
                            initialyProvidedTargetPrice:
                                ladderData.ladTargetPrice ?? 0.0,
                            initialPurchasePrice:
                                ladderData!.ladInitialBuyPrice.toString(),
                            currentStockPrice:
                                stockData.currentPrice.toString(),
                            allocatedCash: double.parse(
                                ladderData!.ladCashAllocated.toString()),
                            cashNeeded: ladderData!.ladCashNeeded,
                            isMarketOrder: true,
                            minimumPriceForUpdateLadder:
                                ladderData!.ladMinimumPrice,
                            setDefaultBuySellQty:
                                ladderData!.ladDefaultBuySellQuantity,
                            newLadder: true,
                            symSecurityCode: ladderData.ladTickerId,
                            stepSize: ladderData!.ladStepSize,
                            numberOfStepsAbove: ladderData!.ladNumOfStepsAbove,
                            numberOfStepsBelow: ladderData!.ladNumOfStepsBelow,
                            initialBuyQty:
                                (ladderData!.ladInitialBuyQuantity) ?? 0,
                            actualCashAllocated: ladderData!.ladCashAllocated,
                            actualInitialBuyCash:
                                ladderData!.ladInitialBuyPrice *
                                    ladderData!.ladInitialBuyQuantity,
                            ladTargetPriceMultiplier:
                                ladderData!.ladTargetPrice,
                          );
                        });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: (ladderData.noFollowup == false)
                          ? Colors.green
                          : Colors.grey),
                  child: FittedBox(
                    child: Text("Show ladder",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: BorderSide(
                      color: (ladderData.noFollowup == false)
                          ? Color(0xFF0099CC)
                          : Colors.grey,
                    ),
                  ),
                  onPressed: () {
                    if (ladderData.noFollowup == false) {
                      if (!modifyBtnClick) {
                        modifyBtnClick = true;
                        showDialog(
                          context: context,
                          builder: (context) => buildModifyOptions(
                              context, ladderData, stockLadder),
                        );
                      }
                    }
                  },
                  child: FittedBox(
                    child: Text(
                      "Modify",
                      style: TextStyle(
                        color: (ladderData.noFollowup == false)
                            ? Color(0xFF0099CC)
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    print("below is status");
                    print(ladderData.ladStatus);
                    print(FilterOption.inactive);
                    if (ladderData.noFollowup == false) {
                      if (!modifyBtnClick) {

                        if(ladderData.ladStatus == FilterOption.inactive) {
                          if(Utility().checkForSubscription(context)) {
                            modifyBtnClick = true;
                            toggleLadderStatus(
                                stockIndex,
                                stockLadder.selectedFilter,
                                ladderData,
                                ladderData.ladStatus,
                                ladderData.ladStatus == FilterOption.inactive);
                          }
                        } else {
                          modifyBtnClick = true;
                          toggleLadderStatus(
                              stockIndex,
                              stockLadder.selectedFilter,
                              ladderData,
                              ladderData.ladStatus,
                              ladderData.ladStatus == FilterOption.inactive);
                        }

                        // modifyBtnClick = true;
                        // toggleLadderStatus(
                        //     stockIndex,
                        //     stockLadder.selectedFilter,
                        //     ladderData,
                        //     ladderData.ladStatus,
                        //     ladderData.ladStatus == FilterOption.inactive);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: (ladderData.noFollowup == false)
                          ? (ladderData.ladStatus == FilterOption.inactive)
                              ? Colors.blue
                              : Colors.red
                          : Colors.grey),
                  child: FittedBox(
                    child: Text(
                        ladderData.ladStatus == FilterOption.inactive
                            ? "Activate Ladder"
                            : "Deactivate Ladder",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(
                width: 7,
              ),
            ],
          ),
        Divider(
          height: 20,
          thickness: 1,
          color: (themeProvider.defaultTheme) ? Colors.black : Colors.white54,
          indent: (themeProvider.defaultTheme) ? 0 : 15,
          endIndent: (themeProvider.defaultTheme) ? 0 : 15,
        )
      ],
    );
  }

  Widget ladderListUi({
    required LadderListModel stockLadderData,
    required ThemeProvider value,
    required LadderProvider ladderState,
    required int stockIndex,
  }) {
    return Theme(
      data: ThemeData(unselectedWidgetColor: Colors.white),
      child: Container(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "${stockIndex + 1}",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Text(
                    stockLadderData.stockName ?? "N/A",
                    style: TextStyle(
                        fontSize: 16,
                        color:
                            !value.defaultTheme ? Colors.white : Colors.black),
                  ),
                  SizedBox(width: 5),
                  Text(
                    (_tradeMainProvider?.tradingOptions == TradingOptions.simulationTradingWithSimulatedPrices)
                        ? "${amountToInrFormat(context, stockLadderData.currentPrice)}"
                        : (webSocketServiceProvider.lastTradedPriceResponseMap[stockLadderData.ladders[0].ladTickerId] == null || (double.tryParse(webSocketServiceProvider.lastTradedPriceResponseMap[stockLadderData.ladders[0].ladTickerId]) ?? 0) <= 0)
                        ?"${amountToInrFormat(context, stockLadderData.currentPrice)}"
                        :"${amountToInrFormat(context, double.parse((webSocketServiceProvider.lastTradedPriceResponseMap[stockLadderData.ladders[0].ladTickerId] ?? stockLadderData.currentPrice).toString()))}",
                    // "${amountToInrFormat(context, stockLadderData.currentPrice)}",
                    style: TextStyle(
                        fontSize: 16,
                        color:
                            !value.defaultTheme ? Colors.white : Colors.black),
                  ),
                ],
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      ladderState.updateStockFilterAtIndex = stockIndex;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: stockLadderData.selectedFilter ==
                                    FilterOption.all
                                ? Colors.green
                                : stockLadderData.selectedFilter ==
                                        FilterOption.active
                                    ? Colors.orange
                                    : stockLadderData.selectedFilter ==
                                            FilterOption.inactive
                                        ? Colors.blue
                                        : Colors.purple,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      child: Text(
                        stockLadderData.selectedFilter == FilterOption.all
                            ? "All"
                            : stockLadderData.selectedFilter ==
                                    FilterOption.active
                                ? "Active"
                                : stockLadderData.selectedFilter ==
                                        FilterOption.inactive
                                    ? "Inactive"
                                    : "Cash Empty",
                        style: TextStyle(
                          color:
                              stockLadderData.selectedFilter == FilterOption.all
                                  ? Colors.green
                                  : stockLadderData.selectedFilter ==
                                          FilterOption.active
                                      ? Colors.orange
                                      : stockLadderData.selectedFilter ==
                                              FilterOption.inactive
                                          ? Colors.blue
                                          : Colors.purple,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ladderState.toggleExpandLadderTileAtIndex = stockIndex;
                    },
                    icon: ladderState.ladderExpansionControllers[stockIndex]
                        ? Icon(Icons.keyboard_arrow_up,
                            color: (themeProvider.defaultTheme)
                                ? Colors.black
                                : Colors.white)
                        : Icon(Icons.keyboard_arrow_down,
                            color: (themeProvider.defaultTheme)
                                ? Colors.black
                                : Colors.white),
                  ),
                ],
              )
            ],
          ),
          Visibility(
              visible: ladderState.ladderExpansionControllers[stockIndex],
              child: Column(
                children: [
                  for (var i = 0; i < stockLadderData.ladders.length; i++)
                    if (stockLadderData.selectedFilter == FilterOption.all ||
                        stockLadderData.selectedFilter ==
                            stockLadderData.ladders[i].ladStatus)
                      ladderUi(
                          stockLadder: stockLadderData,
                          ladderData: stockLadderData.ladders[i],
                          ladderState: ladderState,
                          stockIndex: stockIndex,
                          stockData: stockLadderData,
                          ladderIndex: i,
                          value: value),
                ],
              ))
        ]),
      ),
    );
  }

  storeValueInLadderL1ForMoveFundsToLadder(
      BuildContext context, Ladder ladderData) {
    moveFundsToLadderProvider.selectedLadderL1 = move_funds_to_ladder.Ladder(
      ladId: ladderData.ladId ?? 0,
      ladUserId: ladderData.ladUserId ?? 0,
      ladDefinitionId: ladderData.ladDefinitionId,
      ladPositionId: ladderData.ladPositionId,
      ladTicker: ladderData.ladTicker,
      ladName: ladderData.ladName,
      ladStatus: (ladderData.ladStatus == FilterOption.active)
          ? move_funds_to_ladder.FilterOption.active
          : move_funds_to_ladder.FilterOption.inactive,
      ladTickerId: ladderData.ladTickerId ?? 0,
      ladExchange: ladderData.ladExchange,
      ladTradingMode: ladderData.ladTradingMode,
      ladCashAllocated: ladderData.ladCashAllocated.toString(),
      ladCashGain: ladderData.ladCashGain.toString(),
      ladCashLeft: ladderData.ladCashLeft.toString(),
      ladLastTradePrice: ladderData.ladLastTradePrice,
      ladLastTradeOrderPrice: ladderData.ladLastTradeOrderPrice,
      ladMinimumPrice: ladderData.ladMinimumPrice.toString(),
      ladExtraCashGenerated: ladderData.ladExtraCashGenerated.toString(),
      ladExtraCashLeft: ladderData.ladExtraCashLeft.toString(),
      ladRealizedProfit: ladderData.ladRealizedProfit.toString(),
      ladInitialBuyQuantity: ladderData.ladInitialBuyQuantity,
      ladDefaultBuySellQuantity: ladderData.ladDefaultBuySellQuantity,
      ladTargetPrice: ladderData.ladTargetPrice.toString(),
      ladNumOfStepsAbove: ladderData.ladNumOfStepsAbove,
      ladNumOfStepsBelow: ladderData.ladNumOfStepsBelow,
      ladCashNeeded: ladderData.ladCashNeeded.toString(),
      ladInitialBuyPrice: ladderData.ladInitialBuyPrice.toString(),
      ladCurrentQuantity: ladderData.ladCurrentQuantity,
      ladInitialBuyExecuted: ladderData.ladInitialBuyExecuted,
    );
  }

  storeValueInLadderListForMoveFundsToLadder(
      BuildContext context, List<Ladder> ladderDataList) {
    moveFundsToLadderProvider.ladderList.clear();
    for (int i = 0; i < ladderDataList.length; i++) {
      moveFundsToLadderProvider.ladderList.add(move_funds_to_ladder.Ladder(
        ladId: ladderDataList[i].ladId ?? 0,
        ladUserId: ladderDataList[i].ladUserId ?? 0,
        ladDefinitionId: ladderDataList[i].ladDefinitionId,
        ladPositionId: ladderDataList[i].ladPositionId,
        ladTicker: ladderDataList[i].ladTicker,
        ladName: ladderDataList[i].ladName,
        ladStatus: (ladderDataList[i].ladStatus == FilterOption.active)
            ? move_funds_to_ladder.FilterOption.active
            : move_funds_to_ladder.FilterOption.inactive,
        ladTickerId: ladderDataList[i].ladTickerId ?? 0,
        ladExchange: ladderDataList[i].ladExchange,
        ladTradingMode: ladderDataList[i].ladTradingMode,
        ladCashAllocated: ladderDataList[i].ladCashAllocated.toString(),
        ladCashGain: ladderDataList[i].ladCashGain.toString(),
        ladCashLeft: ladderDataList[i].ladCashLeft.toString(),
        ladLastTradePrice: ladderDataList[i].ladLastTradePrice,
        ladLastTradeOrderPrice: ladderDataList[i].ladLastTradeOrderPrice,
        ladMinimumPrice: ladderDataList[i].ladMinimumPrice.toString(),
        ladExtraCashGenerated:
            ladderDataList[i].ladExtraCashGenerated.toString(),
        ladExtraCashLeft: ladderDataList[i].ladExtraCashLeft.toString(),
        ladRealizedProfit: ladderDataList[i].ladRealizedProfit.toString(),
        ladInitialBuyQuantity: ladderDataList[i].ladInitialBuyQuantity,
        ladDefaultBuySellQuantity: ladderDataList[i].ladDefaultBuySellQuantity,
        ladTargetPrice: ladderDataList[i].ladTargetPrice.toString(),
        ladNumOfStepsAbove: ladderDataList[i].ladNumOfStepsAbove,
        ladNumOfStepsBelow: ladderDataList[i].ladNumOfStepsBelow,
        ladCashNeeded: ladderDataList[i].ladCashNeeded.toString(),
        ladInitialBuyPrice: ladderDataList[i].ladInitialBuyPrice.toString(),
        ladCurrentQuantity: ladderDataList[i].ladCurrentQuantity,
        ladInitialBuyExecuted: ladderDataList[i].ladInitialBuyExecuted,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // fundsProvider = Provider.of<FundsProvider>(context, listen: true);
    emptyLadderProvider =
        Provider.of<EmptyLadderProvider>(context, listen: true);
    customHomeAppBarProvider =
        Provider.of<CustomHomeAppBarProvider>(context, listen: true);
    ladderAddOrWithdrawCashProvider =
        Provider.of<LadderAddOrWithdrawCashProvider>(context, listen: true);
    navigationProvider = Provider.of<NavigationProvider>(context, listen: true);
    mergeLadderProvider =
        Provider.of<MergeLadderProvider>(context, listen: true);
    ladderProvider = Provider.of<LadderProvider>(context, listen: true);
    moveFundsToLadderProvider =
        Provider.of<MoveFundsToLadderProvider>(context, listen: true);
    modifyLadderTargetPriceProvider =
        Provider.of<ModifyLadderTargetPriceProvider>(context, listen: true);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    webSocketServiceProvider =
        Provider.of<WebSocketServiceProvider>(context, listen: true);
    double screenWidth = screenWidthRecognizer(context);
    return Consumer<ThemeProvider>(builder: (context, value, child) {
      return Consumer<LadderProvider>(builder: (_, state, __) {
        return state.isLoading
            ? buildLadderLoadingWidget(
                context, screenWidth) //Center(child: Text("N/A"))
            : state.stockLadders.isEmpty
                ? Center(
                    child: Text(
                      "No ladders",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemBuilder: (context, index) {
                      return ladderListUi(
                          stockLadderData: state.stockLadders[index],
                          value: value,
                          ladderState: state,
                          stockIndex: index);
                    },
                    itemCount: state.stockLadders.length,
                  );
      });
    });
  }

  Widget deleteLadderAlertDialog(String msg, Ladder ladderData) {
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
              color: (themeProvider.defaultTheme) ? Colors.white : Colors.black,
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
                        print("after navigation");
                        deleteLadder(ladderData);
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

  void deleteLadder(Ladder ladderData) async {
    print("inside deleteLadder");
    try {
      if (ladderData.ladStatus == "ACTIVE") {
        await LadderRestApiService().toggleLadderActivationStatus(
          ToggleLadderActivationStatusRequest(
              ladId: ladderData.ladId,
              ladStatus: "INACTIVE",
              ladReinvestExtraCash: false),
        );
      }

      double? tempLimitPrice;
      int? timeInMin;

      if (ladderProvider.selectedProductType == "LIMIT") {
        print("below is limitprice");
        print(ladderProvider.limitPrice);
        tempLimitPrice = double.tryParse(ladderProvider.limitPrice);
        timeInMin = int.tryParse(ladderProvider.limitPriceTimeInMin);
      } else {
        tempLimitPrice = null;
        timeInMin = null;
      }
      String? res =
          await LadderRestApiService().deleteLadder(DeleteLadderRequest(
        ladId: ladderData.ladId,
        productType: ladderProvider.selectedProductType,
        minLimitPrice: tempLimitPrice,
        timeInMin: timeInMin,
      ));
      Fluttertoast.showToast(msg: res);
      callInitialApi();
      // Navigator.pop(context);
      // updateLadderList!();
    } on HttpApiException catch (err) {
      print(err);
    }
  }

  Widget buildLadderLoadingWidget(BuildContext context, double screenWidth) {
    return ListView.builder(
        itemCount: 5,
        itemBuilder: (context, stockIndex) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (themeProvider.defaultTheme)
                        ? ShimmerLoadingView.loadingContainerDark(
                            screenWidth * 0.6, 25)
                        : ShimmerLoadingView.loadingContainer(
                            screenWidth * 0.6, 25),
                    Row(
                      children: [
                        (themeProvider.defaultTheme)
                            ? ShimmerLoadingView.loadingContainerDark(60, 25)
                            : ShimmerLoadingView.loadingContainer(60, 25),
                        SizedBox(width: 5),
                        (themeProvider.defaultTheme)
                            ? ShimmerLoadingView.loadingContainerDark(60, 25)
                            : ShimmerLoadingView.loadingContainer(60, 25),
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (themeProvider.defaultTheme)
                        ? ShimmerLoadingView.loadingContainerDark(
                            screenWidth * 0.4, 25)
                        : ShimmerLoadingView.loadingContainer(
                            screenWidth * 0.4, 25),
                    Row(
                      children: [
                        (themeProvider.defaultTheme)
                            ? ShimmerLoadingView.loadingContainerDark(40, 25)
                            : ShimmerLoadingView.loadingContainer(40, 25),
                        SizedBox(width: 5),
                        (themeProvider.defaultTheme)
                            ? ShimmerLoadingView.loadingContainerDark(60, 25)
                            : ShimmerLoadingView.loadingContainer(60, 25),
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (themeProvider.defaultTheme)
                        ? ShimmerLoadingView.loadingContainerDark(
                            screenWidth * 0.3, 25)
                        : ShimmerLoadingView.loadingContainer(
                            screenWidth * 0.3, 25),
                    Row(
                      children: [
                        (themeProvider.defaultTheme)
                            ? ShimmerLoadingView.loadingContainerDark(50, 25)
                            : ShimmerLoadingView.loadingContainer(50, 25),
                        SizedBox(width: 5),
                        (themeProvider.defaultTheme)
                            ? ShimmerLoadingView.loadingContainerDark(10, 25)
                            : ShimmerLoadingView.loadingContainer(10, 25),
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (themeProvider.defaultTheme)
                        ? ShimmerLoadingView.loadingContainerDark(
                            screenWidth * 0.3, 25)
                        : ShimmerLoadingView.loadingContainer(
                            screenWidth * 0.3, 25),
                    Row(
                      children: [
                        (themeProvider.defaultTheme)
                            ? ShimmerLoadingView.loadingContainerDark(50, 25)
                            : ShimmerLoadingView.loadingContainer(50, 25),
                        SizedBox(width: 5),
                        (themeProvider.defaultTheme)
                            ? ShimmerLoadingView.loadingContainerDark(50, 25)
                            : ShimmerLoadingView.loadingContainer(50, 25),
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }
}
