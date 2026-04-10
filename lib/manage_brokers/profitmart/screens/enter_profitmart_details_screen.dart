import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../../DD_Navigation/widgets/common_screen.dart';
import '../../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../../global/functions/screenWidthRecoginzer.dart';
import '../../../global/widgets/my_text_field.dart';
import '../stateManagement/profitmart_provider.dart';

class EnterProfitmartDetailsScreen extends StatelessWidget {
  EnterProfitmartDetailsScreen({super.key});

  late ProfitmartProvider profitmartProvider;
  late NavigationProvider navigationProvider;

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    profitmartProvider = Provider.of<ProfitmartProvider>(context, listen: true);
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
                              "lib/manage_brokers/assets/profitmart.jpeg",
                              height: 35,
                              width: 35,
                            ),

                            SizedBox(
                                width: 10
                            ),

                            Text(
                              "Profitmart",
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
                                  controller: profitmartProvider.profitmartUserIdTextController,
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
                                  labelText: "Enter User ID",
                                  hintText: "Enter User ID",
                                  counterText: "",

                                  overrideHintText: true,

                                  focusedBorderColor: Colors.white,
                                  isPasswordField: false,

                                  isEnabled: true,
                                  // showLeadingWidget: true,

                                  validator: (value) {

                                  },
                                ),

                                (profitmartProvider.profitmartUserIdFieldError == "")
                                    ? Container()
                                    : Text(profitmartProvider.profitmartUserIdFieldError,
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
                                  controller: profitmartProvider.profitmartPasswordTextController,
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
                                (profitmartProvider.profitmartPasswordFieldError == "")
                                    ? Container()
                                    : Text(profitmartProvider.profitmartPasswordFieldError,
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
                              "Date of Birth",
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
                                InkWell(
                                  onTap: () async {
                                    DateTime maxDob = DateTime.now();
                                    DateTime? picked = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime(maxDob.year - 18, maxDob.month, maxDob.day),
                                        firstDate: DateTime(maxDob.year - 50, maxDob.month, maxDob.day),
                                        lastDate: DateTime.now(),
                                        builder: (BuildContext context, Widget? child) {
                                          return Theme(
                                            data: ThemeData.light().copyWith(
                                              primaryColor:
                                              Colors.blue, // Deprecated, can be removed if not necessary
                                              colorScheme: ColorScheme.light(
                                                primary: Colors.blue,
                                                secondary: Colors.blue, // Replaces accentColor
                                              ),
                                              buttonTheme: ButtonThemeData(
                                                textTheme: ButtonTextTheme.primary,
                                              ),
                                            ),
                                            child: child ?? const SizedBox(), // Null safety check
                                          );
                                        });
                                    if (picked != null) {
                                      DateTime seletedDate = picked;
                                      profitmartProvider.profitmartDOBTextController.text = DateFormat('dd-MM-yyyy').format(picked);
                                    }
                                  },
                                  child: IgnorePointer(
                                    child: MyTextField(
                                      controller: profitmartProvider.profitmartDOBTextController,
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
                                      labelText: "DD-MM-YYYY",
                                      hintText: "DD-MM-YYYY",
                                      counterText: "",

                                      overrideHintText: true,

                                      focusedBorderColor: Colors.white,
                                      isPasswordField: false,

                                      isEnabled: true,
                                      keyboardType: TextInputType.datetime,
                                      // showLeadingWidget: true,

                                      validator: (value) {

                                      },
                                    ),
                                  ),
                                ),
                                (profitmartProvider.profitmartDOBFieldError == "")
                                    ? Container()
                                    : Text(profitmartProvider.profitmartDOBFieldError,
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
                                  controller: profitmartProvider.profitmartVendorCodeTextController,
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
                                  labelText: "Vendor Code",
                                  hintText: "Vendor Code",
                                  counterText: "",

                                  overrideHintText: true,

                                  focusedBorderColor: Colors.white,
                                  isPasswordField: false,

                                  isEnabled: true,
                                  // showLeadingWidget: true,

                                  validator: (value) {

                                  },
                                ),
                                (profitmartProvider.profitmartVendorCodeFieldError == "")
                                    ? Container()
                                    : Text(profitmartProvider.profitmartVendorCodeFieldError,
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
                              "Vendor Key",
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
                                  controller: profitmartProvider.profitmartVendorKeyTextController,
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
                                  labelText: "Vendor Key",
                                  hintText: "Vendor Key",
                                  counterText: "",

                                  overrideHintText: true,

                                  focusedBorderColor: Colors.white,
                                  isPasswordField: false,

                                  isEnabled: true,
                                  // showLeadingWidget: true,

                                  validator: (value) {

                                  },
                                ),
                                (profitmartProvider.profitmartVendorKeyFieldError == "")
                                    ? Container()
                                    : Text(profitmartProvider.profitmartVendorKeyFieldError,
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
                              if(profitmartProvider.profitmartUserIdTextController.text == "") {
                                profitmartProvider.profitmartUserIdFieldError = "Please enter user id";
                              }

                              if(profitmartProvider.profitmartPasswordTextController.text == "") {
                                profitmartProvider.profitmartPasswordFieldError = "Please enter Password";
                              }

                              if(profitmartProvider.profitmartDOBTextController.text == "") {
                                profitmartProvider.profitmartDOBFieldError = "Please enter DOB";
                              }

                              if(profitmartProvider.profitmartVendorCodeTextController.text == "") {
                                profitmartProvider.profitmartVendorCodeFieldError = "Please enter Vendor Code";
                              }

                              if(profitmartProvider.profitmartVendorKeyTextController.text == "") {
                                profitmartProvider.profitmartVendorKeyFieldError = "Please enter Vendor Key";
                              }

                              if(profitmartProvider.profitmartUserIdTextController.text != "" &&
                                  profitmartProvider.profitmartPasswordTextController.text != "" &&
                                  profitmartProvider.profitmartDOBTextController.text != "" &&
                                  profitmartProvider.profitmartVendorCodeTextController.text != "" &&
                                  profitmartProvider.profitmartVendorKeyTextController.text != ""
                              ) {

                                final value = await profitmartProvider.doProfitmartLogin();
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
                            child: (profitmartProvider.buttonLoading)
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
