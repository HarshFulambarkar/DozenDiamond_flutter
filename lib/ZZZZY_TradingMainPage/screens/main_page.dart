import 'dart:async';

import 'package:dozen_diamond/AA_positions/stateManagement/position_provider.dart';
import 'package:dozen_diamond/AB_Ladder/stateManagement/ladder_provider.dart';
import 'package:dozen_diamond/AC_trades/stateManagement/trades_provider.dart';
import 'package:dozen_diamond/AD_Orders/stateManagement/order_provider.dart';
import 'package:dozen_diamond/AE_Activity/stateManagement/activity_provider.dart';
import 'package:dozen_diamond/DD_Navigation/stateManagement/navigation_provider.dart';
import 'package:dozen_diamond/Settings/stateManagement/theme_provider.dart';
import 'package:dozen_diamond/ZB_accountInfoBar/stateManagement/custom_home_app_bar_provider.dart';
import 'package:dozen_diamond/ZS_simulate/models/simulate_ticker_list.dart';
import 'package:dozen_diamond/ZZZZY_TradingMainPage/models/toggle_all_ladder_activation_status_request.dart';
import 'package:dozen_diamond/ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:dozen_diamond/create_ladder_detailed/constants/terms_info_contant.dart';
import 'package:dozen_diamond/create_ladder_detailed/widgets/info_icon_display.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../AD_Orders/screens/hidden_order_tab.dart';
import '../../DD_Navigation/widgets/nav_drawer_new.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../ZS_simulate/services/simulate_rest_api_service.dart';
import '../../AB_ladder/widgets/ladder_csv_confirm_dialog.dart';
import '../../AD_orders/widgets/order_csv_confirm_dialog.dart';
import '../../AA_positions/widgets/position_csv_confirm_dialog.dart';
import '../../AC_trades/widgets/trade_csv_confirm_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../ZS_simulate/models/simulate_stock_request.dart';
import '../../AB_ladder/screens/ladder_tab.dart';
import '../../DD_navigation/widgets/nav_drawer.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';

import '../../AE_Activity/screens/activity_tab.dart';
import '../../AD_orders/screens/orders_tab.dart';

import '../../AA_positions/screens/position_tab.dart';
import '../../AC_trades/screens/trade_tab.dart';
import '../../global/constants/shared_preferences_manager.dart';
import '../../global/functions/utils.dart';
import '../../global/widgets/3d_button.dart';
import '../models/start_trading_request.dart';
import '../services/trade_main_rest_api_service.dart';

class MainPage extends StatefulWidget {
  final bool initiallyExpanded;
  final bool goT0LadderTab;
  final bool enableBackButton;
  final double stepSize;
  final bool enableMenuButton;
  final Function? updateIndex;
  final int goToIndex;
  final String selectedTicker;

  MainPage({
    super.key,
    this.data,
    this.initiallyExpanded = true,
    this.goT0LadderTab = false,
    this.updateIndex,
    this.enableBackButton = true,
    this.enableMenuButton = true,
    this.stepSize = 0,
    this.goToIndex = 0,
    this.selectedTicker = "Select ticker",
  });

  final dynamic data;
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  bool isError = false;
  bool isColor = false;
  bool singleActiveLadder = false;
  ValueNotifier<bool> _toggleController = ValueNotifier<bool>(false);
  bool _toggledOption = false;

  TermsInfoConstant termsInfoConstant = TermsInfoConstant();

  TextEditingController _multiplierController = TextEditingController();
  VoidCallback? _getLadderDataRequest;

  late NavigationProvider navigationProvider;

  String dropdownvalue = 'Sort by Date';
  List<String> list = <String>[
    'Sort by Date',
    'Sort by Alphabet',
  ];
  final List<Color> gradientColors = [
    Colors.white,
    Colors.black38,
  ];
  List<String> activeLadderTickers = ["Select ticker"];
  String? selectedTickerSimulation;
  bool _isWaiting = false;
  bool activeLadderListLoading = true;

  Timer? simulationTimmer;

  TradeMainProvider? _tradeMainProvider;
  late TradeMainProvider tradeMainProvider;
  LadderProvider? _ladderProvider;
  late LadderProvider ladderProvider;
  OrderProvider? _orderProvider;
  ActivityProvider? _activityProvider;
  PositionProvider? _positionProvider;
  TradesProvider? _tradesProvider;
  CustomHomeAppBarProvider? _customHomeAppBarProvider;
  CurrencyConstants? _currencyConstantsProvider;

  void _triggerDrawer() {
    _key.currentState!.openDrawer();
  }

  void getLadderDataRequest(VoidCallback fun) {
    _getLadderDataRequest = fun;
  }

