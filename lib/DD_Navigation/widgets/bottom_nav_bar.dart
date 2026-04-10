import 'package:dozen_diamond/DD_Navigation/stateManagement/navigation_provider.dart';
import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../Settings/stateManagement/theme_provider.dart';
import '../../global/constants/constants.dart';
import '../../global/stateManagement/app_config_provider.dart';

class BottomNavigationbar extends StatefulWidget {
  final int? bottomNavigatonIndex;
  final bool enableBackButton;
  final bool enableMenuButton;
  final int goToIndex;
  final Function? updateIndex;
  final bool initiallyExpanded;
  final String selectedTicker;

  const BottomNavigationbar({
    super.key,
    this.bottomNavigatonIndex,
    this.enableBackButton = false,
    this.enableMenuButton = true,
    this.goToIndex = 0,
    this.updateIndex,
    this.initiallyExpanded = true,
    this.selectedTicker = "Select ticker",
  });

  @override
  State<BottomNavigationbar> createState() => _BottomNavigationbarState();
}

class _BottomNavigationbarState extends State<BottomNavigationbar> {
  late NavigationProvider navigationProvider;
  late ThemeProvider themeProvider;
  late AppConfigProvider appConfigProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    navigationProvider = Provider.of<NavigationProvider>(context, listen: true);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    appConfigProvider = Provider.of<AppConfigProvider>(context, listen: true);
    double screenWidth = screenWidthRecognizer(context);

    bool showAddFunds =
        appConfigProvider.appConfigData.data?.addFundsEnableBottomNavBar ??
            true;
    bool showCreateLadder =
        appConfigProvider.appConfigData.data?.createLadderEnableBottomNavBar ??
            true;
    bool showWatchlist =
        appConfigProvider.appConfigData.data?.watchlistEnableBottomNavBar ??
            true;
    bool showTrade =
        appConfigProvider.appConfigData.data?.tradeEnableBottomNavBar ?? true;
    bool showAnalytics =
        appConfigProvider.appConfigData.data?.analyticsEnableBottomNavBar ??
            true;

    final tabs = [
      if (showAddFunds)
        {
          'icon': Icon(Icons.account_balance_wallet_outlined),
          'label': 'Add Funds',
          'mappedIndex': 0,
        },
      if (showCreateLadder)
        {
          'icon': Image.asset("lib/global/assets/logos/ladder.png",
              width: 25,
              color: navigationProvider.selectedIndex == 3
                  ? Color(0xFF0099CC)
                  : (themeProvider.defaultTheme)
                      ? Colors.black
                      : Colors.white60),
          'label': 'Create ladder',
          'mappedIndex': 3,
        },
      if (showWatchlist)
        {
          'icon': Icon(Icons.list_alt),
          'label': 'Watchlist',
          'mappedIndex': 18,
        },
      if (showTrade)
        {
          'icon': Image.asset("lib/global/assets/icons/suitcase.png",
              width: 25,
              color: navigationProvider.selectedIndex == 1
                  ? Color(0xFF0099CC)
                  : (themeProvider.defaultTheme)
                      ? Colors.black
                      : Colors.white60),
          'label': 'Trade',
          'mappedIndex': 1,
        },
      if (showAnalytics)
        {
          'icon': Image.asset("lib/global/assets/icons/data-analytics-icon.png",
              width: 25,
              color: navigationProvider.selectedIndex == 2
                  ? Color(0xFF0099CC)
                  : (themeProvider.defaultTheme)
                      ? Colors.black
                      : Colors.white60),
          'label': 'Analytics',
          'mappedIndex': 2,
        },
    ];

    int currentIndex = tabs.indexWhere(
      (tab) => tab['mappedIndex'] == navigationProvider.selectedIndex,
    );

    if (currentIndex == -1) {
      currentIndex = 0;
      // navigationProvider.selectedIndex = tabs[0]['mappedIndex'] as int;
    }

