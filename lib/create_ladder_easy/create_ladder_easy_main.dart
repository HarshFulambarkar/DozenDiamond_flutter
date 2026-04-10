import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ZI_Search/mainFile/searchPageMain.dart';
import 'screens/create_ladder_easy_screen.dart';
import 'stateManagement/create_ladder_easy_provider.dart';

class CreateLadderEasyMain extends StatefulWidget {
  const CreateLadderEasyMain({Key? key}) : super(key: key);

  @override
  State<CreateLadderEasyMain> createState() => _CreateLadderEasyMainState();
}

class _CreateLadderEasyMainState extends State<CreateLadderEasyMain> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    return CreateLadderEasyScreen();
    // return MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider.value(value: CreateLadderEasyProvider(navigatorKey)),
    //   ],
    //   child: MaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     navigatorKey: navigatorKey,
    //     title: 'CreateLadderEasy',
    //     theme: ThemeData(
    //       scaffoldBackgroundColor: const Color(0xFF15181F),
    //       textTheme: const TextTheme(
    //         displayLarge: appTextStyle,
    //         displayMedium: appTextStyle,
    //         displaySmall: appTextStyle,
    //         headlineLarge: appTextStyle,
    //         headlineMedium: appTextStyle,
    //         headlineSmall: appTextStyle,
    //         titleLarge: appTextStyle,
    //         titleMedium: appTextStyle,
    //         titleSmall: appTextStyle,
    //         bodyLarge: appTextStyle,
    //         bodyMedium: appTextStyle,
    //         bodySmall: appTextStyle,
    //         labelLarge: appTextStyle,
    //         labelMedium: appTextStyle,
    //         labelSmall: appTextStyle,
    //       ),
    //       primarySwatch: Colors.blue,
    //       visualDensity: VisualDensity.adaptivePlatformDensity,
    //     ),
    //     routes: {
    //       "/": (context) => CreateLadderEasyScreen(),
    //       // "/": (context) => AadhaarUiScreen(),
    //     },
    //   ),
    //   // home: const LoginPage(),
    // );
  }
}
