import 'package:flutter/material.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';

class PushNotificationPage extends StatefulWidget {
  const PushNotificationPage({super.key});

  @override
  State<PushNotificationPage> createState() => _PushNotificationPageState();
}

class _PushNotificationPageState extends State<PushNotificationPage> {
  var switchOnOff = false;
  var switchOnOff1 = false;
  var switchOnOff2 = false;
  var switchOnOff3 = false;
  var isSelected = false;
  var isSelected1 = false;
  var isSelected2 = false;

  Widget header(String title, bool switchValue) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 0, 10),
      alignment: Alignment.topLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          StatefulBuilder(
            builder: (context, setLocalState) {
              return Flexible(
                child: Switch(
                  inactiveTrackColor: Colors.grey,
                  inactiveThumbColor: Colors.white,
                  activeColor: const Color(0xFF0099CC),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: switchValue,
                  onChanged: (value) {
                    setLocalState(() {
                      switchValue = !switchValue;
                    });
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget myHolding(String title, String subtitle) {
    return Container(
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget notificationType() {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.fromLTRB(0, 40, 20, 0),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: const Text(
              "NOTIFICATION TYPE",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),
          ),
          CheckboxListTile(
            title: const Text(
              "Push Notifications",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            side: MaterialStateBorderSide.resolveWith(
              (states) => const BorderSide(width: 2.0, color: Colors.white54),
            ),
            activeColor: const Color(0xFF0099CC),
            // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            value: isSelected,
            onChanged: (value) {
              setState(() {
                isSelected = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text(
              "Email",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            side: MaterialStateBorderSide.resolveWith(
              (states) => const BorderSide(width: 2.0, color: Colors.white54),
            ),
            activeColor: const Color(0xFF0099CC),
            // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            value: isSelected1,
            onChanged: (value) {
              setState(() {
                isSelected1 = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text(
              "Push Notifications & Email",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            side: MaterialStateBorderSide.resolveWith(
              (states) => const BorderSide(width: 2.0, color: Colors.white54),
            ),
            activeColor: const Color(0xFF0099CC),
            // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            value: isSelected2,
            onChanged: (value) {
              setState(() {
                isSelected2 = value!;
              });
            },
          )
        ],
      ),
    );
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
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                    child: const Text(
                      "Push Notifications",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  header(
                      "Do you want a notification before a trade gets placed",
                      switchOnOff),
                  header("Bank Activity", switchOnOff),
                  header("Margin Maintenance Alerts", switchOnOff1),
                  header("Spend Alerts", switchOnOff2),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                    child: Row(
                      children: [
                        Text(
                          "My Holdings",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.info,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                  myHolding("Stock Price Movements", "Enabled"),
                  myHolding("Options Price Movements", "Enabled"),
                  myHolding("Crypto Price Movements", "Enabled"),
                  header("Shareholder Updates", switchOnOff3),
                  header("Order Status", switchOnOff3),
                  header("Option Expiration Reminder", switchOnOff3),
                  // notificationType(),
                  // Preview()
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
