import 'package:dozen_diamond/DD_Navigation/widgets/common_screen.dart';
import 'package:dozen_diamond/manage_brokers/screens/broker_setup_successfull.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../../../global/functions/screenWidthRecoginzer.dart';
import '../../../../global/widgets/my_text_field.dart';
import '../../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../stateManagement/5paisa_broker_provider.dart';

class EnterPaachPaisaDetailsScreen extends StatefulWidget {

  @override
  State<EnterPaachPaisaDetailsScreen> createState() => _EnterPaachPaisaDetailsScreenState();
}

class _EnterPaachPaisaDetailsScreenState extends State<EnterPaachPaisaDetailsScreen> {
  late PaachPaisaBrokersProvider paachPaisaBrokersProvider;

  late NavigationProvider navigationProvider;

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    paachPaisaBrokersProvider = Provider.of<PaachPaisaBrokersProvider>(context, listen: true);
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
                              "lib/manage_brokers/assets/paach_paisa_logo.png",
                              height: 35,
                              width: 35,
                            ),

                            SizedBox(
                                width: 10
                            ),

                            Text(
                              "5Paisa",
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
                              "Client Id/Email ID",
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
                                  controller: paachPaisaBrokersProvider.paachPaisaClientIdTextController,
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
                                  labelText: "Enter Client Id/Email Id",
                                  hintText: "Enter Client Id/Email Id",
                                  counterText: "",

                                  overrideHintText: true,

                                  focusedBorderColor: Colors.white,
                                  isPasswordField: false,

                                  isEnabled: true,
                                  // showLeadingWidget: true,

                                  validator: (value) {

                                  },
                                ),

                                (paachPaisaBrokersProvider.paachPaisaClientIdFieldError == "")
                                    ? Container()
                                    : Text(paachPaisaBrokersProvider.paachPaisaClientIdFieldError,
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
                                  // controller: createLadderEasyProvider.targetTextEditingController,
                                  borderRadius: 5,
                                  controller: paachPaisaBrokersProvider.paachPaisaApiKeyTextController,
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
                                  labelText: "Enter Api Key",
                                  hintText: "Enter Api key",
                                  counterText: "",

                                  overrideHintText: true,

                                  focusedBorderColor: Colors.white,
                                  isPasswordField: false,

                                  isEnabled: true,
                                  // showLeadingWidget: true,

                                  validator: (value) {

                                  },
                                ),
                                (paachPaisaBrokersProvider.paachPaisaApiKeyFieldError == "")
                                    ? Container()
                                    : Text(paachPaisaBrokersProvider.paachPaisaApiKeyFieldError,
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
                              "TOTP",
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
                                  controller: paachPaisaBrokersProvider.paachPaisaTotpTextController,
                                  borderRadius: 5,
                                  currencyFormat: false,
                                  textInputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  isFilled: true,
                                  elevation: 0,
                                  isLabelEnabled: false,
                                  borderWidth: 1,
                                  fillColor: Color(0xff2c2c31),// Colors.transparent,
                                  contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),

                                  onChanged: (value) {

                                  },
                                  borderColor: Colors.white,
                                  labelText: "Enter TOTP",
                                  hintText: "Enter TOTP",
                                  counterText: "",

                                  overrideHintText: true,

                                  focusedBorderColor: Colors.white,
                                  isPasswordField: false,

                                  isEnabled: true,
                                  // showLeadingWidget: true,

                                  validator: (value) {

                                  },
                                ),
                                (paachPaisaBrokersProvider.paachPaisaTotpFieldError == "")
                                    ? Container()
                                    : Text(paachPaisaBrokersProvider.paachPaisaTotpFieldError,
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
                              "PIN",
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
                                  controller: paachPaisaBrokersProvider.paachPaisaPinTextController,
                                  borderRadius: 5,
                                  currencyFormat: false,
                                  textInputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  isFilled: true,
                                  elevation: 0,
                                  isLabelEnabled: false,
                                  borderWidth: 1,
                                  fillColor: Color(0xff2c2c31),// Colors.transparent,
                                  contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),

                                  onChanged: (value) {

                                  },
                                  borderColor: Colors.white,
                                  labelText: "Enter PIN",
                                  hintText: "Enter PIN",
                                  counterText: "",

                                  overrideHintText: true,

                                  focusedBorderColor: Colors.white,
                                  isPasswordField: false,

                                  isEnabled: true,
                                  // showLeadingWidget: true,

                                  validator: (value) {

                                  },
                                ),
                                (paachPaisaBrokersProvider.paachPaisaPinFieldError == "")
                                    ? Container()
                                    : Text(paachPaisaBrokersProvider.paachPaisaPinFieldError,
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

                              paachPaisaBrokersProvider.paachPaisaKeyTextController == TextEditingController(text: "");
                              paachPaisaBrokersProvider.paachPaisaEncryKeyTextController == TextEditingController(text: "");
                              paachPaisaBrokersProvider.paachPaisaUserIdTextController == TextEditingController(text: "");

                              // showDialog(
                              //   context: context,
                              //   barrierDismissible: false,
                              //   builder: (context) => buildPaachPaisaOtpPopup(context),
                              // );
                              if(paachPaisaBrokersProvider.paachPaisaClientIdTextController.text == "") {
                                paachPaisaBrokersProvider.paachPaisaClientIdFieldError = "Please enter client Id/Email Id";
                              }

                              if(paachPaisaBrokersProvider.paachPaisaApiKeyTextController.text == "") {
                                paachPaisaBrokersProvider.paachPaisaApiKeyFieldError = "Please enter Api Key";
                              }

                              if(paachPaisaBrokersProvider.paachPaisaTotpTextController.text == "") {
                                paachPaisaBrokersProvider.paachPaisaTotpFieldError = "Please enter TOTP";
                              }

                              if(paachPaisaBrokersProvider.paachPaisaPinTextController.text == "") {
                                paachPaisaBrokersProvider.paachPaisaPinFieldError = "Please enter PIN";
                              }

                              if(paachPaisaBrokersProvider.paachPaisaClientIdTextController.text != "" &&
                                  paachPaisaBrokersProvider.paachPaisaApiKeyTextController.text != "" &&
                                  paachPaisaBrokersProvider.paachPaisaTotpTextController.text != "" &&
                                  paachPaisaBrokersProvider.paachPaisaPinTextController.text != ""
                              ) {

                                final value = await paachPaisaBrokersProvider.sendPaachPaisaOtp();
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
                                    builder: (context) => buildPaachPaisaOtpPopup(context),
                                  );

                                } else {
                                  // Fluttertoast.showToast(msg: "Something When Wrong");
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

  Widget buildPaachPaisaOtpPopup(BuildContext context) {
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
                    "Enter Detail",
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

                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        "Key",
                        style: TextStyle(
                            fontSize: 18,
                          color: Color(0xFFffffff),
                        ),
                      ),

                      SizedBox(
                        height: 5,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyTextField(
                            controller: paachPaisaBrokersProvider.paachPaisaKeyTextController,
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
                            labelText: "Enter Key",
                            hintText: "Enter Key",
                            counterText: "",

                            overrideHintText: true,

                            focusedBorderColor: Colors.white,
                            isPasswordField: false,

                            isEnabled: true,
                            // showLeadingWidget: true,

                            validator: (value) {

                            },
                          ),
                          (paachPaisaBrokersProvider.paachPaisaKeyFieldError == "")
                              ? Container()
                              : Text(paachPaisaBrokersProvider.paachPaisaKeyFieldError,
                              style: TextStyle(color: Colors.red))
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 15,
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        "Encryption Key",
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
                            controller: paachPaisaBrokersProvider.paachPaisaEncryKeyTextController,
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
                            labelText: "Enter Encryption Key",
                            hintText: "Enter Encryption Key",
                            counterText: "",

                            overrideHintText: true,

                            focusedBorderColor: Colors.white,
                            isPasswordField: false,

                            isEnabled: true,
                            // showLeadingWidget: true,

                            validator: (value) {

                            },
                          ),
                          (paachPaisaBrokersProvider.paachPaisaEncryKeyFieldError == "")
                              ? Container()
                              : Text(paachPaisaBrokersProvider.paachPaisaEncryKeyFieldError,
                              style: TextStyle(color: Colors.red))
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 15,
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        "5Paisa User Id",
                        style: TextStyle(
                            fontSize: 18,
                          color: Color(0xFFffffff),
                        ),
                      ),

                      SizedBox(
                        height: 5,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyTextField(
                            controller: paachPaisaBrokersProvider.paachPaisaUserIdTextController,
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
                          (paachPaisaBrokersProvider.paachPaisaUserIdFieldError == "")
                              ? Container()
                              : Text(paachPaisaBrokersProvider.paachPaisaUserIdFieldError,
                              style: TextStyle(color: Colors.red))
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 15,
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

                    if(paachPaisaBrokersProvider.paachPaisaKeyTextController.text == "") {
                      paachPaisaBrokersProvider.paachPaisaKeyFieldError = "Please enter Key";
                    }

                    if(paachPaisaBrokersProvider.paachPaisaEncryKeyTextController.text == "") {
                      paachPaisaBrokersProvider.paachPaisaEncryKeyFieldError = "Please enter Encryption Key";
                    }

                    if(paachPaisaBrokersProvider.paachPaisaUserIdTextController.text == "") {
                      paachPaisaBrokersProvider.paachPaisaUserIdFieldError = "Please enter User Id";
                    }

                    setState(() {

                    });

                    if(paachPaisaBrokersProvider.paachPaisaKeyTextController.text != "" &&
                        paachPaisaBrokersProvider.paachPaisaEncryKeyTextController.text != "" &&
                        paachPaisaBrokersProvider.paachPaisaUserIdTextController.text != "") {
                      final value = await paachPaisaBrokersProvider.doPaachPaisaLogin();
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
                    'Submit Details',
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
