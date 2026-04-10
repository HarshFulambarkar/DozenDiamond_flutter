import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dozen_diamond/DD_Navigation/stateManagement/navigation_provider.dart';
import 'package:dozen_diamond/merge_ladder/screens/merge_ladder_screen.dart';
import 'package:dozen_diamond/merge_ladder/stateManagement/dart/merge_ladder_provider.dart';
import '../Settings/mainFile/settingsMain.dart';
import '../global/constants/currency_constants.dart';


class MergeLadderMain extends StatefulWidget {
  const MergeLadderMain({super.key});

  @override
  State<MergeLadderMain> createState() => _MergeLadderMainState();
}

class _MergeLadderMainState extends State<MergeLadderMain> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: MergeLadderProvider(navigatorKey)),
        ChangeNotifierProvider.value(value: CurrencyConstants()),
        ChangeNotifierProvider.value(value: NavigationProvider()),
        ChangeNotifierProvider.value(value: MergeLadderProvider(navigatorKey)),
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
          "/": (context) => MergeLadderScreen(),
          // "/": (context) => AadhaarUiScreen(),
        },
      ),
      // home: const LoginPage(),
    );
  }
}