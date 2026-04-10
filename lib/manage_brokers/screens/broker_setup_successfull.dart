import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DD_Navigation/widgets/nav_drawer.dart';
import '../../DD_Navigation/widgets/nav_drawer_new.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/stateManagement/user_config_provider.dart';
import '../stateManagement/manage_brokers_provider.dart';

class BrokerSetupSuccessfull extends StatefulWidget {
  @override
  State<BrokerSetupSuccessfull> createState() => _BrokerSetupSuccessfullState();
}

class _BrokerSetupSuccessfullState extends State<BrokerSetupSuccessfull> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  late ManageBrokersProvider manageBrokersProvider;
  late UserConfigProvider userConfigProvider;

  @override
  void initState() {
    super.initState();

    userConfigProvider = Provider.of<UserConfigProvider>(context, listen: false);
    userConfigProvider.getUserConfigData();
  }

  void _triggerDrawer() {
    _key.currentState!.openDrawer();
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = screenWidthRecognizer(context);
    manageBrokersProvider = Provider.of<ManageBrokersProvider>(context, listen: true);

    return Scaffold(
      key: _key,
      drawer: const NavDrawerNew(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [

              Center(
                child: Container(
                  width: screenWidth == 0 ? null : screenWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Container(
                        height: MediaQuery.of(context).size.height,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Broker Setup Successfully",
                              style:
                              TextStyle(
                                  fontSize: 25,
                                  color: Color(0xFFffffff),
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        ),
                      ),


                    ],
                  ),
                ),
              ),


              CustomHomeAppBarWithProviderNew(
                backButton: false,
                leadingAction: _triggerDrawer,
                  widthOfWidget: screenWidth
              ),
            ],
          ),
        ),
      ),
    );
  }
}
