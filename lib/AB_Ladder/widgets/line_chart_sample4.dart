import 'dart:async';

import 'package:dozen_diamond/AB_Ladder/models/filtered_historical_data_with_given_interval.dart';
import 'package:dozen_diamond/AB_Ladder/models/ladder_steps_for_plot.dart';
import 'package:dozen_diamond/AB_Ladder/models/stock_historical_data_response.dart';
import 'package:dozen_diamond/AB_Ladder/stateManagement/buy_sell_provider.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Settings/stateManagement/theme_provider.dart';
import '../../global/functions/utils.dart';
import '../functions/graphical_view_functions.dart';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class LineChartSample4 extends StatefulWidget {
  final double currentStockPrice;
  final List<double> ladderLineValuesAboveCp;
  final List<double> ladderLineValuesBelowCp;
  final double firstPurchasePrice;
  final double stepSize;
  final String stockName;
  final int initialBuyQty;
  final int defaultBuySellQty;

  LineChartSample4({
    Key? key,
    required this.currentStockPrice,
    required this.ladderLineValuesAboveCp,
    required this.ladderLineValuesBelowCp,
    required this.stepSize,
    required this.stockName,
    required this.initialBuyQty,
    required this.defaultBuySellQty,
    required this.firstPurchasePrice,
  }) : super(key: key);

  @override
  State<LineChartSample4> createState() => _LineChartSample4State();
}

const _barWidth = 1.0;

class _LineChartSample4State extends State<LineChartSample4> {
  int simulationMinuteInterval = 1;
  int plotMinuteInterval = 15;
  List<double> _plotHistoricalData = [];
  List<FlSpot> flSpotsCurrentStockPrice = [];

  late ThemeProvider themeProvider;
  final List<Color> gradientColors = [
    Colors.greenAccent,
    Colors.transparent,
  ];
  bool _loadingHistoricalData = true;
  bool _symbolDataAvailable = true;
  int currentColorIndex = 0;
  Map<int, String> xAxisLabels = {};

  List<double> _ladderLinesValue = [];
  var _minYValue = 0.0;
  var _maxYValue = 0.0;

  var _minYValueNew = 0.0;
  var _maxYValueNew = 0.0;
  var _newInterval = 0.0;

  final List<Color> _lineColors = [
    Colors.brown,
    Colors.blue,
    Colors.purple,
    Colors.amber,
    Colors.pink,
    Colors.orange,
    Colors.indigo,
    Colors.lime,
    Color(0xFF0099CC),
  ];

  final List<Color> _dotColors = [];
  final List<Color> _strokeColor = [];
  BuySellProvider? _buySellProvider;
  StockHistoricalDataResponse? _stockHistoricalData;
  LineChartData? _lineChartData;

  double _progress = 0.0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _buySellProvider = Provider.of(context, listen: false);

