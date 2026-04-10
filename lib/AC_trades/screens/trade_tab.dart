import 'package:dozen_diamond/AC_trades/stateManagement/trades_provider.dart';
import 'package:dozen_diamond/ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:provider/provider.dart';

import '../../AC_trades/models/total_position_trade_action_request.dart';
import '../../AC_trades/widgets/close_trade_dialog.dart';

import '../../AC_trades/widgets/reduceTrade_dialog.dart';
import '../../AC_trades/widgets/replicate_trade_review_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../Settings/stateManagement/theme_provider.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/services/num_formatting.dart';
import '../../global/widgets/shimmer_loading_view.dart';
import '../../replicate_or_reduce/stateManagement/replicate_or_reduce_provider.dart';
import '../models/get_all_unsettled_trade_list_response.dart';
import '../services/trades_rest_api_service.dart';

class TradesTab extends StatefulWidget {
  final bool toggleReturnPrice;
  final String? selectedTicker;
  TradesTab({super.key, required this.toggleReturnPrice, this.selectedTicker});

  @override
  State<TradesTab> createState() => _TradesTabState();
}

class _TradesTabState extends State<TradesTab> {
  GetAllUnsettledTradeListResponse? getAllExecutedTradeListResponse;
  bool isError = false;
  List<bool> tradeActionVisible = [];
  final _replicateTradeFormKey = GlobalKey<FormState>();
  TradesProvider? _tradesProvider;
  final _tradeExecutPriceController = TextEditingController();
  final _tradeUnitController = TextEditingController();
  CurrencyConstants? _currencyConstantsProvider;

  late NavigationProvider navigationProvider;
  late ReplicateOrReduceProvider replicateOrReduceProvider;
  late ThemeProvider themeProvider;

  TradeMainProvider? _tradeMainProvider;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tradesProvider = Provider.of(context, listen: false);
    _tradeMainProvider = Provider.of(context, listen: false);
    _currencyConstantsProvider = Provider.of(context, listen: false);
    callInitialApi();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> callInitialApi() async {
    try {
      await _tradesProvider!.fetchTrades(_currencyConstantsProvider!);
    } on HttpApiException catch (err) {
      print(err);
    }
  }

  String? formatUtcToLocal(String? utcTime) {
    DateTime unFormatedUtcTime =
        new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(utcTime!, true);
    DateTime formatedUtcTime = DateTime.parse(unFormatedUtcTime.toString());
    DateFormat outputFormat = DateFormat('dd/MM/yyyy hh:mm a');
    String localTime =
        outputFormat.format(formatedUtcTime.toLocal()); // UTC to local time
    return localTime;
  }

