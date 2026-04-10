

import 'package:flutter/material.dart';

import '../functions/screenWidthRecoginzer.dart';

class ServerUnderMaintenanceScreen extends StatelessWidget {
  const ServerUnderMaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {

    double screenWidth = screenWidthRecognizer(context);

    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Center(
              child: Image.asset(
                // 'lib/global/assets/lottie/under_maintenance.gif',
                'lib/global/assets/images/under_maintenance.png',
                width: screenWidth - 50,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(
              height: 30,
            ),

            Center(
              child: Text(
                "Server Under Maintenance",
                style: TextStyle(
                  fontSize: 25
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
