import 'dart:developer';
import 'dart:io';

import 'package:dozen_diamond/F_Funds/screens/add_funds_new.dart';
import 'package:dozen_diamond/F_Funds/screens/add_funds_new_new.dart';
import 'package:dozen_diamond/articles/screen/articles_screen.dart';
import 'package:dozen_diamond/create_ladder_detailed/screens/createladder_step4_new.dart';
import 'package:dozen_diamond/global/constants/shared_preferences_manager.dart';
import 'package:dozen_diamond/global/stateManagement/app_config_provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

// Import necessary files
import 'package:dozen_diamond/DD_Navigation/stateManagement/navigation_provider.dart';
import 'package:dozen_diamond/global/constants/data_string.dart';
import 'package:dozen_diamond/generic_socket/screens/blockScreen.dart';
import 'package:dozen_diamond/generic_socket/service/genericSocketService.dart';
import 'package:dozen_diamond/socket_manager/stateManagement/web_socket_service_provider.dart';

import '../../AD_Orders/stateManagement/order_provider.dart';
import '../../F_Funds/screens/add_funds_new_new.dart';
import '../../ZI_Search/screens/ladder_intro_screen1.dart';
import '../../ZI_Search/screens/search_page_new.dart';
import '../../ZI_Search/screens/stock_by_sector_page_new.dart';
import '../../ZZZZY_TradingMainPage/screens/main_page_new.dart';
import '../../ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
import '../../ZZZZ_main/stateManagement/notification_provider.dart';
import '../../access_real_time_trading_otp/screens/access_real_time_trading_otp_screen.dart';
import '../../create_ladder_detailed/screens/createladderSelectStock_new.dart';
import '../../create_ladder_detailed/screens/createladder_step1.dart';
import '../../create_ladder_detailed/screens/createladder_step2_new.dart';
import '../../create_ladder_detailed/screens/createladder_step3_new.dart';
import '../../create_ladder_detailed/screens/createladder_step4_new.dart';
import '../../create_ladder_easy/screens/create_ladder_easy_screen_new.dart';
import '../../depositories_verification/screens/in_progress_dialog.dart';
import '../../depositories_verification/screens/not_authorized_dialog.dart';
import '../../depositories_verification/stateManagement/depositories_verification_provider.dart';
import '../../download/screens/download_screen.dart';
import '../../global/functions/utils.dart';
import '../../global/screens/no_internet_screen.dart';
import '../../global/stateManagement/connectivity_provider.dart';
import '../../global/stateManagement/user_config_provider.dart';
import '../../ladder_add_or_withdraw_cash/screens/ladder_add_or_withdraw_cash_screen_new.dart';
import '../../modify_ladder_target_price/screen/adjust_order_size_screen_new.dart';
import '../../modify_ladder_target_price/screen/adjust_step_size_screen_new.dart';
import '../../modify_ladder_target_price/screen/adjust_target_price_screen_new.dart';
import '../../monitor/screens/monitor_screen.dart';
// import '../../prior_buy_create_ladder/screens/createladder_step1_prior_buy.dart';
import '../../notifications/screens/notification_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../profile/stateManagement/profile_provider.dart';
import '../../questionnaire/screens/questionnaire_screen.dart';
import '../../ranklist/screens/ranklist_screen.dart';
import '../../reminders/screens/reminder_screen.dart';
import '../../replicate_or_reduce/screens/replicate_or_reduce_screen_new.dart';
import '../../strategies/screens/strategies_screen.dart';
import '../../watchlist/screens/watchlist_screen_new.dart';
import './bottom_nav_bar.dart';
import './nav_drawer.dart';

