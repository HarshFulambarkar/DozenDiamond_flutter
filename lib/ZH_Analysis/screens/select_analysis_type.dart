import 'package:dozen_diamond/Settings/stateManagement/theme_provider.dart';
import 'package:dozen_diamond/ZH_analysisAlpha/screens/analysis_alpha.dart';
import 'package:dozen_diamond/ZH_analysisPriceVsNumberOfStocks/screens/analysisDifferentialCostVsNOS.dart';
import 'package:dozen_diamond/ZH_analysisPriceVsNumberOfStocks/screens/analysisPriceVsNOS.dart';
import 'package:dozen_diamond/ZH_analysisPriceVsNumberOfStocks/screens/analysisPriceVsValue.dart';
import 'package:dozen_diamond/ZH_analysisPriceVsNumberOfStocks/screens/analysisValueVsNOS.dart';
import 'package:dozen_diamond/ZH_analysisPriceVsNumberOfStocks/screens/averageCostVsNOS.dart';
import 'package:dozen_diamond/ZH_analysisPriceVsNumberOfStocks/screens/averageCostVsPrice.dart';
import 'package:dozen_diamond/ZH_analysisPriceVsNumberOfStocks/screens/extraCashVsPrice.dart';
import 'package:dozen_diamond/ZH_analysisPriceVsNumberOfStocks/stateManagement/analyticsDateProvider.dart';
import 'package:dozen_diamond/ZH_analysisProfitVsPrice/screens/analysis_profit_vs_price.dart';
import 'package:dozen_diamond/ZH_analysisSettledClosestTrade/screens/analysis_settled_closest_trade.dart';
import 'package:dozen_diamond/ZH_analysisSettledRecentTrade/screens/analysis_settled_recent_trade.dart';
import 'package:dozen_diamond/ZH_analysisTradeAnalytics/screens/analysis_trade_analytics.dart';
import 'package:dozen_diamond/ZH_analysisUnsettledClosestBuy/screens/analysis_unsettled_closest_buy.dart';
import 'package:dozen_diamond/ZH_analysisUnsettledRecentBuy/screens/analysis_unsettled_recent_buy.dart';
import 'package:dozen_diamond/ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../DD_Navigation/widgets/nav_drawer.dart';
import '../../DD_Navigation/widgets/nav_drawer_new.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../ZH_analysis/models/analysis_type.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ZH_analysisProfitVsPrice/screens/analysis_price_vs_number_of_stocks_screen.dart';
import '../../ZH_analysisProfitVsPrice/screens/analysis_stock_value_vs_price_screen.dart';
import '../../ZH_analysisProfitVsPrice/screens/analysis_value_vs_number_of_stocks_screen.dart';
import '../../analysis_alpha_gain_vs_open_price/screens/analysis_alpha_gain_vs_open_price_screen.dart';
import '../../analysis_alpha_vs_open_price/screens/analysis_alpha_vs_open_price_screen.dart';
import '../../global/widgets/info_icon_display.dart';
import '../../trade_table/screens/analysis_trade_table_screen.dart';
import '../services/analytics_rest_api_service.dart';
import 'analysis_average_cost_vs_number_of_stocks.dart';
import 'analysis_average_cost_vs_price.dart';
import 'analysis_differential_selling_price_vs_open_order_price.dart';
import 'analysis_price_vs_ladder_value.dart';

class SelectAnalysisType extends StatefulWidget {
  const SelectAnalysisType({super.key});

  @override
  State<SelectAnalysisType> createState() => _SelectAnalysisTypeState();
}

