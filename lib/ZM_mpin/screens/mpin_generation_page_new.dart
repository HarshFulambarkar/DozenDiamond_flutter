import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../create_ladder_easy/widgets/custom_container.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/widgets/error_dialog.dart';
import '../../navigateAuthentication/stateManagement/navigate_authentication_provider.dart';
import '../models/get_mpin_request.dart';
import '../services/mpin_rest_api_service.dart';

class MpinGenerationPageNew extends StatefulWidget {
  const MpinGenerationPageNew({super.key, required this.regId});
  final int regId;

  @override
  State<MpinGenerationPageNew> createState() => _MpinGenerationPageNewState();
}

class _MpinGenerationPageNewState extends State<MpinGenerationPageNew> {

  late NavigateAuthenticationProvider navigateAuthenticationProvider;

  bool _isObscure = true;
  bool _isObscure2 = true;

  final textEditingController = TextEditingController();
  final textEditingController2 = TextEditingController();

  bool showMpinFieldError = false;
  bool showMpinFieldError2 = false;

  String mpinFieldError = "";
  String mpinFieldError2 = "";

  ApiStateProvider? _apiStateProvider;

  bool submitMpinButtonLoading = false;

  @override
  void initState() {
    super.initState();
    _apiStateProvider = Provider.of(context, listen: false);
  }

  Future<void> _submitUserMpin() async {
    if (textEditingController.text.length < 6) return;
    setState(() {
      submitMpinButtonLoading = true;
    });

    // progressbar(context);
    final pref = await SharedPreferences.getInstance();
    MpinRestApiService()
        .generateNewMpinRequest(
      GetMpinRequest(
        userId: widget.regId.toString(),
        mPinNo: textEditingController.text,
        confirmMpinNo: textEditingController.text,
      ),
    )
        .then((value) {
      Navigator.of(context).canPop();
      setState(() {
        submitMpinButtonLoading = false;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
            side: const BorderSide(
              color: Colors.white,
              width: 1,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          backgroundColor: const Color(0xFF15181F),
          content: Text(
            value?.message ?? "Something went wrong",
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (value!.status!) {
                  Fluttertoast.showToast(
                      msg:
                      'M-pin generated successfully. Enter M-pin to Login');
                  pref.setInt("reg_id", widget.regId);
                  navigateAuthenticationProvider.previousIndex =
                      navigateAuthenticationProvider.selectedIndex;
                  navigateAuthenticationProvider.selectedIndex = 3;
                  // Navigator.of(context).pushReplacement(MaterialPageRoute(
                  //   builder: (context) {
                  //     return const MpinValidatorPage(fetchUserData: true);
                  //   },
                  // ));
                }
              },
              child: const Text(
                "Ok",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      );
    }).catchError((err) {
      setState(() {
        submitMpinButtonLoading = false;
      });

      textEditingController.clear();
      textEditingController2.clear();
      Navigator.canPop(context);
      restApiErrorDialog(context,
          error: err, apiState: _apiStateProvider!, action: _submitUserMpin);
    });
  }

  @override
  Widget build(BuildContext context) {
    navigateAuthenticationProvider =
        Provider.of<NavigateAuthenticationProvider>(context, listen: true);
    double screenWidth = screenWidthRecognizer(context);
    return Center(
        child: Container(
            width: screenWidth,
            child: Scaffold(
              backgroundColor: Colors.transparent,
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
                      "Generate MPIN",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Britanica",
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    SizedBox(
                      width: screenWidth - 34,
                      child: Text(
                        "Please enter a 6-digit MPIN. This pin is your personal key - keep it safe and don't share it with anyone!",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 15,
                    ),

                    buildMpinSection(context, screenWidth),

                    SizedBox(
                      height: 15,
                    ),

                    buildReEnterMpinSection(context, screenWidth),

                    SizedBox(
                      height: 10,
                    ),


                  ],
                ),
              ),

              bottomNavigationBar: buildBottomNavigationSection(context, screenWidth),
            )
        )
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
          keyboardType: TextInputType.number,
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

  Widget buildReEnterMpinSection(BuildContext context, screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Re-enter MPIN",
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w300
              ),
            ),

            InkWell(
              child: Icon(
                _isObscure2
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.white,
              ),
              onTap: () {
                setState(() {
                  _isObscure2 = !_isObscure2;
                });
              },
            )
          ],
        ),

        SizedBox(
            height: 5
        ),

        PinCodeTextField(
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly
          ],
          length: 6,
          obscureText: _isObscure2,
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
          controller: textEditingController2,
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



        (showMpinFieldError2)?SizedBox(
          height: 3,
        ):Container(),

        (showMpinFieldError2)?Text(
          mpinFieldError2,
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
                    if(textEditingController.text.length >= 6 && textEditingController.text == textEditingController2.text){
                      await _submitUserMpin();
                    } else {

                      if(textEditingController.text.length < 6) {
                        showMpinFieldError = true;
                        mpinFieldError = "Enter Mpin";
                      } if (textEditingController.text != textEditingController2.text) {
                        showMpinFieldError2 = true;
                        mpinFieldError2 = "Please make sure the MPINs match.";
                      }

                      setState(() {

                      });
                    }
                  },
                  backgroundColor: Color(0xfff0f0f0),
                  borderRadius: 12,
                  height: 52,
                  width: screenWidth - 34,
                  child: Center(
                    child: (submitMpinButtonLoading)?CircularProgressIndicator():Text(
                      "Confirm MPIN",
                      style: GoogleFonts.poppins(
                          color: Colors.black,
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
