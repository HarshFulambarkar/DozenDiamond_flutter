import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../AB_Ladder/stateManagement/ladder_provider.dart';
import '../../AB_Ladder/models/ladder_list_model.dart';
import '../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../DD_Navigation/widgets/nav_drawer.dart';
import '../../DD_Navigation/widgets/nav_drawer_new.dart';
import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/widgets/custom_container.dart';
import '../../localization/translation_keys.dart';
import '../widgets/download_dialog.dart';

class DownloadScreen extends StatefulWidget {
  final Function updateIndex;
  final bool isAuthenticationPresent;
  DownloadScreen(
      {super.key,
        this.isAuthenticationPresent = false,
        required this.updateIndex});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  late ThemeProvider themeProvider;
  late NavigationProvider navigationProvider;
  late LadderProvider ladderProvider;

  CurrencyConstants? _currencyConstantsProvider;

  @override
  void initState() {
    super.initState();
    ladderProvider = Provider.of<LadderProvider>(context, listen: false);
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    navigationProvider = Provider.of<NavigationProvider>(
      context,
      listen: false,
    );
    _currencyConstantsProvider = Provider.of<CurrencyConstants>(
      context,
      listen: false,
    );

    callInitialApi();
  }

  void callInitialApi() async {
    await ladderProvider!
        .fetchAllLadder(_currencyConstantsProvider!)
        .then((value) {
      setState(() {});
    })
        .catchError((err) {
      print(err);
    });
  }

  void _triggerDrawer() {
    _key.currentState!.openDrawer();
  }

  @override
  void codeUpdated() {


    // submit otp here
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);

    return SafeArea(
      child: Center(
        child: Stack(
          children: [
            Center(
              child: Container(
                color: (themeProvider.defaultTheme)
                    ? Color(0XFFF5F5F5)
                    : Colors.transparent,
                width: screenWidth,
                child: Scaffold(
                  drawer: NavDrawerNew(updateIndex: widget.updateIndex),
                  key: _key,
                  backgroundColor: (themeProvider.defaultTheme)
                      ? Color(0XFFF5F5F5)
                      : Color(0xFF15181F),
                  body: Stack(
                    children: [

                      SingleChildScrollView(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 45),
                            SizedBox(height: 10),

                            SizedBox(height: 10),

                            Padding(
                              padding: const EdgeInsets.only(left: 16, right: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    TranslationKeys.download,
                                    style: TextStyle(
                                      fontFamily: 'Britanica',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: (themeProvider.defaultTheme)
                                          ? Color(0xff141414)
                                          : Color(0xfff0f0f0),
                                    ),
                                  ),

                                  InkWell(
                                    onTap: () async {},
                                    child: Text(
                                      "",
                                      style: TextStyle(
                                        fontFamily: 'Britanica',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: (themeProvider.defaultTheme)
                                            ? Color(0xff0090ff)
                                            : Color(0xff0090ff),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 10),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 16, right: 16.0),
                                  child: Text(
                                    "Ladders",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20,
                                      color: (themeProvider.defaultTheme)
                                          ? Color(0xff0f0f0f)
                                          : Color(0xfff0f0f0),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 10),
                                for (
                                var i = 0;
                                i < ladderProvider.stockLadders.length;
                                i++
                                )
                                  buildLadderDownloadSection(
                                    context,
                                    screenWidth,
                                    ladderProvider.stockLadders[i],
                                    i,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      CustomHomeAppBarWithProviderNew(
                        backButton: true,
                        backIndex: navigationProvider.previousSelectedIndex,
                        leadingAction: _triggerDrawer,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        )
      ),
    );
  }

  Widget buildLadderDownloadSection(
      BuildContext context,
      double screenWidth,
      LadderListModel ladder,
      int stockIndex,
      ) {
    bool isLadderSectionOpen = true;
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
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
                  Row(
                    children: [
                      Text(
                        "  ${stockIndex + 1} ",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: (themeProvider.defaultTheme)
                              ? Color(0xff0f0f0f)
                              : Color(0xfff0f0f0),
                        ),
                      ),

                      Text(
                        "${ladder.stockName}",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: (themeProvider.defaultTheme)
                              ? Color(0xff0f0f0f)
                              : Color(0xfff0f0f0),
                        ),
                      ),

                      Text(
                        " (${ladder.ladders.length} Ladders)",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          color: (themeProvider.defaultTheme)
                              ? Color(0xff0f0f0f)
                              : Color(0xffa2b0bc),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isLadderSectionOpen = !isLadderSectionOpen;
                          });
                        },
                        icon: isLadderSectionOpen
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
                ],
              ),
            ),
            if (isLadderSectionOpen)
              for (var i = 0; i < ladder.ladders.length; i++)
                buildSubLaddersDownloadSection(
                  context,
                  screenWidth,
                  stockIndex,
                  i,
                  ladder.ladders[i],
                ),
          ],
        );
      },
    );
  }

