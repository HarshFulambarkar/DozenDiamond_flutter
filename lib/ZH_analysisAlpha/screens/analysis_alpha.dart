import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../ZH_analysis/models/analysis_type.dart';
import '../../global/widgets/info_icon_display.dart';
import '../models/actual_vs_computed_alpha_request.dart';
import '../models/actual_vs_computed_alpha_response.dart';
import '../models/alpha_gain_analysis_request.dart';
import '../models/alpha_gain_analysis_response.dart';
import '../services/analysis_alpha_rest_api_service.dart';
import '../widgets/actual_vs_computed_alpha_csv_dialog.dart';
import '../widgets/alpha_gain_csv_dialog.dart';

class AnalysisAlpha extends StatefulWidget {
  final AnalysisType userSelectedAnalysis;
  final String userSelectedStock;
  const AnalysisAlpha(
      {super.key,
      required this.userSelectedAnalysis,
      required this.userSelectedStock});

  @override
  State<AnalysisAlpha> createState() => _AnalysisAlphaState();
}

class _AnalysisAlphaState extends State<AnalysisAlpha> {
  String? warningMessage = "";
  String? _selectedStock;
  List<LineChartBarData> actualVsComputedAlphaGraphData = [];
  List<LineChartBarData> alphaGainGraphData = [];
  AnalysisType? _selectedAnalysisType;
  ActualVscomputedAlphaResponse? actualVsComputedAlpha;
  AlphaGainAnalysisResponse? alphaGain;
  List<FlSpot> hiddenAlphaGainGraphData = [];
  final formatter = NumberFormat.compact(locale: "en_US", explicitSign: false);

  late ThemeProvider themeProvider;

  @override
  void initState() {
    super.initState();
    _selectedAnalysisType = widget.userSelectedAnalysis;
    _selectedStock = widget.userSelectedStock;

    getActualVsComputedAlpha();
    // getSelectedStockList();
  }

  _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> getActualVsComputedAlpha() async {
    // 100 indicates fetching all records from starting
    try {
      actualVsComputedAlpha = await AnalysisAlphaRestApiService()
          .actualVsCalculatedAlpha(ActualVscomputedAlphaRequest(
              month: 100, stockName: _selectedStock));

      if (actualVsComputedAlpha!.status!) {
        if (actualVsComputedAlpha!.data!.isNotEmpty) {
          List<FlSpot> actualAlpha = [];
          List<FlSpot> computedAlpha = [];
          actualVsComputedAlpha!.data!.forEach((stockData) {
            computedAlpha.add(FlSpot(double.parse(stockData.price!),
                double.parse(stockData.alpha!)));
            actualAlpha.add(FlSpot(double.parse(stockData.price!),
                stockData.stocksHeld!.toDouble()));

            actualVsComputedAlphaGraphData.add(LineChartBarData(
              spots: [
                FlSpot(double.parse(stockData.price!),
                    double.parse(stockData.alpha!))
              ],
              color: Color.fromARGB(255, 0, 145, 255),
              dotData: FlDotData(
                getDotPainter: (p0, p1, p2, p3) {
                  return FlDotCirclePainter(color: Colors.orange);
                },
              ),
            ));
            actualVsComputedAlphaGraphData.add(LineChartBarData(
              spots: [
                FlSpot(double.parse(stockData.price!),
                    stockData.stocksHeld!.toDouble())
              ],
              color: Color.fromARGB(255, 0, 145, 255),
              dotData: FlDotData(
                getDotPainter: (p0, p1, p2, p3) {
                  return FlDotCirclePainter(color: Colors.blue);
                },
              ),
            ));
          });
          actualVsComputedAlphaGraphData.add(LineChartBarData(
            spots: actualAlpha,
            color: Color.fromARGB(255, 0, 145, 255),
            dotData: FlDotData(
              getDotPainter: (p0, p1, p2, p3) {
                return FlDotCirclePainter(color: Colors.blue);
              },
            ),
          ));
          actualVsComputedAlphaGraphData.add(LineChartBarData(
            spots: computedAlpha,
            color: Colors.orange,
            dotData: FlDotData(
              getDotPainter: (p0, p1, p2, p3) {
                return FlDotCirclePainter(color: Colors.orange);
              },
            ),
          ));
        }
      } else {
        warningMessage = actualVsComputedAlpha!.message ??
            "Insufficient trade record for analysis";
      }
    } on HttpApiException catch (err) {
      print("error in the getActualVsComputedAlpha ${err.errorTitle}");
    }

    _updateState();
  }

