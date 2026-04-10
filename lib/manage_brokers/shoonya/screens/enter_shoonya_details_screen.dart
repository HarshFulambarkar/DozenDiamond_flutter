import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../../DD_Navigation/widgets/common_screen.dart';
import '../../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../../global/functions/screenWidthRecoginzer.dart';
import '../../../global/widgets/my_text_field.dart';
import '../stateManagement/shoonya_broker_provider.dart';

class EnterShoonyaDetailsScreen extends StatelessWidget {
  EnterShoonyaDetailsScreen({super.key});

  late ShoonyaBrokersProvider shoonyaBrokersProvider;
  late NavigationProvider navigationProvider;

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    shoonyaBrokersProvider = Provider.of<ShoonyaBrokersProvider>(context, listen: true);
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
                              "lib/manage_brokers/assets/shoonya.png",
                              height: 35,
                              width: 35,
                            ),

                            SizedBox(
                                width: 10
                            ),

                            Text(
                              "Shoonya",
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
                              "User ID",
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
                                  controller: shoonyaBrokersProvider.shoonyaUserIdTextController,
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

                                (shoonyaBrokersProvider.shoonyaUserIdFieldError == "")
                                    ? Container()
                                    : Text(shoonyaBrokersProvider.shoonyaUserIdFieldError,
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
                              // "PIN",
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
                                  controller: shoonyaBrokersProvider.shoonyaPasswordTextController,
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
                                (shoonyaBrokersProvider.shoonyaPasswordFieldError == "")
                                    ? Container()
                                    : Text(shoonyaBrokersProvider.shoonyaPasswordFieldError,
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
                              "TOTP Secret",
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
                                  controller: shoonyaBrokersProvider.shoonyaTotpSecretTextController,
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
                                  labelText: "Enter TOTP Secret",
                                  hintText: "Enter TOTP Secret",
                                  counterText: "",

                                  overrideHintText: true,

                                  focusedBorderColor: Colors.white,
                                  isPasswordField: false,

                                  isEnabled: true,
                                  // showLeadingWidget: true,

                                  validator: (value) {

                                  },
                                ),
                                (shoonyaBrokersProvider.shoonyaTotpSecretFieldError == "")
                                    ? Container()
                                    : Text(shoonyaBrokersProvider.shoonyaTotpSecretFieldError,
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
                              "Vendor Code",
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
                                  controller: shoonyaBrokersProvider.shoonyaVendorCodeTextController,
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
                                  labelText: "Enter Vendor Code",
                                  hintText: "Enter Vendor Code",
                                  counterText: "",

                                  overrideHintText: true,

                                  focusedBorderColor: Colors.white,
                                  isPasswordField: false,

                                  isEnabled: true,
                                  // showLeadingWidget: true,

                                  validator: (value) {

                                  },
                                ),
                                (shoonyaBrokersProvider.shoonyaVendorCodeFieldError == "")
                                    ? Container()
                                    : Text(shoonyaBrokersProvider.shoonyaVendorCodeFieldError,
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
                                  controller: shoonyaBrokersProvider.shoonyaApiKeyTextController,
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
                                (shoonyaBrokersProvider.shoonyaApiKeyFieldError == "")
                                    ? Container()
                                    : Text(shoonyaBrokersProvider.shoonyaApiKeyFieldError,
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
                              "IMEI",
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
                                  controller: shoonyaBrokersProvider.shoonyaIMEITextController,
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
                                  labelText: "Enter IMEI",
                                  hintText: "Enter IMEI",
                                  counterText: "",

                                  overrideHintText: true,

                                  focusedBorderColor: Colors.white,
                                  isPasswordField: false,

                                  isEnabled: true,
                                  // showLeadingWidget: true,

                                  validator: (value) {

                                  },
                                ),
                                (shoonyaBrokersProvider.shoonyaIMEIFieldError == "")
                                    ? Container()
                                    : Text(shoonyaBrokersProvider.shoonyaIMEIFieldError,
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
                              if(shoonyaBrokersProvider.shoonyaUserIdTextController.text == "") {
                                shoonyaBrokersProvider.shoonyaUserIdFieldError = "Please enter User Id";
                              }

                              if(shoonyaBrokersProvider.shoonyaPasswordTextController.text == "") {
                                shoonyaBrokersProvider.shoonyaPasswordFieldError = "Please enter Password";
                              }

                              if(shoonyaBrokersProvider.shoonyaTotpSecretTextController.text == "") {
                                shoonyaBrokersProvider.shoonyaTotpSecretFieldError = "Please enter TOTP Secret";
                              }

                              if(shoonyaBrokersProvider.shoonyaVendorCodeTextController.text == "") {
                                shoonyaBrokersProvider.shoonyaVendorCodeFieldError = "Please enter Vendor Code";
                              }

                              if(shoonyaBrokersProvider.shoonyaApiKeyTextController.text == "") {
                                shoonyaBrokersProvider.shoonyaApiKeyFieldError = "Please enter Api Key";
                              }

                              if(shoonyaBrokersProvider.shoonyaIMEITextController.text == "") {
                                shoonyaBrokersProvider.shoonyaIMEIFieldError = "Please enter IMEI";
                              }

                              if(shoonyaBrokersProvider.shoonyaUserIdTextController.text != "" &&
                                  shoonyaBrokersProvider.shoonyaPasswordTextController.text != "" &&
                                  shoonyaBrokersProvider.shoonyaTotpSecretTextController.text != "" &&
                                  shoonyaBrokersProvider.shoonyaVendorCodeTextController.text != "" &&
                                  shoonyaBrokersProvider.shoonyaApiKeyTextController.text != "" &&
                                  shoonyaBrokersProvider.shoonyaIMEITextController.text != ""
                              ) {

                                final value = await shoonyaBrokersProvider.doShoonyaLogin();
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
                            child: (shoonyaBrokersProvider.buttonLoading)
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
