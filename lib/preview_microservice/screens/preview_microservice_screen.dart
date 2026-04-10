import 'package:flutter/material.dart';

import '../../DD_Navigation/widgets/nav_drawer.dart';
import '../../DD_Navigation/widgets/nav_drawer_new.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../ZH_Analysis/screens/select_analysis_type.dart';

class PreviewMicroserviceScreen extends StatelessWidget {
  PreviewMicroserviceScreen({super.key});

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  void _triggerDrawer() {
    print("in _triggerDrawer");
    _key.currentState!.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: const NavDrawerNew(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(
                      height: 20,
                    ),

                    // SizedBox(
                    //   height: AppBar().preferredSize.height * 1.2,
                    // ),

                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: const Text(
                                'Preview Microservice',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: const Color(0xFF0099CC),
                                padding:
                                const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                side: const BorderSide(
                                  color: Color(0xFF0099CC),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SelectAnalysisType()),
                                );
                              },
                              child: const Text(
                                'Preview Analytics Microservice',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              // CustomHomeAppBarWithProvider(
              //   backButton: false,
              //   leadingAction: _triggerDrawer,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
