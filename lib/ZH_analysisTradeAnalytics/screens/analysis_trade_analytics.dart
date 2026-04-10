import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:flutter/material.dart';

import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../ZH_Analysis/models/trade_analytics_time_dropdown_model.dart';
import '../../ZH_analysis/models/analysis_type.dart';
import '../../ZH_analysis/models/sort_toggle_button.dart';
import '../../global/services/num_formatting.dart';
import '../models/all_trade_analytics_request.dart';
import '../models/all_trade_analytics_response.dart' as allTradeAlias;
import '../services/analysis_trade_analytics_rest_api_service.dart';
import '../widgets/all_trade_csv_dialog.dart';

class AnalysisTradeAnalytics extends StatefulWidget {
  final AnalysisType userSelectedAnalysis;
  final String userSelectedStock;
  const AnalysisTradeAnalytics(
      {super.key,
      required this.userSelectedAnalysis,
      required this.userSelectedStock});

  @override
  State<AnalysisTradeAnalytics> createState() => _AnalysisTradeAnalyticsState();
}

class _AnalysisTradeAnalyticsState extends State<AnalysisTradeAnalytics> {
  String? warningMessage = "";
  AnalysisType? _selectedAnalysisType;
  String? _selectedStock;
  TradeAnalyticsTimeDropdown? selectedTimeForAllTrade;
  allTradeAlias.AllTradeAnalyticsResponse? allTrade;

  List<SortToggleButton> allTradeTableTitle = [
    SortToggleButton(0, '#', true, true),
    SortToggleButton(1, '#Buy', false, false),
    SortToggleButton(2, 'Price', false, false),
    SortToggleButton(3, 'Gain', false, false),
    SortToggleButton(4, 'Profit', false, false),
    SortToggleButton(5, 'Date', true, false),
  ];

  List<TradeAnalyticsTimeDropdown> timePeriodOptionsForAllTrade = [
    TradeAnalyticsTimeDropdown("Time", 0),
    TradeAnalyticsTimeDropdown("3 mos", 3),
    TradeAnalyticsTimeDropdown("6 mos", 6),
    TradeAnalyticsTimeDropdown("9 mos", 9),
    TradeAnalyticsTimeDropdown("12 mos", 12),
    TradeAnalyticsTimeDropdown("All", 100),
  ];
  @override
  void initState() {
    super.initState();
    _selectedAnalysisType = widget.userSelectedAnalysis;
    _selectedStock = widget.userSelectedStock;
    selectedTimeForAllTrade =
        timePeriodOptionsForAllTrade[timePeriodOptionsForAllTrade.length - 1];
    getAllTradeData();
    // getSelectedStockList();
  }

  _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  void sortAllTrade(int titleIndex, bool increasingOrder) {
    if (allTrade != null && allTrade!.data!.isNotEmpty) {
      switch (titleIndex) {
        case 0:
          {
            if (increasingOrder) {
              allTrade!.data!
                  .sort((a, b) => a.tradeNumber!.compareTo(b.tradeNumber!));
            } else {
              allTrade!.data!
                  .sort((a, b) => b.tradeNumber!.compareTo(a.tradeNumber!));
            }
            _updateState();
            break;
          }
        case 1:
          {
            if (increasingOrder) {
              allTrade!.data!.sort((a, b) => a.bought!.compareTo(b.bought!));
            } else {
              allTrade!.data!.sort((a, b) => b.bought!.compareTo(a.bought!));
            }
            _updateState();
            break;
          }
        case 2:
          {
            if (increasingOrder) {
              allTrade!.data!.sort((a, b) =>
                  double.parse(a.price!).compareTo(double.parse(b.price!)));
            } else {
              allTrade!.data!.sort((a, b) =>
                  double.parse(b.price!).compareTo(double.parse(a.price!)));
            }
            _updateState();
            break;
          }
        case 3:
          {
            if (increasingOrder) {
              allTrade!.data!.sort((a, b) => a.cost!.compareTo(b.cost!));
            } else {
              allTrade!.data!.sort((a, b) => b.cost!.compareTo(a.cost!));
            }
            _updateState();
            break;
          }
        case 4:
          {
            if (increasingOrder) {
              allTrade!.data!.sort((a, b) => a.profit!.compareTo(b.profit!));
            } else {
              allTrade!.data!.sort((a, b) => b.profit!.compareTo(a.profit!));
            }
            _updateState();
            break;
          }
        case 5:
          {
            if (increasingOrder) {
              allTrade!.data!
                  .sort((a, b) => a.tradeNumber!.compareTo(b.tradeNumber!));
            } else {
              allTrade!.data!
                  .sort((a, b) => b.tradeNumber!.compareTo(a.tradeNumber!));
            }
            _updateState();
            break;
          }
      }
    }
  }

