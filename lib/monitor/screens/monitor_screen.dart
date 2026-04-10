import 'package:dozen_diamond/DD_Navigation/widgets/nav_drawer_new.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DD_Navigation/widgets/nav_drawer.dart';
import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/stateManagement/custom_home_app_bar_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../global/constants/currency_constants.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/services/num_formatting.dart';
import '../../global/widgets/custom_container.dart';
import '../../socket_manager/stateManagement/web_socket_service_provider.dart';

class MonitorScreen extends StatefulWidget {
  final Function updateIndex;
  final bool isAuthenticationPresent;
  const MonitorScreen({
    super.key,
    this.isAuthenticationPresent = false,
    required this.updateIndex,
  });

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  late CustomHomeAppBarProvider customHomeAppBarProvider;
  late WebSocketServiceProvider webSocketServiceProvider;
  late ThemeProvider themeProvider;

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  void _triggerDrawer() {
    _key.currentState!.openDrawer();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    CurrencyConstants currencyConstantsProvider = Provider.of(context);
    customHomeAppBarProvider = Provider.of<CustomHomeAppBarProvider>(
      context,
      listen: true,
    );
    customHomeAppBarProvider.getFieldVisibilityOfAccountInfoBar();
    webSocketServiceProvider = Provider.of<WebSocketServiceProvider>(
      context,
      listen: true,
    );
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Center(
      child: Container(
        width: screenWidth,
        child: Scaffold(
          key: _key,
          resizeToAvoidBottomInset: false,
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
          drawer: NavDrawerNew(updateIndex: widget.updateIndex),
          body: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: Container(
                    color: (themeProvider.defaultTheme)
                        ? Color(0XFFF5F5F5)
                        : Colors.transparent,
                    height: MediaQuery.of(context).size.height,
                    width: screenWidth,
                  ),
                ),
                Padding(
                  // padding: const EdgeInsets.only(top: 60.0),
                  padding: const EdgeInsets.only(top: 45.0),
                  child: SingleChildScrollView(
                    child: Center(
                      child: Container(
                        color: (themeProvider.defaultTheme)
                            ? Color(0XFFF5F5F5)
                            : Colors.transparent,
                        width: screenWidth,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Center(child: Text("Monitor Screen")),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                CustomHomeAppBarWithProviderNew(
                  backButton: false,
                  leadingAction: _triggerDrawer,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}