import 'dart:async';

import 'package:dozen_diamond/AA_positions/stateManagement/position_provider.dart';
import 'package:dozen_diamond/AB_Ladder/stateManagement/buy_sell_provider.dart';
import 'package:dozen_diamond/AB_Ladder/stateManagement/ladder_provider.dart';
import 'package:dozen_diamond/AC_trades/stateManagement/trades_provider.dart';
import 'package:dozen_diamond/AD_Orders/stateManagement/order_provider.dart';
import 'package:dozen_diamond/AE_Activity/stateManagement/activity_provider.dart';
import 'package:dozen_diamond/DD_Navigation/stateManagement/navigation_provider.dart';
import 'package:dozen_diamond/Empty_ladder/stateManagement/emptyLadderProvider.dart';
import 'package:dozen_diamond/F_Funds/stateManagement/funds_provider.dart';
import 'package:dozen_diamond/Settings/stateManagement/setting_provider.dart';
import 'package:dozen_diamond/Settings/stateManagement/theme_provider.dart';
import 'package:dozen_diamond/Splash_Screen/Screen/splashScreen.dart';
import 'package:dozen_diamond/ZB_accountInfoBar/stateManagement/custom_home_app_bar_provider.dart';
import 'package:dozen_diamond/ZH_analysisPriceVsNumberOfStocks/stateManagement/analyticsDateProvider.dart';
import 'package:dozen_diamond/ZI_Search/stateManagement/search_provider.dart';
import 'package:dozen_diamond/ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
import 'package:dozen_diamond/ZZZZ_main/services/push_notification.dart';
import 'package:dozen_diamond/articles/stateManagement/article_provider.dart';
import 'package:dozen_diamond/authentication/stateManagement/authenticationProvider.dart';
import 'package:dozen_diamond/create_ladder_detailed/stateManagement/create_ladder_provider.dart';
import 'package:dozen_diamond/manage_brokers/shoonya/stateManagement/shoonya_broker_provider.dart';
// import 'package:dozen_diamond/prior_buy_create_ladder/stateManagement/create_ladder_provider.dart' as prior_buy;
import 'package:dozen_diamond/firebase_options.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:dozen_diamond/global/constants/theme_manager.dart';
import 'package:dozen_diamond/global/widgets/error_dialog.dart';
import 'package:dozen_diamond/ladder_add_or_withdraw_cash/stateManagement/ladder_add_or_withdraw_cash_provider.dart';
import 'package:dozen_diamond/manage_brokers/IIFL/stateManagement/iifl_broker_provider.dart';
import 'package:dozen_diamond/navigateAuthentication/stateManagement/navigate_authentication_provider.dart';
import 'package:dozen_diamond/reminders/services/reminder_service.dart';
import 'package:dozen_diamond/run_revert/stateManagement/runRevertProvider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../access_real_time_trading_otp/stateManagement/webinar_otp_provider.dart';
import '../../authentication/stateManagement/authenticationProvider.dart';
import '../../broker_info/stateManagement/broker_info_provider.dart';
import '../../create_ladder_easy/stateManagement/create_ladder_easy_provider.dart';
import '../../depositories_verification/stateManagement/depositories_verification_provider.dart';
import '../../global/services/stock_price_listener.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

