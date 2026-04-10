import 'package:dozen_diamond/global/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../global/constants/currency_constants.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/widgets/info_icon_display.dart';
import '../../global/widgets/my_text_field.dart';
import '../../global/widgets/text_form_field_input_decoration.dart';
import '../stateManagement/replicate_or_reduce_provider.dart';

class ReplicateOrReduceScreen extends StatelessWidget {
  late NavigationProvider navigationProvider;
  late CurrencyConstants currencyConstantsProvider;
  late ReplicateOrReduceProvider replicateOrReduceProvider;
  late ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    navigationProvider = Provider.of<NavigationProvider>(context, listen: true);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    currencyConstantsProvider =
        Provider.of<CurrencyConstants>(context, listen: true);
    replicateOrReduceProvider =
        Provider.of<ReplicateOrReduceProvider>(context, listen: true);
    double screenWidth = screenWidthRecognizer(context);
    return WillPopScope(
      onWillPop: () async {
        navigationProvider.selectedIndex =
            navigationProvider.previousSelectedIndex;

        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Center(
                  child: Container(
                    width: screenWidth == 0 ? null : screenWidth,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 45,
                          ),
                          // SizedBox(
                          //   height: AppBar().preferredSize.height * 1.5,
                          // ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      replicateOrReduceProvider
                                              .selectedReplicateOrReduceOptions =
                                          "Replicate";
                                    },
                                    child: CustomContainer(
                                        borderRadius: 8,
                                        height: 60,
                                        backgroundColor: (replicateOrReduceProvider
                                                    .selectedReplicateOrReduceOptions ==
                                                "Replicate")
                                            ? Color(0xff23a42e)
                                            : Colors.black,
                                        child: Center(
                                          child: Text("Replicate",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500)),
                                        )),
                                  ),
                                ),
                                SizedBox(width: 30),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      replicateOrReduceProvider
                                              .selectedReplicateOrReduceOptions =
                                          "Reduce";
                                    },
                                    child: CustomContainer(
                                        borderRadius: 8,
                                        height: 60,
                                        backgroundColor: (replicateOrReduceProvider
                                                    .selectedReplicateOrReduceOptions ==
                                                "Reduce")
                                            ? Color.fromARGB(255, 193, 84, 34)
                                            : Colors.black,
                                        child: Center(
                                          child: Text("Reduce",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500)),
                                        )),
                                  ),
                                )
                              ]),
                          SizedBox(height: 20),
                          (replicateOrReduceProvider
                                      .selectedReplicateOrReduceOptions ==
                                  "Reduce")
                              ? buildReduceSection(context)
                              : buildReplicateSection(context),
                        ],
                      ),
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
          ),
        ),
      ),
    );
  }

  Widget buildReplicateSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5),
      child: Column(children: [
        buildReplicateTradeNoteSection(context),
        SizedBox(height: 20),
        buildReplicateUnitField(context),
        SizedBox(height: 10),
        buildReplicateSellPriceField(context),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            goBackButton(context),
            SizedBox(
              width: 40,
            ),
            buildReplicateButton(context),
          ],
        ),
      ]),
    );
  }

  Widget buildReduceSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5.0),
      child: Column(children: [
        buildReduceTradeNoteSection(context),
        SizedBox(height: 20),
        buildReduceUnitField(context),
        SizedBox(height: 10),
        buildReduceSellPriceField(context),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            goBackButton(context),
            SizedBox(
              width: 40,
            ),
            buildReduceButton(context),
          ],
        ),
      ]),
    );
  }

  Widget goBackButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          navigationProvider.selectedIndex = 1;
        },
        child: Text("Go back"),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.red),
        ));
  }

  Widget buildReplicateUnitField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text("Replicate Units", style: TextStyle(fontSize: 16)),
                SizedBox(
                  width: 27,
                  height: 27,
                  child: InfoIconDisplay().infoIconDisplay(context,
                      "Replicate Units", "Unit that you want to Replicate"),
                )
              ],
            ),
            SizedBox(
              width: 140,
              height: 40,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      controller: replicateOrReduceProvider
                          .replicateUnitsTextEditingController,
                      onChanged: (inputNumberOfStepsAbove) {},
                      decoration: allocatedAmountFieldDecoration(
                              null, themeProvider.defaultTheme)
                          .copyWith(
                              // labelText: "0",
                              hintText: "0",
                              hintStyle: TextStyle(
                                color: Colors.white,
                              )),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        (replicateOrReduceProvider.replicateUnitesFieldErrorText == "")
            ? Container()
            : Text(replicateOrReduceProvider.replicateUnitesFieldErrorText,
                style: TextStyle(color: Colors.red))
      ],
    );
  }

  Widget buildReplicateSellPriceField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text("Sell Price", style: TextStyle(fontSize: 16)),
                SizedBox(
                  width: 27,
                  height: 27,
                  child: InfoIconDisplay().infoIconDisplay(context,
                      "Sell Price", "Price at which you want to sell these units."),
                )
              ],
            ),
            SizedBox(
              width: 140,
              height: 40,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      controller: replicateOrReduceProvider
                          .replicateSellPriceTextEditingController,
                      onTap: () {},
                      onChanged: (onChangeValue) {},
                      decoration: allocatedAmountFieldDecoration(
                              CurrencyIcon(
                                  size: 18,
                                  color: themeProvider.defaultTheme
                                      ? Colors.black
                                      : Colors.white),
                              themeProvider.defaultTheme)
                          .copyWith(
                              // labelText: "0",
                              hintText: "0",
                              hintStyle: TextStyle(
                                color: Colors.white,
                              )),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        (replicateOrReduceProvider.replicateSellPriceFieldErrorText == "")
            ? Container()
            : Text(replicateOrReduceProvider.replicateSellPriceFieldErrorText,
                style: TextStyle(color: Colors.red))
      ],
    );
  }

  Widget buildReplicateButton(BuildContext context) {
    return ElevatedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        side: const BorderSide(
          color: Colors.blue,
        ),
      ),
      onPressed: () {
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
      child: const Text('Replicate',
          textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
    );
  }

  Widget buildReduceUnitField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text("Reduce Units", style: TextStyle(fontSize: 16)),
                SizedBox(
                  width: 27,
                  height: 27,
                  child: InfoIconDisplay().infoIconDisplay(context,
                      "Reduce Units", "Number of units you want to reduce."),
                )
              ],
            ),
            SizedBox(
              width: 140,
              height: 40,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      controller: replicateOrReduceProvider
                          .reduceUnitsTextEditingController,
                      onChanged: (inputNumberOfStepsAbove) {},
                      decoration: allocatedAmountFieldDecoration(
                              null, themeProvider.defaultTheme)
                          .copyWith(
                              // labelText: "0",
                              hintText: "0",
                              hintStyle: TextStyle(
                                color: Colors.white,
                              )),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        (replicateOrReduceProvider.reduceUnitesFieldErrorText == "")
            ? Container()
            : Text(replicateOrReduceProvider.reduceUnitesFieldErrorText,
                style: TextStyle(color: Colors.red))
      ],
    );
  }

  Widget buildReduceSellPriceField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text("Sell Price", style: TextStyle(fontSize: 16)),
                SizedBox(
                  width: 27,
                  height: 27,
                  child: InfoIconDisplay().infoIconDisplay(context,
                      "Sell Price", "Price at which you want to sell these units."),
                )
              ],
            ),
            SizedBox(
              width: 140,
              height: 40,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      controller: replicateOrReduceProvider
                          .reduceSellPriceTextEditingController,
                      onTap: () {},
                      onChanged: (onChangeValue) {},
                      decoration: allocatedAmountFieldDecoration(
                              CurrencyIcon(
                                  size: 18,
                                  color: themeProvider.defaultTheme
                                      ? Colors.black
                                      : Colors.white),
                              themeProvider.defaultTheme)
                          .copyWith(
                              // labelText: "0",
                              hintText: "0",
                              hintStyle: TextStyle(
                                color: Colors.white,
                              )),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        (replicateOrReduceProvider.reduceSellPriceFieldErrorText == "")
            ? Container()
            : Text(replicateOrReduceProvider.replicateSellPriceFieldErrorText,
                style: TextStyle(color: Colors.red))
      ],
    );
  }

  Widget buildReduceButton(BuildContext context) {
    return ElevatedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        side: const BorderSide(
          color: Colors.blue,
        ),
      ),
      onPressed: () {
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
      child: const Text('Reduce',
          textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
    );
  }

  Widget buildReplicateTradeNoteSection(BuildContext context) {
    return CustomContainer(
        padding: 0,
        margin: EdgeInsets.zero,
        paddingEdge: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        borderColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              "Note: The 'Sell Price' refers to the price at which the stocks, purchased during trade replication, will subsequently be sold.",
              style: TextStyle(color: Colors.white)),
        ));
  }

  Widget buildReduceTradeNoteSection(BuildContext context) {
    return CustomContainer(
        padding: 0,
        margin: EdgeInsets.zero,
        paddingEdge: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        borderColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              "Note: The 'Sell Price' refers to the price at which the stocks would be sold for reducing trade.",
              style: TextStyle(color: Colors.white)),
        ));
  }
}
