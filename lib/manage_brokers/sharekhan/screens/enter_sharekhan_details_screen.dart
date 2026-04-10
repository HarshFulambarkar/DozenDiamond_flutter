import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../../DD_Navigation/widgets/common_screen.dart';
import '../../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../../global/functions/screenWidthRecoginzer.dart';
import '../../../global/widgets/my_text_field.dart';
import '../stateManagement/sharekhan_provider.dart';

class EnterSharekhanDetailsScreen extends StatelessWidget {
  EnterSharekhanDetailsScreen({super.key});

  late SharekhanProvider sharekhanProvider;
  late NavigationProvider navigationProvider;

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    sharekhanProvider = Provider.of<SharekhanProvider>(context, listen: true);
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
                      SizedBox(height: 45),

                      SizedBox(height: 10),

                      // SizedBox(
                      //   height: AppBar().preferredSize.height * 1.5,
                      // ),
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 5, 0),
                        child: Row(
                          children: [
                            Image.asset(
                              "lib/manage_brokers/assets/sherkhan.jpg",
                              height: 35,
                              width: 35,
                            ),

                            SizedBox(width: 10),

                            Text(
                              "Sharekhan",
                              style: TextStyle(
                                fontSize: 25,
                                color: Color(0xFFffffff),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Api Key",
                              style: TextStyle(
                                color: Color(0xFFffffff),
                                fontSize: 18,
                              ),
                            ),

                            SizedBox(height: 5),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyTextField(
                                  controller: sharekhanProvider
                                      .sharekhanApiKeyTextController,
                                  borderRadius: 5,

                                  currencyFormat: false,
                                  isFilled: true,
                                  elevation: 0,
                                  isLabelEnabled: false,
                                  borderWidth: 1,
                                  fillColor: Color(
                                    0xff2c2c31,
                                  ), // Colors.transparent,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                    20,
                                    5,
                                    20,
                                    5,
                                  ),

                                  onChanged: (value) {
                                    sharekhanProvider.redirectUrl =
                                        sharekhanProvider.baseUrl + value;
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
                                  validator: (value) {},
                                ),

                                (sharekhanProvider.sharekhanApiKeyFieldError ==
                                    "")
                                    ? Container()
                                    : Text(
                                  sharekhanProvider
                                      .sharekhanApiKeyFieldError,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Totp Secret",
                              // "PIN",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFFffffff),
                              ),
                            ),

                            SizedBox(height: 5),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyTextField(
                                  // controller: createLadderEasyProvider.targetTextEditingController,
                                  borderRadius: 5,
                                  controller: sharekhanProvider
                                      .sharekhanTotpSecretTextController,
                                  currencyFormat: false,
                                  isFilled: true,
                                  elevation: 0,
                                  isLabelEnabled: false,
                                  borderWidth: 1,
                                  fillColor: Color(
                                    0xff2c2c31,
                                  ), // Colors.transparent,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                    20,
                                    5,
                                    20,
                                    5,
                                  ),

                                  onChanged: (value) {},
                                  borderColor: Colors.white,
                                  labelText: "Enter Totp Secret",
                                  hintText: "Enter Totp Secret",
                                  counterText: "",

                                  overrideHintText: true,

                                  focusedBorderColor: Colors.white,
                                  isPasswordField: false,

                                  isEnabled: true,

                                  // showLeadingWidget: true,
                                  validator: (value) {},
                                ),
                                (sharekhanProvider
                                    .sharekhanTotpSecretFieldError ==
                                    "")
                                    ? Container()
                                    : Text(
                                  sharekhanProvider
                                      .sharekhanTotpSecretFieldError,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              // "TOTP",
                              "Login Id",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFFffffff),
                              ),
                            ),

                            SizedBox(height: 5),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyTextField(
                                  controller: sharekhanProvider
                                      .sharekhanLoginIdTextController,
                                  borderRadius: 5,
                                  currencyFormat: false,
                                  isFilled: true,
                                  elevation: 0,
                                  isLabelEnabled: false,
                                  borderWidth: 1,
                                  fillColor: Color(
                                    0xff2c2c31,
                                  ), // Colors.transparent,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                    20,
                                    5,
                                    20,
                                    5,
                                  ),

                                  onChanged: (value) {},
                                  borderColor: Colors.white,
                                  // labelText: "Enter TOTP",
                                  // hintText: "Enter TOTP",
                                  labelText: "Enter Login Id",
                                  hintText: "Enter Login Id",
                                  counterText: "",

                                  overrideHintText: true,

                                  focusedBorderColor: Colors.white,
                                  isPasswordField: false,

                                  isEnabled: true,

                                  // showLeadingWidget: true,
                                  validator: (value) {},
                                ),
                                (sharekhanProvider.sharekhanLoginIdFieldError ==
                                    "")
                                    ? Container()
                                    : Text(
                                  sharekhanProvider
                                      .sharekhanLoginIdFieldError,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              // "TOTP",
                              "Password",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFFffffff),
                              ),
                            ),

                            SizedBox(height: 5),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyTextField(
                                  controller: sharekhanProvider
                                      .sharekhanPasswordTextController,
                                  borderRadius: 5,
                                  currencyFormat: false,
                                  isFilled: true,
                                  elevation: 0,
                                  isLabelEnabled: false,
                                  borderWidth: 1,
                                  fillColor: Color(
                                    0xff2c2c31,
                                  ), // Colors.transparent,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                    20,
                                    5,
                                    20,
                                    5,
                                  ),

                                  onChanged: (value) {},
                                  borderColor: Colors.white,
                                  // labelText: "Enter TOTP",
                                  // hintText: "Enter TOTP",
                                  labelText: "Enter password",
                                  hintText: "Enter password",
                                  counterText: "",

                                  overrideHintText: true,

                                  focusedBorderColor: Colors.white,
                                  isPasswordField: false,

                                  isEnabled: true,

                                  // showLeadingWidget: true,
                                  validator: (value) {},
                                ),
                                (sharekhanProvider
                                    .sharekhanPasswordFieldError ==
                                    "")
                                    ? Container()
                                    : Text(
                                  sharekhanProvider
                                      .sharekhanPasswordFieldError,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              // "TOTP",
                              "Secret Key",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFFffffff),
                              ),
                            ),

                            SizedBox(height: 5),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyTextField(
                                  controller: sharekhanProvider
                                      .sharekhanSecretKeyTextController,
                                  borderRadius: 5,
                                  currencyFormat: false,
                                  isFilled: true,
                                  elevation: 0,
                                  isLabelEnabled: false,
                                  borderWidth: 1,
                                  fillColor: Color(
                                    0xff2c2c31,
                                  ), // Colors.transparent,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                    20,
                                    5,
                                    20,
                                    5,
                                  ),

                                  onChanged: (value) {},
                                  borderColor: Colors.white,
                                  // labelText: "Enter TOTP",
                                  // hintText: "Enter TOTP",
                                  labelText: "Enter secret Key",
                                  hintText: "Enter secret Key",
                                  counterText: "",

                                  overrideHintText: true,

                                  focusedBorderColor: Colors.white,
                                  isPasswordField: false,

                                  isEnabled: true,

                                  // showLeadingWidget: true,
                                  validator: (value) {},
                                ),
                                (sharekhanProvider
                                    .sharekhanSecretKeyFieldError ==
                                    "")
                                    ? Container()
                                    : Text(
                                  sharekhanProvider
                                      .sharekhanSecretKeyFieldError,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              side: const BorderSide(color: Color(0xFF0099CC)),
                            ),
                            onPressed: () async {
                              if (sharekhanProvider
                                  .sharekhanApiKeyTextController
                                  .text ==
                                  "") {
                                sharekhanProvider.sharekhanApiKeyFieldError =
                                "Please enter api key";
                              }

                              if (sharekhanProvider
                                  .sharekhanTotpSecretTextController
                                  .text ==
                                  "") {
                                sharekhanProvider
                                    .sharekhanTotpSecretFieldError =
                                "Please enter totp secret";
                              }

                              if (sharekhanProvider
                                  .sharekhanLoginIdTextController
                                  .text ==
                                  "") {
                                sharekhanProvider.sharekhanLoginIdFieldError =
                                "Please enter Login Id";
                              }
                              if (sharekhanProvider
                                  .sharekhanPasswordTextController
                                  .text ==
                                  "") {
                                sharekhanProvider.sharekhanPasswordFieldError =
                                "Please enter Password";
                              }
                              if (sharekhanProvider
                                  .sharekhanSecretKeyTextController
                                  .text ==
                                  "") {
                                sharekhanProvider.sharekhanSecretKeyFieldError =
                                "Please enter Secret Key";
                              }

                              if (sharekhanProvider
                                  .sharekhanApiKeyTextController
                                  .text !=
                                  "" &&
                                  sharekhanProvider
                                      .sharekhanTotpSecretTextController
                                      .text !=
                                      "" &&
                                  sharekhanProvider
                                      .sharekhanLoginIdTextController
                                      .text !=
                                      "" &&
                                  sharekhanProvider
                                      .sharekhanPasswordTextController
                                      .text !=
                                      "" &&
                                  sharekhanProvider
                                      .sharekhanSecretKeyTextController
                                      .text !=
                                      "") {
                                final value = await sharekhanProvider
                                    .doSharekhanLogin();
                                if (value) {
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
                            child: (sharekhanProvider.buttonLoading)
                                ? Padding(
                              padding: const EdgeInsets.only(
                                left: 12,
                                right: 12,
                                bottom: 8,
                                top: 8.0,
                              ),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                                : Text(
                              'Save Details',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Color(0xFFffffff)),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}