  Future<void> reduceTradeDialog(Data? tradeData) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return ReduceTradeDialog(
            tradeData: tradeData!,
          );
        });
  }

  Future<void> closeTradeDialog(Data? tradeData) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CloseTradeDialog(
            tradeData: tradeData!,
          );
        });
  }

  Future<void> replicateTradeDialog(String? stockName, String? tradeExecPrice,
      int? tradeUnit, int? tradeId, String? stockCurrentPrice) {
    _tradeExecutPriceController.text = stockCurrentPrice!;
    _tradeUnitController.text = tradeUnit.toString();
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Replicate trade for $stockName',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.orangeAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
            content: Form(
              key: _replicateTradeFormKey,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Are you sure you want to replicate trade ?'),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text("Trade execution price"),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _tradeExecutPriceController,
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                              signed: false,
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (String? value) {
                              RegExp regex = RegExp(r'(\..*){2,}');
                              if (value == null || value.isEmpty) {
                                return 'Please enter valid value';
                              } else if (regex.hasMatch(value)) {
                                return 'More than one "." not allowed';
                              } else if (RegExp(r'\.').hasMatch(value) &&
                                  !RegExp(r'\.\d+').hasMatch(value)) {
                                return "Please enter valid value";
                              } else if (RegExp(r'^0+$').hasMatch(value)) {
                                return "Please enter value greater than zero";
                              } else if (double.parse(value) >
                                  double.parse(stockCurrentPrice)) {
                                return "Trade replicate price should be less than or equal to current price";
                              } else {
                                return null;
                              }
                            },
                            decoration: textFormFieldDecoration(),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^[0-9\.]+$')),
                              // FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text("Trade unit"),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _tradeUnitController,
                            decoration: textFormFieldDecoration(),
                            keyboardType: TextInputType.number,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onChanged: (value) {
                              Future.delayed(Duration(milliseconds: 500), () {
                                _scrollController.animateTo(
                                    _scrollController.position.maxScrollExtent,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.ease);
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter valid value';
                              } else if (RegExp(r'^0+$').hasMatch(value)) {
                                return "Please enter value greater than zero";
                              } else {
                                return null;
                              }
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
                        if (_replicateTradeFormKey.currentState!.validate()) {
                          TradesRestApiService()
                              .totalPositionTradeAction(
                            TotalPositionTradeActionRequest(
                                tradeId: tradeId,
                                tradeType: "replicate",
                                tradeOrderPrice:
                                    _tradeExecutPriceController.text,
                                tradeUnit:
                                    int.parse(_tradeUnitController.text)),
                          )
                              .then((value) {
                            if (value.status!) {
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: ((context) {
                                  return ReplicateTradeReviewDialog(
                                    stockName: stockName,
                                    tradeUnit:
                                        int.parse(_tradeUnitController.text),
                                    tradeExecutionPrice: double.parse(
                                        _tradeExecutPriceController.text),
                                    tradeId: tradeId,
                                    totalPositionAfterAction:
                                        value.data!.totalUnit,
                                    stockCurrentPosition:
                                        value.data!.curntPositionUnit,
                                    stockCurrentPrice: stockCurrentPrice,
                                    balanceAfterReplicate: double.tryParse(
                                        value.data!.futureBalance!),
                                    currentBalance: double.tryParse(
                                        value.data!.curntBalance!),
                                  );
                                }),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("${value.msg}"),
                                ),
                              );
                            }
                          });
                        }
                      },
                      child: Text('Proceed', style: TextStyle(fontSize: 16)),
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
                      child: Text('Cancel', style: TextStyle(fontSize: 16)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.blue),
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
  }

  InputDecoration textFormFieldDecoration() {
    return InputDecoration(
      errorMaxLines: 8,
      errorStyle: TextStyle(color: Colors.yellow, fontSize: 16),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget tradesUi({
    required Data tradeData,
    required int i,
    required TradesProvider tradeState,
  }) {
    if (_tradeMainProvider!.selectedTickerForSimulation.ticker ==
            "Select ticker" ||
        _tradeMainProvider!.selectedTickerForSimulation.ticker ==
            tradeData.tradeTicker) {
      return InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          tradeState.toggleTradeActionBtnVisibilityAtIndex = i - 1;
        },
        child: Container(
          margin: const EdgeInsets.only(left: 20, bottom: 0, top: 5, right: 20),
          padding: const EdgeInsets.only(left: 0, bottom: 10, top: 0, right: 0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: (themeProvider.defaultTheme)?Colors.black:Colors.white54,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Text(
                      "$i"
                  )),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${tradeData.tradeTicker} (${tradeData.tradeExchange}) Lad ${tradeData.tradeLadderName}: ${tradeData.tradeUnsettledTradeUnits} UNITS",
                          style: TextStyle(
                            fontSize: 16,
                            color: (themeProvider.defaultTheme)?Colors.black:Colors.white,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            left: 0,
                            // bottom: 5,
                            top: 10,
                          ),
                          child: Text(
                            "Long@ ${amountToInrFormat(context, tradeData.tradeExecutionPrice)}",
                            style: const TextStyle(
                              // color: Colors.white,
                              color: Colors.green,
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            left: 0,
                            // bottom: 5,
                          ),
                          child: Text(
                            "Buy cost: ${amountToInrFormat(context, tradeData.tradeExecutionPrice * (tradeData.tradeTotalUnits ?? 0.0))}",
                            style: const TextStyle(
                              // color: Colors.white,
                              color: Colors.green,
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            left: 0,
                          ),
                          child: Text(
                            "Profit from trade: ${amountToInrFormat(context, tradeData.tradeRealizedProfit)}",
                            style: TextStyle(
                              // color: Colors.white,
                              color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200],
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            left: 0,
                          ),
                          child: Text(
                            "Extra cash generated: ${amountToInrFormat(context, tradeData.tradeExtraCashGenerated)}",
                            style: const TextStyle(
                              // color: Colors.white,
                              color: Colors.green,
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            left: 0,
                          ),
                          child: Text(
                            "Actual Brokerage : ${amountToInrFormat(context, tradeData.actualBrokerageCost ?? 0.0)}",
                            style: const TextStyle(
                              // color: Colors.white,
                              color: Colors.green,
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            left: 0,
                          ),
                          child: Text(
                            "Other Charges: ${amountToInrFormat(context, tradeData.otherBrokerageCharges ?? 0.0)}",
                            style: const TextStyle(
                              // color: Colors.white,
                              color: Colors.green,
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            left: 0,
                            // bottom: 5,
                          ),
                          child: Text(
                            'Ticket#: ${tradeData.tradeOrderTicketNumber}',
                            style: TextStyle(
                                fontSize: 16, color: Colors.indigo[200]),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        widget.toggleReturnPrice
                            ? FittedBox(
                                child: RichText(
                                  textAlign: TextAlign.end,
                                  text: TextSpan(
                                      text:
                                          "${amountToInrFormat(context, tradeData.currentPrice - tradeData.tradeExecutionPrice)}",
                                      style: TextStyle(
                                        color: (themeProvider.defaultTheme)?Colors.black:determineColorByValue(
                                            tradeData.currentPrice -
                                                tradeData.tradeExecutionPrice),
                                        fontWeight: FontWeight.normal,
                                      ),
                                      children: [
                                        TextSpan(
                                            text: "\nPrice above",
                                            style:
                                                TextStyle(color: Colors.white))
                                      ]),
                                ),
                              )
                            : FittedBox(
                                child: RichText(
                                  textAlign: TextAlign.end,
                                  text: TextSpan(
                                      text:
                                          "${amountToInrFormat(context, (tradeData.currentPrice - tradeData.tradeExecutionPrice) * (tradeData.tradeUnsettledTradeUnits ?? 0))}",
                                      style: TextStyle(
                                        color: (themeProvider.defaultTheme)?Colors.black:determineColorByValue(
                                            tradeData.currentPrice -
                                                tradeData.tradeExecutionPrice),
                                        fontWeight: FontWeight.normal,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "\nTrade return",
                                          style: TextStyle(
                                              // color: Colors.white
                                              color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]),
                                        )
                                      ]),
                                ),
                              ),
                        Container(
                          margin: const EdgeInsets.only(
                            left: 0,
                            bottom: 5,
                            top: 10,
                          ),
                          child: FittedBox(
                              child: Provider.of<TradeMainProvider>(context,
                                              listen: false)
                                          .tradingOptions ==
                                      TradingOptions
                                          .simulationTradingWithSimulatedPrices
                                  ? Text(
                                      "${amountToInrFormat(context, tradeData.currentPrice)}\n Simulated price",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.green,
                                      ),
                                      textAlign: TextAlign.end,
                                    )
                                  : Text(
                                      "${amountToInrFormat(context, tradeData.currentPrice)}\n Current price",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.green,
                                      ),
                                      textAlign: TextAlign.end,
                                    )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              // SizedBox(
              //   height: 5,
              // ),
              Visibility(
                visible: tradeState.tradeActionVisible[i - 1],
                child: Row(
                  children: [
                    // Expanded(
                    //   child: OutlinedButton(
                    //       style: OutlinedButton.styleFrom(
                    //           padding: EdgeInsets.zero,
                    //           side: BorderSide(color: Colors.blue)),
                    //       onPressed: () {
                    //         setState(() {
                    //           tradeActionVisible[index] = false;
                    //         });
                    //         modifyTradeDialog(
                    //             getAllExecutedTradeListResponse!
                    //                 .data![index]);
                    //       },
                    //       child: Text('Modify')),
                    // ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    // Expanded(
                    //   child: ElevatedButton(
                    //       style: ElevatedButton.styleFrom(
                    //           padding: EdgeInsets.zero,
                    //           backgroundColor: Colors.blue),
                    //       onPressed: () {
                    //         setState(() {
                    //           tradeActionVisible[index] = false;
                    //           reduceTradeDialog(
                    //               getAllExecutedTradeListResponse!
                    //                   .data![index]);
                    //         });
                    //       },
                    //       child: Text(
                    //         'Reduce',
                    //       )),
                    // ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    // Expanded(
                    //   child: ElevatedButton(
                    //       style: ElevatedButton.styleFrom(
                    //         padding: EdgeInsets.zero,
                    //         backgroundColor: Colors.red,
                    //       ),
                    //       onPressed: () {
                    //         setState(() {
                    //           tradeActionVisible[index] = false;
                    //         });
                    //         // Navigator.pop(context);
                    //         closeTradeDialog(
                    //             getAllExecutedTradeListResponse!
                    //                 .data![index]);
                    //       },
                    //       child: Text(
                    //         'Close',
                    //       )),
                    // ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: (tradeData.noFollowup == false)
                              ? Colors.orangeAccent
                              : Colors.grey,
                        ),
                        onPressed: () {
                          // setState(() {
                          //   tradeActionVisible[index] = false;
                          // });

                          // replicateTradeDialog(
                          //     getAllExecutedTradeListResponse
                          //         ?.data![index]
                          //         .tradeStockName,
                          //     getAllExecutedTradeListResponse
                          //         ?.data?[index]
                          //         .tradeExePrice,
                          //     getAllExecutedTradeListResponse
                          //         ?.data?[index].tradeUnit,
                          //     getAllExecutedTradeListResponse
                          //         ?.data?[index].tradeId,
                          //     getAllExecutedTradeListResponse
                          //         ?.data?[index]
                          //         .stockCurrentPrice);

                          // if (tradeData.noFollowup == false) {
                          //   Fluttertoast.showToast(
                          //       msg: "This feature will unlock soon");
                          // }

                          replicateOrReduceProvider.selectedTradeId =
                              tradeData.tradeId.toString();

                          navigationProvider.previousSelectedIndex =
                              navigationProvider.selectedIndex;
                          navigationProvider.selectedIndex = 13;
                        },
                        child: Text(
                          'Replicate or Reduce',
                          style: TextStyle(
                            color: Colors.black
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    navigationProvider = Provider.of<NavigationProvider>(context, listen: true);
    replicateOrReduceProvider =
        Provider.of<ReplicateOrReduceProvider>(context, listen: true);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    double screenWidth = screenWidthRecognizer(context);
    return Consumer<TradesProvider>(builder: (_, state, __) {
      return state.isLoading
          ? buildTradeLoadingWidget(context, screenWidth) //Center(child: Text("N/A"))
          : state.trades!.data!.isEmpty
              ? Center(
                  child: Text(
                    "No open trades",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView(
                children: [

                  Row(
                    children: [

                      SizedBox(
                        height: 34,
                        width: 24,
                        child: Checkbox(
                          value: (_tradesProvider!.selectedTradeFilter == "RECENT")?true:false,
                          onChanged: (bool? checked) {
                            setState(() {

                              if(checked == true) {
                                _tradesProvider!.selectedTradeFilter = "RECENT";
                              } else {
                                _tradesProvider!.selectedTradeFilter = "ALL";
                              }

                            });
                            _tradesProvider!.fetchTrades(_currencyConstantsProvider!);

                          },
                          side: BorderSide(
                              color: Colors.white
                          ),
                          checkColor: (themeProvider.defaultTheme)?Colors.white:Colors.black,
                          fillColor:
                          WidgetStateColor.resolveWith((states) {
                            return states.contains(WidgetState.selected)
                                ? Colors.white // Selected color
                                : Colors
                                .black; // Transparent when unselected
                          }),
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Show recent trades only",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white
                          // color: Color(0xFF0099CC)
                        ),
                      )
                    ],
                  ),

                  ListView.builder(
                    shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return tradesUi(
                          tradeData: state.trades!.data![index],
                          i: index + 1,
                          tradeState: state,
                        );
                      },
                      itemCount: state.trades!.data!.length,
                    ),
                ],
              );
    });
  }

  Widget buildTradeLoadingWidget(BuildContext context, double screenWidth) {
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
                        ?ShimmerLoadingView.loadingContainerDark(screenWidth * 0.6, 25)
                        :ShimmerLoadingView.loadingContainer(
                        screenWidth * 0.6, 25
                    ),

                    Row(
                      children: [
                        (themeProvider.defaultTheme)
                            ?ShimmerLoadingView.loadingContainerDark(60, 25)
                            :ShimmerLoadingView.loadingContainer(60, 25),

                        SizedBox(
                            width: 5
                        ),

                        (themeProvider.defaultTheme)
                            ?ShimmerLoadingView.loadingContainerDark(60, 25)
                            :ShimmerLoadingView.loadingContainer(60, 25),
                      ],
                    )




                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (themeProvider.defaultTheme)
                        ?ShimmerLoadingView.loadingContainerDark(screenWidth * 0.4, 25)
                        :ShimmerLoadingView.loadingContainer(
                        screenWidth * 0.4, 25
                    ),

                    Row(
                      children: [
                        (themeProvider.defaultTheme)
                            ?ShimmerLoadingView.loadingContainerDark(40, 25)
                            :ShimmerLoadingView.loadingContainer(40, 25),

                        SizedBox(
                            width: 5
                        ),

                        (themeProvider.defaultTheme)
                            ?ShimmerLoadingView.loadingContainerDark(60, 25)
                            :ShimmerLoadingView.loadingContainer(60, 25),
                      ],
                    )




                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (themeProvider.defaultTheme)
                        ?ShimmerLoadingView.loadingContainerDark(screenWidth * 0.3, 25)
                        :ShimmerLoadingView.loadingContainer(
                        screenWidth * 0.3, 25
                    ),

                    Row(
                      children: [
                        (themeProvider.defaultTheme)
                            ?ShimmerLoadingView.loadingContainerDark(50, 25)
                            :ShimmerLoadingView.loadingContainer(50, 25),

                        SizedBox(
                            width: 5
                        ),

                        (themeProvider.defaultTheme)
                            ?ShimmerLoadingView.loadingContainerDark(10, 25)
                            :ShimmerLoadingView.loadingContainer(10, 25),
                      ],
                    )




                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (themeProvider.defaultTheme)
                        ?ShimmerLoadingView.loadingContainerDark(screenWidth * 0.3, 25)
                        :ShimmerLoadingView.loadingContainer(
                        screenWidth * 0.3, 25
                    ),

                    Row(
                      children: [
                        (themeProvider.defaultTheme)
                            ?ShimmerLoadingView.loadingContainerDark(50, 25)
                            :ShimmerLoadingView.loadingContainer(50, 25),

                        SizedBox(
                            width: 5
                        ),

                        (themeProvider.defaultTheme)
                            ?ShimmerLoadingView.loadingContainerDark(50, 25)
                            :ShimmerLoadingView.loadingContainer(50, 25),
                      ],
                    )




                  ],
                ),
              ],
            ),
          );
        }
    );
  }
}
