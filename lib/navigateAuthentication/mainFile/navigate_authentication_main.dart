import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/navigate_authentication_screen.dart';
import '../stateManagement/navigate_authentication_provider.dart';


class NavigateAuthenticationMain extends StatefulWidget {
  const NavigateAuthenticationMain({Key? key}) : super(key: key);

  @override
  State<NavigateAuthenticationMain> createState() => _NavigateAuthenticationMainState();
}

class _NavigateAuthenticationMainState extends State<NavigateAuthenticationMain> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: NavigateAuthenticationProvider(navigatorKey)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        title: 'Dozen Diamonds Kosh',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFF15181F),
          textTheme: const TextTheme(

          ),
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          "/": (context) => NavigateAuthenticationScreen(),
          // "/": (context) => AadhaarUiScreen(),
        },
      ),
      // home: const LoginPage(),
    );
  }
}