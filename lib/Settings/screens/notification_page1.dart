import 'package:dozen_diamond/Settings/screens/push_notification_page.dart';

import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../settings/models/settings_content_model.dart';
import 'package:flutter/material.dart';

class NotificationPage1 extends StatefulWidget {
  const NotificationPage1({super.key});

  @override
  State<NotificationPage1> createState() => _NotificationPage1State();
}

class _NotificationPage1State extends State<NotificationPage1> {
  final List<SettingsContentModel> settingscontentlist = [
    SettingsContentModel(
      icons: const Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.white,
      ),
      routes: const PushNotificationPage(),
      title: "Push Notifications",
    ),
    SettingsContentModel(
      icons: const Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.white,
      ),
      routes: const Text(""),
      title: "Email Notifications",
    ),
    SettingsContentModel(
      icons: const Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.white,
      ),
      routes: const Text(""),
      title: "Messages",
    ),
    SettingsContentModel(
      icons: const Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.white,
      ),
      routes: const Text(""),
      title: "Muted",
    ),
  ];

  Widget mainContent() {
    return Expanded(
        child: SingleChildScrollView(
      child: Column(
        children: settingscontentlist
            .map(
              (e) => Column(
                children: [
                  InkWell(
                    onTap: () async {
                      var test = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => e.routes,
                        ),
                      );
                      print("test$test");
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 15, top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            e.title,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 0,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Divider(
                      indent: 10,
                      endIndent: 10,
                      color: Colors.white54,
                      thickness: 1,
                    ),
                  )
                ],
              ),
            )
            .toList(),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              // padding: const EdgeInsets.only(top: 60.0),
              padding: const EdgeInsets.only(top: 45.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // header(),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 15, top: 20, bottom: 20),
                    child: const Text(
                      "Notifications and Messages",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  mainContent(),
                ],
              ),
            ),
            CustomHomeAppBarWithProviderNew(backButton: true),
          ],
        ),
      ),
    );
  }
}
