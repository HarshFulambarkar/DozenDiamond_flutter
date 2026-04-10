import 'package:dozen_diamond/ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import 'package:dozen_diamond/create_ladder_detailed/stateManagement/create_ladder_provider.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:dozen_diamond/global/constants/shared_preferences_manager.dart';
import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:flutter/material.dart';
import 'package:dozen_diamond/DD_Navigation/stateManagement/navigation_provider.dart';
import 'package:dozen_diamond/create_ladder_easy/stateManagement/create_ladder_easy_provider.dart';
import 'package:dozen_diamond/create_ladder_easy/model/ladder_creation_tickers_response.dart';
import 'package:provider/provider.dart';

import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';

class LadderCreationOptionScreen extends StatefulWidget {
  final int indexOfLadder;
  final String message;
  final NavigationProvider navigationProvider;
  final CreateLadderEasyProvider createLadderEasyProvider;
  final dynamic value; // Replace with actual value type if known

  const LadderCreationOptionScreen({
    Key? key,
    required this.indexOfLadder,
    required this.message,
    required this.navigationProvider,
    required this.createLadderEasyProvider,
    required this.value,
  }) : super(key: key);

  @override
  _LadderCreationOptionScreenState createState() =>
      _LadderCreationOptionScreenState();
}

class _LadderCreationOptionScreenState
    extends State<LadderCreationOptionScreen> {
  String? ladderCreationType; // This will store the ladder creation type
  late CurrencyConstants currencyConstantsProvider;
  late ThemeProvider themeProvider;
  late CreateLadderProvider createLadderProvider;

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

  Widget customUi(BuildContext buildContext) {
    return Column(
      children: [
        Text(
          widget.message,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: Colors.blue),
                backgroundColor: (themeProvider.defaultTheme)?Colors.blue:Colors.transparent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: () {
                // Navigate to Advance Ladder Creation Option
                widget.navigationProvider.previousSelectedIndex =
                    widget.navigationProvider.selectedIndex;
                widget.navigationProvider.selectedIndex = 5;
                Navigator.pop(buildContext); // Close the current screen
              },
              child: Text(
                'Detailed',
                style: TextStyle(color: (themeProvider.defaultTheme)?Colors.white:Colors.blue),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: Colors.green),
                backgroundColor: (themeProvider.defaultTheme)?Colors.green:Colors.transparent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: () async {
                // Clear the ladder details list and fill in details
                widget.createLadderEasyProvider.ladderDetailsList.clear();
                for (int i = widget.indexOfLadder;
                    // i < widget.value.ladderCreationScreen1.length;
                    i < createLadderProvider.ladderCreationScreen1.length;
                    i++) {
                  widget.createLadderEasyProvider.ladderDetailsList.add(
                    LadderDetails(
                      ladExchange: createLadderProvider.ladderCreationScreen1[i].clpExchange ?? "",
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
                widget.navigationProvider.selectedIndex = 4;
                await Future.delayed(const Duration(seconds: 1));
                // Navigate to Easy Ladder Creation Option
                Navigator.pop(buildContext); // Close the current screen

                print("selectedIndex");
                print(widget.navigationProvider.selectedIndex);


                print("previousSelectedIndex");
                print(widget.navigationProvider.previousSelectedIndex);
                widget.navigationProvider.previousSelectedIndex =
                    widget.navigationProvider.selectedIndex;
                widget.navigationProvider.selectedIndex = 8;
              },
              child: Text('Easy', style: TextStyle(
                  color: (themeProvider.defaultTheme)?Colors.white:Colors.green
              )),
            ),
          ],
        ),
      ],
    );
  }

  Widget beginnerUi(BuildContext buildContext) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            side: BorderSide(
                color: Colors.blue
            ),
            backgroundColor: (themeProvider.defaultTheme)?Colors.blue:Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          ),
          onPressed: () async {
            // Provide to Easy Ladder Creation
            widget.createLadderEasyProvider.ladderDetailsList.clear();
            for (int i = widget.indexOfLadder;
                // i < widget.value.ladderCreationScreen1.length;
                i < createLadderProvider.ladderCreationScreen1.length;
                i++) {
              widget.createLadderEasyProvider.ladderDetailsList.add(
                LadderDetails(
                  ladExchange: createLadderProvider.ladderCreationScreen1[i].clpExchange ?? "",
                  ladTickerId:
                      // widget.value.ladderCreationScreen1[i].clpTickerId,
                  createLadderProvider.ladderCreationScreen1[i].clpTickerId,
                  // ladTicker: widget.value.ladderCreationScreen1[i].clpTicker,
                  ladTicker: createLadderProvider.ladderCreationScreen1[i].clpTicker,
                  // ladInitialBuyPrice: widget.value.ladderCreationScreen1[i]
                  ladInitialBuyPrice: createLadderProvider.ladderCreationScreen1[i]
                      .clpInitialPurchasePrice!.text,
                  ladCashAllocated:
                      // widget.value.cashAllocatedControllerList[i].text,
                  createLadderProvider.cashAllocatedControllerList[createLadderProvider.ladderCreationScreen1[i].clpTickerId]!.text,
                ),
              );
            }
            widget.navigationProvider.selectedIndex = 4;
            await Future.delayed(const Duration(seconds: 1));
            Navigator.pop(buildContext);
            widget.navigationProvider.previousSelectedIndex =
                widget.navigationProvider.selectedIndex;
            widget.navigationProvider.selectedIndex = 8;
          },
          child: Text('Proceed to Easy Ladder Creation',
              style: TextStyle(
                  color: (themeProvider.defaultTheme)?Colors.white:Colors.blue
              )),
        ),
      ],
    );
  }

  Widget advancedUi(BuildContext buildContext) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            side: BorderSide(color: Colors.green),
            backgroundColor: (themeProvider.defaultTheme)?Colors.green:Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          ),
          onPressed: () {
            // Navigate to Advance Ladder Creation Option
            widget.navigationProvider.previousSelectedIndex =
                widget.navigationProvider.selectedIndex;
            widget.navigationProvider.selectedIndex = 5;
            Navigator.pop(buildContext); // Close the current screen
          },
          child: Text(
            'Proceed to Detailed Ladder Creation',
            style: TextStyle(color: (themeProvider.defaultTheme)?Colors.white:Colors.green),
          ),
        ),
      ],
    );
  }

  Widget customLadderCreationOption(BuildContext buildContext) {
    // If ladderCreationType is null, show a loading spinner
    if (ladderCreationType == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${createLadderProvider.ladderCreationScreen1[widget.indexOfLadder].clpTicker}",
                    // "${widget.value.ladderCreationScreen1[widget.indexOfLadder].clpTicker}",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  // Row(
                  //   children: [
                  //     Text(
                  //       "current price: ",
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //       ),
                  //     ),
                  //     Text(
                  //       "${currencyConstantsProvider.currency}${widget.value.ladderCreationScreen1[widget.indexOfLadder].clpInitialPurchasePrice!.text}",
                  //       style: TextStyle(
                  //         fontSize: 18,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Current Price: ",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    // "${currencyConstantsProvider.currency}${widget.value.ladderCreationScreen1[widget.indexOfLadder].clpInitialPurchasePrice!.text}",
                    "${currencyConstantsProvider.currency}${createLadderProvider.ladderCreationScreen1[widget.indexOfLadder].clpInitialPurchasePrice!.text}",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Cash Assigned: ",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    // "${currencyConstantsProvider.currency}${widget.value.cashAllocatedControllerList[widget.indexOfLadder].text}",
                    "${currencyConstantsProvider.currency}${createLadderProvider.cashAllocatedControllerList[createLadderProvider.ladderCreationScreen1[widget.indexOfLadder].clpTickerId]!.text}",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),
          // Display the appropriate UI based on ladderCreationType
          ladderCreationType == "custom"
              ? customUi(buildContext)
              : ladderCreationType == 'beginner'
                  ? beginnerUi(buildContext)
                  : advancedUi(buildContext),

          const SizedBox(height: 20),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              side: BorderSide(style: BorderStyle.solid, color: Colors.red),
              backgroundColor: (themeProvider.defaultTheme)?Colors.red:Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            onPressed: () {
              // Navigate to Advance Ladder Creation Option

              widget.navigationProvider.selectedIndex = 4;
              Navigator.pop(buildContext); // Close the current screen
            },
            child: Text(
              'Modify Cash Assign',
              style: TextStyle(
                  color: (themeProvider.defaultTheme)?Colors.white:Colors.red
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext buildContext) {
    double screenWidth = screenWidthRecognizer(context);
    currencyConstantsProvider =
        Provider.of<CurrencyConstants>(context, listen: true);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    createLadderProvider = Provider.of<CreateLadderProvider>(context, listen: true);
    return Scaffold(
      body: Stack(
        children: [
          (createLadderProvider.ladderCreationScreen1.isEmpty)?Container():Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Container(
                color: (themeProvider.defaultTheme)?Color(0XFFF5F5F5):Colors.transparent,
                width: screenWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 45,
                    ),
                    // SizedBox(
                    //   height: AppBar().preferredSize.height * 1.2,
                    // ),
                    customLadderCreationOption(buildContext),
                  ],
                ),
              ),
            ),
          ),
          CustomHomeAppBarWithProviderNew(
            backButton: true,
            isForPop: true,
          ),
        ],
      ),
    );
  }
}
