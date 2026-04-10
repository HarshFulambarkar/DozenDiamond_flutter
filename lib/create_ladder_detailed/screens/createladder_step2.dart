import 'package:dozen_diamond/DD_Navigation/stateManagement/navigation_provider.dart';
import 'package:dozen_diamond/DD_Navigation/widgets/nav_drawer.dart';
import 'package:dozen_diamond/Settings/stateManagement/theme_provider.dart';
import 'package:dozen_diamond/create_ladder/screens/show_ladder_creation_option_dialog.dart';
import 'package:dozen_diamond/create_ladder_detailed/constants/terms_info_contant.dart';
import 'package:dozen_diamond/create_ladder_detailed/models/ladder_creation_parameter_values.dart';
import 'package:dozen_diamond/create_ladder_detailed/services/rest_api_service.dart';
import 'package:dozen_diamond/create_ladder_detailed/stateManagement/create_ladder_provider.dart';
import 'package:dozen_diamond/create_ladder_detailed/widgets/info_icon_display.dart';
import 'package:dozen_diamond/create_ladder_easy/stateManagement/create_ladder_easy_provider.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:dozen_diamond/global/services/num_formatting.dart';
import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:dozen_diamond/global/widgets/text_form_field_input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../DD_Navigation/widgets/nav_drawer_new.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../create_ladder/screens/show_ladder_creation_option_dialog_new.dart';
import '../../create_ladder_easy/utils/utility.dart';
import '../../global/widgets/custom_container.dart';
import '../../kyc/widgets/custom_bottom_sheets.dart';

class CreateLadder2 extends StatefulWidget {
  const CreateLadder2({super.key});

  @override
  State<CreateLadder2> createState() => _CreateLadder2State();
}

