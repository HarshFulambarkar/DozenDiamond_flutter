import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../../DD_Navigation/widgets/common_screen.dart';
import '../../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../../global/functions/screenWidthRecoginzer.dart';
import '../../../global/widgets/my_text_field.dart';
import '../stateManagement/zerodha_provider.dart';

class EnterZerodhaDetailsScreen extends StatelessWidget {
  EnterZerodhaDetailsScreen({super.key});

  late ZerodhaProvider zerodhaProvider;
  late NavigationProvider navigationProvider;

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    zerodhaProvider = Provider.of<ZerodhaProvider>(context, listen: true);
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
                              "lib/manage_brokers/assets/zerodha.jpeg",
                              height: 35,
                              width: 35,
                            ),

                            SizedBox(
                                width: 10
                            ),

                            Text(
                              "Zerodha",
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
                                  controller: zerodhaProvider.zerodhaApiKeyTextController,
                                  borderRadius: 5,

                                  currencyFormat: false,
                                  isFilled: true,
                                  elevation: 0,
                                  isLabelEnabled: false,
                                  borderWidth: 1,
                                  fillColor: Color(0xff2c2c31),// Colors.transparent,
                                  contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),

                                  onChanged: (value) {
                                    zerodhaProvider.redirectUrl = zerodhaProvider.baseUrl + value;
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

                                (zerodhaProvider.zerodhaApiKeyFieldError == "")
                                    ? Container()
                                    : Text(zerodhaProvider.zerodhaApiKeyFieldError,
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
                              "Api Secret",
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
                                  controller: zerodhaProvider.zerodhaApiSecretTextController,
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
                                  labelText: "Enter Api Secret",
                                  hintText: "Enter Api Secret",
                                  counterText: "",

                                  overrideHintText: true,

                                  focusedBorderColor: Colors.white,
                                  isPasswordField: false,

                                  isEnabled: true,
                                  // showLeadingWidget: true,

                                  validator: (value) {

                                  },
                                ),
                                (zerodhaProvider.zerodhaApiSecretFieldError == "")
                                    ? Container()
                                    : Text(zerodhaProvider.zerodhaApiSecretFieldError,
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
                              "Redirect URL",
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: screenWidth - 80,
                                      child: IgnorePointer(
                                        child: MyTextField(

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
                                          labelText: zerodhaProvider.redirectUrl,
                                          hintText: zerodhaProvider.redirectUrl,
                                          counterText: "",

                                          overrideHintText: true,

                                          focusedBorderColor: Colors.white,
                                          isPasswordField: false,

                                          isEnabled: true,
                                          // showLeadingWidget: true,
                                          validator: (value) {

                                          },
                                        ),
                                      ),
                                    ),

                                    InkWell(
                                      onTap: () {
                                        print("copy");
                                        Clipboard.setData(ClipboardData(text: zerodhaProvider.redirectUrl));
                                        Fluttertoast.showToast(
                                            msg: "Copied to clipboard",
                                            backgroundColor: Colors.green);
                                      },
                                      child: Icon(
                                        Icons.copy,
                                        color: (zerodhaProvider.redirectUrl.isNotEmpty)
                                            ?Colors.white:Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),

                                (zerodhaProvider.redirectUrl.isEmpty)
                                    ? Container()
                                    : Text("Note: Copy and paste the above URL and log in. You will then receive a request token. Copy and paste that token in the field below to complete the Zerodha login.",
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
                              "Request Token",
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
                                  controller: zerodhaProvider.zerodhaRquestTokenTextController,
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
                                  labelText: "Enter Request Token",
                                  hintText: "Enter Request Token",
                                  counterText: "",

                                  overrideHintText: true,

                                  focusedBorderColor: Colors.white,
                                  isPasswordField: false,

                                  isEnabled: true,
                                  // showLeadingWidget: true,

                                  validator: (value) {

                                  },
                                ),
                                (zerodhaProvider.zerodhaRquestTokenFieldError == "")
                                    ? Container()
                                    : Text(zerodhaProvider.zerodhaRquestTokenFieldError,
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
                              if(zerodhaProvider.zerodhaApiKeyTextController.text == "") {
                                zerodhaProvider.zerodhaApiKeyFieldError = "Please enter api key";
                              }

                              if(zerodhaProvider.zerodhaApiSecretTextController.text == "") {
                                zerodhaProvider.zerodhaApiSecretFieldError = "Please enter api secret";
                              }

                              if(zerodhaProvider.zerodhaRquestTokenTextController.text == "") {
                                zerodhaProvider.zerodhaRquestTokenFieldError = "Please enter request token";
                              }


                              if(zerodhaProvider.zerodhaApiKeyTextController.text != "" &&
                                  zerodhaProvider.zerodhaApiSecretTextController.text != "" &&
                                  zerodhaProvider.zerodhaRquestTokenTextController.text != ""
                              ) {

                                final value = await zerodhaProvider.doZerodhaLogin();
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
                            child: (zerodhaProvider.buttonLoading)
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