    return Align(
      alignment: Alignment
          .bottomCenter, // Ensure the alignment is at the bottom center
      child: Container(
        width: screenWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: const Alignment(0, -0.1),
            colors: [
              kBackgroundColor.withOpacity(0),
              kBackgroundColor,
            ],
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          unselectedItemColor:
              (themeProvider.defaultTheme) ? Colors.black : Colors.white60,
          selectedItemColor:
              Color(0xFF0099CC), //Color.fromARGB(255, 136, 174, 186),

          items: tabs
              .map((tab) => BottomNavigationBarItem(
                    icon: tab['icon'] as Widget,
                    label: tab['label'] as String,
                  ))
              .toList(),
          // currentIndex: tabs.indexWhere(
          //     (tab) => tab['mappedIndex'] == navigationProvider.selectedIndex,
          // ),
          currentIndex: (currentIndex >= tabs.length) ? 0 : currentIndex,
          onTap: (index) {
            final mappedIndex = tabs[index]['mappedIndex'] as int;
            navigationProvider.onItemTapped(mappedIndex);
          },

          // old code starts from here

          // items: [
          //   BottomNavigationBarItem(
          //     icon: Icon(Icons.account_balance_wallet_outlined),
          //     label: 'Add Funds',
          //
          //   ),
          //
          //   BottomNavigationBarItem(
          //     icon: Image.asset("lib/global/assets/logos/ladder.png",
          //         width: 25,
          //         color: navigationProvider.selectedIndex == 3
          //             ? Color(0xFF0099CC)
          //             : (themeProvider.defaultTheme)
          //             ?Colors.black:Colors.white60),
          //     label: 'Create ladder',
          //   ),
          //
          //   BottomNavigationBarItem(
          //     icon: Icon(Icons.list_alt),
          //     label: 'Watchlist',
          //
          //   ),
          //
          //   BottomNavigationBarItem(
          //     icon: Image.asset("lib/global/assets/icons/suitcase.png",
          //         width: 25,
          //         color: navigationProvider.selectedIndex == 1
          //             ? Color(0xFF0099CC)
          //             : (themeProvider.defaultTheme)
          //             ?Colors.black:Colors.white60),
          //     label: 'Trade',
          //   ),
          //   BottomNavigationBarItem(
          //     icon: Image.asset(
          //         "lib/global/assets/icons/data-analytics-icon.png",
          //         width: 25,
          //         color: navigationProvider.selectedIndex == 2
          //             ? Color(0xFF0099CC)
          //             : (themeProvider.defaultTheme)
          //             ?Colors.black:Colors.white60),
          //     label: 'Analytics',
          //   ),
          // ],
          // currentIndex: (navigationProvider.selectedIndex == 0)
          //       ?0
          //       :(navigationProvider.selectedIndex == 3)
          //       ?1
          //       :(navigationProvider.selectedIndex == 1)
          //       ?3
          //       :(navigationProvider.selectedIndex == 2)
          //       ?4
          //       :(navigationProvider.selectedIndex == 18)
          //       ?2
          //       :1,
          // onTap: (index) {
          //   // Map the visual index to the actual desired index
          //   int mappedIndex;
          //   switch (index) {
          //     case 0:
          //       mappedIndex = 0; // 'Add Funds'
          //       break;
          //     case 1:
          //       mappedIndex = 3; // 'Create Ladder' mapped to index 3
          //       break;
          //     case 2:
          //       mappedIndex = 18; // 'watchlist' mapped to index 1
          //       break;
          //     case 3:
          //       mappedIndex = 1; // 'Trade' mapped to index 2
          //       break;
          //     case 4:
          //       mappedIndex = 2; // 'Analytics' mapped to index 2
          //       break;
          //     default:
          //       mappedIndex = 0;
          //   }
          //
          //   // Use the mapped index
          //   navigationProvider.onItemTapped(mappedIndex);
          // },

          // old code ends here
        ),
      ),
    );
  }
}
