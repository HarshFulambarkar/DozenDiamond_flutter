import 'dart:convert';
import 'dart:developer';

import 'package:dozen_diamond/ZH_analysisPriceVsNumberOfStocks/stateManagement/analyticsDateProvider.dart';
import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../ZH_Analysis/models/trade_analytics_time_dropdown_model.dart';
import '../../ZH_analysis/models/analysis_type.dart';
import '../../global/widgets/info_icon_display.dart';
import '../models/analysis_differential_selling_price_vs_open_order_price_response.dart';
import '../models/graph_data_request.dart';
import '../models/price_vs_ladder_value_request.dart';
import '../models/price_vs_ladder_value_response.dart';
import '../services/analytics_rest_api_service.dart';

class AnalysisDifferentialSellingPriceVsOpenOrderPriceScreen extends StatefulWidget {
  final AnalysisType userSelectedAnalysis;
  final String userSelectedStock;
  const AnalysisDifferentialSellingPriceVsOpenOrderPriceScreen(
      {super.key,
        required this.userSelectedAnalysis,
        required this.userSelectedStock});

  @override
  State<AnalysisDifferentialSellingPriceVsOpenOrderPriceScreen> createState() => _AnalysisDifferentialSellingPriceVsOpenOrderPriceScreenState();
}

class _AnalysisDifferentialSellingPriceVsOpenOrderPriceScreenState extends State<AnalysisDifferentialSellingPriceVsOpenOrderPriceScreen> {
  String? warningMessage = "";
  String? _selectedStock;
  TradeAnalyticsTimeDropdown? _selectedTimePeriod;
  AnalysisType? _selectedAnalysisType;
  DateTimeProvider? _dateTimeState;
  AnalysisDifferentialSellingPriceVsOpenOrderPriceResponse? graphData;
  List<LineChartBarData> selectedGraphData = [];
  List<FlSpot> hiddenGraphData = [];
  List<TradeAnalyticsTimeDropdown> timePeriodOptions = [
    TradeAnalyticsTimeDropdown("Time", 0),
    TradeAnalyticsTimeDropdown("3 mos", 3),
    TradeAnalyticsTimeDropdown("6 mos", 6),
    TradeAnalyticsTimeDropdown("9 mos", 9),
    TradeAnalyticsTimeDropdown("12 mos", 12),
    TradeAnalyticsTimeDropdown("All", 100),
  ];
  final formatter = NumberFormat.compact(locale: "en_US", explicitSign: false);
  bool _graphDataAvailable = false;

  bool loadingGraphData = false;
  late ThemeProvider themeProvider;

  @override
  void initState() {
    super.initState();
    _selectedAnalysisType = widget.userSelectedAnalysis;
    _selectedStock = widget.userSelectedStock;
    _selectedTimePeriod = timePeriodOptions[timePeriodOptions.length - 1];
    _dateTimeState = Provider.of<DateTimeProvider>(context, listen: false);
    getAnalysisDifferentialSellingPriceVsOpenOrderPriceData();
    // getSelectedStockList();
  }

  _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  Widget priceVsLadderValueCsvDialog() {
    return Container(
      child: TextButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return csvDownloadDialog(context);
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
      margin: EdgeInsets.fromLTRB(0, 0, 18, 0),
    );
  }

  double maxMinY = 0;

