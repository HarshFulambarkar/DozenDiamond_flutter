import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZI_Search/stateManagement/search_provider.dart';
import '../../global/constants/shared_preferences_manager.dart';
import '../../global/widgets/custom_container.dart';
import '../stateManagement/navigation_provider.dart';

class BottomNavBarNew extends StatefulWidget {
  const BottomNavBarNew({super.key});

  @override
  State<BottomNavBarNew> createState() => _BottomNavBarNewState();
}

class _BottomNavBarNewState extends State<BottomNavBarNew> {

  late NavigationProvider navigationProvider;
  late SearchProvider searchProvider;
  late ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {

    navigationProvider = Provider.of<NavigationProvider>(context, listen: true);
    searchProvider = Provider.of<SearchProvider>(context, listen: true);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    double screenWidth = screenWidthRecognizer(context);
    return Container(
      width: screenWidth,
      height: 75,
      color: (navigationProvider.selectedIndex == 3 ||
          navigationProvider.selectedIndex == 4 ||
          navigationProvider.selectedIndex == 5 ||
          navigationProvider.selectedIndex == 6 ||
          navigationProvider.selectedIndex == 7 ||
          navigationProvider.selectedIndex == 8 ||
          navigationProvider.selectedIndex == 9)
          ?(themeProvider.defaultTheme)?Color(0xfff5f5f5):Color(0xff454545)
          :(themeProvider.defaultTheme)?Color(0xfff0f0f0):Colors.transparent,
      child: Stack(
        children: [

          Positioned(
            bottom: 0,
            child: Container(
              height: 65, //57,
              width: screenWidth,
              color: (themeProvider.defaultTheme)?Colors.white:Color(0xff2c2c31),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomContainer(
                onTap: () {
                  navigationProvider.selectedIndex = 0;
                },
                height: 75,
                width: 71,
                backgroundColor: (navigationProvider.selectedIndex == 0)
                    ?(themeProvider.defaultTheme)?Colors.white:Color(0xff2c2c31)
                    :Colors.transparent,
                padding: 0,
                borderRadius: 100,
                paddingEdge: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Image.asset(
                      "lib/DD_Navigation/assets/home_icon_image.png",
                      height: 24,
                      width: 24,
                      color: (navigationProvider.selectedIndex == 0)
                          ?Color(0xff1a94f2):(themeProvider.defaultTheme)?Color(0xff2c2c31):Colors.white,
                    ),

                    SizedBox(
                      height: 2,
                    ),

                    Text(
                      "Home",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: (navigationProvider.selectedIndex == 0)
                            ?Color(0xff1a94f2):(themeProvider.defaultTheme)?Color(0xff2c2c31):Colors.white,
                      ),
                    )
                  ],
                ),
              ),

              CustomContainer(
                onTap: () async {

                  // final value = (await SharedPreferenceManager.getIsLadderIntroDone()) ?? false;
                  final value = true; //(await SharedPreferenceManager.getIsLadderIntroDone()) ?? false;

                  if(value) {

                    navigationProvider.selectedIndex = 3;

                  } else {
                    SharedPreferenceManager.saveIsLadderIntroDone(true);
                    final value = (await SharedPreferenceManager.getIsFirstTimeOnLadderPage()) ?? true;
                    // final value = false; //(await SharedPreferenceManager.getIsFirstTimeOnLadderPage()) ?? true;

                    if(value == false) {
                      searchProvider.showStockListSection = true;
                    } else {
                      searchProvider.showStockListSection = false;
                    }
                    navigationProvider.selectedIndex = 22;
                  }
                  // navigationProvider.selectedIndex = 3;
                  // navigationProvider.selectedIndex = 22;
                },
                height: 75,
                width: 71,
                backgroundColor: (navigationProvider.selectedIndex == 3 || navigationProvider.selectedIndex == 22 || navigationProvider.selectedIndex == 4)
                    ?(themeProvider.defaultTheme)?Colors.white:Color(0xff2c2c31)
                    :Colors.transparent,
                padding: 0,
                borderRadius: 100,
                paddingEdge: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Image.asset(
                      "lib/DD_Navigation/assets/ladder_icon_image.png",
                      height: 24,
                      width: 24,
                      color: (navigationProvider.selectedIndex == 3 || navigationProvider.selectedIndex == 22 || navigationProvider.selectedIndex == 4)
                          ?Color(0xff1a94f2):(themeProvider.defaultTheme)?Color(0xff2c2c31):Colors.white,
                    ),

                    SizedBox(
                      height: 2,
                    ),

                    Text(
                      "Ladder",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: (navigationProvider.selectedIndex == 3 || navigationProvider.selectedIndex == 22 || navigationProvider.selectedIndex == 4)
                            ?Color(0xff1a94f2):(themeProvider.defaultTheme)?Color(0xff2c2c31):Colors.white,
                      ),
                    )
                  ],
                ),
              ),

