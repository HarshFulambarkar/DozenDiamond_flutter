import 'package:dozen_diamond/AB_Ladder/functions/graphical_view_functions.dart';
import 'package:dozen_diamond/AB_Ladder/models/stock_historical_data_request.dart';
import 'package:dozen_diamond/AB_Ladder/models/stock_historical_data_response.dart';
import 'package:dozen_diamond/AB_Ladder/services/ladder_rest_api_service.dart';
import 'package:flutter/material.dart';

import '../models/filtered_historical_data_with_given_interval.dart';
import '../models/ladder_steps_for_plot.dart';

class BuySellProvider with ChangeNotifier {
  int _sharesBoughtSoldPerTrade = 10;
  int _buyInSimulation = 0;
  int _sellInSimulation = 0;
  int _netShareQty = 0;
  double _simulationTradesCashGain = 0.0;
  double _extraCashInSimulation = 0.0;
  double firstBuyingTrade = 0.0;
  String _simulationDuration = "";
  Map<String, StockHistoricalDataResponse?> _stocksHistoricalOneMinuteData =
      Map();

  int get sharesBoughtSoldPerTrade => _sharesBoughtSoldPerTrade;
  int get buyInSimulation => _buyInSimulation;
  int get sellInSimulation => _sellInSimulation;
  double get simulationTradesCashGain => _simulationTradesCashGain;
  double get extraCashInSimulation => _extraCashInSimulation;
  int get netShareQty => _netShareQty;
  String get simulationDuration => _simulationDuration;

  double _totalBrokerage = 2.0;

  double get totalBrokerage => _totalBrokerage;

  set totalBrokerage(double value) {
    _totalBrokerage = value;
    notifyListeners();
  }

  double _averageBrokerage = 2.0;

  double get averageBrokerage => _averageBrokerage;

  set averageBrokerage(double value) {
    _averageBrokerage = value;
    notifyListeners();
  }

  void resetAllVariable() {
    _buyInSimulation = 0;
    _sellInSimulation = 0;
    _netShareQty = 0;
    _simulationTradesCashGain = 0.0;
    _extraCashInSimulation = 0.0;
    firstBuyingTrade = 0.0;
    _simulationDuration = "";
  }

  void updateBuySells(int buyQty, int sellQty) {
    _buyInSimulation = buyQty;
    _sellInSimulation = sellQty;
  }

  set updateNetShareQty(int qty) {
    if (_buyInSimulation >= _sellInSimulation) {
      _netShareQty = qty;
    } else {
      _netShareQty = (-qty);
    }
  }

  void updateTradesCashGain(double cashGain) {
    _simulationTradesCashGain = cashGain;
  }

  void updateFirstBuyingTrade(double fBT) {
    firstBuyingTrade = fBT;
  }

  set updateBuySellQty(int qty) {
    _sharesBoughtSoldPerTrade = qty;
  }

  void updateState() {
    notifyListeners();
  }

  void updateSimulationDuration(String startDate, String endDate) {
    try {
      _simulationDuration = calculateDuration(startDate, endDate);
    } catch (err) {
      _simulationDuration = "N/A";
    }
  }

  double calculateCashNeededForCurrentPrice(
      double initialBuyPrice, double stepSize) {
    double numberOfStepsBelow = initialBuyPrice / stepSize;
    double averagePurchasePrice = initialBuyPrice / 2;
    int buySellQty = _sharesBoughtSoldPerTrade;
    // Cash needed equals Cash left for initial trade
    double cashNeeded = numberOfStepsBelow * averagePurchasePrice * buySellQty;
    return cashNeeded;
  }