  Widget buildTextAndWidgetRow({
    required String title,
    required Widget widget,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: (themeProvider.defaultTheme)
                  ? Color(0xff0f0f0f)
                  : Color(0xfff0f0f0),
            ),
          ),
        ),
        widget,
      ],
    );
  }

  Map<String, String> titleToCsvType = {
    'Exc. Orders CSV': 'userLadderExecutedOrderDownload',
    'All Orders CSV': 'userLadderAllOrderDownload',
    'All Ladders CSV': 'userLadderDownload',
    'Trades CSV': 'userTradeDownloadCsv',
    'Orders CSV': 'userOrderDownload',
    'Positions CSV': 'userPositonDownload',
  };
  String csvTypeFromTitle(String title) {
    return titleToCsvType[title] ?? "";
  }

  Widget buildTextAndDownloadRow({
    required String title,
    required String stockName,
    String? ladId,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                // color: (themeProvider.defaultTheme)?Colors.purple[400]:Colors.yellow[200],
                color: (themeProvider.defaultTheme)
                    ? Color(0xff0f0f0f)
                    : Color(0xfff0f0f0),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return DownloadCsvDialog(
                    csvType: csvTypeFromTitle(title),
                    stockName: stockName,
                    ladId: ladId,
                  );
                },
              );
            },
            child: Text(
              "Download",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.blue,
                // color: (themeProvider.defaultTheme)?Colors.purple[400]:Colors.yellow[200],
                // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSubLaddersDownloadSection(
      BuildContext context,
      double screenWidth,
      int stockIndex,
      int ladderIndex,
      Ladder ladder,
      ) {
    bool isSubLadderSectionOpen = true;
    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.only(
            top: 5.0,
            bottom: 5,
            left: 6,
            right: 6,
          ),
          child: CustomContainer(
            padding: 0,
            margin: EdgeInsets.zero,
            borderRadius: 10,
            backgroundColor: (themeProvider.defaultTheme)
                ? Color(0xffdadde6)
                : Color(0xff2c2c31), //Color(0xff2c2c31),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 12,
                right: 12,
                bottom: 5,
                top: 5.0,
              ),
              child: Column(
                children: [
                  buildTextAndWidgetRow(
                    title:
                    "${ladderProvider.stockLadders[stockIndex].stockName} ${ladder.ladName} (${ladder.ladExchange})",
                    widget: IconButton(
                      onPressed: () {
                        setState(() {
                          isSubLadderSectionOpen = !isSubLadderSectionOpen;
                        });
                      },
                      icon: (isSubLadderSectionOpen)
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
                  ),
                  if (isSubLadderSectionOpen) ...[
                    Divider(color: Colors.grey, thickness: 0.3),
                    buildTextAndDownloadRow(
                      title: "Exc. Orders CSV",
                      stockName:
                      ladderProvider.stockLadders[stockIndex].stockName ??
                          "",
                      ladId: ladder.ladId.toString(),
                    ),
                    buildTextAndDownloadRow(
                      title: "All Orders CSV",
                      stockName:
                      ladderProvider.stockLadders[stockIndex].stockName ??
                          "",
                      ladId: ladder.ladId.toString(),
                    ),
                    buildTextAndDownloadRow(
                      title: "All Ladders CSV",
                      stockName:
                      ladderProvider.stockLadders[stockIndex].stockName ??
                          "",
                      ladId: ladder.ladId.toString(),
                    ),
                    buildTextAndDownloadRow(
                      title: "Trades CSV",
                      stockName:
                      ladderProvider.stockLadders[stockIndex].stockName ??
                          "",
                      ladId: ladder.ladId.toString(),
                    ),
                    buildTextAndDownloadRow(
                      title: "Orders CSV",
                      stockName:
                      ladderProvider.stockLadders[stockIndex].stockName ??
                          "",
                      ladId: ladder.ladId.toString(),
                    ),
                    buildTextAndDownloadRow(
                      title: "Positions CSV",
                      stockName:
                      ladderProvider.stockLadders[stockIndex].stockName ??
                          "",
                      ladId: ladder.ladId.toString(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
