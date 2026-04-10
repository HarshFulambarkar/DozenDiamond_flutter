import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../DD_Navigation/widgets/common_screen.dart';
import '../../Settings/stateManagement/theme_provider.dart';
import '../../global/functions/helper.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/models/http_api_exception.dart';
import '../../global/services/auth_service.dart';
import '../../global/services/socket_manager.dart';
import '../../global/widgets/custom_container.dart';
import '../../global/widgets/error_dialog.dart';
import '../../login/services/login_rest_api_service.dart';
import '../../navigateAuthentication/screens/navigate_authentication_screen.dart';
import '../../navigateAuthentication/stateManagement/navigate_authentication_provider.dart';
import '../../socket_manager/stateManagement/web_socket_service_provider.dart';
import '../models/get_validate_mpin_request.dart';
import '../services/mpin_rest_api_service.dart';

class MpinValidatorPageNew extends StatefulWidget {
  final bool fetchUserData;
  const MpinValidatorPageNew({super.key, this.fetchUserData = false});

  @override
  State<MpinValidatorPageNew> createState() => _MpinValidatorPageNewState();
}

class _MpinValidatorPageNewState extends State<MpinValidatorPageNew> {

  SocketManager socketManager = SocketManager();
  // late FocusNode pinFocusNode ;
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
  late ThemeProvider themeProvider;

  bool showMpinFieldError = false;
  String mpinFieldError = "";

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
      pinFocusNode = FocusNode();
      FocusScope.of(context).requestFocus(pinFocusNode);
    });
    // Future.delayed(const Duration(milliseconds: 3000), () {
    //   if (mounted) {
    //     FocusScope.of(context).requestFocus(pinFocusNode);
    //   }
    // });
    // _navigationProvider =
    //     Provider.of<NavigationProvider>(context, listen: false);
    // if (widget.fetchUserData) {
    //   callInitialApi();
    // }

    handleBiometric();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    pinFocusNode.dispose();
    print("dispose called");
    super.dispose();
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
    // progressbar(context);
    final pref = await SharedPreferences.getInstance();
    MpinRestApiService()
        .getValidateMpin(
      GetValidateMpinRequest(
        userId: pref.getInt("reg_id").toString(),
        mPinNo: textEditingController.text,
      ),
    )
        .then((value) {
      // hideBar(context);
      // Navigator.of(context).pop();
      if (value!.status!) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CommonScreen()),
        );
      }
    }).catchError((err) {
      textEditingController.clear();
      // Navigator.pop(context);
      // hideBar(context);
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
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    double screenWidth = screenWidthRecognizer(context);

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (!pinFocusNode.hasFocus) {
    //     FocusScope.of(context).requestFocus(pinFocusNode);
    //   }
    // });

    return Center(
        child: Container(
          width: screenWidth,
          child: Scaffold(
            backgroundColor: (themeProvider.defaultTheme)
                ?Colors.white:Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
            ),
            body: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "lib/global/assets/logos/dozendiamond_logo.jpeg",
                    width: 25,
                  ),

                  SizedBox(
                    height: 12,
                  ),

                  Text(
                    "Welcome back!",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Britanica",
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  Text(
                    "Enter your MPIN to login.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Britanica",
                    ),
                  ),

                  SizedBox(
                    height: 15,
                  ),

                  buildMpinSection(context, screenWidth),

                  SizedBox(
                    height: 10,
                  ),

                  Row(
                    children: [
                      Text(
                        "Forgot your MPIN? Click here to ",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),

                      InkWell(
                        onTap: () {

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

                        },
                        child: Text(
                          "reset",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Color(0xff5cbbff),
                          ),
                        ),
                      ),
                    ],
                  ),

                  (isBiometricAvailable)?SizedBox(
                    height: 40,
                  ):Container(),

                  (isBiometricAvailable)?buildBiometricSection(context, screenWidth):Container()
                ],
              ),
            ),

            bottomNavigationBar: buildBottomNavigationSection(context, screenWidth),
          )
        )
    );
  }

  Widget buildBiometricSection(BuildContext context, screenWidget) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,

      onTap: () async {

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fingerprint,
            color: (themeProvider.defaultTheme)?Colors.black:Colors.white,
          ),

          SizedBox(
            width: 5,
          ),

          Text(
            "Login with Biometric",
            style: GoogleFonts.poppins(
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  Widget buildMpinSection(BuildContext context, screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "MPIN",
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w300
              ),
            ),

            InkWell(
              child: Icon(
                _isObscure
                    ? Icons.visibility_off
                    : Icons.visibility,
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

        SizedBox(
          height: 5
        ),

        PinCodeTextField(
          key: ValueKey(Uuid().toString()),
          // autoFocus: true,
          focusNode: pinFocusNode,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) {
            print("on Submitted");
            FocusScope.of(context).unfocus(); // Close keyboard when "Done" pressed
          },
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly
          ],
          length: 6,
          obscureText: _isObscure,
          obscuringCharacter: "*",
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            activeColor: Color(0xff2c2c31),
            activeFillColor: Color(0xff2c2c31),
            disabledColor: Color(0xff2c2c31),
            errorBorderColor: Color(0xffd42f1f),
            inactiveColor: Color(0xff2c2c31),
            inactiveFillColor: Color(0xff2c2c31),
            selectedColor: Color(0xff5cbbff),
            selectedFillColor: Color(0xff2c2c31),
            borderRadius: BorderRadius.circular(9),
          ),
          animationDuration:
          const Duration(milliseconds: 300),
          controller: textEditingController,
          onCompleted: (v) async {
            print("inside oncomplete");
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



        (showMpinFieldError)?SizedBox(
          height: 3,
        ):Container(),

        (showMpinFieldError)?Text(
          mpinFieldError,
          style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Color(0xffd41f1f)
          ),
        ):Container(),

      ],
    );
  }

  Widget buildBottomNavigationSection(BuildContext context, screenWidth) {
    return Container(
      width: screenWidth,
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16.0),
                child: CustomContainer(
                  onTap: () async {
                    if(textEditingController.text.length >= 6){
                      await _submitUserMpin();
                    } else {
                      showMpinFieldError = true;
                      mpinFieldError = "Enter Mpin";
                      setState(() {

                      });
                    }
                  },
                  backgroundColor: (themeProvider.defaultTheme)
                      ?Colors.black:Color(0xfff0f0f0),
                  borderRadius: 12,
                  height: 52,
                  width: screenWidth - 34,
                  child: Center(
                    child: Text(
                      "Login",
                      style: GoogleFonts.poppins(
                          color: (themeProvider.defaultTheme)?Colors.white:Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 18,
              ),

              Row(
                children: [
                  Text(
                    // "New here? ",
                    "Different Account? ",
                    style: GoogleFonts.poppins(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      // navigateAuthenticationProvider.previousIndex =
                      //     navigateAuthenticationProvider.selectedIndex;
                      // navigateAuthenticationProvider.selectedIndex = 0;
                      SharedPreferences.getInstance()
                          .then((value) async {
                        LoginRestApiService().signOutGoogle();
                        await value.remove("reg_id");
                        await value.remove("reg_user");
                        navigateAuthenticationProvider.selectedIndex = 1;

                      });
                    },
                    child: Text(
                      "Login",
                      // "Create your account",
                      style: GoogleFonts.poppins(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff1a94f2),
                      ),
                    ),
                  )
                ],
              ),

              SizedBox(
                height: 18,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
