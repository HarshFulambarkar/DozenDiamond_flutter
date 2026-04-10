import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:flutter/material.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../models/multiple_ladder_support_request.dart';
import '../services/settings_rest_api_service.dart';

class MultipleLadderCreation extends StatefulWidget {
  const MultipleLadderCreation({super.key});

  @override
  State<MultipleLadderCreation> createState() => _MultipleLadderCreationState();
}

class _MultipleLadderCreationState extends State<MultipleLadderCreation> {
  var switchOnOff = false;
  @override
  void initState() {
    super.initState();
    getUserLadderSupportSettings();
  }

  Future<void> getUserLadderSupportSettings() async {
    try {
      await SettingRestApiService().getMultipleLadderSupport().then((res) {
        if (res?.status == true) {
          setState(() {
            switchOnOff = res?.data?.regMultipleLadderSupport ?? false;
          });
        }
      });
    } on HttpApiException catch (err) {
      print(err.errorTitle);
    }
  }

  Future<void> userLadderSetting() async {
    try {
      await SettingRestApiService()
          .multipleLadderSupport(MultipleLadderSupportRequest(
        regMultipleLadderSupport: switchOnOff,
      ))
          .then((res) {
        if (res?.status == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                res?.msg ?? "",
              ),
            ),
          );
        }
      });
    } on HttpApiException catch (err) {
      print(err.errorTitle);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget header(String title) {
      return Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 0, 10),
        alignment: Alignment.topLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
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
                return Switch(
                  inactiveTrackColor: Colors.grey,
                  inactiveThumbColor: Colors.white,
                  activeColor: const Color(0xFF0099CC),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: switchOnOff,
                  onChanged: (value) async {
                    setLocalState(() {
                      switchOnOff = value;
                    });
                    await userLadderSetting();
                  },
                );
              },
            )
          ],
        ),
      );
    }

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
                    margin: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                    child: const Text(
                      "Ladder Creation",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 0,
                  ),
                  header(
                    "Enable Multiple Ladder Creation",
                  ),
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
