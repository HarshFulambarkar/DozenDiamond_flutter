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
import 'package:google_fonts/google_fonts.dart';
import '../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
import '../../global/functions/utils.dart';
import '../../global/models/http_api_exception.dart';
import 'package:provider/provider.dart';
import '../../ZZZZY_tradingMainPage/services/trade_main_rest_api_service.dart';
import '../../global/functions/helper.dart';
import '../../global/widgets/custom_bottom_sheets.dart';
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

import '../widgets/review_ladder_dialog_new.dart';

class LadderTabNew extends StatefulWidget {
  LadderTabNew({
    super.key,
    required this.initiallyExpanded,
    required this.ladderlist,
    required this.ladderDataRequest,
    this.selectedTicker,
  });

  final bool initiallyExpanded;
  final List ladderlist;
  final Function ladderDataRequest;
  final String? selectedTicker;

  @override
  State<LadderTabNew> createState() => _LadderTabNewState();
}

class _LadderTabNewState extends State<LadderTabNew> {
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

  late ScrollController _scrollController;
  bool _isLoadingMore = false;
  int? _nextCursor;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _ladderProvider = Provider.of<LadderProvider>(context, listen: false);
    _tradeMainProvider = Provider.of<TradeMainProvider>(context, listen: false);
    _customHomeAppBarProvider = Provider.of(context, listen: false);
    _currencyConstantsProvider = Provider.of<CurrencyConstants>(
      context,
      listen: false,
    );
    callInitialApi();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // User is near the bottom (200px threshold)
      if (!_isLoadingMore && _hasMore) {
        _loadMore();
      }
    }
  }

  void _loadMore() async {
    if (_nextCursor == null && _hasMore == false) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      // Call fetch with cursor
      await _ladderProvider!.fetchAllLadder(
        _currencyConstantsProvider!,
        nextCursor: _nextCursor, // pass the cursor
        isInitialLoading: false,
      );
      print("loaded more : with next ${_ladderProvider!.nextCursor}");
      // Update pagination state from provider or response
      // Assuming your provider exposes these after fetch
      _nextCursor = _ladderProvider!.nextCursor;
      _hasMore = _ladderProvider!.hasMore;
    } catch (err) {
      print("Pagination error: $err");
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  void callInitialApi() async {
    await _ladderProvider!
        .fetchAllLadder(
          _currencyConstantsProvider!,
          nextCursor: _nextCursor,
          isInitialLoading: true,
        )
        .then((_) {
          setState(() {
            _nextCursor = _ladderProvider!.nextCursor;
            _hasMore = _ladderProvider!.hasMore;
          });
        })
        .catchError((err) {
          print(err);
        });
  }

  void toggleLadderActivation(
    Ladder ladderInfo,
    bool isInActive, {
    FilterOption filterOption = FilterOption.all,
    int indexOfStockFilterChange = -1,
  }) async {
    try {
      await LadderRestApiService().toggleLadderActivationStatus(
        ToggleLadderActivationStatusRequest(
          ladId: ladderInfo.ladId,
          ladStatus: isInActive ? "ACTIVE" : "INACTIVE",
          ladReinvestExtraCash: false,
        ),
      );
      // While Deactivating a single ladder due to pop black screen was appearing
      // if (isInActive) Navigator.pop(context);
      await _tradeMainProvider!.getActiveLadderTickers(context);
      await _ladderProvider!.fetchAllLadder(
        _currencyConstantsProvider!,
        nextCursor: null,
        filterOption: filterOption,
        indexOfStockFilterChange: indexOfStockFilterChange,
      );
      await _tradeMainProvider!.getTradeMenuButtonsVisibilityStatus();
      await _customHomeAppBarProvider!.fetchUserAccountDetails();
    } on HttpApiException catch (err) {
      // Navigator.canPop(context);
      print("iside eorrr accestiopn");
      print(err.errorTitle);
      print(err.errorSuggestion);
    }
  }

    void refreshLadderList() async {
  await _ladderProvider!.fetchAllLadder(
    _currencyConstantsProvider!,
    nextCursor: null, // Reset to first page
    isInitialLoading: true,
  );
  setState(() {
    _nextCursor = _ladderProvider!.nextCursor;
    _hasMore = _ladderProvider!.hasMore;
  });
}

  void toggleLadderStatus(
    int indexOfStock,
    FilterOption stockFilterOption,
    Ladder ladderInfo,
    FilterOption ladderStatus,
    bool isInActive,
  ) async {
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
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: (themeProvider.defaultTheme)
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            data: ThemeData(
                              unselectedWidgetColor: Colors.white,
                            ),
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
                          ),
                        ],
                      ),

                      Text(
                        "This feature is currently inactive.",
                        style: TextStyle(
                          color: (themeProvider.defaultTheme)
                              ? Colors.yellow
                              : Colors.yellow,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 10),
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
                              // Navigator.pop(context);
                              toggleLadderActivation(
                                ladderInfo,
                                isInActive,
                                filterOption: stockFilterOption,
                                indexOfStockFilterChange: indexOfStock,
                              );
                            },
                            child: const Text(
                              "Ok",
                              style: TextStyle(color: Color(0xFF0099CC)),
                            ),
                          ),
                        ],
                      ),
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
        toggleLadderActivation(
          ladderInfo,
          false,
          filterOption: stockFilterOption,
          indexOfStockFilterChange: indexOfStock,
        );
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
                  borderRadius: BorderRadius.circular(20),
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
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("OK"),
                    ),
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Something went wrong!")));
      }
    });
  }

  Future<void> putCashLadderDialog(BuildContext context, Ladder ladderData) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog();
      },
    );
  }

  Future<void> emptyLadderDialog(BuildContext context, Ladder ladderData) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: (themeProvider.defaultTheme)
              ? Colors.white
              : Colors.black,
          title: Text("Make Ladder Cash Empty"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Making the ladder cash empty will deallocated the funds from the ladder and the ladder will deactive",
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 20.0,
                  right: 20.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () async {
                        await EmptyLadderService().cashEmptyLadder(
                          CashEmptyLadderRequest(ladId: ladderData.ladId),
                          context,
                        );
                      },
                      child: Text(
                        "Proceed",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel"),
                    ),
                  ],
                ),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
            side: const BorderSide(color: Colors.white, width: 1),
          ),
        );
      },
    );
  }

