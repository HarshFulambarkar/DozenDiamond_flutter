/*
Author: Saif Rahman
Date: 20/05/2025 
*/

import 'dart:math';

import 'package:dozen_diamond/AB_Ladder/models/filtered_historical_data_with_given_interval.dart';
import 'package:dozen_diamond/AB_Ladder/models/ladder_steps_for_plot.dart';
import 'package:dozen_diamond/AB_Ladder/models/stock_historical_data_request.dart';
import 'package:dozen_diamond/AB_Ladder/models/stock_historical_data_response.dart';
import 'package:dozen_diamond/past_data_graphical_view/services/past_data_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// get the lines data of the above and below using the current Price and the step size
// fetch the data from the api
// store the fetched api in the provider

class PastDataProvider extends ChangeNotifier {
  double _extraCashInSimulation = 0.0;
  List<FlSpot> _flSpotsCurrentStockPrice = [];
  List<double> _plotHistoricalData = [];
  List<double> _ladderLinesValueAboveCP = [];
  List<double> _ladderLinesValueBelowCP = [];
  double stepSize = 20.0;
  double initialBuyPrice = 4000;
  double noOfStepsAbove = 40.5;
  int noOfStepsBelow = 40;
  int defaultBuySellQty = 40;
  int numberOfStepsAbove = 40;

  double minimumPrice = 0;
  double targetPrice = 8000;

  int initialBuyQty = 10;

  final List<String> _stoocksBoughtSoldQtyAboveCp = [];
  final List<String> _stoocksBoughtSoldQtyBelowCp = [];
  final List<int> _stocksHeldAboveCP = [];
  final List<int> _stocksHeldBelowCP = [];

  void ladderLinesValue() {
    print(noOfStepsAbove);
    _ladderLinesValueAboveCP.add(initialBuyPrice.toDouble());
    var tempSum = initialBuyPrice + stepSize;
    _ladderLinesValueAboveCP.insert(0, tempSum.toDouble());
    for (var i = 1; i < noOfStepsAbove; i++) {
      print(i);

      if (i == noOfStepsAbove - 1) {
        print(stepSize);

        tempSum += stepSize;

        _ladderLinesValueAboveCP.insert(0, tempSum.toDouble());

        tempSum = tempSum + ((numberOfStepsAbove - noOfStepsAbove) * stepSize);

        _ladderLinesValueAboveCP.insert(0, targetPrice.toDouble());
      } else {
        tempSum += stepSize;
        _ladderLinesValueAboveCP.insert(0, tempSum.toDouble());
      }
    }
    var tempSum1 = initialBuyPrice - stepSize;
    _ladderLinesValueBelowCP.add(tempSum1.toDouble());
    for (var i = 1; i < noOfStepsBelow; i++) {
      tempSum1 -= stepSize;
      if (tempSum1 > 0) {
        if (tempSum1 >= minimumPrice) {
          _ladderLinesValueBelowCP.add(tempSum1.toDouble());
        }
      }
    }
    _stocksHeldAboveCP.add(initialBuyQty.toInt());
    var tempSum2 = initialBuyQty.toInt() - defaultBuySellQty;

    _stocksHeldAboveCP.insert(0, tempSum2);
    for (var i = 1; i < noOfStepsAbove; i++) {
      if (i == noOfStepsAbove - 1) {
        tempSum2 -= defaultBuySellQty;
        _stocksHeldAboveCP.insert(0, tempSum2);

        tempSum2 = tempSum2 - (initialBuyQty + tempSum2);
        _stocksHeldAboveCP.insert(0, tempSum2);
      } else {
        tempSum2 -= defaultBuySellQty;
        _stocksHeldAboveCP.insert(0, tempSum2);
      }
    }
    var tempSum3 = initialBuyQty.toInt() + defaultBuySellQty;
    _stocksHeldBelowCP.add(tempSum3);
    for (var i = 1; i < noOfStepsBelow; i++) {
      tempSum3 += defaultBuySellQty;
      _stocksHeldBelowCP.add(tempSum3);
    }

    for (var i = 0; i < _ladderLinesValueAboveCP.length; i++) {
      _stoocksBoughtSoldQtyAboveCp.add(defaultBuySellQty.toString());
    }
    for (var i = 0; i < _ladderLinesValueBelowCP.length; i++) {
      _stoocksBoughtSoldQtyBelowCp.add(defaultBuySellQty.toString());
    }
    if (_stocksHeldAboveCP.first < 0) {
      final tempSb = _stocksHeldAboveCP[1].toString();
      _stocksHeldAboveCP.replaceRange(0, 1, [0]);
      _stoocksBoughtSoldQtyAboveCp.replaceRange(0, 1, [tempSb]);
    } else if ((_stocksHeldAboveCP.first != 0 &&
        _stocksHeldAboveCP.first <
            double.parse(_stoocksBoughtSoldQtyAboveCp.first))) {
      _stocksHeldAboveCP.first = 0;
      _stoocksBoughtSoldQtyAboveCp.first = _stocksHeldAboveCP[1].toString();
    }
    final lastLLV = _ladderLinesValueBelowCP.last;
    final result = lastLLV - minimumPrice;
    final halfStepSize = stepSize / 2;
    if (result >= halfStepSize) {
      final tempLastShbcp = _stocksHeldBelowCP.last;
      _stocksHeldBelowCP.add(tempLastShbcp + defaultBuySellQty);
      _stoocksBoughtSoldQtyBelowCp.add(defaultBuySellQty.toString());
      _ladderLinesValueBelowCP.add(minimumPrice);
    }
  }

