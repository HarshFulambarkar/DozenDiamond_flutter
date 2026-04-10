import 'package:dozen_diamond/ZH_analysisPriceVsNumberOfStocks/stateManagement/analyticsDateProvider.dart';
import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../ZH_analysis/models/analysis_type.dart';
import '../../ZH_analysis/models/sort_toggle_button.dart';
import '../../global/services/num_formatting.dart';
import '../../global/widgets/info_icon_display.dart';
import '../models/analysis_unsettle_closest_buy_response.dart';
import '../models/analytics_unsettled_closest_buy_table_request.dart';
import '../models/analytics_unsettled_closest_buy_table_response.dart'
    as unsettledBuyModel;
import '../services/analysis_unsettled_closest_buy_rest_api_service.dart';
import '../widgets/unsettled_closest_buys_csv_dialog.dart';

class AnalysisUnsettledClosestBuy extends StatefulWidget {
  final AnalysisType userSelectedAnalysis;
  final String userSelectedStock;
  const AnalysisUnsettledClosestBuy(
      {super.key,
      required this.userSelectedStock,
      required this.userSelectedAnalysis});

  @override
  State<AnalysisUnsettledClosestBuy> createState() =>
      _AnalysisUnsettledClosestBuyState();
}

class _AnalysisUnsettledClosestBuyState
    extends State<AnalysisUnsettledClosestBuy> {
  AnalysisType? _selectedAnalysisType;
  // unsettledBuyModel.AnalyticsUnsettledClosestBuyTableResponse? unsettledBuy;
  AnalysisUnsettleClosestBuyResponse? unsettledBuyDataNew;
  String? _selectedStock;
  DateTimeProvider? _dateTimeState;
  String? warningMessage = "";

  late ThemeProvider themeProvider;
  bool loadingTableData = false;

  List<SortToggleButton> unsettledBuyTableTitle = [
    SortToggleButton(0, '#', true, true),
    SortToggleButton(1, 'Price', false, false),
    SortToggleButton(2, 'Units', false, false),
    SortToggleButton(3, 'Date', false, false),
  ];

  @override
  void initState() {
    super.initState();
    _selectedAnalysisType = widget.userSelectedAnalysis;
    _selectedStock = widget.userSelectedStock;

    _dateTimeState = Provider.of<DateTimeProvider>(context, listen: false);
    // getUnsettledBuysData();
    getUnsettledBuysDataNew();
    // getSelectedStockList();
  }

  Future<void> getUnsettledBuysDataNew() async {
    loadingTableData = true;
    AnalysisUnsettledClosestBuyRestApiService()
        .analyticsUnsettledClosestBuyTableNew(
        AnalyticsUnsettledClosestBuyTableRequest(
            startDate: DateFormat('yyyy-MM-dd')
                .format(_dateTimeState!.startFullDate),
            endDate:
            DateFormat('yyyy-MM-dd').format(_dateTimeState!.endFullDate),
            stockName: _selectedStock),
        false)
        .then((value) {
      if (value!.status!) {
        unsettledBuyDataNew = value;
        _updateState();
      } else {
        warningMessage = "No records available";
      }

      loadingTableData = false;
    }).catchError((err) {
      loadingTableData = false;
      print("Error from the getUnsettledBuyData $err");
    });
  }

  // Future<void> getUnsettledBuysData() async {
  //   AnalysisUnsettledClosestBuyRestApiService()
  //       .analyticsUnsettledClosestBuyTable(
  //           AnalyticsUnsettledClosestBuyTableRequest(stockName: _selectedStock),
  //           false)
  //       .then((value) {
  //     if (value!.status!) {
  //       unsettledBuy = value;
  //       _updateState();
  //     } else {
  //       warningMessage = "No records available";
  //     }
  //   }).catchError((err) {
  //     print("Error from the getUnsettledBuyData $err");
  //   });
  // }

  _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  void sortUnsettledClosestBuys(int titleIndex, bool increasingOrder) {
    if (unsettledBuyDataNew != null && unsettledBuyDataNew!.data!.isNotEmpty) {
      switch (titleIndex) {
        case 0:
          {
            if (increasingOrder) {
              unsettledBuyDataNew!.data!
                  .sort((a, b) => a.tradeNumber!.compareTo(b.tradeNumber!));
            } else {
              unsettledBuyDataNew!.data!
                  .sort((a, b) => b.tradeNumber!.compareTo(a.tradeNumber!));
            }
            _updateState();
            break;
          }
        case 1:
          {
            if (increasingOrder) {
              unsettledBuyDataNew!.data!.sort((a, b) =>
                  double.parse(a.price!.toString()).compareTo(double.parse(b.price!.toString())));
            } else {
              unsettledBuyDataNew!.data!.sort((a, b) =>
                  double.parse(b.price!.toString()).compareTo(double.parse(a.price!.toString())));
            }
            _updateState();
            break;
          }
        case 2:
          {
            if (increasingOrder) {
              unsettledBuyDataNew!.data!
                  .sort((a, b) => a.price!.compareTo(b.price!));
            } else {
              unsettledBuyDataNew!.data!
                  .sort((a, b) => b.price!.compareTo(a.price!));
            }
            _updateState();
            break;
          }
        case 3:
          {
            if (increasingOrder) {
              unsettledBuyDataNew!.data!.sort((a, b) =>
                  double.parse(a.price!.toString()).compareTo(double.parse(b.price!.toString())));
            } else {
              unsettledBuyDataNew!.data!.sort((a, b) =>
                  double.parse(b.price!.toString()).compareTo(double.parse(a.price!.toString())));
            }
            _updateState();
            break;
          }
      }
    }
  }

  Widget unsettledClosestBuyTableWidget() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            child: TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return UnsettledClosestBuysCsvDialog(
                          stockName: _selectedStock);
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
          unsettledBuyDataNew!.data!.isNotEmpty
              ? Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: (themeProvider.defaultTheme)?Colors.black:Colors.white),
                          left: BorderSide(color: (themeProvider.defaultTheme)?Colors.black:Colors.white),
                          right: BorderSide(color: (themeProvider.defaultTheme)?Colors.black:Colors.white))),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (int i = 0; i < unsettledBuyTableTitle.length; i++)
                          Expanded(
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                child: InkWell(
                                  onTap: () {
                                    for (int j = 0;
                                        j < unsettledBuyTableTitle.length;
                                        j++) {
                                      if (i == j) {
                                        unsettledBuyTableTitle[j].selected =
                                            true;
                                        unsettledBuyTableTitle[j]
                                                .orderIncreasing =
                                            !unsettledBuyTableTitle[j]
                                                .orderIncreasing!;
                                        sortUnsettledClosestBuys(
                                            j,
                                            unsettledBuyTableTitle[j]
                                                .orderIncreasing!);
                                      } else {
                                        unsettledBuyTableTitle[j].selected =
                                            false;
                                        unsettledBuyTableTitle[j]
                                                .orderIncreasing =
                                            !unsettledBuyTableTitle[j]
                                                .orderIncreasing!;
                                      }
                                    }
                                    // _updateState();
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                          child: Text(
                                        unsettledBuyTableTitle[i].buttonTitle!,
                                        textAlign: TextAlign.center,
                                      )),
                                      if (unsettledBuyTableTitle[i].selected!)
                                        Icon(
                                          unsettledBuyTableTitle[i]
                                                  .orderIncreasing!
                                              ? Icons.arrow_upward
                                              : Icons.arrow_downward,
                                          color: Colors.blue,
                                          size: 18,
                                        )
                                    ],
                                  ),
                                )),
                          ),
                      ]),
                )
              : Container(),
          unsettledBuyDataNew!.data!.isNotEmpty
              ? Container(
                  height: MediaQuery.of(context).size.height * 0.36,
                  child: RawScrollbar(
                    thumbColor: Colors.blue,
                    thickness: 4,
                    radius: Radius.circular(18),
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      child: Table(
                        border: TableBorder(
                            top: BorderSide(color: (themeProvider.defaultTheme)?Colors.black:Colors.white),
                            bottom: BorderSide(color: (themeProvider.defaultTheme)?Colors.black:Colors.white),
                            left: BorderSide(color: (themeProvider.defaultTheme)?Colors.black:Colors.white),
                            right: BorderSide(color: (themeProvider.defaultTheme)?Colors.black:Colors.white)),
                        children: [
                          ...unsettledBuyDataNew!.data!
                              .map(
                                (tableData) => TableRow(
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
                                        child: Text(
                                          amountToInrFormat(
                                                  context,
                                                  double.parse(
                                                      tableData.price!.toString())) ??
                                              "N/A",
                                          textAlign: TextAlign.center,
                                        )),
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 5),
                                        child: Text(
                                          tableData.units.toString(),
                                          textAlign: TextAlign.center,
                                        )),
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 5),
                                        child: double.parse(tableData.price!.toString()) > 0
                                            ? Text(
                                                "${tableData.timestamp!.toString()}",
                                                textAlign: TextAlign.center,
                                              )
                                            : Text(
                                                amountToInrFormat(
                                                        context,
                                                        double.parse(
                                                            tableData.price!.toString())) ??
                                                    "N/A",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.orange),
                                              )),
                                  ],
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList()
                        ],
                      ),
                    ),
                  ),
                )
              : Container(),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Net Cash Gain'),
              Text(
                '${double.parse(unsettledBuyDataNew!.total!.netCashGain!.toString()) > 0 ? "+" : ""} ${amountToInrFormat(context, double.parse(unsettledBuyDataNew!.total!.netCashGain!.toString()))}',
                style: TextStyle(
                  color: double.parse(unsettledBuyDataNew!.total!.netCashGain!.toString()) > 0
                      ? Colors.green
                      : (themeProvider.defaultTheme)?Colors.black:Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 7,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Net stock bought / sold'),
              Text("${unsettledBuyDataNew!.total!.netStockBought} / ${unsettledBuyDataNew!.total!.netStockSold}")
              // Text(
              //     "${amountToInrFormat(context, double.parse(unsettledBuyDataNew!.total!.netStockBought!.toString()))} / ${amountToInrFormat(context, double.parse(unsettledBuyDataNew!.total!.netStockSold!.toString()))!.replaceAll("-", "")}"),
            ],
          ),
          SizedBox(
            height: 7,
          ),

        ],
      ),
      margin: EdgeInsets.only(
        left: 15,
        right: 15,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // drawer: const NavigationDrawerWidget(),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Container(
                color: (themeProvider.defaultTheme)?Color(0XFFF5F5F5):Colors.transparent,
                height: MediaQuery.of(context).size.height,
                width: screenWidth,
              ),
            ),
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
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            children: [
                              Text(
                                "${widget.userSelectedStock}  ${widget.userSelectedAnalysis.itemString!}",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),

                              SizedBox(
                                width: 27,
                                height: 27,
                                child: InfoIconDisplay().infoIconDisplay(
                                  context,
                                  widget.userSelectedAnalysis.itemString!,
                                  widget.userSelectedAnalysis.itemDescription!,
                                  color: (themeProvider.defaultTheme)
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              )
                            ],
                          ),
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
                          ],
                        ),
                      ),
                      _selectedAnalysisType!.itemId == 9 //2
                          ? unsettledBuyDataNew != null
                              ? unsettledClosestBuyTableWidget()
                              : (loadingTableData)
                          ?Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Center(
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                              ),
                            )
                        ),
                      ):Container(
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
