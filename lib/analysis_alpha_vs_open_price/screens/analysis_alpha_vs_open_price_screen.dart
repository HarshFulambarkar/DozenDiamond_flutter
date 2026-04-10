import 'package:dozen_diamond/Settings/stateManagement/theme_provider.dart';
import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../ZH_analysis/models/analysis_type.dart';
import '../../ZH_analysisPriceVsNumberOfStocks/stateManagement/analyticsDateProvider.dart';
import '../../global/widgets/info_icon_display.dart';
import '../models/alpha_vs_open_price_request.dart';
import '../models/analysis_alpha_vs_open_price_response.dart';
import '../services/analysis_alpha_vs_open_price_rest_api_service.dart';

class AnalysisAlphaVsOpenPriceScreen extends StatefulWidget {
  final AnalysisType userSelectedAnalysis;
  final String userSelectedStock;
  const AnalysisAlphaVsOpenPriceScreen({
    super.key,
    required this.userSelectedAnalysis,
    required this.userSelectedStock,
  });

  @override
  State<AnalysisAlphaVsOpenPriceScreen> createState() =>
      _AnalysisAlphaVsOpenPriceScreenState();
}

class _AnalysisAlphaVsOpenPriceScreenState
    extends State<AnalysisAlphaVsOpenPriceScreen> {
  String? warningMessage = "";
  String? _selectedStock;
  List<LineChartBarData> actualVsComputedAlphaGraphData = [];
  List<LineChartBarData> alphaGainGraphData = [];
  AnalysisType? _selectedAnalysisType;
  AnalysisAlphaVsOpenPriceResponse? analysisAlphaVsOpenPriceResponse;
  late ThemeProvider themeProvider;

  bool isGraphLoading = false;

  List<FlSpot> hiddenAlphaGainGraphData = [];
  final formatter = NumberFormat.compact(locale: "en_US", explicitSign: false);

  DateTimeProvider? _dateTimeState;

  @override
  void initState() {
    super.initState();
    _selectedAnalysisType = widget.userSelectedAnalysis;
    _selectedStock = widget.userSelectedStock;

    _dateTimeState = Provider.of<DateTimeProvider>(context, listen: false);
    getAlphaVsOpenPrice();
    // getSelectedStockList();
  }

  _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> getAlphaVsOpenPrice() async {
    // 100 indicates fetching all records from starting
    isGraphLoading = true;
    try {
      analysisAlphaVsOpenPriceResponse =
      await AnalysisAlphaVsOpenPriceRestApiService()
          .analyticsAlphaVsOpenPriceGraph(
        AlphaVsOpenPriceRequest(
          startDate: DateFormat(
            'yyyy-MM-dd',
          ).format(_dateTimeState!.startFullDate),
          endDate: DateFormat(
            'yyyy-MM-dd',
          ).format(_dateTimeState!.endFullDate),
          stockName: _selectedStock,
        ),
      );

      if (analysisAlphaVsOpenPriceResponse!.status! &&
          analysisAlphaVsOpenPriceResponse!.data != null) {
        if (analysisAlphaVsOpenPriceResponse!.data!.isNotEmpty) {
          List<FlSpot> stockOwn = [];
          List<FlSpot> alpha5 = [];
          List<FlSpot> alpha10 = [];
          analysisAlphaVsOpenPriceResponse!.data!.forEach((stockData) {
            stockOwn.add(
              FlSpot(
                double.parse(stockData.price!.toString()),
                stockData.stockOwn!.toDouble(),
              ),
            );

            alpha5.add(
              FlSpot(
                double.parse(stockData.price!.toString()),
                double.parse(stockData.alpha5!.toStringAsFixed(2)),
              ),
            );

            if (stockData.alpha10 != null) {
              alpha10.add(
                FlSpot(
                  double.parse(stockData.price!.toString()),
                  double.parse(stockData.alpha10!.toStringAsFixed(2)),
                ),
              );
            }

            // actualVsComputedAlphaGraphData.add(LineChartBarData(
            //   spots: [
            //     FlSpot(double.parse(stockData.price!.toString()),
            //         double.parse(stockData.alpha5!.toString()))
            //   ],
            //   color: Color.fromARGB(255, 0, 145, 255),
            //   dotData: FlDotData(
            //     getDotPainter: (p0, p1, p2, p3) {
            //       return FlDotCirclePainter(color: Colors.orange);
            //     },
            //   ),
            // ));
            // actualVsComputedAlphaGraphData.add(LineChartBarData(
            //   spots: [
            //     FlSpot(double.parse(stockData.price!.toString()),
            //         stockData.stockOwn!.toDouble())
            //   ],
            //   color: Color.fromARGB(255, 0, 145, 255),
            //   dotData: FlDotData(
            //     getDotPainter: (p0, p1, p2, p3) {
            //       return FlDotCirclePainter(color: Colors.blue);
            //     },
            //   ),
            // ));
          });
          actualVsComputedAlphaGraphData.add(
            LineChartBarData(
              spots: stockOwn,
              color: Color.fromARGB(255, 0, 145, 255),
              dotData: FlDotData(
                getDotPainter: (p0, p1, p2, p3) {
                  return FlDotCirclePainter(color: Colors.blue);
                },
              ),
            ),
          );
          actualVsComputedAlphaGraphData.add(
            LineChartBarData(
              spots: alpha5,
              color: Colors.orange,
              dotData: FlDotData(
                getDotPainter: (p0, p1, p2, p3) {
                  return FlDotCirclePainter(color: Colors.orange);
                },
              ),
            ),
          );
          actualVsComputedAlphaGraphData.add(
            LineChartBarData(
              spots: alpha10,
              color: Colors.purple,
              dotData: FlDotData(
                getDotPainter: (p0, p1, p2, p3) {
                  return FlDotCirclePainter(color: Colors.purple);
                },
              ),
            ),
          );
        }
      } else {
        warningMessage =
            analysisAlphaVsOpenPriceResponse!.message ??
                "Insufficient trade record for analysis";
      }

      isGraphLoading = false;
    } on HttpApiException catch (err) {
      print("error in the getActualVsComputedAlpha ${err.errorTitle}");
      isGraphLoading = false;
    }

    isGraphLoading = false;

    _updateState();
  }

  Widget alphaVsOpenOrderPriceCsvDialog() {
    return Container(
      child: TextButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return csvDownloadDialog(context);
              // return ActualVsComputedAlphaCsvDialog(
              //   stockName: _selectedStock,
              // );
            },
          );
        },
        child: Text("Download CSV", style: TextStyle(color: Color(0xFF0099CC))),
        style: TextButton.styleFrom(padding: EdgeInsets.zero),
      ),
      margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
    );
  }
  //
  // Widget alphaGainCsvDialog() {
  //   return Container(
  //     child: TextButton(
  //       onPressed: () {
  //         showDialog(
  //             context: context,
  //             builder: (context) {
  //               return AlphaGainCsvDialog(
  //                 stockName: _selectedStock,
  //               );
  //             });
  //       },
  //       child: Text(
  //         "Download CSV",
  //         style: TextStyle(
  //           color: Color(0xFF0099CC),
  //         ),
  //       ),
  //       style: TextButton.styleFrom(padding: EdgeInsets.zero),
  //     ),
  //     margin: EdgeInsets.fromLTRB(0, 0, 18, 0),
  //   );
  // }

  // Future<void> getAlphaGain() async {
  //   // 100 indicates fetching all records from starting
  //   for (var graphData in analysisAlphaVsOpenPriceResponse!.data!) {
  //     if (graphData.alpha10 != null) {
  //       hiddenAlphaGainGraphData.add(FlSpot(double.parse(graphData.price!.toString()),
  //           double.parse(graphData.alpha10!.toString())));
  //
  //       alphaGainGraphData.add(LineChartBarData(
  //         spots: [
  //           FlSpot(double.parse(graphData.price!.toString()),
  //               double.parse(graphData.alpha10!.toString()))
  //         ],
  //         color: Color.fromARGB(255, 0, 145, 255),
  //         dotData: FlDotData(getDotPainter: (p0, p1, p2, p3) {
  //           return FlDotCirclePainter(color: Colors.orange, radius: 3);
  //         }),
  //         // isCurved: true,
  //       ));
  //     }
  //   }
  //   alphaGainGraphData.add(LineChartBarData(
  //     spots: hiddenAlphaGainGraphData,
  //     color: Color.fromARGB(255, 0, 145, 255),
  //     dotData: FlDotData(
  //       getDotPainter: (p0, p1, p2, p3) {
  //         return FlDotCirclePainter(color: Colors.orange, radius: 3);
  //       },
  //     ),
  //   ));
  // }

  Widget alphaVsOpenPriceWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        alphaVsOpenOrderPriceCsvDialog(),
        // actualVsComputedAlphaCsvDialog(),
        Container(
          height: MediaQuery.of(context).size.height * 0.48,
          width: MediaQuery.of(context).size.width * 0.9,
          margin: EdgeInsets.only(right: 50, top: 0),
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
                    color: (themeProvider.defaultTheme)
                        ? Colors.black
                        : Colors.white,
                    dashArray: [10, 5],
                    strokeWidth: 0.6,
                  );
                },
                getDrawingVerticalLine: (value) {
                  print(value);
                  return FlLine(
                    color: (themeProvider.defaultTheme)
                        ? Colors.black
                        : Colors.white,
                    dashArray: [10, 5],
                    strokeWidth: 0.6,
                  );
                },
              ),
              maxY: null,
              lineTouchData: LineTouchData(
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
                          LineTooltipItem("", TextStyle(fontSize: 0)),
                        );
                      } else {
                        tooltipData.add(
                          LineTooltipItem(
                            "${i == 1 ? 'Price: ${value[i].x}\n' : ''}",
                            TextStyle( color:(themeProvider.defaultTheme)
                                ? Colors.black
                                : Colors.white,),
                            textAlign: TextAlign.left,
                            children: [
                              // TextSpan(
                              //     text: "Stock Own: ${value[i].y}",
                              //     style:
                              //     TextStyle(color: Colors.white))
                              TextSpan(
                                text:
                                "${(value[i].bar.color!.value == Colors.blue.value)
                                    ? 'Stock Own'
                                    : (value[i].bar.color!.value == Colors.purple.value)
                                    ? 'Alpha'
                                    : 'Alpha'}: ${value[i].y}",
                                style: TextStyle( color:(themeProvider.defaultTheme)
                                    ? Colors.black
                                    : Colors.white,),
                              ),
                              // TextStyle(color: value[i].bar.color))
                            ],
                          ),
                        );
                      }
                    }
                    return tooltipData;
                  },
                  fitInsideHorizontally: true,
                  fitInsideVertically: true,
                  tooltipHorizontalAlignment: FLHorizontalAlignment.right,
                ),
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
                        // axisSide: meta.axisSide,
                        meta: meta,
                        child: axisTitle,
                      );
                    },
                    reservedSize: 25,
                  ),
                  axisNameSize: 16,
                ),
                leftTitles: AxisTitles(
                  axisNameWidget: Text("Alpha"),
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
                        // axisSide: meta.axisSide,
                        meta: meta,
                        child: axisTitle,
                      );
                    },
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  left: BorderSide( color:(themeProvider.defaultTheme)
                      ? Colors.black
                      : Colors.white,),
                  bottom: BorderSide( color:(themeProvider.defaultTheme)
                      ? Colors.black
                      : Colors.white,),
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
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.fiber_manual_record, color: Colors.blue, size: 15),
              SizedBox(width: 5),
              Text("Price"),
              SizedBox(width: 10),
              Icon(Icons.fiber_manual_record, color: Colors.orange, size: 15),
              SizedBox(width: 5),
              Text("Alpha5"),
              SizedBox(width: 10),
              Icon(Icons.fiber_manual_record, color: Colors.purple, size: 15),
              SizedBox(width: 5),
              Text("Alpha10"),
              SizedBox(width: 35),
            ],
            // mainAxisSize: MainAxisSize.min,
          ),
        ),
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
            Center(
              child: Container(
                color: (themeProvider.defaultTheme)
                    ? Color(0XFFF5F5F5)
                    : Colors.transparent,
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
                      SizedBox(height: 45),

                      // SizedBox(
                      //   height: AppBar().preferredSize.height * 1.2,
                      // ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 5,
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            children: [
                              Text(
                                "${widget.userSelectedStock}  ${widget.userSelectedAnalysis.itemString!}",
                                style: TextStyle(fontSize: 20),
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
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      _selectedAnalysisType!.itemId ==
                          14 //7
                          ? (isGraphLoading)
                          ? Container(
                        height:
                        MediaQuery.of(context).size.height *
                            0.5,
                        child: Center(
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                          : (analysisAlphaVsOpenPriceResponse!.data ==
                          null)
                          ? Center(
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 10,
                            left: 20,
                            right: 20,
                          ),
                          child: Text(warningMessage!),
                        ),
                      )
                          : alphaVsOpenPriceWidget()
                          : Container(
                        margin: EdgeInsets.only(
                          top: 10,
                          left: 20,
                          right: 20,
                        ),
                        child: Text(warningMessage!),
                      ),
                      // _selectedAnalysisType!.itemId == 14 //8
                      //     ? alphaGainAnalysisWidget()
                      //     : Container(
                      //   margin: EdgeInsets.only(
                      //       top: 10, left: 20, right: 20),
                      //   child: Text(warningMessage!),
                      // ),
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
            ),
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
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
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
                  print("clicked here");
                  Navigator.pop(context);
                  Map<String, dynamic> data = {
                    "stock_name": widget.userSelectedStock,
                    'startDate': DateFormat(
                      'yyyy-MM-dd',
                    ).format(_dateTimeState!.startFullDate),
                    'endDate': DateFormat(
                      'yyyy-MM-dd',
                    ).format(_dateTimeState!.endFullDate),
                  };
                  AnalysisAlphaVsOpenPriceRestApiService()
                      .alphaVsOpenPriceAnalyticsCsv(
                    data,
                    // ProfitVsPriceAnalyticsCsvRequest(
                    //     stockName: widget.stockName,
                    //     month: widget.duration)
                  )
                      .then((value) {
                    Fluttertoast.showToast(msg: value!.message!);
                  })
                      .catchError((err) {
                    print(err);
                  });
                },
                child: Text('OK', style: TextStyle(fontSize: 18)),
              ),
            ),
            SizedBox(width: 10),
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
  }
}