  int calculateMonthsPassed(DateTime fromDate, DateTime toDate) {
    int yearsDifference = toDate.year - fromDate.year;
    int monthsDifference = toDate.month - fromDate.month;
    return yearsDifference * 12 + monthsDifference;
  }

  double calculateCashNeededForCurrentPrice(
      double initialBuyPrice, double stepSize) {
    double numberOfStepsBelow = initialBuyPrice / stepSize;
    double averagePurchasePrice = initialBuyPrice / 2;
    int buySellQty = initialBuyQty;
    double cashNeeded = numberOfStepsBelow * averagePurchasePrice * buySellQty;
    return cashNeeded;
  }

  void calculateExtraCashForSimulation(
      List<double> buySellTradesInSequence, double stepsize) {
    _extraCashInSimulation = 0;
    double cashLeft = calculateCashNeededForCurrentPrice(
        buySellTradesInSequence[0] + stepsize, stepsize);
    for (int i = 0; i < buySellTradesInSequence.length; i++) {
      bool isThisTradeBuy = i == 0
          ? true
          : (buySellTradesInSequence[i - 1] > buySellTradesInSequence[i]
              ? true
              : false);
      if (isThisTradeBuy) {
        cashLeft -= buySellTradesInSequence[i] * initialBuyQty;
        double cashNeeded = calculateCashNeededForCurrentPrice(
            buySellTradesInSequence[i], stepsize);
        // double extraCashForOrder =
        //     (cashLeft - cashNeeded) - _extraCashInSimulation;
        _extraCashInSimulation = cashLeft - cashNeeded;
      } else {
        cashLeft += buySellTradesInSequence[i] * initialBuyQty;
        double cashNeeded = calculateCashNeededForCurrentPrice(
            buySellTradesInSequence[i], stepsize);
        // double extraCashForOrder =
        //     (cashLeft - cashNeeded) - _extraCashInSimulation;
        _extraCashInSimulation = cashLeft - cashNeeded;
      }
    }
  }

  void _lineChartBarDatashowDots(List<FlSpot> dotSpots) {
    List<double> buySellTradesPriceInSequence = [];
    for (var i = 0; i < _flSpotsCurrentStockPrice.length; i++) {
      buySellTradesPriceInSequence.add(_flSpotsCurrentStockPrice[i].y);
    }
    calculateExtraCashForSimulation(buySellTradesPriceInSequence, stepSize);
  }

