import 'package:dozen_diamond/DD_Navigation/widgets/nav_drawer_new.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/stateManagement/custom_home_app_bar_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../global/constants/currency_constants.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/services/num_formatting.dart';
import '../../global/widgets/custom_container.dart';
import '../../socket_manager/stateManagement/web_socket_service_provider.dart';
import '../stateManagement/strategies_provider.dart';

class StrategiesScreen extends StatefulWidget {
  final Function updateIndex;
  final bool isAuthenticationPresent;
  const StrategiesScreen({
    super.key,
    this.isAuthenticationPresent = false,
    required this.updateIndex,
  });

  @override
  State<StrategiesScreen> createState() => _StrategiesScreenState();
}

class _StrategiesScreenState extends State<StrategiesScreen> {
  late CustomHomeAppBarProvider customHomeAppBarProvider;
  late WebSocketServiceProvider webSocketServiceProvider;
  late ThemeProvider themeProvider;
  late StrategiesProvider strategiesProvider;

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
    strategiesProvider = Provider.of<StrategiesProvider>(context, listen: true);

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

                            buildHeading(context),

                            SizedBox(height: 10),

                            buildStrategyList(context),
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

  Widget buildHeading(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 15),

        Text(
          "Strategies",
          style: TextStyle(
            fontSize: 25,
            color: (themeProvider.defaultTheme)
                ? Colors.black
                : Color(0xFFffffff),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget buildStrategyList(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: strategiesProvider.strategyList
          .map(
            (strategy) => Column(
          children: [
            Container(
              margin: EdgeInsets.zero,
              color: Colors.transparent,
              child: ListTile(
                dense: true,
                trailing: Icon(
                  (strategy == 'Stressless trading method (STM)')
                      ? Icons.check
                      : Icons.lock,
                  size: 18,
                  color: themeProvider.defaultTheme
                      ? Colors.black
                      : Colors.white,
                ),
                title: Text(
                  strategy,
                  style: TextStyle(
                    color: (strategy == 'Stressless trading method (STM)')
                        ? (themeProvider.defaultTheme)
                        ? Colors.black
                        : Colors.white
                        : Colors.grey,

                    fontSize: 16,
                  ),
                ),
                onTap: () async {
                  switch (strategy) {
                    case "Stressless trading method (STM)":
                      {
                        break;
                      }

                    default:
                      {
                        Fluttertoast.showToast(
                          msg: 'This feature will unlock soon!',
                        );
                      }
                  }
                },
              ),
            ),
            Divider(),
            const SizedBox(height: 0),
          ],
        ),
      )
          .toList(),
    );
  }
}