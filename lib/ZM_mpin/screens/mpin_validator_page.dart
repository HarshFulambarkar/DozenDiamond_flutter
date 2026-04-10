import 'dart:io';

import 'package:dozen_diamond/DD_Navigation/widgets/common_screen.dart';
import 'package:dozen_diamond/global/constants/data_string.dart';
import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:dozen_diamond/global/services/auth_service.dart';
import 'package:dozen_diamond/global/widgets/error_dialog.dart';
import 'package:dozen_diamond/socket_manager/stateManagement/web_socket_service_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:dozen_diamond/navigateAuthentication/stateManagement/navigate_authentication_provider.dart';

import '../../global/functions/helper.dart';
import '../../global/models/http_api_exception.dart';
import '../../global/services/socket_manager.dart';

import '../../ZM_mpin/models/get_validate_mpin_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../global/services/stock_price_listener.dart';
import '../../login/widgets/background_image.dart';
import '../../navigateAuthentication/screens/navigate_authentication_screen.dart';
import '../services/mpin_rest_api_service.dart';

class MpinValidatorPageOld extends StatefulWidget {
  final bool fetchUserData;
  const MpinValidatorPageOld({super.key, this.fetchUserData = false});

  @override
  State<MpinValidatorPageOld> createState() => _MpinValidatorPageState();
}

class _MpinValidatorPageState extends State<MpinValidatorPageOld> {
  SocketManager socketManager = SocketManager();
  FocusNode pinFocusNode = FocusNode();
  // LadderProvider? _ladderProvider;
  // OrderProvider? _orderProvider;
  // ActivityProvider? _activityProvider;
  // PositionProvider? _positionProvider;
  // TradesProvider? _tradesProvider;
  // FundsProvider? _fundsProvider;
  // CustomHomeAppBarProvider? _customHomeAppBarProvider;
  // TradeMainProvider? _tradeMainProvider;
  // late NavigationProvider _navigationProvider;
  final textEditingController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _isObscure = true;

  bool isBiometricAvailable = false;

  late NavigateAuthenticationProvider navigateAuthenticationProvider;
  late WebSocketServiceProvider webSocketServiceProvider;

