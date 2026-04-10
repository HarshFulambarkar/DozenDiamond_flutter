import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../AB_Ladder/stateManagement/ladder_provider.dart';
import '../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../DD_Navigation/widgets/nav_drawer.dart';
import '../../DD_Navigation/widgets/nav_drawer_new.dart';
import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../create_ladder_detailed/stateManagement/create_ladder_provider.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/widgets/custom_container.dart';

class LadderIntroScreen1 extends StatefulWidget {
  final Function updateIndex;
  final bool refreshProviderState;

  const LadderIntroScreen1(
      {super.key,
        required this.updateIndex,
        required this.refreshProviderState});

  @override
  State<LadderIntroScreen1> createState() => _LadderIntroScreen1State();
}

class _LadderIntroScreen1State extends State<LadderIntroScreen1> {
  late ThemeProvider themeProvider;
  late NavigationProvider navigationProvider;
  late CreateLadderProvider createLadderProvider;

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  void _triggerDrawer() {
    _key.currentState!.openDrawer();
  }

  List<Map<String, dynamic>> whyUserLaddersList = [
    {
      "title": "Better price control",
      "message": "Buy low, sell high without constant monitoring."
    },

    {
      "title": "Automated Execution",
      "message": "Set it up once, and let the market come to you."
    },

    {
      "title": "Risk Management",
      "message": "Spread your orders to minimize impact and maximize returns."
    },

    {
      "title": "Save Time",
      "message": "No need to watch the charts all day--your strategy runs in the background."
    },
  ];

  @override
  Widget build(BuildContext context) {

    double screenWidth = screenWidthRecognizer(context);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    navigationProvider = Provider.of<NavigationProvider>(context, listen: true);
    createLadderProvider = Provider.of<CreateLadderProvider>(context, listen: true);

    return SafeArea(
      child: Center(
        child: Container(
          color: (themeProvider.defaultTheme)
              ? Color(0XFFF5F5F5)
              : Colors.transparent,
          width: screenWidth,
          child: Scaffold(
            drawer: NavDrawerNew(updateIndex: widget.updateIndex),
            key: _key,
            // backgroundColor: Colors.red,
            backgroundColor: (themeProvider.defaultTheme)
                ? Color(0XFFF5F5F5)
                : Color(0xFF15181F),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 45,
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      buildTopSection(context, screenWidth),

                      SizedBox(
                        height: 8,
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16.0),
                        child: Divider(
                          color: Color(0xff2c2c31),
                          thickness: 1,
                        ),
                      ),

                      SizedBox(
                        height: 8,
                      ),

                      buildWhatAreLaddersSection(context, screenWidth),

                      SizedBox(
                        height: 15,
                      ),

                      buildWhyUseLaddersSection(context, screenWidth),

                      SizedBox(
                        height: 20,
                      ),

                      buildButtonSection(context, screenWidth)


                    ],
                  ),
                ),
          
                CustomHomeAppBarWithProviderNew(
                    backButton: false, leadingAction: _triggerDrawer),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTopSection(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ladders",
                style: TextStyle(
                  fontFamily: 'Britanica',
                  fontWeight: FontWeight.w400,
                  fontSize: 26,
                  color: Color(0xfff0f0f0)
                ),
              ),

              Text(
                "Trade smart with this strategy",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  color: Color(0xfff0f0f0).withOpacity(0.6)
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildWhatAreLaddersSection(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              // Icon(
              //   CupertinoIcons.book,
              //   color: Color(0xfff0f0f0),
              //   size: 18,
              // ),
              //
              // SizedBox(
              //   width: 3,
              // ),

              Text(
                "📖 What Are Ladders?",
                style: TextStyle(
                  fontFamily: 'Britanica',
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: Color(0xfff0f0f0)
                ),
              ),
            ],
          ),

          SizedBox(
            height: 8,
          ),

          Text(
            "Ladders let you automate your trades by placing multiple buy or sell orders at different price levels. Instead of guessing the perfect entry or exit, it helps you take advantage of market movements--automatically!",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w300,
              fontSize: 14,
              color: Color(0xffa2b0bc),
            ),
          )
        ],
      ),
    );
  }

  Widget buildWhyUseLaddersSection(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            "Why Use Ladders?",
            style: TextStyle(
                fontFamily: 'Britanica',
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: Color(0xfff0f0f0)
            ),
          ),

          SizedBox(
            height: 8,
          ),

        ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: whyUserLaddersList.length, //3, //watchlistProvider.searchedStockList.length,
          itemBuilder: (context, index) {

            return buildWhyUserLaddersCard(context, screenWidth, whyUserLaddersList[index]['title'], whyUserLaddersList[index]['message']);
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 10,
            );
          },
        ),



        ],
      ),
    );
  }

  Widget buildWhyUserLaddersCard(BuildContext context, double screenWidth, String title, String message) {
    return CustomContainer(
      margin: EdgeInsets.zero,
      padding: 0,
      paddingEdge: EdgeInsets.zero,
      backgroundColor: Color(0xff2c2c31),
      borderRadius: 10,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "✦ ${title}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xfff0f0f0),
                  ),
                )
              ],
            ),

            SizedBox(
              height: 3,
            ),

            Text(
              message,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: Color(0xffa2b0bc)
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildButtonSection(BuildContext context, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          CustomContainer(
            padding: 0,
            paddingEdge: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            borderRadius: 12,
            backgroundColor: Colors.transparent,
            onTap: () {

              createLadderProvider.showLadderIntroToolTip = false;
              navigationProvider.selectedIndex = 3;

            },
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8.0),
              child: Text(
                  "Skip",
                  style: GoogleFonts.poppins(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xffa2b0bc),
                  )
              ),
            ),
          ),

          SizedBox(
            width: 8,
          ),

          CustomContainer(
            padding: 0,
            paddingEdge: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            borderRadius: 12,
            backgroundColor: Color(0xfff0f0f0),
            onTap: () {
              createLadderProvider.showLadderIntroToolTip = true;
              navigationProvider.selectedIndex = 3;
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8.0),
              child: Text(
                  "Get Started",
                  style: GoogleFonts.poppins(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff000000),
                  )
              ),
            ),
          )
        ],
      ),
    );
  }
}
