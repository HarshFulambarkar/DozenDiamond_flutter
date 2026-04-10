import 'package:dozen_diamond/DD_Navigation/widgets/common_screen.dart';
import 'package:dozen_diamond/manage_brokers/ICICISecurities/stateManagement/icici_security_provider.dart';
import 'package:dozen_diamond/manage_brokers/screens/broker_setup_successfull.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../../../global/functions/screenWidthRecoginzer.dart';
import '../../../../global/widgets/my_text_field.dart';
import '../../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../stateManagement/smc_broker_provider.dart';

class EnterSmcDetailsScreen extends StatefulWidget {

  @override
  State<EnterSmcDetailsScreen> createState() => _EnterSmcDetailsScreenState();
}

class _EnterSmcDetailsScreenState extends State<EnterSmcDetailsScreen> {
  late NavigationProvider navigationProvider;

  late SmcBrokersProvider smcBrokersProvider;

  FocusNode pinFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(pinFocusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    smcBrokersProvider = Provider.of<SmcBrokersProvider>(context, listen: true);
    navigationProvider = Provider.of<NavigationProvider>(context, listen: true);

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [

              Center(
                child: Container(
                  width: screenWidth == 0 ? null : screenWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 45,
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      // SizedBox(
                      //   height: AppBar().preferredSize.height * 1.5,
                      // ),

                      Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 5, 0),
                        child: Row(
                          children: [

                            Image.asset(
                              "lib/manage_brokers/assets/smc_logo.png",
                              height: 35,
                              width: 35,
                            ),

                            SizedBox(
                                width: 10
                            ),

                            Text(
                              "SMC",
                              style:
                              TextStyle(
                                  fontSize: 25,
                                  color: Color(0xFFffffff),
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              "Client Id",
                              style: TextStyle(
                                  color: Color(0xFFffffff),
                                  fontSize: 18
                              ),
                            ),

                            SizedBox(
                              height: 5,
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyTextField(
                                  controller: smcBrokersProvider.smcClientIdTextController,
                                  borderRadius: 5,

                                  currencyFormat: false,
                                  isFilled: true,
                                  elevation: 0,
                                  isLabelEnabled: false,
                                  borderWidth: 1,
                                  fillColor: Color(0xff2c2c31),// Colors.transparent,
                                  contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),

                                  onChanged: (value) {

                                  },
                                  borderColor: Colors.white,
                                  labelText: "Enter Client Id",
                                  hintText: "Enter Client Id",
                                  counterText: "",

                                  overrideHintText: true,

                                  focusedBorderColor: Colors.white,
                                  isPasswordField: false,

                                  isEnabled: true,
                                  // showLeadingWidget: true,

                                  validator: (value) {

                                  },
                                ),

                                (smcBrokersProvider.smcClientIdFieldError == "")
                                    ? Container()
                                    : Text(smcBrokersProvider.smcClientIdFieldError,
                                    style: TextStyle(color: Colors.red))
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              "Password",
                              style: TextStyle(
                                  color: Color(0xFFffffff),
                                  fontSize: 18
                              ),
                            ),

                            SizedBox(
                              height: 5,
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyTextField(
                                  // controller: createLadderEasyProvider.targetTextEditingController,
                                  borderRadius: 5,
                                  controller: smcBrokersProvider.smcPasswordTextController,
                                  currencyFormat: false,
                                  isFilled: true,
                                  elevation: 0,
                                  isLabelEnabled: false,
                                  borderWidth: 1,
                                  fillColor: Color(0xff2c2c31),// Colors.transparent,
                                  contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),

                                  onChanged: (value) {

                                  },
                                  borderColor: Colors.white,
                                  labelText: "Enter Password",
                                  hintText: "Enter Password",
                                  counterText: "",

                                  overrideHintText: true,

                                  focusedBorderColor: Colors.white,
                                  isPasswordField: false,

                                  isEnabled: true,
                                  // showLeadingWidget: true,

                                  validator: (value) {

                                  },
                                ),
                                (smcBrokersProvider.smcPasswordFieldError == "")
                                    ? Container()
                                    : Text(smcBrokersProvider.smcPasswordFieldError,
                                    style: TextStyle(color: Colors.red))
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              "Api Key",
                              style: TextStyle(
                                  color: Color(0xFFffffff),
                                  fontSize: 18
                              ),
                            ),

                            SizedBox(
                              height: 5,
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyTextField(
                                  controller: smcBrokersProvider.smcApiKeyTextController,
                                  borderRadius: 5,
                                  // textInputFormatters: [
                                  //   FilteringTextInputFormatter.digitsOnly
                                  // ],
                                  currencyFormat: false,
                                  isFilled: true,
                                  elevation: 0,
                                  isLabelEnabled: false,
                                  borderWidth: 1,
                                  fillColor: Color(0xff2c2c31),// Colors.transparent,
                                  contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {

                                  },
                                  borderColor: Colors.white,
                                  labelText: "Enter Api Key",
                                  hintText: "Enter Api Key",
                                  counterText: "",

                                  overrideHintText: true,

                                  focusedBorderColor: Colors.white,
                                  isPasswordField: false,

                                  isEnabled: true,
                                  // showLeadingWidget: true,

                                  validator: (value) {

                                  },
                                ),
                                (smcBrokersProvider.smcApiKeyFieldError == "")
                                    ? Container()
                                    : Text(smcBrokersProvider.smcApiKeyFieldError,
                                    style: TextStyle(color: Colors.red))
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              side: const BorderSide(
                                color: Color(0xFF0099CC),
                              ),
                            ),
                            onPressed: () async {
                              smcBrokersProvider.smcOtpTextController = TextEditingController(text: "");
                              if(smcBrokersProvider.smcClientIdTextController.text == "") {
                                smcBrokersProvider.smcClientIdFieldError = "Please enter Client Id";
                              }

                              if(smcBrokersProvider.smcPasswordTextController.text == "") {
                                smcBrokersProvider.smcPasswordFieldError = "Please enter Password";
                              }

                              if(smcBrokersProvider.smcApiKeyTextController.text == "") {
                                smcBrokersProvider.smcApiKeyFieldError = "Please enter Api Key";
                              }

                              if(smcBrokersProvider.smcClientIdTextController.text != "" &&
                                  smcBrokersProvider.smcPasswordTextController.text != "" &&
                                  smcBrokersProvider.smcApiKeyTextController.text != ""
                              ) {

                                final value = await smcBrokersProvider.sendSmcOtp();
                                if(value) {
                                  // navigationProvider.selectedIndex = 12;
                                  // Navigator.of(context).pushAndRemoveUntil(
                                  //   MaterialPageRoute(
                                  //     builder: (context) => CommonScreen(),
                                  //   ),
                                  //       (Route<dynamic> route) => false,
                                  // );

                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => buildSmcOtpPopup(context),
                                  );
                                } else {
                                  // Fluttertoast.showToast(msg: "Something When Wrong");
                                  // showDialog(
                                  //   context: context,
                                  //   barrierDismissible: false,
                                  //   builder: (context) => buildKotakNeoOtpPopup(context),
                                  // );
                                }



                              }


                            },
                            child: const Text(
                              'Save Details',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFffffff),
                              ),
                            ),
                          ),
                        ],
                      ),


                    ],
                  ),
                ),
              ),


              CustomHomeAppBarWithProviderNew(
                backButton: true,
                widthOfWidget: screenWidth,
                isForPop:
                true, //these leadingAction button is not working, I have tired making it work, but it isn't.
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSmcSecretKeyPopup(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.only(bottom: 5),
        width: screenWidth,
        decoration: BoxDecoration(
          color: Color(
              0xFF15181F), //value.defaultTheme ? Colors.white : Color(0xFF15181F),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white54,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                        Icons.clear,
                        color: Colors.white
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 10,
                  ),
                  child: const Text(
                    "Enter Secret Key",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(
                    width: 10
                ),

              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30),
              child: Column(
                  mainAxisSize: MainAxisSize.min, children: [

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyTextField(
                      controller: smcBrokersProvider.smcSecretKeyTextController,
                      borderRadius: 5,

                      currencyFormat: false,
                      isFilled: true,
                      elevation: 0,
                      isLabelEnabled: false,
                      borderWidth: 1,
                      fillColor: Colors.transparent,
                      contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),

                      onChanged: (value) {

                      },
                      borderColor: Colors.white,
                      labelText: "Enter Secret key",
                      hintText: "Enter Secret key",
                      counterText: "",

                      overrideHintText: true,

                      focusedBorderColor: Colors.white,
                      isPasswordField: false,

                      isEnabled: true,
                      // showLeadingWidget: true,

                      validator: (value) {

                      },
                    ),

                    (smcBrokersProvider.smcSecretKeyFieldError == "")
                        ? Container()
                        : Text(smcBrokersProvider.smcSecretKeyFieldError,
                        style: TextStyle(color: Colors.red))
                  ],
                ),

                SizedBox(
                  height: 15,
                ),

                ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: const BorderSide(
                      color: Color(0xFF0099CC),
                    ),
                  ),
                  onPressed: () async {

                    if(smcBrokersProvider.smcSecretKeyTextController.text == "") {
                      smcBrokersProvider.smcSecretKeyFieldError = "Please enter Secret key";
                    }

                    if(smcBrokersProvider.smcSecretKeyTextController.text != "") {
                      final value = await smcBrokersProvider.doSmcLogin();
                      if(value) {
                        navigationProvider.selectedIndex = 12;
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => CommonScreen(),
                          ),
                              (Route<dynamic> route) => false,
                        );
                      }
                    }


                  },
                  child: const Text(
                    'Submit Detail',
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(
                  height: 10,
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSmcOtpPopup(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.only(bottom: 5),
        width: screenWidth,
        decoration: BoxDecoration(
          color: Color(
              0xFF15181F), //value.defaultTheme ? Colors.white : Color(0xFF15181F),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white54,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                        Icons.clear,
                        color: Colors.white
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 10,
                  ),
                  child: const Text(
                    "Enter TOTP",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFffffff),
                    ),
                  ),
                ),

                SizedBox(
                    width: 10
                ),

              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30),
              child: Column(
                  mainAxisSize: MainAxisSize.min, children: [

                PinCodeTextField(
                  // focusNode: pinFocusNode,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  length: 6,
                  textStyle: TextStyle(
                    color: Color(0xFFffffff),
                  ),
                  obscureText: false,
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
                  animationDuration: const Duration(milliseconds: 300),
                  controller: smcBrokersProvider.smcOtpTextController,
                  onCompleted: (v) async {

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

                (smcBrokersProvider.smcOtpFieldError == "")
                    ? Container()
                    : Text(smcBrokersProvider.smcOtpFieldError,
                    style: TextStyle(color: Colors.red)),

                SizedBox(
                  height: 15,
                ),

                ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: const BorderSide(
                      color: Color(0xFF0099CC),
                    ),
                  ),
                  onPressed: () async {

                    if(smcBrokersProvider.smcOtpTextController.text == "") {
                      smcBrokersProvider.smcOtpFieldError = "Please enter TOTP";
                    }

                    if(smcBrokersProvider.smcOtpTextController.text != "") {
                      final value = await smcBrokersProvider.sendSmcSecretKey();
                      if(value) {

                        Navigator.of(context).pop();

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => buildSmcSecretKeyPopup(context),
                        );
                      } else {

                      }
                    }


                  },
                  child: const Text(
                    'Submit OTP',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFffffff),
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
