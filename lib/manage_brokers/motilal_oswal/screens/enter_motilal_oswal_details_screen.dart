import 'package:dozen_diamond/DD_Navigation/widgets/common_screen.dart';
import 'package:dozen_diamond/manage_brokers/ICICISecurities/stateManagement/icici_security_provider.dart';
import 'package:dozen_diamond/manage_brokers/motilal_oswal/stateManagement/motilal_oswal_broker_provider.dart';
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

class EnterMotilalOswalDetailsScreen extends StatefulWidget {

  @override
  State<EnterMotilalOswalDetailsScreen> createState() => _EnterMotilalOswalDetailsScreenState();
}

class _EnterMotilalOswalDetailsScreenState extends State<EnterMotilalOswalDetailsScreen> {
  late NavigationProvider navigationProvider;

  late MotilalOswalBrokersProvider motilalOswalBrokersProvider;

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
    motilalOswalBrokersProvider = Provider.of<MotilalOswalBrokersProvider>(context, listen: true);
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
                              "lib/manage_brokers/assets/motilal_oswal.jpg",
                              height: 35,
                              width: 35,
                            ),

                            SizedBox(
                                width: 10
                            ),

                            Text(
                              "Motilal Oswal",
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
                              "User Id",
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
                                  controller: motilalOswalBrokersProvider.motilalOswalUserIdTextController,
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
                                  labelText: "Enter User Id",
                                  hintText: "Enter User Id",
                                  counterText: "",

                                  overrideHintText: true,

                                  focusedBorderColor: Colors.white,
                                  isPasswordField: false,

                                  isEnabled: true,
                                  // showLeadingWidget: true,

                                  validator: (value) {

                                  },
                                ),

                                (motilalOswalBrokersProvider.motilalOswalUserIdFieldError == "")
                                    ? Container()
                                    : Text(motilalOswalBrokersProvider.motilalOswalUserIdFieldError,
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
                                  controller: motilalOswalBrokersProvider.motilalOswalPasswordTextController,
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
                                (motilalOswalBrokersProvider.motilalOswalPasswordFieldError == "")
                                    ? Container()
                                    : Text(motilalOswalBrokersProvider.motilalOswalPasswordFieldError,
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
                              "Two FA",
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
                                  controller: motilalOswalBrokersProvider.motilalOswalTwoFATextController,
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
                                  labelText: "Enter Two FA",
                                  hintText: "Enter Two FA",
                                  counterText: "",

                                  overrideHintText: true,

                                  focusedBorderColor: Colors.white,
                                  isPasswordField: false,

                                  isEnabled: true,
                                  // showLeadingWidget: true,

                                  validator: (value) {

                                  },
                                ),
                                (motilalOswalBrokersProvider.motilalOswalTwoFAFieldError == "")
                                    ? Container()
                                    : Text(motilalOswalBrokersProvider.motilalOswalTwoFAFieldError,
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
                                  controller: motilalOswalBrokersProvider.motilalOswalApiKeyTextController,
                                  borderRadius: 5,

                                  currencyFormat: false,
                                  isFilled: true,
                                  elevation: 0,
                                  isLabelEnabled: false,
                                  borderWidth: 1,
                                  fillColor: Color(0xff2c2c31),// Colors.transparent,
                                  contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                  // keyboardType: TextInputType.number,
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
                                (motilalOswalBrokersProvider.motilalOswalApiKeyFieldError == "")
                                    ? Container()
                                    : Text(motilalOswalBrokersProvider.motilalOswalApiKeyFieldError,
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

                              motilalOswalBrokersProvider.motilalOswalOtpTextController = TextEditingController(text: "");

                              if(motilalOswalBrokersProvider.motilalOswalUserIdTextController.text == "") {
                                motilalOswalBrokersProvider.motilalOswalUserIdFieldError = "Please enter User Id";
                              }

                              if(motilalOswalBrokersProvider.motilalOswalPasswordTextController.text == "") {
                                motilalOswalBrokersProvider.motilalOswalPasswordFieldError = "Please enter Password";
                              }

                              if(motilalOswalBrokersProvider.motilalOswalTwoFATextController.text == "") {
                                motilalOswalBrokersProvider.motilalOswalTwoFAFieldError = "Please enter Two FA";
                              }

                              if(motilalOswalBrokersProvider.motilalOswalApiKeyTextController.text == "") {
                                motilalOswalBrokersProvider.motilalOswalApiKeyFieldError = "Please enter Api Key";
                              }

                              if(motilalOswalBrokersProvider.motilalOswalUserIdTextController.text != "" &&
                                  motilalOswalBrokersProvider.motilalOswalPasswordTextController.text != "" &&
                                  motilalOswalBrokersProvider.motilalOswalTwoFATextController.text != "" &&
                                  motilalOswalBrokersProvider.motilalOswalApiKeyTextController.text != ""
                              ) {

                                final value = await motilalOswalBrokersProvider.motilalOswalLogin();
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
                                    builder: (context) => buildMotilalOswalOtpPopup(context),
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

  Widget buildMotilalOswalOtpPopup(BuildContext context) {
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
                    "Enter OTP",
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
                  length: 4,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  textStyle: TextStyle(
                    color: Color(0xFFffffff),
                  ),
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
                  controller: motilalOswalBrokersProvider.motilalOswalOtpTextController,
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

                (motilalOswalBrokersProvider.motilalOswalOtpFieldError == "")
                    ? Container()
                    : Text(motilalOswalBrokersProvider.motilalOswalOtpFieldError,
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

                    if(motilalOswalBrokersProvider.motilalOswalOtpTextController.text == "") {
                      motilalOswalBrokersProvider.motilalOswalOtpFieldError = "Please enter OTP";
                    }

                    if(motilalOswalBrokersProvider.motilalOswalOtpTextController.text != "") {
                      final value = await motilalOswalBrokersProvider.motilalOswalVerifyOtp();
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