  StockHistoricalDataResponse? _stockHistoricalData;
  int plotMinuteInterval = 15;
  LadderStepsForPlot determineHorizontalLadderSteps(
    List<double> stepsAboveInitialBuy,
    List<double> stepsBelowInitialBuy,
    double maxHistoricalValue,
    double minHistoricalValue,
    double stepSize) {
  
  print("inside determineHorizontalLadderSteps ${maxHistoricalValue} and ${minHistoricalValue}");
  
  // 🔥 Add null safety checks
  if (stepsAboveInitialBuy.isEmpty && stepsBelowInitialBuy.isEmpty) {
    print("WARNING: Both step lists are empty!");
    return LadderStepsForPlot([], maxHistoricalValue, minHistoricalValue);
  }
  
  if (stepsAboveInitialBuy.isNotEmpty) {
    print("here is the stepsAboveInitialBuy ${stepsAboveInitialBuy[0]}");
  }
  print("here is the stepsBelowInitialBuy ${stepsBelowInitialBuy.length}");
  
  List<double> ladderStepsToBeIncluded = [];

  // Add steps above initial buy that fall within historical range
  for (var i in stepsAboveInitialBuy) {
    if (i <= maxHistoricalValue && i >= minHistoricalValue) {
      ladderStepsToBeIncluded.add(i);
    }
  }
  
  // Add steps below initial buy that fall within historical range
  for (var i in stepsBelowInitialBuy) {
    if (i >= minHistoricalValue && i <= maxHistoricalValue) {
      ladderStepsToBeIncluded.add(i);
    }
  }

  print("i am checking below");
  print(stepsBelowInitialBuy);
  print(minHistoricalValue);
  print(maxHistoricalValue);
  print("ladderStepsToBeIncluded length: ${ladderStepsToBeIncluded.length}");

  // 🔥 CRITICAL FIX: Check if list is empty before accessing first/last
  if (ladderStepsToBeIncluded.isEmpty) {
    print("WARNING: No ladder steps fall within historical range!");
    print("Steps above: $stepsAboveInitialBuy");
    print("Steps below: $stepsBelowInitialBuy");
    print("Historical range: $minHistoricalValue to $maxHistoricalValue");
    
    // Return with fallback values
    return LadderStepsForPlot([], maxHistoricalValue, minHistoricalValue);
  }

  // ✅ Now safe to access first and last
  final firstLadderValue = ladderStepsToBeIncluded.first;
  final lastLadderValue = ladderStepsToBeIncluded.last;

  double maxYValueForPlot =
      firstLadderValue + (stepSize / 2) < maxHistoricalValue
          ? maxHistoricalValue
          : firstLadderValue + (stepSize / 2);
  double minYValueForPlot =
      lastLadderValue - (stepSize / 2) > minHistoricalValue
          ? minHistoricalValue
          : lastLadderValue - (stepSize / 2);

  return LadderStepsForPlot(
      ladderStepsToBeIncluded, maxYValueForPlot, minYValueForPlot);
}

  FilteredHistoricalDataWithGivenInterval
      filterHistoricalDataWithGivenTimeInterval(int minuteInterval,
          StockHistoricalDataResponse unfilteredHistoricalData) {
    int dateLabelIndex = 1;
    String startingHistoricalDate = "";
    String endingHistoricalDate = "";
    Map<int, String> dateLabels = Map();
    List<double> filteredHistoricalData = [];
    print(
        "data is coming and the length is ${unfilteredHistoricalData.data?.length ?? 31}");
    for (var i = 0; i < unfilteredHistoricalData.totalCount!; i++) {
      if (i % minuteInterval == 0) {
        final closePriceString =
            (unfilteredHistoricalData.data![i].close).toString();
        final closePrice = double.parse(closePriceString);
        filteredHistoricalData.add(closePrice);
        dateLabels[dateLabelIndex] = unfilteredHistoricalData.data![i].date!;
        dateLabelIndex++;
      }
    }

    final maximumHistoricalValue = filteredHistoricalData.reduce(max);
    final minimumHistoricalValue = filteredHistoricalData.reduce(min);

    startingHistoricalDate = dateLabels[1] ?? "";
    endingHistoricalDate = dateLabels[dateLabelIndex - 1] ?? "";

    return FilteredHistoricalDataWithGivenInterval(
        filteredHistoricalData,
        maximumHistoricalValue,
        minimumHistoricalValue,
        dateLabels,
        startingHistoricalDate,
        endingHistoricalDate);
  }