import '../../ZZZZY_TradingMainPage/screens/main_page.dart';
import '../../F_Funds/screens/addFunds.dart';
import '../../ZH_Analysis/screens/select_analysis_type.dart';
import '../../ZI_Search/screens/search_page.dart' hide SearchPageNew;
import '../../ZI_Search/screens/stock_by_sector_page.dart';
import '../../broker_info/screens/broker_info_screen.dart';
import '../../create_ladder_detailed/screens/createladderSelectStock.dart';
import '../../create_ladder_detailed/screens/createladder_step2.dart';
import '../../create_ladder_detailed/screens/createladder_step3.dart';
import '../../create_ladder_detailed/screens/createladder_step4.dart';
import '../../create_ladder_easy/create_ladder_easy_main.dart';
import '../../ladder_add_or_withdraw_cash/screens/ladder_add_or_withdraw_cash_screen.dart';
import '../../manage_brokers/screens/broker_setup_successfull.dart';
import '../../merge_ladder/screens/merge_ladder_screen.dart';
import '../../modify_ladder_target_price/screen/adjust_order_size_screen.dart';
import '../../modify_ladder_target_price/screen/adjust_step_size_screen.dart';
import '../../modify_ladder_target_price/screen/adjust_target_price_screen.dart';
import '../../move_funds_to_ladder/screens/move_funds_to_ladder_screen.dart';
import '../../replicate_or_reduce/screens/replicate_or_reduce_screen.dart';
import '../../watchlist/screens/watchlist_screen.dart';
import 'bottom_nav_bar_new.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'nav_drawer_new.dart' show NavDrawerNew;

class CommonScreen extends StatefulWidget {
  final int? bottomNavigatonIndex;
  final bool enableBackButton;
  final bool enableMenuButton;
  final int goToIndex;
  final Function? updateIndex;
  final bool initiallyExpanded;
  final String selectedTicker;

  const CommonScreen({
    super.key,
    this.bottomNavigatonIndex,
    this.enableBackButton = false,
    this.enableMenuButton = true,
    this.goToIndex = 0,
    this.updateIndex,
    this.initiallyExpanded = true,
    this.selectedTicker = "Select ticker",
  });

  @override
  State<CommonScreen> createState() => _CommonScreenState();
}

class _CommonScreenState extends State<CommonScreen> {
  int selectedIndex = 0;
  bool isBlocked = false;
  String deviceUniqueId = "";
  late NavigationProvider navigationProvider;
  late WebSocketServiceProvider webSocketServiceProvider;
  final DataStrings dataStrings = DataStrings();

  late AppConfigProvider appConfigProvider;

  late NotificationProvider notificationProvider =
      Provider.of<NotificationProvider>(context);
  late ConnectivityProvider connectivityProvider;
  late OrderProvider orderProvider;
  late TradeMainProvider tradeMainProvider;
  late DepositoriesVerificationProvider depositoriesVerificationProvider;

  // final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  List get pages => [
    // AddFunds(
    //   updateIndex: navigationProvider.onItemTapped,
    //   isAuthenticationPresent: true,
    // ),
    // AddFundsNew(
    //   updateIndex: navigationProvider.onItemTapped,
    //   isAuthenticationPresent: true,
    // ),
    AddFundsNewNew(
      updateIndex: navigationProvider.onItemTapped,
      isAuthenticationPresent: true,
    ),
    // MainPage(
    //   enableBackButton: false,
    //   enableMenuButton: true,
    //   updateIndex: navigationProvider.onItemTapped,
    //   goToIndex: widget.goToIndex,
    //   initiallyExpanded: widget.initiallyExpanded,
    //   selectedTicker: widget.selectedTicker,
    // ),
    MainPageNew(
      enableBackButton: false,
      enableMenuButton: true,
      updateIndex: navigationProvider.onItemTapped,
      goToIndex: widget.goToIndex,
      initiallyExpanded: widget.initiallyExpanded,
      selectedTicker: widget.selectedTicker,
    ),
    SelectAnalysisType(),
    // SearchPage(updateIndex: () {}, refreshProviderState: true),
    SearchPageNew(updateIndex: () {}, refreshProviderState: true),
    // CreateLadderSelectStock(),
    CreateLadderSelectStockNew(),
    // CreateLadder2(),
    CreateLadder2New(),
    // CreateLadder3(),
    CreateLadder3New(),
    // CreateLadder4(),
    CreateLadder4New(),
    // CreateLadderEasyMain(),
    CreateLadderEasyScreenNew(),
    // StockBySectorPage(refreshProviderState: true),
    StockBySectorPageNew(refreshProviderState: true),
    // LadderAddOrWithdrawCashScreen(),
    LadderAddOrWithdrawCashScreenNew(),
    MergeLadderScreen(),
    BrokerSetupSuccessfull(),
    // ReplicateOrReduceScreen(),
    ReplicateOrReduceScreenNew(),
    // ModifyLadderTargetPriceScreen(),
    AdjustTargetPriceScreenNew(),
    // AdjustStepSizeScreen(),
    AdjustStepSizeScreenNew(),
    // AdjustOrderSizeScreen(),
    AdjustOrderSizeScreenNew(),
    MoveFundsToLadderScreen(),
    // WatchlistScreen(
    //   updateIndex: navigationProvider.onItemTapped,
    //   isAuthenticationPresent: true,
    // ),
    WatchlistScreenNew(
      updateIndex: navigationProvider.onItemTapped,
      isAuthenticationPresent: true,
    ),
    BrokerInfoScreen(),
    MonitorScreen(
      updateIndex: navigationProvider.onItemTapped,
      isAuthenticationPresent: true,
    ), // 20
    StrategiesScreen(
      updateIndex: navigationProvider.onItemTapped,
      isAuthenticationPresent: true,
    ), // 21

