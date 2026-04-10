import 'package:dozen_diamond/ZH_analysisPriceVsNumberOfStocks/models/analyticsRequest.dart';
import 'package:dozen_diamond/ZH_analysisPriceVsNumberOfStocks/models/closedOrderPriceAndUnits.dart';
import 'package:dozen_diamond/ZH_analysisPriceVsNumberOfStocks/models/plotGraphData.dart';
import 'package:dozen_diamond/ZH_analysisPriceVsNumberOfStocks/models/priceVsValueVsNOSRequest.dart';
import 'package:dozen_diamond/ZH_analysisPriceVsNumberOfStocks/services/priceVsValueVsNOSService.dart';
import 'package:flutter/material.dart';

import '../models/ExtraCashVsPriceDataResponse.dart';

class DateTimeProvider extends ChangeNotifier {
  DateTime? _endDateTime;
  DateTime? _startDateTime;

  PlotGraphData? _graphData;

  ClosedOrderPriceAndUnitsResponse? _closedOrderPriceAndUnitsResponse;

  TextEditingController _startDateTimeController = TextEditingController();
  TextEditingController _endDateTimeController = TextEditingController();

  get startDateTimeController => _startDateTimeController;
  get endDateTimeController => _endDateTimeController;

  get endFullDate => _endDateTime;
  get startFullDate => _startDateTime;

  get endDate => _endDateTime?.day;
  get startDate => _startDateTime?.day;

  get endDateMonth => _endDateTime?.month;
  get startDateMonth => _startDateTime?.month;

  get endDateYear => _endDateTime?.year;
  get startDateYear => _startDateTime?.year;

  get closedOrderPriceAndUnitsResponse => _closedOrderPriceAndUnitsResponse;

  get graphData => _graphData;

  set endDateTime(DateTime dateTime) {
    _endDateTime = dateTime;
    notifyListeners();
  }

  set startDateTime(DateTime dateTime) {
    _startDateTime = dateTime;
    notifyListeners();
  }

  ExtraCashVsPriceDataResponse _extraCashGraphData =
      ExtraCashVsPriceDataResponse();

  ExtraCashVsPriceDataResponse get extraCashGraphData => _extraCashGraphData;

  set extraCashGraphData(ExtraCashVsPriceDataResponse value) {
    _extraCashGraphData = value;
    notifyListeners();
  }

  Future<void> getExtraGraphData(AnalyticsRequest analyticsRequest) async {
    extraCashGraphData = await PriceVsValueVsNoOfStocks()
        .extraCashVsPriceOfStocks(analyticsRequest);

    print("below is extra cash graph data");
    print(extraCashGraphData.data!.isEmpty);
  }

  void setStartAndEndDateTime(DateTime dateTime, {isStartDate = false}) {
    if (isStartDate) {
      startDateTime = dateTime;
    } else {
      endDateTime = dateTime;
    }
    notifyListeners();
  }

  Future<void> getGraphData(selectedStock) async {
    try {
      _closedOrderPriceAndUnitsResponse = await PriceVsValueVsNoOfStocks()
          .priceVsValueVsNumberOfStocks(PriceVsValueVsNoOfStocksRequest(
              startDate: "$startDateYear-$startDateMonth-$startDate",
              endDate: "$endDateYear-$endDateMonth-$endDate",
              stockName: selectedStock));

      if (_closedOrderPriceAndUnitsResponse?.data == null ||
          _closedOrderPriceAndUnitsResponse!.data!.isEmpty) {
        throw Exception("No data found in the response.");
      }

      _graphData ??= PlotGraphData(orders: []);

      // Ensure the list is initialized and has enough capacity
      for (int i = 0;
          i < _closedOrderPriceAndUnitsResponse!.data!.length;
          i++) {
        if (_graphData!.orders!.length <= i) {
          _graphData!.orders!
              .add(Orders()); // Replace `Order` with your actual class
        }

        print(
            "at the first code line ${_closedOrderPriceAndUnitsResponse!.data![i].executionPrice}");
        _graphData!.orders![i].executionPrice = double.tryParse(
            _closedOrderPriceAndUnitsResponse!.data![i].executionPrice ?? "0");
        print("successfully execution price fetched");

        if (i == 0) {
          print("in if condition");
          _graphData!.orders![i].totalUnits =
              _closedOrderPriceAndUnitsResponse!.data![i].units;
          print("going outside");
        } else {
          print("in the else condition");
          _graphData!.orders![i].totalUnits =
              _graphData!.orders![i - 1].totalUnits! +
                  (_closedOrderPriceAndUnitsResponse!.data![i].units ?? 0);
          print("going outside else condition");
        }

        print("going to calculate the execution price");
        _graphData!.orders![i].value = _graphData!.orders![i].executionPrice! *
            _graphData!.orders![i].totalUnits!;
        print("calculated execution price");
        _graphData!.orders![i].tradeType =
            _closedOrderPriceAndUnitsResponse!.data![i].type;
        print("trade type is also fetched");
      }
    } catch (e) {
      print("error in the get graph data provider $e");
      throw e;
    }
    notifyListeners();
  }
}
