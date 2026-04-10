import 'package:dozen_diamond/kyc/provider/kyc_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/verify_aadhaar_screen.dart';

class KycMain extends StatefulWidget {
  const KycMain({Key? key}) : super(key: key);

  @override
  State<KycMain> createState() => _KycMainState();
}

class _KycMainState extends State<KycMain> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: KycProvider(navigatorKey)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        title: 'Dozen Diamonds Kosh',
        // title: 'Flutter LoginPage',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFF15181F),
          textTheme: const TextTheme(

          ),
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          "/": (context) => VerifyAadhaarScreen(),
          // "/": (context) => AadhaarUiScreen(),
        },
      ),
      // home: const LoginPage(),
    );
  }
}