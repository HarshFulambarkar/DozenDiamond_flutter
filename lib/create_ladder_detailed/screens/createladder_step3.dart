import 'package:dozen_diamond/DD_Navigation/stateManagement/navigation_provider.dart';
import 'package:dozen_diamond/DD_Navigation/widgets/nav_drawer.dart';
import 'package:dozen_diamond/Settings/stateManagement/theme_provider.dart';
import 'package:dozen_diamond/create_ladder_detailed/constants/terms_info_contant.dart';
import 'package:dozen_diamond/create_ladder_detailed/stateManagement/create_ladder_provider.dart';
import 'package:dozen_diamond/create_ladder_detailed/widgets/info_icon_display.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:dozen_diamond/global/services/num_formatting.dart';
import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:dozen_diamond/global/widgets/text_form_field_input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DD_Navigation/widgets/nav_drawer_new.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../global/widgets/custom_container.dart';

class CreateLadder3 extends StatefulWidget {
  const CreateLadder3({Key? key}) : super(key: key);
  @override
  State<CreateLadder3> createState() => _CreateLadder3State();
}

class _CreateLadder3State extends State<CreateLadder3> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  CreateLadderProvider? _stateProvider;
  ThemeProvider? _themeProvider;
  late NavigationProvider _navigationProvider;
  late ThemeProvider themeProvider;
  bool cashLessWarning = false;
  final FocusNode _focusNode = FocusNode();
  final FocusNode _initialBuyQtyFocus = FocusNode();
  TermsInfoConstant termsInfoConstant = TermsInfoConstant();
  bool _isBtnClicked = false;
  Color valueFieldColor = Color.fromARGB(255, 21, 24, 31);
  Color textOfValueFieldColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _stateProvider = Provider.of(context, listen: false);
    _themeProvider = Provider.of(context, listen: false);
    _navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);
    _initialBuyQtyFocus.addListener(() {
      if (!_initialBuyQtyFocus.hasFocus) {
        _stateProvider!.resetIbqToEstInitialBuyCashQty();
      }
    });
  }

  void _triggerDrawer() {
    _key.currentState!.openDrawer();
  }

  Widget initialBuyQtyUi() {
    // Print each single element first
    double initialBuyCash = double.tryParse(_stateProvider!
            .ladderCreationParametersScreen2.initialBuyCash!.text
            .replaceAll(",", "")) ??
        0.0;
    double initialBuyPrice = _stateProvider!.initialBuyPrice;

// Calculate the result without flooring
    double result = initialBuyCash / initialBuyPrice;

// Print the result with two decimal places
//     print("Result: ${result.toStringAsFixed(2)}");
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Buy Qty", style: TextStyle(fontSize: 16)),
                      Text("Max Range: ${(result).floor()}",
                          style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  SizedBox(
                    width: 27,
                    height: 27,
                    child: InfoIconDisplay().infoIconDisplay(
                        context,
                        termsInfoConstant.titleBuyQty,
                        termsInfoConstant.messageBuyQty,
                        color: (themeProvider.defaultTheme)
                            ?Colors.black:Colors.white,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 80,
              height: 30,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _stateProvider!.initialBuyQtyController,
                      onChanged: (inputInitialBuyQty) {
                        _stateProvider!.updateInitialBuyQuantity(
                          inputInitialBuyQty.replaceAll(',', ''),
                          _stateProvider!
                              .initialBuyQtyController.selection.baseOffset,
                        );
                      },
                      focusNode: _initialBuyQtyFocus,
                      decoration: allocatedAmountFieldDecoration(
                          null, _themeProvider!.defaultTheme),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        buildBuyQtySlider(context),
      ],
    );
  }

  Widget initialBuyQtyWarning() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Text(
        _stateProvider!.initialBuyQtyWarning,
        style: TextStyle(color: Colors.yellow),
      ),
    );
  }

  Widget cashAllocatedUi(CurrencyConstants currencyConstantsProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text("Cash Assigned",
                style: TextStyle(
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)?Colors.white:Colors.black
                )),
            SizedBox(
              width: 27,
              height: 27,
              child: InfoIconDisplay().infoIconDisplay(
                  context,
                  termsInfoConstant.titleCashAllocated,
                  termsInfoConstant.messageCashAllocated,
                  color: (themeProvider.defaultTheme)?Colors.white:Colors.black),
            )
          ],
        ),
        SizedBox(
          width: 140,
          height: 30,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                      color: (themeProvider.defaultTheme)?Colors.white:valueFieldColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    "${currencyConstantsProvider.currency} ${amountToInrFormatCLP(double.tryParse(_stateProvider!.ladderCreationParametersScreen2.clpCashAllocated!.text.isNotEmpty ? _stateProvider!.ladderCreationParametersScreen2.clpCashAllocated!.text.replaceAll(",", "") : "2.0") ?? 1.0, decimalDigit: 2)}",
                    style: TextStyle(
                        fontSize: 16,
                        color: (themeProvider.defaultTheme)?Colors.black:textOfValueFieldColor,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
        //   child: TextFormField(
        //     controller: _stateProvider!.cashAllocatedController,
        //     onTap: () {
        //       List<String> splittedValues = doublValueSplitterBydot(
        //           _stateProvider!
        //               .ladderCreationParametersScreen2.clpCashAllocated!.text);
        //       _stateProvider!.updateCashAllocated(
        //         splittedValues[0],
        //         splittedValues[1],
        //         _stateProvider!.ladderCreationParametersScreen2
        //             .clpCashAllocated!.text.length,
        //       );
        //     },
        //     onChanged: (inputCashAllocated) {
        //       List<String> splittedValues =
        //           doublValueSplitterBydot(inputCashAllocated);

        //       _stateProvider!.updateCashAllocated(
        //         splittedValues[0],
        //         splittedValues[1],
        //         _stateProvider!.cashAllocatedController.selection.baseOffset,
        //       );
        //     },
        //     decoration: allocatedAmountFieldDecoration(
        //         CurrencyIcon(
        //           size: 18,
        //           color: _themeProvider!.defaultTheme
        //               ? Colors.black
        //               : Colors.white,
        //         ),
        //         _themeProvider!.defaultTheme),
        //     keyboardType: TextInputType.number,
        //     focusNode: _focusNode,
        //   ),
        // ),
      ],
    );
  }

  Widget estInitialBuyCashUi(CurrencyConstants currencyConstantsProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text("Est. initial buy cash",
                style: TextStyle(
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)?Colors.white:Colors.black)),
            SizedBox(
              width: 27,
              height: 27,
              child: InfoIconDisplay().infoIconDisplay(
                  context,
                  termsInfoConstant.titleCashAllocated,
                  termsInfoConstant.messageCashAllocated,
                  color: (themeProvider.defaultTheme)?Colors.white:Colors.black),
            )
          ],
        ),
        SizedBox(
          width: 140,
          height: 30,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                      color: (themeProvider.defaultTheme)?Colors.white:valueFieldColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    "${currencyConstantsProvider.currency} ${amountToInrFormatCLP(_stateProvider!.estInitialBuyCash, decimalDigit: 2)} ",
                    style: TextStyle(
                        fontSize: 16,
                        color: (themeProvider.defaultTheme)?Colors.black:textOfValueFieldColor,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget actualInitialBuyCashUi(CurrencyConstants currencyConstantsProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text("Actual initial buy cash",
                style: TextStyle(fontSize: 16,
                    color: (themeProvider.defaultTheme)?Colors.white:Colors.black
                )),
            SizedBox(
              width: 27,
              height: 27,
              child: InfoIconDisplay().infoIconDisplay(
                  context,
                  termsInfoConstant.titleCashAllocated,
                  termsInfoConstant.messageCashAllocated,
                  color: (themeProvider.defaultTheme)?Colors.white:Colors.black),
            )
          ],
        ),
        SizedBox(
          width: 140,
          height: 30,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                      color: (themeProvider.defaultTheme)?Colors.white:valueFieldColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    "${currencyConstantsProvider.currency} ${amountToInrFormatCLP(_stateProvider!.actualInitialBuyCash, decimalDigit: 2)}",
                    style: TextStyle(
                        fontSize: 16,
                        color: (themeProvider.defaultTheme)?Colors.black:textOfValueFieldColor,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget cashAllocatedWarningUi() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Text(
        _stateProvider!.cashAllocatedWarning,
        style: TextStyle(color: Colors.yellow),
      ),
    );
  }

  Widget actualInitialBuyCashWarningUi() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Text(
        "N/A",
        style: TextStyle(color: Colors.yellow),
      ),
    );
  }

  Widget estInitialBuyCashWarningUi() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Text(
        "N/A",
        style: TextStyle(color: Colors.yellow),
      ),
    );
  }

  Widget estInitialBuyCashFormulaUi() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text(
                "Initial buy cash ",
                style: TextStyle(
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)?Colors.white:Colors.black,
                ),
              ),
            ),
            Text(
              "=",
              style: TextStyle(
                  fontSize: 16,
                color: (themeProvider.defaultTheme)?Colors.white:Colors.black,
              ),
            ),
            Column(
              children: [
                Text(' Cash allocated', style: TextStyle(
                    fontSize: 16,
                  color: (themeProvider.defaultTheme)?Colors.white:Colors.black,
                )),
              ],
            ),
            Text(
              ' x ',
              style: TextStyle(
                  fontSize: 16,
                color: (themeProvider.defaultTheme)?Colors.white:Colors.black,
              ),
            ),
            Row(
              children: [
                Text(
                  '(',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w100,
                    color: (themeProvider.defaultTheme)?Colors.white:Colors.black,
                  ),
                ),
                Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '2 x K - 2',
                      style: TextStyle(
                          fontSize: 16,
                        color: (themeProvider.defaultTheme)?Colors.white:Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Container(
                      width: 80,
                      child: Divider(
                        color: (themeProvider.defaultTheme)
                            ?Colors.white:Colors.black,
                        indent: 10,
                        thickness: 1,
                        endIndent: 10,
                        height: 1,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      '2 x K - 1',
                      style: TextStyle(
                          fontSize: 16,
                        color: (themeProvider.defaultTheme)?Colors.white:Colors.black,
                      ),
                    ),
                  ],
                ),
                Text(
                  ')',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w100,
                    color: (themeProvider.defaultTheme)?Colors.white:Colors.black,
                  ),
                ),
              ],
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "K",
              style: TextStyle(
                  fontSize: 16,
                color: (themeProvider.defaultTheme)?Colors.white:Colors.black,
              ),
            ),
            Text(
              " = ",
              style: TextStyle(
                  fontSize: 16,
                color: (themeProvider.defaultTheme)?Colors.white:Colors.black,
              ),
            ),
            Text(
              "${amountToInrFormatCLP(_stateProvider!.targetPrice / _stateProvider!.initialBuyPrice, decimalDigit: 2)}",
              style: TextStyle(
                  fontSize: 16,
                color: (themeProvider.defaultTheme)?Colors.white:Colors.black,
              ),
            ),
            SizedBox(
              width: 35,
            ),
            Text(
              '(',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w100,
                color: (themeProvider.defaultTheme)?Colors.white:Colors.black,
              ),
            ),
            SizedBox(
              width: 7,
            ),
            Text(
              "K",
              style: TextStyle(
                  fontSize: 16,
                color: (themeProvider.defaultTheme)?Colors.white:Colors.black,
              ),
            ),
            Text(
              " = ",
              style: TextStyle(
                  fontSize: 16,
                color: (themeProvider.defaultTheme)?Colors.white:Colors.black,
              ),
            ),
            Column(
              children: [
                Text('Target price', style: TextStyle(
                    fontSize: 16,
                  color: (themeProvider.defaultTheme)?Colors.white:Colors.black,
                )),
                SizedBox(
                  height: 2,
                ),
                Container(
                  width: 120,
                  child: Divider(
                    color: (themeProvider.defaultTheme)
                        ?Colors.white:Colors.black,
                    indent: 10,
                    thickness: 1,
                    endIndent: 10,
                    height: 1,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Text('Initial buy price', style: TextStyle(
                    fontSize: 16,
                  color: (themeProvider.defaultTheme)?Colors.white:Colors.black,
                ))
              ],
            ),
            Text(
              ')',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w100,
                color: (themeProvider.defaultTheme)?Colors.white:Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget initialBuyQtyformulaUi(CurrencyConstants currencyConstantsProvider) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Buy Qty",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              " = ",
              style: TextStyle(fontSize: 16),
            ),
            Row(
              children: [
                Text(
                  "FLOOR ",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '(',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w100),
                ),
                Column(
                  children: [
                    Text('Initial buy cash', style: TextStyle(fontSize: 16)),
                    SizedBox(
                      height: 2,
                    ),
                    Container(
                      width: 120,
                      child: Divider(
                        color: (themeProvider.defaultTheme)
                            ?Colors.black:Colors.white,
                        indent: 10,
                        thickness: 1,
                        endIndent: 10,
                        height: 1,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text('Initial buy price', style: TextStyle(fontSize: 16))
                  ],
                ),
                Text(
                  ')',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w100),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget formulaCheckBox(bool forQuantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Show Formula',
          style: TextStyle(fontSize: 12,
              color: (themeProvider.defaultTheme)
                  ?Colors.black:Colors.yellow
          ),
        ),
        SizedBox(
          width: 25,
          height: 30,
          child: Checkbox(
            value: forQuantity
                ? _stateProvider!.displayFormulaOfInitialBuyQuantity
                : _stateProvider!.displayFormulaOfInitialBuyCash,
            onChanged: (bool? value) {
              forQuantity
                  ? _stateProvider!.displayFormulaOfInitialBuyQuantity =
                      value ?? false
                  : _stateProvider!.displayFormulaOfInitialBuyCash =
                      value ?? false;
            },
            side: BorderSide(
              color: (themeProvider.defaultTheme)
                  ?Colors.black:Colors.white, // White outline
              width: 2, // You can adjust the width if needed
            ),
          ),
        ),
      ],
    );
  }

  Widget initialBuyPriceUi(CurrencyConstants currencyConstantsProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Initial buy price:",
          style: TextStyle(fontSize: 16),
        ),
        Text(
          "${currencyConstantsProvider.currency} ${_stateProvider!.initialBuyPrice}",
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget backBtn() {
    return ElevatedButton(
      onPressed: () {
        _navigationProvider.selectedIndex = 5;
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: (themeProvider.defaultTheme)?Colors.red:Colors.orange
      ),
      child: Text("Back",
        style: TextStyle(
            color: (themeProvider.defaultTheme)?Colors.white:Colors.white
        ),
      ),
    );
  }

  Widget nextBtn() {
    return ElevatedButton(
        onPressed: () {
          double initialBuyQty = 0;
          if (_stateProvider!.initialBuyQtyController.text != "") {
            initialBuyQty = double.parse(_stateProvider!
                .initialBuyQtyController.text
                .replaceAll(",", "")
                .replaceAll(" ", ""));
          }

          if (_stateProvider!.actualInitialBuyCash <= 0 || initialBuyQty <= 0) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return warningMessageDialog(
                    "Cash Allocated is not enough for creating a ladder please add more cash",
                    context);
              },
            );
          } else {
            if (!_isBtnClicked) {
              print("inside _isBtnClicked");
              print(_stateProvider!.cashAllocatedWarning.length);
              print(_stateProvider!.initialBuyQtyWarning.length);
              if (_stateProvider!.cashAllocatedWarning.length == 0 &&
                  _stateProvider!.initialBuyQtyWarning.length == 0) {
                _isBtnClicked = true;
                _stateProvider!.updateInitialBuyQuantityEvenly();
                _stateProvider!.calculateOptimalParameters();
                // _stateProvider!.updateLimitCashNeeded(false);
                // _stateProvider!.updateCeilingBuySellQtyBool = true;
                _navigationProvider.selectedIndex = 7;
                // Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
                //   _isBtnClicked = false;
                //   _stateProvider!.updateLimitCashNeeded(false);
                //   return CreateLadder4();
                // })));
              }
            }
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: (themeProvider.defaultTheme)?Colors.green:Colors.orange
        ),
        child: Text(
            "Select ladder Step Size",
          style: TextStyle(
              color: (themeProvider.defaultTheme)?Colors.white:Colors.white
          ),
        ));
  }

  Widget heading() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
              "Select initial buy for ${_stateProvider!.ladderCreationParametersScreen1.clpTicker} ladder",
              style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    CurrencyConstants currencyConstantsProvider = Provider.of(context);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    _stateProvider = Provider.of<CreateLadderProvider>(context, listen: true);
    return Scaffold(
        key: _key,
        drawer: const NavDrawerNew(),
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Container(
                  color: (themeProvider.defaultTheme)?Color(0XFFF5F5F5):Colors.transparent,
                  height: MediaQuery.of(context).size.height,
                  width: screenWidth,
                ),
              ),
              SingleChildScrollView(
                child: Center(
                  child: Container(
                    color: (themeProvider.defaultTheme)?Color(0XFFF5F5F5):Colors.transparent,
                    width: screenWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: AppBar().preferredSize.height * 1.2,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            heading(),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 30.0, right: 20.0),
                                    child: Consumer<CreateLadderProvider>(
                                      builder: (context, value, child) {
                                        return _stateProvider!
                                                .ladderCreationScreen2.isEmpty
                                            ? CircularProgressIndicator()
                                            : Consumer<ThemeProvider>(builder:
                                                (context, themeValue, child) {
                                                return Column(
                                                  children: [
                                                    initialBuyPriceUi(
                                                        currencyConstantsProvider),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: (themeProvider.defaultTheme)
                                                              ?Color(0xFF0066C0):Colors.grey,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          4.0))),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Column(
                                                          children: [
                                                            cashAllocatedUi(
                                                                currencyConstantsProvider),
                                                            if (_stateProvider!
                                                                    .cashAllocatedWarning
                                                                    .length !=
                                                                0)
                                                              cashAllocatedWarningUi(),
                                                            SizedBox(height: 10),
                                                            estInitialBuyCashUi(
                                                                currencyConstantsProvider),
                                                            SizedBox(height: 2),
                                                            formulaCheckBox(
                                                                false),
                                                            _stateProvider!
                                                                    .displayFormulaOfInitialBuyCash
                                                                ? Column(
                                                                    children: [
                                                                      estInitialBuyCashFormulaUi(),
                                                                      SizedBox(
                                                                          height:
                                                                              2),
                                                                      SizedBox(
                                                                          height:
                                                                              5),
                                                                    ],
                                                                  )
                                                                : Container(),
                                                            SizedBox(height: 2),
                                                            actualInitialBuyCashUi(
                                                                currencyConstantsProvider),
                                                            SizedBox(height: 5),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    initialBuyQtyUi(),
                                                    if (_stateProvider!
                                                            .initialBuyQtyWarning
                                                            .length !=
                                                        0)
                                                      initialBuyQtyWarning(),
                                                    formulaCheckBox(true),
                                                    SizedBox(height: 2),
                                                    _stateProvider!
                                                            .displayFormulaOfInitialBuyQuantity
                                                        ? initialBuyQtyformulaUi(
                                                            currencyConstantsProvider)
                                                        : Container(),
                                                  ],
                                                );
                                              });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [backBtn(), nextBtn()],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              buildPageNumberCircle(context, screenWidth),
              CustomHomeAppBarWithProvider(
                  backButton: true,
                  widthOfWidget:
                      screenWidth //these leadingAction button is not working, I have tired making it work, but it isn't.
                  ),
            ],
          ),
        ));
  }

  Widget buildPageNumberCircle(BuildContext context, screenWidth) {
    return Center(
      child: Container(
        width: screenWidth,
        child: Column(
          children: [
            SizedBox(
              height: AppBar().preferredSize.height * 1.2,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomContainer(
                  borderColor: (themeProvider.defaultTheme)
                      ?Colors.black:Colors.white,
                  borderWidth: 1,
                  borderRadius: 50,
                  backgroundColor: (themeProvider.defaultTheme)
                      ?Colors.black:Colors.white,
                  height: 30,
                  width: 30,
                  child: Center(
                    child: Text(
                      "2",
                      style: TextStyle(
                          color: (themeProvider.defaultTheme)
                              ?Colors.white:Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget warningMessageDialog(String msg, BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 10,
              left: 20,
              right: 20,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(
                10,
              ),
              border: Border.all(
                color: Colors.white,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Warning",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.yellow,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  msg,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                      width: 80,
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Ok",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBuyQtySlider(BuildContext context) {
    double initialBuyCash = double.tryParse(_stateProvider!
            .ladderCreationParametersScreen2.initialBuyCash!.text
            .replaceAll(",", "")) ??
        0.0;
    double initialBuyPrice = _stateProvider!.initialBuyPrice;

// Calculate the result without flooring
    double result = (initialBuyPrice != 0) ? initialBuyCash / initialBuyPrice : 0.0;

    double min = 1;
    double max = result.floor().toDouble();
    double targetPrice = double.parse(
        _stateProvider!.initialBuyQtyController.text.replaceAll(",", ""));
        // _stateProvider!.ladderCreationParametersScreen2.clpInitialBuyQuantity!.text.replaceAll(",", ""));
    if(targetPrice == 0) {
      targetPrice = 1;
    }

    // print("below are values of buildBuyQtySlider");
    // print(targetPrice);
    // print((targetPrice > max));
    // print((targetPrice < min));
    // print("lllllllll");
    // print((_stateProvider!.initialBuyQtyController.text.isEmpty));
    // print(min);
    // print(max);
    // print('targetPrice');
    // print(targetPrice);
    // print(result);
    return Slider(
      value: (_stateProvider!.initialBuyQtyController.text.isEmpty)
          ? min
          : (targetPrice > max)
              ? max
              : (targetPrice < min)
                  ? min
                  : targetPrice,
      max: max <= 1 ? 2 : max,
      divisions:
          ((max - min) <= 0) ? 1 : int.parse((max - min).toStringAsFixed(0)),
      min: min,
      label: _stateProvider!.initialBuyQtyController.text,
      onChanged: (double value) {
        print("inside on change");
        print(value);
        _stateProvider!.initialBuyQtyController.value = TextEditingValue(
          text: value.toString(),
          selection: TextSelection.fromPosition(TextPosition(
              offset: _stateProvider!
                  .initialBuyQtyController.selection.baseOffset)),
        );

        _stateProvider!.ladderCreationParametersScreen2.clpInitialBuyQuantity!.value = TextEditingValue(
          text: value.toString(),
          selection: TextSelection.fromPosition(TextPosition(
              offset: _stateProvider!
                  .initialBuyQtyController.selection.baseOffset)),
        );

        print("below is value of initialBuyQtyController");
        print(_stateProvider!.initialBuyQtyController.text);



        _stateProvider!.updateInitialBuyQuantity(
          _stateProvider!.initialBuyQtyController.text.replaceAll(',', ''),
          _stateProvider!.initialBuyQtyController.selection.baseOffset,
        );
      },
    );
  }
}
