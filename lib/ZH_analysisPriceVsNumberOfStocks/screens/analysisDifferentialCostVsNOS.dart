import 'package:flutter/material.dart';

import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';

class DifferentialCostVsNOS extends StatefulWidget {
  const DifferentialCostVsNOS({super.key});

  @override
  State<DifferentialCostVsNOS> createState() => _DifferentialCostVsNOSState();
}

class _DifferentialCostVsNOSState extends State<DifferentialCostVsNOS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Text(
                "Coming Soon",
                style: TextStyle(
                    fontSize: 20
                ),
              ),
            ),

            CustomHomeAppBarWithProviderNew(backButton: true, isForPop: true),
          ],
        ),
      ),
    );
  }
}
