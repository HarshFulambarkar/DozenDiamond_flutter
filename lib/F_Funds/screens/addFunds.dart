import 'package:dozen_diamond/DD_Navigation/stateManagement/navigation_provider.dart';
import 'package:dozen_diamond/F_Funds/screens/aboutPaperCash.dart';
import 'package:dozen_diamond/F_Funds/stateManagement/funds_provider.dart';
import 'package:dozen_diamond/Settings/stateManagement/theme_provider.dart';
import 'package:dozen_diamond/ZB_accountInfoBar/stateManagement/custom_home_app_bar_provider.dart';
import 'package:dozen_diamond/authentication/services/authentication_rest_api_service.dart';
import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../DD_Navigation/widgets/nav_drawer_new.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../create_ladder_detailed/widgets/info_icon_display.dart';
import '../../global/constants/custom_colors_light.dart';

import '../../global/services/num_formatting.dart';
import '../../DD_navigation/widgets/nav_drawer.dart';
import '../../global/widgets/3d_button.dart';
import '../models/add_funds_to_user_account_request.dart';

import '../services/funds_rest_api_service.dart';
import '../widgets/withdrawal_option.dart';

class AddFunds extends StatefulWidget {
  final Function updateIndex;
  final bool isAuthenticationPresent;
  const AddFunds(
      {super.key,
      this.isAuthenticationPresent = false,
      required this.updateIndex});

  @override
  State<AddFunds> createState() => _AddFundsState();
}

