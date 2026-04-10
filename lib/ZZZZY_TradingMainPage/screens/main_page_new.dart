import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../AA_positions/screens/position_tab.dart';
import '../../AA_positions/screens/position_tab_new.dart';
import '../../AA_positions/stateManagement/position_provider.dart';
import '../../AA_positions/widgets/position_csv_confirm_dialog.dart';
import '../../AB_Ladder/screens/ladder_tab.dart';
import '../../AB_Ladder/screens/ladder_tab_new.dart';
import '../../AB_Ladder/stateManagement/ladder_provider.dart';
import '../../AB_Ladder/widgets/ladder_csv_confirm_dialog.dart';
import '../../AC_trades/screens/trade_tab.dart';
import '../../AC_trades/screens/trade_tab_new.dart';
import '../../AC_trades/stateManagement/trades_provider.dart';
import '../../AC_trades/widgets/trade_csv_confirm_dialog.dart';
import '../../AD_Orders/screens/hidden_order_tab.dart';
import '../../AD_Orders/screens/orders_tab.dart';
import '../../AD_Orders/screens/orders_tab_new.dart';
import '../../AD_Orders/stateManagement/order_provider.dart';
import '../../AD_Orders/widgets/order_csv_confirm_dialog.dart';
import '../../AE_Activity/screens/activity_tab.dart';
import '../../AE_Activity/stateManagement/activity_provider.dart';
import '../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../DD_Navigation/widgets/nav_drawer.dart';
import '../../DD_Navigation/widgets/nav_drawer_new.dart';
import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/stateManagement/custom_home_app_bar_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../ZS_simulate/models/simulate_stock_request.dart';
import '../../ZS_simulate/services/simulate_rest_api_service.dart';
import '../../create_ladder_detailed/constants/terms_info_contant.dart';
import '../../global/constants/currency_constants.dart';
import '../../global/constants/shared_preferences_manager.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/functions/utils.dart';
import '../../global/models/http_api_exception.dart';
import '../../global/widgets/3d_button.dart';
import '../../global/widgets/custom_container.dart';
import '../../global/widgets/info_icon_display.dart';
import '../models/start_trading_request.dart';
import '../models/toggle_all_ladder_activation_status_request.dart';
import '../services/trade_main_rest_api_service.dart';
import '../stateManagement/trade_main_provider.dart';
import 'package:dozen_diamond/ZS_simulate/models/simulate_ticker_list.dart';
import '../../global/widgets/my_text_field.dart';
import 'dart:io';

class MainPageNew extends StatefulWidget {
  final bool initiallyExpanded;
  final bool goT0LadderTab;
  final bool enableBackButton;
  final double stepSize;
  final bool enableMenuButton;
  final Function? updateIndex;
  final int goToIndex;
  final String selectedTicker;