  Future<void> getAnalysisDifferentialSellingPriceVsOpenOrderPriceData() async {
    print("inside getAnalysisDifferentialSellingPriceVsOpenOrderPriceData");
    loadingGraphData = true;
    try {
      graphData = await AnalyticsRestApiService()
          .analysisDifferentialSellingPriceVsOpenOrderPriceGraph(GraphDataRequest(
          startDate: DateFormat('yyyy-MM-dd')
              .format(_dateTimeState!.startFullDate),
          endDate:
          DateFormat('yyyy-MM-dd').format(_dateTimeState!.endFullDate),
          stockName: _selectedStock));
      print("here is the graphData ${jsonEncode(graphData)}");

      List<LineChartBarData> selectedGraphDataTemp = [];
      if (graphData!.status!) {

        // for (var entry in graphData!.data!) {
        //   if (entry.type == "Cumulative") {
        //     totalUnits = entry.units ?? 0;
        //     totalCashGain = entry.cashGain ?? 0.0;
        //   } else {
        //     entry.units = (entry.units ?? 0) + totalUnits;
        //     totalUnits = entry.units!;
        //     if (entry.tradeNumber == 1) {
        //       entry.cashGain = (entry.cashGain ?? 0.0) + totalCashGain;
        //     }
        //   }
        // }

        for (var entry in graphData!.data!) {
          // if (!(entry.type == "Cumulative")) {
          //
          // }

          // print(
          //     "the graphData is here ${entry.cashGain} and ${entry.units} and ${entry.price} and ${entry.type}");
          // print(
          //     "product of units and price${((entry.units ?? 0) * (entry.price ?? 0.0))}");
          // double profit = (entry.cashGain ?? 0.0) +
          //     ((entry.units ?? 0) * (entry.price ?? 0.0));

          double price = entry.price!.toDouble();
          double differentialSellingPrice = (double.parse(entry.differentialSellingPrice!.toStringAsFixed(2)));
          // print("------------------------");
          // print(entry.cashGain);
          // print(entry.units);
          // print(entry.price);
          // print("the graphData is here number of stocks $numberOfStocks");

          // hiddenGraphData.add(FlSpot(value, numberOfStocks));
          hiddenGraphData.add(FlSpot(price, differentialSellingPrice));

          setState((){
            maxMinY = hiddenGraphData.map((point) => point.y).reduce((a, b) => a > b ? a : b);
          });
        }

        int j = 0;

        print("here is the graphData2 ${(graphData)}");
        selectedGraphDataTemp.add(LineChartBarData(
          spots: hiddenGraphData,

          // color: Color.fromARGB(255, 0, 145, 255),
          color: Colors.blue,
          barWidth: 1,
          dotData: FlDotData(
            getDotPainter: (p0, p1, p2, p3) {
              // if (j >= graphData!.data!.length - 1) {
              //   j = 0;
              // } else {
              //   j++;
              // }
              //
              // if (j > graphData!.data!.length - 1) {
              //   print("never here");
              //   j = graphData!.data!.length - 1;
              // }

              // print("below are values");
              // print(graphData!.data![j].tradeNumber);
              // print((double.parse(graphData!.data![j].differentialSellingPrice!.toStringAsFixed(2))));
              // print((double.parse(graphData!.data![j].price!.toStringAsFixed(2))));

              // if (graphData!.data![j].differentialSellingPrice! >= graphData!.data![j].price!.toDouble()) {
              if ((double.parse(graphData!.data![j].differentialSellingPrice!.toStringAsFixed(2))) >= (double.parse(graphData!.data![j].price!.toStringAsFixed(2)))) {
                if (j == 0) {
                  if (j >= graphData!.data!.length - 1) {
                    j = 0;
                  } else {
                    j++;
                  }
                  return FlDotCirclePainter(
                    strokeColor: Color.fromARGB(255, 0, 255, 34),
                    color: Color.fromARGB(255, 0, 255, 34),
                  );
                } else if (j == graphData!.data!.length - 1) {
                  if (j >= graphData!.data!.length - 1) {
                    j = 0;
                  } else {
                    j++;
                  }
                  return FlDotCirclePainter(
                    strokeColor: Color.fromARGB(255, 0, 255, 34),
                    color: Color.fromARGB(255, 0, 255, 34),
                  );
                } else {
                  if (j >= graphData!.data!.length - 1) {
                    j = 0;
                  } else {
                    j++;
                  }
                  return FlDotCirclePainter(
                      strokeColor: Color.fromARGB(255, 0, 255, 34),
                      color: Color.fromARGB(255, 0, 255, 34));
                }
              } else {
                if (j == 0) {
                  if (j >= graphData!.data!.length - 1) {
                    j = 0;
                  } else {
                    j++;
                  }
                  return FlDotCirclePainter(
                    strokeColor: Color.fromARGB(255, 255, 0, 0),
                    color: const Color.fromARGB(255, 255, 0, 0),
                  );
                } else if (j == graphData!.data!.length - 1) {
                  if (j >= graphData!.data!.length - 1) {
                    j = 0;
                  } else {
                    j++;
                  }
                  return FlDotCirclePainter(
                    strokeColor: Color.fromARGB(255, 255, 0, 0),
                    color: const Color.fromARGB(255, 255, 0, 0),
                  );
                } else {
                  if (j >= graphData!.data!.length - 1) {
                    j = 0;
                  } else {
                    j++;
                  }
                  return FlDotCirclePainter(
                      strokeColor: Color.fromARGB(255, 255, 0, 0),
                      color: const Color.fromARGB(255, 255, 0, 0));
                }
              }

              if (j >= graphData!.data!.length - 1) {
                j = 0;
              } else {
                j++;
              }
              return FlDotCirclePainter(color: Colors.blue);
            },
          ),
        ));

        print("assigning value in j");

        selectedGraphData = selectedGraphDataTemp;

        _graphDataAvailable = selectedGraphData.length > 0;
      }
    } on HttpApiException catch (err) {
      print(" function $err");
      loadingGraphData = false;
    }

    loadingGraphData = false;

    _updateState();
  }