class _AddFundsState extends State<AddFunds> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  AuthenticationRestApiService _authenticationRestApiService =
      AuthenticationRestApiService();
  final GlobalKey<FormState> _paperAmount = GlobalKey<FormState>();
  FocusNode _paperAmountFocus = FocusNode();
  bool _paperAmountError = false;
  String totalCashAvailable = "0.0";
  TextEditingController paperFundsAmount = TextEditingController();
  bool showFloatingActionBtn = false;
  late FundsProvider _fundsProvider;
  late CustomHomeAppBarProvider customHomeAppBarProvider;
  CustomHomeAppBarProvider? _customHomeAppBarProvider;
  bool _isBtnClicked = false;
  ScrollController portfolioCashDetailsScrollcontroller = ScrollController();
  get unallocatedCashLeftForTrading => null;

  TextStyle fundsPageFontSize = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  TextStyle totalCashAvailableParametersFontSize = TextStyle(
    color: Colors.yellow,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  void _triggerDrawer() {
    _key.currentState!.openDrawer();
  }

  late NavigationProvider navigationProvider;
  late ThemeProvider themeProvider;
  @override
  void initState() {
    super.initState();
    _fundsProvider = Provider.of<FundsProvider>(context, listen: false);
    _fundsProvider.callInitialApi();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   _fundsProvider = Provider.of<FundsProvider>(context, listen: false);

    // });

    _paperAmountFocus.addListener(_handlePaperAmountFocus);
    paperFundsAmount.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      // Update button state based on the text field value
    });
  }

  void _handlePaperAmountFocus() {
    showFloatingActionBtn = _paperAmountFocus.hasFocus;
    _updateState();
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  Widget accountDetailsWidget() {
    _customHomeAppBarProvider =
        Provider.of<CustomHomeAppBarProvider>(context, listen: true);
    // print(
    //     'Unallocated Cash: ${_fundsProvider.accountCashDetails?.data?.accountUnallocatedCash}');
    // print(
    //     'Extra Cash Left: ${_fundsProvider.accountCashDetails?.data?.accountExtraCashLeft}');
    // print(
    //     'Cash Needed for Active Ladders: ${_fundsProvider.accountCashDetails?.data?.accountCashNeededForActiveLadders}');
    double parseAndTrim(String? value) {
      if (value == null || value.isEmpty) return 0.0;
      return double.tryParse(value.trim()) ?? 0.0;
    }

    double totalCash = parseAndTrim(
            _fundsProvider.accountCashDetails?.data?.accountUnallocatedCash) +
        parseAndTrim(
            _fundsProvider.accountCashDetails?.data?.accountExtraCashLeft) +
        parseAndTrim(_fundsProvider
            .accountCashDetails?.data?.accountCashNeededForActiveLadders);
    List<List<dynamic>> totalCashItems = [
      [
        "(a)Unallocated Cash",
        amountToInrFormat(
            context,
            double.tryParse(_fundsProvider
                    .accountCashDetails?.data?.accountUnallocatedCash ??
                "0.0")),
        _customHomeAppBarProvider?.accountInfoBarFieldVisibility
                .showUnallocatedCashLeftForTrading ??
            false,
        'showUnallocatedCashLeftForTrading',
        "Cash not yet used in any ladder; available for creating new ladders or withdrawal.",
      ],
      [
        "(b)Cash Needed for ladders",
        amountToInrFormat(
            context,
            double.tryParse(_fundsProvider.accountCashDetails?.data
                    ?.accountCashNeededForActiveLadders ??
                "0.0")),
        _customHomeAppBarProvider?.accountInfoBarFieldVisibility
                .showCashNeededForActiveLadders ??
            false,
        'showCashNeededForActiveLadders',
        "Funds reserved for upcoming buy trades in your ladders, ensuring future purchases are funded.",
      ],
      [
        "Extra cash(c)left/(d)generated",
        "${amountToInrFormat(context, double.tryParse(_fundsProvider.accountCashDetails?.data?.accountExtraCashGenerated ?? "0.0")) ?? "N/A"}/${amountToInrFormat(context, double.tryParse(_fundsProvider.accountCashDetails?.data?.accountExtraCashLeft ?? "0.0")) ?? "N/A"}",
        _customHomeAppBarProvider
                ?.accountInfoBarFieldVisibility.showExtraCash ??
            false,
        'showExtraCash',
        "Extra Cash Left: Cash generated from executed trades, available for new ladders or withdrawal. \n Extra Cash Generated: Total extra cash generated by the account to date",
      ],
    ];
    List<List<dynamic>> accountDetailsStrings = [
      [
        "Cash for new ladders(a+c)",
        amountToInrFormat(
                context,
                double.tryParse(_fundsProvider
                        .accountCashDetails?.data?.accountCashForNewLadders ??
                    "0.0")) ??
            "N/A",
        _customHomeAppBarProvider
                ?.accountInfoBarFieldVisibility.showCashForNewLadders ??
            false,
        'showCashForNewLadders',
        "Cash for New Ladder refers to the total cash in your account that can be used to create new ladders. It is the sum of Unallocated Cash, which is yet to be utilized, and Extra Cash Left from the ladders.",
      ],
      [
        "Funds in play",
        amountToInrFormat(
                context,
                double.tryParse(_fundsProvider
                        .accountCashDetails?.data?.accountFundsInPlay ??
                    "0.0")) ??
            "N/A",
        _customHomeAppBarProvider
                ?.accountInfoBarFieldVisibility.showFundsInPlay ??
            false,
        'showFundsInPlay',
        "The total amount of money currently allocated to active ladders. It represents the portion of your capital that is presently being utilized in your trading strategy."
      ]
    ];

    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      child: Scrollbar(
        controller: portfolioCashDetailsScrollcontroller,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: portfolioCashDetailsScrollcontroller,
          child: Column(
            children: [
              SizedBox(height: 15),
              for (var details in accountDetailsStrings) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 34,
                            width: 24,
                            child: Checkbox(
                              value: details[2],
                              onChanged: (bool? checked) {
                                if (checked != null) {
                                  // setState(() {
                                  // Update the respective visibility field dynamically
                                  if (details[3] ==
                                      'showUnallocatedCashLeftForTrading') {
                                    _customHomeAppBarProvider
                                            ?.accountInfoBarFieldVisibility
                                            .showUnallocatedCashLeftForTrading =
                                        checked;
                                  } else if (details[3] ==
                                      'showCashNeededForActiveLadders') {
                                    _customHomeAppBarProvider
                                            ?.accountInfoBarFieldVisibility
                                            .showCashNeededForActiveLadders =
                                        checked;
                                  } else if (details[3] == 'showExtraCash') {
                                    _customHomeAppBarProvider
                                        ?.accountInfoBarFieldVisibility
                                        .showExtraCash = checked;
                                  } else if (details[3] ==
                                      'showCashForNewLadders') {
                                    _customHomeAppBarProvider
                                        ?.accountInfoBarFieldVisibility
                                        .showCashForNewLadders = checked;
                                  } else if (details[3] == 'showFundsInPlay') {
                                    _customHomeAppBarProvider
                                        ?.accountInfoBarFieldVisibility
                                        .showFundsInPlay = checked;
                                  }
                                  _customHomeAppBarProvider!
                                      .updateAccountInfoBarFieldVisibility(
                                          _customHomeAppBarProvider!
                                              .accountInfoBarFieldVisibility);
                                  // });
                                }
                              },
                              fillColor:
                                  MaterialStateColor.resolveWith((states) {
                                return states.contains(MaterialState.selected)
                                    ? Colors.blue // Selected color
                                    : Colors
                                        .transparent; // Transparent when unselected
                              }),
                            ),
                          ),
                          SizedBox(width: 5),
                          Row(
                            children: [
                              Text(details[0], style: fundsPageFontSize),
                              SizedBox(
                                width: 27,
                                height: 27,
                                child: InfoIconDisplay().infoIconDisplay(
                                  context,
                                  details[0],
                                  details[4],
                                  color: (themeProvider.defaultTheme)
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),

                      // Expanded(
                      //   flex: 2,
                      //   child:
                      // ),
                      Text(
                        details[1],
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: 16),
                      ),
                      // Expanded(
                      //   child: ,
                      // ),
                      // SizedBox(width: 5),
                    ],
                  ),
                ),
              ],
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Cash available",
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "${amountToInrFormat(context, totalCash)}",
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  for (var details in totalCashItems) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                height: 34,
                                width: 24,
                                child: Checkbox(
                                  value: details[2],
                                  onChanged: (bool? checked) {
                                    if (checked != null) {
                                      // setState(() {
                                      // Update the respective visibility field dynamically
                                      if (details[3] ==
                                          'showUnallocatedCashLeftForTrading') {
                                        _customHomeAppBarProvider
                                                ?.accountInfoBarFieldVisibility
                                                .showUnallocatedCashLeftForTrading =
                                            checked;
                                      } else if (details[3] ==
                                          'showCashNeededForActiveLadders') {
                                        _customHomeAppBarProvider
                                                ?.accountInfoBarFieldVisibility
                                                .showCashNeededForActiveLadders =
                                            checked;
                                      } else if (details[3] ==
                                          'showExtraCash') {
                                        _customHomeAppBarProvider
                                            ?.accountInfoBarFieldVisibility
                                            .showExtraCash = checked;
                                      } else if (details[3] ==
                                          'showCashForNewLadders') {
                                        _customHomeAppBarProvider
                                            ?.accountInfoBarFieldVisibility
                                            .showCashForNewLadders = checked;
                                      } else if (details[3] ==
                                          'showFundsInPlay') {
                                        _customHomeAppBarProvider
                                            ?.accountInfoBarFieldVisibility
                                            .showFundsInPlay = checked;
                                      }
                                      _customHomeAppBarProvider!
                                          .updateAccountInfoBarFieldVisibility(
                                              _customHomeAppBarProvider!
                                                  .accountInfoBarFieldVisibility);
                                      // });
                                    }
                                  },
                                  fillColor:
                                      MaterialStateColor.resolveWith((states) {
                                    return states
                                            .contains(MaterialState.selected)
                                        ? Colors.blue // Selected color
                                        : Colors
                                            .transparent; // Transparent when unselected
                                  }),
                                ),
                              ),
                              SizedBox(width: 5),
                              Row(
                                children: [
                                  Text(details[0],
                                      style:
                                          totalCashAvailableParametersFontSize
                                              .copyWith(
                                        color: (themeProvider.defaultTheme)
                                            ? Colors.black
                                            : Colors.yellow,
                                      )),
                                  SizedBox(
                                    width: 27,
                                    height: 27,
                                    child: InfoIconDisplay().infoIconDisplay(
                                        context, details[0], details[4],
                                        color: (themeProvider.defaultTheme)
                                            ? Colors.black
                                            : Colors.white),
                                  )
                                ],
                              ),
                            ],
                          ),

                          // Expanded(
                          //   flex: 2,
                          //   child:
                          // ),
                          Text(
                            (details[1].length < 20)
                                ? details[1]
                                : details[1].toString().replaceAll("/", "\n/ "),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          // Expanded(
                          //   child: ,
                          // ),
                          // SizedBox(width: 5),
                        ],
                      ),
                    ),
                  ]
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget addWithdrawFundsBtn() {
    navigationProvider = Provider.of<NavigationProvider>(context, listen: true);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Visibility(
          visible: !showFloatingActionBtn,

          // child: threeDButton(
          //   height: 30,
          //   onTap: () {
          //     navigationProvider.selectedIndex = 1;
          //   },
          //     child: Padding(
          //       padding: const EdgeInsets.only(left: 12.0, right: 12),
          //       child: Text(
          //         "Skip adding funds",
          //         style: TextStyle(
          //             fontSize: 15,
          //             color: (themeProvider.defaultTheme)?Colors.white:Colors.white
          //         ),
          //       ),
          //     ),
          // ),

          //
          child: ElevatedButton(
            child: Text(
              "Skip adding funds",
              style: TextStyle(
                  fontSize: 15,
                  color: (themeProvider.defaultTheme)
                      ? Colors.white
                      : Colors.white),
            ),
            onPressed: () {
              navigationProvider.selectedIndex = 1;
            },
          ),
        ),
        Container(
          child: Consumer<ThemeProvider>(builder: (context, value, child) {
            return ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const WithdrawalOptionDialogBox(),
                );
              },
              style: ElevatedButton.styleFrom(
                side: BorderSide(
                    width: 1.5,
                    color:
                        value.defaultTheme ? Color(0XFF07A9e9f) : Colors.blue),
                backgroundColor:
                    value.defaultTheme ? Color(0XFF07A9e9f) : Colors.blue,
              ),
              child: Text(
                "Withdraw",
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            );
          }),
        ),
      ],
    );
  }

  Future<void> addPaperFunds() async {
    try {
      await FundsRestApiService().addFundsToUserPaperAccount(
          AddFundsToUserAccountRequest(
              amount: paperFundsAmount.text.replaceAll(',', '')));

      await Provider.of<CustomHomeAppBarProvider>(context, listen: false)
          .fetchUserAccountDetails();
      await _fundsProvider.callInitialApi();

      // await _fundsProvider!.getAccountDetail();

      _isBtnClicked = false;
      Fluttertoast.showToast(msg: "Paper cash added successfully");
      _paperAmountError = true;
      _paperAmountFocus.unfocus();
      paperFundsAmount.clear();
    } on HttpApiException catch (err) {
      print(err.errorTitle);
    }
  }

  InputDecoration textFormFieldDecoration(String hintText, bool defaultTheme) {
    return InputDecoration(
      errorMaxLines: 8,
      errorStyle: TextStyle(color: Colors.yellow, fontSize: 18),
      hintText: hintText,
      counterText: "",
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
      hintStyle: TextStyle(color: defaultTheme ? Colors.black : Colors.grey),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
        ),
      ),
      prefixIcon: Padding(
        padding: EdgeInsets.all(5.0),
        child: CurrencyIcon(
          size: 20,
          color: defaultTheme ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  String? enterAmountValid(String? value) {
    RegExp regex = RegExp(r'(\..*){2,}');
    if (_paperAmountError) {
      return null;
    }
    if (value != null || value!.isNotEmpty) {
      if (regex.hasMatch(value)) {
        return 'More than one "." not allowed';
      } else if (RegExp(r'\.').hasMatch(value) &&
          !RegExp(r'\.\d+').hasMatch(value)) {
        return "Please enter valid value";
      } else if (RegExp(r'^0+$').hasMatch(value)) {
        return "Please enter value greater than zero";
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    CurrencyConstants currencyConstantsProvider = Provider.of(context);
    customHomeAppBarProvider =
        Provider.of<CustomHomeAppBarProvider>(context, listen: true);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    customHomeAppBarProvider.getFieldVisibilityOfAccountInfoBar();
    return Scaffold(
      backgroundColor: Color(0xFF15181F),
      key: _key,
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      drawer: NavDrawerNew(updateIndex: widget.updateIndex),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                  color: (themeProvider.defaultTheme)
                      ? Color(0XFFF5F5F5)
                      : Color(0xFF15181F),
                  width: screenWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer<ThemeProvider>(builder: (context, value, child) {
                        return Card(
                          elevation: 20,
                          color: value.defaultTheme
                              ? Color(0XFF2c3e50)
                              : Color(0xFF15181F),
                          child: Padding(
                            padding: (value.defaultTheme)
                                ? EdgeInsets.only(left: 12, right: 12.0)
                                : EdgeInsets.zero,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Total cash left",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AboutPaperCash(),
                                                ));
                                          },
                                          icon: Container(
                                            width: 25,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors
                                                    .white, // Border color
                                                width: 0.75, // Border width
                                              ),
                                            ),
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              child: Icon(
                                                Icons.question_mark,
                                                size: 15,
                                                color:
                                                    Colors.black, // Icon color
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      amountToInrFormat(
                                              context,
                                              double.tryParse(_fundsProvider
                                                      .accountCashDetails
                                                      ?.data
                                                      ?.accountCashLeft ??
                                                  "0.0")) ??
                                          "N/A",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0Xff98d6e9),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      Padding(
                        padding: (themeProvider.defaultTheme)
                            ? EdgeInsets.only(top: 8, left: 5.0, right: 5)
                            : EdgeInsets.zero,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                          decoration: BoxDecoration(
                              color: (themeProvider.defaultTheme)
                                  ? Colors.transparent
                                  : Color(
                                      0xFF15181F), //Color.fromARGB(255, 23, 21, 13),
                              border: Border.all(
                                  width: 1.5,
                                  color: (themeProvider.defaultTheme)
                                      ? Colors.black
                                      : const Color.fromARGB(
                                          255, 224, 206, 206)),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: (themeProvider.defaultTheme)
                                        ? Colors.transparent
                                        : Colors.transparent.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(3),
                                    border: Border.all(
                                        width: 1.5,
                                        color: (themeProvider.defaultTheme)
                                            ? Colors.black
                                            : Colors.transparent),
                                  ),
                                  child: Consumer<ThemeProvider>(
                                      builder: (context, value, child) {
                                    return Form(
                                      key: _paperAmount,
                                      child: TextFormField(
                                        focusNode: _paperAmountFocus,
                                        maxLength: 14,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'^[0-9,\.]+$'),
                                          ),
                                          NumberToCurrencyFormatter()
                                        ],
                                        keyboardType: TextInputType.number,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller: paperFundsAmount,
                                        validator: enterAmountValid,
                                        decoration: textFormFieldDecoration(
                                            "Enter amount", value.defaultTheme),
                                        style: (value.defaultTheme)
                                            ? TextStyle(color: Colors.black)
                                            : kBodyText,
                                      ),
                                    );
                                  }),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                  child: Container(
                                child: ElevatedButton(
                                  child: Text(
                                    "Add paper cash",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  onPressed: paperFundsAmount.text == "" &&
                                          paperFundsAmount.text.isEmpty
                                      ? null
                                      : () {
                                          if (!_isBtnClicked) {
                                            _isBtnClicked = true;
                                            if (paperFundsAmount.text != "" &&
                                                paperFundsAmount
                                                    .text.isNotEmpty &&
                                                _paperAmount.currentState!
                                                    .validate()) {
                                              addPaperFunds();
                                            }
                                          }
                                        },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.disabled)) {
                                          return (themeProvider.defaultTheme)
                                              ? Colors.black
                                              : Colors
                                                  .grey; // Color for disabled state
                                        }
                                        return Colors.green; // Default color
                                      },
                                    ),
                                  ),
                                ),
                              )),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: accountDetailsWidget(),
                      ),
                      SizedBox(height: 15),
                      Expanded(child: addWithdrawFundsBtn()),
                    ],
                  ),
                ),
              ),
            ),
            CustomHomeAppBarWithProvider(
                backButton: false, leadingAction: _triggerDrawer),
          ],
        ),
      ),
    );
  }
}
