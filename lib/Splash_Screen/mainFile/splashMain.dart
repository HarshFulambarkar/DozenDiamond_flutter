import 'package:dozen_diamond/Splash_Screen/Screen/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../AB_ladder/stateManagement/buy_sell_provider.dart';
import '../../ZB_accountInfoBar/stateManagement/custom_home_app_bar_provider.dart';

import 'dart:io';

const appTextStyle =
    TextStyle(color: Colors.white, fontFamily: "Roboto_Condensed");

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: BuySellProvider()),
        ChangeNotifierProvider.value(value: CustomHomeAppBarProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dozen Diamonds Kosh',
        // title: 'Flutter LoginPage',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFF15181F),
          textTheme: const TextTheme(
            displayLarge: appTextStyle,
            displayMedium: appTextStyle,
            displaySmall: appTextStyle,
            headlineLarge: appTextStyle,
            headlineMedium: appTextStyle,
            headlineSmall: appTextStyle,
            titleLarge: appTextStyle,
            titleMedium: appTextStyle,
            titleSmall: appTextStyle,
            bodyLarge: appTextStyle,
            bodyMedium: appTextStyle,
            bodySmall: appTextStyle,
            labelLarge: appTextStyle,
            labelMedium: appTextStyle,
            labelSmall: appTextStyle,
          ),
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          "/": (context) => SplashScreen(),
        },
        // home: const LoginPage(),
      ),
    );
  }
}
