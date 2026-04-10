import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:dozen_diamond/ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import 'package:dozen_diamond/ZH_Analysis/models/trade_analytics_time_dropdown_model.dart';
import 'package:dozen_diamond/ZH_analysis/models/analysis_type.dart';
import 'package:dozen_diamond/ZH_analysisPriceVsNumberOfStocks/models/plotGraphData.dart';
import 'package:dozen_diamond/ZH_analysisPriceVsNumberOfStocks/stateManagement/analyticsDateProvider.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';

class AnalysisPriceVsValue extends StatefulWidget {
  final AnalysisType userSelectedAnalysis;
  final String userSelectedStock;
  const AnalysisPriceVsValue(
      {super.key,
      required this.userSelectedAnalysis,
      required this.userSelectedStock});

  @override
  State<AnalysisPriceVsValue> createState() =>
      _AnalysisPriceVsNumberOfStocksState();
}

class _AnalysisPriceVsNumberOfStocksState extends State<AnalysisPriceVsValue> {
  DateTimeProvider? _dateTimeState;

  String? warningMessage = "";
  String? _selectedStock;
  AnalysisType? _selectedAnalysisType;
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

  @override
  void initState() {
    super.initState();
    _selectedAnalysisType = widget.userSelectedAnalysis;
    _selectedStock = widget.userSelectedStock;
    _dateTimeState = Provider.of<DateTimeProvider>(context, listen: false);
    _dateTimeState!.getGraphData(_selectedStock);
    getProfitVsPriceGraphData(_dateTimeState!.graphData);

    // getSelectedStockList();
  }

  _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> getProfitVsPriceGraphData(PlotGraphData graphData) async {
    try {
      for (var i = 0; i < graphData.orders!.length; i++) {
        hiddenGraphData.add(FlSpot(graphData.orders![i].executionPrice!,
            double.tryParse((graphData.orders![i].value).toString()) ?? 0));
        selectedGraphData.add(LineChartBarData(
          spots: [
            FlSpot(graphData.orders![i].executionPrice!,
                double.tryParse((graphData.orders![i].value).toString()) ?? 0)
          ],
          barWidth: 10,
          color: Colors.white,
          dotData: FlDotData(
            getDotPainter: (p0, p1, p2, p3) {
              if (graphData.orders![i].tradeType == 'BUY') {
                if (i == 0) {
                  return FlDotCrossPainter(
                      color: Color.fromARGB(255, 0, 255, 34), size: 12);
                } else if (i == graphData.orders!.length - 1) {
                  return FlDotSquarePainter(
                      color: Color.fromARGB(255, 0, 255, 34), size: 8);
                } else {
                  return FlDotCirclePainter(
                      color: Color.fromARGB(255, 0, 255, 34));
                }
              } else if (graphData.orders![i].tradeType == 'SELL') {
                if (i == 0) {
                  return FlDotCrossPainter(
                      color: const Color.fromARGB(255, 255, 0, 0), size: 12);
                } else if (i == graphData.orders!.length - 1) {
                  return FlDotSquarePainter(
                      color: const Color.fromARGB(255, 255, 0, 0), size: 8);
                } else {
                  return FlDotCirclePainter(
                      color: const Color.fromARGB(255, 255, 0, 0));
                }
              }
              return FlDotCirclePainter(color: Colors.yellow);
            },
          ),
        ));
      }
      int j = 0;
      selectedGraphData.add(LineChartBarData(
        spots: hiddenGraphData,

        // color: Color.fromARGB(255, 0, 145, 255),
        color: Colors.blue,
        barWidth: 1,
        dotData: FlDotData(
          getDotPainter: (p0, p1, p2, p3) {
            if (j >= graphData.orders!.length - 1) {
              j = 0;
            } else {
              j++;
            }

            if (j > graphData.orders!.length - 1) {
              j = graphData.orders!.length - 1;
            }

            if (graphData.orders![j].tradeType?.toLowerCase() == 'buy') {
              if (j == 0) {
                return FlDotCirclePainter(
                    color: Color.fromARGB(255, 0, 255, 34));
                // return FlDotCrossPainter(
                //     color: Color.fromARGB(255, 0, 255, 34), size: 12);
              } else if (j == graphData.orders!.length - 1) {
                return FlDotCirclePainter(
                    color: Color.fromARGB(255, 0, 255, 34));
                // return FlDotSquarePainter(
                //     color: Color.fromARGB(255, 0, 255, 34), size: 8);
              } else {
                return FlDotCirclePainter(
                    color: Color.fromARGB(255, 0, 255, 34));
              }
            } else if (graphData.orders![j].tradeType?.toLowerCase() ==
                'sell') {
              if (j == 0) {
                return FlDotCirclePainter(
                    color: const Color.fromARGB(255, 255, 0, 0));
                // return FlDotCrossPainter(
                //     color: const Color.fromARGB(255, 255, 0, 0), size: 12);
              } else if (j == graphData.orders!.length - 1) {
                return FlDotCirclePainter(
                    color: const Color.fromARGB(255, 255, 0, 0));
                // return FlDotSquarePainter(
                //     color: const Color.fromARGB(255, 255, 0, 0), size: 8);
              } else {
                return FlDotCirclePainter(
                    color: const Color.fromARGB(255, 255, 0, 0));
              }
            }

            return FlDotCirclePainter(color: Colors.yellow);
          },
        ),
      ));
      _graphDataAvailable = selectedGraphData.length > 0;
    } on HttpApiException catch (err) {
      print("getProfitVsPriceGraphData function $err");
    }

    _updateState();
  }

  Widget profitVsPriceLineChart() {
    return LineChart(
      LineChartData(
        lineBarsData: selectedGraphData,

        gridData: FlGridData(
          getDrawingHorizontalLine: (value) {
            return FlLine(
                color: Colors.white, dashArray: [10, 5], strokeWidth: 0.6);
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
                color: Colors.white, dashArray: [10, 5], strokeWidth: 0.6);
          },
        ),
        maxY: null,
        lineTouchData: LineTouchData(
          // touchCallback: (p0, p1) {
          //   print("pak ${p1!.lineBarSpots!.length}");
          // },
          touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (value) {
                List<LineTooltipItem> tooltipData = [];

                for (int i = 0; i < value.length; i++) {
                  if (i == value.length - 1) {
                    tooltipData
                        .add(LineTooltipItem("", TextStyle(fontSize: 0)));
                  } else {
                    tooltipData.add(LineTooltipItem(
                        "${i == 0 ? 'Price: ${value[i].x}\n' : ''}value: ${value[i].y}",
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
            axisNameWidget: Text("Price"),
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
            axisNameWidget: Text("value"),
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
            left: BorderSide(color: Colors.white),
            bottom: BorderSide(color: Colors.white),
          ),
        ),
        // backgroundColor: Colors.white,
      ),
      duration: Duration(milliseconds: 150),
      curve: Curves.linear,
      // swapAnimationDuration: Duration(milliseconds: 150), // Optional
      // swapAnimationCurve: Curves.linear, // Optional
    );
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
                  width: screenWidth,
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
                      (_selectedAnalysisType?.itemId ?? 0) < 5
                          ? !_graphDataAvailable
                              ? Container(
                                  margin: EdgeInsets.only(top: 10, left: 40),
                                  child: Text(warningMessage!),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.5,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.only(
                                            left: 10,
                                            right: 50,
                                            top: 5,
                                            bottom: 10),
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
                ),
              ),
            ),
            CustomHomeAppBarWithProviderNew(
              backButton: true,
              isForPop: true,
            ),
          ],
        ),
      ),
    );
  }
}
