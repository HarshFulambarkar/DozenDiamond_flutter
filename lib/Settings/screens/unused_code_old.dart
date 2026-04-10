import 'package:dozen_diamond/Settings/models/settings_content_model.dart';
import 'package:dozen_diamond/Settings/screens/multiple_ladder_creation_setting.dart';
import 'package:dozen_diamond/Settings/screens/notification_page1.dart';
import 'package:dozen_diamond/Settings/screens/theme_screen.dart';
import 'package:dozen_diamond/Settings/stateManagement/theme_provider.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

// these code contains the old screen ui of the setting page
final List<SettingsContentModel> settingscontentlist = [
  SettingsContentModel(
    icons: const Icon(
      Icons.arrow_forward_ios_rounded,
      color: Colors.white,
    ),
    routes: const NotificationPage1(),
    subtitle: "Notifications and messages",
    title: "Account",
  ),
  SettingsContentModel(
    icons: const Icon(
      Icons.arrow_forward_ios_rounded,
      color: Colors.white,
    ),
    routes: const ThemeScreen(),
    subtitle: "Change the theme of the App",
    title: "Theme",
  ),
  SettingsContentModel(
    icons: const Icon(
      Icons.arrow_forward_ios_rounded,
      color: Colors.white,
    ),
    routes: const ThemeScreen(),
    subtitle: "Select your Trading Options",
    title: "Trading Options",
  ),
  SettingsContentModel(
    icons: const Icon(
      Icons.arrow_forward_ios_rounded,
      color: Colors.white,
    ),
    routes: const MultipleLadderCreation(),
    subtitle: "Enabling and Disabling Multiple Ladder Creation",
    title: "Ladder Creation",
  ),
  SettingsContentModel(
    icons: const Icon(
      Icons.arrow_forward_ios_rounded,
      color: Colors.white,
    ),
    routes: const Text(""),
    subtitle: "Invite Friends, Past Invites",
    title: "Free Stocks",
  ),
  SettingsContentModel(
    icons: const Icon(
      Icons.arrow_forward_ios_rounded,
      color: Colors.white,
    ),
    routes: const Text(""),
    subtitle: "Status, Balance, Docs, Taxes",
    title: "Account Summary",
  ),
  SettingsContentModel(
    icons: const Icon(
      Icons.arrow_forward_ios_rounded,
      color: Colors.white,
    ),
    routes: const Text(""),
    subtitle: "Deposits, Withdrawals",
    title: "Transfers",
  ),
  SettingsContentModel(
    icons: const Icon(
      Icons.arrow_forward_ios_rounded,
    ),
    routes: const Text(""),
    subtitle: "Traders, Dividends, Transfers",
    title: "History",
  ),
  SettingsContentModel(
    icons: const Icon(
      Icons.arrow_forward_ios_rounded,
    ),
    routes: const Text(""),
    subtitle: "Support, Guides",
    title: "Help",
  ),
  SettingsContentModel(
    icons: const Icon(
      Icons.arrow_forward_ios_rounded,
      color: Colors.white,
    ),
    routes: const Text(""),
    subtitle: "IRHSI 992555960",
    title: "Account No.",
  ),
];
Widget header() {
  return Container(
    alignment: Alignment.topLeft,
    margin: const EdgeInsets.only(
      left: 20,
      top: 10,
      bottom: 10,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Total Value",
          style: TextStyle(
            color: Color(0xFF0099CC),
            fontSize: 24,
          ),
        ),
        Text(
          "${CurrencyConstants().currency} 10,000.50",
          style: TextStyle(
            color: Color(0xFF0099CC),
            fontSize: 24,
          ),
        ),
      ],
    ),
  );
}

Widget mainContent() {
  return Expanded(
      child: SingleChildScrollView(
    child: Column(
      children: settingscontentlist
          .map(
            (e) => Consumer<ThemeProvider>(builder: (context, value, child) {
              return Column(
                children: [
                  ListTile(
                    dense: true,
                    trailing: Icon(Icons.arrow_forward_ios_rounded,
                        size: 18,
                        color:
                            value.defaultTheme ? Colors.black : Colors.white),
                    title: Text(
                      e.title,
                      style: const TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      e.subtitle,
                      style: const TextStyle(fontSize: 16),
                    ),
                    onTap: () async {
                      print(
                          "Here is your route before ${settingscontentlist[2].routes}");
                      if (e.routes == settingscontentlist[1].routes ||
                          e.routes == settingscontentlist[2].routes) {
                        print("Here is your route ${e.routes}");
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => e.routes,
                          ),
                        );
                      } else {
                        Fluttertoast.showToast(
                            msg: "This feature will unlock soon");
                      }

                      // print("test$test");
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Divider(
                      color:
                          value.defaultTheme ? Colors.black54 : Colors.white54,
                      thickness: 1,
                    ),
                  )
                ],
              );
            }),
          )
          .toList(),
    ),
  ));
}
