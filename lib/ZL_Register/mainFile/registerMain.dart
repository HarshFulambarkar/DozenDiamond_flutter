
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import '../../global/constants/theme_manager.dart';
import '../screens/signup_page.dart';

const appTextStyle =
    TextStyle(color: Colors.white, fontFamily: "Roboto_Condensed");

ThemeManager themeManager = new ThemeManager();

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dozen Diamonds Kosh',
      // title: 'Flutter LoginPage',
      theme: themeManager.darkThemeData,

      routes: {
        "/": (context) => SignUpPage(),
      },
      // home: const LoginPage(),
    );
  }
}
