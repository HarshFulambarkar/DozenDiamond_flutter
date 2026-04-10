import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../Settings/stateManagement/theme_provider.dart';
import '../../create_ladder_detailed/stateManagement/create_ladder_provider.dart';
import '../../create_ladder_easy/model/ladder_creation_tickers_response.dart';
import '../../create_ladder_easy/stateManagement/create_ladder_easy_provider.dart';
import '../../global/constants/currency_constants.dart';
import '../../global/constants/shared_preferences_manager.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/widgets/custom_container.dart';
import '../../localization/translation_keys.dart';

class LadderCreationOptionScreenNew extends StatefulWidget {
  final int indexOfLadder;
  final String message;
  final NavigationProvider navigationProvider;
  final CreateLadderEasyProvider createLadderEasyProvider;
  final dynamic value; // Replace with actual value type if known

  const LadderCreationOptionScreenNew({
    Key? key,
    required this.indexOfLadder,
    required this.message,
    required this.navigationProvider,
    required this.createLadderEasyProvider,
    required this.value,
  }) : super(key: key);

  @override
  State<LadderCreationOptionScreenNew> createState() => _LadderCreationOptionScreenNewState();
}

class _LadderCreationOptionScreenNewState extends State<LadderCreationOptionScreenNew> {
  String? ladderCreationType; // This will store the ladder creation type
  late CurrencyConstants currencyConstantsProvider;
  late ThemeProvider themeProvider;
  late CreateLadderProvider createLadderProvider;

  String selectedMode = "Detailed";

  @override
  void initState() {
    super.initState();
    _loadLadderCreationType(); // Asynchronous loading of ladder creation type
  }

  Future<void> _loadLadderCreationType() async {
    // Fetching the ladder creation type
    final type = await SharedPreferenceManager.getLadderCreationType() ?? "";
    setState(() {
      ladderCreationType = type;
    });
  }


