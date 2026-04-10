import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../global/widgets/my_text_field.dart';
import '../../global/constants/currency_constants.dart';
import '../../global/services/num_formatting.dart';
import '../stateManagement/ladder_add_or_withdraw_cash_provider.dart';

class LadderAddOrWithdrawCashScreen extends StatelessWidget {
  LadderAddOrWithdrawCashScreen({super.key});

  late LadderAddOrWithdrawCashProvider ladderAddOrWithdrawCashProvider;
  late CurrencyConstants currencyConstantsProvider;
  late NavigationProvider navigationProvider;
  late ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    ladderAddOrWithdrawCashProvider =
        Provider.of<LadderAddOrWithdrawCashProvider>(context, listen: true);
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
                    height: MediaQuery.of(context).size.height +
                        AppBar().preferredSize.height * 1.5,
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
                                (ladderAddOrWithdrawCashProvider.isWithdraw)
                                    ? "Cash withdraw from ladder"
                                    : 'Add Cash to Ladder',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Target : ${currencyConstantsProvider.currency}${ladderAddOrWithdrawCashProvider.target}',
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Cash Already Allocated : ${amountToInrFormat(context, ladderAddOrWithdrawCashProvider.cashAlreadyAllocated)}',
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Step Size : ${currencyConstantsProvider.currency}${ladderAddOrWithdrawCashProvider.stepSize.toStringAsFixed(2)}',
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Order Size : ${ladderAddOrWithdrawCashProvider.orderSize}',
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Current Price : ${amountToInrFormat(context, ladderAddOrWithdrawCashProvider.currentPrice)}',
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Current Stock Owned : ${ladderAddOrWithdrawCashProvider.currentStockOwn}',
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Cash Needed : ${amountToInrFormat(context, ladderAddOrWithdrawCashProvider.cashNeeded)}',
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Extra Cash Generated : ${amountToInrFormat(context, ladderAddOrWithdrawCashProvider.extraCashGenerated)}',
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          buildLadderAddOrWithdrawCashFiled(context),
                          durationPicker(context),
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