  void calculateExtraCashForSimulation(
      List<double> buySellTradesInSequence, double stepsize) {
    _extraCashInSimulation = 0;
    // Cash needed equals Cash left for initial trade
    double cashLeft = calculateCashNeededForCurrentPrice(
        buySellTradesInSequence[0] + stepsize, stepsize);
    for (int i = 0; i < buySellTradesInSequence.length; i++) {
      // Assuming first trade will always be buy
      bool isThisTradeBuy = i == 0
          ? true
          : (buySellTradesInSequence[i - 1] > buySellTradesInSequence[i]
              ? true
              : false);
      if (isThisTradeBuy) {
        cashLeft -= buySellTradesInSequence[i] * _sharesBoughtSoldPerTrade;
        double cashNeeded = calculateCashNeededForCurrentPrice(
            buySellTradesInSequence[i], stepsize);
        double extraCashForOrder =
            (cashLeft - cashNeeded) - _extraCashInSimulation;
        _extraCashInSimulation = cashLeft - cashNeeded;
      } else {
        cashLeft += buySellTradesInSequence[i] * _sharesBoughtSoldPerTrade;
        double cashNeeded = calculateCashNeededForCurrentPrice(
            buySellTradesInSequence[i], stepsize);
        double extraCashForOrder =
            (cashLeft - cashNeeded) - _extraCashInSimulation;
        _extraCashInSimulation = cashLeft - cashNeeded;
      }
    }
  }

  Future<StockHistoricalDataResponse?> getHistoricalDataOfStock(
      String stockName,
      {bool checkHistorical = false}) async {
    try {
      if (_stocksHistoricalOneMinuteData.containsKey(stockName)) {
        return _stocksHistoricalOneMinuteData[stockName];
      } else {
        await fetchOneMinuteHistoricalData(
            stockName: stockName, checkHistorical: checkHistorical);
        return getHistoricalDataOfStock(stockName);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<StockHistoricalDataResponse?> checkHistoricalDataOfStock(
      String stockName) async {
    try {
      if (_stocksHistoricalOneMinuteData.containsKey(stockName)) {
        return _stocksHistoricalOneMinuteData[stockName];
      } else {
        await fetchOneMinuteHistoricalData(stockName: stockName);
        return getHistoricalDataOfStock(stockName);
      }
    } catch (e) {
      throw e;
    }
  }

  int calculateMonthsPassed(DateTime fromDate, DateTime toDate) {
    int yearsDifference = toDate.year - fromDate.year;
    int monthsDifference = toDate.month - fromDate.month;
    return yearsDifference * 12 + monthsDifference;
  }

  void clearHistoricalData() {
    _stocksHistoricalOneMinuteData.clear();
  }

  Future<void> fetchOneMinuteHistoricalData(
      {required String stockName, bool checkHistorical = false}) async {
    try {
      String exchange = "NSE";
      int monthsFromJan2023 =
          calculateMonthsPassed(DateTime(2023, 6, 1), DateTime.now());
      StockHistoricalDataResponse? historicalData;
      if (checkHistorical) {
        historicalData = await LadderRestApiService().checkStockHistoricalData(
            StockHistoricalDataRequest(
                symbolName: stockName,
                exchange: exchange,
                monthframe: monthsFromJan2023));
      } else {
        historicalData = await LadderRestApiService().getStockHistoricalData(
            StockHistoricalDataRequest(
                symbolName: stockName,
                exchange: exchange,
                monthframe: monthsFromJan2023));
      }
      _stocksHistoricalOneMinuteData[stockName] = historicalData;
    } catch (e) {
      throw e;
    }
  }

  Future<StockHistoricalDataResponse?> fetchOneMinuteHistoricalDataForWeb(
      {required String stockName}) async {
    try {
      String exchange = "NSE";
      int monthsFromJan2023 =
          calculateMonthsPassed(DateTime(2023, 6, 1), DateTime.now());
      StockHistoricalDataResponse? historicalData = await LadderRestApiService()
          .getStockHistoricalData(StockHistoricalDataRequest(
              symbolName: stockName,
              exchange: exchange,
              monthframe: monthsFromJan2023));

      return historicalData;
    } catch (e) {
      throw e;
    }
  }
}
