import 'package:dozen_diamond/DD_Navigation/widgets/nav_drawer_new.dart';
import 'package:dozen_diamond/Settings/stateManagement/theme_provider.dart';
import 'package:dozen_diamond/ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/widgets/custom_container.dart';

class RankListScreen extends StatefulWidget {
  final Function updateIndex;
  final bool isAuthenticationPresent;
  const RankListScreen({
    super.key,
    this.isAuthenticationPresent = false,
    required this.updateIndex,
  });

  @override
  State<RankListScreen> createState() => _RankListScreenState();
}

class _RankListScreenState extends State<RankListScreen> {

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  late ThemeProvider themeProvider;
  late CurrencyConstants currencyConstants;

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

    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    currencyConstants = Provider.of<CurrencyConstants>(context, listen: true);

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

                            Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8.0),
                              child: Text(
                                "Ranklist",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'Britanica',
                                  color: (themeProvider.defaultTheme)?Color(0xff141414):Color(0xFFffffff),
                                  fontWeight: FontWeight.w400),
                              ),
                            ),

                            SizedBox(height: 10),

                            buildCategorySection(context, screenWidth)
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

  Widget buildCategorySection(BuildContext context, double screenWidth) {
    return ListView(
      shrinkWrap: true,
      children: [
        Column(
          children: [
            CustomContainer(
              borderRadius: 0,
              backgroundColor: (themeProvider.defaultTheme)
                  ? Color(0xffdadde6)
                  : Color(0xff1b1b1b), // Color(0xff1b1b1b),
              padding: 0,
              margin: EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Industrials",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 22, //16,
                        color: (themeProvider.defaultTheme)
                            ? Color(0xff0f0f0f)
                            : Color(0xfff0f0f0),
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {

                    },
                    icon:
                    true
                        ? Icon(
                      Icons.keyboard_arrow_up,
                      color: (themeProvider.defaultTheme)
                          ? Colors.black
                          : Colors.white,
                    )
                        : Icon(
                      Icons.keyboard_arrow_down,
                      color: (themeProvider.defaultTheme)
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            buildStockCard(context, screenWidth),

            buildStockCard(context, screenWidth),
          ],
        ),

        SizedBox(
          height: 10,
        ),

        Column(
          children: [
            CustomContainer(
              borderRadius: 0,
              backgroundColor: (themeProvider.defaultTheme)
                  ? Color(0xffdadde6)
                  : Color(0xff1b1b1b), // Color(0xff1b1b1b),
              padding: 0,
              margin: EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Energy",
                      style: GoogleFonts.poppins(
                        // fontWeight: FontWeight.w400,
                        fontWeight: FontWeight.w500,
                        fontSize: 22, //16,
                        color: (themeProvider.defaultTheme)
                            ? Color(0xff0f0f0f)
                            : Color(0xfff0f0f0),
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {

                    },
                    icon:
                    true
                        ? Icon(
                      Icons.keyboard_arrow_up,
                      color: (themeProvider.defaultTheme)
                          ? Colors.black
                          : Colors.white,
                    )
                        : Icon(
                      Icons.keyboard_arrow_down,
                      color: (themeProvider.defaultTheme)
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            buildStockCard(context, screenWidth),
          ],
        ),

        SizedBox(
          height: 10,
        ),

        Column(
          children: [
            CustomContainer(
              borderRadius: 0,
              backgroundColor: (themeProvider.defaultTheme)
                  ? Color(0xffdadde6)
                  : Color(0xff1b1b1b), // Color(0xff1b1b1b),
              padding: 0,
              margin: EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Consumer Discretionary",
                      style: GoogleFonts.poppins(
                        // fontWeight: FontWeight.w400,
                        fontWeight: FontWeight.w500,
                        fontSize: 22, //16,
                        color: (themeProvider.defaultTheme)
                            ? Color(0xff0f0f0f)
                            : Color(0xfff0f0f0),
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {

                    },
                    icon:
                    true
                        ? Icon(
                      Icons.keyboard_arrow_up,
                      color: (themeProvider.defaultTheme)
                          ? Colors.black
                          : Colors.white,
                    )
                        : Icon(
                      Icons.keyboard_arrow_down,
                      color: (themeProvider.defaultTheme)
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            buildStockCard(context, screenWidth),

            buildStockCard(context, screenWidth),

            buildStockCard(context, screenWidth),

            buildStockCard(context, screenWidth),
          ],
        ),

        SizedBox(
          height: 10,
        ),

        CustomContainer(
          borderRadius: 0,
          backgroundColor: (themeProvider.defaultTheme)
              ? Color(0xffdadde6)
              : Color(0xff1b1b1b), // Color(0xff1b1b1b),
          padding: 0,
          margin: EdgeInsets.zero,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Healthcare",
                  style: GoogleFonts.poppins(
                    // fontWeight: FontWeight.w400,
                    fontWeight: FontWeight.w500,
                    fontSize: 22, //16,
                    color: (themeProvider.defaultTheme)
                        ? Color(0xff0f0f0f)
                        : Color(0xfff0f0f0),
                  ),
                ),
              ),

              IconButton(
                onPressed: () {

                },
                icon:
                true
                    ? Icon(
                  Icons.keyboard_arrow_up,
                  color: (themeProvider.defaultTheme)
                      ? Colors.black
                      : Colors.white,
                )
                    : Icon(
                  Icons.keyboard_arrow_down,
                  color: (themeProvider.defaultTheme)
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 10,
        ),

        CustomContainer(
          borderRadius: 0,
          backgroundColor: (themeProvider.defaultTheme)
              ? Color(0xffdadde6)
              : Color(0xff1b1b1b), // Color(0xff1b1b1b),
          padding: 0,
          margin: EdgeInsets.zero,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Financial Service",
                  style: GoogleFonts.poppins(
                    // fontWeight: FontWeight.w400,
                    fontWeight: FontWeight.w500,
                    fontSize: 22, //16,
                    color: (themeProvider.defaultTheme)
                        ? Color(0xff0f0f0f)
                        : Color(0xfff0f0f0),
                  ),
                ),
              ),

              IconButton(
                onPressed: () {

                },
                icon:
                true
                    ? Icon(
                  Icons.keyboard_arrow_up,
                  color: (themeProvider.defaultTheme)
                      ? Colors.black
                      : Colors.white,
                )
                    : Icon(
                  Icons.keyboard_arrow_down,
                  color: (themeProvider.defaultTheme)
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 5,
        ),

        CustomContainer(
          borderRadius: 0,
          backgroundColor: (themeProvider.defaultTheme)
              ? Color(0xffdadde6)
              : Color(0xff1b1b1b), // Color(0xff1b1b1b),
          padding: 0,
          margin: EdgeInsets.zero,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Commodities",
                  style: GoogleFonts.poppins(
                    // fontWeight: FontWeight.w400,
                    fontWeight: FontWeight.w500,
                    fontSize: 22, //16,
                    color: (themeProvider.defaultTheme)
                        ? Color(0xff0f0f0f)
                        : Color(0xfff0f0f0),
                  ),
                ),
              ),

              IconButton(
                onPressed: () {

                },
                icon:
                true
                    ? Icon(
                  Icons.keyboard_arrow_up,
                  color: (themeProvider.defaultTheme)
                      ? Colors.black
                      : Colors.white,
                )
                    : Icon(
                  Icons.keyboard_arrow_down,
                  color: (themeProvider.defaultTheme)
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ],
          ),
        ),


      ],
    );
  }

  Widget buildStockCard(BuildContext context, double screenWidth) {
    return CustomContainer(
      backgroundColor: (themeProvider.defaultTheme)
          ? Colors.white
          : Color(0xff2c2c31).withOpacity(0.39),
      borderRadius: 0,
      padding: 0,
      margin: EdgeInsets.zero,
      paddingEdge: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 9,
          bottom: 9.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "NTPC",
                        // webSocketServiceProvider
                        //     .ddWatchlistStockList[index]
                        //     .tickerName ??
                        //     "",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: (themeProvider.defaultTheme)
                              ? Colors.black
                              : Color(0xfff0f0f0),
                        ),
                      ),
                      CustomContainer(
                        backgroundColor: Color(0xff3a2d7f),
                        borderRadius: 20,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 8,
                            right: 8.0,
                            top: 3,
                            bottom: 3,
                          ),
                          child: Text(
                            "BSE",
                            // webSocketServiceProvider
                            //     .ddWatchlistStockList[index]
                            //     .tickerExchange ??
                            //     "",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color(0xfff0f0f0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3),
                  Container(
                    width: screenWidth * 0.3,
                    child: Text(
                      "NTPC Limited",
                      // '${webSocketServiceProvider.ddWatchlistStockList[index].issuerName ?? ""}',
                      // "${TimeConverter().convertToISTTimeFormat(webSocketServiceProvider.ddWatchlistStockList[index].updatedAt ?? DateTime.now().toString())} ",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: (themeProvider.defaultTheme)
                            ? Colors.black
                            : Color(0xfff0f0f0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${currencyConstants.currency}234",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.green

                            // color: (themeProvider.defaultTheme)
                            //     ? Colors.black
                            //     : Color(0xfff0f0f0),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
