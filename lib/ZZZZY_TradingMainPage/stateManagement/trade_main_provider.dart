import 'package:dozen_diamond/AB_Ladder/models/get_ladder_response.dart';
import 'package:dozen_diamond/AB_Ladder/stateManagement/ladder_provider.dart';
import 'package:dozen_diamond/Settings/models/switching_trading_mode_request.dart';
import 'package:dozen_diamond/Settings/services/settings_rest_api_service.dart';
import 'package:dozen_diamond/ZS_simulate/models/simulate_ticker_list.dart';

import 'package:dozen_diamond/ZZZZY_TradingMainPage/models/get_trade_menu_button_visibility_response.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../AB_Ladder/services/ladder_rest_api_service.dart';
import '../models/active_ladder_simulation_tickers_response.dart';
import '../services/trade_main_rest_api_service.dart';

enum TradingOptions {
  simulationTradingWithSimulatedPrices,
  simulationTradingWithRealValues,
  tradingWithRealCash,
  paperCash,
}

class TradeMainProvider extends ChangeNotifier {
  Color _colorOfIncrementButton = Colors.green;
  Color get colorOfIncrementButton => _colorOfIncrementButton;
  set colorOfIncrementButton(Color colorOfIncrementButtonBunch) {
    _colorOfIncrementButton = colorOfIncrementButtonBunch;
    notifyListeners();
  }

  Color _colorOfDecrementButton = Colors.red;
  Color get colorOfDecrementButton => _colorOfDecrementButton;
  set colorOfDecrementButton(Color colorOfDecrementButtonBunch) {
    _colorOfDecrementButton = colorOfDecrementButtonBunch;
    notifyListeners();
  }

  bool _isLoading = true;
  bool _togglePriceAboveTradeReturn = true;
  bool _isStartTrading = false;
  bool _expandWidget = true;

  bool _tradeExpanded = true;

  bool get tradeExpanded => _tradeExpanded;

  set tradeExpanded(bool value) {
    _tradeExpanded = value;
    notifyListeners();
  }

  bool _ordersExpanded = true;

  bool get ordersExpanded => _ordersExpanded;

  set ordersExpanded(bool value) {
    _ordersExpanded = value;
    notifyListeners();
  }

  bool _positionsExpanded = true;

  bool get positionsExpanded => _positionsExpanded;

  set positionsExpanded(bool value) {
    _positionsExpanded = value;
    notifyListeners();
  }

  List<SimulateTicker> _activeLadderTickers = [];
  List<SimulateTicker> _activeLadderTickersTemp = [];
  SimulateTicker _selectedTickerForSimulation = SimulateTicker(
    "Select ticker",
    -1,
    "",
  );
  SimulateTicker _selectedTickerForSimulationTemp = SimulateTicker(
    "Select ticker",
    -1,
    "",
  );
  bool simulationVisibility = false;
  bool startTradingVisibility = false;
  bool? tradingStatus;
  bool? _singleActiveLadderStatus = false;
  int _tabBarIndex = 0;
  bool _singleLadderExist = false;

  Map<String, double> _firstLadderInitialBuyPrice = {};

  Map<String, double> get firstLadderInitialBuyPrice =>
      _firstLadderInitialBuyPrice;

  set firstLadderInitialBuyPrice(Map<String, double> value) {
    _firstLadderInitialBuyPrice = value;
    notifyListeners();
  }

  Map<String, double> _ladCurrentPrice = {};

  Map<String, double> get ladCurrentPrice => _ladCurrentPrice;

  set ladCurrentPrice(Map<String, double> value) {
    _ladCurrentPrice = value;
    notifyListeners();
  }

  Map<String, double> _ladStepSize = {};

  Map<String, double> get ladStepSize => _ladStepSize;

  set ladStepSize(Map<String, double> value) {
    _ladStepSize = value;
    notifyListeners();
  }

