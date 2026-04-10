import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dozen_diamond/ladder_add_or_withdraw_cash/screens/ladder_add_or_withdraw_cash_screen.dart';
import 'package:dozen_diamond/ladder_add_or_withdraw_cash/stateManagement/ladder_add_or_withdraw_cash_provider.dart';

import '../Settings/mainFile/settingsMain.dart';
import '../global/constants/currency_constants.dart';

class LadderAddOrWithdrawCashMain extends StatefulWidget {
  const LadderAddOrWithdrawCashMain({super.key});

  @override
  State<LadderAddOrWithdrawCashMain> createState() =>
      _LadderAddOrWithdrawCashMainState();
}

class _LadderAddOrWithdrawCashMainState
    extends State<LadderAddOrWithdrawCashMain> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
            value: LadderAddOrWithdrawCashProvider(navigatorKey)),
        ChangeNotifierProvider.value(value: CurrencyConstants()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        title: 'Dozen Diamonds Kosh',
        // title: '',
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
          "/": (context) => LadderAddOrWithdrawCashScreen(),
          // "/": (context) => AadhaarUiScreen(),
        },
      ),
      // home: const LoginPage(),
    );
  }
}