  void initState() {
    super.initState();
    _tradeMainProvider = Provider.of(context, listen: false);
    _ladderProvider = Provider.of(context, listen: false);
    _orderProvider = Provider.of(context, listen: false);
    _positionProvider = Provider.of(context, listen: false);
    _activityProvider = Provider.of(context, listen: false);
    _tradesProvider = Provider.of(context, listen: false);
    _customHomeAppBarProvider = Provider.of(context, listen: false);
    _currencyConstantsProvider = Provider.of(context, listen: false);
    _tabController = TabController(
        length: 5, vsync: this, initialIndex: _tradeMainProvider!.tabBarIndex);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkIfSuperUser();
    });

    selectedTickerSimulation = activeLadderTickers[0];
    _tradeMainProvider = Provider.of(context, listen: false);

    _toggleController.addListener(
      () {
        if (_toggledOption) {
          if (mounted) {
            setState(() {
              _toggledOption = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _toggledOption = true;
            });
          }
        }
      },
    );
    callInitialApi();
    print("InitState is called of main_page");

    getUserEmail();
  }

  checkIfSuperUser() async {
    print("inside checkIfSuperUser");
    bool isSuperUser = await SharedPreferenceManager.getIsSuper() ?? false;

    print(isSuperUser);
    _orderProvider!.isSuperUser = isSuperUser;
    print("below is init state isSuperUser");
    print(_orderProvider!.isSuperUser);
    _tabController = (_orderProvider!.isSuperUser)
        ? TabController(
            length: 6,
            vsync: this,
            initialIndex: _tradeMainProvider!.tabBarIndex)
        : TabController(
            length: 5,
            vsync: this,
            initialIndex: _tradeMainProvider!.tabBarIndex);
    setState(() {});
  }

  String email = "-";

  getUserEmail() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      email = pref.getString("reg_user_email") ?? "-";
    });
  }

  List<Function> tabsButtonVisibility = [];

  Future<void> _activityDownloadCsv() async {
    await TradeMainRestApiService().activityDownloadCsv().then((res) {
      if (res?.status == true) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: "${res?.message}",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }).catchError((err) {
      Navigator.of(context).pop();
      print("activity download csv $err");
    });
  }

  Future<void> _startTrading() async {
    _tradeMainProvider?.updateTradingStatus = null;

    TradeMainRestApiService()
        .startTrading(
      StartTradingRequest(
        actTradingStatus: false,
      ),
    )
        .then((res) async {
      await _tradeMainProvider!.getTradeMenuButtonsVisibilityStatus();
      await refreshDataAtSimulation();
    }).catchError((err) {
      print("start trading function err $err");
    });
  }

  Future<void> callInitialApi() async {
    try {
      print("ladder exist in call initialApi 1");
      await _tradeMainProvider!.getTradeMenuButtonsVisibilityStatus();
      print("ladder exist in call initialApi 2");
      // await _tradeMainProvider!.getSingleActiveLadderStatus();
      if (mounted) {
        await _tradeMainProvider!.getActiveLadderTickers(context);
      }
      print("ladder exist in call initialApi 3");
      // await _tradeMainProvider!.fetchTradingStatus();
      // bool ladderLoaded = await _tradeMainProvider!
      //     .initialGetLadderData(_currencyConstantsProvider!);
//    print("ladder exist in call initialApi 4");
     
    } on HttpApiException catch (err) {
      print(err);
    }
  }

  Future<void> refreshDataAtSimulation() async {
    try {
      await _tradesProvider!.fetchTrades(_currencyConstantsProvider!);
      await _orderProvider!.fetchOrders(_currencyConstantsProvider!);
      await _positionProvider!.fetchPositions(_currencyConstantsProvider!);
      await _ladderProvider!.fetchAllLadder(_currencyConstantsProvider!);
      await _activityProvider!.fetchActivities();
      await _customHomeAppBarProvider!.fetchUserAccountDetails();
      await _tradeMainProvider!.getTradeMenuButtonsVisibilityStatus();
    } on HttpApiException catch (err) {
      print("refreshDataAtSimulation function $err");
    }
  }

  Future<void> activateAllLadderDialog(
      BuildContext context, bool? forDeactivating) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 10,
              left: 20,
              right: 20,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(
                20,
              ),
              border: Border.all(
                color: Colors.white,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  forDeactivating!
                      ? "Are you sure you want to Deactivate all ladder ?"
                      : "Are you sure you want to Active all ladder ?",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextButton(
                        onPressed: () {
                          ToggleAllLadderActivationStatusRequest requestBody =
                              ToggleAllLadderActivationStatusRequest(
                                  ladStatus:
                                      forDeactivating ? "INACTIVE" : "ACTIVE");
                          TradeMainRestApiService()
                              .allLadderToggleActivationStatus(requestBody)
                              .then((value) {
                            refreshDataAtSimulation();
                            Navigator.pop(context);
                            Fluttertoast.showToast(msg: value.message!);
                            _tradeMainProvider!.getActiveLadderTickers(context);
                            // bottom navigation bar navigator.push
                          });
                        },
                        child: const Text(
                          "Proceed",
                          style:
                              TextStyle(color: Color(0xFF0099CC), fontSize: 16),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> simulation(
      double multiple, int stockId, BuildContext context) async {
    await SimulateRestApiService()
        .simulateStock(SimulateStockRequest(
      simulatePriceByStepSizeMultiple: multiple,
      tickerId: stockId,
    ))
        .then((res) {
      if (res?.status == false) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text("Target price reached all stocks sold successfully")));
      }
    }).catchError((err) {
      print("simulation function error $err");
    });
  }

  List mainPageList = [];
  ThemeProvider themeProvider = new ThemeProvider();
  final List<Tab> _tabs = [
    Tab(child: Consumer<ThemeProvider>(builder: (context, value, child) {
      return Container(
          margin: EdgeInsets.all(10),
          child: Text("Ladders",
              style: TextStyle(
                  color: value.defaultTheme ? Colors.black : Colors.white)));
    })),
    Tab(child: Consumer<ThemeProvider>(builder: (context, value, child) {
      return Container(
          margin: const EdgeInsets.all(10),
          child: Text("Trades",
              style: TextStyle(
                  color: value.defaultTheme ? Colors.black : Colors.white)));
    })),
    Tab(child: Consumer<ThemeProvider>(builder: (context, value, child) {
      return Container(
          margin: const EdgeInsets.all(10),
          child: Text("Orders",
              style: TextStyle(
                  color: value.defaultTheme ? Colors.black : Colors.white)));
    })),
    Tab(child: Consumer<ThemeProvider>(builder: (context, value, child) {
      return Container(
          margin: const EdgeInsets.all(10),
          child: Text("Hidden Orders",
              style: TextStyle(
                  color: value.defaultTheme ? Colors.black : Colors.white)));
    })),
    Tab(child: Consumer<ThemeProvider>(builder: (context, value, child) {
      return Container(
          margin: const EdgeInsets.all(10),
          child: Text("Positions",
              style: TextStyle(
                  color: value.defaultTheme ? Colors.black : Colors.white)));
    })),
    Tab(child: Consumer<ThemeProvider>(builder: (context, value, child) {
      return Container(
          margin: const EdgeInsets.all(10),
          child: Text("Activity",
              style: TextStyle(
                  color: value.defaultTheme ? Colors.black : Colors.white)));
    })),
  ];

  late TabController _tabController;

  List ladderlist1 = [];

  @override
  void dispose() {
    _tabController.dispose();
    simulationTimmer?.cancel();
    super.dispose();
  }


  Widget activityDownloadCsvDialog(defaultTheme) {
    return TextButton.icon(
      icon: FaIcon(
        FontAwesomeIcons.fileArrowDown,
        size: 22,
        color: defaultTheme ? Colors.blue : Color(0xFF0099CC),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, localSetState) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                    side: const BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  actionsAlignment: MainAxisAlignment.center,
                  backgroundColor: const Color(0xFF15181F),
                  title: const Text(
                    "Download As CSV",
                    style: TextStyle(color: Colors.white),
                  ),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Dear user you will recieve a CSV file in your email (${email}) with detailed information of the Activity ",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                  actions: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            child: ElevatedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                side: const BorderSide(
                                  color: Color(0xFF0099CC),
                                ),
                              ),
                              onPressed: () async {
                                _activityDownloadCsv();
                              },
                              child: const Text('Ok'),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                side: const BorderSide(
                                  color: Color(0xFF0099CC),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Color(0xFF0099CC)),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                );
              },
            );
          },
        );
      },
      label: Text(
        "Activity CSV",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: defaultTheme ? Colors.blue : Color(0xFF0099CC),
        ),
      ),
    );
  }

  Widget tradeCsvDialog(defaultTheme) {
    return TextButton.icon(
      icon: FaIcon(
        FontAwesomeIcons.fileArrowDown,
        size: 22,
        color: defaultTheme ? Colors.blue : Color(0xFF0099CC),
      ),
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return TradeCsvConfirmDialog();
            });
      },
      label: Text(
        "Trade CSV",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: defaultTheme ? Colors.blue : Color(0xFF0099CC),
        ),
      ),
    );
  }

  Widget orderCsvDialog(defaultTheme) {
    return TextButton.icon(
      icon: FaIcon(
        FontAwesomeIcons.fileArrowDown,
        size: 22,
        color: defaultTheme ? Colors.blue : Color(0xFF0099CC),
      ),
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return OrderCsvConfirmDialog();
            });
      },
      label: Text(
        "Order CSV",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: defaultTheme ? Colors.blue : Color(0xFF0099CC),
        ),
      ),
    );
  }

  Widget startStopTradingBtn() {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: Align(
        alignment: Alignment.topRight,
        child: _tradeMainProvider?.tradingStatus == null
            ? const SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(),
              )
            : _tradeMainProvider?.tradingStatus == true
                ? Container(
                    width: screenWidthRecognizer(context) * 0.28,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        textStyle: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        _startTrading();
                        // Map<String, dynamic> request = {
                        //   "websocket": false,
                        // };

                        // StartStopSmartApiWebsocketResponse? res =
                        //     await TradeMainRestApiService()
                        //         .startStopSmartApiWebsocket(request);
                      },
                      child: const Text("Stop Trading",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white)),
                    ),
                  )
                : !_tradeMainProvider!.singleLadderExist
                    ? const SizedBox()
                    : _tradeMainProvider?.singleActiveLadderStatus ?? false
                        ? Column(
                            children: [
                              Center(
                                child: Container(
                                  width: screenWidthRecognizer(context) * 0.28,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _tradeMainProvider?.updateTradingStatus =
                                          null;

                                      TradeMainRestApiService()
                                          .startTrading(
                                        StartTradingRequest(
                                          actTradingStatus: true,
                                        ),
                                      )
                                          .then((res) async {
                                        _tradeMainProvider!
                                            .getTradeMenuButtonsVisibilityStatus();
                                        _tradeMainProvider!
                                            .getActiveLadderTickers(context);
                                        refreshDataAtSimulation();

                                        // Map<String, dynamic> request = {
                                        //   "websocket": true,
                                        // };

                                        // StartStopSmartApiWebsocketResponse? res =
                                        //     await TradeMainRestApiService()
                                        //         .startStopSmartApiWebsocket(
                                        //             request);
                                      });
                                    },
                                    child: Text("Start Trading",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Center(
                                child: Container(
                                  width: screenWidthRecognizer(context) * 0.28,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Fluttertoast.showToast(
                                          msg:
                                              "Active any ladder to start trading");
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            (themeProvider.defaultTheme)
                                                ? MaterialStatePropertyAll(
                                                    Colors.black)
                                                : MaterialStatePropertyAll(
                                                    Colors.grey)),
                                    child: Text("Start Trading",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color:
                                                (themeProvider.defaultTheme)
                                                    ? Colors.white
                                                    : Colors.white)),
                                  ),
                                ),
                              ),
                            ],
                          ),
      ),
    );
  }

  Widget positionCsvDialog(defaultTheme) {
    return TextButton.icon(
      icon: FaIcon(
        FontAwesomeIcons.fileArrowDown,
        size: 22,
        color: defaultTheme ? Colors.blue : Color(0xFF0099CC),
      ),
      onPressed: () {
        showDialog(
            context: context,
            builder: (ctx) {
              return PositionCsvConfirmDialog();
            });
      },
      label: Text(
        "Position CSV",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: defaultTheme ? Colors.blue : Color(0xFF0099CC),
        ),
      ),
    );
  }

  Widget ladderCsvDialog(defaultTheme) {
    return TextButton.icon(
      icon: FaIcon(
        FontAwesomeIcons.fileArrowDown,
        size: 22,
        color: defaultTheme ? Colors.blue : Color(0xFF0099CC),
      ),
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return LadderCsvConfirmDialog();
            });
      },
      label: Text(
        "Ladder CSV",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: defaultTheme ? Colors.blue : Color(0xFF0099CC),
        ),
      ),
    );
  }

  Widget expandCollapseLadderButton(defaultTheme) {
    return SizedBox(
      width: 110,
      child: TextButton.icon(
        icon: Icon(
          Icons.expand,
          color: defaultTheme ? Colors.blue : Color(0xFF0099CC),
          size: 21,
        ),
        onPressed: () {
          _tradeMainProvider!.toggleExpandWidget();
          _ladderProvider!.toggleExpandLadderExpansionTile =
              _tradeMainProvider!.expandWidget;
        },
        label: Text(
          _tradeMainProvider!.expandWidget ? "Collapse All" : "Expand All",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: defaultTheme ? Colors.blue : Color(0xFF0099CC),
          ),
        ),
      ),
    );
  }

  Widget expandCollapseLadderValueButton(defaultTheme) {
    return SizedBox(
      width: 120,
      child: TextButton.icon(
        icon: Icon(
          Icons.expand,
          color: defaultTheme ? Colors.blue : Color(0xFF0099CC),
          size: 21,
        ),
        onPressed: () {
          _ladderProvider!
              .toggleAllVisible(!_ladderProvider!.toggleAllVisibleValue);
        },
        label: Text(
          ladderProvider.toggleAllVisibleValue
              ? "Collapse Ladder"
              : "Expand Ladder",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: defaultTheme ? Colors.blue : Color(0xFF0099CC),
          ),
        ),
      ),
    );
  }

  Widget increDecreStockPriceBtn({required TradeMainProvider tradeMainState}) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                children: [
                  Container(
                    width: screenWidthRecognizer(context) * 0.3,
                    child: const Text(
                      "Tick By Tick",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: screenWidthRecognizer(context) * 0.33,
                    child: tradeMainState.isLoading
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            margin: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: CircularProgressIndicator())
                        : DropdownButtonHideUnderline(
                            child: DropdownButton<SimulateTicker>(
                            onChanged: (SimulateTicker? value) {
                              tradeMainState.updateSelectedTickerForSimulation =
                                  value;
                            },
                            dropdownColor: (themeProvider.defaultTheme)
                                ? Colors.white
                                : Colors.black,
                            value: tradeMainState.selectedTickerForSimulation,
                            items: tradeMainState.activeLadderTickers
                                .map((tickerDetail) =>
                                    DropdownMenuItem<SimulateTicker>(
                                      child: Text(
                                        tickerDetail.ticker,
                                        style: TextStyle(
                                            color: (themeProvider.defaultTheme)
                                                ? Colors.black
                                                : Colors.white),
                                      ),
                                      value: tickerDetail,
                                    ))
                                .toList(),
                          )),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: (themeProvider.defaultTheme)
                                ? Colors.black
                                : Colors.white),
                        borderRadius: BorderRadius.circular(5)),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    height: 45,
                  ),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                          width: screenWidthRecognizer(context) * 0.14,
                          child: Text(
                              "Multiplier",
                            overflow: TextOverflow.ellipsis,
                          )),
                      SizedBox(
                        height: 27,
                        width: 27,
                        child: InfoIconDisplay().infoIconDisplay(
                          context,
                          termsInfoConstant.titleStepSizeMultipler,
                          termsInfoConstant.messageStepSizeMultipler,
                          color: (themeProvider.defaultTheme)
                              ? Colors.black
                              : Colors.white,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 45,
                    width: screenWidthRecognizer(context) * 0.12,
                    // width: 60,
                    child: TextFormField(
                      controller: _multiplierController,
                      cursorColor: Colors.white, // White cursor
                      style: TextStyle(
                          color: (themeProvider.defaultTheme)
                              ? Colors.black
                              : Colors.white), // White text color
                      keyboardType: TextInputType.number,

                      decoration: InputDecoration(
                        prefixText: 'X ',
                        prefixStyle: TextStyle(
                            color: (themeProvider.defaultTheme)
                                ? Colors.black
                                : Colors.white), // White prefix text color
                        hintText: '1',
                        hintStyle: TextStyle(
                            color: (themeProvider.defaultTheme)
                                ? Colors.black
                                : Colors.white70), // Hint text color in white
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: (themeProvider.defaultTheme)
                                  ? Colors.black
                                  : Colors.white), // White border color
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: (themeProvider.defaultTheme)
                                  ? Colors.black
                                  : Colors
                                      .white), // White border for enabled state
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: (themeProvider.defaultTheme)
                                  ? Colors.black
                                  : Colors.white), // White border when focused
                        ),
                        counterStyle: TextStyle(
                            color: (themeProvider.defaultTheme)
                                ? Colors.black
                                : Colors.white), // White counter text color
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a number';
                        }
                        if (value.length < 2) {
                          // Adjusted to check for a 2-digit number
                          return 'Please enter a 2-digit number';
                        }
                        return null;
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              if (_tradeMainProvider?.simulationVisibility == true)
                Container(
                    height: 30,
                    width: 30,
                    // decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(1000)),
                    child: threeDButton(
                        height: 20,
                        onTap: () async {
                          if (_isWaiting) {
                            return; // Prevent further actions during delay
                          }

                          _isWaiting =
                              true; // Set the flag to true to indicate waiting state
                          // await Future.delayed(
                          //     Duration(seconds: 2)); // Add the delay
                          try {
                            if (_tradeMainProvider!
                                        .selectedTickerForSimulation.ticker !=
                                    "Select ticker" &&
                                _tradeMainProvider?.simulationVisibility ==
                                    true) {
                              // await Future.delayed(Duration(seconds: 2));
                              double multiplierValue =
                                  double.tryParse(_multiplierController.text) ??
                                      1;
                              await simulation(
                                  multiplierValue,
                                  _tradeMainProvider!
                                      .selectedTickerForSimulation.tickerId,
                                  context);
                              refreshDataAtSimulation();
                              tradeMainState.getActiveLadderTickers(context,
                                  fromSimulationButtonUPAndDown: true);
                              Fluttertoast.showToast(
                                  msg: "Price increased",
                                  backgroundColor: Colors.green);
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                      "Please select ticker from dropdown for simulation");
                            }
                          } catch (error) {
                            print("Here is the error: ${error}");
                          } finally {
                            _isWaiting = false;
                          }
                        },
                        backgroundColor:
                            _tradeMainProvider?.colorOfIncrementButton,
                        child: Container(
                          height: 30,
                          width: 30,
                          child: Center(
                            child: FaIcon(
                              // FontAwesomeIcons.circleArrowUp,
                              FontAwesomeIcons.arrowUp,
                              color: Colors
                                  .white, //_tradeMainProvider?.colorOfIncrementButton,
                              size: 15,
                            ),
                          ),
                        ))
                    // child: InkWell(
                    //     highlightColor: Colors.transparent,
                    //     splashFactory: NoSplash.splashFactory,
                    //     onTapDown: (details) => {
                    //           _tradeMainProvider?.colorOfIncrementButton =
                    //               Colors.purple
                    //         },
                    //     onTapUp: (details) => {
                    //           _tradeMainProvider?.colorOfIncrementButton =
                    //               Colors.green
                    //         },
                    //     onTap: () async {
                    //       if (_tradeMainProvider!
                    //                   .selectedTickerForSimulation.ticker !=
                    //               "Select ticker" &&
                    //           _tradeMainProvider?.simulationVisibility == true) {
                    //         double multiplierValue =
                    //             double.tryParse(_multiplierController.text) ?? 1;
                    //         await simulation(
                    //             multiplierValue,
                    //             _tradeMainProvider!
                    //                 .selectedTickerForSimulation.tickerId,
                    //             context);
                    //         refreshDataAtSimulation();
                    //         tradeMainState.getActiveLadderTickers(context,
                    //             fromSimulationButtonUPAndDown: true);
                    //         Fluttertoast.showToast(
                    //             msg: "Price increased",
                    //             backgroundColor: Colors.green);
                    //       } else {
                    //         Fluttertoast.showToast(
                    //             msg:
                    //                 "Please select ticker from dropdown for simulation");
                    //       }
                    //     },
                    //     child: FaIcon(
                    //       FontAwesomeIcons.circleArrowUp,
                    //       color: _tradeMainProvider?.colorOfIncrementButton,
                    //     )),
                    ),
              SizedBox(
                width: 10,
              ),
              if (_tradeMainProvider?.simulationVisibility == true)
                Container(
                    height: 30,
                    width: 30,
                    // decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(100)),

                    child: threeDButton(
                        height: 20,
                        onTap: () async {
                          if (_isWaiting) {
                            return; // Prevent further actions during delay
                          }

                          _isWaiting =
                              true; // Set the flag to true to indicate waiting state
                          // await Future.delayed(
                          //     Duration(seconds: 2)); // Add the delay

                          try {
                            if (_tradeMainProvider!
                                    .selectedTickerForSimulation.ticker !=
                                "Select ticker") {
                              double multiplierValue =
                                  double.tryParse(_multiplierController.text) ??
                                      1;
                              await simulation(
                                  -multiplierValue,
                                  _tradeMainProvider!
                                      .selectedTickerForSimulation.tickerId,
                                  context);
                              refreshDataAtSimulation();
                              tradeMainState.getActiveLadderTickers(context,
                                  fromSimulationButtonUPAndDown: true);
                              Fluttertoast.showToast(
                                  msg: "Price dropped",
                                  backgroundColor: Colors.red);
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                      "Please select ticker from dropdown for simulation");
                            }
                          } catch (error) {
                            print("Error in the body: ${error}");
                          } finally {
                            _isWaiting = false;
                          }
                        },
                        backgroundColor:
                            _tradeMainProvider?.colorOfDecrementButton,
                        child: Container(
                          height: 30,
                          width: 30,
                          child: Center(
                            child: FaIcon(
                              // FontAwesomeIcons.circleArrowUp,
                              FontAwesomeIcons.arrowDown,
                              color: Colors
                                  .white, //_tradeMainProvider?.colorOfIncrementButton,
                              size: 15,
                            ),
                          ),
                        ))
                    // child: InkWell(
                    //   highlightColor: Colors.transparent,
                    //   splashFactory: NoSplash.splashFactory,
                    //   onTapDown: (details) => {
                    //     _tradeMainProvider?.colorOfDecrementButton = Colors.yellow
                    //     // Color.fromARGB(255, 255, 0, 85)
                    //   },
                    //   onTapUp: (details) => {
                    //     _tradeMainProvider?.colorOfDecrementButton = Colors.red
                    //   },
                    //   onTap: () async {
                    //     if (_tradeMainProvider!
                    //             .selectedTickerForSimulation.ticker !=
                    //         "Select ticker") {
                    //       double multiplierValue =
                    //           double.tryParse(_multiplierController.text) ?? 1;
                    //       await simulation(
                    //           -multiplierValue,
                    //           _tradeMainProvider!
                    //               .selectedTickerForSimulation.tickerId,
                    //           context);
                    //       refreshDataAtSimulation();
                    //       tradeMainState.getActiveLadderTickers(context,
                    //           fromSimulationButtonUPAndDown: true);
                    //       Fluttertoast.showToast(
                    //           msg: "Price dropped", backgroundColor: Colors.red);
                    //     } else {
                    //       Fluttertoast.showToast(
                    //           msg:
                    //               "Please select ticker from dropdown for simulation");
                    //     }
                    //   },
                    //   child: FaIcon(
                    //     FontAwesomeIcons.circleArrowDown,
                    //     color: _tradeMainProvider?.colorOfDecrementButton,
                    //   ),
                    // ),
                    ),
              SizedBox(
                width: 20,
              ),
              if (_tradeMainProvider?.simulationVisibility == true)
                Container(
                  height: 30,
                  width: 30,
                  child: threeDButton(
                      height: 20,
                      onTap: () async {
                        if (_isWaiting) {
                          return; // Prevent further actions during delay
                        }

                        _isWaiting =
                            true; // Set the flag to true to indicate waiting state
                        // await Future.delayed(
                        //     Duration(seconds: 2)); // Add the delay
                        try {
                          if (_tradeMainProvider!
                                      .selectedTickerForSimulation.ticker !=
                                  "Select ticker" &&
                              _tradeMainProvider?.simulationVisibility ==
                                  true) {
                            // await Future.delayed(Duration(seconds: 2));
                            double multiplierValue = 0;
                            await simulation(
                                multiplierValue,
                                _tradeMainProvider!
                                    .selectedTickerForSimulation.tickerId,
                                context);
                            refreshDataAtSimulation();
                            tradeMainState.getActiveLadderTickers(context,
                                fromSimulationButtonUPAndDown: true);
                            Fluttertoast.showToast(
                                msg: "New Price updated",
                                backgroundColor: Colors.blue);
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    "Please select ticker from dropdown for simulation");
                          }
                        } catch (error) {
                          print("Here is the error: ${error}");
                        } finally {
                          _isWaiting = false;
                        }
                      },
                      backgroundColor: Colors.blue,
                      child: Container(
                          height: 30,
                          width: 30,
                          child: Center(
                            child: Icon(
                              CupertinoIcons.arrow_left_right,
                              color: Colors.white,
                              size: 15,
                            ),
                          ))),
                ),
              SizedBox(
                width: 50,
              ),
              _tradeMainProvider!.selectedTickerForSimulation.ticker !=
                      "Select ticker"
                  ? Container(
                      width: screenWidthRecognizer(context) * 0.15,
                      child: Text(
                          "${(((tradeMainState.ladCurrentPrice[tradeMainState.selectedTickerForSimulation.tickerId.toString()] ?? 0) - (tradeMainState.firstLadderInitialBuyPrice[tradeMainState.selectedTickerForSimulation.tickerId.toString()] ?? 0)) / (tradeMainState.ladStepSize[tradeMainState.selectedTickerForSimulation.tickerId.toString()] ?? 0)).toStringAsFixed(2)} / ${((tradeMainState.ladCurrentPrice[tradeMainState.selectedTickerForSimulation.tickerId.toString()] ?? 0) - (tradeMainState.firstLadderInitialBuyPrice[tradeMainState.selectedTickerForSimulation.tickerId.toString()] ?? 0)).toStringAsFixed(2)}"),
                    )
                  : SizedBox(),
            ],
          ),
        ],
      ),
    );
  }

  Widget floatingActionBtnWidget(double screenWidth) {
    return Container(
        width: screenWidth == 0 ? null : screenWidth,
        margin: EdgeInsets.only(right: 10, top: 10, bottom: 5),
        alignment: Alignment.bottomRight,
        child: _tabController.index == 4
            ? FloatingActionButton.extended(
                label: const Text("Add New Ladder"),
                backgroundColor: const Color(0xff2596be),
                elevation: 20,
                onPressed: () {
                  navigationProvider.selectedIndex = 1;
                },
              )
            : null);
  }

  Widget togglePriceAboveTradeReturnBtn() {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: Align(
        alignment: Alignment.centerRight,
        child: AdvancedSwitch(
          controller: _toggleController,
          activeColor: const Color(0xFF15181F),
          inactiveColor: const Color(0xFF15181F),
          activeChild: FittedBox(
            child: Text(
              "Price above",
              style: TextStyle(
                fontSize: 14,
              ),
              softWrap: true,
            ),
          ),
          inactiveChild: FittedBox(
            child: Text(
              "Trade return",
              style: TextStyle(
                fontSize: 14,
              ),
              softWrap: true,
            ),
          ),
          thumb: Icon(
            Icons.sync,
            color: Color(0xFF0099CC),
          ),
          borderRadius: BorderRadius.circular(5),
          height: 35,
          width: 110,
        ),
      ),
    );
  }

  Widget setDownloadCsvDialog() {
    switch (_tabController.index) {
      case 3:
        {
          return Consumer<ThemeProvider>(builder: (context, value, child) {
            return _tradeMainProvider?.isAbleToSendCsv.position ?? false
                ? positionCsvDialog(value.defaultTheme)
                : SizedBox(
                    height: 10,
                  );
          });
        }
      case 0:
        {
          return Consumer<ThemeProvider>(builder: (context, value, child) {
            return _tradeMainProvider?.isAbleToSendCsv.ladder ?? false
                ? ladderCsvDialog(value.defaultTheme)
                : SizedBox(
                    height: 10,
                  );
          });
        }
      case 1:
        {
          return Consumer<ThemeProvider>(builder: (context, value, child) {
            return _tradeMainProvider?.isAbleToSendCsv.trade ?? false
                ? tradeCsvDialog(value.defaultTheme)
                : SizedBox(height: 10);
          });
        }
      case 2:
        {
          return Consumer<ThemeProvider>(builder: (context, value, child) {
            return _tradeMainProvider?.isAbleToSendCsv.openOrder ?? false
                ? orderCsvDialog(value.defaultTheme)
                : SizedBox(
                    height: 10,
                  );
          });
        }
      case 4:
        {
          return Consumer<ThemeProvider>(builder: (context, value, child) {
            return _tradeMainProvider?.isAbleToSendCsv.activity ?? false
                ? activityDownloadCsvDialog(value.defaultTheme)
                : SizedBox(
                    height: 10,
                  );
          });
        }
      default:
        {
          return Consumer<ThemeProvider>(builder: (context, value, child) {
            return _tradeMainProvider?.isAbleToSendCsv.ladder ?? false
                ? ladderCsvDialog(value.defaultTheme)
                : SizedBox();
          });
        }
    }
  }

  Widget tradeTabBarBtnWidget() {
    if (_orderProvider!.isSuperUser) {
      tabsButtonVisibility = [
        () {
          _ladderProvider?.defaultVisibilitySOfLadderBtns = 0;
        },
        () {
          if (_tradesProvider!.trades != null) {
            _tradesProvider?.defaultVisibilitySOfTradesBtns =
                _tradesProvider!.trades!.data!.length;
          }
        },
        () {
          if (_orderProvider!.orders != null) {
            _orderProvider?.defaultVisibilitySOfOrderBtns =
                _orderProvider!.orders!.data!.length;
          }
        },
        () {
          if (_orderProvider!.orders != null) {
            _orderProvider?.defaultVisibilitySOfHiddenOrderBtns =
                _orderProvider!.hiddenOrders!.data!.length;
          }
        },
        () {
          if (_positionProvider!.positions != null) {
            _positionProvider?.defaultVisibilitySOfPositionBtns =
                _positionProvider!.positions!.data!.length;
          }
        },
      ];
    } else {
      tabsButtonVisibility = [
        () {
          _ladderProvider?.defaultVisibilitySOfLadderBtns = 0;
        },
        () {
          if (_tradesProvider!.trades != null) {
            _tradesProvider?.defaultVisibilitySOfTradesBtns =
                _tradesProvider!.trades!.data!.length;
          }
        },
        () {
          if (_orderProvider!.orders != null) {
            _orderProvider?.defaultVisibilitySOfOrderBtns =
                _orderProvider!.orders!.data!.length;
          }
        },
        () {
          if (_positionProvider!.positions != null) {
            _positionProvider?.defaultVisibilitySOfPositionBtns =
                _positionProvider!.positions!.data!.length;
          }
        },
      ];
    }

    return TabBar(
      isScrollable: true,

      // tabAlignment: TabAlignment.start,
      indicatorPadding: EdgeInsets.zero,
      labelPadding: const EdgeInsets.symmetric(horizontal: 0),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      onTap: (value) {
        // tabsButtonVisibility[1]();
        // print("function is being executed");
        for (int i = 0; i < 4; i++) {
          if (value != i && _tradeMainProvider!.singleLadderExist) {
            tabsButtonVisibility[i]();
          }
        }

        _tradeMainProvider!.updateTabBarIndex = value;
      },
      // isScrollable: true,
      controller: _tabController,
      // tabs: _tabs,
      tabs: (_orderProvider!.isSuperUser)
          ? [
              Tab(child:
                  Consumer<ThemeProvider>(builder: (context, value, child) {
                return Container(
                    margin: EdgeInsets.all(10),
                    child: Text("Ladders",
                        style: TextStyle(
                            color: (tradeMainProvider.tabBarIndex == 0)
                                ? Colors.blue
                                : value.defaultTheme
                                    ? Colors.black
                                    : Colors.white)));
              })),
              Tab(child:
                  Consumer<ThemeProvider>(builder: (context, value, child) {
                return Container(
                    margin: const EdgeInsets.all(10),
                    child: Text("Trades",
                        style: TextStyle(
                            color: (tradeMainProvider.tabBarIndex == 1)
                                ? Colors.blue
                                : value.defaultTheme
                                    ? Colors.black
                                    : Colors.white)));
              })),
              Tab(child:
                  Consumer<ThemeProvider>(builder: (context, value, child) {
                return Container(
                    margin: const EdgeInsets.all(10),
                    child: Text("Orders",
                        style: TextStyle(
                            color: (tradeMainProvider.tabBarIndex == 2)
                                ? Colors.blue
                                : value.defaultTheme
                                    ? Colors.black
                                    : Colors.white)));
              })),
              Tab(child:
                  Consumer<ThemeProvider>(builder: (context, value, child) {
                return Container(
                    margin: const EdgeInsets.all(10),
                    child: Text("Hidden Orders",
                        style: TextStyle(
                            color: (_orderProvider!.isSuperUser &&
                                    tradeMainProvider.tabBarIndex == 3)
                                ? Colors.blue
                                : (_orderProvider!.isSuperUser == false &&
                                        tradeMainProvider.tabBarIndex == 2)
                                    ? Colors.blue
                                    : value.defaultTheme
                                        ? Colors.black
                                        : Colors.white)));
              })),
              Tab(child:
                  Consumer<ThemeProvider>(builder: (context, value, child) {
                return Container(
                    margin: const EdgeInsets.all(10),
                    child: Text("Positions",
                        style: TextStyle(
                            color: (_orderProvider!.isSuperUser &&
                                    tradeMainProvider.tabBarIndex == 4)
                                ? Colors.blue
                                : (_orderProvider!.isSuperUser == false &&
                                        tradeMainProvider.tabBarIndex == 3)
                                    ? Colors.blue
                                    : value.defaultTheme
                                        ? Colors.black
                                        : Colors.white)));
              })),
              Tab(child:
                  Consumer<ThemeProvider>(builder: (context, value, child) {
                return Container(
                    margin: const EdgeInsets.all(10),
                    child: Text("Activity",
                        style: TextStyle(
                            color: (_orderProvider!.isSuperUser &&
                                    tradeMainProvider.tabBarIndex == 5)
                                ? Colors.blue
                                : (_orderProvider!.isSuperUser == false &&
                                        tradeMainProvider.tabBarIndex == 4)
                                    ? Colors.blue
                                    : value.defaultTheme
                                        ? Colors.black
                                        : Colors.white)));
              })),
            ]
          : [
              Tab(child:
                  Consumer<ThemeProvider>(builder: (context, value, child) {
                return Container(
                    margin: EdgeInsets.all(10),
                    child: Text("Ladders",
                        style: TextStyle(
                            color: (tradeMainProvider.tabBarIndex == 0)
                                ? Colors.blue
                                : value.defaultTheme
                                    ? Colors.black
                                    : Colors.white)));
              })),
              Tab(child:
                  Consumer<ThemeProvider>(builder: (context, value, child) {
                return Container(
                    margin: const EdgeInsets.all(10),
                    child: Text("Trades",
                        style: TextStyle(
                            color: (tradeMainProvider.tabBarIndex == 1)
                                ? Colors.blue
                                : value.defaultTheme
                                    ? Colors.black
                                    : Colors.white)));
              })),
              Tab(child:
                  Consumer<ThemeProvider>(builder: (context, value, child) {
                return Container(
                    margin: const EdgeInsets.all(10),
                    child: Text("Orders",
                        style: TextStyle(
                            color: (tradeMainProvider.tabBarIndex == 2)
                                ? Colors.blue
                                : value.defaultTheme
                                    ? Colors.black
                                    : Colors.white)));
              })),
              Tab(child:
                  Consumer<ThemeProvider>(builder: (context, value, child) {
                return Container(
                    margin: const EdgeInsets.all(10),
                    child: Text("Positions",
                        style: TextStyle(
                            color: (tradeMainProvider.tabBarIndex == 3)
                                ? Colors.blue
                                : value.defaultTheme
                                    ? Colors.black
                                    : Colors.white)));
              })),
              Tab(child:
                  Consumer<ThemeProvider>(builder: (context, value, child) {
                return Container(
                    margin: const EdgeInsets.all(10),
                    child: Text("Activity",
                        style: TextStyle(
                            color: (tradeMainProvider.tabBarIndex == 4)
                                ? Colors.blue
                                : value.defaultTheme
                                    ? Colors.black
                                    : Colors.white)));
              })),
            ],
    );
  }

  Widget ladderActiveDeactiveBtn({TradeMainProvider? tradeMainState}) {
    return tradeMainState!.singleActiveLadderStatus == null
        ? CircularProgressIndicator()
        : tradeMainState.singleActiveLadderStatus!
            ? ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.purple)),
                onPressed: () {
                  if(Utility().checkForSubscription(context)) {
                    activateAllLadderDialog(context, true);
                  }

                },
                child: Text("Deactivate All the Ladders",
                    style: TextStyle(fontSize: 12, color: Colors.white)))
            : ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.green)),
                onPressed: () {
                  activateAllLadderDialog(context, false);
                  _tradeMainProvider!
                      .getTradeMenuButtonsVisibilityStatus()
                      .catchError((err) {});
                },
                child: Text("Activate All the Ladders",
                    style: TextStyle(
                        fontSize: 12,
                        color: (themeProvider.defaultTheme)
                            ? Colors.white
                            : Colors.white)));
  }

  Widget tradeTabBarChildrenWidget(
      {required TradeMainProvider tradeMainState}) {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        dragStartBehavior: DragStartBehavior.down,
        children: (_orderProvider!.isSuperUser)
            ? [
                LadderTab(
                    initiallyExpanded: tradeMainState.expandWidget,
                    ladderlist: ladderlist1,
                    ladderDataRequest: getLadderDataRequest,
                    selectedTicker: selectedTickerSimulation != "Select ticker"
                        ? selectedTickerSimulation
                        : null),
                TradesTab(
                    toggleReturnPrice: _toggledOption,
                    selectedTicker: selectedTickerSimulation != "Select ticker"
                        ? selectedTickerSimulation
                        : null),
                OrdersTab(
                    selectedTicker: selectedTickerSimulation != "Select ticker"
                        ? selectedTickerSimulation
                        : null),

                HiddenOrdersTab(
                    selectedTicker: selectedTickerSimulation != "Select ticker"
                        ? selectedTickerSimulation
                        : null),

                PositionsTab(
                    selectedTicker: selectedTickerSimulation != "Select ticker"
                        ? selectedTickerSimulation
                        : null),

                const ActivityTab(),

                // const FavoriteTab()
              ]
            : [
                LadderTab(
                    initiallyExpanded: tradeMainState.expandWidget,
                    ladderlist: ladderlist1,
                    ladderDataRequest: getLadderDataRequest,
                    selectedTicker: selectedTickerSimulation != "Select ticker"
                        ? selectedTickerSimulation
                        : null),
                TradesTab(
                    toggleReturnPrice: _toggledOption,
                    selectedTicker: selectedTickerSimulation != "Select ticker"
                        ? selectedTickerSimulation
                        : null),
                OrdersTab(
                    selectedTicker: selectedTickerSimulation != "Select ticker"
                        ? selectedTickerSimulation
                        : null),

                PositionsTab(
                    selectedTicker: selectedTickerSimulation != "Select ticker"
                        ? selectedTickerSimulation
                        : null),

                const ActivityTab(),

                // const FavoriteTab()
              ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    tradeMainProvider = Provider.of<TradeMainProvider>(context, listen: true);
    ladderProvider = Provider.of<LadderProvider>(context, listen: true);
    double screenWidth = screenWidthRecognizer(context);
    return Consumer<TradeMainProvider>(builder: (_, state, __) {
      Widget downloadCsv = setDownloadCsvDialog();

      // if(MediaQuery.of(context).size.width >= 1366) {
      if (false) {
        return buildTradeForDesktop(context);
      } else {
        return (_orderProvider!.isSuperUser)
            ? DefaultTabController(
                length: 6,
                child: Scaffold(
                  key: _key,
                  drawer:
                  NavDrawerNew(updateIndex: widget.updateIndex),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.miniEndFloat,
                  body: SafeArea(
                    child: Stack(
                      children: [
                        Padding(
                          // padding: const EdgeInsets.only(top: 60.0),
                          padding: const EdgeInsets.only(top: 45.0),
                          child: Center(
                            child: Container(
                              color: (themeProvider.defaultTheme)
                                  ? Color(0XFFF5F5F5)
                                  : Colors.transparent,
                              width: screenWidth,
                              child: Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 20, right: 20, top: 0, bottom: 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        downloadCsv,
                                        if (_tabController.index == 0 &&
                                            state.singleLadderExist)
                                          Consumer<ThemeProvider>(
                                              builder: (context, value, child) {
                                            return Row(
                                              children: [
                                                expandCollapseLadderValueButton(
                                                    value.defaultTheme),
                                                expandCollapseLadderButton(
                                                    value.defaultTheme),
                                              ],
                                            );
                                          }),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 20, right: 10, top: 0, bottom: 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        if (_tradeMainProvider!.singleLadderExist &&
                                            !_tradeMainProvider!
                                                .simulationVisibility)
                                          _tradeMainProvider
                                                      ?.singleActiveLadderStatus ??
                                                  false
                                              ? ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStatePropertyAll(
                                                              Colors.purple)),
                                                  onPressed: () {
                                                    activateAllLadderDialog(
                                                        context, true);
                                                  },
                                                  child: Text(
                                                      "Deactivate All the Ladders",
                                                      style: TextStyle(
                                                          color: (themeProvider
                                                                  .defaultTheme)
                                                              ? Colors.white
                                                              : Colors.white)))
                                              : ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStatePropertyAll(
                                                              Colors.green)),
                                                  onPressed: () {
                                                    activateAllLadderDialog(
                                                        context, false);
                                                    _tradeMainProvider!
                                                        .getTradeMenuButtonsVisibilityStatus();
                                                  },
                                                  child: Text(
                                                      "Activate All the Ladders",
                                                      style: TextStyle(color: (themeProvider.defaultTheme) ? Colors.white : Colors.white))),
                                        if (_tradeMainProvider
                                                    ?.tradingOptions ==
                                                TradingOptions
                                                    .simulationTradingWithSimulatedPrices &&
                                            _tradeMainProvider!
                                                .singleLadderExist &&
                                            _tradeMainProvider!
                                                .simulationVisibility)
                                          increDecreStockPriceBtn(
                                              tradeMainState: state),
                                        Column(
                                          children: [
                                            if (state.singleLadderExist)
                                              startStopTradingBtn(),
                                            if (_tabController.index == 1 &&
                                                state.singleLadderExist &&
                                                _tradesProvider!.trades !=
                                                    null &&
                                                _tradesProvider!
                                                    .trades!.data!.isNotEmpty)
                                              togglePriceAboveTradeReturnBtn(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  tradeTabBarBtnWidget(),
                                  tradeTabBarChildrenWidget(
                                      tradeMainState: state),

                                  // floatingActionBtnWidget(),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (widget.enableBackButton == false &&
                            widget.enableMenuButton == true)
                          CustomHomeAppBarWithProviderNew(
                            backButton: false,
                            leadingAction:
                                _triggerDrawer, //these leadingAction button is not working, I have tired making it work, but it isn't.
                          ),
                      ],
                    ),
                  ),
                ),
              )
            : DefaultTabController(
                // length: (_orderProvider!.isSuperUser)?6:5,
                length: 5,
                child: Scaffold(
                  key: _key,
                  drawer:
                      // NavigationDrawerWidget(updateIndex: widget.updateIndex),
                      NavDrawerNew(updateIndex: widget.updateIndex),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.miniEndFloat,
                  body: SafeArea(
                    child: Stack(
                      children: [
                        Padding(
                          // padding: const EdgeInsets.only(top: 60.0),
                          padding: const EdgeInsets.only(top: 45.0),
                          child: Center(
                            child: Container(
                              color: (themeProvider.defaultTheme)
                                  ? Color(0XFFF5F5F5)
                                  : Colors.transparent,
                              width: screenWidth,
                              child: Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 20, right: 20, top: 0, bottom: 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        downloadCsv,
                                        if (_tabController.index == 0 &&
                                            state.singleLadderExist)
                                          Consumer<ThemeProvider>(
                                              builder: (context, value, child) {
                                            return Row(
                                              children: [
                                                expandCollapseLadderValueButton(
                                                    value.defaultTheme),
                                                expandCollapseLadderButton(
                                                    value.defaultTheme),
                                              ],
                                            );
                                          }),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 20, right: 10, top: 0, bottom: 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        if (_tradeMainProvider!.singleLadderExist &&
                                            !_tradeMainProvider!
                                                .simulationVisibility)
                                          _tradeMainProvider
                                                      ?.singleActiveLadderStatus ??
                                                  false
                                              ? ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStatePropertyAll(
                                                              Colors.purple)),
                                                  onPressed: () {
                                                    activateAllLadderDialog(
                                                        context, true);
                                                  },
                                                  child: Text(
                                                      "Deactivate All the Ladders",
                                                      style: TextStyle(
                                                          color: (themeProvider
                                                                  .defaultTheme)
                                                              ? Colors.white
                                                              : Colors.white)))
                                              : ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStatePropertyAll(
                                                              Colors.green)),
                                                  onPressed: () {
                                                    activateAllLadderDialog(
                                                        context, false);
                                                    _tradeMainProvider!
                                                        .getTradeMenuButtonsVisibilityStatus();
                                                  },
                                                  child: Text(
                                                      "Activate All the Ladders",
                                                      style: TextStyle(color: (themeProvider.defaultTheme) ? Colors.white : Colors.white))),
                                        if (_tradeMainProvider
                                                    ?.tradingOptions ==
                                                TradingOptions
                                                    .simulationTradingWithSimulatedPrices &&
                                            _tradeMainProvider!
                                                .singleLadderExist &&
                                            _tradeMainProvider!
                                                .simulationVisibility)
                                          increDecreStockPriceBtn(
                                              tradeMainState: state),
                                        Column(
                                          children: [
                                            if (state.singleLadderExist)
                                              startStopTradingBtn(),
                                            if (_tabController.index == 1 &&
                                                state.singleLadderExist &&
                                                _tradesProvider!.trades !=
                                                    null &&
                                                _tradesProvider!
                                                    .trades!.data!.isNotEmpty)
                                              togglePriceAboveTradeReturnBtn(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  tradeTabBarBtnWidget(),
                                  tradeTabBarChildrenWidget(
                                      tradeMainState: state),

                                  // floatingActionBtnWidget(),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (widget.enableBackButton == false &&
                            widget.enableMenuButton == true)
                          CustomHomeAppBarWithProviderNew(
                            backButton: false,
                            leadingAction:
                                _triggerDrawer, //these leadingAction button is not working, I have tired making it work, but it isn't.
                          ),
                      ],
                    ),
                  ),
                ),
              );
      }
    });
  }

  Widget buildTradeForDesktop(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 55.0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                    left: 20, right: 20, top: 0, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_tabController.index == 0 &&
                        tradeMainProvider.singleLadderExist)
                      Consumer<ThemeProvider>(builder: (context, value, child) {
                        return Row(
                          children: [
                            expandCollapseLadderValueButton(value.defaultTheme),
                            expandCollapseLadderButton(value.defaultTheme),
                          ],
                        );
                      }),
                  ],
                ),
              ),
              (_orderProvider!.isSuperUser)
                  ? Row(children: [
                      Expanded(
                        flex: 4,
                        child: LadderTab(
                            initiallyExpanded: tradeMainProvider.expandWidget,
                            ladderlist: ladderlist1,
                            ladderDataRequest: getLadderDataRequest,
                            selectedTicker:
                                selectedTickerSimulation != "Select ticker"
                                    ? selectedTickerSimulation
                                    : null),
                      ),
                      Expanded(
                        flex: 2,
                        child: TradesTab(
                            toggleReturnPrice: _toggledOption,
                            selectedTicker:
                                selectedTickerSimulation != "Select ticker"
                                    ? selectedTickerSimulation
                                    : null),
                      ),
                      Expanded(
                        flex: 3,
                        child: OrdersTab(
                            selectedTicker:
                                selectedTickerSimulation != "Select ticker"
                                    ? selectedTickerSimulation
                                    : null),
                      ),
                      Expanded(
                        flex: 3,
                        child: HiddenOrdersTab(
                            selectedTicker:
                                selectedTickerSimulation != "Select ticker"
                                    ? selectedTickerSimulation
                                    : null),
                      ),
                      Expanded(
                        flex: 2,
                        child: PositionsTab(
                            selectedTicker:
                                selectedTickerSimulation != "Select ticker"
                                    ? selectedTickerSimulation
                                    : null),
                      ),
                      Expanded(
                        flex: 3,
                        child: const ActivityTab(),
                      ),
                    ])
                  : Row(children: [
                      Expanded(
                        flex: 4,
                        child: LadderTab(
                            initiallyExpanded: tradeMainProvider.expandWidget,
                            ladderlist: ladderlist1,
                            ladderDataRequest: getLadderDataRequest,
                            selectedTicker:
                                selectedTickerSimulation != "Select ticker"
                                    ? selectedTickerSimulation
                                    : null),
                      ),
                      Expanded(
                        flex: 2,
                        child: TradesTab(
                            toggleReturnPrice: _toggledOption,
                            selectedTicker:
                                selectedTickerSimulation != "Select ticker"
                                    ? selectedTickerSimulation
                                    : null),
                      ),
                      Expanded(
                        flex: 3,
                        child: OrdersTab(
                            selectedTicker:
                                selectedTickerSimulation != "Select ticker"
                                    ? selectedTickerSimulation
                                    : null),
                      ),
                      Expanded(
                        flex: 2,
                        child: PositionsTab(
                            selectedTicker:
                                selectedTickerSimulation != "Select ticker"
                                    ? selectedTickerSimulation
                                    : null),
                      ),
                      Expanded(
                        flex: 3,
                        child: const ActivityTab(),
                      ),
                    ]),
            ],
          ),
        ),
        if (widget.enableBackButton == false && widget.enableMenuButton == true)
          CustomHomeAppBarWithProviderNew(
            backButton: false,
            leadingAction:
                _triggerDrawer, //these leadingAction button is not working, I have tired making it work, but it isn't.
          ),
      ],
    );
  }
}