  // double _firstLadderInitialBuyPrice = 0.0;
  // double get firstLadderInitialBuyPrice => _firstLadderInitialBuyPrice;
  // set firstLadderInitialBuyPrice(double firstLadderInitialBuyPriceBunch) {
  //   _firstLadderInitialBuyPrice = firstLadderInitialBuyPriceBunch;
  //   notifyListeners();
  // }
  //
  // double _ladCurrentPrice = 0.0;
  // double get ladCurrentPrice => _ladCurrentPrice;
  // set ladCurrentPrice(double ladCurrentPriceBunch) {
  //   _ladCurrentPrice = ladCurrentPriceBunch;
  //   notifyListeners();
  // }
  //
  // double _ladStepSize = 0.0;
  // double get ladStepSize => _ladStepSize;
  // set ladStepSize(double ladStepSizeBunch) {
  //   _ladStepSize = ladStepSizeBunch;
  //   notifyListeners();
  // }

  IsAbleToSendCsv _isAbleToSendCsv = IsAbleToSendCsv(
    position: false,
    trade: false,
    ladder: false,
    openOrder: false,
    activity: false,
  );

  int get tabBarIndex => _tabBarIndex;
  List<SimulateTicker> get activeLadderTickers => _activeLadderTickers;
  List<SimulateTicker> get activeLadderTickersTemp => _activeLadderTickersTemp;
  SimulateTicker get selectedTickerForSimulation =>
      _selectedTickerForSimulation;
  bool get isLoading => _isLoading;
  bool get expandWidget => _expandWidget;
  bool get isStartTrading => _isStartTrading;
  bool get togglePriceAboveTradeReturn => _togglePriceAboveTradeReturn;
  bool get singleLadderExist => _singleLadderExist;

  IsAbleToSendCsv get isAbleToSendCsv => _isAbleToSendCsv;

  late SharedPreferences _prefs;
  static const String _keyTradingOptions = 'tradingOptions';

  TradeMainProvider() {
    _initPreferences();
  }

  TradingOptions _tradingOptions =
      TradingOptions.simulationTradingWithSimulatedPrices;

  TradingOptions get tradingOptions => _tradingOptions;