Future<void> deleteLadderDialog(Ladder ladderData) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setStateSB) {
          return AlertDialog(
            title: Text(
              'Delete Ladder',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blue),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Text('Enter Minimum Limit Price'),
                SizedBox(height: 5),
                (ladderProvider.showLimitPriceTextField)
                    ? buildLimitPriceTextField(context)
                    : Container(),
                SizedBox(height: 10),
                Text('Enter Time in Min'),
                SizedBox(height: 5),
                buildLimitPriceTimeInMinTextField(context),
              ],
            ),
            actions: [
              Row(
                children: [
                  SizedBox(width: 5),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (ladderProvider.selectedProductType == "LIMIT" &&
                            (ladderProvider.limitPrice == 'null' ||
                                ladderProvider.limitPriceTimeInMin == 'null')) {
                          if (ladderProvider.limitPrice == 'null') {
                            ladderProvider.limitPriceErrorText =
                                "Please enter min limit price";
                          }
                          if (ladderProvider.limitPriceTimeInMin == 'null') {
                            ladderProvider.limitPriceTimeInMinErrorText =
                                "Please enter time in min";
                          }
                          setStateSB(() {});
                        } else {
                          Navigator.pop(context); // Close current dialog
                          // Show confirmation dialog
                          showDialog(
                            context: context,
                            builder: (context) {
                              return deleteLadderAlertDialog(
                                "You sure you want to delete this ladder?",
                                ladderData,
                              );
                            },
                          );
                        }
                      },
                      child: Text(
                        'Proceed',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.blue),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                ],
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
              side: const BorderSide(color: Colors.white, width: 1),
            ),
            actionsAlignment: MainAxisAlignment.center,
            backgroundColor: const Color(0xFF15181F),
          );
        },
      );
    },
  );
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
                ? Color(0xffCACAD3)
                : Color(0xff2c2c31),
            borderColor: (themeProvider.defaultTheme)
                ? Color(0xffCACAD3)
                : Color(0xff2c2c31),
            textStyle: TextStyle(
              color: (themeProvider.defaultTheme) ? Colors.black : Colors.white,
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
              // FilteringTextInputFormatter.digitsOnly
              FilteringTextInputFormatter.allow(RegExp(r'^[0-9,\.]+$')),
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
            : Text(
                ladderProvider.limitPriceErrorText,
                style: TextStyle(color: Colors.red),
              ),
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
                ? Color(0xffCACAD3)
                : Color(0xff2c2c31),
            borderColor: (themeProvider.defaultTheme)
                ? Color(0xffCACAD3)
                : Color(0xff2c2c31),
            textStyle: TextStyle(
              color: (themeProvider.defaultTheme) ? Colors.black : Colors.white,
            ),
            maxLength: 2,
            elevation: 0,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
            // textStyle: (themeProvider.defaultTheme)
            //     ? TextStyle(color: Colors.black)
            //     : kBodyText,
            // borderColor: Color(0xff2c2c31),
            margin: EdgeInsets.zero,
            focusedBorderColor:
                ((ladderProvider.limitPriceTimeInMinErrorText != ""))
                ? Color(0xffd41f1f)
                : Color(0xff5cbbff),
            counterText: "",
            textInputFormatters: [
              FilteringTextInputFormatter.digitsOnly,

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
            : Text(
                ladderProvider.limitPriceTimeInMinErrorText,
                style: TextStyle(color: Colors.red),
              ),
      ],
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
      ladCashAssigned: ladderData.ladCashAssigned,
    );
  }

  storeValueInLadderList(BuildContext context, List<Ladder> ladderDataList) {
    mergeLadderProvider.ladderList.clear();
    for (int i = 0; i < ladderDataList.length; i++) {
      mergeLadderProvider.ladderList.add(
        merge_ladder.Ladder(
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
          ladExtraCashGenerated: ladderDataList[i].ladExtraCashGenerated
              .toString(),
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
          ladCashAssigned: ladderDataList[i].ladCashAssigned,
        ),
      );
    }
  }

  storeValueInLadderL1ForMoveFundsToLadder(
    BuildContext context,
    Ladder ladderData,
  ) {
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
    BuildContext context,
    List<Ladder> ladderDataList,
  ) {
    moveFundsToLadderProvider.ladderList.clear();
    for (int i = 0; i < ladderDataList.length; i++) {
      moveFundsToLadderProvider.ladderList.add(
        move_funds_to_ladder.Ladder(
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
          ladExtraCashGenerated: ladderDataList[i].ladExtraCashGenerated
              .toString(),
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
        ),
      );
    }
  }


  Future<void> refreshAfterDeleteLadder() async {
  if (mounted) {
    // Reset pagination
    setState(() {
      _nextCursor = null;
      _hasMore = true;
    });
    
    // Refresh ladder list
    await _ladderProvider!.fetchAllLadder(
      _currencyConstantsProvider!,
      nextCursor: null,
      isInitialLoading: true,
    );
    
    setState(() {
      _nextCursor = _ladderProvider!.nextCursor;
      _hasMore = _ladderProvider!.hasMore;
    });
  }
}

