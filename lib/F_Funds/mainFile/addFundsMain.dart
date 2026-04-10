import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../AB_ladder/stateManagement/buy_sell_provider.dart';

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
  runApp(const LoginMain());
}

class LoginMain extends StatefulWidget {
  const LoginMain({Key? key}) : super(key: key);

  @override
  State<LoginMain> createState() => _LoginMainState();
}

class _LoginMainState extends State<LoginMain> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: BuySellProvider()),
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
          // "/": (context) => AddFunds(updateIndex: ),
        },
      ),
      // home: const LoginPage(),
    );
  }
}