  @override
  Widget build(BuildContext context) {

    double screenWidth = screenWidthRecognizer(context);
    currencyConstantsProvider =
        Provider.of<CurrencyConstants>(context, listen: true);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    createLadderProvider = Provider.of<CreateLadderProvider>(context, listen: true);

    return SafeArea(
      child: Container(
        width: screenWidth,
        decoration: BoxDecoration(
          color: (themeProvider.defaultTheme)?Colors.white:Color(0xff2c2c31),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
          
              SizedBox(
                height: 20,
              ),
          
              buildTopHeadingSection(context, screenWidth),
          
              SizedBox(
                height: 10,
              ),
          
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10.0),
                child: Divider(
                  thickness: 1,
                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xff808083),
                ),
              ),
          
              SizedBox(
                height: 10,
              ),
          
              buildValuesSection(context, screenWidth),
          
              SizedBox(
                height: 20,
              ),
          
              buildLadderCreationOptionsSection(context, screenWidth),
          
              SizedBox(
                height: 15,
              ),
          
              // buildToggleButtonSection(context, screenWidth),
              //
              // SizedBox(
              //   height: 15,
              // ),
          
              buildBottomButtonSection(context, screenWidth),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTopHeadingSection(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TranslationKeys.chooseYourLadderMode,
            style: TextStyle(
              fontFamily: "Britanica",
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
            ),
          ),

          SizedBox(
            height: 10,
          ),

          Text(
            TranslationKeys.selectTheTradingModeThatSuitsYouBestStartSimpleOrGoInDepthWithAdvancedSettings,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w300,
              fontSize: 14,
              color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc),
            ),
          )
        ],
      ),
    );
  }

  Widget buildValuesSection(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "${createLadderProvider.ladderCreationScreen1[widget.indexOfLadder].clpTicker}",
                    // "WIPRO",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
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
                        // "BSE",
                        createLadderProvider
                            .ladderCreationScreen1[widget.indexOfLadder]
                            .clpExchange ??
                            "",
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

              Text(
                // "${currencyConstantsProvider.currency}302.98",
                "${currencyConstantsProvider.currency}${createLadderProvider.ladderCreationScreen1[widget.indexOfLadder].clpInitialPurchasePrice!.text}",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                ),
              )
            ],
          ),

          SizedBox(
            height: 8,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Cash allocated:",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w300,
                  fontSize: 14,
                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc),
                ),
              ),

              Text(
                // "${currencyConstantsProvider.currency}2,00,000",
                "${currencyConstantsProvider.currency}${createLadderProvider.cashAllocatedControllerList[createLadderProvider.ladderCreationScreen1[widget.indexOfLadder].clpTickerId]!.text}",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                ),
              )
            ],
          )

        ],
      ),
    );
  }

  Widget buildLadderCreationOptionsSection(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16.0),
      child: Column(
        children: [
          CustomContainer(
            backgroundColor: (themeProvider.defaultTheme)?Color(0xffBEDAF0):(selectedMode == "Detailed")
                ?Color(0xff163a57)
                :Color(0xff1d1d1f),
            padding: 0,
            paddingEdge: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            borderRadius: 10,
            onTap: () {
              setState((){
                selectedMode = "Detailed";
              });

            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16, top: 12, bottom: 12),
              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            TranslationKeys.detailed,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                            ),
                          ),

                          SizedBox(
                            width: 5,
                          ),

                          Text(
                            TranslationKeys.recommended,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic,
                              color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                            ),
                          ),

                          SizedBox(
                            width: 5,
                          ),

                          Icon(
                              CupertinoIcons.sparkles,
                            color: Colors.yellow,
                            size: 10,
                          )

                        ],
                      ),

                      (selectedMode == "Detailed")?CustomContainer(
                        borderRadius: 50,
                        borderColor: Color(0xff1a94f2),
                        padding: 0,
                        paddingEdge: EdgeInsets.zero,
                        margin: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        borderWidth: 1.5,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.circle,
                            size: 10,
                            color: Color(0xff1a94f2),
                          ),
                        ),
                      ):CustomContainer(
                        borderRadius: 50,
                        borderColor: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0), // Color(0xff1a94f2),
                        padding: 0,
                        paddingEdge: EdgeInsets.zero,
                        margin: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        borderWidth: 1.5,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.circle,
                            size: 10,
                            color: Colors.transparent, // Color(0xff1a94f2),
                          ),
                        ),
                      )
                    ],
                  ),

                  SizedBox(
                    height: 8,
                  ),

                  Text(
                    TranslationKeys.fullControlWithAdvancedSettings,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc)
                    ),
                  )
                ],
              ),
            ),
          ),

          SizedBox(
            height: 12,
          ),

          CustomContainer(
            backgroundColor: (themeProvider.defaultTheme)?Color(0xffBEDAF0):(selectedMode == 'Easy')
                ?Color(0xff163a57)
                :Color(0xff1d1d1f), // Color(0xff163a57),
            padding: 0,
            paddingEdge: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            borderRadius: 10,
            onTap: () {
              setState((){
                selectedMode = "Easy";
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16, top: 12, bottom: 12),
              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            TranslationKeys.easy,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                            ),
                          ),

                          // SizedBox(
                          //   width: 5,
                          // ),
                          //
                          // Text(
                          //   TranslationKeys.recommended,
                          //   style: GoogleFonts.poppins(
                          //     fontSize: 12,
                          //     fontWeight: FontWeight.w400,
                          //     fontStyle: FontStyle.italic,
                          //     color: Color(0xfff0f0f0),
                          //   ),
                          // ),
                          //
                          // SizedBox(
                          //   width: 5,
                          // ),
                          //
                          // Icon(
                          //   CupertinoIcons.sparkles,
                          //   color: Colors.yellow,
                          //   size: 10,
                          // )

                        ],
                      ),

                      (selectedMode == "Easy")?CustomContainer(
                        borderRadius: 50,
                        borderColor: Color(0xff1a94f2),
                        padding: 0,
                        paddingEdge: EdgeInsets.zero,
                        margin: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        borderWidth: 1.5,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.circle,
                            size: 10,
                            color: Color(0xff1a94f2),
                          ),
                        ),
                      ):CustomContainer(
                        borderRadius: 50,
                        borderColor: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0), // Color(0xff1a94f2),
                        padding: 0,
                        paddingEdge: EdgeInsets.zero,
                        margin: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        borderWidth: 1.5,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.circle,
                            size: 10,
                            color: Colors.transparent, // Color(0xff1a94f2),
                          ),
                        ),
                      )
                    ],
                  ),

                  SizedBox(
                    height: 8,
                  ),

                  Text(
                    TranslationKeys.noFormulasSimpleAutomation,
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc)
                    ),
                  )
                ],
              ),
            ),
          ),

          // (createLadderProvider.priorBuyAvailable[createLadderProvider.ladderCreationScreen1[widget.indexOfLadder].clpTicker] == true)?
          SizedBox(
            height: 12,
          ),
              // :Container(),

          // (createLadderProvider.priorBuyAvailable[createLadderProvider.ladderCreationScreen1[widget.indexOfLadder].clpTicker] == true)?
          CustomContainer(
            backgroundColor: (themeProvider.defaultTheme)?Color(0xffBEDAF0):(selectedMode == 'Prior Buy')
                ?Color(0xff163a57)
                :Color(0xff1d1d1f), // Color(0xff163a57),
            padding: 0,
            paddingEdge: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            borderRadius: 10,
            onTap: () {
              setState((){
                selectedMode = "Prior Buy";
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16, top: 12, bottom: 12),
              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Prior Buy",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                            ),
                          ),

                          // SizedBox(
                          //   width: 5,
                          // ),
                          //
                          // Text(
                          //   TranslationKeys.recommended,
                          //   style: GoogleFonts.poppins(
                          //     fontSize: 12,
                          //     fontWeight: FontWeight.w400,
                          //     fontStyle: FontStyle.italic,
                          //     color: Color(0xfff0f0f0),
                          //   ),
                          // ),
                          //
                          // SizedBox(
                          //   width: 5,
                          // ),
                          //
                          // Icon(
                          //   CupertinoIcons.sparkles,
                          //   color: Colors.yellow,
                          //   size: 10,
                          // )

                        ],
                      ),

                      (selectedMode == "Prior Buy")?CustomContainer(
                        borderRadius: 50,
                        borderColor: Color(0xff1a94f2),
                        padding: 0,
                        paddingEdge: EdgeInsets.zero,
                        margin: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        borderWidth: 1.5,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.circle,
                            size: 10,
                            color: Color(0xff1a94f2),
                          ),
                        ),
                      ):CustomContainer(
                        borderRadius: 50,
                        borderColor: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0), // Color(0xff1a94f2),
                        padding: 0,
                        paddingEdge: EdgeInsets.zero,
                        margin: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        borderWidth: 1.5,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.circle,
                            size: 10,
                            color: Colors.transparent, // Color(0xff1a94f2),
                          ),
                        ),
                      )
                    ],
                  ),

                  SizedBox(
                    height: 8,
                  ),

                  Text(
                    // "If you bought the stock priorly",
                    "Stocks you currently Hold in your Demat Account.",
                    // TranslationKeys.noFormulasSimpleAutomation,
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc)
                    ),
                  )
                ],
              ),
            ),
          ),
              // :Container(),

          // SizedBox(
          //   height: 12,
          // ),
          //
          // CustomContainer(
          //   backgroundColor: (themeProvider.defaultTheme)?Color(0xffBEDAF0):(selectedMode == 'One Click')
          //       ?Color(0xff163a57)
          //       :Color(0xff1d1d1f), // Color(0xff163a57),
          //   padding: 0,
          //   paddingEdge: EdgeInsets.zero,
          //   margin: EdgeInsets.zero,
          //   borderRadius: 10,
          //   onTap: () {
          //     setState((){
          //       selectedMode = "One Click";
          //     });
          //   },
          //   child: Padding(
          //     padding: const EdgeInsets.only(left: 16.0, right: 16, top: 12, bottom: 12),
          //     child: Column(
          //
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Row(
          //               children: [
          //                 Text(
          //                   "One Click",
          //                   style: GoogleFonts.poppins(
          //                     fontSize: 16,
          //                     fontWeight: FontWeight.w400,
          //                     color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
          //                   ),
          //                 ),
          //
          //
          //               ],
          //             ),
          //
          //             (selectedMode == "One Click")?CustomContainer(
          //               borderRadius: 50,
          //               borderColor: Color(0xff1a94f2),
          //               padding: 0,
          //               paddingEdge: EdgeInsets.zero,
          //               margin: EdgeInsets.zero,
          //               backgroundColor: Colors.transparent,
          //               borderWidth: 1.5,
          //               child: Padding(
          //                 padding: const EdgeInsets.all(5.0),
          //                 child: Icon(
          //                   Icons.circle,
          //                   size: 10,
          //                   color: Color(0xff1a94f2),
          //                 ),
          //               ),
          //             ):CustomContainer(
          //               borderRadius: 50,
          //               borderColor: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0), // Color(0xff1a94f2),
          //               padding: 0,
          //               paddingEdge: EdgeInsets.zero,
          //               margin: EdgeInsets.zero,
          //               backgroundColor: Colors.transparent,
          //               borderWidth: 1.5,
          //               child: Padding(
          //                 padding: const EdgeInsets.all(5.0),
          //                 child: Icon(
          //                   Icons.circle,
          //                   size: 10,
          //                   color: Colors.transparent, // Color(0xff1a94f2),
          //                 ),
          //               ),
          //             )
          //           ],
          //         ),
          //
          //         SizedBox(
          //           height: 8,
          //         ),
          //
          //         Text(
          //           "Create a ladder in one click",
          //           style: GoogleFonts.poppins(
          //               fontSize: 14,
          //               fontWeight: FontWeight.w300,
          //               color: (themeProvider.defaultTheme)?Colors.black:Color(0xffa2b0bc)
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  bool isChecked = false;

  Widget buildToggleButtonSection(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18.0),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          children: [
            Text(
              TranslationKeys.useTheSameModeForAllSelectedStocks,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w300,
                fontSize: 16,
                color: Color(0xfff0f0f0),
              ),
            ),

            Transform.scale(
              scale: 0.7,
              child: Switch(
                inactiveTrackColor: Colors.grey,
                inactiveThumbColor: Colors.white,
                activeColor: const Color(0xFF0099CC),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: isChecked,
                onChanged: (value) async {
                  setState(() {
                    isChecked = !isChecked;
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildBottomButtonSection(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomContainer(
            padding: 0,
            paddingEdge: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            borderRadius: 12,
            backgroundColor: Colors.transparent,
            onTap: () async {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8.0),
              child: Text(
                  TranslationKeys.cancel,
                  style: GoogleFonts.poppins(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0)
                  )
              ),
            ),
          ),

          SizedBox(
            width: 5,
          ),

          CustomContainer(
            padding: 0,
            paddingEdge: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            borderRadius: 12,
            backgroundColor: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
            onTap: () async {

              print(selectedMode);

              createLadderProvider.selectedMode = selectedMode;

              if(selectedMode == "Easy") {

                print("inside easy");

                widget.createLadderEasyProvider.ladderDetailsList.clear();
                widget.createLadderEasyProvider.currentPrice = double.parse(
                    createLadderProvider.ladderCreationParametersScreen1.currentPrice.toString()
                        .replaceAll(",", ""));
                for (int i = widget.indexOfLadder;
                // i < widget.value.ladderCreationScreen1.length;
                i < createLadderProvider.ladderCreationScreen1.length;
                i++) {
                  widget.createLadderEasyProvider.ladderDetailsList.add(
                    LadderDetails(
                      ladExchange: createLadderProvider.ladderCreationScreen1[i].clpExchange,
                      ladTickerId:
                      // widget.value.ladderCreationScreen1[i].clpTickerId,
                      createLadderProvider.ladderCreationScreen1[i].clpTickerId,
                      ladTicker:
                      // widget.value.ladderCreationScreen1[i].clpTicker,
                      createLadderProvider.ladderCreationScreen1[i].clpTicker,
                      // ladInitialBuyPrice: widget.value.ladderCreationScreen1[i]
                      ladInitialBuyPrice: createLadderProvider.ladderCreationScreen1[i]
                          .clpInitialPurchasePrice!.text,
                      ladCashAllocated:
                      // widget.value.cashAllocatedControllerList[i].text,
                      createLadderProvider.cashAllocatedControllerList[createLadderProvider.ladderCreationScreen1[i].clpTickerId]!.text,
                    ),
                  );
                }
                widget.createLadderEasyProvider.updateCheckbox = false;
                widget.createLadderEasyProvider.stockRecommendedParametersDataEasyLadderCreate = createLadderProvider.stockRecommendedParametersData;
                widget.navigationProvider.selectedIndex = 4;
                await Future.delayed(const Duration(seconds: 1));
                // Navigate to Easy Ladder Creation Option
                print("before calling navigator .pop");
                Navigator.pop(context); // Close the current screen

                print("selectedIndex");
                print(widget.navigationProvider.selectedIndex);


                print("previousSelectedIndex");
                print(widget.navigationProvider.previousSelectedIndex);
                widget.navigationProvider.previousSelectedIndex =
                    widget.navigationProvider.selectedIndex;
                widget.navigationProvider.selectedIndex = 8;

              } else if(selectedMode == "Detailed") {
                widget.navigationProvider.previousSelectedIndex =
                    widget.navigationProvider.selectedIndex;
                widget.navigationProvider.selectedIndex = 5;
                Navigator.pop(context); // Close the current screen
              } else if(selectedMode == "One Click") {

                Fluttertoast.showToast(msg: 'This feature will unlock soon!');

              } else {
                print("inside prior but option");
                widget.navigationProvider.previousSelectedIndex =
                    widget.navigationProvider.selectedIndex;
                widget.navigationProvider.selectedIndex = 5;
                Navigator.pop(context); // Close the current screen

                // widget.navigationProvider.previousSelectedIndex =
                //     widget.navigationProvider.selectedIndex;
                // widget.navigationProvider.selectedIndex = 27;
                // Navigator.pop(context); // Close the current screen
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8.0),
              child: Text(
                  TranslationKeys.continuee,
                  style: GoogleFonts.poppins(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    color: (themeProvider.defaultTheme)
                        ?Color(0xfff0f0f0)
                        :Color(0xff000000),
                  )
              ),
            ),
          )
        ],
      ),
    );
  }
}