  ApiStateProvider? _apiStateProvider;
  @override
  void initState() {
    super.initState();
    _apiStateProvider = Provider.of(context, listen: false);
    webSocketServiceProvider = Provider.of(context, listen: false);
    // _tradeMainProvider = Provider.of(context, listen: false);
    // _ladderProvider = Provider.of(context, listen: false);
    // _orderProvider = Provider.of(context, listen: false);
    // _fundsProvider = Provider.of(context, listen: false);
    // _positionProvider = Provider.of(context, listen: false);
    // _activityProvider = Provider.of(context, listen: false);
    // _tradesProvider = Provider.of(context, listen: false);
    // _customHomeAppBarProvider = Provider.of(context, listen: false);
    // _tradeMainProvider = Provider.of<TradeMainProvider>(context, listen: false);
    // _customHomeAppBarProvider!.getFieldVisibilityOfAccountInfoBar();
    // if (webSocketServiceProvider.status == "Disconnected") {
    //   webSocketServiceProvider.connect("ws://pxkjng5f-3000.inc1.devtunnels.ms/selected-stocks?userId=717");
    // }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(pinFocusNode);
    });
    // _navigationProvider =
    //     Provider.of<NavigationProvider>(context, listen: false);
    // if (widget.fetchUserData) {
    //   callInitialApi();
    // }

    handleBiometric();
  }

  handleBiometric() async {
    isBiometricAvailable = await _authService.isBiometricAvailable();
    setState(() {

    });
  }

  // Future<void> callInitialApi() async {
  //   try {
  //     await _customHomeAppBarProvider!.fetchUserAccountDetails();
  //     await _customHomeAppBarProvider!.getAppPackageInfo();
  //     await _tradeMainProvider!.getTradeMenuButtonsVisibilityStatus();
  //     await _tradeMainProvider!.initialGetLadderData();
  //     await _ladderProvider!.fetchAllLadder();
  //     await _tradeMainProvider!.getActiveLadderTickers(context);
  //     await _tradesProvider!.fetchTrades();
  //     await _orderProvider!.fetchOrders();
  //     await _positionProvider!.fetchPositions();
  //     await _activityProvider!.fetchActivities();
  //   } on HttpApiException catch (err) {
  //     print(err.errorTitle);
  //   }
  // }

  Future<void> _submitUserMpin() async {
    if (textEditingController.text.length < 6) return;
    progressbar(context);
    final pref = await SharedPreferences.getInstance();
    MpinRestApiService()
        .getValidateMpin(
      GetValidateMpinRequest(
        userId: pref.getInt("reg_id").toString(),
        mPinNo: textEditingController.text,
      ),
    )
        .then((value) {
      Navigator.of(context).pop();
      if (value!.status!) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CommonScreen()),
        );
      }
    }).catchError((err) {
      textEditingController.clear();
      Navigator.pop(context);
      if (err is HttpApiException) {
        if (err.errorTitle == "User not found") {
          Fluttertoast.showToast(msg: err.errorTitle);
          SharedPreferences.getInstance().then((value) async {
            await value.remove("reg_id");
            await value.remove("reg_user");
            navigateAuthenticationProvider.selectedIndex = 1;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => NavigateAuthenticationScreen()),
              (Route<dynamic> route) => false, // Removes all previous routes
            );
          });
        } else {
          restApiErrorDialog(context, error: err, apiState: _apiStateProvider!);
        }
      } else {
        restApiErrorDialog(context, error: HttpApiException(
          errorCode: 400,
          errorTitle: "Something went wrong please try again later",
          errorSuggestion: "Try using mobile network",
        ), apiState: _apiStateProvider!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    navigateAuthenticationProvider =
        Provider.of<NavigateAuthenticationProvider>(context, listen: true);
    double screenWidth = screenWidthRecognizer(context);
    return Stack(children: [
      Center(
        child: Container(
          width: screenWidth,
          child: Stack(
            children: [
              const BackgroundImage(),
              Scaffold(
                // resizeToAvoidBottomInset: false,
                backgroundColor: Colors.transparent,
                body: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: SizedBox(
                              width: 150,
                              height: 150,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(7),
                                child: Image.asset(
                                  "lib/global/assets/logos/dozendiamond_logo.jpeg",
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.amber,
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'Whoops!',
                                        style: TextStyle(fontSize: 30),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Login using 6-digit M-pin",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                child: Icon(
                                  _isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                                onTap: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          PinCodeTextField(
                            focusNode: pinFocusNode,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            length: 6,
                            obscureText: _isObscure,
                            obscuringCharacter: "*",
                            animationType: AnimationType.fade,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              activeColor: Colors.blue,
                              activeFillColor: Colors.blue,
                              disabledColor: Colors.white,
                              errorBorderColor: Colors.white,
                              inactiveColor: Colors.white,
                              inactiveFillColor: Colors.white,
                              selectedColor: Colors.white,
                              selectedFillColor: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            animationDuration:
                                const Duration(milliseconds: 300),
                            controller: textEditingController,
                            onCompleted: (v) async {
                              await _submitUserMpin();
                            },
                            onChanged: (value) {
                              print(value);
                            },
                            beforeTextPaste: (text) {
                              print("Allowing to paste $text");
                              return true;
                            },
                            appContext: context,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: (isBiometricAvailable)
                                ?MainAxisAlignment.spaceEvenly:MainAxisAlignment.center,
                            children: [
                              (isBiometricAvailable)?OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  side: const BorderSide(
                                    color: Color(0xFF0099CC),
                                  ),
                                ),
                                onPressed: () async {
                                  // final auth = LocalAuthentication();
                                  // final result = await auth.authenticate(
                                  //   localizedReason: "localizedReason",
                                  //   options: const AuthenticationOptions(
                                  //     biometricOnly: true,
                                  //   ),
                                  // );
                                  // if (result && mounted) {
                                  //   print("below is result");
                                  //   print(result);
                                  // }



                                  bool authenticated = await _authService.authenticateWithBiometrics(context);
                                  if (authenticated) {
                                    print("inside authenticated");
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => const CommonScreen()),
                                    );
                                    // _navigateToHome();
                                  }
                                },
                                child: const Text(
                                  "Use biometric",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ):Container(),
                              TextButton(
                                onPressed: () {
                                  print(navigateAuthenticationProvider
                                      .selectedIndex);
                                  navigateAuthenticationProvider.previousIndex =
                                      navigateAuthenticationProvider
                                          .selectedIndex;
                                  navigateAuthenticationProvider.selectedIndex =
                                      5;
                                  print("below is mpin p index");
                                  print(navigateAuthenticationProvider
                                      .previousIndex);
                                  // Navigator.of(context)
                                  //     .pushReplacement(MaterialPageRoute(
                                  //   builder: (context) {
                                  //     return const LoginPage(
                                  //       forgotMpin: true,
                                  //     );
                                  //   },
                                  // ));
                                },
                                child: const Text("Forgot Mpin"),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          (kIsWeb == true)?"${DataStrings().version}":"",
          style: TextStyle(fontSize: 22),
        ),
      )
    ]);
  }
}