  Widget valueVsNumberOfStocksLineChart() {
    return LineChart(
      LineChartData(
        lineBarsData: selectedGraphData,

        gridData: FlGridData(
          getDrawingHorizontalLine: (value) {
            return FlLine(
                color: (themeProvider.defaultTheme)?Colors.black:Colors.white, dashArray: [10, 5], strokeWidth: 0.6);
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
                color: (themeProvider.defaultTheme)?Colors.black:Colors.white, dashArray: [10, 5], strokeWidth: 0.6);
          },
        ),
        // maxY: null,
        // maxY: 750000,
        // minY: -750000,
        // maxY: maxMinY,
        // minY: -maxMinY,
        lineTouchData: LineTouchData(
          // touchCallback: (p0, p1) {
          //   print("pak ${p1!.lineBarSpots!.length}");
          // },
          touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (value) {
                List<LineTooltipItem> tooltipData = [];

                for (int i = 0; i < value.length; i++) {
                  if (i == value.length - 1) {
                    // tooltipData
                    //     .add(LineTooltipItem("", TextStyle(fontSize: 0)));
                    tooltipData.add(LineTooltipItem(
                        "Differential Selling Price: ${value[i].y.toStringAsFixed(2)}\n${i == 0 ? 'Price: ${value[i].x}\n' : ''}",
                        TextStyle(color: Colors.white),
                        textAlign: TextAlign.left));
                  } else {
                    tooltipData.add(LineTooltipItem(
                        "Differential Selling Price: ${value[i].y.toStringAsFixed(2)}\n${i == 0 ? 'Price: ${value[i].x}\n' : ''}",
                        TextStyle(color: Colors.white),
                        textAlign: TextAlign.left));
                  }
                }
                return tooltipData;
              },
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              tooltipHorizontalAlignment: FLHorizontalAlignment.right),
          touchSpotThreshold: 3,
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            // axisNameWidget: Text("Stock Value"),
            axisNameWidget: Text("Open Order Price"),
            sideTitles: SideTitles(
              showTitles: true,
              // interval: 30,
              getTitlesWidget: (value, meta) {
                Widget axisTitle = SizedBox(
                    width: 50,
                    child: Text(formatter.format(value))
                );
                // A workaround to hide the max value title as FLChart is overlapping it on top of previous
                if (value == meta.min) {
                  return Container();
                }

                if (value == meta.max) {
                  final remainder = value % meta.appliedInterval;
                  if (remainder != 0.0 &&
                      remainder / meta.appliedInterval < 0.5) {
                    axisTitle = const SizedBox.shrink();
                  }
                }

                return SideTitleWidget(
                    meta: meta,
                    // axisSide: meta.axisSide,
                    child: axisTitle);
              },
              reservedSize: 25,

            ),
            axisNameSize: 16,
          ),
          leftTitles: AxisTitles(
            // axisNameWidget: Text("Number of Stocks"),
            axisNameWidget: Text("Differential Selling Price"),
            axisNameSize: 16,
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                Widget axisTitle = Text(formatter.format(value));
                // A workaround to hide the max value title as FLChart is overlapping it on top of previous

                if (value == meta.min) {
                  return Container();
                }

                if (value == meta.max) {
                  final remainder = value % meta.appliedInterval;
                  if (remainder != 0.0 &&
                      remainder / meta.appliedInterval < 0.5) {
                    axisTitle = const SizedBox(
                      width: 20,
                    );
                  }
                }
                return SideTitleWidget(
                    // axisSide: meta.axisSide,
                    meta: meta,
                    child: axisTitle);
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            left: BorderSide(color: (themeProvider.defaultTheme)?Colors.black:Colors.white),
            bottom: BorderSide(color: (themeProvider.defaultTheme)?Colors.black:Colors.white),
          ),
        ),
        // backgroundColor: Colors.white,
      ),
      // duration: Duration(milliseconds: 150),
      // curve: Curves.linear,
      // swapAnimationDuration: Duration(milliseconds: 150), // Optional
      // swapAnimationCurve: Curves.linear, // Optional
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
                          margin: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
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
                        // Container(
                        //   margin: EdgeInsets.symmetric(horizontal: 18),
                        //   child: Wrap(
                        //     children: [
                        //       // stockListDropdown(),
                        //
                        //       filterDataByTime(),
                        //     ],
                        //   ),
                        // ),
                        _selectedAnalysisType!.itemId == 4 || //1 ||
                            _selectedAnalysisType!.itemId == 8
                            ? !_graphDataAvailable
                            ? (loadingGraphData)
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
                            : Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            priceVsLadderValueCsvDialog(),
                            Container(
                                height:
                                MediaQuery.of(context).size.height *
                                    0.5,
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(
                                    right: 50, top: 5, bottom: 10),
                                child: valueVsNumberOfStocksLineChart()),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.fiber_manual_record,
                                    color: const Color.fromARGB(
                                        255, 255, 0, 0),
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("Sell"),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.fiber_manual_record,
                                    color:
                                    Color.fromARGB(255, 0, 255, 34),
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("Buy"),
                                  SizedBox(
                                    width: 35,
                                  ),
                                ],
                                mainAxisSize: MainAxisSize.min,
                              ),
                            )
                          ],
                        )
                            : Container(),
                      ],
                    ),
                  )),
            ),
            CustomHomeAppBarWithProviderNew(
              backButton: true,
              widthOfWidget: screenWidth,
              isForPop:
              true, //these leadingAction button is not working, I have tired making it work, but it isn't.
            )
          ],
        ),
      ),
    );
  }

  Widget csvDownloadDialog(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Are you sure you want to download ${widget.userSelectedAnalysis.itemString!} records in CSV for ${widget.userSelectedStock} ?",
        textAlign: TextAlign.center,
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
                  print("clicked here");
                  Navigator.pop(context);
                  Map<String, dynamic> data = {
                    "stock_name": widget.userSelectedStock,
                    'startDate': DateFormat('yyyy-MM-dd')
                        .format(_dateTimeState!.startFullDate),
                    'endDate' : DateFormat('yyyy-MM-dd').format(_dateTimeState!.endFullDate),
                  };
                  AnalyticsRestApiService()
                      .differentialSellingPriceVsOpenOrderPriceAnalyticsCsv(
                      data
                    // ProfitVsPriceAnalyticsCsvRequest(
                    //     stockName: widget.stockName,
                    //     month: widget.duration)
                  )
                      .then((value) {
                    Fluttertoast.showToast(msg: value!.message!);
                  }).catchError((err) {
                    print(err);
                  });
                },
                child: Text('OK', style: TextStyle(fontSize: 18)),
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
  }
}