import '../../global/stateManagement/app_config_provider.dart';
import '../../global/stateManagement/connectivity_provider.dart';
import '../../global/stateManagement/one_click_ladder_provider.dart';
import '../../global/stateManagement/progress_provider.dart';
import '../../global/stateManagement/user_config_provider.dart';
import '../../kyc/provider/kyc_provider.dart';
import '../../login/stateManagement/auth_provider.dart';
import '../../manage_brokers/5paisa/stateManagement/5paisa_broker_provider.dart';
import '../../manage_brokers/ICICISecurities/stateManagement/icici_security_provider.dart';
import '../../manage_brokers/angle_one/stateManagement/angle_one_broker_provider.dart';
import '../../manage_brokers/kotak_neo/stateManagement/kotak_neo_broker_provider.dart';
import '../../manage_brokers/motilal_oswal/stateManagement/motilal_oswal_broker_provider.dart';
import '../../manage_brokers/profitmart/stateManagement/profitmart_provider.dart';
import '../../manage_brokers/sharekhan/stateManagement/sharekhan_provider.dart';
import '../../manage_brokers/smc/stateManagement/smc_broker_provider.dart';
import '../../manage_brokers/stateManagement/manage_brokers_provider.dart';
import '../../manage_brokers/upstox/stateManagement/upstox_broker_provider.dart';
import '../../manage_brokers/zerodha/stateManagement/zerodha_provider.dart';
import '../../merge_ladder/stateManagement/dart/merge_ladder_provider.dart';
import '../../modify_ladder_target_price/stateManagment/modifyLadderTargetPriceProvider.dart';
import '../../move_funds_to_ladder/stateManagement/move_funds_to_ladder_provider.dart';
import '../../notifications/stateManagement/notification_screen_provider.dart';
import '../../profile/stateManagement/profile_provider.dart';
import '../../questionnaire/stateManagement/questionnaire_provider.dart';
import '../../reminders/stateManagement/reminder_provider.dart';
import '../../replicate_or_reduce/stateManagement/replicate_or_reduce_provider.dart';
import '../../socket_manager/stateManagement/web_socket_service_provider.dart';
import '../../strategies/stateManagement/strategies_provider.dart';
import '../../subscriptions/stateManagement/subscription_provider.dart';
import '../../watchlist/stateManagement/watchlist_provider.dart';
import '../../welcome_screens/screens/welcome_screen.dart';
import '../../welcome_screens/stateManagement/welcome_screens_provider.dart';
import '../services/push_notification.dart';
import '../stateManagement/notification_provider.dart';

ThemeManager themeManager = new ThemeManager();

