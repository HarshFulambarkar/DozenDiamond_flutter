import 'dart:math';

import 'package:dozen_diamond/AB_Ladder/models/filtered_historical_data_with_given_interval.dart';
import 'package:dozen_diamond/AB_Ladder/models/ladder_steps_for_plot.dart';
import 'package:dozen_diamond/AB_Ladder/models/stock_historical_data_response.dart';

FilteredHistoricalDataWithGivenInterval
    filterHistoricalDataWithGivenTimeInterval(int minuteInterval,
        StockHistoricalDataResponse unfilteredHistoricalData) {
  int dateLabelIndex = 1;
  String startingHistoricalDate = "";
  String endingHistoricalDate = "";
  Map<int, String> dateLabels = Map();
  List<double> filteredHistoricalData = [];
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

LadderStepsForPlot determineHorizontalLadderSteps(
    List<double> stepsAboveInitialBuy,
    List<double> stepsBelowInitialBuy,
    double maxHistoricalValue,
    double minHistoricalValue,
    double stepSize) {
  print(
      "inside determineHorizontalLadderSteps ${maxHistoricalValue} and ${minHistoricalValue}");
  print("here is the stepsAboveInitialBuy ${stepsAboveInitialBuy[0]}");
  print("here is the stepsBelowInitialBuy ${stepsBelowInitialBuy.length}");
  List<double> ladderStepsToBeIncluded = [];

  for (var i in stepsAboveInitialBuy) {
    if (i <= maxHistoricalValue && i >= minHistoricalValue) {
      if (stepsAboveInitialBuy.length > 100) {
        // if (skipperA == (stepsAboveInitialBuy.length / 100).floor()) {
        //   skipperA = 0;
        ladderStepsToBeIncluded.add(i);
        // } else {
        //   skipperA++;
        // }
      } else {
        ladderStepsToBeIncluded.add(i);
      }
    }
  }
  for (var i in stepsBelowInitialBuy) {
    if (i >= minHistoricalValue && i <= maxHistoricalValue) {
      print("the length of stepsBelow is ${stepsBelowInitialBuy.length}");
      if (stepsBelowInitialBuy.length > 100) {
        // if (skipperB == (stepsAboveInitialBuy.length / 100).floor()) {
        //   skipperB = 0;
        //   print("here is the stepsAboveInitialBuy  w- in if ${i}");
        ladderStepsToBeIncluded.add(i);
        // } else {
        //   skipperB++;
        // }
      } else {
        print("here is the stepsAboveInitialBuy  w- in else ${i}");
        ladderStepsToBeIncluded.add(i);
      }
      // ladderStepsToBeIncluded.add(i);
    }
  }

  print("i am checking below");
  print(stepsBelowInitialBuy);
  print(minHistoricalValue);
  print(maxHistoricalValue);

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

void determinePointsBeforeAndAfterIntersectingCurrentPrice(
    List<double> filteredHistoricalData, double currentPrice) {
  List<Map<String, dynamic>> pointsBeforeAndAfterIntersection = [];
  for (var i = 0; i < filteredHistoricalData.length; i++) {
    if (i + 1 < filteredHistoricalData.length) {
      if (filteredHistoricalData[i] < currentPrice &&
          filteredHistoricalData[i + 1] >= currentPrice) {
        pointsBeforeAndAfterIntersection.add({
          "x1": i + 1,
          "y1": filteredHistoricalData[i],
          "x2": i + 2,
          "y2": filteredHistoricalData[i + 1],
          "Y": currentPrice
        });
      }
      if (filteredHistoricalData[i] > currentPrice &&
          filteredHistoricalData[i + 1] <= currentPrice) {
        pointsBeforeAndAfterIntersection.add({
          "x1": i + 1,
          "y1": filteredHistoricalData[i],
          "x2": i + 2,
          "y2": filteredHistoricalData[i + 1],
          "Y": currentPrice
        });
      }
    }
  }
}

void determinePointsBeforeAndAfterIntersectingLadderSteps(
    List<double> ladderSteps,
    List<double> filteredHistoricalData,
    double currentPrice) {
  List<Map<String, dynamic>> pointsBeforeAndAfterIntersection = [];
  for (var element in ladderSteps) {
    if (element != currentPrice) {
      for (var i = 0; i < filteredHistoricalData.length; i++) {
        if (i + 1 < filteredHistoricalData.length) {
          if (filteredHistoricalData[i] < element &&
              filteredHistoricalData[i + 1] >= element) {
            pointsBeforeAndAfterIntersection.add({
              "x1": i + 1,
              "y1": filteredHistoricalData[i],
              "x2": i + 2,
              "y2": filteredHistoricalData[i + 1],
              "Y": element
            });
          }
          if (filteredHistoricalData[i] > element &&
              filteredHistoricalData[i + 1] <= element) {
            pointsBeforeAndAfterIntersection.add({
              "x1": i + 1,
              "y1": filteredHistoricalData[i],
              "x2": i + 2,
              "y2": filteredHistoricalData[i + 1],
              "Y": element
            });
          }
        }
      }
    }
  }
}

String calculateDuration(String startDate, String endDate) {
  try {
    // Parse the input date strings into DateTime objects
    print("start $startDate end $endDate");
    DateTime start = DateTime.parse(startDate);
    DateTime end = DateTime.parse(endDate);

    // Calculate the difference in years, months, and days
    int years = end.year - start.year;
    int months = end.month - start.month;
    int days = end.day - start.day;

    // Adjust the calculation if the months or days difference is negative
    if (days < 0) {
      months -= 1;
      DateTime prevMonthEnd =
          DateTime(end.year, end.month, 0); // Last day of the previous month
      days += prevMonthEnd.day;
    }

    if (months < 0) {
      years -= 1;
      months += 12;
    }

    // Build the result string
    String result = '';
    if (years > 0) {
      result += '$years ${years == 1 ? 'year' : 'years'}';
    }
    if (months > 0) {
      if (result.isNotEmpty) result += ' and ';
      result += '$months ${months == 1 ? 'month' : 'months'}';
    }

    // Only include days if there are no months or years
    if (years == 0 && months == 0 && days > 0) {
      result = '$days ${days == 1 ? 'day' : 'days'}';
    }

    return result.isEmpty ? '0 days' : result;
  } catch (err) {
    throw err;
  }
}
