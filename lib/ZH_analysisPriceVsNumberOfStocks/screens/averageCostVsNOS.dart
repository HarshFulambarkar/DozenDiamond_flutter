import 'package:flutter/material.dart';

import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';

class AverageCostVsNOS extends StatefulWidget {
  const AverageCostVsNOS({super.key});

  @override
  State<AverageCostVsNOS> createState() => _AverageCostVsNOSState();
}

class _AverageCostVsNOSState extends State<AverageCostVsNOS> {
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