class _SelectAnalysisTypeState extends State<SelectAnalysisType> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  bool showActiveStock = true;

  List<AnalysisType> _analysisTypes = [
    AnalysisType(
      itemId: 1,
      itemString: 'Profit vs Open Order Price (Chart)',
        itemDescription: "This graph shows the profit variation with respect to the open order price (the price at which buy or sell orders are placed). As the open order price increases, the potential profit from selling generally increases. If shares are bought at lower prices and sold at higher prices, the profit difference is clearly visible on the graph. Green dots indicate buy points (stocks purchased), while red dots indicate sell points (stocks sold).",
    ),
    // AnalysisType(itemId: 2, itemString: 'Price vs Number of stocks'),
    AnalysisType(
        itemId: 2,
        itemString: 'Number of stocks vs Open Order Price',
      itemDescription: "This graph represents the relationship between the stock price and the number of stocks held. As the stock price decreases, the number of stocks typically increases, and as the price rises, the number of stocks decreases—showing an inverse relationship between price and quantity. Green dots indicate buy points, and red dots indicate sell points. The chart visualizes how stock holdings change with the open order price over a selected time period",
    ),
    // AnalysisType(itemId: 3, itemString: 'Price vs Value'),
    AnalysisType(
      itemId: 3,
        itemString: 'Stock Value vs Open Order Price',
      itemDescription: "The open order price is the price at which a stock trade is placed. The stock value is calculated as: Stock Value = Number of Stocks × Open Order Price. As trades occur, the graph updates dynamically to show how the total stock value changes with varying open order prices. Buying more shares at lower prices increases the total value, while selling shares at higher prices reduces it.",
    ),
    // AnalysisType(itemId: 4, itemString: 'Value vs Number of stocks'),
    AnalysisType(
      itemId: 4,
      itemString: 'Stock Value vs Number of stocks',
      itemDescription: "Number of Stocks represents the total quantity of shares owned at any point. Stock Value is calculated as: Stock Value = Number of Stocks × open order Price As the number of stocks increases, the total stock value also increases, assuming the stock price remains the same. If stock prices fluctuate, the graph helps visualize how stock value changes with different stock quantities.",
    ),
    AnalysisType(
      itemId: 5,
      itemString: 'Extra Cash vs Open Order Price',
      itemDescription: "This graph shows how extra cash is generated during each trade, regardless of whether stocks are bought or sold. Extra Cash represents the additional funds generated from each trade (buy or sell). Price is the price of the stock at the time of each trade.",
    ),
    AnalysisType(
      itemId: 17,
      itemString: 'Ladders Value vs Open Order Price',
      itemDescription: "The Ladder's Value vs. Open Order Price graph shows how the ladder's value changes in relation to the open order price over a set of trades. Here’s how it works: Ladder's Value: This is the total value calculated for a particular stock trade, which includes the cash needed for the trade (based on the stock's price), the cumulative extra cash generated from previous orders, and the value of the stock position. Open Order Price: This is the price at which the stock is bought or sold at the time of each trade.",
    ),
    AnalysisType(itemId: 6, itemString: 'Average Cost vs Open Order Price', itemDescription: "This graph shows your stock’s average cost compared to the order price for each order. \nAverage cost → overall cost per stock considering all previous trades \norder price → price of the stock for each individual order",),
    AnalysisType(itemId: 7, itemString: 'Average Cost vs Number of stocks', itemDescription: "This graph shows your stock’s average cost as your total number of shares changes over time. \,Average cost → the typical price you paid for each stock, considering all your previous trades \nNumber of stocks → how many shares you own after each buy or sell",),
    AnalysisType(
        // itemId: 8, itemString: 'Differential Cost vs Number of stocks', itemDescription: "",),
        itemId: 8,
      itemString: 'Differential Selling Price vs Open Order Price',
      itemDescription: "The Differential Selling Price vs. Open Order Price graph represents the relationship between the price at which a stock is bought (Open Order Price) and the price at which it is sold (Differential Selling Price). The Open Order Price refers to the price at which a stock is purchased. The Differential Selling Price represents the price at which the stock is effectively sold, taking into account the cumulative cash gain and the stock ownership. \nGreen dots represent a good point, where the stock was sold at a higher price than the buying price (Open Order Price) \nRed dots represent a bad point, where the stock was sold at a lower price than the Open Order Price",
    ),
    AnalysisType(
      itemId: 9,
      itemString: 'Unsettled (Table) Closest buys',
      itemDescription: "The trades are first arranged from highest to lowest based on their execution price. Then, for every buy order, we look for the closest matching sell order. If there's a match, the trade is completed. This process repeats until no more trades can be settled. Any remaining unmatched trades are then shown in the graph.",
    ),
    AnalysisType(
      itemId: 10,
      itemString: 'Settled (Table) Closest buys',
      itemDescription: "First, the orders are sorted by execution price in descending order. Then, we look for the closest buy order and find the nearest sell order that matches it. If a match is found, the trade is settled and added to the settledClosedBuysData list. This process continues for the next closest buy order, finding its nearest matching sell order and settling the trade. All settled trades are then displayed in a table for easy viewing and analysis.",
    ),
    AnalysisType(
      itemId: 11,
      itemString: 'Unsettled (Table) Recent buys',
      itemDescription: "First, the orderDetails are sorted by order_execution_price in descending order. If multiple orders have the same price, they are further sorted by time, from newest to oldest. Next, we identify the closest buy order and find the nearest sell order based on time for that buy order. If a match is found, the trade is settled. This process continues until all possible trades are settled. Any remaining unsettled trades are then displayed in a graph for better visualization.",
    ),
    AnalysisType(
      itemId: 12,
      itemString: 'Settled (Table) Recent buys',
      itemDescription: "First, the orderDetails are sorted by order_execution_price in descending order. If multiple orders have the same price, they are further sorted by time, from newest to oldest. Then, we find the closest buy order and look for the nearest sell order based on time for that buy order. If a match is found, the trade is settled and added to settledRecentBuysData. This process continues until all possible trades are settled. Finally, the settled trades are displayed in a table for easy viewing and analysis.",
    ),
    AnalysisType(
      itemId: 13,
      itemString: 'All trade (Table)',
      itemDescription: "The All Trades Table includes a complete record of all buy and sell trades made by the user. It provides a clear overview of every transaction, helping users track their trading activity easily.",
    ),
    // AnalysisType(itemId: 14, itemString: 'Actual vs Computed Alpha (Chart)', itemDescription: "",),
    AnalysisType(
      itemId: 14,
      itemString: 'Alpha vs Open Order Price',
      itemDescription: "Alpha is the gain in portfolio value for every unit price change in the stock. Here we are plotting alpha vs price.",
    ),
    AnalysisType(
      itemId: 15,
      itemString: 'Alpha gain vs Open Order Price',
      itemDescription: "For the buy and hold strategy, alpha should be the number of stock. Alpha gain is the difference between the alpha in the portfolio and the alpha in the buy and hold strategy.",
    ),
    // AnalysisType(itemId: 15, itemString: 'Alpha gain (Chart)'),
  ];

  DateTimeProvider? _dateTimeState;
  bool _stockListApiCall = false;
  List<String?> selectedStockList = [];
  String? _selectedStock;
  String? _selectedStockDropdownPlaceholder = "";
  String? warningMessage = "";

  late ThemeProvider themeProvider;

  @override
  void initState() {
    super.initState();
    warningMessage = "Please select ticker";
    getSelectedStockList();
    _dateTimeState = Provider.of<DateTimeProvider>(context, listen: false);
  }

  _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  void _triggerDrawer() {
    _key.currentState!.openDrawer();
  }

  Future<void> getSelectedStockList() async {

    TradeMainProvider tradeMainProvider = Provider.of<TradeMainProvider>(context, listen: false);
    String currentTradingMode = "SIMULATION-PAPER";

    if (tradeMainProvider.tradingOptions ==
        TradingOptions.simulationTradingWithSimulatedPrices) {
      currentTradingMode = "SIMULATION-PAPER";
    }

    if (tradeMainProvider.tradingOptions ==
        TradingOptions.simulationTradingWithRealValues) {
      currentTradingMode = "REALTIME-PAPER";
    }

    if (tradeMainProvider.tradingOptions ==
        TradingOptions.tradingWithRealCash) {
      currentTradingMode = "REAL";
    }

    Map<String, dynamic> request = {
      "trading_mode": currentTradingMode,
      "active_stocks_only": showActiveStock,
    };
    SharedPreferences.getInstance().then((pref) {
      AnalyticsRestApiService().tradeAnalyticStockList(request).then((value) {
        _stockListApiCall = true;
        selectedStockList = value!.data!;
        selectedStockList.insert(0, 'Tickers');
        if (value.data!.isNotEmpty) {
          _selectedStock = value.data![0];
          // getPriceStockValueGraphData();
        } else {
          _selectedStockDropdownPlaceholder = "No stocks available";
        }
        _updateState();
      }).catchError((err) {
        print("Error in getSelectStockList $err");
      });
    });
  }

  Future<void> selectAnalysis(
      AnalysisType analysisType, DateTimeProvider value) async {
    if (_selectedStock == "Tickers" || !_stockListApiCall) {
      Fluttertoast.showToast(msg: "Please select ticker for analysis");
    } else if (_selectedStockDropdownPlaceholder == "No stocks available") {
      Fluttertoast.showToast(msg: "No stock available for analysis");
    } else if (_dateTimeState!.startDateTimeController.text == '' &&
        _dateTimeState!.endDateTimeController.text == '') {
      Fluttertoast.showToast(msg: "Select the dates");
    } else if (_dateTimeState!.startDateTimeController.text == '') {
      Fluttertoast.showToast(msg: "Select the start date");
    } else if (_dateTimeState!.endDateTimeController.text == '') {
      Fluttertoast.showToast(msg: "Select the end date");
    } else {
      // await value.getGraphData(_selectedStock);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        switch (analysisType.itemId) {
          case 1:
            return AnalysisProfitVsPrice(
              userSelectedAnalysis: analysisType,
              userSelectedStock: _selectedStock!,
            );
          // case 2:
          //   return AnalysisPriceVsNumberOfStocks(
          //     userSelectedAnalysis: analysisType,
          //     userSelectedStock: _selectedStock!,
          //   );
          case 2:
            return AnalysisPriceVsNumberOfStocksScreen(
              userSelectedAnalysis: analysisType,
              userSelectedStock: _selectedStock!,
            );
          // case 3:
          //   return AnalysisPriceVsValue(
          //     userSelectedAnalysis: analysisType,
          //     userSelectedStock: _selectedStock!,
          //   );
          case 3:
            // return AnalysisPriceVsValueScreen(
            return AnalysisStockValuePriceScreen(
              userSelectedAnalysis: analysisType,
              userSelectedStock: _selectedStock!,
            );
          // case 4:
          //   return AnalysisValueVsNumberOfStocks(
          //     userSelectedAnalysis: analysisType,
          //     userSelectedStock: _selectedStock!,
          //   );
          case 4:
            return AnalysisValueVsNumberOfStocksScreen(
              userSelectedAnalysis: analysisType,
              userSelectedStock: _selectedStock!,
            );
          case 5:
            return ExtraCashVsPrice(
              userSelectedAnalysis: analysisType,
              userSelectedStock: _selectedStock!,
            );
          case 6:
            return AnalysisAverageCostVsPriceScreen(
              userSelectedAnalysis: analysisType,
              userSelectedStock: _selectedStock!,
            );
          // return AverageCostVsPrice();
          case 7:
            return AnalysisAverageCostVsNumberOfStocksScreen(
              userSelectedAnalysis: analysisType,
              userSelectedStock: _selectedStock!,
            );
          // return AverageCostVsNOS();
          case 8:
            return AnalysisDifferentialSellingPriceVsOpenOrderPriceScreen(
              userSelectedAnalysis: analysisType,
              userSelectedStock: _selectedStock!,
            );
            // return DifferentialCostVsNOS();
          case 9:
            return AnalysisUnsettledClosestBuy(
              userSelectedAnalysis: analysisType,
              userSelectedStock: _selectedStock!,
            );
          case 10:
            return AnalysisSettledClosestTrade(
              userSelectedAnalysis: analysisType,
              userSelectedStock: _selectedStock!,
            );
          case 11:
            return AnalysisUnsettledRecentBuy(
              userSelectedAnalysis: analysisType,
              userSelectedStock: _selectedStock!,
            );
          case 12:
            return AnalysisSettledRecentTrade(
              userSelectedAnalysis: analysisType,
              userSelectedStock: _selectedStock!,
            );
          case 13:
            return AnalysisTradeTableScreen(
              userSelectedAnalysis: analysisType,
              userSelectedStock: _selectedStock!,
            );
          case 14:
            return AnalysisAlphaVsOpenPriceScreen(
              userSelectedAnalysis: analysisType,
              userSelectedStock: _selectedStock!,
            );
          // case 14:
          //   return AnalysisTradeAnalytics(
          //     userSelectedAnalysis: analysisType,
          //     userSelectedStock: _selectedStock!,
          //   );
          case 15:
            return AnalysisAlphaGainVsOpenPriceScreen(
              userSelectedAnalysis: analysisType,
              userSelectedStock: _selectedStock!,
            );
            // return AnalysisAlphaVsOpenPriceScreen(
            //   userSelectedAnalysis: analysisType,
            //   userSelectedStock: _selectedStock!,
            // );
          case 16:
            return AnalysisAlpha(
              userSelectedAnalysis: analysisType,
              userSelectedStock: _selectedStock!,
            );
          case 17:
            // return AnalysisPriceVsValueScreen(
            return AnalysisPriceVsLadderValueScreen(
              userSelectedAnalysis: analysisType,
              userSelectedStock: _selectedStock!,
            );

          default:
            return AnalysisProfitVsPrice(
              userSelectedAnalysis: analysisType,
              userSelectedStock: _selectedStock!,
            );
        }
      }));
    }
  }

  Future<void> _selectDate({isStartDate = false}) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: isStartDate ? DateTime(2024) : DateTime.now(),
        firstDate: DateTime(2024),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor:
                  Colors.blue, // Deprecated, can be removed if not necessary
              colorScheme: ColorScheme.light(
                primary: Colors.blue,
                secondary: Colors.blue, // Replaces accentColor
              ),
              buttonTheme: ButtonThemeData(
                textTheme: ButtonTextTheme.primary,
              ),
            ),
            child: child ?? const SizedBox(), // Null safety check
          );
        });
    if (picked != null) {
      if (isStartDate) {
        _dateTimeState!.startDateTime = picked;
        _dateTimeState!.startDateTimeController.text =
            DateFormat('MM-dd-yyyy').format(picked);
      } else {
        _dateTimeState!.endDateTime = picked;
        _dateTimeState!.endDateTimeController.text =
            DateFormat('MM-dd-yyyy').format(picked);
      }
    }
  }

  Widget dateSetter() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Start Date',
                    style: TextStyle(
                        color: (themeProvider.defaultTheme)
                            ?Colors.black:Colors.white
                    ),
                  ),
                  SizedBox(
                      height: 4), // Spacing between label and TextFormField
                  Container(
                    height: 35,
                    child: TextFormField(
                      keyboardType: TextInputType.datetime,
                      controller: _dateTimeState!.startDateTimeController,
                      readOnly: false, // Allow keyboard input
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10.0),
                        labelStyle: TextStyle(
                            color: (themeProvider.defaultTheme)
                                ?Colors.black
                                :Colors.white
                        ),
                        hintText: 'MM-DD-YYYY',
                        hintStyle: TextStyle(color: (themeProvider.defaultTheme)
                            ?Colors.black
                            :Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: (themeProvider.defaultTheme)
                              ?Colors.black
                              :Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: (themeProvider.defaultTheme)
                              ?Colors.black
                              :Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: (themeProvider.defaultTheme)
                              ?Colors.black
                              :Colors.white),
                        ),
                      ),
                      style: TextStyle(color: (themeProvider.defaultTheme)
                          ?Colors.black
                          :Colors.white),
                      onChanged: (value) {
                        String formattedValue =
                            value.replaceAll(RegExp(r'[^0-9]'), '');
                        if (formattedValue.length > 2) {
                          formattedValue = formattedValue.substring(0, 2) +
                              '-' +
                              formattedValue.substring(2);
                        }
                        if (formattedValue.length > 5) {
                          formattedValue = formattedValue.substring(0, 5) +
                              '-' +
                              formattedValue.substring(5);
                        }
                        if (formattedValue.length >= 10) {
                          formattedValue = formattedValue.substring(0, 10);
                        }
                        _dateTimeState!.startDateTimeController.text =
                            formattedValue;
                        _dateTimeState!.startDateTimeController.selection =
                            TextSelection.fromPosition(
                          TextPosition(
                              offset: _dateTimeState!
                                  .startDateTimeController.text.length),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: IconButton(
                onPressed: () => _selectDate(isStartDate: true),
                icon: Icon(Icons.calendar_month),
                color: (themeProvider.defaultTheme)
                    ?Colors.black
                    :Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'End Date',
                    style: TextStyle(color: (themeProvider.defaultTheme)
                        ?Colors.black
                        :Colors.white),
                  ),
                  SizedBox(
                      height: 4), // Spacing between label and TextFormField
                  Container(
                    height: 40,
                    child: TextFormField(
                      keyboardType: TextInputType.datetime,
                      controller: _dateTimeState!.endDateTimeController,
                      readOnly: false, // Allow keyboard input
                      // decoration: dateFieldInputDecortion,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10.0),
                        labelStyle: TextStyle(
                            color: (themeProvider.defaultTheme)
                                ?Colors.black
                                :Colors.white
                        ),
                        hintText: 'MM-DD-YYYY',
                        hintStyle: TextStyle(color: (themeProvider.defaultTheme)
                            ?Colors.black
                            :Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: (themeProvider.defaultTheme)
                              ?Colors.black
                              :Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: (themeProvider.defaultTheme)
                              ?Colors.black
                              :Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: (themeProvider.defaultTheme)
                              ?Colors.black
                              :Colors.white),
                        ),
                      ),
                      style: TextStyle(color: (themeProvider.defaultTheme)
                          ?Colors.black
                          :Colors.white),
                      onChanged: (value) {
                        String formattedValue =
                            value.replaceAll(RegExp(r'[^0-9]'), '');
                        if (formattedValue.length > 2) {
                          formattedValue = formattedValue.substring(0, 2) +
                              '-' +
                              formattedValue.substring(2);
                        }
                        if (formattedValue.length > 5) {
                          formattedValue = formattedValue.substring(0, 5) +
                              '-' +
                              formattedValue.substring(5);
                        }
                        if (formattedValue.length >= 10) {
                          formattedValue = formattedValue.substring(0, 10);
                        }
                        _dateTimeState!.endDateTimeController.text =
                            formattedValue;
                        _dateTimeState!.endDateTimeController.selection =
                            TextSelection.fromPosition(
                          TextPosition(
                              offset: _dateTimeState!
                                  .endDateTimeController.text.length),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: IconButton(
                onPressed: () => _selectDate(),
                icon: Icon(Icons.calendar_month),
                color: (themeProvider.defaultTheme)
                    ?Colors.black
                    :Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget stockListDropdown() {
    return stockListDropdownButton(_stockListApiCall);
  }

  Widget stockListDropdownButton(bool stocksPresent) {
    return Consumer<ThemeProvider>(builder: (context, value, child) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: value.defaultTheme ? Colors.black : Colors.white,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: 45,
        margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            padding: EdgeInsets.zero,
            iconSize:
                _stockListApiCall && selectedStockList.isEmpty ? 0.0 : 24.0,
            hint: Text(
              !stocksPresent
                  ? "No Stocks"
                  : _selectedStockDropdownPlaceholder ?? '',
              style: TextStyle(
                  color: (themeProvider.defaultTheme)?Colors.black:Colors.white
              ),
            ),
            value: !stocksPresent ? null : _selectedStock,
            onChanged: (value) {
              if (!stocksPresent) {
              } else {
                _selectedStock = value;
                if (value == "Tickers") {
                  warningMessage = "Please select ticker for analysis and Date";
                } else if (_dateTimeState?.startDateTimeController.text == '' ||
                    _dateTimeState?.endDateTimeController.text == '') {
                  warningMessage = "Please select analysis type and Date";
                } else {
                  warningMessage = "Please select analysis type";
                }
                _updateState();
              }
            },
            dropdownColor: value.defaultTheme ? Colors.white : Colors.black,
            items: selectedStockList
                .map(
                  (String? stock) => DropdownMenuItem<String>(
                    child: Text(stock!),
                    value: stock,
                  ),
                )
                .toList(),
          ),
        ),
      );
    });
  }

  Widget analysisButton(AnalysisType analysisType) {
    return Consumer<DateTimeProvider>(builder: (context, value, _) {
      return InkWell(
        onTap: () {
          selectAnalysis(analysisType, value);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      analysisType.itemString!,
                      style: GoogleFonts.poppins(
                          fontSize: 16
                      ),
                    ),

                    SizedBox(
                      width: 27,
                      height: 27,
                      child: InfoIconDisplay().infoIconDisplay(
                        context,
                        analysisType.itemString!,
                        analysisType.itemDescription!,
                        color: (themeProvider.defaultTheme)
                            ? Colors.black
                            : Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.blue,
                size: 15,
              )
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    return Scaffold(
      key: _key,
      drawer: NavDrawerNew(),
      // drawer: NavigationDrawerWidget(),
      resizeToAvoidBottomInset: false,
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
                      //   height: AppBar().preferredSize.height * 1.5,
                      // ),

                      Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 5, 0),
                        child: Row(
                          children: [

                            SizedBox(
                              height: 34,
                              width: 24,
                              child: Checkbox(
                                value: showActiveStock,
                                onChanged: (bool? checked) {
                                  setState(() {
                                    showActiveStock = checked!;
                                    _selectedStock = "Tickers";
                                    // _dateTimeState!.startDateTimeController.text = "";
                                    // _dateTimeState!.endDateTimeController.text = "";
                                  });
                                  getSelectedStockList();

                                },
                                side: BorderSide(
                                  color: (themeProvider.defaultTheme)?Colors.black:Colors.white
                                ),
                                checkColor: (themeProvider.defaultTheme)?Colors.white:Colors.black,
                                fillColor:
                                WidgetStateColor.resolveWith((states) {
                                  return states.contains(WidgetState.selected)
                                      ? Colors.white // Selected color
                                      : Colors.black; // Transparent when unselected
                                }),
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              "Show active stock only",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: (themeProvider.defaultTheme)?Colors.black:Colors.white
                                  // color: Colors.white
                                  // color: Color(0xFF0099CC)
                              ),
                            )
                          ],
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 5, 0),
                        child: Text(
                          warningMessage!,
                          style:
                              TextStyle(fontSize: 18, color: Color(0xFF0099CC)),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(child: stockListDropdown()),
                          SizedBox(
                              width:
                                  16), // Add some spacing between dropdown and date setter
                          Expanded(child: dateSetter()),
                        ],
                      ),
                      ..._analysisTypes
                          .map((analysisType) => analysisButton(analysisType))
                          .toList(),
                    ],
                  ),
                ),
              ),
            ),
            MediaQuery.of(context).size.width < 768
                ? CustomHomeAppBarWithProviderNew(
                    backButton: false,
                    leadingAction: _triggerDrawer,
                    widthOfWidget:
                        screenWidth //these leadingAction button is not working, I have tired making it work, but it isn't.
                    )
                : CustomHomeAppBarWithProviderNew(
                    backButton: false,
                    leadingAction: _triggerDrawer,
                    widthOfWidget:
                        screenWidth //these leadingAction button is not working, I have tired making it work, but it isn't.
                    ),
          ],
        ),
      ),
    );
  }
}