    LadderIntroScreen1(updateIndex: () {}, refreshProviderState: true), //22
    QuestionnaireScreen(
      updateIndex: navigationProvider.onItemTapped,
      isAuthenticationPresent: true,
    ), //23
    AccessRealTimeTradingOtpScreen(
      updateIndex: navigationProvider.onItemTapped,
      isAuthenticationPresent: true,
    ), //24
    ProfileScreen(
      updateIndex: navigationProvider.onItemTapped,
      isAuthenticationPresent: true,
    ), //25

    DownloadScreen(
      updateIndex: navigationProvider.onItemTapped,
      isAuthenticationPresent: true,
    ), //26
    CreateLadder1New(), // 27
    ReminderScreen(updateIndex: navigationProvider.onItemTapped), //28
    NotificationScreen(updateIndex: navigationProvider.onItemTapped), //29
    ArticlesScreen(), //30
    RankListScreen(
      updateIndex: navigationProvider.onItemTapped,
      isAuthenticationPresent: true,
    ), // 31
  ];

  @override
  void initState() {
    super.initState();
    initFunction();
  }

  initFunction() {
    _checkIfBlocked(); // Async check for block status
    _checkIfBlocked(); // Async check for block status
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      tradeMainProvider = Provider.of<TradeMainProvider>(
        context,
        listen: false,
      );
      webSocketServiceProvider = Provider.of<WebSocketServiceProvider>(
        context,
        listen: false,
      );
      webSocketServiceProvider.startFetching();

      appConfigProvider = Provider.of<AppConfigProvider>(
        context,
        listen: false,
      );
      orderProvider = Provider.of<OrderProvider>(context, listen: false);

      deviceUniqueId = await GenericRestApiService().getPlatformUniqueId();
      webSocketServiceProvider.accountBlockage(context, deviceUniqueId);

      Provider.of<WebSocketServiceProvider>(
        context,
        listen: false,
      ).startFetching();

      appConfigProvider.getAppConfig().then((onValue) {
        // if(Platform.isIOS || Platform.isAndroid) {
        //   AppConfigProvider appConfigProvider = Provider.of<AppConfigProvider>(context, listen: false);
        //   appConfigProvider.handleAppUpdate(context);
        // }
        // if(Platform.isIOS) {
        //
        //   Utility().showInAppMessage(context, "Message", "ios description jfldsj s jfksjfls jsj lfj slfjsl jsdfldjl sjflsjf lsj slfjs fjsljfsl slfjs lfjs fsj fs;fjs;lfjs; fjs");
        //
        // } else if (Platform.isAndroid) {
        //
        //   Utility().showInAppMessage(context, "Message", "android description jfldsj s jfksjfls jsj lfj slfjsl jsdfldjl sjflsjf lsj slfjs fjsljfsl slfjs lfjs fsj fs;fjs;lfjs; fjs");
        //
        // } else if(kIsWeb) {
        //
        //   Utility().showInAppMessage(context, "Message", "web description jfldsj s jfksjfls jsj lfj slfjsl jsdfldjl sjflsjf lsj slfjs fjsljfsl slfjs lfjs fsj fs;fjs;lfjs; fjs");
        //
        // }

        handleAppMessage();
      });

      appConfigProvider.getGradedOrderList(context);

      print("before calling getDes");

      checkIfSuperUser();

      print("came here in common screen initstate");

      final userConfigProvider = Provider.of<UserConfigProvider>(
        context,
        listen: false,
      );

      userConfigProvider.getUserConfigData().then((onValue) async {
        print("after colling getUserConfigData");
        await tradeMainProvider.getTradeMenuButtonsVisibilityStatus();
        print("after colling getUserConfigData2");
        print(tradeMainProvider.tradingOptions);
        if (tradeMainProvider.tradingOptions ==
            TradingOptions.tradingWithRealCash) {
          if (userConfigProvider.userConfigData.planExpiryDateTime != null) {
            print("inside planExpiryDateTime");
            DateTime now = DateTime.now();
            Duration difference = userConfigProvider
                .userConfigData
                .planExpiryDateTime!
                .difference(now);
            print(difference.inDays);
            print(difference.isNegative);
            if (difference.inDays <= 5 && difference.isNegative == false) {
              Utility().showPlanExpiringPopUp(
                context,
                userConfigProvider.userConfigData.planExpiryDateTime!,
              );
            }
          }

          print("inside real trading code");
          if (userConfigProvider.userConfigData.brokerExpired ?? false) {
            Utility().showEnterBrokerOtpPopUp(context);
          }
        }
      });

      depositoriesVerificationProvider =
          Provider.of<DepositoriesVerificationProvider>(context, listen: false);
      await tradeMainProvider.getTradeMenuButtonsVisibilityStatus();
      depositoriesVerificationProvider.getDepositoriesVerificationStatus().then((
        onValue,
      ) {
        // if(Platform.isIOS || Platform.isAndroid) {
        //   AppConfigProvider appConfigProvider = Provider.of<AppConfigProvider>(context, listen: false);
        //   appConfigProvider.handleAppUpdate(context);
        // }

        print("in onValue");
        print(depositoriesVerificationProvider.depositoriesVerificationStatus);
        if (depositoriesVerificationProvider.depositoriesVerificationStatus !=
            "authorized") {
          print(
            "inside tradeMainProvider.getTradeMenuButtonsVisibilityStatus()",
          );
          print(tradeMainProvider.tradingOptions);
          if (tradeMainProvider.tradingOptions ==
              TradingOptions.tradingWithRealCash) {
            print("inside if if if if");
            showDialog(
              context: context,
              builder: (ctx) => NotAuthorizedDialog(),
              // builder: (ctx) => InProgressDialog(),
              barrierDismissible: false,
            );
          }
        }
      });

      final profileProvider = Provider.of<ProfileProvider>(
        context,
        listen: false,
      );
      profileProvider.getProfileData();

      if (kIsWeb) {
        notificationProvider = Provider.of<NotificationProvider>(
          context,
          listen: false,
        );
      }
    });

    // analytics.logEvent(
    //   name: 'common_screen',
    //   parameters: {'screen_name': 'inside_common_screen'},
    // );
  }

  handleAppMessage() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int buildNumber = int.parse(packageInfo.buildNumber);

    if (kIsWeb) {
      if (appConfigProvider.appConfigData.data != null) {
        if (appConfigProvider.appConfigData.data!.updateMessageInSide != null) {
          if (appConfigProvider.appConfigData.data!.updateMessageInSide!.web !=
              null) {
            if ((appConfigProvider
                        .appConfigData
                        .data!
                        .updateMessageInSide!
                        .web!
                        .minBuildNumber ??
                    0) >=
                buildNumber) {
              Utility().showInAppMessage(
                context,
                appConfigProvider
                        .appConfigData
                        .data!
                        .updateMessageInSide!
                        .web!
                        .message ??
                    "Message",
                appConfigProvider
                        .appConfigData
                        .data!
                        .updateMessageInSide!
                        .web!
                        .subMessage ??
                    "Message",
              );
            }
          }
        }
      }

      // Utility().showInAppMessage(context, "Message", "web description jfldsj s jfksjfls jsj lfj slfjsl jsdfldjl sjflsjf lsj slfjs fjsljfsl slfjs lfjs fsj fs;fjs;lfjs; fjs");
    } else if (Platform.isIOS) {
      if (appConfigProvider.appConfigData.data != null) {
        if (appConfigProvider.appConfigData.data!.updateMessageInSide != null) {
          if (appConfigProvider.appConfigData.data!.updateMessageInSide!.ios !=
              null) {
            if ((appConfigProvider
                        .appConfigData
                        .data!
                        .updateMessageInSide!
                        .ios!
                        .minBuildNumber ??
                    0) >=
                buildNumber) {
              Utility().showInAppMessage(
                context,
                appConfigProvider
                        .appConfigData
                        .data!
                        .updateMessageInSide!
                        .ios!
                        .message ??
                    "Message",
                appConfigProvider
                        .appConfigData
                        .data!
                        .updateMessageInSide!
                        .ios!
                        .subMessage ??
                    "Message",
              );
            }
          }
        }
      }
      // Utility().showInAppMessage(context, "Message", "ios description jfldsj s jfksjfls jsj lfj slfjsl jsdfldjl sjflsjf lsj slfjs fjsljfsl slfjs lfjs fsj fs;fjs;lfjs; fjs");
    } else if (Platform.isAndroid) {
      if (appConfigProvider.appConfigData.data != null) {
        if (appConfigProvider.appConfigData.data!.updateMessageInSide != null) {
          if (appConfigProvider
                  .appConfigData
                  .data!
                  .updateMessageInSide!
                  .android !=
              null) {
            if ((appConfigProvider
                        .appConfigData
                        .data!
                        .updateMessageInSide!
                        .android!
                        .minBuildNumber ??
                    0) >=
                buildNumber) {
              Utility().showInAppMessage(
                context,
                appConfigProvider
                        .appConfigData
                        .data!
                        .updateMessageInSide!
                        .android!
                        .message ??
                    "Message",
                appConfigProvider
                        .appConfigData
                        .data!
                        .updateMessageInSide!
                        .android!
                        .subMessage ??
                    "Message",
              );
            }
          }
        }
      }

      // Utility().showInAppMessage(context, "Message", "android description jfldsj s jfksjfls jsj lfj slfjsl jsdfldjl sjflsjf lsj slfjs fjsljfsl slfjs lfjs fsj fs;fjs;lfjs; fjs");
    }
  }

  checkIfSuperUser() async {
    print("inside checkIfSuperUser");
    bool isSuperUser = await SharedPreferenceManager.getIsSuper() ?? false;

    print(isSuperUser);
    orderProvider.isSuperUser = isSuperUser;
    setState(() {});
  }

  Future<void> _checkIfBlocked() async {
    // deviceUniqueId = await GenericRestApiService().getPlatformUniqueId();
    // isBlocked =
    //     await GenericRestApiService().genericSocketRestService(deviceUniqueId, context);
    // print("isBlocked is here $isBlocked");
    setState(() {}); // Update UI based on block status
  }

  @override
  Widget build(BuildContext context) {
    navigationProvider = Provider.of<NavigationProvider>(context, listen: true);
    webSocketServiceProvider = Provider.of<WebSocketServiceProvider>(
      context,
      listen: true,
    );

    connectivityProvider = Provider.of<ConnectivityProvider>(
      context,
      listen: true,
    );
    depositoriesVerificationProvider =
        Provider.of<DepositoriesVerificationProvider>(context, listen: true);
    appConfigProvider = Provider.of<AppConfigProvider>(context, listen: true);

    // print(
    //     "these is the socketProvider ${webSocketServiceProvider.isBlocked} and ${webSocketServiceProvider.showAnotherLoginButton}");

    return
    // (connectivityProvider.connectionStatus.contains(ConnectivityResult.wifi) ||
    //   connectivityProvider.connectionStatus.contains(ConnectivityResult.mobile) ||
    //   connectivityProvider.connectionStatus.contains(ConnectivityResult.ethernet) ||
    //   connectivityProvider.connectionStatus.contains(ConnectivityResult.vpn))?
    (true)
        ? (webSocketServiceProvider.isBlocked)
              ? Scaffold(body: AccountBlockedScreen())
              : Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom,
                  ),
                  child: Scaffold(
                    backgroundColor: const Color(0xFF15181F),
                    drawer:
                        // NavigationDrawerWidget(updateIndex: widget.updateIndex),
                        NavDrawerNew(updateIndex: widget.updateIndex),
                    body: Stack(
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child: pages[navigationProvider.selectedIndex],
                            ),
                            const BottomNavBarNew(),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            (kIsWeb == true) ? "${dataStrings.version}" : "",
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
        : NoInternetScreen();
  }
}