              CustomContainer(
                onTap: () {
                  navigationProvider.selectedIndex = 18;
                },
                height: 75,
                width: 71,
                backgroundColor: (navigationProvider.selectedIndex == 18)
                    ?(themeProvider.defaultTheme)?Colors.white:Color(0xff2c2c31)
                    :Colors.transparent,
                padding: 0,
                borderRadius: 100,
                paddingEdge: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Image.asset(
                      "lib/DD_Navigation/assets/watchlist_icon_image.png",
                      height: 24,
                      width: 24,
                      color: (navigationProvider.selectedIndex == 18)
                          ?Color(0xff1a94f2):(themeProvider.defaultTheme)?Color(0xff2c2c31):Colors.white,
                    ),

                    SizedBox(
                      height: 2,
                    ),

                    Text(
                      "Watchlist",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: (navigationProvider.selectedIndex == 18)
                            ?Color(0xff1a94f2):(themeProvider.defaultTheme)?Color(0xff2c2c31):Colors.white,
                      ),
                    )
                  ],
                ),
              ),

              CustomContainer(
                onTap: () {
                  navigationProvider.selectedIndex = 1;
                },
                height: 75,
                width: 71,
                backgroundColor: (navigationProvider.selectedIndex == 1)
                    ?(themeProvider.defaultTheme)?Colors.white:Color(0xff2c2c31)
                    :Colors.transparent,
                padding: 0,
                borderRadius: 100,
                paddingEdge: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Image.asset(
                      "lib/DD_Navigation/assets/trade_icon_image.png",
                      height: 24,
                      width: 24,
                      color: (navigationProvider.selectedIndex == 1)
                          ?Color(0xff1a94f2):(themeProvider.defaultTheme)?Color(0xff2c2c31):Colors.white,
                    ),

                    SizedBox(
                      height: 2,
                    ),

                    Text(
                      "Trade",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: (navigationProvider.selectedIndex == 1)
                            ?Color(0xff1a94f2):(themeProvider.defaultTheme)?Color(0xff2c2c31):Colors.white,
                      ),
                    )
                  ],
                ),
              ),

              CustomContainer(
                onTap: () {
                  navigationProvider.selectedIndex = 2;
                },
                height: 75,
                width: 71,
                backgroundColor: (navigationProvider.selectedIndex == 2)
                    ?(themeProvider.defaultTheme)?Colors.white:Color(0xff2c2c31)
                    :Colors.transparent,
                padding: 0,
                borderRadius: 100,
                paddingEdge: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Image.asset(
                      "lib/DD_Navigation/assets/analytics_icon_image.png",
                      height: 24,
                      width: 24,
                      color: (navigationProvider.selectedIndex == 2)
                          ?Color(0xff1a94f2):(themeProvider.defaultTheme)?Color(0xff2c2c31):Colors.white,
                    ),

                    SizedBox(
                      height: 2,
                    ),

                    Text(
                      "Analytics",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: (navigationProvider.selectedIndex == 2)
                            ?Color(0xff1a94f2):(themeProvider.defaultTheme)?Color(0xff2c2c31):Colors.white,
                      ),
                    )
                  ],
                ),
              ),


            ],
          )

        ],
      ),
    );
  }
}
