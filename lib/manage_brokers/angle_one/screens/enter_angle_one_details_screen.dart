import 'package:dozen_diamond/DD_Navigation/widgets/common_screen.dart';
import 'package:dozen_diamond/manage_brokers/angle_one/stateManagement/angle_one_broker_provider.dart';
import 'package:dozen_diamond/manage_brokers/screens/broker_setup_successfull.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../../../global/functions/screenWidthRecoginzer.dart';
import '../../../../global/widgets/my_text_field.dart';
import '../../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';

class EnterAngleOneDetailsScreen extends StatelessWidget {

  late AngleOneBrokersProvider angleOneBrokersProvider;
  late NavigationProvider navigationProvider;

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    angleOneBrokersProvider = Provider.of<AngleOneBrokersProvider>(context, listen: true);
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
                              "lib/manage_brokers/assets/angel_one.png",
                              height: 35,
                              width: 35,
                            ),

                            SizedBox(
                                width: 10
                            ),

                            Text(
                              "Angel One",
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
                              "Client Code",
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
                                  controller: angleOneBrokersProvider.angleOneClientCodeTextController,
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
                                  labelText: "Enter Client Code",
                                  hintText: "Enter Client Code",
                                  counterText: "",

                                  overrideHintText: true,

                                  focusedBorderColor: Colors.white,
                                  isPasswordField: false,

                                  isEnabled: true,
                                  // showLeadingWidget: true,

                                  validator: (value) {

                                  },
                                ),

                                (angleOneBrokersProvider.angleOneClientCodeFieldError == "")
                                    ? Container()
                                    : Text(angleOneBrokersProvider.angleOneClientCodeFieldError,
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
                              // "Password",
                              "PIN",
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
                                  // controller: createLadderEasyProvider.targetTextEditingController,
                                  borderRadius: 5,
                                  controller: angleOneBrokersProvider.angleOnePasswordTextController,
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
                                  labelText: "Enter Pin",
                                  hintText: "Enter Pin",
                                  counterText: "",

                                  overrideHintText: true,

                                  focusedBorderColor: Colors.white,
                                  isPasswordField: false,

                                  isEnabled: true,
                                  // showLeadingWidget: true,

                                  validator: (value) {

                                  },
                                ),
                                (angleOneBrokersProvider.angleOnePasswordFieldError == "")
                                    ? Container()
                                    : Text(angleOneBrokersProvider.angleOnePasswordFieldError,
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
                                  controller: angleOneBrokersProvider.angleOneApiKeyTextController,
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
                                (angleOneBrokersProvider.angleOneApiKeyFieldError == "")
                                    ? Container()
                                    : Text(angleOneBrokersProvider.angleOneApiKeyFieldError,
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
                              // "TOTP",
                              "QR Key",
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
                                  controller: angleOneBrokersProvider.angleOneQRKeyTextController,
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
                                  // labelText: "Enter TOTP",
                                  // hintText: "Enter TOTP",
                                  labelText: "QR Key",
                                  hintText: "QR Key",
                                  counterText: "",

                                  overrideHintText: true,

                                  focusedBorderColor: Colors.white,
                                  isPasswordField: false,

                                  isEnabled: true,
                                  // showLeadingWidget: true,

                                  validator: (value) {

                                  },
                                ),
                                (angleOneBrokersProvider.angleOneTotpFieldError == "")
                                    ? Container()
                                    : Text(angleOneBrokersProvider.angleOneTotpFieldError,
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
                              if(angleOneBrokersProvider.angleOneClientCodeTextController.text == "") {
                                angleOneBrokersProvider.angleOneClientCodeFieldError = "Please enter client code";
                              }

                              if(angleOneBrokersProvider.angleOnePasswordTextController.text == "") {
                                angleOneBrokersProvider.angleOnePasswordFieldError = "Please enter Password";
                              }

                              if(angleOneBrokersProvider.angleOneApiKeyTextController.text == "") {
                                angleOneBrokersProvider.angleOneApiKeyFieldError = "Please enter Api Key";
                              }

                              if(angleOneBrokersProvider.angleOneQRKeyTextController.text == "") {
                                angleOneBrokersProvider.angleOneTotpFieldError = "Please enter TOTP";
                              }

                              if(angleOneBrokersProvider.angleOneClientCodeTextController.text != "" &&
                                  angleOneBrokersProvider.angleOnePasswordTextController.text != "" &&
                                  angleOneBrokersProvider.angleOneApiKeyTextController.text != "" &&
                                  angleOneBrokersProvider.angleOneQRKeyTextController.text != ""
                              ) {

                                final value = await angleOneBrokersProvider.doAngleOneLogin();
                                if(value) {
                                  navigationProvider.selectedIndex = 12;
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => CommonScreen(),
                                    ),
                                        (Route<dynamic> route) => false,
                                  );
                                } else {
                                  // Fluttertoast.showToast(msg: "Something When Wrong");
                                }



                              }


                            },
                            child: (angleOneBrokersProvider.buttonLoading)
                                ?Padding(
                                  padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 8.0),
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ):Text(
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
}
