import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dozen_diamond/AA_positions/stateManagement/position_provider.dart';
import 'package:dozen_diamond/AB_Ladder/stateManagement/ladder_provider.dart';
import 'package:dozen_diamond/AC_trades/stateManagement/trades_provider.dart';
import 'package:dozen_diamond/AD_Orders/stateManagement/order_provider.dart';
import 'package:dozen_diamond/AE_Activity/stateManagement/activity_provider.dart';
import 'package:dozen_diamond/ZB_accountInfoBar/stateManagement/custom_home_app_bar_provider.dart';
import 'package:dozen_diamond/ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:dozen_diamond/global/constants/shared_preferences_manager.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:dozen_diamond/global/services/socket_manager.dart';
import 'package:dozen_diamond/global/services/stock_price_listener.dart';
import 'package:dozen_diamond/global/stateManagement/app_config_provider.dart';
import 'package:dozen_diamond/navigateAuthentication/screens/navigate_authentication_screen.dart';
import 'package:dozen_diamond/navigateAuthentication/stateManagement/navigate_authentication_provider.dart';
import 'package:dozen_diamond/welcome_screens/stateManagement/welcome_screens_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ZZZZ_main/stateManagement/notification_provider.dart';
import '../../global/screens/no_internet_screen.dart';
import '../../global/screens/server_under_maintenance_screen.dart';
import '../../global/functions/utils.dart';
import '../../global/stateManagement/connectivity_provider.dart';
import '../../profile/stateManagement/profile_provider.dart';
import '../../socket_manager/stateManagement/web_socket_service_provider.dart';
import '../../welcome_screens/screens/welcome_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SocketManager socketManager = SocketManager();
  FocusNode pinFocusNode = FocusNode();
  LadderProvider? _ladderProvider;
  OrderProvider? _orderProvider;
  ActivityProvider? _activityProvider;
  PositionProvider? _positionProvider;
  TradesProvider? _tradesProvider;
  final textEditingController = TextEditingController();
  TradeMainProvider? _tradeMainProvider;
  CustomHomeAppBarProvider? _customHomeAppBarProvider;
  CurrencyConstants? _currencyConstantsProvider;
  late NavigateAuthenticationProvider navigateAuthenticationProvider;
  late WebSocketServiceProvider webSocketServiceProvider;
  late AppConfigProvider appConfigProvider;
  late WelcomeScreensProvider welcomeScreensProvider;
  late ConnectivityProvider connectivityProvider;
  late ProfileProvider profileProvider;

  late NotificationProvider notificationProvider =
      Provider.of<NotificationProvider>(context);

  void initState() {
    super.initState();
    _tradeMainProvider = Provider.of(context, listen: false);
    _ladderProvider = Provider.of(context, listen: false);
    _orderProvider = Provider.of(context, listen: false);
    _positionProvider = Provider.of(context, listen: false);
    _activityProvider = Provider.of(context, listen: false);
    _tradesProvider = Provider.of(context, listen: false);
    navigateAuthenticationProvider = Provider.of(context, listen: false);
    _customHomeAppBarProvider = Provider.of(context, listen: false);
    _tradeMainProvider = Provider.of(context, listen: false);
    _currencyConstantsProvider = Provider.of(context, listen: false);
    webSocketServiceProvider = Provider.of(context, listen: false);
    appConfigProvider = Provider.of(context, listen: false);
    welcomeScreensProvider = Provider.of(context, listen: false);
    connectivityProvider = Provider.of(context, listen: false);
    profileProvider = Provider.of(context, listen: false);

    // if (webSocketServiceProvider.status == "Disconnected") {
    //   webSocketServiceProvider.connect("ws://pxkjng5f-3000.inc1.devtunnels.ms/selected-stocks?userId=717");
    // }

    // callInitialApi();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkNavigation();
      getAppVersionInfo();
    });

    if (kIsWeb == false) {
      notificationProvider =
          Provider.of<NotificationProvider>(context, listen: false);
    }
  }

  String version = "1.0.0";
  String buildNumber = "1";
  Future<void> getAppVersionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    // String appName = packageInfo.appName;
    // String packageName = packageInfo.packageName;
    version = packageInfo.version; // e.g. "1.0.0"
    buildNumber = packageInfo.buildNumber; // e.g. "1"

    // print('App Name: $appName');
    // print('Package Name: $packageName');
    // print('Version: $version');
    // print('Build Number: $buildNumber');
  }

  checkNavigation() async {
    bool value = await appConfigProvider.checkServerStatus();

    // if(connectivityProvider.connectionStatus.contains(ConnectivityResult.wifi) ||
    //     connectivityProvider.connectionStatus.contains(ConnectivityResult.mobile) ||
    //     connectivityProvider.connectionStatus.contains(ConnectivityResult.ethernet) ||
    //     connectivityProvider.connectionStatus.contains(ConnectivityResult.vpn)){
    if (true) {
      // print("inside wifi");

      if (value == false) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ServerUnderMaintenanceScreen(),
          ),
        );
      } else {
        bool checkIsFirstTime =
            await SharedPreferenceManager.getIsFirstTimeInApp() ?? true;
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final pref = await SharedPreferences.getInstance();
          final userId = pref.getInt("reg_id") ?? 0;

          if(userId != 0) {
            _customHomeAppBarProvider!.callInitialApi();
            profileProvider.getProfileData();
            _customHomeAppBarProvider!.getUserAccountDetails;
          }

          // if(pinFocusNode.canRequestFocus){
          //   FocusScope.of(context).requestFocus(pinFocusNode);
          // }
        });
        await appConfigProvider.getAppConfig();


        if (kIsWeb == false) {
          if (appConfigProvider.appConfigData.data?.welcomeScreenData != null) {
            print("assigning welcomescreendata");
            welcomeScreensProvider.welcomeScreenData =
                appConfigProvider.appConfigData.data!.welcomeScreenData!;
            setState(() {});
          }
        }
        // if(appConfigProvider.appConfigData.welcomeScreenData != null) {
        //   print("assigning welcomescreendata");
        //   welcomeScreensProvider.welcomeScreenData = appConfigProvider.appConfigData.welcomeScreenData!;
        //   setState(() {
        //
        //   });
        // }

        await Future.delayed(Duration(seconds: 3), () {
          if (checkIsFirstTime) {
            SharedPreferenceManager.saveIsFirstTimeInApp(false);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => WelcomeScreen(),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => NavigateAuthenticationScreen(),
              ),
            );
          }
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => NavigateAuthenticationScreen(),
          //   ),
          // );
        });
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NoInternetScreen(),
        ),
      );
    }

    handleAppMessage();


  }

  handleAppMessage() async {

    print("inside handleAppMessage");

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int buildNumber = int.parse(packageInfo.buildNumber);

    print("after getting buildNumber");
    print(kIsWeb);
    // print(Platform.isAndroid);
    // print(Platform.isIOS);

    if(kIsWeb) {

      print("inside web");

      if(appConfigProvider.appConfigData.data != null) {
        if(appConfigProvider.appConfigData.data!.updateMessageOutSide != null) {
          if(appConfigProvider.appConfigData.data!.updateMessageOutSide!.web != null) {
            print("below is web build number");
            print(appConfigProvider.appConfigData.data!.updateMessageOutSide!.web!.minBuildNumber);
            print(buildNumber);
            if((appConfigProvider.appConfigData.data!.updateMessageOutSide!.web!.minBuildNumber ?? 0) >= buildNumber) {
              print("passing all the condition and showing popup");
              Utility().showInAppMessage(context, appConfigProvider.appConfigData.data!.updateMessageOutSide!.web!.message ?? "Message", appConfigProvider.appConfigData.data!.updateMessageOutSide!.web!.subMessage ?? "Message");
            }
          }
        }
      }

      // Utility().showInAppMessage(context, "Message", "web description jfldsj s jfksjfls jsj lfj slfjsl jsdfldjl sjflsjf lsj slfjs fjsljfsl slfjs lfjs fsj fs;fjs;lfjs; fjs");

    } else if(Platform.isIOS) {

      print("iside ios");

      if(appConfigProvider.appConfigData.data != null) {
        if(appConfigProvider.appConfigData.data!.updateMessageOutSide != null) {
          if(appConfigProvider.appConfigData.data!.updateMessageOutSide!.ios != null) {
            print("iside ios 2");
            print(appConfigProvider.appConfigData.data!.updateMessageOutSide!.ios!.minBuildNumber);
            print(buildNumber);
            if((appConfigProvider.appConfigData.data!.updateMessageOutSide!.ios!.minBuildNumber ?? 0) >= buildNumber) {

              print(appConfigProvider.appConfigData.data!.updateMessageOutSide!.ios!.minBuildNumber);
              Utility().showInAppMessage(context, appConfigProvider.appConfigData.data!.updateMessageOutSide!.ios!.message ?? "Message", appConfigProvider.appConfigData.data!.updateMessageOutSide!.ios!.subMessage ?? "Message");
            }
          }
        }
      }
      // Utility().showInAppMessage(context, "Message", "ios description jfldsj s jfksjfls jsj lfj slfjsl jsdfldjl sjflsjf lsj slfjs fjsljfsl slfjs lfjs fsj fs;fjs;lfjs; fjs");

    } else if (Platform.isAndroid) {

      print("below is log");
      log(jsonEncode(appConfigProvider.appConfigData.data));

      if(appConfigProvider.appConfigData.data != null) {
        if(appConfigProvider.appConfigData.data!.updateMessageOutSide != null) {
          if(appConfigProvider.appConfigData.data!.updateMessageOutSide!.android != null) {
            if((appConfigProvider.appConfigData.data!.updateMessageOutSide!.android!.minBuildNumber ?? 0) >= buildNumber) {
              Utility().showInAppMessage(context, appConfigProvider.appConfigData.data!.updateMessageOutSide!.android!.message ?? "Message", appConfigProvider.appConfigData.data!.updateMessageOutSide!.android!.subMessage ?? "Message");
            }
          }
        }
      }

      // Utility().showInAppMessage(context, "Message", "android description jfldsj s jfksjfls jsj lfj slfjsl jsdfldjl sjflsjf lsj slfjs fjsljfsl slfjs lfjs fsj fs;fjs;lfjs; fjs");

    }
  }

  Future<void> callInitialApi() async {
    try {
      SharedPreferences value = await SharedPreferences.getInstance();

      if (value.getInt("reg_id") != null) {
        await _customHomeAppBarProvider!.fetchUserAccountDetails();
        await _customHomeAppBarProvider!.getAppPackageInfo();

        await _tradeMainProvider!.getTradeMenuButtonsVisibilityStatus();
        // await _tradeMainProvider!
        //     .initialGetLadderData(_currencyConstantsProvider!);
        await _ladderProvider!.fetchAllLadder(_currencyConstantsProvider!);
        await _tradeMainProvider!.getActiveLadderTickers(context);
        await _tradesProvider!.fetchTrades(_currencyConstantsProvider!);
        await _orderProvider!.fetchOrders(_currencyConstantsProvider!);
        await _positionProvider!.fetchPositions(_currencyConstantsProvider!);
        await _activityProvider!.fetchActivities();
        _customHomeAppBarProvider!.getFieldVisibilityOfAccountInfoBar();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NavigateAuthenticationScreen(),
          ),
        );
      } else {
        Future.delayed(Duration(seconds: 3), () {});
      }
    } on HttpApiException catch (err) {
      // print(err.errorTitle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
          Image.asset(
              // 'lib/global/assets/logos/dozendiamond_logo.jpeg',
              'lib/global/assets/logos/kosh_logo_without_bg.png',
              color: Colors.white,
              height: 400,
              width: 400),
        ]))),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "v${version}+${buildNumber}",
              style: GoogleFonts.poppins(

              ),
            )
          ],
        ),
      ),
    );
  }
}