  // Declare SharedPreferences instance
  Future<void> _saveTradingOptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _prefs = prefs;
  }

  bool? get singleActiveLadderStatus => _singleActiveLadderStatus;

  Future<void> _initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    await _saveTradingOptions(); // Await saving trading options
    notifyListeners();
  }

  set updateTabBarIndex(int i) {
    _tabBarIndex = i;
    notifyListeners();
  }

  Future<bool> initialGetLadderData(
    CurrencyConstants currencyConstantsProvider,
  ) async {
    try {
      GetLadderResponse? res = await LadderRestApiService().getLadder(
        null,
        currencyConstantsProvider,
        limit: 3
      );
      if (res!.data!.isNotEmpty) {
        _singleLadderExist = true;
      } else {
        _singleLadderExist = false;
      }
      notifyListeners();
      return _singleLadderExist;
    } catch (e) {
      throw e;
    }
  }

  Future<void> _savePreferences() async {
    await _prefs.setString(_keyTradingOptions, tradingOptions.toString());
  }

  set tradingOptions(TradingOptions value) {
    _tradingOptions = value;
    _savePreferences();
    notifyListeners();
  }

  Future<void> switchingTradeMode(int indexValue) async {
    if (indexValue == 0) {
      await SettingRestApiService().switchingTradeMode(
        // SwitchingTradingModeRequest(tradingMode: "SIMULATION")); //'Simulation'));
        SwitchingTradingModeRequest(tradingMode: "SIMULATION-PAPER"),
      ); //'Simulation'));
    } else if (indexValue == 1) {
      await SettingRestApiService().switchingTradeMode(
        // SwitchingTradingModeRequest(tradingMode: "PRACTICEMARKET")); //'PracticeMarket'));
        SwitchingTradingModeRequest(tradingMode: "REALTIME-PAPER"),
      ); //'PracticeMarket'));
    } else {
      await SettingRestApiService().switchingTradeMode(
        // SwitchingTradingModeRequest(tradingMode: "REALMARKET")); //'RealMarket'));
        SwitchingTradingModeRequest(tradingMode: "REAL"),
      ); //'RealMarket'));
      // SwitchingTradingModeRequest(tradingMode: "REALTIME-PAPER")); //'RealMarket'));
    }
    notifyListeners();
  }

  // convert it into one api
  // Future<void> fetchTradingStatusmode() async {
  //   final res = await SettingRestApiService().getTradingModeStatus();
  //   if (res.data!.tradingMode == "Simulation") {
  //     tradingOptions = TradingOptions.simulationTradingWithSimulatedPrices;
  //   } else if (res.data!.tradingMode == "PracticeMarket") {
  //     tradingOptions = TradingOptions.simulationTradingWithRealValues;
  //   } else {
  //     tradingOptions = TradingOptions.tradingWithRealCash;
  //   }
  //   _savePreferences();
  //   notifyListeners();
  // }

  Future<bool> getActiveLadderTickers(
    BuildContext ctx, {
    bool fromSimulationButtonUPAndDown = false,
  }) async {
    try {
      ActiveLadderSimulationTickersResponse? value =
          await TradeMainRestApiService().fetchActiveLaddersimulationTickers();

      if (value!.status!) {
        List<SimulateTicker> activeLadderSimulationsTickers = [];
        for (int k = 0; k < (value.data ?? []).length; k++) {
          activeLadderSimulationsTickers.add(
            SimulateTicker(
              value.data![k].ladTicker ?? "",
              value.data![k].ladTickerId ?? -1,
              value.data![k].ladExchange ?? "",
            ),
          );
        }
        int i = 0;
        _isLoading = false;

        if (fromSimulationButtonUPAndDown == true) {
          _activeLadderTickersTemp.clear();
          _activeLadderTickersTemp = [SimulateTicker("Select ticker", -1, "")];
          _activeLadderTickersTemp += activeLadderSimulationsTickers;
        } else {
          _activeLadderTickers.clear();
          _activeLadderTickers = [SimulateTicker("Select ticker", -1, "")];
          _activeLadderTickers += activeLadderSimulationsTickers;
        }

        if (fromSimulationButtonUPAndDown == true) {
          print("inside if");
          i = _activeLadderTickersTemp.indexOf(
            _selectedTickerForSimulationTemp,
          );
          _selectedTickerForSimulationTemp =
              _activeLadderTickersTemp[i == -1 ? 0 : i];
        } else {
          print("inside else");
          i = activeLadderTickers.indexOf(_selectedTickerForSimulation);
          _selectedTickerForSimulation = activeLadderTickers[i == -1 ? 0 : i];
        }

        print("below is i");
        print(fromSimulationButtonUPAndDown);
        print(i);
        print(value.data);

        if (value.data?.length == 0) {
          return true;
        }

        for (int k = 0; k < (value.data ?? []).length; k++) {
          _firstLadderInitialBuyPrice[value.data![k].ladTickerId.toString()] =
              value.data![k].ladInitialBuyPrice ?? 0.0;
          _ladCurrentPrice[value.data![k].ladTickerId.toString()] =
              value.data![k].ladCurrentPrice ?? 0.0;
          _ladStepSize[value.data![k].ladTickerId.toString()] =
              value.data![k].ladStepSize ?? 0.0;
        }

        // _firstLadderInitialBuyPrice =
        //     value.data![i == -1 ? 0 : i].ladInitialBuyPrice ?? 0.0;
        // _ladCurrentPrice = value.data![i == -1 ? 0 : i].ladCurrentPrice ?? 0.0;
        // _ladStepSize = value.data![i == -1 ? 0 : i].ladStepSize ?? 0.0;

        if (fromSimulationButtonUPAndDown) {
          if (_activeLadderTickersTemp.length == 2 &&
              Provider.of<LadderProvider>(
                    ctx,
                    listen: false,
                  ).stockLadders.length ==
                  1) {
            if (activeLadderTickersTemp.length >= 2) {
              _selectedTickerForSimulationTemp = activeLadderTickersTemp[1];
            }
          }
        } else {
          if (_activeLadderTickers.length == 2 &&
              Provider.of<LadderProvider>(
                    ctx,
                    listen: false,
                  ).stockLadders.length ==
                  1) {
            if (activeLadderTickers.length >= 2) {
              _selectedTickerForSimulation = activeLadderTickers[1];
            }
          }
        }

        notifyListeners();
        return true;
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  //put it into one single api
  // Future<bool> getSingleActiveLadderStatus() async {
  //   try {
  //     IsAnyLadderActiveResponse? res =
  //         await TradeMainRestApiService().isAnyLadderActive();
  //     _singleActiveLadderStatus = res?.data?.anyLadderActive ?? false;
  //     notifyListeners();
  //     return true;
  //   } catch (e) {
  //     throw e;
  //   }
  // }

  set updateSelectedTickerForSimulation(SimulateTicker? newTicker) {
    _selectedTickerForSimulation = newTicker ?? _activeLadderTickers[0];
    _selectedTickerForSimulationTemp = newTicker ?? _activeLadderTickersTemp[0];
    notifyListeners();
  }

  void toggleExpandWidget() {
    _expandWidget = !_expandWidget;
    notifyListeners();
  }

  set updateIsAbleToSendCsv(IsAbleToSendCsv isAbleToSendCsvBunch) {
    _isAbleToSendCsv = isAbleToSendCsvBunch;
    notifyListeners();
  }

  set updateStartTrading(bool tradingStatus) {
    _isStartTrading = tradingStatus;
    notifyListeners();
  }

  void updatePriceAboveTradeReturn() {
    _togglePriceAboveTradeReturn = !_togglePriceAboveTradeReturn;
    notifyListeners();
  }

  set updateSimulationVisibility(bool visibility) {
    simulationVisibility = visibility;
  }

  set updateStartTradingVisibility(bool visibility) {
    simulationVisibility = visibility;
    notifyListeners();
  }

  set updateTradingStatus(bool? status) {
    tradingStatus = status;
  }

  Future<void> getTradeMenuButtonsVisibilityStatus() async {
    print("inside getTradeMenuButtonsVisibilityStatus");
    try {
      GetTradeMenuButtonVisibilityResponse? res =
          await TradeMainRestApiService().getTradeMenuButtonVisibility();
      if (res.status == true) {
        updateTradingStatus = res.data?.isStartTradingOn ?? false;
        _singleActiveLadderStatus = res.data?.anyLadderActive ?? false;
        updateSimulationVisibility = res.data?.isStartTradingOn ?? false;
        _isAbleToSendCsv = res.data!.isAbleToSendCsv!;
        _singleLadderExist = res.data!.anyLadderExists!;

        if ((res.data!.currentTradingStatus ?? "").toUpperCase() ==
            "SIMULATION-PAPER") {
          // "SIMULATION") {
          tradingOptions = TradingOptions.simulationTradingWithSimulatedPrices;
        } else if ((res.data!.currentTradingStatus ?? "").toUpperCase() ==
            "REALTIME-PAPER") {
          // "PRACTICE MARKET") {
          tradingOptions = TradingOptions.simulationTradingWithRealValues;
        } else {
          tradingOptions = TradingOptions.tradingWithRealCash;
        }
        notifyListeners();
      }

      _savePreferences();
      print("after _savePreferences");
      notifyListeners();
    } catch (e) {
      print("paneer $e");
    }
  }

  // Future<bool> fetchTradingStatus() async {
  //   try {
  //     GetCurrentTradingStatusResponse? res =
  //         await TradeMainRestApiService().getTradingStatus();
  //     if (res?.status == true) {
  //       updateTradingStatus = res?.data?.regTradingStatus;
  //       updateSimulationVisibility = false;
  //     } else {
  //       updateTradingStatus = res?.data?.regTradingStatus;
  //       updateSimulationVisibility = res?.data?.regTradingStatus ?? false;
  //     }
  //     notifyListeners();
  //     return true;
  //   } catch (e) {
  //     throw e;
  //   }
  // }
}
