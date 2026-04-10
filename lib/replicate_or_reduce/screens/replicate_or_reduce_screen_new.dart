import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../create_ladder_easy/widgets/custom_container.dart';
import '../../global/constants/currency_constants.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/widgets/info_icon_display.dart';
import '../../global/widgets/my_text_field.dart';
import '../stateManagement/replicate_or_reduce_provider.dart';

class ReplicateOrReduceScreenNew extends StatelessWidget {
  ReplicateOrReduceScreenNew({super.key});

  late NavigationProvider navigationProvider;
  late CurrencyConstants currencyConstantsProvider;
  late ReplicateOrReduceProvider replicateOrReduceProvider;
  late ThemeProvider themeProvider;
  late CurrencyConstants currencyConstants;

  @override
  Widget build(BuildContext context) {
    navigationProvider = Provider.of<NavigationProvider>(context, listen: true);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    currencyConstantsProvider =
        Provider.of<CurrencyConstants>(context, listen: true);
    replicateOrReduceProvider =
        Provider.of<ReplicateOrReduceProvider>(context, listen: true);
    currencyConstants = Provider.of<CurrencyConstants>(context, listen: true);
    double screenWidth = screenWidthRecognizer(context);

    return PopScope(
      onPopInvokedWithResult: (value, result) {
        navigationProvider.selectedIndex =
            navigationProvider.previousSelectedIndex;
      },
      child: SafeArea(
        top: true,
        bottom: false,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Stack(
              children: [

                Center(
                  child: Container(
                    width: screenWidth == 0 ? null : screenWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 45,
                        ),

                        SizedBox(
                          height: 10,
                        ),

                        buildTopTabSection(context, screenWidth),

                        SizedBox(height: 20),

                        (replicateOrReduceProvider
                            .selectedReplicateOrReduceOptions ==
                            "Reduce")
                            ? buildReduceSection(context, screenWidth)
                            : buildReplicateSection(context, screenWidth),
                      ],
                    ),
                  ),
                ),

                CustomHomeAppBarWithProviderNew(
                  backButton: true,
                  widthOfWidget: screenWidth,
                  backIndex:
                  1, //these leadingAction button is not working, I have tired making it work, but it isn't.
                )
              ],
            ),
          )
        ),
      ),
    );
  }

  Widget buildTopTabSection(BuildContext context, double screenWidth) {
    return CustomContainer(
      padding: 0,
      margin: EdgeInsets.zero,
      borderRadius: 0,
      width: screenWidth,
      backgroundColor: (themeProvider.defaultTheme)?Color(0xffdadde6):Color(0xff2c2c31),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CustomContainer(
              backgroundColor: (replicateOrReduceProvider.selectedReplicateOrReduceOptions == "Replicate")
                  ?Color(0xff141414)
                  :Colors.transparent,
              onTap: () {
                replicateOrReduceProvider.selectedReplicateOrReduceOptions = "Replicate";
              },

              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8.0),
                  child: Text(
                    "Replicate",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: (replicateOrReduceProvider.selectedReplicateOrReduceOptions == "Replicate")
                          ?Color(0xff1a94f2)
                          :Color(0xffa2b0bc),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: CustomContainer(
              backgroundColor: (replicateOrReduceProvider.selectedReplicateOrReduceOptions == "Reduce")
                  ?Color(0xff141414)
                  :Colors.transparent,
              onTap: () {
                replicateOrReduceProvider.selectedReplicateOrReduceOptions = "Reduce";
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8.0),
                  child: Text(
                    "Reduce",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: (replicateOrReduceProvider.selectedReplicateOrReduceOptions == "Reduce")
                          ?Color(0xff1a94f2)
                          :Color(0xffa2b0bc),
                    ),
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget buildReplicateSection(context, screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        buildReplicateNote(context, screenWidth),

        SizedBox(
          height: 20,
        ),

        buildReplicateFieldSection(context, screenWidth),

        SizedBox(
          height: 20,
        ),

        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CustomContainer(
            backgroundColor: (themeProvider.defaultTheme)
                ?Colors.black
                :Color(0xfff0f0f0),
            borderRadius: 12,
            paddingEdge: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            padding: 0,
            onTap: () {

              if (replicateOrReduceProvider
                  .replicateUnitsTextEditingController.text ==
                  "") {
                replicateOrReduceProvider.replicateUnitesFieldErrorText =
                "Enter Replicate Units";
              } else {
                replicateOrReduceProvider.replicateUnitesFieldErrorText = "";
              }

              if (replicateOrReduceProvider
                  .replicateSellPriceTextEditingController.text ==
                  "") {
                replicateOrReduceProvider.replicateSellPriceFieldErrorText =
                "Enter Replicate Sell Price";
              } else {
                replicateOrReduceProvider.replicateSellPriceFieldErrorText = "";
              }

              if (replicateOrReduceProvider
                  .replicateUnitsTextEditingController.text !=
                  "" &&
                  replicateOrReduceProvider
                      .replicateSellPriceTextEditingController.text !=
                      "") {
                if (int.parse(replicateOrReduceProvider
                    .replicateUnitsTextEditingController.text) <=
                    0) {
                  replicateOrReduceProvider.replicateUnitesFieldErrorText =
                  "Replicate Unit can't be 0";
                } else if (int.parse(replicateOrReduceProvider
                    .replicateSellPriceTextEditingController.text) <=
                    0) {
                  replicateOrReduceProvider.replicateSellPriceFieldErrorText =
                  "Replicate Sell Price can't be 0";
                } else {
                  replicateOrReduceProvider.replicateUnitesFieldErrorText = "";
                  replicateOrReduceProvider.replicateSellPriceFieldErrorText = "";
                  replicateOrReduceProvider.replicateTrade();
                }
              }

            },
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8.0),
              child: Text(
                "Replicate",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.5,
                    color: (themeProvider.defaultTheme)
                        ?Color(0xfff0f0f0)
                        :Color(0xff1a1a25)
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildReduceSection(context, screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        buildReduceNote(context, screenWidth),

        SizedBox(
          height: 20,
        ),

        buildReduceFieldSection(context, screenWidth),

        SizedBox(
          height: 20,
        ),

        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CustomContainer(
            backgroundColor: (themeProvider.defaultTheme)
                ?Colors.black
                :Color(0xfff0f0f0),
            borderRadius: 12,
            paddingEdge: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            padding: 0,
            onTap: () {

              if (replicateOrReduceProvider.reduceUnitsTextEditingController.text ==
                  "") {
                replicateOrReduceProvider.reduceUnitesFieldErrorText =
                "Enter Replicate Units";
              } else {
                replicateOrReduceProvider.reduceUnitesFieldErrorText = "";
              }

              if (replicateOrReduceProvider
                  .reduceSellPriceTextEditingController.text ==
                  "") {
                replicateOrReduceProvider.reduceSellPriceFieldErrorText =
                "Enter Reduce Sell Price";
              } else {
                replicateOrReduceProvider.reduceSellPriceFieldErrorText = "";
              }

              if (replicateOrReduceProvider.reduceUnitsTextEditingController.text !=
                  "" &&
                  replicateOrReduceProvider
                      .reduceSellPriceTextEditingController.text !=
                      "") {
                if (int.parse(replicateOrReduceProvider
                    .reduceUnitsTextEditingController.text) <=
                    0) {
                  replicateOrReduceProvider.reduceUnitesFieldErrorText =
                  "Replicate Unit can't be 0";
                } else if (int.parse(replicateOrReduceProvider
                    .reduceSellPriceTextEditingController.text) <=
                    0) {
                  replicateOrReduceProvider.reduceSellPriceFieldErrorText =
                  "Reduce Sell Price can't be 0";
                } else {
                  replicateOrReduceProvider.reduceUnitesFieldErrorText = "";
                  replicateOrReduceProvider.reduceSellPriceFieldErrorText = "";
                  replicateOrReduceProvider.reduceTrade();
                }
              }

            },
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8.0),
              child: Text(
                "Reduce",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.5,
                    color: (themeProvider.defaultTheme)
                        ?Color(0xfff0f0f0)
                        :Color(0xff1a1a25)
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }



  Widget buildReplicateNote(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12.0, bottom: 0),
      child: CustomContainer(
        borderRadius: 10,
        // backgroundColor: Color(0xff28282a),
        backgroundColor: (themeProvider.defaultTheme)?Color(0xffdadde6):Color(0xff2c2c31),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: (themeProvider.defaultTheme)?Color(0xff141414):Color(0xfff0f0f0),
                            size: 13,
                          ),

                          SizedBox(
                            width: 5,
                          ),

                          Text(
                            'Note',
                            // "Basic Plan",
                            style: GoogleFonts.poppins(
                              color: (themeProvider.defaultTheme)?Color(0xff141414):Color(0xfff0f0f0),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 5,
                      ),

                      Container(
                        width: screenWidthRecognizer(context) * 0.8,
                        child: Text(
                          "The 'Sell Price' refers to the price at which the stocks, purchased during trade replication, will subsequently be sold.",

                          style: TextStyle(
                              color: (themeProvider.defaultTheme)?Color(0xff141414):Color(0xffa2b0bc), //Color(0xff545455),
                              fontSize: 16,
                              fontWeight: FontWeight.w400
                            // Optional: limits the text to 2 lines
                          ),
                        ),
                      )
                    ],
                  ),
                  // Icon(
                  //   CupertinoIcons.cube_box,
                  //   color: Colors.white,
                  //   size: 20,
                  // )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildReduceNote(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12.0, bottom: 0),
      child: CustomContainer(
        borderRadius: 10,
        // backgroundColor: Color(0xff28282a),
        backgroundColor: (themeProvider.defaultTheme)?Color(0xffdadde6):Color(0xff2c2c31),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: (themeProvider.defaultTheme)?Color(0xff141414):Color(0xfff0f0f0),
                            size: 13,
                          ),

                          SizedBox(
                            width: 5,
                          ),

                          Text(
                            'Note',
                            // "Basic Plan",
                            style: GoogleFonts.poppins(
                              color: (themeProvider.defaultTheme)?Color(0xff141414):Color(0xfff0f0f0),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 5,
                      ),

                      Container(
                        width: screenWidthRecognizer(context) * 0.8,
                        child: Text(
                          "The 'Sell Price' refers to the price at which the stocks would be sold for reducing trade.",

                          style: TextStyle(
                              color: (themeProvider.defaultTheme)?Color(0xff141414):Color(0xffa2b0bc), //Color(0xff545455),
                              fontSize: 16,
                              fontWeight: FontWeight.w400
                            // Optional: limits the text to 2 lines
                          ),
                        ),
                      )
                    ],
                  ),
                  // Icon(
                  //   CupertinoIcons.cube_box,
                  //   color: Colors.white,
                  //   size: 20,
                  // )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildReplicateFieldSection(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Replicate units",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xffa2b0bc)
                    ),
                  ),

                  SizedBox(
                    width: 8,
                  ),

                  SizedBox(
                    width: 23,
                    height: 23,
                    child: InfoIconDisplay().infoIconDisplay(context,
                        "Replicate Units", "Unit that you want to Replicate"),
                  )
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 32,
                    width: screenWidth * 0.3,
                    child: MyTextField(
                      isFilled: true,
                      fillColor: (themeProvider.defaultTheme)?Color(0xffDADDE6):Colors.transparent,
                      labelText: "",
                      maxLength: 14,
                      elevation: 0,
                      controller: replicateOrReduceProvider
                          .replicateUnitsTextEditingController,
                      textInputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.number,
                      textStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                      ),
                      borderColor: (themeProvider.defaultTheme)?Color(0xffDADDE6):Color(0xff2c2c31),
                      margin: EdgeInsets.zero,
                      contentPadding: EdgeInsets.only(left: 12, bottom: 5),
                      focusedBorderColor: Color(0xff5cbbff),
                      showLeadingWidget: false  ,
                      showTrailingWidget: false,

                      counterText: "",
                      borderRadius: 8,
                      hintText: '',
                      onChanged: (inputNumberOfStepsAbove) {},

                    ),
                  ),

                  (replicateOrReduceProvider.replicateUnitesFieldErrorText == "")
                      ? Container()
                      : Text(replicateOrReduceProvider.replicateUnitesFieldErrorText,
                      style: TextStyle(color: Colors.red))
                ],
              )
            ],
          ),

          SizedBox(
            height: 15,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Sell Price",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xffa2b0bc)
                    ),
                  ),

                  SizedBox(
                    width: 8,
                  ),

                  SizedBox(
                    width: 23,
                    height: 23,
                    child: InfoIconDisplay().infoIconDisplay(context,
                        "Sell Price", "Price at which you want to sell these units."),
                  )
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 32,
                    width: screenWidth * 0.3,
                    child: MyTextField(
                      isFilled: true,
                      fillColor: (themeProvider.defaultTheme)?Color(0xffDADDE6):Colors.transparent,
                      labelText: "",
                      maxLength: 14,
                      elevation: 0,
                      controller: replicateOrReduceProvider
                          .replicateSellPriceTextEditingController,
                      textInputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^[0-9,\.]+$'),
                        ),
                      ],
                      prefixText: currencyConstants.currency,
                      keyboardType: TextInputType.number,
                      textStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                      ),
                      borderColor: (themeProvider.defaultTheme)?Color(0xffDADDE6):Color(0xff2c2c31),
                      margin: EdgeInsets.zero,
                      contentPadding: EdgeInsets.only(left: 12, bottom: 5),
                      focusedBorderColor: Color(0xff5cbbff),
                      showLeadingWidget: false  ,
                      showTrailingWidget: false,

                      counterText: "",
                      borderRadius: 8,
                      hintText: '',
                      onChanged: (inputNumberOfStepsAbove) {},

                    ),
                  ),

                  (replicateOrReduceProvider.replicateSellPriceFieldErrorText == "")
                      ? Container()
                      : Text(replicateOrReduceProvider.replicateSellPriceFieldErrorText,
                      style: TextStyle(color: Colors.red))
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildReduceFieldSection(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16.0),
      child: Column(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Reduce units",
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xffa2b0bc)
                    ),
                  ),

                  SizedBox(
                    width: 8,
                  ),

                  SizedBox(
                    width: 23,
                    height: 23,
                    child: InfoIconDisplay().infoIconDisplay(context,
                        "Reduce Units", "Number of units you want to reduce."),
                  )
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 32,
                    width: screenWidth * 0.3,
                    child: MyTextField(
                      isFilled: true,
                      fillColor: (themeProvider.defaultTheme)?Color(0xffDADDE6):Colors.transparent,
                      labelText: "",
                      maxLength: 14,
                      elevation: 0,
                      controller: replicateOrReduceProvider
                          .reduceUnitsTextEditingController,
                      textInputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.number,
                      textStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                      ),
                      borderColor: (themeProvider.defaultTheme)?Color(0xffDADDE6):Color(0xff2c2c31),
                      margin: EdgeInsets.zero,
                      contentPadding: EdgeInsets.only(left: 12, bottom: 5),
                      focusedBorderColor: Color(0xff5cbbff),
                      showLeadingWidget: false  ,
                      showTrailingWidget: false,

                      counterText: "",
                      borderRadius: 8,
                      hintText: '',
                      onChanged: (inputNumberOfStepsAbove) {},

                    ),
                  ),

                  (replicateOrReduceProvider.reduceUnitesFieldErrorText == "")
                      ? Container()
                      : Text(replicateOrReduceProvider.reduceUnitesFieldErrorText,
                      style: TextStyle(color: Colors.red))
                ],
              )
            ],
          ),

          SizedBox(
            height: 15,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Sell Price",
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xffa2b0bc)
                    ),
                  ),

                  SizedBox(
                    width: 8,
                  ),

                  SizedBox(
                    width: 23,
                    height: 23,
                    child: InfoIconDisplay().infoIconDisplay(context,
                        "Sell Price", "Price at which you want to sell these units."),
                  )
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 32,
                    width: screenWidth * 0.3,
                    child: MyTextField(
                      isFilled: true,
                      fillColor: (themeProvider.defaultTheme)?Color(0xffDADDE6):Colors.transparent,
                      labelText: "",
                      maxLength: 14,
                      elevation: 0,
                      controller: replicateOrReduceProvider
                          .reduceSellPriceTextEditingController,
                      textInputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^[0-9,\.]+$'),
                        ),
                      ],
                      prefixText: currencyConstants.currency,
                      keyboardType: TextInputType.number,
                      textStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: (themeProvider.defaultTheme)?Colors.black:Color(0xfff0f0f0),
                      ),
                      borderColor: (themeProvider.defaultTheme)?Color(0xffDADDE6):Color(0xff2c2c31),
                      margin: EdgeInsets.zero,
                      contentPadding: EdgeInsets.only(left: 12, bottom: 5),
                      focusedBorderColor: Color(0xff5cbbff),
                      showLeadingWidget: false  ,
                      showTrailingWidget: false,

                      counterText: "",
                      borderRadius: 8,
                      hintText: '',
                      onChanged: (inputNumberOfStepsAbove) {},

                    ),
                  ),

                  (replicateOrReduceProvider.replicateSellPriceFieldErrorText == "")
                      ? Container()
                      : Text(replicateOrReduceProvider.replicateSellPriceFieldErrorText,
                      style: TextStyle(color: Colors.red))
                ],
              )
            ],
          ),

        ],
      ),
    );
  }
}