  Widget actualVsComputedAlphaCsvDialog() {
    return Container(
      child: TextButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return ActualVsComputedAlphaCsvDialog(
                  stockName: _selectedStock,
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
      margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
    );
  }

  Widget alphaGainCsvDialog() {
    return Container(
      child: TextButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlphaGainCsvDialog(
                  stockName: _selectedStock,
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

  Future<void> getAlphaGain() async {
    // 100 indicates fetching all records from starting
    AnalysisAlphaRestApiService()
        .alphaGainAnalysis(
            AlphaGainAnalysisRequest(month: 100, stockName: _selectedStock))
        .then((value) {
      if (value!.status!) {
        alphaGain = value;
        for (var graphData in value.data!) {
          if (graphData.alphaGain! != "NaN") {
            hiddenAlphaGainGraphData.add(FlSpot(double.parse(graphData.price!),
                double.parse(graphData.alphaGain!)));

            alphaGainGraphData.add(LineChartBarData(
              spots: [
                FlSpot(double.parse(graphData.price!),
                    double.parse(graphData.alphaGain!))
              ],
              color: Color.fromARGB(255, 0, 145, 255),
              dotData: FlDotData(getDotPainter: (p0, p1, p2, p3) {
                return FlDotCirclePainter(color: Colors.orange, radius: 3);
              }),
              // isCurved: true,
            ));
          }
        }
        alphaGainGraphData.add(LineChartBarData(
          spots: hiddenAlphaGainGraphData,
          color: Color.fromARGB(255, 0, 145, 255),
          dotData: FlDotData(
            getDotPainter: (p0, p1, p2, p3) {
              return FlDotCirclePainter(color: Colors.orange, radius: 3);
            },
          ),
        ));
      } else {
        warningMessage = value.msg ?? "Insufficient trade records for analysis";
      }
      _updateState();
    });
  }

  Widget actualVsComputedAlphaWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        actualVsComputedAlphaCsvDialog(),
        Container(
            height: MediaQuery.of(context).size.height * 0.48,
            width: MediaQuery.of(context).size.width * 0.9,
            margin: EdgeInsets.only(
              right: 50,
              top: 0,
            ),
            child: LineChart(
              LineChartData(
                lineBarsData: actualVsComputedAlphaGraphData,
                // clipData: FlClipData.all(),
                // minX: 0,
                // minY: 0,
                // maxX: 500,
                gridData: FlGridData(
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                        color: Colors.white,
                        dashArray: [10, 5],
                        strokeWidth: 0.6);
                  },
                  getDrawingVerticalLine: (value) {
                    print(value);
                    return FlLine(
                        color: Colors.white,
                        dashArray: [10, 5],
                        strokeWidth: 0.6);
                  },
                ),
                maxY: null,
                lineTouchData: LineTouchData(
                  // touchCallback: (p0, p1) {
                  //   print("pak ${p1!.lineBarSpots!.length}");
                  // },
                  // getTouchedSpotIndicator: (barData, spotIndexes) {
                  //   print("gareed ${barData.spots}");
                  //   return [
                  //     TouchedSpotIndicatorData(FlLine(color: Colors.red), FlDotData(
                  //       getDotPainter: (p0, p1, p2, p3) {
                  //         return FlDotCirclePainter(color: Colors.white);
                  //       },
                  //     ))
                  //   ];
                  // },
                  // handleBuiltInTouches: false,
                  touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (value) {
                        List<LineTooltipItem> tooltipData = [];
                        // for (var spotData in value) {
                        //   print("paneer: ${spotData.bar} ${value.length}");
                        //   tooltipData.add(LineTooltipItem(
                        //       "Execution price: ${spotData.x}\nStock value: ${spotData.y}\nTrade Execution time: ${formatUtcToLocal(graphData[spotData.spotIndex].createdAt)}",
                        //       TextStyle(color: Colors.white)));
                        // }
                        for (int i = 0; i < value.length; i++) {
                          if (i % 2 == 0) {
                            tooltipData.add(
                                LineTooltipItem("", TextStyle(fontSize: 0)));
                          } else {
                            tooltipData.add(LineTooltipItem(
                                "${i == 1 ? 'Price: ${value[i].x}\n' : ''}",
                                TextStyle(color: Colors.white),
                                textAlign: TextAlign.left,
                                children: [
                                  TextSpan(
                                      text:
                                          "${value[i].bar.color!.value == Color(0xffff9800).value ? 'Computed α' : 'Actual α'}: ${value[i].y}",
                                      style:
                                          TextStyle(color: value[i].bar.color))
                                ]));
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
                            // axisSide: meta.axisSide,
                            meta: meta,
                            child: axisTitle);
                      },
                      reservedSize: 25,
                    ),
                    axisNameSize: 16,
                  ),
                  leftTitles: AxisTitles(
                    axisNameWidget: Text("Quantity"),
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
                            axisTitle = const SizedBox.shrink();
                          }
                        }
                        return SideTitleWidget(
                            meta: meta,
                            // axisSide: meta.axisSide,
                            child: axisTitle);
                      },
                    ),
                  ),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
            )),
        Container(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.fiber_manual_record,
                color: Colors.orange,
                size: 15,
              ),
              SizedBox(
                width: 5,
              ),
              Text("Alpha"),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.fiber_manual_record,
                color: Colors.blue,
                size: 15,
              ),
              SizedBox(
                width: 5,
              ),
              Text("Actual quantity"),
              SizedBox(
                width: 35,
              ),
            ],
            // mainAxisSize: MainAxisSize.min,
          ),
        )
      ],
    );
  }

  Widget alphaGainAnalysisWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        alphaGainCsvDialog(),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(right: 50, top: 5, bottom: 10),
          child: LineChart(
            LineChartData(
              lineBarsData: alphaGainGraphData,
              // clipData: FlClipData.all(),
              // minX: 0,
              // minY: 0,
              // maxX: 500,
              gridData: FlGridData(
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                      color: Colors.white,
                      dashArray: [10, 5],
                      strokeWidth: 0.6);
                },
                getDrawingVerticalLine: (value) {
                  print(value);
                  return FlLine(
                      color: Colors.white,
                      dashArray: [10, 5],
                      strokeWidth: 0.6);
                },
              ),
              maxY: null,
              lineTouchData: LineTouchData(
                // getTouchedSpotIndicator: (barData, spotIndexes) {
                //   print("gareed ${barData.spots}");
                //   return [
                //     TouchedSpotIndicatorData(FlLine(color: Colors.red), FlDotData(
                //       getDotPainter: (p0, p1, p2, p3) {
                //         return FlDotCirclePainter(color: Colors.white);
                //       },
                //     ))
                //   ];
                // },
                // handleBuiltInTouches: false,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (value) {
                    List<LineTooltipItem> tooltipData = [];
                    // for (var spotData in value) {
                    //   print("paneer: ${spotData.bar} ${value.length}");
                    //   tooltipData.add(LineTooltipItem(
                    //       "Execution price: ${spotData.x}\nStock value: ${spotData.y}\nTrade Execution time: ${formatUtcToLocal(graphData[spotData.spotIndex].createdAt)}",
                    //       TextStyle(color: Colors.white)));
                    // }
                    for (int i = 0; i < value.length; i++) {
                      if (i == value.length - 1) {
                        tooltipData
                            .add(LineTooltipItem("", TextStyle(fontSize: 0)));
                      } else {
                        tooltipData.add(LineTooltipItem(
                            "${i == 0 ? 'Price: ${value[i].x}\n' : ''}Alpha gain: ${value[i].y}",
                            TextStyle(color: Colors.white),
                            textAlign: TextAlign.left));
                      }
                    }
                    return tooltipData;
                  },
                  fitInsideHorizontally: true,
                  fitInsideVertically: true,
                ),
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
                      if (value == meta.max) {
                        final remainder = value % meta.appliedInterval;
                        if (remainder != 0.0 &&
                            remainder / meta.appliedInterval < 0.5) {
                          axisTitle = const SizedBox.shrink();
                        }
                      }

                      return SideTitleWidget(
                          // axisSide: meta.axisSide,
                          meta: meta,
                          child: axisTitle);
                    },
                    reservedSize: 25,
                  ),
                  axisNameSize: 16,
                ),
                leftTitles: AxisTitles(
                  axisNameWidget: Text("Alpha gain"),
                  axisNameSize: 16,
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 50,
                    getTitlesWidget: (value, meta) {
                      Widget axisTitle = Text(formatter.format(value));
                      // A workaround to hide the max value title as FLChart is overlapping it on top of previous
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
                  ),
                ),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 20),
          alignment: Alignment.centerRight,
          child: Row(
            children: [
              Icon(
                Icons.fiber_manual_record,
                color: Colors.orange,
                size: 15,
              ),
              SizedBox(
                width: 5,
              ),
              Text("Alpha gain"),
            ],
            mainAxisSize: MainAxisSize.min,
          ),
        )
      ],
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
                      _selectedAnalysisType!.itemId == 15 //7
                          ? actualVsComputedAlpha != null
                              ? actualVsComputedAlphaWidget()
                              : Container(
                                  margin: EdgeInsets.only(
                                      top: 10, left: 20, right: 20),
                                  child: Text(warningMessage!),
                                )
                          : Container(),
                      _selectedAnalysisType!.itemId == 15 //8
                          ? alphaGain != null
                              ? alphaGainAnalysisWidget()
                              : Container(
                                  margin: EdgeInsets.only(
                                      top: 10, left: 20, right: 20),
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
              isForPop:
                  true, //these leadingAction button is not working, I have tired making it work, but it isn't.
            )
          ],
        ),
      ),
    );
  }
}