Future<void> deleteLadder(Ladder ladderData) async {
  try {
    await LadderRestApiService().deleteLadder(
      DeleteLadderRequest(ladId: ladderData.ladId ?? 0),
    );
    
    // Refresh the ladder list immediately
    await refreshAfterDeleteLadder();
    
    // Refresh other related data
    await _tradeMainProvider!.getActiveLadderTickers(context);
    await _customHomeAppBarProvider!.fetchUserAccountDetails();
    
    if (mounted) {
      Fluttertoast.showToast(msg: "Ladder deleted successfully");
    }
    
  } on HttpApiException catch (err) {
    if (mounted) {
      Fluttertoast.showToast(msg: err.errorTitle);
    }
    print(err.errorTitle);
  }
}

  @override
  Widget build(BuildContext context) {
    emptyLadderProvider = Provider.of<EmptyLadderProvider>(
      context,
      listen: true,
    );
    customHomeAppBarProvider = Provider.of<CustomHomeAppBarProvider>(
      context,
      listen: true,
    );
    ladderAddOrWithdrawCashProvider =
        Provider.of<LadderAddOrWithdrawCashProvider>(context, listen: true);
    navigationProvider = Provider.of<NavigationProvider>(context, listen: true);
    mergeLadderProvider = Provider.of<MergeLadderProvider>(
      context,
      listen: true,
    );
    ladderProvider = Provider.of<LadderProvider>(context, listen: true);
    moveFundsToLadderProvider = Provider.of<MoveFundsToLadderProvider>(
      context,
      listen: true,
    );
    modifyLadderTargetPriceProvider =
        Provider.of<ModifyLadderTargetPriceProvider>(context, listen: true);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    webSocketServiceProvider = Provider.of<WebSocketServiceProvider>(
      context,
      listen: true,
    );
    double screenWidth = screenWidthRecognizer(context);
    return Scaffold(
      backgroundColor: (themeProvider.defaultTheme)
          ? Color(0xfff0f0f0) //Color(0XFFF5F5F5)
          : Color(0xFF15181F),
      body: (ladderProvider.isLoading)
          ? buildLadderLoadingWidget(context, screenWidth)
          : ladderProvider.stockLadders.isEmpty
          ? Center(child: Text("No ladders", style: TextStyle(fontSize: 18)))
          : buildLadderSection(context, screenWidth),
    );
  }

  Widget buildLadderSection(BuildContext context, double screenWidth) {
    return Consumer<LadderProvider>(
      builder: (context, provider, child) {
        // print("provider.stockLadders.length ${provider.stockLadders.length}");
        final itemCount =
            provider.stockLadders.length + (_isLoadingMore ? 1 : 0);
        return ListView.builder(
          controller: _scrollController,
          itemCount: itemCount,
          itemBuilder: (context, stockIndex) {
            // Loading indicator at the bottom
            print(stockIndex);
            if (stockIndex == provider.stockLadders.length) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(
                    color: themeProvider.defaultTheme
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              );
            } // Safety check
            if (stockIndex > provider.stockLadders.length) {
              return SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Column(
                children: [
                  CustomContainer(
                    borderRadius: 0,
                    backgroundColor: (themeProvider.defaultTheme)
                        ? Color(0xffdadde6)
                        : Color(0xff1b1b1b), // Color(0xff1b1b1b),
                    padding: 0,
                    margin: EdgeInsets.zero,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "  ${stockIndex + 1} ",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: (themeProvider.defaultTheme)
                                    ? Color(0xff0f0f0f)
                                    : Color(0xfff0f0f0),
                              ),
                            ),

                            Text(
                              "${provider.stockLadders[stockIndex].stockName}",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: (themeProvider.defaultTheme)
                                    ? Color(0xff0f0f0f)
                                    : Color(0xfff0f0f0),
                              ),
                            ),

                            Text(
                              " | ${_currencyConstantsProvider!.currency}${provider.stockLadders[stockIndex].currentPrice}",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                                color: (themeProvider.defaultTheme)
                                    ? Color(0xff0f0f0f)
                                    : Color(0xfff0f0f0),
                              ),
                            ),

                            Text(
                              " (${provider.stockLadders[stockIndex].ladders.length} Ladders)",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                                color: (themeProvider.defaultTheme)
                                    ? Color(0xff0f0f0f)
                                    : Color(0xffa2b0bc),
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                provider.updateStockFilterAtIndex = stockIndex;
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        provider
                                                .stockLadders[stockIndex]
                                                .selectedFilter ==
                                            FilterOption.all
                                        ? Colors.green
                                        : provider
                                                  .stockLadders[stockIndex]
                                                  .selectedFilter ==
                                              FilterOption.active
                                        ? Colors.orange
                                        : provider
                                                  .stockLadders[stockIndex]
                                                  .selectedFilter ==
                                              FilterOption.inactive
                                        ? Colors.blue
                                        : Colors.purple,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  provider
                                              .stockLadders[stockIndex]
                                              .selectedFilter ==
                                          FilterOption.all
                                      ? "All"
                                      : provider
                                                .stockLadders[stockIndex]
                                                .selectedFilter ==
                                            FilterOption.active
                                      ? "Active"
                                      : provider
                                                .stockLadders[stockIndex]
                                                .selectedFilter ==
                                            FilterOption.inactive
                                      ? "Inactive"
                                      : "Cash Empty",
                                  style: TextStyle(
                                    color:
                                        provider
                                                .stockLadders[stockIndex]
                                                .selectedFilter ==
                                            FilterOption.all
                                        ? Colors.green
                                        : provider
                                                  .stockLadders[stockIndex]
                                                  .selectedFilter ==
                                              FilterOption.active
                                        ? Colors.orange
                                        : provider
                                                  .stockLadders[stockIndex]
                                                  .selectedFilter ==
                                              FilterOption.inactive
                                        ? Colors.blue
                                        : Colors.purple,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                provider.toggleExpandLadderTileAtIndex =
                                    stockIndex;
                              },
                              icon:
                                  provider
                                      .ladderExpansionControllers[stockIndex]
                                  ? Icon(
                                      Icons.keyboard_arrow_up,
                                      color: (themeProvider.defaultTheme)
                                          ? Colors.black
                                          : Colors.white,
                                    )
                                  : Icon(
                                      Icons.keyboard_arrow_down,
                                      color: (themeProvider.defaultTheme)
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Visibility(
                    visible: provider.ladderExpansionControllers[stockIndex],
                    child: Column(
                      children: [
                        for (
                          var i = 0;
                          i < provider.stockLadders[stockIndex].ladders.length;
                          i++
                        )
                          if (provider
                                      .stockLadders[stockIndex]
                                      .selectedFilter ==
                                  FilterOption.all ||
                              provider
                                      .stockLadders[stockIndex]
                                      .selectedFilter ==
                                  provider
                                      .stockLadders[stockIndex]
                                      .ladders[i]
                                      .ladStatus)
                            buildSubLaddersSection(
                              context,
                              screenWidth,
                              stockIndex,
                              i,
                              provider.stockLadders[stockIndex],
                              provider.stockLadders[stockIndex].ladders[i],
                            ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget buildSubLaddersSection(
    BuildContext context,
    double screenWidth,
    int indexOfStock,
    int indexOfLadder,
    LadderListModel stockIndex,
    Ladder ladderIndex,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5, left: 6, right: 6),
      child: CustomContainer(
        padding: 0,
        margin: EdgeInsets.zero,
        borderRadius: 10,
        backgroundColor: (themeProvider.defaultTheme)
            ? Color(0xffdadde6)
            : Color(0xff2c2c31), //Color(0xff2c2c31),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 12,
            right: 12,
            bottom: 5,
            top: 5.0,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "${stockIndex.stockName} ${ladderIndex.ladName} (${ladderIndex.ladExchange})",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: (themeProvider.defaultTheme)
                              ? Color(0xff0f0f0f)
                              : Color(0xfff0f0f0),
                        ),
                      ),

                      Transform.scale(
                        scale: 0.7,
                        child: Switch(
                          value: ladderIndex.ladStatus != FilterOption.inactive,
                          onChanged: (value1) {
                            if (ladderIndex.noFollowup == false) {
                              if (!modifyBtnClick) {
                                if (ladderIndex.ladStatus == FilterOption.inactive) {
                                  if (Utility().checkForSubscription(context)) {

                                    if(ladderIndex.isOneClick) {

                                      showDialog(
                                        context: context,
                                        builder: (context) => oneClickLadderDetailsPopup(context, ladderIndex, indexOfStock, stockIndex),
                                      );

                                    } else {
                                      modifyBtnClick = true;
                                      toggleLadderStatus(
                                        indexOfStock,
                                        stockIndex.selectedFilter,
                                        ladderIndex,
                                        ladderIndex.ladStatus,
                                        ladderIndex.ladStatus ==
                                            FilterOption.inactive,
                                      );
                                    }

                                  }
                                } else {
                                  modifyBtnClick = true;
                                  toggleLadderStatus(
                                    indexOfStock,
                                    stockIndex.selectedFilter,
                                    ladderIndex,
                                    ladderIndex.ladStatus,
                                    ladderIndex.ladStatus ==
                                        FilterOption.inactive,
                                  );
                                }
                              }
                            }
                          },
                          inactiveTrackColor: Colors.grey,
                          inactiveThumbColor: Colors.white,
                          activeColor: Color(0xff34c759),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      CustomContainer(
                        backgroundColor: Colors.transparent,
                        onTap: () {
                          if (ladderIndex.noFollowup == false) {
                            if (!modifyBtnClick) {
                              modifyBtnClick = true;
                              showDialog(
                                context: context,
                                builder: (context) => buildModifyOptions(
                                  context,
                                  ladderIndex,
                                  stockIndex,
                                ),
                              );
                            }
                          }
                        },
                        child: Icon(
                          Icons.edit,
                          size: 20,
                          color: (themeProvider.defaultTheme)
                              ? Color(0xff0f0f0f)
                              : Color(0xfff0f0f0),
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          print("icon tapped");
                          ladderProvider.toggleAllValueVisible(
                            indexOfStock,
                            indexOfLadder,
                          );
                        },
                        icon: (ladderIndex.isAllValueVisible == false)
                            ? Icon(
                                Icons.keyboard_arrow_up,
                                color: (themeProvider.defaultTheme)
                                    ? Colors.black
                                    : Colors.white,
                              )
                            : Icon(
                                Icons.keyboard_arrow_down,
                                color: (themeProvider.defaultTheme)
                                    ? Colors.black
                                    : Colors.white,
                              ),
                      ),
                    ],
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

                  SizedBox(width: 5),

                  CustomContainer(
                    padding: 0,
                    margin: EdgeInsets.zero,
                    backgroundColor: Colors.blue[800],
                    // backgroundColor: themeProvider.defaultTheme
                    //     ? Colors.blue
                    //     : Color(0xFF0099CC),
                    borderRadius: 8, // 50,
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
                                    style: TextStyle(color: Colors.greenAccent),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              Row(
                                children: [
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        Map<String, dynamic> data = {
                                          "lad_id": ladderIndex.ladId ?? "",
                                          "stock_name": stockIndex.stockName,
                                        };
                                        LadderRestApiService()
                                            .userLadderExecutedOrderDownloadCsv(
                                              data,
                                            )
                                            .then((value) {
                                              Navigator.pop(context);
                                              Fluttertoast.showToast(
                                                msg: "success",
                                              );
                                            })
                                            .catchError((err) {
                                              Navigator.pop(context);
                                              print(err);
                                            });
                                      },
                                      child: Text(
                                        'OK',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                ],
                              ),
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
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: FittedBox(
                        child: AutoSizeText(
                          "Exc. Orders",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.white,
                            // color: themeProvider.defaultTheme
                            //     ? Colors.blue
                            //     : Color(0xFF0099CC),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 5),

                  Text(
                    " / ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: themeProvider.defaultTheme
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),

                  SizedBox(width: 5),

                  CustomContainer(
                    padding: 0,
                    margin: EdgeInsets.zero,
                    backgroundColor: Colors.blue[800],
                    // backgroundColor: themeProvider.defaultTheme
                    //     ? Colors.blue
                    //     : Color(0xFF0099CC),
                    borderRadius: 8,
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
                                    style: TextStyle(color: Colors.greenAccent),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              Row(
                                children: [
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        Map<String, dynamic> data = {
                                          "lad_id": ladderIndex.ladId ?? "",
                                          "stock_name": stockIndex.stockName,
                                        };
                                        LadderRestApiService()
                                            .userLadderAllOrderDownloadCsv(data)
                                            .then((value) {
                                              Navigator.pop(context);
                                              Fluttertoast.showToast(
                                                msg: "success",
                                              );
                                            })
                                            .catchError((err) {
                                              Navigator.pop(context);
                                              print(err);
                                            });
                                      },
                                      child: Text(
                                        'OK',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                ],
                              ),
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
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: FittedBox(
                        child: AutoSizeText(
                          " All Orders ",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.white,
                            // color: themeProvider.defaultTheme
                            //     ? Colors.blue
                            //     : Color(0xFF0099CC),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Divider(color: Colors.grey, thickness: 0.3),

              Column(
                children: [
                  (ladderIndex.isAllValueVisible == false)
                      ? Container()
                      : SizedBox(height: 8),

                  (ladderIndex.isAllValueVisible == false)
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Min/Initial price",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: (themeProvider.defaultTheme)
                                    ? Colors.purple[400]
                                    : Colors.yellow[200],
                                // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                              ),
                            ),

                            Text(
                              "${amountToInrFormat(context, ladderIndex.ladMinimumPrice)}/${amountToInrFormat(context, ladderIndex.ladInitialBuyPrice)}",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: (themeProvider.defaultTheme)
                                    ? Colors.purple[400]
                                    : Colors.yellow[200],
                                // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                              ),
                            ),
                          ],
                        ),

                  (ladderIndex.isAllValueVisible == false)
                      ? Container()
                      : SizedBox(height: 5),

                  (ladderIndex.isAllValueVisible == false)
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Target price",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: (themeProvider.defaultTheme)
                                    ? Colors.purple[400]
                                    : Colors.yellow[200],
                                // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                              ),
                            ),

                            Text(
                              "${amountToInrFormat(context, ladderIndex.ladTargetPrice)}",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: (themeProvider.defaultTheme)
                                    ? Colors.purple[400]
                                    : Colors.yellow[200],
                                // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                              ),
                            ),
                          ],
                        ),

                  SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Cash gain",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: (themeProvider.defaultTheme)
                              ? Colors.green[800]
                              : Colors.green,
                          // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                        ),
                      ),

                      Text(
                        "${amountToInrFormat(context, ladderIndex.ladCashGain)}",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: (themeProvider.defaultTheme)
                              ? Colors.green[800]
                              : Colors.green,
                          // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Cash Needed",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: (themeProvider.defaultTheme)
                              ? Colors.green[800]
                              : Colors.green,
                          // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                        ),
                      ),

                      Text(
                        "${amountToInrFormat(context, ladderIndex.ladCashNeeded)}",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: (themeProvider.defaultTheme)
                              ? Colors.green[800]
                              : Colors.green,
                          // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 5),

                  (ladderIndex.isAllValueVisible == false)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Profit/Extra Cash",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: (themeProvider.defaultTheme)
                                    ? Colors.green[800]
                                    : Colors.green,
                                // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                              ),
                            ),

                            Text(
                              "${amountToInrFormat(context, (ladderIndex.ladCurrentQuantity * stockIndex.currentPrice) + ladderIndex.ladCashGain)}/${amountToInrFormat(context, ladderIndex.ladExtraCashGenerated)}",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: (themeProvider.defaultTheme)
                                    ? Colors.green[800]
                                    : Colors.green,
                                // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Alloc. Cash",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: (themeProvider.defaultTheme)
                                        ? Colors.green[800]
                                        : Colors.green,
                                    // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                                  ),
                                ),

                                Text(
                                  "${amountToInrFormat(context, ladderIndex.ladCashAllocated)}",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: (themeProvider.defaultTheme)
                                        ? Colors.green[800]
                                        : Colors.green,
                                    // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 5),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Extra Cash/per Order",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: (themeProvider.defaultTheme)
                                        ? Colors.green[800]
                                        : Colors.green,
                                    // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                                  ),
                                ),

                                Text(
                                  "${amountToInrFormat(context, ladderIndex.ladExtraCashGenerated)}/${amountToInrFormat(context, ladderIndex.ladExtraCashPerOrder)}",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: (themeProvider.defaultTheme)
                                        ? Colors.green[800]
                                        : Colors.green,
                                    // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                  (ladderIndex.isAllValueVisible == false)
                      ? Container()
                      : SizedBox(height: 5),

                  (ladderIndex.isAllValueVisible == false)
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Realized profit/Total Profit:",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: (themeProvider.defaultTheme)
                                    ? Colors.green[800]
                                    : Colors.green,
                                // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                              ),
                            ),

                            Text(
                              "${amountToInrFormat(context, ladderIndex.ladRealizedProfit)} / ${amountToInrFormat(context, (ladderIndex.ladCurrentQuantity * stockIndex.currentPrice) + ladderIndex.ladCashGain)}",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: (themeProvider.defaultTheme)
                                    ? Colors.green[800]
                                    : Colors.green,
                                // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                              ),
                            ),
                          ],
                        ),
                ],
              ),

              (ladderIndex.isAllValueVisible == false)
                  ? Container()
                  : SizedBox(height: 5),

              (ladderIndex.isAllValueVisible == false)
                  ? Container()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Number of steps above/below",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: (themeProvider.defaultTheme)
                                ? Color.fromARGB(255, 226, 98, 43)
                                : Color.fromARGB(255, 222, 142, 13),
                            // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                          ),
                        ),

                        Text(
                          "${((ladderIndex.ladCurrentQuantity == 0 ? ladderIndex.ladInitialBuyQuantity : ladderIndex.ladCurrentQuantity) / ladderIndex.ladDefaultBuySellQuantity).toStringAsFixed(2)}/${(stockIndex.currentPrice / ladderIndex.ladStepSize).floor()}.00",
                          // "${_currencyConstantsProvider?.currency}${((ladderIndex.ladCurrentQuantity == 0 ? ladderIndex.ladInitialBuyQuantity : ladderIndex.ladCurrentQuantity) / ladderIndex.ladDefaultBuySellQuantity).toStringAsFixed(2)}/${(ladderProvider.stockLadders[stockIndex].currentPrice / ladderIndex.ladStepSize).floor()}",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: (themeProvider.defaultTheme)
                                ? Color.fromARGB(255, 226, 98, 43)
                                : Color.fromARGB(255, 222, 142, 13),
                            // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                          ),
                        ),
                      ],
                    ),

              SizedBox(height: 5),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Steps/Price moved",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: (themeProvider.defaultTheme)
                          ? Color.fromARGB(255, 226, 98, 43)
                          : Color.fromARGB(255, 222, 142, 13),
                      // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                    ),
                  ),

                  Text(
                    "${((stockIndex.currentPrice - ladderIndex.ladInitialBuyPrice) / ladderIndex.ladStepSize).toStringAsFixed(2)}/${(stockIndex.currentPrice - ladderIndex.ladInitialBuyPrice).toStringAsFixed(2)}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: (themeProvider.defaultTheme)
                          ? Color.fromARGB(255, 226, 98, 43)
                          : Color.fromARGB(255, 222, 142, 13),
                      // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                    ),
                  ),
                ],
              ),

              Column(
                children: [
                  (ladderIndex.isAllValueVisible == false)
                      ? Container()
                      : SizedBox(height: 5),

                  (ladderIndex.isAllValueVisible == false)
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Ladder number",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: (themeProvider.defaultTheme)
                                    ? Color.fromARGB(255, 226, 98, 43)
                                    : Color.fromARGB(255, 222, 142, 13),
                                // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                              ),
                            ),

                            Text(
                              "${ladderIndex.ladId}",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: (themeProvider.defaultTheme)
                                    ? Color.fromARGB(255, 226, 98, 43)
                                    : Color.fromARGB(255, 222, 142, 13),
                                // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                              ),
                            ),
                          ],
                        ),

                  (ladderIndex.isAllValueVisible == false)
                      ? Container()
                      : SizedBox(height: 5),

                  (ladderIndex.isAllValueVisible == false)
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Step Size",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: (themeProvider.defaultTheme)
                                    ? Color.fromARGB(255, 226, 98, 43)
                                    : Color.fromARGB(255, 222, 142, 13),
                                // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                              ),
                            ),

                            Text(
                              "${amountToInrFormat(context, ladderIndex.ladStepSize)}",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: (themeProvider.defaultTheme)
                                    ? Color.fromARGB(255, 226, 98, 43)
                                    : Color.fromARGB(255, 222, 142, 13),
                                // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                              ),
                            ),
                          ],
                        ),

                  SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        // "Qty init/buysell/current",
                        "Qty init/order size/current",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: (themeProvider.defaultTheme)
                              ? Colors.indigo[800]
                              : Colors.indigo[200],
                          // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                        ),
                      ),

                      Text(
                        "${ladderIndex.ladInitialBuyQuantity}/ ${ladderIndex.ladDefaultBuySellQuantity}/ ${ladderIndex.ladCurrentQuantity}",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: (themeProvider.defaultTheme)
                              ? Colors.indigo[800]
                              : Colors.indigo[200],
                          // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                        ),
                      ),
                    ],
                  ),

                  (ladderIndex.isAllValueVisible == false)
                      ? Container()
                      : SizedBox(height: 5),

                  (ladderIndex.isAllValueVisible == false)
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Ladder exe. orders/open orders",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: (themeProvider.defaultTheme)
                                    ? Colors.indigo[800]
                                    : Colors.indigo[200],
                                // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                              ),
                            ),

                            Text(
                              "${ladderIndex.ladExecutedOrders}/${ladderIndex.ladOpenOrders}",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: (themeProvider.defaultTheme)
                                    ? Colors.indigo[800]
                                    : Colors.indigo[200],
                                // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                              ),
                            ),
                          ],
                        ),

                  SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Loss/Capital Recovery",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: (themeProvider.defaultTheme)
                              ? Color(0xff0f0f0f)
                              : Color(0xfff0f0f0),
                        ),
                      ),

                      Text(
                        "${(ladderIndex.timeToRecoverLossesInDays! <= 0) ? "NA" : ladderIndex.timeToRecoverLossesInDays} D / ${(ladderIndex.timeToRecoverInvestmentInYears! <= 0) ? "NA" : ladderIndex.timeToRecoverInvestmentInYears} Y",
                        // (ladderIndex.timeToRecoverInvestmentInYears! <= 0)
                        //     ?"NA"
                        //     :"${ladderProvider.stockLadders[stockIndex].ladders[ladderIndex].timeToRecoverInvestmentInYears}",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: (themeProvider.defaultTheme)
                              ? Color(0xff0f0f0f)
                              : Color(0xfff0f0f0),
                        ),
                      ),
                    ],
                  ),

                  // (ladderIndex.isAllValueVisible == false)   //   maiAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       "Loss/Capital Recovery",
                  //       style: GoogleFonts.poppins(
                  //           fontWeight: FontWeight.w400,
                  //           fontSize: 14,
                  //           color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                  //       ),
                  //     ),
                  //
                  //     Text(
                  //       "${(ladderProvider.stockLadders[stockIndex].ladders[ladderIndex].timeToRecoverLossesInDays! <= 0) ?"NA":ladderProvider.stockLadders[stockIndex].ladders[ladderIndex].timeToRecoverLossesInDays}D/${(ladderProvider.stockLadders[stockIndex].ladders[ladderIndex].timeToRecoverInvestmentInYears! <= 0)?"NA":ladderProvider.stockLadders[stockIndex].ladders[ladderIndex].timeToRecoverInvestmentInYears}Y",
                  //       // (ladderProvider.stockLadders[stockIndex].ladders[ladderIndex].timeToRecoverInvestmentInYears! <= 0)
                  //       //     ?"NA"
                  //       //     :"${ladderProvider.stockLadders[stockIndex].ladders[ladderIndex].timeToRecoverInvestmentInYears}",
                  //       style: GoogleFonts.poppins(
                  //           fontWeight: FontWeight.w500,
                  //           fontSize: 14,
                  //           color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                  //       ),
                  //     )
                  //   ],
                  // ):Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       "Time To Recover Investment In Years",
                  //       style: GoogleFonts.poppins(
                  //           fontWeight: FontWeight.w400,
                  //           fontSize: 14,
                  //           color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                  //       ),
                  //     ),
                  //
                  //     Text(
                  //       (ladderProvider.stockLadders[stockIndex].ladders[ladderIndex].timeToRecoverInvestmentInYears! <= 0)
                  //           ?"NA"
                  //           :"${ladderProvider.stockLadders[stockIndex].ladders[ladderIndex].timeToRecoverInvestmentInYears}",
                  //       style: GoogleFonts.poppins(
                  //           fontWeight: FontWeight.w500,
                  //           fontSize: 14,
                  //           color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                  //       ),
                  //     )
                  //   ],
                  // ),

                  // (ladderIndex.isAllValueVisible == false)(
                  //   height: 5,
                  // ),
                  //
                  // (ladderProvider.stockLadders[stockIndex].ladders[ladderIndex].isAllValueVisible == false)
                  //     ? Container():Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       "Time To Recover Losses In Days",
                  //       style: GoogleFonts.poppins(
                  //           fontWeight: FontWeight.w400,
                  //           fontSize: 14,
                  //           color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                  //       ),
                  //     ),
                  //
                  //     Text(
                  //       (ladderProvider.stockLadders[stockIndex].ladders[ladderIndex].timeToRecoverLossesInDays! <= 0)
                  //           ?"NA"
                  //           :"${ladderProvider.stockLadders[stockIndex].ladders[ladderIndex].timeToRecoverLossesInDays}",
                  //       style: GoogleFonts.poppins(
                  //           fontWeight: FontWeight.w500,
                  //           fontSize: 14,
                  //           color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                  //       ),
                  //     )
                  //   ],
                  // ),
                  (ladderIndex.isAllValueVisible == false)
                      ? Container()
                      : SizedBox(height: 5),

                  (ladderIndex.isAllValueVisible == false)
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "No. of Trades/Month",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: (themeProvider.defaultTheme)
                                    ? Color(0xff0f0f0f)
                                    : Color(0xfff0f0f0),
                              ),
                            ),

                            Text(
                              "${ladderIndex.noOfTradesPerMonth}",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: (themeProvider.defaultTheme)
                                    ? Color(0xff0f0f0f)
                                    : Color(0xfff0f0f0),
                              ),
                            ),
                          ],
                        ),

                  SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        // "Amount Already Recovered",
                        "Investment Recovered",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: (themeProvider.defaultTheme)
                              ? Color(0xff0f0f0f)
                              : Color(0xfff0f0f0),
                        ),
                      ),

                      Text(
                        "${ladderIndex.amountAlreadyRecovered}",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: (themeProvider.defaultTheme)
                              ? Color(0xff0f0f0f)
                              : Color(0xfff0f0f0),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Brokerage/Other Charges",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: (themeProvider.defaultTheme)
                              ? Color(0xff0f0f0f)
                              : Color(0xfff0f0f0),
                        ),
                      ),

                      Text(
                        "${amountToInrFormat(context, ladderIndex.actualBrokerageCost)} / ${amountToInrFormat(context, ladderIndex.otherBrokerageCharges)}",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: (themeProvider.defaultTheme)
                              ? Color(0xff0f0f0f)
                              : Color(0xfff0f0f0),
                        ),
                      ),
                    ],
                  ),

                  (ladderIndex.isAllValueVisible == false)
                      ? Container()
                      : SizedBox(height: 5),

                  (ladderIndex.isAllValueVisible == false)
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Created At",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: (themeProvider.defaultTheme)
                                    ? Color(0xff0f0f0f)
                                    : Color(0xfff0f0f0),
                              ),
                            ),

                            Text(
                              // "${ladderProvider.stockLadders[stockIndex].ladders[ladderIndex].createdAt}",
                              "${Utility().formatUtcToLocal(ladderIndex.createdAt.toString())}",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: (themeProvider.defaultTheme)
                                    ? Color(0xff0f0f0f)
                                    : Color(0xfff0f0f0),
                              ),
                            ),
                          ],
                        ),

                  // SizedBox(
                  //   height: 5,
                  // ),
                  //
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       "Actual Brokerage",
                  //       style: GoogleFonts.poppins(
                  //           fontWeight: FontWeight.w400,
                  //           fontSize: 14,
                  //           color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                  //       ),
                  //     ),
                  //
                  //     Text(
                  //       "${amountToInrFormat(context, ladderIndex.actualBrokerageCost)}",
                  //       style: GoogleFonts.poppins(
                  //           fontWeight: FontWeight.w500,
                  //           fontSize: 14,
                  //           color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                  //       ),
                  //     )
                  //   ],
                  // ),
                  //
                  // SizedBox(
                  //   height: 5,
                  // ),
                  //
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       "Other Charges",
                  //       style: GoogleFonts.poppins(
                  //           fontWeight: FontWeight.w400,
                  //           fontSize: 14,
                  //           color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                  //       ),
                  //     ),
                  //
                  //     Text(
                  //       // "#1,00,000.00/#1,00,000",
                  //       "${amountToInrFormat(context, ladderIndex.otherBrokerageCharges)}",
                  //       style: GoogleFonts.poppins(
                  //           fontWeight: FontWeight.w500,
                  //           fontSize: 14,
                  //           color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                  //       ),
                  //     )
                  //   ],
                  // ),
                ],
              ),

              SizedBox(height: 8),

              Divider(color: Colors.grey, thickness: 0.3),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomContainer(
                    backgroundColor: Colors.transparent,
                    onTap: () {
                      CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
                        ReviewLadderDialogNew(
                          stockExchange: ladderIndex.ladExchange,
                          inTradePage: true,
                          stockName: (ladderIndex.ladTicker),
                          tickerId: ladderIndex.ladTickerId ?? 0,
                          initialyProvidedTargetPrice:
                              ladderIndex.ladTargetPrice ?? 0.0,
                          initialPurchasePrice: ladderIndex.ladInitialBuyPrice
                              .toString(),
                          currentStockPrice: stockIndex.currentPrice.toString(),
                          allocatedCash: double.parse(
                            ladderIndex.ladCashAllocated.toString(),
                          ),
                          cashNeeded: ladderIndex.ladCashNeeded,
                          isMarketOrder: true,
                          minimumPriceForUpdateLadder:
                              ladderIndex.ladMinimumPrice,
                          setDefaultBuySellQty:
                              ladderIndex.ladDefaultBuySellQuantity,
                          newLadder: true,
                          symSecurityCode: ladderIndex.ladTickerId,
                          stepSize: ladderIndex.ladStepSize,
                          numberOfStepsAbove: ladderIndex.ladNumOfStepsAbove,
                          numberOfStepsBelow: ladderIndex.ladNumOfStepsBelow,
                          initialBuyQty:
                              (ladderIndex.ladInitialBuyQuantity) ?? 0,
                          actualCashAllocated: ladderIndex.ladCashAllocated,
                          actualInitialBuyCash:
                              ladderIndex.ladInitialBuyPrice *
                              ladderIndex.ladInitialBuyQuantity,
                          ladTargetPriceMultiplier: ladderIndex.ladTargetPrice,
                        ),
                        context,
                        height: 850,
                      );
                    },
                    child: Text(
                      "Show Ladder",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: (themeProvider.defaultTheme)
                            ? Color(0xff0f0f0f)
                            : Color(0xfff0f0f0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
              borderRadius: BorderRadius.circular(20),
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
                const SizedBox(height: 20),
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
                  leading: const Icon(Icons.edit, color: Colors.blue),
                  title: const Text(
                    "Edit ladder",
                    style: TextStyle(color: Colors.white),
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
    BuildContext context,
    Ladder ladderData,
    LadderListModel stockLadder,
  ) {
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
                  0xFF15181F,
                ), //value.defaultTheme ? Colors.white : Color(0xFF15181F),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 12),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.zero,
                  color: Colors.transparent,
                  child: ListTile(
                    dense: true,
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 18,
                      color:
                          (themeProvider.defaultTheme) // value.defaultTheme
                          ? Colors.black
                          : Colors.white,
                    ),
                    title: Text(
                      "Add Cash to ladder",
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            (themeProvider.defaultTheme) // value.defaultTheme
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    onTap: () async {
                      Navigator.pop(context);

                      ladderAddOrWithdrawCashProvider.selectedLadderData =
                          ladderData;

                      ladderAddOrWithdrawCashProvider.ladId =
                          ladderData.ladId ?? 0;
                      ladderAddOrWithdrawCashProvider.initialBuyExecuted =
                          ladderData.ladInitialBuyExecuted == 1 ? true : false;
                      ladderAddOrWithdrawCashProvider.initialBuyQuantity =
                          ladderData.ladInitialBuyQuantity;
                      await ladderAddOrWithdrawCashProvider.resetValues(
                        context,
                      );

                      print(
                        "below is account unallocated cash of add cash to ladder",
                      );
                      // print(fundsProvider.accountCashDetails?.data?.accountUnallocatedCash);

                      ladderAddOrWithdrawCashProvider.availableCashInAccount =
                          customHomeAppBarProvider
                              .getUserAccountDetails
                              ?.data
                              ?.accountUnallocatedCash ??
                          8000; // add this value from api later

                      // ladderAddOrWithdrawCashProvider.availableCashInAccount =
                      //     double.parse(fundsProvider.accountCashDetails?.data
                      //             ?.accountUnallocatedCash ??
                      //         '8000'); // add this value from api later

                      print(
                        ladderAddOrWithdrawCashProvider.availableCashInAccount,
                      );
                      ladderAddOrWithdrawCashProvider.target = double.parse(
                        ladderData.ladTargetPrice.toString(),
                      );
                      ladderAddOrWithdrawCashProvider.cashAlreadyAllocated =
                          double.parse(ladderData.ladCashAllocated.toString());
                      ladderAddOrWithdrawCashProvider.numberOfStepsAbove =
                          ladderData.ladNumOfStepsAbove;
                      ladderAddOrWithdrawCashProvider.numberOfStepsBelow =
                          ladderData.ladNumOfStepsBelow;
                      ladderAddOrWithdrawCashProvider.orderSize =
                          ladderData.ladDefaultBuySellQuantity;
                      ladderAddOrWithdrawCashProvider.currentPrice =
                          double.parse(
                            stockLadder.currentPrice.toString() ?? '0',
                          ); //4437; // add this value from api later
                      ladderAddOrWithdrawCashProvider.currentStockOwn =
                          ladderData.ladCurrentQuantity;
                      ladderAddOrWithdrawCashProvider.cashNeeded = double.parse(
                        ladderData.ladCashNeeded.toString(),
                      );
                      ladderAddOrWithdrawCashProvider.extraCashGenerated =
                          double.parse(
                            ladderData.ladExtraCashGenerated.toString(),
                          );
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
                      color:
                          (themeProvider.defaultTheme) // value.defaultTheme
                          ? Colors.black
                          : Colors.white,
                    ),
                    title: Text(
                      "Withdraw Cash from ladder",
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            (themeProvider.defaultTheme) // value.defaultTheme
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    onTap: () async {
                      Navigator.pop(context);

                      await ladderAddOrWithdrawCashProvider.resetValues(
                        context,
                      );
                      ladderAddOrWithdrawCashProvider.ladId =
                          ladderData.ladId ?? 0;

                      ladderAddOrWithdrawCashProvider.availableCashInAccount =
                          customHomeAppBarProvider
                              .getUserAccountDetails
                              ?.data
                              ?.accountUnallocatedCash ??
                          1000000;

                      // ladderAddOrWithdrawCashProvider.availableCashInAccount =
                      //     double.parse(fundsProvider.accountCashDetails?.data
                      //             ?.accountUnallocatedCash ??
                      //         '1000000'); // add this value from api later

                      ladderAddOrWithdrawCashProvider.target = double.parse(
                        ladderData.ladTargetPrice.toString(),
                      );
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
                      ladderAddOrWithdrawCashProvider.currentPrice =
                          double.parse(
                            stockLadder.currentPrice.toString() ?? '0',
                          ); //4437; // add this value from api later
                      ladderAddOrWithdrawCashProvider.currentStockOwn =
                          ladderData.ladCurrentQuantity;
                      ladderAddOrWithdrawCashProvider.cashNeeded = double.parse(
                        ladderData.ladCashNeeded.toString(),
                      );
                      ladderAddOrWithdrawCashProvider.extraCashGenerated =
                          double.parse(
                            ladderData.ladExtraCashGenerated.toString(),
                          );

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
                      color:
                          (themeProvider.defaultTheme) // value.defaultTheme
                          ? Colors.black
                          : Colors.white,
                    ),
                    title: Text(
                      "Merge two ladders",
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            (themeProvider.defaultTheme) // value.defaultTheme
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

                        List<Ladder> initialBoughtLadderList = stockLadder
                            .ladders
                            .where(
                              (ladder) =>
                                  (ladder.ladCurrentQuantity > 0 &&
                                  ladder.ladId != ladderData.ladId),
                            )
                            .toList();

                        if (initialBoughtLadderList.isNotEmpty &&
                            ladderData.ladCurrentQuantity > 0) {
                          mergeLadderProvider.availableCashInAccount =
                              customHomeAppBarProvider
                                  .getUserAccountDetails
                                  ?.data
                                  ?.accountUnallocatedCash ??
                              1000000;

                          // mergeLadderProvider.availableCashInAccount =
                          //     double.parse(fundsProvider.accountCashDetails?.data
                          //             ?.accountUnallocatedCash ??
                          //         '1000000'); // add this value from api later

                          mergeLadderProvider.currentPrice = double.parse(
                            stockLadder.currentPrice.toString() ?? '0',
                          ); //4437; // add this value from api later

                          await storeValueInLadderL1(context, ladderData);

                          await storeValueInLadderList(
                            context,
                            initialBoughtLadderList,
                          );

                          navigationProvider.previousSelectedIndex =
                              navigationProvider.selectedIndex;
                          navigationProvider.selectedIndex = 11;
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => mergeLadderAlertDialog(
                              context,
                              "You can't add ladder who's initial buy does not take place or Ladder reached his target price",
                            ),
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
                          builder: (context) => mergeLadderAlertDialog(
                            context,
                            "You should have more than 1 ladders of same stock to merge ladders with initial buy done",
                          ),
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
                      color:
                          (themeProvider.defaultTheme) // value.defaultTheme
                          ? Colors.black
                          : Colors.white,
                    ),
                    title: Text(
                      "Adjust Target",
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            (themeProvider.defaultTheme) // value.defaultTheme
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      modifyLadderTargetPriceProvider.selectedLadder =
                          ladderData;
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
                      modifyLadderTargetPriceProvider.calculateMinimumK(
                        ladderData.ladCashAllocated,
                      );
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
                      color:
                          (themeProvider.defaultTheme) // value.defaultTheme
                          ? Colors.black
                          : Colors.white,
                    ),
                    title: Text(
                      "Adjust step size",
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            (themeProvider.defaultTheme) // value.defaultTheme
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      modifyLadderTargetPriceProvider.selectedLadder =
                          ladderData;
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
                      modifyLadderTargetPriceProvider.selectedLadder =
                          ladderData;

                      modifyLadderTargetPriceProvider.calculateMinStepSize(
                        currentPrice: stockLadder.currentPrice,
                        targetPrice: ladderData.ladTargetPrice,
                        capital: ladderData.ladCashAllocated,
                      );
                      modifyLadderTargetPriceProvider.calculateMaxStepSize(
                        currentPrice: stockLadder.currentPrice,
                        targetPrice: ladderData.ladTargetPrice,
                        capital: ladderData.ladCashAllocated,
                      );

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
                      color:
                          (themeProvider.defaultTheme) // value.defaultTheme
                          ? Colors.black
                          : Colors.white,
                    ),
                    title: Text(
                      "Adjust order size",
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            (themeProvider.defaultTheme) // value.defaultTheme
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      modifyLadderTargetPriceProvider.selectedLadder =
                          ladderData;
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
                      modifyLadderTargetPriceProvider.selectedLadder =
                          ladderData;
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
                      color:
                          (themeProvider.defaultTheme) // value.defaultTheme
                          ? Colors.black
                          : Colors.white,
                    ),
                    title: Text(
                      // "Move Funds to Ladder",
                      "Move assets to Ladder",
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            (themeProvider.defaultTheme) // value.defaultTheme
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      modifyLadderTargetPriceProvider.selectedLadder =
                          ladderData;
                      if (stockLadder.ladders.length >= 2) {
                        List<Ladder> initialBoughtLadderList = stockLadder
                            .ladders
                            .where(
                              (ladder) =>
                                  (ladder.ladCurrentQuantity > 0 &&
                                  ladder.ladId != ladderData.ladId),
                            )
                            .toList();

                        if (initialBoughtLadderList.isNotEmpty &&
                            ladderData.ladCurrentQuantity > 0) {
                          moveFundsToLadderProvider.availableCashInAccount =
                              customHomeAppBarProvider
                                  .getUserAccountDetails
                                  ?.data
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
                            context,
                            ladderData,
                          );

                          await storeValueInLadderListForMoveFundsToLadder(
                            context,
                            initialBoughtLadderList,
                          );

                          navigationProvider.previousSelectedIndex =
                              navigationProvider.selectedIndex;
                          navigationProvider.selectedIndex = 17;
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => mergeLadderAlertDialog(
                              context,
                              // "You can't move funds to ladder who's initial buy does not take place or Ladder reached his target price"),
                              "You can't move assets to ladder who's initial buy does not take place or Ladder reached his target price",
                            ),
                          );
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => mergeLadderAlertDialog(
                            context,
                            // "You should have more than 1 ladders of same stock to move funds to ladders with initial buy done"),
                            "You should have more than 1 ladders of same stock to move assets to ladders with initial buy done",
                          ),
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
                        color:
                            (themeProvider.defaultTheme) // value.defaultTheme
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    onTap: () async {
                      modifyLadderTargetPriceProvider.selectedLadder =
                          ladderData;
                      emptyLadderProvider.ladStatus = ladderData.ladStatus;
                      ladderData.ladStatus != FilterOption.cashEmpty
                          ? await emptyLadderDialog(context, ladderData)
                          : Fluttertoast.showToast(
                              msg: "These Feature is locked",
                            );
                      Navigator.pop(context);
                      // putCashLadderDialog(context, ladderData);
                    },
                  ),
                ),
TextButton(
  onPressed: () async {
    if (ladderData.ladStatus == FilterOption.inactive) {
      Navigator.pop(context); // Close modify options dialog

      if (ladderData.ladCurrentQuantity <= 0) {
        showDialog(
          context: context,
          builder: (context) {
            return deleteLadderAlertDialog(
              "Are you sure you want to delete this ladder?",
              ladderData,
            );
          },
        );
      } else {
        await deleteLadderDialog(ladderData);
      }
    } else {
      Fluttertoast.showToast(
        msg: "Please deactivate the ladder before deleting",
      );
    }
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLimitAndMarketDropDown(BuildContext context, setStateSB) {
    return CustomContainer(
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
            items: ladderProvider.productType
                .map(
                  (sortType) => DropdownMenuItem<String>(
                    child: Text(sortType!),
                    value: sortType,
                  ),
                )
                .toList(),
          ),
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
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: (themeProvider.defaultTheme)
                    ? Colors.black
                    : Colors.white,
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
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Ok",
                    style: TextStyle(color: Color(0xFF0099CC)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Updated deleteLadderAlertDialog method
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
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: (themeProvider.defaultTheme)
                  ? Colors.black
                  : Colors.white,
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop(); // Close confirmation dialog
                      await deleteLadder(ladderData); // Delete and refresh
                    },
                    child: Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close confirmation dialog
                    },
                    child: Text(
                      "No",
                      style: TextStyle(
                        color: (themeProvider.defaultTheme)
                            ? Colors.black
                            : Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
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
                          screenWidth * 0.6,
                          25,
                        )
                      : ShimmerLoadingView.loadingContainer(
                          screenWidth * 0.6,
                          25,
                        ),

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
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  (themeProvider.defaultTheme)
                      ? ShimmerLoadingView.loadingContainerDark(
                          screenWidth * 0.4,
                          25,
                        )
                      : ShimmerLoadingView.loadingContainer(
                          screenWidth * 0.4,
                          25,
                        ),

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
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  (themeProvider.defaultTheme)
                      ? ShimmerLoadingView.loadingContainerDark(
                          screenWidth * 0.3,
                          25,
                        )
                      : ShimmerLoadingView.loadingContainer(
                          screenWidth * 0.3,
                          25,
                        ),

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
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  (themeProvider.defaultTheme)
                      ? ShimmerLoadingView.loadingContainerDark(
                          screenWidth * 0.3,
                          25,
                        )
                      : ShimmerLoadingView.loadingContainer(
                          screenWidth * 0.3,
                          25,
                        ),

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
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget oneClickLadderDetailsPopup(BuildContext context, Ladder ladderIndex, int indexOfStock, LadderListModel stockIndex,) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: CustomContainer(
        borderRadius: 20,
        backgroundColor: (themeProvider.defaultTheme)
            ? Color(0XFFF5F5F5)
            : Color(0xFF15181F),
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
                    "Activate one click ladder",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 12),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Divider(),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Allocated Cash",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: (themeProvider.defaultTheme)
                          ? Color(0xff0f0f0f)
                          : Color(0xfff0f0f0),
                    ),
                  ),

                  Text(
                    "${amountToInrFormat(context, ladderIndex.ladCashAllocated)}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: (themeProvider.defaultTheme)
                          ? Color(0xff0f0f0f)
                          : Color(0xfff0f0f0),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 5,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Target Price",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: (themeProvider.defaultTheme)
                          ? Color(0xff0f0f0f)
                          : Color(0xfff0f0f0),
                    ),
                  ),

                  Text(
                    "${ladderIndex.ladTargetPrice}",
                    // "${amountToInrFormat(context, ladderIndex.ladCashAllocated)}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: (themeProvider.defaultTheme)
                          ? Color(0xff0f0f0f)
                          : Color(0xfff0f0f0),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 5,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Initial purchase price",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: (themeProvider.defaultTheme)
                          ? Color(0xff0f0f0f)
                          : Color(0xfff0f0f0),
                    ),
                  ),

                  Text(
                    // "${ladderIndex.ladTargetPrice}",
                    "${amountToInrFormat(context, ladderIndex.ladInitialBuyPrice)}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: (themeProvider.defaultTheme)
                          ? Color(0xff0f0f0f)
                          : Color(0xfff0f0f0),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 5,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Initial Buy Quantity",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: (themeProvider.defaultTheme)
                          ? Color(0xff0f0f0f)
                          : Color(0xfff0f0f0),
                    ),
                  ),

                  Text(
                    "${ladderIndex.ladInitialBuyQuantity}",
                    // "${amountToInrFormat(context, ladderIndex.ladInitialBuyPrice)}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: (themeProvider.defaultTheme)
                          ? Color(0xff0f0f0f)
                          : Color(0xfff0f0f0),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 5,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Order Size",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: (themeProvider.defaultTheme)
                          ? Color(0xff0f0f0f)
                          : Color(0xfff0f0f0),
                    ),
                  ),

                  Text(
                    "${ladderIndex.ladDefaultBuySellQuantity}",
                    // "${amountToInrFormat(context, ladderIndex.ladInitialBuyPrice)}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: (themeProvider.defaultTheme)
                          ? Color(0xff0f0f0f)
                          : Color(0xfff0f0f0),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 5,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Step size",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: (themeProvider.defaultTheme)
                          ? Color(0xff0f0f0f)
                          : Color(0xfff0f0f0),
                    ),
                  ),

                  Text(
                    "${ladderIndex.ladStepSize}",
                    // "${amountToInrFormat(context, ladderIndex.ladInitialBuyPrice)}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: (themeProvider.defaultTheme)
                          ? Color(0xff0f0f0f)
                          : Color(0xfff0f0f0),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 5,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Cash needed",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: (themeProvider.defaultTheme)
                          ? Color(0xff0f0f0f)
                          : Color(0xfff0f0f0),
                    ),
                  ),

                  Text(
                    // "${ladderIndex.ladStepSize}",
                    "${amountToInrFormat(context, ladderIndex.ladCashNeeded)}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: (themeProvider.defaultTheme)
                          ? Color(0xff0f0f0f)
                          : Color(0xfff0f0f0),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8.0),
              child: Divider(),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    child: Text(
                      "Activate",
                      style: TextStyle(
                        color: (themeProvider.defaultTheme)?Color(0xFFf0f0f0):Color(0xFFf0f0f0),
                      ),
                    ),
                    onPressed: () {

                      Navigator.pop(context);

                      modifyBtnClick = true;
                      toggleLadderStatus(
                        indexOfStock,
                        stockIndex.selectedFilter,
                        ladderIndex,
                        ladderIndex.ladStatus,
                        ladderIndex.ladStatus == FilterOption.inactive,
                      );



                    },
                  ),

                  SizedBox(
                    width: 5,
                  ),

                  ElevatedButton(
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: (themeProvider.defaultTheme)?Color(0xFFf0f0f0):Color(0xFFf0f0f0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),

            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