    getHistoricalData();
    _startProgress();
  }

  void _startProgress() {
    const duration = Duration(milliseconds: 100);
    _timer = Timer.periodic(duration, (Timer timer) {
      setState(() {
        if (_progress >= 1) {
          _timer.cancel();
        } else {
          _progress += 0.01;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    _timer.cancel();
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  void getHistoricalData() async {
    try {
      _buySellProvider!.updateBuySellQty = widget.defaultBuySellQty;
      if (kIsWeb) {
        _stockHistoricalData = await _buySellProvider!
            .fetchOneMinuteHistoricalDataForWeb(stockName: widget.stockName);
      } else {
        _stockHistoricalData =
            await _buySellProvider!.getHistoricalDataOfStock(widget.stockName);
      }
      ladderLineValues();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<BuySellProvider>(context, listen: false).updateState();
      });
    } on HttpApiException catch (err) {
      if (err.errorCode == 404 &&
          err.errorTitle == "The symbol name is not found.") {
        _loadingHistoricalData = false;
        _symbolDataAvailable = false;
        _updateState();
      } else {
        print(err);
      }
    }
  }

  LineChartBarData _lineChartBarData(double valueY,
      {bool isCurrentValue = false}) {
    if (currentColorIndex < _lineColors.length - 1) {
      currentColorIndex++;
    } else {
      currentColorIndex = 0;
    }
    return LineChartBarData(
      isCurved: false,
      color: isCurrentValue ? Colors.green : _lineColors[currentColorIndex],
      barWidth: _barWidth,
      dashArray: isCurrentValue ? [6, 6] : null,
      dotData: FlDotData(
        show: false,
      ),
      isStrokeCapRound: true,
      spots: [
        for (var i = 0; i < _plotHistoricalData.length; i++)
          FlSpot(i.toDouble() + 1, valueY)
      ],
    );
  }

  LineChartBarData _lineChartBarDatashowDots(List<FlSpot> dotSpots) {
    if (currentColorIndex < _lineColors.length - 1) {
      currentColorIndex++;
    } else {
      currentColorIndex = 0;
    }
    _dotColors.clear();
    _strokeColor.clear();
    var buyCashGain = 0.0;
    var sellCashGain = 0.0;
    List<double> buySellTradesPriceInSequence = [];
    for (var i = 0; i < flSpotsCurrentStockPrice.length; i++) {
      if (i - 1 >= 0) {
        if (flSpotsCurrentStockPrice[i].y < flSpotsCurrentStockPrice[i - 1].y) {
          buySellTradesPriceInSequence.add(flSpotsCurrentStockPrice[i].y);
          _dotColors.add(Colors.blue);
          print("buy order price ${flSpotsCurrentStockPrice[i].y}");
          _strokeColor.add(Colors.white);
          buyCashGain -= (flSpotsCurrentStockPrice[i].y *
              _buySellProvider!.sharesBoughtSoldPerTrade);
        } else {
          buySellTradesPriceInSequence.add(flSpotsCurrentStockPrice[i].y);
          _dotColors.add(Colors.red);
          print("sell order price ${flSpotsCurrentStockPrice[i].y}");
          _strokeColor.add(Colors.white);
          sellCashGain += (flSpotsCurrentStockPrice[i].y *
              _buySellProvider!.sharesBoughtSoldPerTrade);
        }
      } else {
        buySellTradesPriceInSequence.add(flSpotsCurrentStockPrice[i].y);
        print("initial buy order price ${flSpotsCurrentStockPrice[i].y}");
        buyCashGain -= (flSpotsCurrentStockPrice[i].y *
            _buySellProvider!.sharesBoughtSoldPerTrade);
        _dotColors.add(Colors.blue);
        _strokeColor.add(Colors.white);
      }
    }

    final tradesCashGain = buyCashGain + sellCashGain;
    _buySellProvider!.updateTradesCashGain(tradesCashGain);
    _buySellProvider!.updateFirstBuyingTrade(flSpotsCurrentStockPrice.first.y);
    _buySellProvider!.calculateExtraCashForSimulation(
        buySellTradesPriceInSequence, widget.stepSize);

    int buyQty = _dotColors.where((element) => element == Colors.blue).length;
    int sellQty = _dotColors.where((element) => element == Colors.red).length;
    print("buy $buyQty sell $sellQty total ${_dotColors.length}");
    _buySellProvider!.updateBuySells(buyQty, sellQty);
    int netShareQty =
        (buyQty - sellQty) * _buySellProvider!.sharesBoughtSoldPerTrade;
    _buySellProvider!.updateNetShareQty = netShareQty;

    return LineChartBarData(
      color: Colors.transparent,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(color: _dotColors[index], radius: 5);
          // return FlDotCrossPainter(
          //     color: _dotColors[index], size: index == 0 ? 13 : 9);
        },
      ),
      spots: dotSpots,
    );
  }

  void ladderLineValues() {
    if (_stockHistoricalData != null) {
      _plotHistoricalData.clear();
      xAxisLabels.clear();
      FilteredHistoricalDataWithGivenInterval filteredHistoricalData =
          filterHistoricalDataWithGivenTimeInterval(
              plotMinuteInterval, _stockHistoricalData!);
      _plotHistoricalData = filteredHistoricalData.filteredData;
      xAxisLabels = filteredHistoricalData.xAxisDateLabels;
      _buySellProvider!.updateSimulationDuration(
          filteredHistoricalData.startingHistoricalDate,
          filteredHistoricalData.endingHistoricalDate);
      // for (var i = 0; i < _stockHistoricalData!.totalCount!; i++) {
      //   final temp = (_stockHistoricalData!.data![i].close).toString();
      //   final temp1 = double.parse(temp);
      //   _plotHistoricalData.add(temp1);
      //   xAxisLabels[i + 1] = _stockHistoricalData!.data![i].date!;
      // }

      // final maximumHistoricalValue = _plotHistoricalData.reduce(max);
      // final minimumHistoricalValue = _plotHistoricalData.reduce(min);
      LadderStepsForPlot ladderStepsForPlot = determineHorizontalLadderSteps(
          widget.ladderLineValuesAboveCp,
          widget.ladderLineValuesBelowCp,
          filteredHistoricalData.maxHistoricalValues,
          filteredHistoricalData.minHistoricalValues,
          widget.stepSize);
      // for (var i in widget.ladderLineValuesAboveCp) {
      //   if (i <= maximumHistoricalValue && i >= minimumHistoricalValue) {
      //     _ladderLinesValue.add(i);
      //   }
      // }
      // for (var i in widget.ladderLineValuesBelowCp) {
      //   if (i >= minimumHistoricalValue && i <= maximumHistoricalValue) {
      //     _ladderLinesValue.add(i);
      //   }
      // }
      // final firstLadderValue = _ladderLinesValue.first;
      // final lastLadderValue = _ladderLinesValue.last;
      _ladderLinesValue = ladderStepsForPlot.ladderSteps;

      // if (_ladderLinesValue.length > 7) {
      // // if (false) {
      //   List<double> reduced = [];
      //
      //   int total = _ladderLinesValue.length;
      //   int step = (total - 1) ~/ 6; // 6 gaps → 7 lines
      //
      //   // Always add the first
      //   reduced.add(_ladderLinesValue.first);
      //
      //   // Pick evenly spaced middle values
      //   for (int i = 1; i < 6; i++) {
      //     int index = (i * (total - 1) / 6).round();
      //     reduced.add(_ladderLinesValue[index]);
      //   }
      //
      //   // Always add the last
      //   reduced.add(_ladderLinesValue.last);
      //
      //   _ladderLinesValue = reduced.toSet().toList()..sort();
      // }

      _maxYValue = ladderStepsForPlot.maxYValueForPlot;
      _minYValue = ladderStepsForPlot.minYValueForPlot;
      calculateMaxAndMinYAxis(_ladderLinesValue);
    }
    _lineChartData = mainData();
  }

  void calculateMaxAndMinYAxis(List<double> steps) {
    print("in calculateMaxAndMinYAxis");

    if (steps.length >= 2) {
      _newInterval = (steps[0] - steps[1]).abs();
    } else {
      _newInterval = widget.stepSize;
    }

    double minValue = steps.reduce((a, b) => a < b ? a : b);

    print("below is min new value");
    print(minValue);

    setState(() {
      _minYValueNew = minValue - _newInterval;
    });

    double maxValue = steps.reduce((a, b) => a > b ? a : b);

    print("below is max new value");
    print(maxValue);

    setState(() {
      _maxYValueNew = maxValue + _newInterval;
    });
  }

  LineChartData mainData() {
    List<Map<String, dynamic>> tempList = [];
    for (var i = 0; i < _plotHistoricalData.length; i++) {
      if (i + 1 < _plotHistoricalData.length) {
        if (_plotHistoricalData[i] < widget.currentStockPrice &&
            _plotHistoricalData[i + 1] >= widget.currentStockPrice) {
          tempList.add({
            "x1": i + 1,
            "y1": _plotHistoricalData[i],
            "x2": i + 2,
            "y2": _plotHistoricalData[i + 1],
            "Y": widget.currentStockPrice
          });
        }
        if (_plotHistoricalData[i] > widget.currentStockPrice &&
            _plotHistoricalData[i + 1] <= widget.currentStockPrice) {
          tempList.add({
            "x1": i + 1,
            "y1": _plotHistoricalData[i],
            "x2": i + 2,
            "y2": _plotHistoricalData[i + 1],
            "Y": widget.currentStockPrice
          });
        }
      }
    }
    for (var element in _ladderLinesValue) {
      if (element != widget.currentStockPrice) {
        for (var i = 0; i < _plotHistoricalData.length; i++) {
          if (i + 1 < _plotHistoricalData.length) {
            if (_plotHistoricalData[i] < element &&
                _plotHistoricalData[i + 1] >= element) {
              tempList.add({
                "x1": i + 1,
                "y1": _plotHistoricalData[i],
                "x2": i + 2,
                "y2": _plotHistoricalData[i + 1],
                "Y": element
              });
            }
            if (_plotHistoricalData[i] > element &&
                _plotHistoricalData[i + 1] <= element) {
              tempList.add({
                "x1": i + 1,
                "y1": _plotHistoricalData[i],
                "x2": i + 2,
                "y2": _plotHistoricalData[i + 1],
                "Y": element
              });
            }
          }
        }
      }
    }
    for (var i in tempList) {
      flSpotsCurrentStockPrice.add(
        FlSpot(
            i["x1"] +
                (i["x2"] - i["x1"]) * (i["Y"] - i["y1"]) / (i["y2"] - i["y1"]),
            i["Y"]),
      );
    }
    flSpotsCurrentStockPrice.sort(
      (a, b) => a.x.compareTo(b.x),
    );
    final List<FlSpot> tempFlSpot = [];

    var tempFlSpotsValue = flSpotsCurrentStockPrice.first.y;
    tempFlSpot.add(flSpotsCurrentStockPrice.first);

    for (var i = 0; i < flSpotsCurrentStockPrice.length; i++) {
      if (tempFlSpotsValue != flSpotsCurrentStockPrice[i].y) {
        tempFlSpotsValue = flSpotsCurrentStockPrice[i].y;
        tempFlSpot.add(flSpotsCurrentStockPrice[i]);
      }
    }

    flSpotsCurrentStockPrice = tempFlSpot;

    List<LineChartBarData>? lineChartData = [
      LineChartBarData(
        isCurved: false,
        color: Colors.lightGreenAccent,
        barWidth: _barWidth,
        dotData: FlDotData(show: false),
        isStrokeCapRound: true,
        spots: [
          for (var i = 0; i < _plotHistoricalData.length; i++)
            FlSpot(i.toDouble() + 1, _plotHistoricalData[i])
        ],
      ),
      for (var i = 0; i < _ladderLinesValue.length; i++)
        if (_ladderLinesValue[i] != widget.currentStockPrice) ...[
          _lineChartBarData(_ladderLinesValue[i]),
        ],

      // for (int i = (_ladderLinesValue.length / 7).floor(); i < _ladderLinesValue.length; i += (_ladderLinesValue.length / 7).floor())
      //   if (_ladderLinesValue[i] != widget.currentStockPrice) ...[
      //     _lineChartBarData(_ladderLinesValue[i]),
      //   ],

      _lineChartBarDatashowDots(
        flSpotsCurrentStockPrice,
      ),


    ];

    List<double> executedPrice = [];
    for(int index=0; index<flSpotsCurrentStockPrice.length; index++) {
      executedPrice.add(flSpotsCurrentStockPrice[index].x);
    }

    _buySellProvider?.totalBrokerage = Utility().findBrokeragePerExeOrder(widget.defaultBuySellQty.toDouble() ,executedPrice);
    _buySellProvider?.averageBrokerage = ((_buySellProvider?.totalBrokerage ?? 2) / executedPrice.length);

    _loadingHistoricalData = false;
    _updateState();
    return LineChartData(
      clipData: const FlClipData.all(), // Clips all sides
      minY: _minYValueNew,
      maxY: _maxYValueNew,
      borderData: FlBorderData(
        show: true,
        border: const Border(
          left: BorderSide(width: 1, color: Color(0xff37434d)),
          bottom: BorderSide(width: 1, color: Color(0xff37434d)),
        ),
      ),
      titlesData: FlTitlesData(
        show: true,

        rightTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(sideTitles: bottomTitles),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(

            showTitles: true,
            interval: _newInterval,
            reservedSize: 42.0,
            getTitlesWidget: (value, meta) {
              // if (value == _minYValue || value == _maxYValue) {
              //   return const SizedBox();
              // }
              return leftTile(value.toStringAsFixed(2));
            },
          ),
        ),
      ),
      gridData: FlGridData(
        show: false,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey,
            strokeWidth: 1,
            dashArray: [4, 4],
          );
        },
      ),
      lineBarsData: lineChartData,
      lineTouchData: LineTouchData(
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((index) {
            return TouchedSpotIndicatorData(
              FlLine(
                color: Colors.white.withOpacity(0.1),
                strokeWidth: 2,
                dashArray: [3, 3],
              ),
              FlDotData(
                show: false,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 8,
                  color: [
                    Colors.black,
                    Colors.green,
                  ][index],
                  strokeWidth: 2,
                  strokeColor: Colors.lightGreenAccent,
                ),
              ),
            );
          }).toList();
        },
        // touchTooltipData: LineTouchTooltipData(
        //   tooltipPadding: const EdgeInsets.all(8),
        //   tooltipBgColor: const Color(0xff2e3747).withOpacity(0.8),
        //   getTooltipItems: (touchedSpots) {
        //     return touchedSpots.map((touchedSpot) {
        //       return LineTooltipItem(
        //         '${touchedSpot.y * 100}',
        //         const TextStyle(color: Colors.white, fontSize: 12.0),
        //       );
        //     }).toList();
        //   },
        // ),
        handleBuiltInTouches: false,
      ),
    );
  }

  Widget _titleBuilderWidget(double value, TitleMeta meta) {
    var style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: (themeProvider.defaultTheme)
            ?Colors.black:Colors.white
    );
    if (value == meta.max) {
      return SizedBox();
    }
    return SideTitleWidget(
      // axisSide: meta.axisSide,
      meta: meta,
      child: Column(
        children: [
          Text(
            DateFormat('dd-MM').format(
              DateTime.parse(
                xAxisLabels[value.toInt()].toString(),
              ),
            ),
            style: style,
          ),
          Text(
            DateFormat.y().format(
              DateTime.parse(
                xAxisLabels[value.toInt()].toString(),
              ),
            ),
            style: style,
          ),
        ],
      ),
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        getTitlesWidget: _titleBuilderWidget,
        reservedSize: 40.0,
      );

  Widget leftTile(String titleText) => Text(
        titleText,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: (themeProvider.defaultTheme)
              ?Colors.black:Colors.white,
        ),
      );

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    return _loadingHistoricalData
        ? Center(
            child: progressBar(context),
            // child: CircularProgressIndicator(),
          )
        : !_symbolDataAvailable
            ? Center(
                child: Text(
                  "We're sorry, but the historical data for ${widget.stockName} is currently unavailable.",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              )
            : ClipRect(
                child: SizedBox(
                  width: 500,
                  height: 200,
                  child: LineChart(
                    _lineChartData!,
                  ),
                ),
            );
  }

  Widget progressBar(BuildContext context) {
    return Center(
      child: (int.parse(((10 - (_progress * 10)).toStringAsFixed(0))) < 1)?Text(
        'Loading...',
        style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xfff0f0f0)
        ),
        // style: TextStyle(fontSize: 20),
      ):Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          CircularProgressIndicator(
            value: (_progress * 10) / 10, // Progress value (0.0 to 1.0)
            strokeWidth: 4,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
          ),

          SizedBox(
            height: 5,
          ),

          Text(
            'Graph will Appear in ${(10 - (_progress * 10)).toStringAsFixed(0)}s',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xfff0f0f0)
            ),
            // style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          // LinearProgressIndicator(value: _progress),
        ],
      ),
    );
  }
}