  MainPageNew({
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
  State<MainPageNew> createState() => _MainPageNewState();
}

class _MainPageNewState extends State<MainPageNew>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  bool isError = false;
  bool isColor = false;
  bool singleActiveLadder = false;
  ValueNotifier<bool> _toggleController = ValueNotifier<bool>(false);
  bool _toggledOption = false;

  TermsInfoConstant termsInfoConstant = TermsInfoConstant();

  TextEditingController _multiplierController = TextEditingController(
    text: "1",
  );
  VoidCallback? _getLadderDataRequest;

  late NavigationProvider navigationProvider;

  String dropdownvalue = 'Sort by Date';
  List<String> list = <String>['Sort by Date', 'Sort by Alphabet'];
  final List<Color> gradientColors = [Colors.white, Colors.black38];
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
      length: 5,
      vsync: this,
      initialIndex: _tradeMainProvider!.tabBarIndex,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkIfSuperUser();
    });

    selectedTickerSimulation = activeLadderTickers[0];
    _tradeMainProvider = Provider.of(context, listen: false);

    _toggleController.addListener(() {
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
    });
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
            initialIndex: _tradeMainProvider!.tabBarIndex,
          )
        : TabController(
            length: 5,
            vsync: this,
            initialIndex: _tradeMainProvider!.tabBarIndex,
          );
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
    await TradeMainRestApiService()
        .activityDownloadCsv()
        .then((res) {
          if (res?.status == true) {
            Navigator.of(context).pop();
            Fluttertoast.showToast(
              msg: "${res?.message}",
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        })
        .catchError((err) {
          Navigator.of(context).pop();
          print("activity download csv $err");
        });
  }

  Future<void> _startTrading() async {
    _tradeMainProvider?.updateTradingStatus = null;

    TradeMainRestApiService()
        .startTrading(StartTradingRequest(actTradingStatus: false))
        .then((res) async {
          await _tradeMainProvider!.getTradeMenuButtonsVisibilityStatus();
          await refreshDataAtSimulation();
        })
        .catchError((err) {
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
       await _tradeMainProvider!.initialGetLadderData(
        _currencyConstantsProvider!,
      );
      print("ladder exist in call initialApi 4");
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
    BuildContext context,
    bool? forDeactivating,
  ) async {
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
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  forDeactivating!
                      ? "Are you sure you want to Deactivate all ladder ?"
                      : "Are you sure you want to Active all ladder ?",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextButton(
                        onPressed: () {
                          ToggleAllLadderActivationStatusRequest requestBody =
                              ToggleAllLadderActivationStatusRequest(
                                ladStatus: forDeactivating
                                    ? "INACTIVE"
                                    : "ACTIVE",
                              );
                          TradeMainRestApiService()
                              .allLadderToggleActivationStatus(requestBody)
                              .then((value) {
                                refreshDataAtSimulation();
                                Navigator.pop(context);
                                Fluttertoast.showToast(msg: value.message!);
                                _tradeMainProvider!.getActiveLadderTickers(
                                  context,
                                );
                                // bottom navigation bar navigator.push
                              });
                        },
                        child: const Text(
                          "Proceed",
                          style: TextStyle(
                            color: Color(0xFF0099CC),
                            fontSize: 16,
                          ),
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> simulation(
    double multiple,
    int stockId,
    BuildContext context,
  ) async {
    await SimulateRestApiService()
        .simulateStock(
          SimulateStockRequest(
            simulatePriceByStepSizeMultiple: multiple,
            tickerId: stockId,
          ),
        )
        .then((res) {
          if (res?.status == false) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Target price reached all stocks sold successfully",
                ),
              ),
            );
          }
        })
        .catchError((err) {
          print("simulation function error $err");
        });
  }

  List mainPageList = [];
  ThemeProvider themeProvider = new ThemeProvider();

  late TabController _tabController;

  List ladderlist1 = [];

  @override
  void dispose() {
    _tabController.dispose();
    simulationTimmer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    tradeMainProvider = Provider.of<TradeMainProvider>(context, listen: true);
    ladderProvider = Provider.of<LadderProvider>(context, listen: true);
    double screenWidth = screenWidthRecognizer(context);

    return SafeArea(
      bottom: (kIsWeb)
          ? true
          : (Platform.isIOS)
          ? false
          : true,
      child: Center(
        child: Stack(
          children: [
            Center(
              child: Container(
                width: screenWidth,
                child: Consumer<TradeMainProvider>(
                  builder: (_, state, __) {
                    Widget downloadCsv = setDownloadCsvDialog(
                      context,
                      screenWidth,
                    );
                    return DefaultTabController(
                      length: 5,
                      child: Scaffold(
                        // drawer: NavigationDrawerWidget(updateIndex: widget.updateIndex),
                        drawer: NavDrawerNew(updateIndex: widget.updateIndex),
                        key: _key,
                        // backgroundColor: Colors.red,
                        floatingActionButtonLocation:
                            FloatingActionButtonLocation.miniEndFloat,
                        backgroundColor: (themeProvider.defaultTheme)
                            ? Color(0xfff0f0f0) //Color(0XFFF5F5F5)
                            : Color(0xFF15181F),
                        body: Stack(
                          children: [
                            Column(
                              children: [
                                SizedBox(height: 45),

                                tradeTabBarBtnWidget(),

                                // SizedBox(
                                //   height: 20,
                                // ),
                                SizedBox(height: 10),

                                buildCollapseSection(context, screenWidth),

                                buildTopOptionSection(context, screenWidth),

                                SizedBox(height: 8),

                                (_tradeMainProvider?.tradingOptions ==
                                            TradingOptions
                                                .simulationTradingWithSimulatedPrices &&
                                        _tradeMainProvider!.singleLadderExist &&
                                        _tradeMainProvider!
                                            .simulationVisibility)
                                    ? buildSimulationOptionSection(
                                        context,
                                        screenWidth,
                                      )
                                    : Container(),

                                (_tradeMainProvider?.tradingOptions ==
                                            TradingOptions
                                                .simulationTradingWithSimulatedPrices &&
                                        _tradeMainProvider!.singleLadderExist &&
                                        _tradeMainProvider!
                                            .simulationVisibility)
                                    ? SizedBox(height: 8)
                                    : Container(),

                                CustomContainer(
                                  padding: 0,
                                  margin: EdgeInsets.zero,
                                  borderRadius: 0,
                                  height: 6,
                                  width: screenWidth,
                                  backgroundColor: (themeProvider.defaultTheme)
                                      ? Color(0xffdadde6)
                                      : Color(0xff2c2c31),
                                ),

                                SizedBox(height: 8),

                                // tradeTabBarBtnWidget(),

                                // SizedBox(
                                //   height: 8,
                                // ),
                                tradeTabBarChildrenWidget(
                                  tradeMainState: state,
                                ),

                                Container(),
                              ],
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
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCollapseSection(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_tabController.index == 0)
            CustomContainer(
              padding: 0,
              margin: EdgeInsets.zero,
              onTap: () {
                // _ladderProvider!
                //     .toggleAllVisible(!_ladderProvider!.toggleAllVisibleValue);

                _tradeMainProvider!.toggleExpandWidget();
                _ladderProvider!.toggleExpandLadderExpansionTile =
                    _tradeMainProvider!.expandWidget;
              },
              backgroundColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.expand,
                      size: 15,
                      color: (themeProvider.defaultTheme)
                          ? Color(0xff000000)
                          : Color(0xffffffff),
                    ),

                    SizedBox(width: 5),

                    Text(
                      // ladderProvider.toggleAllVisibleValue
                      //     ? "Collapse Ladder"
                      //     : "Expand Ladder",
                      _tradeMainProvider!.expandWidget
                          ? "Collapse All"
                          : "Expand All",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0,
                        fontSize: 13,
                        color: (themeProvider.defaultTheme)
                            ? Color(0xff000000)
                            : Color(0xffffffff),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          (_tabController.index == 3)
              ? CustomContainer(
                  padding: 0,
                  margin: EdgeInsets.zero,
                  onTap: () {
                    _tradeMainProvider!.positionsExpanded =
                        !_tradeMainProvider!.positionsExpanded;
                    _positionProvider?.isPositionsExpanded.updateAll(
                      (k, v) => _tradeMainProvider!.positionsExpanded,
                    );
                  },
                  backgroundColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.expand,
                          size: 15,
                          color: (themeProvider.defaultTheme)
                              ? Color(0xff000000)
                              : Color(0xffffffff),
                        ),

                        SizedBox(width: 5),

                        Text(
                          _tradeMainProvider!.positionsExpanded
                              ? "Collapse All Positions"
                              : "Expand All Positions",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0,
                            fontSize: 13,
                            color: (themeProvider.defaultTheme)
                                ? Color(0xff000000)
                                : Color(0xffffffff),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : (_tabController.index == 2)
              ? CustomContainer(
                  padding: 0,
                  margin: EdgeInsets.zero,
                  onTap: () {
                    _tradeMainProvider!.ordersExpanded =
                        !_tradeMainProvider!.ordersExpanded;
                    _orderProvider?.isOrdersExpanded.updateAll(
                      (k, v) => _tradeMainProvider!.ordersExpanded,
                    );
                  },
                  backgroundColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.expand,
                          size: 15,
                          color: (themeProvider.defaultTheme)
                              ? Color(0xff000000)
                              : Color(0xffffffff),
                        ),

                        SizedBox(width: 5),

                        Text(
                          _tradeMainProvider!.ordersExpanded
                              ? "Collapse All Orders"
                              : "Expand All Orders",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0,
                            fontSize: 13,
                            color: (themeProvider.defaultTheme)
                                ? Color(0xff000000)
                                : Color(0xffffffff),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : (_tabController.index == 1)
              ? CustomContainer(
                  padding: 0,
                  margin: EdgeInsets.zero,
                  onTap: () {
                    _tradeMainProvider!.tradeExpanded =
                        !_tradeMainProvider!.tradeExpanded;
                    _tradesProvider?.isTradeExpanded.updateAll(
                      (k, v) => _tradeMainProvider!.tradeExpanded,
                    );
                  },
                  backgroundColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.expand,
                          size: 15,
                          color: (themeProvider.defaultTheme)
                              ? Color(0xff000000)
                              : Color(0xffffffff),
                        ),

                        SizedBox(width: 5),

                        Text(
                          _tradeMainProvider!.tradeExpanded
                              ? "Collapse All Trades"
                              : "Expand All Trades",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0,
                            fontSize: 13,
                            color: (themeProvider.defaultTheme)
                                ? Color(0xff000000)
                                : Color(0xffffffff),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : (_tabController.index == 4)
              ? Container()
              : CustomContainer(
                  padding: 0,
                  margin: EdgeInsets.zero,
                  onTap: () {
                    print("on tap");
                    // _tradeMainProvider!.toggleExpandWidget();
                    // _ladderProvider!.toggleExpandLadderExpansionTile =
                    //     _tradeMainProvider!.expandWidget;

                    _ladderProvider!.toggleAllVisible(
                      !_ladderProvider!.toggleAllVisibleValue,
                    );
                  },
                  backgroundColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.expand,
                          size: 15,
                          color: (themeProvider.defaultTheme)
                              ? Color(0xff000000)
                              : Color(0xffffffff),
                        ),

                        SizedBox(width: 5),

                        Text(
                          ladderProvider.toggleAllVisibleValue
                              ? "Collapse Ladder"
                              : "Expand Ladder",
                          // _tradeMainProvider!.expandWidget ? "Collapse All" : "Expand All",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0,
                            fontSize: 13,
                            color: (themeProvider.defaultTheme)
                                ? Color(0xff000000)
                                : Color(0xffffffff),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget buildLadderCsvOption(BuildContext context, double screenWidth) {
    return CustomContainer(
      padding: 0,
      margin: EdgeInsets.zero,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return LadderCsvConfirmDialog();
          },
        );
      },
      backgroundColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8.0),
        child: Row(
          children: [
            Icon(
              Icons.file_download_rounded,
              size: 15,
              color: (themeProvider.defaultTheme)
                  ? Color(0xff000000)
                  : Color(0xffffffff),
            ),

            SizedBox(width: 5),

            Text(
              "Ladder CSV",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                letterSpacing: 0,
                fontSize: 13,
                color: (themeProvider.defaultTheme)
                    ? Color(0xff000000)
                    : Color(0xffffffff),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTradesCsvOption(BuildContext context, double screenWidth) {
    return CustomContainer(
      padding: 0,
      margin: EdgeInsets.zero,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return TradeCsvConfirmDialog();
          },
        );
      },
      backgroundColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8.0),
        child: Row(
          children: [
            Icon(
              Icons.file_download_rounded,
              size: 15,
              color: (themeProvider.defaultTheme)
                  ? Color(0xff000000)
                  : Color(0xffffffff),
            ),

            SizedBox(width: 5),

            Text(
              "Trades CSV",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                letterSpacing: 0,
                fontSize: 13,
                color: (themeProvider.defaultTheme)
                    ? Color(0xff000000)
                    : Color(0xffffffff),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOrdersCsvOption(BuildContext context, double screenWidth) {
    return CustomContainer(
      padding: 0,
      margin: EdgeInsets.zero,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return OrderCsvConfirmDialog();
          },
        );
      },
      backgroundColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8.0),
        child: Row(
          children: [
            Icon(
              Icons.file_download_rounded,
              size: 15,
              color: (themeProvider.defaultTheme)
                  ? Color(0xff000000)
                  : Color(0xffffffff),
            ),

            SizedBox(width: 5),

            Text(
              "Orders CSV",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                letterSpacing: 0,
                fontSize: 13,
                color: (themeProvider.defaultTheme)
                    ? Color(0xff000000)
                    : Color(0xffffffff),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPositionCsvOption(BuildContext context, double screenWidth) {
    return CustomContainer(
      padding: 0,
      margin: EdgeInsets.zero,
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) {
            return PositionCsvConfirmDialog();
          },
        );
      },
      backgroundColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8.0),
        child: Row(
          children: [
            Icon(
              Icons.file_download_rounded,
              size: 15,
              color: (themeProvider.defaultTheme)
                  ? Color(0xff000000)
                  : Color(0xffffffff),
            ),

            SizedBox(width: 5),

            Text(
              "Position CSV",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                letterSpacing: 0,
                fontSize: 13,
                color: (themeProvider.defaultTheme)
                    ? Color(0xff000000)
                    : Color(0xffffffff),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildActivityCsvOption(BuildContext context, double screenWidth) {
    return CustomContainer(
      padding: 0,
      margin: EdgeInsets.zero,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, localSetState) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                    side: const BorderSide(color: Colors.white, width: 1),
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
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
        );
      },
      backgroundColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8.0),
        child: Row(
          children: [
            Icon(
              Icons.file_download_rounded,
              size: 15,
              color: (themeProvider.defaultTheme)
                  ? Color(0xff000000)
                  : Color(0xffffffff),
            ),

            SizedBox(width: 5),

            Text(
              "Activity CSV",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                letterSpacing: 0,
                fontSize: 13,
                color: (themeProvider.defaultTheme)
                    ? Color(0xff000000)
                    : Color(0xffffffff),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTopOptionSection(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16.0),
      child: Column(
        children: [
          buildMiddleOptions(context, screenWidth),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              setDownloadCsvDialog(context, screenWidth),

              // ConstrainedBox(
              //   constraints: BoxConstraints(
              //     minWidth: screenWidth * 0.01,
              //     maxWidth: screenWidth * 0.1,
              //   ),
              // ),

              // SizedBox(
              //   width: screenWidth * 0.05,
              // ),

              // buildMiddleOptions(context, screenWidth),

              // SizedBox(
              //   width: screenWidth * 0.05,
              // ),

              // if (_tradeMainProvider!.singleLadderExist && !_tradeMainProvider!.simulationVisibility)
              //   _tradeMainProvider?.singleActiveLadderStatus ?? false
              //       ? ElevatedButton(
              //       style: ButtonStyle(
              //           backgroundColor:
              //           MaterialStatePropertyAll(
              //               Colors.purple)),
              //       onPressed: () {
              //         activateAllLadderDialog(
              //             context, true);
              //       },
              //       child: Text(
              //           "Deactivate All Ladders",
              //           style: TextStyle(
              //               color: (themeProvider
              //                   .defaultTheme)
              //                   ? Colors.white
              //                   : Colors.white)))
              //       : ElevatedButton(
              //       style: ButtonStyle(
              //           backgroundColor:
              //           MaterialStatePropertyAll(
              //               Colors.green)),
              //       onPressed: () {
              //         activateAllLadderDialog(
              //             context, false);
              //         _tradeMainProvider!
              //             .getTradeMenuButtonsVisibilityStatus();
              //       },
              //       child: Text(
              //           "Activate All Ladders",
              //           style: TextStyle(color: (themeProvider.defaultTheme) ? Colors.white : Colors.white))),
              buildStartStopTradingOption(context, screenWidth),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildStartStopTradingOption(BuildContext context, double screenWidth) {
    return (_tradeMainProvider?.tradingStatus == null)
        ? const SizedBox(
            height: 15,
            width: 15,
            child: CircularProgressIndicator(),
          )
        : (_tradeMainProvider?.tradingStatus == true)
        ? CustomContainer(
            padding: 0,
            margin: EdgeInsets.zero,
            onTap: () {
              _startTrading();
            },
            // backgroundColor: (themeProvider.defaultTheme)?Color(0xff000000):Color(0xffffffff),
            backgroundColor: Color(0xffff2200).withOpacity(0.24),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 8.0,
                left: 8,
                right: 8,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.pause,
                    size: 18,
                    color: Color(0xffe21e00),
                    // color: (themeProvider.defaultTheme)?Color(0xff000000):Color(0xffffffff)
                  ),

                  SizedBox(width: 5),

                  Text(
                    "Stop Trading",
                    style: GoogleFonts.poppins(
                      letterSpacing: 0,
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: Color(0xffffffff),
                      // color: (themeProvider.defaultTheme)?Color(0xffffffff):Color(0xff000000)
                    ),
                  ),
                ],
              ),
            ),
          )
        : !_tradeMainProvider!.singleLadderExist
        ? const SizedBox()
        : CustomContainer(
            padding: 0,
            margin: EdgeInsets.zero,
            onTap: () {
              if (_tradeMainProvider?.singleActiveLadderStatus ?? false) {
                _tradeMainProvider?.updateTradingStatus = null;

                TradeMainRestApiService()
                    .startTrading(StartTradingRequest(actTradingStatus: true))
                    .then((res) async {
                      _tradeMainProvider!.getTradeMenuButtonsVisibilityStatus();
                      _tradeMainProvider!.getActiveLadderTickers(context);
                      refreshDataAtSimulation();

                      // Map<String, dynamic> request = {
                      //   "websocket": true,
                      // };

                      // StartStopSmartApiWebsocketResponse? res =
                      //     await TradeMainRestApiService()
                      //         .startStopSmartApiWebsocket(
                      //             request);
                    });
              } else {
                Fluttertoast.showToast(
                  msg: "Active any ladder to start trading",
                );
              }
            },
            backgroundColor: (themeProvider.defaultTheme)
                ? Color(0xff000000)
                : Color(0xffffffff),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 8.0,
                left: 8,
                right: 8,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.play_arrow,
                    size: 18,
                    color: Color(0xff1a94f2),
                    // color: (themeProvider.defaultTheme)?Color(0xff000000):Color(0xffffffff)
                  ),

                  SizedBox(width: 5),

                  Text(
                    "Start Trading",
                    style: GoogleFonts.poppins(
                      letterSpacing: 0,
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: (themeProvider.defaultTheme)
                          ? Color(0xffffffff)
                          : Color(0xff000000),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget buildDeactivateAllLaddersOption(
    BuildContext context,
    double screenWidth,
  ) {
    return CustomContainer(
      padding: 0,
      margin: EdgeInsets.zero,
      onTap: () {
        if (_tradeMainProvider?.singleActiveLadderStatus ?? false) {
          if(Utility().checkForSubscription(context)) {
            activateAllLadderDialog(context, true);
          }
          // activateAllLadderDialog(context, true);
        } else {
          activateAllLadderDialog(context, false);
          _tradeMainProvider!.getTradeMenuButtonsVisibilityStatus();
        }
      },
      backgroundColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8.0),
        child: Row(
          children: [
            Icon(
              Icons.remove_circle_outline,
              size: 15,
              color: (themeProvider.defaultTheme)
                  ? Color(0xff000000)
                  : Color(0xffffffff),
            ),

            SizedBox(width: 5),

            Text(
              (_tradeMainProvider?.singleActiveLadderStatus ?? false)
                  ? "Deactivate all ladders"
                  : "Activate all ladders",
              style: GoogleFonts.poppins(
                letterSpacing: 0,
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: (themeProvider.defaultTheme)
                    ? Color(0xff000000)
                    : Color(0xffffffff),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTradeReturnOption(BuildContext context, double screenWidth) {
    return CustomContainer(
      padding: 0,
      margin: EdgeInsets.zero,
      onTap: () {
        setState(() {
          _toggleController.value = !_toggleController.value;
        });
      },
      backgroundColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8.0),
        child: Row(
          children: [
            Icon(
              Icons.sync,
              size: 15,
              color: (themeProvider.defaultTheme)
                  ? Color(0xff000000)
                  : Color(0xffffffff),
            ),

            SizedBox(width: 5),

            Text(
              _toggleController.value ? "Price above" : "Trade return",

              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                letterSpacing: 0,
                fontSize: 13,
                color: (themeProvider.defaultTheme)
                    ? Color(0xff000000)
                    : Color(0xffffffff),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMiddleOptions(BuildContext context, double screenWidth) {
    switch (_tabController.index) {
      case 0:
        {
          return (_tradeMainProvider!.singleLadderExist &&
                  !_tradeMainProvider!.simulationVisibility)
              ? buildDeactivateAllLaddersOption(context, screenWidth)
              : Container(height: 8);
        }
      case 1:
        {
          return (_tabController.index == 1 &&
                  tradeMainProvider.singleLadderExist &&
                  _tradesProvider!.trades != null &&
                  _tradesProvider!.trades!.data!.isNotEmpty)
              ? buildTradeReturnOption(context, screenWidth)
              : Container(height: 8);
        }
      case 2:
        {
          return Container(height: 8);
        }
      case 3:
        {
          return Container(height: 8);
        }
      case 4:
        {
          return Container(height: 8);
        }
      default:
        {
          return Container(height: 8);
        }
    }
  }

  Widget setDownloadCsvDialog(BuildContext context, double screenWidth) {
    switch (_tabController.index) {
      case 3:
        {
          return Consumer<ThemeProvider>(
            builder: (context, value, child) {
              return _tradeMainProvider?.isAbleToSendCsv.position ?? false
                  ? buildPositionCsvOption(
                      context,
                      screenWidth,
                    ) // positionCsvDialog(value.defaultTheme)
                  : SizedBox(height: 10);
            },
          );
        }
      case 0:
        {
          return Consumer<ThemeProvider>(
            builder: (context, value, child) {
              return _tradeMainProvider?.isAbleToSendCsv.ladder ?? false
                  ? buildLadderCsvOption(
                      context,
                      screenWidth,
                    ) // ladderCsvDialog(value.defaultTheme)
                  : SizedBox(height: 10);
            },
          );
        }
      case 1:
        {
          return Consumer<ThemeProvider>(
            builder: (context, value, child) {
              return _tradeMainProvider?.isAbleToSendCsv.trade ?? false
                  ? buildTradesCsvOption(
                      context,
                      screenWidth,
                    ) // tradeCsvDialog(value.defaultTheme)
                  : SizedBox(height: 10);
            },
          );
        }
      case 2:
        {
          return Consumer<ThemeProvider>(
            builder: (context, value, child) {
              return _tradeMainProvider?.isAbleToSendCsv.openOrder ?? false
                  ? buildOrdersCsvOption(
                      context,
                      screenWidth,
                    ) // orderCsvDialog(value.defaultTheme)
                  : SizedBox(height: 10);
            },
          );
        }
      case 4:
        {
          return Consumer<ThemeProvider>(
            builder: (context, value, child) {
              return _tradeMainProvider?.isAbleToSendCsv.activity ?? false
                  ? buildActivityCsvOption(
                      context,
                      screenWidth,
                    ) // activityDownloadCsvDialog(value.defaultTheme)
                  : SizedBox(height: 10);
            },
          );
        }
      default:
        {
          return Consumer<ThemeProvider>(
            builder: (context, value, child) {
              return _tradeMainProvider?.isAbleToSendCsv.ladder ?? false
                  ? buildLadderCsvOption(
                      context,
                      screenWidth,
                    ) // ladderCsvDialog(value.defaultTheme)
                  : SizedBox();
            },
          );
        }
    }
  }

  Widget buildSimulationOptionSection(
    BuildContext context,
    double screenWidth,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16.0),
      child: 
          Wrap(
            children: [
              Row(
                children: [
                  buildTickByTickOption(context, screenWidth),
              
                  SizedBox(width: 8),
              
                  buildMultiplierOption(context, screenWidth),                  
                  
                ],
              ),
              buildUpAndDownTickerPriceButton(context, screenWidth),
            ],
          ),

    );
  }

  Widget buildTickByTickOption(BuildContext context, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tick by Tick",
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: (themeProvider.defaultTheme)
                ? Color(0xff0f0f0f)
                : Color(0xfff8f8f9),
          ),
        ),

        SizedBox(height: 5),

        (tradeMainProvider.isLoading)
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(),
              )
            : CustomContainer(
                padding: 0,
                margin: EdgeInsets.zero,
                borderColor: (themeProvider.defaultTheme)
                    ? Color(0xffdadde6)
                    : Color(0xff2c2c31),
                borderWidth: 1,
                backgroundColor: (themeProvider.defaultTheme)
                    ? Color(0xffdadde6)
                    : Color(0xff2c2c31),
                height: 40,
                borderRadius: 8,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<SimulateTicker>(
                      onChanged: (SimulateTicker? value) {
                        tradeMainProvider.updateSelectedTickerForSimulation =
                            value;
                      },
                      dropdownColor: (themeProvider.defaultTheme)
                          ? Colors.white
                          : Colors.black,
                      value: tradeMainProvider.selectedTickerForSimulation,
                      icon: Icon(Icons.keyboard_arrow_down_outlined),
                      items: tradeMainProvider.activeLadderTickers
                          .map(
                            (tickerDetail) => DropdownMenuItem<SimulateTicker>(
                              child: Text(
                                "${tickerDetail.ticker} ${tickerDetail.tickerExchange}",
                                style: GoogleFonts.poppins(
                                  color: (themeProvider.defaultTheme)
                                      ? Color(0xff141414)
                                      : Color(0xfff0f0f0),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              value: tickerDetail,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Widget buildMultiplierOption(BuildContext context, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Multiplier",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: (themeProvider.defaultTheme)
                    ? Color(0xff0f0f0f)
                    : Color(0xfff8f8f9),
              ),
            ),

            SizedBox(width: 3),

            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return InfoIconDisplay().infoDialog(
                      termsInfoConstant.titleStepSizeMultipler,
                      termsInfoConstant.messageStepSizeMultipler,
                    );
                  },
                );
              },
              child: Icon(
                Icons.info_outline,
                size: 15,
                color: (themeProvider.defaultTheme)
                    ? Color(0xff000000)
                    : Color(0xffffffff),
              ),
            ),
          ],
        ),

        SizedBox(height: 5),

        SizedBox(
          height: 40,
          width: 100,
          child: MyTextField(
            isFilled: true,
            fillColor: (themeProvider.defaultTheme)
                ? Color(0xffDADDE6)
                : Colors.transparent,
            labelText: "",
            maxLength: 14,
            elevation: 0,
            controller: _multiplierController,
            textInputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^[0-9,\.]+$')),
            ],
            keyboardType: TextInputType.number,
            textStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: (themeProvider.defaultTheme)
                  ? Colors.black
                  : Color(0xfff0f0f0),
            ),
            borderColor: (themeProvider.defaultTheme)
                ? Color(0xffDADDE6)
                : Color(0xff2c2c31),
            margin: EdgeInsets.zero,
            contentPadding: EdgeInsets.only(left: 12, bottom: 5),
            focusedBorderColor: Color(0xff5cbbff),
            showLeadingWidget: false,
            showTrailingWidget: false,

            prefixText: "X ",

            counterText: "",
            borderRadius: 8,
            hintText: '1',
            onChanged: (value) {},
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
            onFieldSubmitted: (value) {},
          ),
        ),
      ],
    );
  }

  Widget buildUpAndDownTickerPriceButton(
    BuildContext context,
    double screenWidth,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (_tradeMainProvider?.simulationVisibility == true)
            ? Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Buttons",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: (themeProvider.defaultTheme)
                            ? Color(0xff0f0f0f)
                            : Color(0xfff8f8f9),
                      ),
                    ),

                    SizedBox(width: 3),

                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return InfoIconDisplay().infoDialog(
                              "Button Information",
                              "Simulate the selected stock manually using the buttons below: \n- Green: Move the price up from the current price \n- Red: Move the price down from the current price \n- Blue: Execute all pending orders at the current stock price",
                            );
                          },
                        );
                      },
                      child: Icon(
                        Icons.info_outline,
                        size: 15,
                        color: (themeProvider.defaultTheme)
                            ? Color(0xff000000)
                            : Color(0xffffffff),
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
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

                    // Fluttertoast.showToast(
                    //   timeInSecForIosWeb: 3,
                    //     msg: "Note: If the order is not executed, because the current price is lower than the open order price. Please simulate again.",
                    //     backgroundColor: Colors.orange,
                    //   webBgColor: "linear-gradient(to right, #FB8C00, #FB8C00)"
                    // );

                    _isWaiting =
                        true; // Set the flag to true to indicate waiting state
                    // await Future.delayed(
                    //     Duration(seconds: 2)); // Add the delay
                    try {
                      if (_tradeMainProvider!
                                  .selectedTickerForSimulation
                                  .ticker !=
                              "Select ticker" &&
                          _tradeMainProvider?.simulationVisibility == true) {
                        // await Future.delayed(Duration(seconds: 2));
                        double multiplierValue =
                            double.tryParse(_multiplierController.text) ?? 1;
                        await simulation(
                          multiplierValue,
                          _tradeMainProvider!
                              .selectedTickerForSimulation
                              .tickerId,
                          context,
                        );
                        refreshDataAtSimulation();
                        tradeMainProvider.getActiveLadderTickers(
                          context,
                          fromSimulationButtonUPAndDown: true,
                        );
                        Fluttertoast.showToast(
                          msg: "Price increased",
                          backgroundColor: Colors.green,
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg:
                              "Please select ticker from dropdown for simulation",
                        );
                      }
                    } catch (error) {
                      print("Here is the error: ${error}");
                    } finally {
                      _isWaiting = false;
                    }
                  },
                  backgroundColor: _tradeMainProvider?.colorOfIncrementButton,
                  child: Container(
                    height: 30,
                    width: 30,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 3),
                        child: FaIcon(
                          // FontAwesomeIcons.circleArrowUp,
                          FontAwesomeIcons.arrowUp,
                          color: Colors
                              .white, //_tradeMainProvider?.colorOfIncrementButton,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            SizedBox(width: 10),

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

                    // Fluttertoast.showToast(
                    //     timeInSecForIosWeb: 3,
                    //     msg: "Note: If the order is not executed, because the current price is lower than the open order price. Please simulate again.",
                    //     backgroundColor: Colors.orange,
                    //     webBgColor: "linear-gradient(to right, #FB8C00, #FB8C00)"
                    //     // webBgColor: Colors.orange
                    // );

                    try {
                      if (_tradeMainProvider!
                              .selectedTickerForSimulation
                              .ticker !=
                          "Select ticker") {
                        double multiplierValue =
                            double.tryParse(_multiplierController.text) ?? 1;
                        await simulation(
                          -multiplierValue,
                          _tradeMainProvider!
                              .selectedTickerForSimulation
                              .tickerId,
                          context,
                        );
                        refreshDataAtSimulation();
                        tradeMainProvider.getActiveLadderTickers(
                          context,
                          fromSimulationButtonUPAndDown: true,
                        );
                        Fluttertoast.showToast(
                          msg: "Price dropped",
                          backgroundColor: Colors.red,
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg:
                              "Please select ticker from dropdown for simulation",
                        );
                      }
                    } catch (error) {
                      print("Error in the body: ${error}");
                    } finally {
                      _isWaiting = false;
                    }
                  },
                  backgroundColor: _tradeMainProvider?.colorOfDecrementButton,
                  child: Container(
                    height: 30,
                    width: 30,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 3.0),
                        child: FaIcon(
                          // FontAwesomeIcons.circleArrowUp,
                          FontAwesomeIcons.arrowDown,
                          color: Colors
                              .white, //_tradeMainProvider?.colorOfIncrementButton,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            SizedBox(width: 10),
            if (_tradeMainProvider?.simulationVisibility == true)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                                      .selectedTickerForSimulation
                                      .ticker !=
                                  "Select ticker" &&
                              _tradeMainProvider?.simulationVisibility ==
                                  true) {
                            // await Future.delayed(Duration(seconds: 2));
                            double multiplierValue = 0;
                            await simulation(
                              multiplierValue,
                              _tradeMainProvider!
                                  .selectedTickerForSimulation
                                  .tickerId,
                              context,
                            );
                            refreshDataAtSimulation();
                            tradeMainProvider.getActiveLadderTickers(
                              context,
                              fromSimulationButtonUPAndDown: true,
                            );
                            Fluttertoast.showToast(
                              msg: "New Price updated",
                              backgroundColor: Colors.blue,
                            );
                          } else {
                            Fluttertoast.showToast(
                              msg:
                                  "Please select ticker from dropdown for simulation",
                            );
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
                          child: FaIcon(
                            // FontAwesomeIcons.circleArrowUp,
                            FontAwesomeIcons.arrowsLeftRight,
                            color: Colors
                                .white, //_tradeMainProvider?.colorOfIncrementButton,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // SizedBox(
                  //   width: 8,
                  // ),
                  //
                  // InkWell(
                  //   onTap: () {
                  //
                  //     showDialog(
                  //       context: context,
                  //       builder: (BuildContext context) {
                  //         return InfoIconDisplay().infoDialog("termsInfoConstant.titleStepSizeMultipler", "termsInfoConstant.messageStepSizeMultipler");
                  //       },
                  //     );
                  //
                  //   },
                  //   child: Icon(
                  //       Icons.info_outline,
                  //       size: 23, // 15,
                  //       color: (themeProvider.defaultTheme)?Color(0xff000000):Color(0xffffffff)
                  //   ),
                  // ),
                ],
              ),
          ],
        ),

        SizedBox(height: 6),

        _tradeMainProvider!.selectedTickerForSimulation.ticker !=
                "Select ticker"
            ? Container(
                width: screenWidthRecognizer(context) * 0.3,
                child: Text(
                  "${(((tradeMainProvider.ladCurrentPrice[tradeMainProvider.selectedTickerForSimulation.tickerId.toString()] ?? 0) - (tradeMainProvider.firstLadderInitialBuyPrice[tradeMainProvider.selectedTickerForSimulation.tickerId.toString()] ?? 0)) / (tradeMainProvider.ladStepSize[tradeMainProvider.selectedTickerForSimulation.tickerId.toString()] ?? 0)).toStringAsFixed(2)} / ${((tradeMainProvider.ladCurrentPrice[tradeMainProvider.selectedTickerForSimulation.tickerId.toString()] ?? 0) - (tradeMainProvider.firstLadderInitialBuyPrice[tradeMainProvider.selectedTickerForSimulation.tickerId.toString()] ?? 0)).toStringAsFixed(2)}",
                ),
                // "${((tradeMainProvider.ladCurrentPrice - tradeMainProvider.firstLadderInitialBuyPrice) / tradeMainProvider.ladStepSize).toStringAsFixed(2)} / ${(tradeMainProvider.ladCurrentPrice - tradeMainProvider.firstLadderInitialBuyPrice).toStringAsFixed(2)}"),
              )
            : SizedBox(),
      ],
    );
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

    return Container(
      color: (themeProvider.defaultTheme)
          ? Color(0xffdadde6)
          : Color(0xff2c2c31),
      child: Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 6.0),
        child: Container(
          color: (themeProvider.defaultTheme)
              ? Color(0xfff0f0f0)
              : Color(0xff1d1d1f),
          height: 35,
          child: TabBar(
            isScrollable: false,
            // tabAlignment: TabAlignment.start,
            dividerColor: Colors.transparent,
            indicatorPadding: EdgeInsets.zero,
            indicator: BoxDecoration(
              color: Color(0xff1a94f2),
              borderRadius: BorderRadius.circular(3),
            ),
            labelPadding: const EdgeInsets.symmetric(horizontal: 0),
            padding: const EdgeInsets.symmetric(horizontal: 0),
            // indicatorWeight: 100,
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
                    Tab(
                      child: Consumer<ThemeProvider>(
                        builder: (context, value, child) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20.0,
                            ),
                            child: FittedBox(
                              child: Text(
                                "Ladders",
                                style: GoogleFonts.poppins(
                                  color: (tradeMainProvider.tabBarIndex == 0)
                                      ? Colors.white
                                      : (themeProvider.defaultTheme)
                                      ? Color(0xff0f0f0f)
                                      : Color(0xffA2B0BC),
                                  // color: (tradeMainProvider.tabBarIndex == 0)
                                  //     ? Colors.blue
                                  //     : value.defaultTheme
                                  //     ? Colors.black
                                  //     : Colors.white
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Tab(
                      child: Consumer<ThemeProvider>(
                        builder: (context, value, child) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 15.0,
                            ),
                            child: FittedBox(
                              child: Text(
                                "Trades",
                                style: GoogleFonts.poppins(
                                  color: (tradeMainProvider.tabBarIndex == 1)
                                      ? Colors.white
                                      : (themeProvider.defaultTheme)
                                      ? Color(0xff0f0f0f)
                                      : Color(0xffA2B0BC),
                                  // color: (tradeMainProvider.tabBarIndex == 1)
                                  //     ? Colors.blue
                                  //     : value.defaultTheme
                                  //     ? Colors.black
                                  //     : Colors.white
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Tab(
                      child: Consumer<ThemeProvider>(
                        builder: (context, value, child) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 15.0,
                            ),
                            child: FittedBox(
                              child: Text(
                                "Orders",
                                style: GoogleFonts.poppins(
                                  color: (tradeMainProvider.tabBarIndex == 2)
                                      ? Colors.white
                                      : (themeProvider.defaultTheme)
                                      ? Color(0xff0f0f0f)
                                      : Color(0xffA2B0BC),
                                  // color: (tradeMainProvider.tabBarIndex == 2)
                                  //     ? Colors.blue
                                  //     : value.defaultTheme
                                  //     ? Colors.black
                                  //     : Colors.white
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Tab(
                      child: Consumer<ThemeProvider>(
                        builder: (context, value, child) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 15.0,
                            ),
                            child: FittedBox(
                              child: Text(
                                "Hidden Orders",
                                style: GoogleFonts.poppins(
                                  color:
                                      (_orderProvider!.isSuperUser &&
                                          tradeMainProvider.tabBarIndex == 3)
                                      ? Colors.white
                                      : (_orderProvider!.isSuperUser == false &&
                                            tradeMainProvider.tabBarIndex == 2)
                                      ? Colors.white
                                      : (themeProvider.defaultTheme)
                                      ? Color(0xff0f0f0f)
                                      : Color(0xffA2B0BC),
                                  // color: (_orderProvider!.isSuperUser && tradeMainProvider.tabBarIndex == 3 )
                                  //     ? Colors.blue
                                  //     : (_orderProvider!.isSuperUser == false && tradeMainProvider.tabBarIndex == 2)
                                  //     ? Colors.blue
                                  //     : value.defaultTheme
                                  //     ? Colors.black
                                  //     : Colors.white
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Tab(
                      child: Consumer<ThemeProvider>(
                        builder: (context, value, child) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10.0,
                            ),
                            child: FittedBox(
                              child: Text(
                                "Positions",
                                style: GoogleFonts.poppins(
                                  color:
                                      (_orderProvider!.isSuperUser &&
                                          tradeMainProvider.tabBarIndex == 4)
                                      ? Colors.white
                                      : (_orderProvider!.isSuperUser == false &&
                                            tradeMainProvider.tabBarIndex == 3)
                                      ? Colors.white
                                      : (themeProvider.defaultTheme)
                                      ? Color(0xff0f0f0f)
                                      : Color(0xffA2B0BC),
                                  // color: (_orderProvider!.isSuperUser && tradeMainProvider.tabBarIndex == 4 )
                                  //     ? Colors.blue
                                  //     : (_orderProvider!.isSuperUser == false && tradeMainProvider.tabBarIndex == 3)
                                  //     ? Colors.blue
                                  //     : value.defaultTheme
                                  //     ? Colors.black
                                  //     : Colors.white
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Tab(
                      child: Consumer<ThemeProvider>(
                        builder: (context, value, child) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 15.0,
                            ),
                            child: Text(
                              "Activity",
                              style: GoogleFonts.poppins(
                                color:
                                    (_orderProvider!.isSuperUser &&
                                        tradeMainProvider.tabBarIndex == 5)
                                    ? Colors.white
                                    : (_orderProvider!.isSuperUser == false &&
                                          tradeMainProvider.tabBarIndex == 4)
                                    ? Colors.white
                                    : (themeProvider.defaultTheme)
                                    ? Color(0xff0f0f0f)
                                    : Color(0xffA2B0BC),
                                // color: (_orderProvider!.isSuperUser && tradeMainProvider.tabBarIndex == 5 )
                                //     ? Colors.blue
                                //     : (_orderProvider!.isSuperUser == false && tradeMainProvider.tabBarIndex == 4)
                                //     ? Colors.blue
                                //     : value.defaultTheme
                                //     ? Colors.black
                                //     : Colors.white
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ]
                : [
                    Tab(
                      child: Consumer<ThemeProvider>(
                        builder: (context, value, child) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 15.0,
                            ),
                            child: FittedBox(
                              child: Text(
                                "Ladders",
                                style: TextStyle(
                                  color: (tradeMainProvider.tabBarIndex == 0)
                                      ? Colors.white
                                      : (themeProvider.defaultTheme)
                                      ? Color(0xff0f0f0f)
                                      : Color(0xffA2B0BC),
                                  // color: (tradeMainProvider.tabBarIndex == 0)
                                  //     ? Colors.blue
                                  //     : value.defaultTheme
                                  //     ? Colors.black
                                  //     : Colors.white
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Tab(
                      child: Consumer<ThemeProvider>(
                        builder: (context, value, child) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 15.0,
                            ),
                            child: FittedBox(
                              child: Text(
                                "Trades",
                                style: GoogleFonts.poppins(
                                  color: (tradeMainProvider.tabBarIndex == 1)
                                      ? Colors.white
                                      : (themeProvider.defaultTheme)
                                      ? Color(0xff0f0f0f)
                                      : Color(0xffA2B0BC),
                                  // color: (tradeMainProvider.tabBarIndex == 1)
                                  //     ? Colors.blue
                                  //     : value.defaultTheme
                                  //     ? Colors.black
                                  //     : Colors.white
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Tab(
                      child: Consumer<ThemeProvider>(
                        builder: (context, value, child) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 15.0,
                            ),
                            child: FittedBox(
                              child: Text(
                                "Orders",
                                style: GoogleFonts.poppins(
                                  color: (tradeMainProvider.tabBarIndex == 2)
                                      ? Colors.white
                                      : (themeProvider.defaultTheme)
                                      ? Color(0xff0f0f0f)
                                      : Color(0xffA2B0BC),
                                  // color: (tradeMainProvider.tabBarIndex == 2)
                                  //     ? Colors.blue
                                  //     : value.defaultTheme
                                  //     ? Colors.black
                                  //     : Colors.white
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Tab(
                      child: Consumer<ThemeProvider>(
                        builder: (context, value, child) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10.0,
                            ),
                            child: FittedBox(
                              child: Text(
                                "Positions",
                                style: GoogleFonts.poppins(
                                  color: (tradeMainProvider.tabBarIndex == 3)
                                      ? Colors.white
                                      : (themeProvider.defaultTheme)
                                      ? Color(0xff0f0f0f)
                                      : Color(0xffA2B0BC),
                                  // color: (tradeMainProvider.tabBarIndex == 3)
                                  //     ? Colors.blue
                                  //     : value.defaultTheme
                                  //     ? Colors.black
                                  //     : Colors.white
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Tab(
                      child: Consumer<ThemeProvider>(
                        builder: (context, value, child) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 15.0,
                            ),
                            child: FittedBox(
                              child: Text(
                                "Activity",
                                style: GoogleFonts.poppins(
                                  color: (tradeMainProvider.tabBarIndex == 4)
                                      ? Colors.white
                                      : (themeProvider.defaultTheme)
                                      ? Color(0xff0f0f0f)
                                      : Color(0xffA2B0BC),
                                  // color: (tradeMainProvider.tabBarIndex == 4)
                                  //     ? Colors.blue
                                  //     : value.defaultTheme
                                  //     ? Colors.black
                                  //     : Colors.white
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
          ),
        ),
      ),
    );
  }

  Widget tradeTabBarChildrenWidget({
    required TradeMainProvider tradeMainState,
  }) {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        dragStartBehavior: DragStartBehavior.down,
        children: (_orderProvider!.isSuperUser)
            ? [
                // LadderTab(
                //     initiallyExpanded: tradeMainState.expandWidget,
                //     ladderlist: ladderlist1,
                //     ladderDataRequest: getLadderDataRequest,
                //     selectedTicker: selectedTickerSimulation != "Select ticker"
                //         ? selectedTickerSimulation
                //         : null),
                LadderTabNew(
                  initiallyExpanded: tradeMainState.expandWidget,
                  ladderlist: ladderlist1,
                  ladderDataRequest: getLadderDataRequest,
                  selectedTicker: selectedTickerSimulation != "Select ticker"
                      ? selectedTickerSimulation
                      : null,
                ),
                // TradesTab(
                //     toggleReturnPrice: _toggledOption,
                //     selectedTicker: selectedTickerSimulation != "Select ticker"
                //         ? selectedTickerSimulation
                //         : null),
                TradeTabNew(
                  toggleReturnPrice: _toggledOption,
                  selectedTicker: selectedTickerSimulation != "Select ticker"
                      ? selectedTickerSimulation
                      : null,
                ),
                // OrdersTab(
                //     selectedTicker: selectedTickerSimulation != "Select ticker"
                //         ? selectedTickerSimulation
                //         : null),
                OrdersTabNew(
                  selectedTicker: selectedTickerSimulation != "Select ticker"
                      ? selectedTickerSimulation
                      : null,
                ),

                HiddenOrdersTab(
                  selectedTicker: selectedTickerSimulation != "Select ticker"
                      ? selectedTickerSimulation
                      : null,
                ),

                // PositionsTab(
                //     selectedTicker: selectedTickerSimulation != "Select ticker"
                //         ? selectedTickerSimulation
                //         : null),
                PositionTabNew(
                  selectedTicker: selectedTickerSimulation != "Select ticker"
                      ? selectedTickerSimulation
                      : null,
                ),

                const ActivityTab(),

                // const FavoriteTab()
              ]
            : [
                // LadderTab(
                //     initiallyExpanded: tradeMainState.expandWidget,
                //     ladderlist: ladderlist1,
                //     ladderDataRequest: getLadderDataRequest,
                //     selectedTicker: selectedTickerSimulation != "Select ticker"
                //         ? selectedTickerSimulation
                //         : null),
                LadderTabNew(
                  initiallyExpanded: tradeMainState.expandWidget,
                  ladderlist: ladderlist1,
                  ladderDataRequest: getLadderDataRequest,
                  selectedTicker: selectedTickerSimulation != "Select ticker"
                      ? selectedTickerSimulation
                      : null,
                ),
                // TradesTab(
                //     toggleReturnPrice: _toggledOption,
                //     selectedTicker: selectedTickerSimulation != "Select ticker"
                //         ? selectedTickerSimulation
                //         : null),
                TradeTabNew(
                  toggleReturnPrice: _toggledOption,
                  selectedTicker: selectedTickerSimulation != "Select ticker"
                      ? selectedTickerSimulation
                      : null,
                ),
                // OrdersTab(
                //     selectedTicker: selectedTickerSimulation != "Select ticker"
                //         ? selectedTickerSimulation
                //         : null),
                OrdersTabNew(
                  selectedTicker: selectedTickerSimulation != "Select ticker"
                      ? selectedTickerSimulation
                      : null,
                ),

                // PositionsTab(
                //     selectedTicker: selectedTickerSimulation != "Select ticker"
                //         ? selectedTickerSimulation
                //         : null),
                PositionTabNew(
                  selectedTicker: selectedTickerSimulation != "Select ticker"
                      ? selectedTickerSimulation
                      : null,
                ),

                const ActivityTab(),

                // const FavoriteTab()
              ],
      ),
    );
  }
}
