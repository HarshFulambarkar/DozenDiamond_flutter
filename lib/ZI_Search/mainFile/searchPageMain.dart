
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../ZI_Search/stateManagement/search_provider.dart';
import 'dart:io';




import '../screens/search_page.dart';

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

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//   ]);
//   HttpOverrides.global = MyHttpOverrides();
//   runApp(const LoginMain());
// }

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

    GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: SearchProvider(navigatorKey)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
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
          "/": (context) => SearchPageNew(
                updateIndex: () {},
                refreshProviderState: false,
              ),
        },
      ),
      // home: const LoginPage(),
    );
  }
}
