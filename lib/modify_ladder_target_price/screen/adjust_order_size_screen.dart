import 'package:dozen_diamond/Settings/stateManagement/theme_provider.dart';
import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../global/widgets/my_text_field.dart';
import '../../global/constants/currency_constants.dart';
import '../../global/services/num_formatting.dart';
import '../stateManagment/modifyLadderTargetPriceProvider.dart';

class AdjustOrderSizeScreen extends StatelessWidget {
  AdjustOrderSizeScreen({super.key});

  late ModifyLadderTargetPriceProvider modifyLadderTargetPriceProvider;
  late CurrencyConstants currencyConstantsProvider;
  late NavigationProvider navigationProvider;
  late ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    modifyLadderTargetPriceProvider =
        Provider.of<ModifyLadderTargetPriceProvider>(context, listen: true);
    navigationProvider = Provider.of<NavigationProvider>(context, listen: true);
    currencyConstantsProvider =
        Provider.of<CurrencyConstants>(context, listen: true);
    double screenWidth = screenWidthRecognizer(context);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
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
                    color: (themeProvider.defaultTheme)
                        ? Color(0XFFF5F5F5)
                        : Colors.transparent,
                    height: MediaQuery.of(context).size.height,
                    width: screenWidth,
                  ),
                ),
                Center(
                  child: Container(
                    width: screenWidth == 0 ? null : screenWidth,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Adjust Order Size',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Target : ${currencyConstantsProvider.currency}${modifyLadderTargetPriceProvider.targetPrice}',
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Cash Already Allocated : ${amountToInrFormat(context, modifyLadderTargetPriceProvider.cashAllocated)}',
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Step Size : ${currencyConstantsProvider.currency}${modifyLadderTargetPriceProvider.stepSize.toStringAsFixed(2)}',
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Order Size : ${modifyLadderTargetPriceProvider.orderSize}',
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Current Price : ${amountToInrFormat(context, modifyLadderTargetPriceProvider.currentPrice)}',
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Current Stock Owned : ${modifyLadderTargetPriceProvider.quantitiesOwned}',
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Cash Needed : ${amountToInrFormat(context, modifyLadderTargetPriceProvider.cashNeeded)}',
                          ),

                          // Text(
                          //     'Extra Cash Generated : 0.0' //${amountToInrFormat(context, ladderAddOrWithdrawCashProvider.extraCashGenerated)}',
                          // ),
                          const SizedBox(
                            height: 15,
                          ),
                          buildOrderSizeField(context),

                          SizedBox(
                            height: 30,
                          ),
                          buildCheckBoxAndSaveLadderButton(context),
                          buildBottomLabelSection(context),
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

  buildOrderSizeField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Center(
            child: Text(
              "Order Size",
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyTextField(
                controller:
                    modifyLadderTargetPriceProvider.modifiedOrderSizeController,
                borderRadius: 5,
                isFilled: true,
                elevation: 0,
                isLabelEnabled: false,
                borderWidth: 1,
                fillColor: Colors.transparent,
                contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                textInputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                // textInputFormatters: [
                //   CurrencyInputFormatter(), // Apply the custom currency formatter
                // ],
                onChanged: (value) {
                  modifyLadderTargetPriceProvider.orderSizeCheckBox = false;
                  if (modifyLadderTargetPriceProvider
                          .modifiedOrderSizeController.text !=
                      "") {
                    modifyLadderTargetPriceProvider.modifiedOrderSize =
                        int.tryParse(modifyLadderTargetPriceProvider
                                .modifiedOrderSizeController.text) ??
                            0;
                  }
                },
                borderColor:
                    (themeProvider.defaultTheme) ? Colors.black : Colors.white,
                labelText: "Enter Order Size",
                hintText: "Enter Order Size",
                maxLength: 9,
                counterText: "",
                // isLabelEnabled: false,
                overrideHintText: true,
                hintTextStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500),
                focusedBorderColor:
                    (themeProvider.defaultTheme) ? Colors.black : Colors.white,
                isPasswordField: false,

                isEnabled: true,
                // showLeadingWidget: true,
                textStyle: TextStyle(
                    fontSize: 16,
                    color: (!themeProvider.defaultTheme)
                        ? Colors.black
                        : Colors.white),
                keyboardType: TextInputType.number,

                validator: (value) {
                  print("inside of validator");
                  if (value!.isNotEmpty && value != "") {}
                  return null;
                },
              ),
              // (ladderAddOrWithdrawCashProvider.adderAddOrWithdrawCashError ==
              //     "")
              //     ? Container()
              //     : Text(
              //   ladderAddOrWithdrawCashProvider
              //       .adderAddOrWithdrawCashError,
              //   style: const TextStyle(color: Colors.red),
              // ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildCheckBoxAndSaveLadderButton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: Checkbox(
                tristate: true, // Example with tristate
                value: modifyLadderTargetPriceProvider
                    .orderSizeCheckBox, //ladderAddOrWithdrawCashProvider.updateCheckbox,
                activeColor: Colors.blue,
                side: BorderSide(
                    color: (themeProvider.defaultTheme)
                        ? Colors.black
                        : Colors.white),
                onChanged: (bool? newValue) {
                  modifyLadderTargetPriceProvider.modifyOrderSize();
                  // setState(() {
                  //   value = newValue;
                  // });
                },
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              "Note : Update value by clicking the checkbox!",
            )
          ],
        ),
        SizedBox(
          height: // (ladderAddOrWithdrawCashProvider.updateCheckbox)
              (true) ? 10 : 0,
        ),
        // (ladderAddOrWithdrawCashProvider.updateCheckbox &&
        //         ladderAddOrWithdrawCashProvider.adderAddOrWithdrawCashError ==
        //             "")
        (true)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildCancelAndGoBackButton(context),
                  buildAcceptChangeButton(context),
                ],
              )
            : Container()
      ],
    );
  }

  Widget buildCancelAndGoBackButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.red, //const Color(0xFF0099CC),
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            side: const BorderSide(
              color: Colors.red, //Color(0xFF0099CC),
            ),
          ),
          onPressed: () {
            // ladderAddOrWithdrawCashProvider
            //     .addOrWithdrawCashTextController.text = "";
            navigationProvider.selectedIndex = 1;
          },
          child: const Text('Cancel & Go back',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget buildAcceptChangeButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: const Color(0xFF0099CC),
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            side: const BorderSide(
              color: Color(0xFF0099CC),
            ),
          ),
          onPressed: () async {
            if (false) {
            } else {
              modifyLadderTargetPriceProvider
                  .modifyOrderSizeBusinessLogic(context);
            }
          },
          child: const Text('Accept Changes',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget buildBottomLabelSection(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Expanded(
              flex: 1,
              child: Text(
                "New Cash Needed",
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${amountToInrFormat(context, modifyLadderTargetPriceProvider.newCashNeeded)}",
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Expanded(
              flex: 1,
              child: Text(
                // "Total Cost Allocated",
                "New Number of Steps Above",
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${(modifyLadderTargetPriceProvider.newNumberOfStepsAbove).toStringAsFixed(2)}",
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Expanded(
              flex: 1,
              child: Text(
                // "Total Cost Allocated",
                "New Number of Steps Below",
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${(modifyLadderTargetPriceProvider.newNumberOfStepsBelow)}",
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Expanded(
              flex: 1,
              child: Text(
                "New Step Size",
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  modifyLadderTargetPriceProvider.newStepSize
                      .toStringAsFixed(2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