class _CreateLadder2State extends State<CreateLadder2> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  CreateLadderProvider? _stateProvider;
  ThemeProvider? _themeProvider;
  late NavigationProvider _navigationProvider;
  late CreateLadderEasyProvider createLadderEasyProvider;
  late CurrencyConstants currencyConstantsProvider;
  RestApiService restApiService = RestApiService();
  TermsInfoConstant termsInfoConstant = TermsInfoConstant();
  bool properPricingCheck = false;
  String warningMessage = "";
  Data? ladderCreationParametersValues;
  final FocusNode _focusNode = FocusNode();
  bool minimumPriceCheck = true;
  bool targetPriceCheck = true;
  bool _isBtnClicked = false;
  Color valueFieldColor = Color.fromARGB(255, 21, 24, 31);
  Color textOfValueFieldColor = Colors.white;

  late ThemeProvider themeProvider;

  void initState() {
    super.initState();
    _stateProvider = Provider.of(context, listen: false);
    _themeProvider = Provider.of(context, listen: false);
    _navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);
    // _stateProvider!.assignValueInRecommendedParameters();
    // _stateProvider!.listenLtpOfStock(context);
  }

  void _triggerDrawer() {
    _key.currentState!.openDrawer();
  }

  Widget targetPriceUI() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Target Price",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                        "Range: ${amountToInrFormat(context, _stateProvider!.initialBuyPrice * 1.2)} to ${amountToInrFormat(context, _stateProvider!.initialBuyPrice * 50)}",
                        style: TextStyle(fontSize: 12)),
                  ],
                ),
                SizedBox(
                  width: 27,
                  height: 27,
                  child: InfoIconDisplay().infoIconDisplay(
                      context,
                      termsInfoConstant.titleTarget,
                      termsInfoConstant.messageTarget,
                      color: (themeProvider.defaultTheme)
                          ? Colors.black
                          : Colors.white),
                ),
              ],
            ),
            SizedBox(
              width: 120,
              height: 30,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _stateProvider!.targetPriceController,
                      onTap: () {
                        List<String> splittedValues = doublValueSplitterBydot(
                            _stateProvider!.ladderCreationParametersScreen1
                                .clpTargetPrice!.text);
                        _stateProvider!.updateTargetPrice(
                          splittedValues[0],
                          splittedValues[1],
                          _stateProvider!.ladderCreationParametersScreen1
                              .clpTargetPrice!.text.length,
                        );
                      },
                      onChanged: (onChangeValue) {
                        List<String> splittedValues =
                            doublValueSplitterBydot(onChangeValue);
                        _stateProvider!.updateTargetPrice(
                          splittedValues[0],
                          splittedValues[1],
                          _stateProvider!
                              .targetPriceController.selection.baseOffset,
                        );
                      },
                      decoration: allocatedAmountFieldDecoration(
                          CurrencyIcon(
                              size: 18,
                              color: _themeProvider!.defaultTheme
                                  ? Colors.black
                                  : Colors.white),
                          _themeProvider!.defaultTheme),
                      keyboardType: TextInputType.number,
                      focusNode: _focusNode,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        buildTargetPriceSlider(context)
      ],
    );
  }

  Widget kFormulaUi() {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "K = ",
            style: TextStyle(fontSize: 16),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Target price', style: TextStyle(fontSize: 16)),
              SizedBox(
                height: 2,
              ),
              Container(
                width: 120,
                child: Divider(
                  color: (themeProvider.defaultTheme)
                      ? Colors.black
                      : Colors.white,
                  indent: 10,
                  thickness: 1,
                  endIndent: 10,
                  height: 1,
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Expanded(
                  flex: 3,
                  child: Container(
                      child: Text('Initial buy price',
                          style: TextStyle(fontSize: 16))))
            ],
          ),
        ],
      ),
    );
  }

  Widget targetPriceWarningUi() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Text(
        _stateProvider!.targetPriceWarning,
        style: TextStyle(color: Colors.yellow),
      ),
    );
  }

  Widget targetPriceMultiplierUi() {
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
                      Text("Target Price Multiplier (K)",
                          style: TextStyle(fontSize: 16)),
                      Text("Range: 1.2 to 50", style: TextStyle(fontSize: 12))
                    ],
                  ),
                  SizedBox(
                    width: 27,
                    height: 27,
                    child: InfoIconDisplay().infoIconDisplay(
                        context,
                        termsInfoConstant.titleMultiplier,
                        termsInfoConstant.messageMultiplier,
                        color: (themeProvider.defaultTheme)
                            ? Colors.black
                            : Colors.white),
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
                    flex: 1,
                    child: TextFormField(
                      controller:
                          _stateProvider!.targetPriceMultiplierController[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!,
                      maxLength: 6,
                      onTap: () {
                        _stateProvider!.updateTargetPriceMultiplier(
                          _stateProvider!.ladderCreationParametersScreen1
                              .targetPriceMultiplier[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!.text,
                          _stateProvider!.ladderCreationParametersScreen1
                              .targetPriceMultiplier[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!.text.length,
                        );
                      },
                      onChanged: (onChangeValue) {
                        // _stateProvider!.targetPriceMultiplierController = onChangeValue;
                        _stateProvider!.targetPriceMultiplierController[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!.value =
                            TextEditingValue(
                          text: onChangeValue,
                          selection: TextSelection.fromPosition(TextPosition(
                              offset: _stateProvider!
                                  .targetPriceMultiplierController[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!
                                  .selection
                                  .baseOffset)),
                        );
                        _stateProvider!.updateTargetPriceMultiplier(
                          onChangeValue,
                          _stateProvider!.targetPriceMultiplierController[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!
                              .selection.baseOffset,
                        );
                      },
                      decoration: allocatedAmountFieldDecoration(
                        Icon(Icons.close,
                            size: 14,
                            color: themeProvider.defaultTheme
                                ? Colors.black
                                : Colors.white),
                        themeProvider.defaultTheme,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        buildTargetPriceMultiplierSlider(context)
      ],
    );
  }

  Widget minimumPriceUi(CurrencyConstants currencyConstantsProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text("Minimum Price",
                style: TextStyle(
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)
                        ? Colors.white
                        : Colors.black)),
            SizedBox(
              width: 27,
              height: 27,
              child: InfoIconDisplay().infoIconDisplay(
                  context,
                  termsInfoConstant.titleMinimum,
                  termsInfoConstant.messageMinimum,
                  color: (themeProvider.defaultTheme)
                      ? Colors.white
                      : Colors.black),
            )
          ],
        ),
        SizedBox(
          width: 30,
        ),
        SizedBox(
          width: 120,
          height: 30,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                      color: (themeProvider.defaultTheme)
                          ? Colors.white
                          : valueFieldColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    "${currencyConstantsProvider.currency} ${_stateProvider!.minimumPrice}",
                    style: TextStyle(
                        fontSize: 16,
                        color: (themeProvider.defaultTheme)
                            ? Colors.black
                            : textOfValueFieldColor,
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

  Widget initialBuyPriceUi(CurrencyConstants currencyConstantsProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text("Initial Buy Price",
                style: TextStyle(
                    fontSize: 16,
                    color: (themeProvider.defaultTheme)
                        ? Colors.white
                        : Colors.black)),
            SizedBox(
              width: 27,
              height: 27,
              child: InfoIconDisplay().infoIconDisplay(
                  context,
                  termsInfoConstant.titleInitial,
                  termsInfoConstant.messageInitial,
                  color: (themeProvider.defaultTheme)
                      ? Colors.white
                      : Colors.black),
            )
          ],
        ),
        SizedBox(
          width: 30,
        ),
        SizedBox(
          width: 120,
          height: 30,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                      color: (themeProvider.defaultTheme)
                          ? Colors.white
                          : valueFieldColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    "${currencyConstantsProvider.currency} ${_stateProvider!.initialBuyPrice}",
                    style: TextStyle(
                        fontSize: 16,
                        color: (themeProvider.defaultTheme)
                            ? Colors.black
                            : textOfValueFieldColor,
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

  Widget minimumPriceWarningUi() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Text(
        _stateProvider!.minimumPriceWarning,
        style: TextStyle(color: Colors.yellow),
      ),
    );
  }

  Widget nextBtn() {
    return ElevatedButton(
      onPressed: () {
        print(
            "here is the value of the following ${_stateProvider!.targetPriceController.text}");
        if (_stateProvider!.targetPrice <= 0 || _stateProvider!.k <= 0) {
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
            if (_stateProvider!.minimumPriceWarning.length == 0 &&
                _stateProvider!.targetPriceWarning.length == 0) {
              _isBtnClicked = true;
              _navigationProvider.previousSelectedIndex =
                  _navigationProvider.selectedIndex;
              _navigationProvider.selectedIndex = 6;
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              //   _isBtnClicked = false;
              //   return CreateLadder3();
              // }));
            }
          }
        }
      },
      style: ElevatedButton.styleFrom(
          backgroundColor:
              (themeProvider.defaultTheme) ? Colors.green : Colors.orange),
      child: Text(
        "Select ladder Initial Buy",
        style: TextStyle(
            color: (themeProvider.defaultTheme) ? Colors.white : Colors.white),
      ),
    );
  }

  Widget backBtn() {
    return ElevatedButton(
      onPressed: () async {
        await _stateProvider!.changeCashAllocated();

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => LadderCreationOptionScreen(
        //       indexOfLadder: _stateProvider!.index,
        //       message: "Choose your ladder creation option",
        //       navigationProvider: _navigationProvider,
        //       createLadderEasyProvider: createLadderEasyProvider,
        //       value: _stateProvider, // Replace with the correct value object
        //     ),
        //   ),
        // );

        CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
            LadderCreationOptionScreenNew(
              indexOfLadder: _stateProvider!.index,
              message: "Choose your ladder creation option",
              navigationProvider: _navigationProvider,
              createLadderEasyProvider: createLadderEasyProvider,
              value: _stateProvider, // Replace with the correct value object
            ),
            context,
            // height: 500
            height: 580 // + 80
        );

        _navigationProvider.selectedIndex = 4;
      },
      style: ElevatedButton.styleFrom(
          backgroundColor:
              (themeProvider.defaultTheme) ? Colors.red : Colors.orange),
      child: Text(
        "Back",
        style: TextStyle(
            color: (themeProvider.defaultTheme) ? Colors.white : Colors.white),
      ),
    );
  }

  Widget headingUi() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Text(
          "Select Price for ${_stateProvider!.ladderCreationParametersScreen1.clpTicker} ladder",
          style: TextStyle(fontSize: 20)),
    );
  }

  Widget recommendedParameters() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Recommended Parameters",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Switch(
            value:
                //_stateProvider!.recommendedParametersNotAvailable ?
                false,
            // : _stateProvider!.isRecommendedParametersEnabledScreen1,
            onChanged: (bool value) {
              Fluttertoast.showToast(msg: "Feature Locked");
              // if (_stateProvider!.recommendedParametersNotAvailable) {
              //   print("hello in the onChanged of the switch 1");
              //   Fluttertoast.showToast(
              //       msg: "No Recommended Parameters available");
              // } else {
              //   _stateProvider!.isRecommendedParametersEnabledScreen1 = value;
              // }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    currencyConstantsProvider = Provider.of(context);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    createLadderEasyProvider =
        Provider.of<CreateLadderEasyProvider>(context, listen: true);
    return Scaffold(
        key: _key,
        drawer: const NavDrawerNew(),
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
              SingleChildScrollView(
                child: Center(
                  child: Container(
                    color: (themeProvider.defaultTheme)
                        ? Color(0XFFF5F5F5)
                        : Colors.transparent,
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
                            headingUi(),
                            Container(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin:
                                      EdgeInsets.only(left: 30.0, right: 20.0),
                                  child: Consumer<CreateLadderProvider>(
                                      builder: (context, value, child) {
                                    if (_stateProvider!
                                        .ladderCreationScreen1.isEmpty) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                    return Consumer<ThemeProvider>(
                                        builder: (context, themeValue, child) {
                                      return Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color:
                                                    (themeProvider.defaultTheme)
                                                        ? Color(0xFF0066C0)
                                                        : Colors.grey,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4.0))),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  initialBuyPriceUi(
                                                      currencyConstantsProvider),
                                                  SizedBox(height: 5),
                                                  minimumPriceUi(
                                                      currencyConstantsProvider),
                                                  SizedBox(height: 5),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          kFormulaUi(),
                                          SizedBox(height: 10),
                                          recommendedParameters(),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          targetPriceMultiplierUi(),
                                          SizedBox(height: 10),
                                          targetPriceUI(),
                                          if (_stateProvider!
                                                  .targetPriceWarning.length !=
                                              0)
                                            targetPriceWarningUi(),
                                        ],
                                      );
                                    });
                                  }),
                                ),
                              ],
                            )),
                            SizedBox(
                              height: 20,
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
                  backButton: false,
                  leadingAction: _triggerDrawer,
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
                      ? Colors.black
                      : Colors.white,
                  borderWidth: 1,
                  borderRadius: 50,
                  backgroundColor: (themeProvider.defaultTheme)
                      ? Colors.black
                      : Colors.white,
                  height: 30,
                  width: 30,
                  child: Center(
                    child: Text(
                      "1",
                      style: TextStyle(
                          color: (themeProvider.defaultTheme)
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold),
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

  Widget buildTargetPriceMultiplierSlider(BuildContext context) {
    return Slider(
      value: (_stateProvider!.targetPriceMultiplierController[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!.text == "")
          ? 2
          : (double.parse(
                      _stateProvider!.targetPriceMultiplierController[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!.text) >
                  50)
              ? 50
              : (double.parse(_stateProvider!
                          .targetPriceMultiplierController[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!.text) <
                      2)
                  ? 2
                  : double.parse(
                      _stateProvider!.targetPriceMultiplierController[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!.text),
      max: 50,
      divisions: 50 - 2,
      min: 2,
      label: _stateProvider!.targetPriceMultiplierController[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!.text,
      onChanged: (double value) {
        _stateProvider!.targetPriceMultiplierController[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!.value =
            TextEditingValue(
          text: value.toString(),
          selection: TextSelection.fromPosition(TextPosition(
              offset: _stateProvider!
                  .targetPriceMultiplierController[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!.selection.baseOffset)),
        );
        // _stateProvider!.targetPriceMultiplierController.text = value.toString();

        _stateProvider!.updateTargetPriceMultiplier(
          _stateProvider!.targetPriceMultiplierController[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!.text,
          _stateProvider!.targetPriceMultiplierController[_stateProvider!.ladderCreationParametersScreen1.clpTicker ?? ""]!.selection.baseOffset,
        );
      },
    );
  }

  Widget buildTargetPriceSlider(BuildContext context) {
    double min = _stateProvider!.initialBuyPrice * 1.2;
    double max = _stateProvider!.initialBuyPrice * 50;
    double targetPrice = double.parse(
        _stateProvider!.targetPriceController.text.replaceAll(",", ""));
    return Slider(
      value: (_stateProvider!.targetPriceController.text == "")
          ? min
          : (targetPrice > max)
              ? max
              : (targetPrice < min)
                  ? min
                  : targetPrice,
      max: max,
      divisions: int.parse((max - min).toStringAsFixed(0)),
      min: min,
      label: currencyConstantsProvider.currency +
          _stateProvider!.targetPriceController.text,
      onChanged: (double value) {
        _stateProvider!.targetPriceController.value = TextEditingValue(
          text: value.toString(),
          selection: TextSelection.fromPosition(TextPosition(
              offset:
                  _stateProvider!.targetPriceController.selection.baseOffset)),
        );

        List<String> splittedValues = doublValueSplitterBydot(value.toString());
        _stateProvider!.updateTargetPrice(
          splittedValues[0],
          splittedValues[1],
          _stateProvider!.targetPriceController.selection.baseOffset,
        );
      },
    );
  }
}