  void mainData() {
    print("Here is the mainData function"); // check if this is printed
    print("Checking _stockHistoricalData: $_stockHistoricalData");
    FilteredHistoricalDataWithGivenInterval filteredHistoricalData =
        filterHistoricalDataWithGivenTimeInterval(
            plotMinuteInterval, _stockHistoricalData!);
    print("here is the filteredHistoricalData ${filteredHistoricalData}");
    LadderStepsForPlot ladderStepsForPlot = determineHorizontalLadderSteps(
        _ladderLinesValueAboveCP,
        _ladderLinesValueBelowCP,
        filteredHistoricalData.maxHistoricalValues,
        filteredHistoricalData.minHistoricalValues,
        stepSize);

    _plotHistoricalData = filteredHistoricalData.filteredData;

    List<Map<String, dynamic>> tempList = [];

    for (var i = 0; i < _plotHistoricalData.length; i++) {
      if (i + 1 < _plotHistoricalData.length) {
        if (_plotHistoricalData[i] < initialBuyPrice &&
            _plotHistoricalData[i + 1] >= initialBuyPrice) {
          tempList.add({
            "x1": i + 1,
            "y1": _plotHistoricalData[i],
            "x2": i + 2,
            "y2": _plotHistoricalData[i + 1],
            "Y": initialBuyPrice
          });
        }
        if (_plotHistoricalData[i] > initialBuyPrice &&
            _plotHistoricalData[i + 1] <= initialBuyPrice) {
          tempList.add({
            "x1": i + 1,
            "y1": _plotHistoricalData[i],
            "x2": i + 2,
            "y2": _plotHistoricalData[i + 1],
            "Y": initialBuyPrice
          });
        }
      }
    }
    List<double> ladderLinesValue = ladderStepsForPlot.ladderSteps;

    for (var element in ladderLinesValue) {
      if (element != initialBuyPrice) {
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
      _flSpotsCurrentStockPrice.add(
        FlSpot(
            i["x1"] +
                (i["x2"] - i["x1"]) * (i["Y"] - i["y1"]) / (i["y2"] - i["y1"]),
            i["Y"]),
      );
    }
    _flSpotsCurrentStockPrice.sort(
      (a, b) => a.x.compareTo(b.x),
    );
    final List<FlSpot> tempFlSpot = [];

    var tempFlSpotsValue = _flSpotsCurrentStockPrice.first.y;
    tempFlSpot.add(_flSpotsCurrentStockPrice.first);

    for (var i = 0; i < _flSpotsCurrentStockPrice.length; i++) {
      if (tempFlSpotsValue != _flSpotsCurrentStockPrice[i].y) {
        tempFlSpotsValue = _flSpotsCurrentStockPrice[i].y;
        tempFlSpot.add(_flSpotsCurrentStockPrice[i]);
      }
    }

    _flSpotsCurrentStockPrice = tempFlSpot;
    _lineChartBarDatashowDots(
      _flSpotsCurrentStockPrice,
    );
  }

  int calculateMonthsBetween(DateTime startDate, DateTime endDate) {
    int yearDiff = endDate.year - startDate.year;
    int monthDiff = endDate.month - startDate.month;
    int totalMonths = yearDiff * 12 + monthDiff;

    // Adjust if end day is before the start day in the month
    if (endDate.day < startDate.day) {
      totalMonths -= 1;
    }

    return totalMonths;
  }

  Future<double> processExtraCashFromPastData(
      {required String stockName}) async {
    String exchange = "NSE";
    int monthsFromJan2023 =
        calculateMonthsPassed(DateTime(2023, 6, 1), DateTime.now());
    print("here is the months ${monthsFromJan2023}");
    StockHistoricalDataResponse? historicalData =
        await PastDataGraphicalViewService().getStockHistoricalData(
            StockHistoricalDataRequest(
                symbolName: stockName,
                exchange: exchange,
                monthframe: monthsFromJan2023));
    if (historicalData == null) {
      return -1;
    }
    _stockHistoricalData = historicalData;
    DateTime? startDate = _stockHistoricalData?.data?.isNotEmpty == true
        ? DateTime.tryParse(_stockHistoricalData!.data![0].date ?? "")
        : null;

    int lengthOfData = _stockHistoricalData?.data?.length ?? 0;

    DateTime? lastDate = lengthOfData > 0
        ? DateTime.tryParse(
            _stockHistoricalData!.data![lengthOfData - 1].date ?? "")
        : null;

    mainData();
    if (startDate != null && lastDate != null) {
      int noOfMonths = calculateMonthsBetween(startDate, lastDate);
      return _extraCashInSimulation / noOfMonths;
    }
    return 0.0;
  }
}

Future<double> getExtraCashPerMonthOfAStock(
    {required String stockName,
    required double initialBuyPrice,
    required double targetPrice,
    required double noOfStepsAbove,
    required int noOfStepsBelow,
    required int defaultBuySellQty,
    required double stepSize,
    required int initialBuyQty}) async {
  PastDataProvider pastDataProvider = PastDataProvider();
  pastDataProvider.initialBuyPrice = initialBuyPrice;
  pastDataProvider.targetPrice = targetPrice;
  pastDataProvider.minimumPrice = 0.0;
  pastDataProvider.noOfStepsAbove = noOfStepsAbove;
  pastDataProvider.noOfStepsBelow = noOfStepsBelow;
  pastDataProvider.defaultBuySellQty = defaultBuySellQty;
  pastDataProvider.stepSize = stepSize;
  pastDataProvider.initialBuyQty = initialBuyQty;
  pastDataProvider.ladderLinesValue();
  print(
      "here is the value from the function ${stockName} and ${initialBuyPrice}");
  double? extraCash =
      await pastDataProvider.processExtraCashFromPastData(stockName: stockName);

  double extraCashPerMonth = extraCash / 6;
  if (extraCashPerMonth <= 0) {
    return 0;
  } else {
    return extraCashPerMonth;
  }
}

void main() async {
  double extraCash = await getExtraCashPerMonthOfAStock(
      stockName: "ETERNAL",
      initialBuyPrice: 1560.40,
      targetPrice: 3120.80,
      noOfStepsAbove: 42.8,
      noOfStepsBelow: 42,
      defaultBuySellQty: 5,
      stepSize: 36.46,
      initialBuyQty: 214);
  print("here is the extraCash:  ${extraCash == 0 ? "NA" : extraCash}");
}
