import 'dart:convert';
import 'dart:developer';

import 'package:dozen_diamond/ZH_analysisPriceVsNumberOfStocks/stateManagement/analyticsDateProvider.dart';
import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../ZH_Analysis/models/trade_analytics_time_dropdown_model.dart';
import '../../ZH_analysis/models/analysis_type.dart';
import '../../global/widgets/info_icon_display.dart';
import '../models/analytics_profit_vs_price_graph_request.dart';
import '../models/analytics_profit_vs_price_graph_response.dart';
import '../services/analysis_profit_vs_price_rest_api_service.dart';
import '../widgets/profit_vs_price_csv_dialog.dart';

class AnalysisProfitVsPrice extends StatefulWidget {
  final AnalysisType userSelectedAnalysis;
  final String userSelectedStock;
  const AnalysisProfitVsPrice(
      {super.key,
      required this.userSelectedAnalysis,
      required this.userSelectedStock});

  @override
  State<AnalysisProfitVsPrice> createState() => _AnalysisProfitVsPriceState();
}

class _AnalysisProfitVsPriceState extends State<AnalysisProfitVsPrice> {
  String? warningMessage = "";
  String? _selectedStock;
  TradeAnalyticsTimeDropdown? _selectedTimePeriod;
  AnalysisType? _selectedAnalysisType;
  DateTimeProvider? _dateTimeState;
  AnalyticsProfitVsPriceGraphResponse? graphData;
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
    getProfitVsPriceGraphData();
    // getSelectedStockList();
  }

  _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  Widget filterDataByTime() {
    return Container(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<TradeAnalyticsTimeDropdown>(
          padding: EdgeInsets.zero,
          value: _selectedTimePeriod,
          onChanged:
              _selectedStock == 'Tickers' || _selectedAnalysisType!.itemId != 1
                  ? null
                  : (value) {
                      _selectedTimePeriod = value;
                      if (value!.timePeriodNumber != 0) {
                        getProfitVsPriceGraphData();
                      } else {
                        graphData!.data!.clear();
                        selectedGraphData.clear();
                        _graphDataAvailable = false;
                        _updateState();
                      }
                    },
          dropdownColor: Colors.black,
          items: timePeriodOptions
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

  Widget filterDataByTimeDialogBox(
      void Function(void Function())? dialogSetState) {
    return Container(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<TradeAnalyticsTimeDropdown>(
          padding: EdgeInsets.zero,
          value: _selectedTimePeriod,
          onChanged:
              _selectedStock == 'Tickers' || _selectedAnalysisType!.itemId != 1
                  ? null
                  : (value) {
                      _selectedTimePeriod = value;
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
                        graphData!.data!.clear();
                        selectedGraphData.clear();
                        _graphDataAvailable = false;
                        _updateState();
                      }
                    },
          dropdownColor: Colors.black,
          items: timePeriodOptions
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

  Widget profitVsPriceCsvDialog() {
    return Container(
      child: TextButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return ProfitVsPriceCsvDialog(
                    stockName: _selectedStock,
                    duration: _selectedTimePeriod!.timePeriodNumber,
                  startDate: DateFormat('yyyy-MM-dd')
                      .format(_dateTimeState!.startFullDate),
                  endDate:
                  DateFormat('yyyy-MM-dd').format(_dateTimeState!.endFullDate),
                  graphType: widget.userSelectedAnalysis.itemString!,
                );
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

  Future<void> getProfitVsPriceGraphData() async {
    print("inside getProfitVsPriceGraphData");
    loadingGraphData = true;
    try {
      graphData = await AnalysisProfitVsPriceRestApiService()
          .analyticsProfitVsPriceGraph(AnalyticsProfitVsPriceGraphRequest(
              startDate: DateFormat('yyyy-MM-dd')
                  .format(_dateTimeState!.startFullDate),
              endDate:
                  DateFormat('yyyy-MM-dd').format(_dateTimeState!.endFullDate),
              stockName: _selectedStock));
      print("here is the graphData ${jsonEncode(graphData)}");

      List<LineChartBarData> selectedGraphDataTemp = [];
      if (graphData!.status!) {
        int totalUnits = 0;
        double totalCashGain = 0.0;

        for (var entry in graphData!.data!) {
          if (entry.type == "Cumulative") {
            totalUnits = entry.units ?? 0;
            totalCashGain = entry.cashGain ?? 0.0;
          } else {
            entry.units = (entry.units ?? 0) + totalUnits;
            entry.cashGain = (entry.cashGain ?? 0) + totalCashGain;
            totalUnits = entry.units!;
            totalCashGain = entry.cashGain!;
            // if (entry.tradeNumber == 1) {
            //   entry.cashGain = (entry.cashGain ?? 0.0) + totalCashGain;
            // }
          }
        }

        for (var entry in graphData!.data!) {
          if (!(entry.type == "Cumulative")) {
            print(
                "the graphData is here ${entry.cashGain} and ${entry.units} and ${entry.price} and ${entry.type}");
            print(
                "product of units and price ${((entry.units ?? 0) * (entry.price ?? 0.0))}");
            double profit = (entry.cashGain ?? 0.0) +
                ((entry.units ?? 0) * (entry.price ?? 0.0));
            print("------------------------");
            print(entry.cashGain);
            print(entry.units);
            print(entry.price);
            print("the graphData is here profit $profit");

            hiddenGraphData.add(FlSpot(entry.price ?? 0.0, profit));

            setState(() {
              maxMinY = hiddenGraphData
                  .map((point) => point.y)
                  .reduce((a, b) => a > b ? a : b);
            });
          }
        }

        graphData!.data!.removeWhere((item) => item.type == 'Cumulative');

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

              // if (j > graphData!.data!.length - 1) {
              //   print("never here");
              //   j = graphData!.data!.length - 1;
              // }

              if (graphData!.data![j].type?.toLowerCase() == 'buy') {
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
              } else if (graphData!.data![j].type?.toLowerCase() == 'sell') {
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
              return FlDotCirclePainter(color: Colors.yellow);
            },
          ),
        ));

        print("assigning value in j");

        selectedGraphData = selectedGraphDataTemp;

        _graphDataAvailable = selectedGraphData.length > 0;
      }
    } on HttpApiException catch (err) {
      print("getProfitVsPriceGraphData function $err");
      loadingGraphData = false;
    }

    loadingGraphData = false;

    _updateState();
  }

  Widget profitVsPriceLineChart() {
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
                        "${i == 0 ? 'Price: ${value[i].x}\n' : ''}Profit: ${value[i].y.toStringAsFixed(2)}",
                        TextStyle(color: Colors.white),
                        textAlign: TextAlign.left));
                  } else {
                    tooltipData.add(LineTooltipItem(
                        "${i == 0 ? 'Price: ${value[i].x}\n' : ''}Profit: ${value[i].y.toStringAsFixed(2)}",
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
            axisNameWidget: Text("Open Order Price"),
            sideTitles: SideTitles(
              showTitles: true,
              // interval: 30,
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
            axisNameWidget: Text("Profit"),
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
                              style: GoogleFonts.poppins(
                                fontSize: 18,
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
                    _selectedAnalysisType!.itemId == 1 ||
                            _selectedAnalysisType!.itemId == 13
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
                                  profitVsPriceCsvDialog(),
                                  Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.only(
                                          right: 50, top: 5, bottom: 10),
                                      child: profitVsPriceLineChart()),
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
}