  Widget filterDataByTimeAllDialogBox(
      void Function(void Function())? dialogSetState) {
    return Container(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<TradeAnalyticsTimeDropdown>(
          padding: EdgeInsets.zero,
          value: selectedTimeForAllTrade,
          onChanged:
              _selectedStock == 'Tickers' || _selectedAnalysisType!.itemId != 6
                  ? null
                  : (value) {
                      selectedTimeForAllTrade = value;
                      if (value!.timePeriodNumber != 0) {
                        if (dialogSetState != null) {
                          dialogSetState(
                            () {},
                          );
                        }
                        _updateState();
                      } else {
                        if (dialogSetState != null) {
                          dialogSetState(
                            () {},
                          );
                        }
                        allTrade = null;
                        _updateState();
                      }
                    },
          dropdownColor: Colors.black,
          items: timePeriodOptionsForAllTrade
              .map(
                (TradeAnalyticsTimeDropdown timePeriodOption) =>
                    DropdownMenuItem<TradeAnalyticsTimeDropdown>(
                  child: Text(
                    timePeriodOption.timePeriod,
                    style: TextStyle(color: Colors.white),
                  ),
                  value: timePeriodOption,
                ),
              )
              .toList(),
        ),
      ),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5)),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      height: 45,
    );
  }

  Future<void> selectDurationAllTradePopUp() async {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (ctx, localSetState) {
            return AlertDialog(
              title: Text('Please select duration'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [filterDataByTimeAllDialogBox(localSetState)],
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
                          getAllTradeData();
                          Navigator.pop(context);
                        },
                        child: Text('proceed', style: TextStyle(fontSize: 18)),
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
                        child: Text('Cancel', style: TextStyle(fontSize: 18)),
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
        });
  }

  Widget allTradeWidget() {
    return allTrade!.data!.isNotEmpty
        ? Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AllTradeCsvDialog(
                                stockName: _selectedStock, duration: 3);
                          });
                    },
                    child: Text(
                      "Download CSV",
                      style: TextStyle(
                        color: Color(0xFF0099CC),
                      ),
                    ),
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Colors.white),
                          left: BorderSide(color: Colors.white),
                          right: BorderSide(color: Colors.white))),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (int i = 0; i < allTradeTableTitle.length; i++)
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                for (int j = 0;
                                    j < allTradeTableTitle.length;
                                    j++) {
                                  if (i == j) {
                                    allTradeTableTitle[j].selected = true;
                                    allTradeTableTitle[j].orderIncreasing =
                                        !allTradeTableTitle[j].orderIncreasing!;
                                    sortAllTrade(j,
                                        allTradeTableTitle[j].orderIncreasing!);
                                  } else {
                                    allTradeTableTitle[j].selected = false;
                                    allTradeTableTitle[j].orderIncreasing =
                                        !allTradeTableTitle[j].orderIncreasing!;
                                  }
                                }
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                          child: Text(
                                        allTradeTableTitle[i].buttonTitle!,
                                        textAlign: TextAlign.center,
                                      )),
                                      if (allTradeTableTitle[i].selected!)
                                        Icon(
                                          allTradeTableTitle[i].orderIncreasing!
                                              ? Icons.arrow_upward
                                              : Icons.arrow_downward,
                                          color: Colors.blue,
                                          size: 18,
                                        )
                                    ],
                                  )),
                            ),
                          ),
                      ]),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.425,
                  child: RawScrollbar(
                    thumbColor: Colors.blue,
                    thickness: 4,
                    radius: Radius.circular(18),
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      child: Table(
                        border: TableBorder(
                            top: BorderSide(color: Colors.white),
                            bottom: BorderSide(color: Colors.white),
                            left: BorderSide(color: Colors.white),
                            right: BorderSide(color: Colors.white)),
                        children: [
                          ...allTrade!.data!
                              .map((tableData) => TableRow(
                                      children: [
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            child: Text(
                                              tableData.tradeNumber.toString(),
                                              textAlign: TextAlign.center,
                                            )),
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            child: tableData.bought! >= 0
                                                ? Text(
                                                    tableData.bought.toString(),
                                                    textAlign: TextAlign.center,
                                                  )
                                                : Text(
                                                    "{ ${tableData.bought!} }",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.orange),
                                                  )),
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            child: Text(
                                              amountToInrFormat(
                                                      context,
                                                      double.parse(
                                                          tableData.price!)) ??
                                                  "N/A",
                                              textAlign: TextAlign.center,
                                            )),
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            child: double.parse(
                                                        tableData.cost!) >=
                                                    0
                                                ? Text(
                                                    amountToInrFormat(
                                                            context,
                                                            double.parse(
                                                                tableData
                                                                    .cost!)) ??
                                                        "N/A",
                                                    textAlign: TextAlign.center,
                                                  )
                                                : Text(
                                                    "{ ${amountToInrFormat(context, double.parse(tableData.cost!))} }",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.orange),
                                                  )),
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            child: double.parse(
                                                        tableData.profit!) >=
                                                    0
                                                ? Text(
                                                    amountToInrFormat(
                                                            context,
                                                            double.parse(
                                                                tableData
                                                                    .profit!)) ??
                                                        "N/A",
                                                    textAlign: TextAlign.center,
                                                  )
                                                : Text(
                                                    "{ ${amountToInrFormat(context, double.parse(tableData.profit!))} }",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.orange),
                                                  )),
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            child: Text(
                                              tableData.purchaseDate!,
                                              textAlign: TextAlign.center,
                                            )),
                                      ],
                                      decoration: BoxDecoration(
                                          border: Border(
                                              top: BorderSide(
                                                  color: Colors.white)))))
                              .toList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            margin: EdgeInsets.only(
              left: 15,
              right: 15,
            ),
          )
        : Container(
            margin: EdgeInsets.only(top: 10, left: 18),
            child: Text("No records available"),
          );
  }

  Widget filterDataByTimeAllTrade() {
    return Container(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<TradeAnalyticsTimeDropdown>(
          padding: EdgeInsets.zero,
          value: selectedTimeForAllTrade,
          onChanged:
              _selectedStock == 'Tickers' || _selectedAnalysisType!.itemId != 6
                  ? null
                  : (value) {
                      selectedTimeForAllTrade = value;
                      if (value!.timePeriodNumber != 0) {
                        getAllTradeData();
                      } else {
                        allTrade = null;

                        _updateState();
                      }
                    },
          dropdownColor: Colors.black,
          items: timePeriodOptionsForAllTrade
              .map(
                (TradeAnalyticsTimeDropdown timePeriodOption) =>
                    DropdownMenuItem<TradeAnalyticsTimeDropdown>(
                  child: Text(
                    timePeriodOption.timePeriod,
                    style: TextStyle(color: Colors.white),
                  ),
                  value: timePeriodOption,
                ),
              )
              .toList(),
        ),
      ),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5)),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      height: 45,
    );
  }

  Future<void> getAllTradeData() async {
    try {
      allTrade = await AnalysisTradeAnalyticsRestApiService()
          .allTradeAnalyticsTable(AllTradeAnalyticsRequest(
        stockName: _selectedStock,
        month: selectedTimeForAllTrade!.timePeriodNumber,
      ));

      _updateState();
    } on HttpApiException catch (err) {
      print("error in the getAllTradeData ${err.errorTitle}");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // drawer: const NavigationDrawerWidget(),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Center(
                child: Container(
                  width: screenWidth == 0 ? null : screenWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 45,
                      ),
                      // SizedBox(
                      //   height: AppBar().preferredSize.height * 1.2,
                      // ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                "${widget.userSelectedStock}  ${widget.userSelectedAnalysis.itemString!}",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 18),
                        child: Wrap(
                          children: [
                            // stockListDropdown(),
                            SizedBox(
                              width: 10,
                              // height: 50,
                            ),
                            // analysisDropdown(),
                            SizedBox(
                              width: 10,
                              // height: 50,
                            ),
                            filterDataByTimeAllTrade(),
                          ],
                        ),
                      ),
                      _selectedAnalysisType!.itemId == 14 //6
                          ? allTrade != null
                              ? allTradeWidget()
                              : Container(
                                  margin: EdgeInsets.only(top: 10, left: 40),
                                  child: Text(warningMessage!),
                                )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
            CustomHomeAppBarWithProviderNew(
              backButton: true,
              widthOfWidget: screenWidth,
              isForPop: true,
            ),
          ],
        ),
      ),
    );
  }
}