  buildLadderAddOrWithdrawCashFiled(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Center(
            child: Text(
              (ladderAddOrWithdrawCashProvider.isWithdraw)
                  ? "Cash Withdraw"
                  : "Add Cash",
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyTextField(
                controller: ladderAddOrWithdrawCashProvider
                    .addOrWithdrawCashTextController,
                borderRadius: 5,
                currencyFormat: true,
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
                  ladderAddOrWithdrawCashProvider.updateCheckbox = false;

                  if (ladderAddOrWithdrawCashProvider.isWithdraw) {
                    ladderAddOrWithdrawCashProvider
                        .validateWithdrawCashToLadderPrice(context);
                  } else {
                    ladderAddOrWithdrawCashProvider
                        .validateAddCashToLadderPrice(context);
                  }
                },
                borderColor:
                    (themeProvider.defaultTheme) ? Colors.black : Colors.white,
                labelText: "Enter Cash",
                hintText: "Enter Cash",
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
                    color: (themeProvider.defaultTheme)
                        ? Colors.black
                        : Colors.white),
                keyboardType: TextInputType.number,

                validator: (value) {
                  print("inside of validator");
                  if (value!.isNotEmpty && value != "") {}
                  return null;
                },
              ),
              (ladderAddOrWithdrawCashProvider.adderAddOrWithdrawCashError ==
                      "")
                  ? Container()
                  : Text(
                      ladderAddOrWithdrawCashProvider
                          .adderAddOrWithdrawCashError,
                      style: const TextStyle(color: Colors.red),
                    ),
              SizedBox(
                height: 5,
              ),
              (ladderAddOrWithdrawCashProvider.isWithdraw)
                  ? Container()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your account balance is ${currencyConstantsProvider.currency}${ladderAddOrWithdrawCashProvider.availableCashInAccount}",
                          // "Maximum cash you can add is ${currencyConstantsProvider.currency}${ladderAddOrWithdrawCashProvider.availableCashInAccount}",
                        ),
                        Text(
                          "Minimum cash you can add is ${currencyConstantsProvider.currency}${ladderAddOrWithdrawCashProvider.minimumCashUserCanAdd(context).toStringAsFixed(2)}",
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget durationPicker(BuildContext context) {
    String title = ladderAddOrWithdrawCashProvider.isWithdraw
        ? "Select duration for selling stocks"
        : "Select duration for buying stocks";

    final List<String> durations = [
      "5 mins",
      "10 mins",
      "20 mins",
      "30 mins",
      "40 mins",
      "50 mins",
      "60 mins"
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        DropdownButton<String>(
          dropdownColor:
              (themeProvider.defaultTheme) ? Colors.white : Colors.black,
          hint: Text("Select Duration"),
          value: ladderAddOrWithdrawCashProvider.selectedDuration,
          icon: Icon(Icons.arrow_drop_down),
          onChanged: (String? newValue) {
            ladderAddOrWithdrawCashProvider.selectedDuration =
                newValue ?? "5 mins";

            // Handle selection logic here if needed
          },
          items: durations.map<DropdownMenuItem<String>>(
            (String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            },
          ).toList(),
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
                value: ladderAddOrWithdrawCashProvider.updateCheckbox,
                activeColor: Colors.blue,
                onChanged: (bool? newValue) {
                  ladderAddOrWithdrawCashProvider.updateCheckbox =
                      newValue ?? false;

                  if (ladderAddOrWithdrawCashProvider
                          .addOrWithdrawCashTextController.text ==
                      "") {
                    ladderAddOrWithdrawCashProvider
                        .adderAddOrWithdrawCashError = "Please enter price";
                  }

                  if (ladderAddOrWithdrawCashProvider.updateCheckbox) {
                    ladderAddOrWithdrawCashProvider
                        .addAndWithdrawLadderCash(context);
                  }
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
            ladderAddOrWithdrawCashProvider
                .addOrWithdrawCashTextController.text = "";
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
            if (ladderAddOrWithdrawCashProvider.updateCheckbox &&
                ladderAddOrWithdrawCashProvider.adderAddOrWithdrawCashError ==
                    "") {
              if (ladderAddOrWithdrawCashProvider.isWithdraw) {
                await ladderAddOrWithdrawCashProvider.withdrawCashToLadder();
              } else {
                await ladderAddOrWithdrawCashProvider.addCashToLadder();
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Change Accepted Successfully",
                  ),
                ),
              );
              navigationProvider.selectedIndex = 1;
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Select checkbox",
                  ),
                ),
              );
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
            Expanded(
              flex: 1,
              child: Text((ladderAddOrWithdrawCashProvider.isWithdraw)
                  ? "New Stock to sell"
                  : (ladderAddOrWithdrawCashProvider.initialBuyExecuted)
                      ? "New Stock to Buy"
                      : "New Inital Buy Quantity"),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: (ladderAddOrWithdrawCashProvider.initialBuyExecuted)
                    ? Text(ladderAddOrWithdrawCashProvider.newStockToBuy
                            .abs()
                            .toStringAsFixed(0)
                        //  "0.0",
                        )
                    : Text(
                        (ladderAddOrWithdrawCashProvider.newInitialBuyQuantity)
                            .toString()),
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
                "New Cash Needed",
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                    "${amountToInrFormat(context, ladderAddOrWithdrawCashProvider.newCashNeeded)}"
                    // "0.0",

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
                "New Extra Cash generated per trade",
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                    "${amountToInrFormat(context, ladderAddOrWithdrawCashProvider.newExtraCashGeneratedPerTrade)}"
                    // "0.0",

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
                "New Order Size",
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child:
                    Text(ladderAddOrWithdrawCashProvider.newOrderSize.toString()
                        // "-",

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
                child: Text(ladderAddOrWithdrawCashProvider.newStepSize
                        .toStringAsFixed(2)
                    // "-",

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