final GlobalKey<NavigatorState> globalNavigatorKey =
    GlobalKey<NavigatorState>();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    // print("Some notification received");
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // print("Handling background message: ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb == false) {
    WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initialize Firebase
    // FacebookSdk.sdkInitialize();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  //<--------starts here ------->
  // if (!kIsWeb && Platform.isIOS == false) {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  //   String userNotificationToken = await PushNotification.init();
  //   //listening to background notification
  //   print("here is the token $userNotificationToken");
  //   FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);
  //   // MainFileService().pushNotificationResponse(userNotificationToken);
  // }
  //<-------ends here----------->

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  HttpOverrides.global = MyHttpOverrides();
  TeXRenderingServer.start();

  ReminderService().start();

  // Crashlytics – Dart errors
  if (kIsWeb) {
    runApp(const MyApp());
  } else {
    runZonedGuarded(() {
      runApp(MyApp());
    }, FirebaseCrashlytics.instance.recordError);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: RunRevertProvider()),
        ChangeNotifierProvider.value(value: ThemeProvider()),
        ChangeNotifierProvider.value(value: BuySellProvider()),
        ChangeNotifierProvider.value(value: CustomHomeAppBarProvider()),
        ChangeNotifierProvider.value(value: CreateLadderProvider()),
        // ChangeNotifierProvider.value(value: prior_buy.CreateLadderProvider()),
        ChangeNotifierProvider.value(value: StockPriceListener()),
        ChangeNotifierProvider.value(value: PositionProvider()),
        ChangeNotifierProvider.value(value: LadderProvider()),
        ChangeNotifierProvider.value(value: TradesProvider()),
        ChangeNotifierProvider.value(value: OrderProvider()),
        ChangeNotifierProvider.value(value: ActivityProvider()),
        ChangeNotifierProvider.value(value: TradeMainProvider()),
        ChangeNotifierProvider.value(value: FundsProvider()),
        ChangeNotifierProvider.value(value: DateTimeProvider()),
        ChangeNotifierProvider.value(value: NavigationProvider()),
        ChangeNotifierProvider.value(
          value: AuthenticationProvider(navigatorKey),
        ),
        ChangeNotifierProvider.value(
          value: LadderAddOrWithdrawCashProvider(navigatorKey),
        ),
        ChangeNotifierProvider.value(value: SearchProvider(navigatorKey)),
        ChangeNotifierProvider.value(value: ApiStateProvider()),
        ChangeNotifierProvider.value(
          value: NavigateAuthenticationProvider(navigatorKey),
        ),
        ChangeNotifierProvider.value(value: CurrencyConstants()),
        ChangeNotifierProvider.value(
          value: CreateLadderEasyProvider(navigatorKey),
        ),
        ChangeNotifierProvider.value(value: SettingProvider()),
        ChangeNotifierProvider.value(value: ModifyLadderTargetPriceProvider()),
        ChangeNotifierProvider.value(value: MergeLadderProvider(navigatorKey)),
        ChangeNotifierProvider.value(
          value: ManageBrokersProvider(navigatorKey),
        ),
        ChangeNotifierProvider.value(
          value: UpstoxBrokersProvider(navigatorKey),
        ),
        ChangeNotifierProvider.value(value: IIFLBrokersProvider(navigatorKey)),
        ChangeNotifierProvider.value(
          value: IciciSecurityBrokersProvider(navigatorKey),
        ),
        ChangeNotifierProvider.value(value: SubscriptionProvider(navigatorKey)),
        ChangeNotifierProvider.value(
          value: KotakNeoBrokersProvider(navigatorKey),
        ),
        ChangeNotifierProvider.value(value: SmcBrokersProvider(navigatorKey)),
        ChangeNotifierProvider.value(
          value: PaachPaisaBrokersProvider(navigatorKey),
        ),
        ChangeNotifierProvider.value(
          value: ReplicateOrReduceProvider(navigatorKey),
        ),
        ChangeNotifierProvider.value(
          value: MoveFundsToLadderProvider(navigatorKey),
        ),
        ChangeNotifierProvider.value(value: WatchlistProvider(navigatorKey)),
        ChangeNotifierProvider.value(
          value: WebSocketServiceProvider(navigatorKey),
        ),
        ChangeNotifierProvider.value(
          value: AngleOneBrokersProvider(navigatorKey),
        ),
        ChangeNotifierProvider.value(value: EmptyLadderProvider()),
        ChangeNotifierProvider.value(
          value: MotilalOswalBrokersProvider(navigatorKey),
        ),
        ChangeNotifierProvider.value(value: BrokerInfoProvider(navigatorKey)),
        ChangeNotifierProvider.value(value: StrategiesProvider(navigatorKey)),
        ChangeNotifierProvider.value(value: AppConfigProvider(navigatorKey)),
        ChangeNotifierProvider.value(value: KycProvider(navigatorKey)),
        ChangeNotifierProvider.value(
          value: WelcomeScreensProvider(navigatorKey),
        ),
        ChangeNotifierProvider.value(
          value: AuthenticationProvider(navigatorKey),
        ),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => ProgressProvider()),
        ChangeNotifierProvider(
          create: (_) => DepositoriesVerificationProvider(navigatorKey),
        ),
        ChangeNotifierProvider(create: (_) => AuthProvider(navigatorKey)),
        ChangeNotifierProvider(
          create: (_) => QuestionnaireProvider(navigatorKey)..loadQuestions(),
        ),
        ChangeNotifierProvider(create: (_) => ProfileProvider(navigatorKey)),
        ChangeNotifierProvider(create: (_) => UserConfigProvider(navigatorKey)),
        ChangeNotifierProvider(create: (_) => WebinarOtpProvider(navigatorKey)),
        ChangeNotifierProvider(create: (_) => ProfitmartProvider(navigatorKey)),
        ChangeNotifierProvider(
          create: (_) => ShoonyaBrokersProvider(navigatorKey),
        ),
        ChangeNotifierProvider(create: (_) => ZerodhaProvider(navigatorKey)),
        ChangeNotifierProvider.value(value: SharekhanProvider(navigatorKey)),
        ChangeNotifierProvider(create: (_) => ReminderProvider()),
        ChangeNotifierProvider(create: (_) => ArticleProvider()),
        ChangeNotifierProvider(create: (_) => OneClickLadderProvider()),
        ChangeNotifierProvider(create: (_) => NotificationScreenProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, value, child) {
          return GetMaterialApp(
            navigatorKey: globalNavigatorKey,
            builder: (context, child) {
              return Consumer<ThemeProvider>(
                builder: (context, themeProviderProvider, _) {
                  return MediaQuery(
                    data: MediaQuery.of(context)
                        // .copyWith(textScaler: TextScaler.linear(0.9)),
                        .copyWith(
                          textScaler: TextScaler.linear(
                            themeProviderProvider.textScaleFactor,
                          ),
                        ),
                    child: child!,
                  );
                },
              );
            },
            debugShowCheckedModeBanner: false,
            title: 'Dozen Diamonds Kosh',
            // title: 'Flutter LoginPage',
            theme: value.defaultTheme
                ? themeManager.defaultThemeData
                : themeManager.darkThemeData,

            routes: {
              "/": (context) => SplashScreen(),
              // "/": (context) => ChangeBaseUrlScreen(),
              // "/": (context) => WelcomeScreen(),
            },

            // home: const LoginPage(),
          );
        },
      ),
    );
  }
}
