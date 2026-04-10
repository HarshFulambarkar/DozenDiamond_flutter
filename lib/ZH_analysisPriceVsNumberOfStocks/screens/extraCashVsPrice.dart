import 'package:dozen_diamond/ZH_analysis/models/analysis_type.dart';
import 'package:dozen_diamond/ZH_analysisPriceVsNumberOfStocks/models/analyticsRequest.dart';
import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../ZH_Analysis/models/trade_analytics_time_dropdown_model.dart';
import '../../global/models/http_api_exception.dart';
import '../../global/widgets/info_icon_display.dart';
import '../models/ExtraCashVsPriceDataResponse.dart';
import '../models/plotGraphData.dart';
import '../services/priceVsValueVsNOSService.dart';
import '../stateManagement/analyticsDateProvider.dart';

class ExtraCashVsPrice extends StatefulWidget {
  final AnalysisType userSelectedAnalysis;
  final String userSelectedStock;
  const ExtraCashVsPrice(
      {super.key,
      required this.userSelectedAnalysis,
      required this.userSelectedStock});

  @override
  State<ExtraCashVsPrice> createState() => _ExtraCashVsPriceState();
}

class _ExtraCashVsPriceState extends State<ExtraCashVsPrice> {
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

  bool loadingGraphData = false;

  late ThemeProvider themeProvider;
  @override
  void initState() {
    super.initState();
    _dateTimeState = Provider.of<DateTimeProvider>(context, listen: false);
    _selectedAnalysisType = widget.userSelectedAnalysis;
    _selectedStock = widget.userSelectedStock;
    loadData();
    // getSelectedStockList();
  }

  loadData() async {
    loadingGraphData = true;
    await _dateTimeState!.getExtraGraphData(AnalyticsRequest(
        startDate:
            DateFormat('yyyy-MM-dd').format(_dateTimeState!.startFullDate),
        endDate: DateFormat('yyyy-MM-dd').format(_dateTimeState!.endFullDate),
        stockName: _selectedStock));
    getExtraCashVsPriceGraphData(_dateTimeState!.extraCashGraphData);
  }

  _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> getExtraCashVsPriceGraphData(
      ExtraCashVsPriceDataResponse graphData) async {
    try {
      for (var i = 0; i < graphData.data!.length; i++) {
        hiddenGraphData.add(FlSpot(
            double.parse((graphData.data![i].price!).toString()),
            double.tryParse((graphData.data![i].extraCash).toString()) ?? 0));
        selectedGraphData.add(LineChartBarData(
          spots: [
            FlSpot(double.parse((graphData.data![i].price!).toString()),
                double.tryParse((graphData.data![i].extraCash).toString()) ?? 0)
          ],
          barWidth: 10,
          color: Colors.white,
          dotData: FlDotData(
            getDotPainter: (p0, p1, p2, p3) {
              if (graphData.data![i].type == 'BUY') {
                if (i == 0) {
                  return FlDotCrossPainter(
                      color: Color.fromARGB(255, 0, 255, 34), size: 12);
                } else if (i == graphData.data!.length - 1) {
                  return FlDotSquarePainter(
                      color: Color.fromARGB(255, 0, 255, 34), size: 8);
                } else {
                  return FlDotCirclePainter(
                      color: Color.fromARGB(255, 0, 255, 34));
                }
              } else if (graphData.data![i].type == 'SELL') {
                if (i == 0) {
                  return FlDotCrossPainter(
                      color: const Color.fromARGB(255, 255, 0, 0), size: 12);
                } else if (i == graphData.data!.length - 1) {
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
            if (j >= graphData.data!.length - 1) {
              j = 0;
            } else {
              j++;
            }

            if (j > graphData.data!.length - 1) {
              j = graphData.data!.length - 1;
            }

            if (graphData.data![j].type?.toLowerCase() == 'buy') {
              if (j == 0) {
                return FlDotCirclePainter(
                    color: Color.fromARGB(255, 0, 255, 34));
                // return FlDotCrossPainter(
                //     color: Color.fromARGB(255, 0, 255, 34), size: 12);
              } else if (j == graphData.data!.length - 1) {
                return FlDotCirclePainter(
                    color: Color.fromARGB(255, 0, 255, 34));
                // return FlDotSquarePainter(
                //     color: Color.fromARGB(255, 0, 255, 34), size: 8);
              } else {
                return FlDotCirclePainter(
                    color: Color.fromARGB(255, 0, 255, 34));
              }
            } else if (graphData.data![j].type?.toLowerCase() == 'sell') {
              if (j == 0) {
                return FlDotCirclePainter(
                    color: const Color.fromARGB(255, 255, 0, 0));
                // return FlDotCrossPainter(
                //     color: const Color.fromARGB(255, 255, 0, 0), size: 12);
              } else if (j == graphData.data!.length - 1) {
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
                color:
                    (themeProvider.defaultTheme) ? Colors.black : Colors.white,
                dashArray: [10, 5],
                strokeWidth: 0.6);
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
                color:
                    (themeProvider.defaultTheme) ? Colors.black : Colors.white,
                dashArray: [10, 5],
                strokeWidth: 0.6);
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
                        // "${i == 0 ? 'Price: ${value[i].x}\n' : ''}Extra Cash: ${value[i].y}",
                        "Extra Cash: ${value[i].y}\n${i == 0 ? 'Price: ${value[i].x}' : ''}",
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
            axisNameWidget: Text("Extra Cash"),
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
            left: BorderSide(
                color:
                    (themeProvider.defaultTheme) ? Colors.black : Colors.white),
            bottom: BorderSide(
                color:
                    (themeProvider.defaultTheme) ? Colors.black : Colors.white),
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
                      SizedBox(
                        height: 45,
                      ),
                      // SizedBox(
                      //   height: AppBar().preferredSize.height * 1.2,
                      // ),

                      // SizedBox(
                      //   height: 20,
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
                      (_selectedAnalysisType?.itemId ?? 0) < 6
                          ? !_graphDataAvailable
                              ? (loadingGraphData)
                                  ? Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                      child: Center(
                                          child: SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: CircularProgressIndicator(),
                                      )),
                                    )
                                  : Container(
                                      margin:
                                          EdgeInsets.only(top: 10, left: 40),
                                      child: Text(warningMessage!),
                                    )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    extraCashVsPriceCsvDialog(),
                                    Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.5,
                                        width:
                                            MediaQuery.of(context).size.width,
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
                ),
              ),
            ),
            CustomHomeAppBarWithProviderNew(backButton: true, isForPop: true),
            // TopNavigation.TopBarNavigation(context),
          ],
        ),
      ),
    );
  }

  Widget extraCashVsPriceCsvDialog() {
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
                    'endDate': DateFormat('yyyy-MM-dd')
                        .format(_dateTimeState!.endFullDate),
                  };
                  PriceVsValueVsNoOfStocks()
                      .stockExtraCashVsPriceAnalyticsCsv(data
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
