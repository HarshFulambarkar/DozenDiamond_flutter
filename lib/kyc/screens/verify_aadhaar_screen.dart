import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../provider/kyc_provider.dart';
import '../utility/utils.dart';
import '../widgets/custom_bottom_sheets.dart';
import '../widgets/my_text_field.dart';
import 'aadhaar_ui_screen.dart';
import 'enter_verification_opt.dart';

class VerifyAadhaarScreen extends StatelessWidget {

  late KycProvider kycProvider;
  late ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    kycProvider = Provider.of<KycProvider>(context, listen: true);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Container(
                  color: (themeProvider.defaultTheme)
                      ? Colors.white:Colors.black,
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
                        child: Text(
                          "Verify Aadhaar Card",
                          style: TextStyle(
                              fontSize: 25,
                              color: (themeProvider.defaultTheme)
                                  ?Colors.black
                                  :Color(0xFFffffff),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      verifyAdharWidget(context),
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
      bottomSheet: Container(
        color: (themeProvider.defaultTheme)
            ?Color(0xFF15181F)
            :Color(0xFF15181F),
        height: 100,
        width: screenWidth,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 18, right: 16.0),
            child: InkWell(
              onTap: () async {
                if(kycProvider.isLoading == false){
                  if(kycProvider.aadharFrontImage.path == "" && kycProvider.aadharCardController.text.isEmpty){
                    Utility.showSingleTextToast("upload Aadhaar Image or enter adhar number");
                  }else if(kycProvider.aadharCardController.text.isEmpty){
                    Utility.showSingleTextToast("enter Aadhaar Number");
                  }else if(kycProvider.aadharCardController.text.length < 12){
                    Utility.showSingleTextToast("enter Valid Aadhaar Number");
                  }else{
                    // CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
                    //     EnterVerificationOpt(), context,
                    //     height: 230, enableDrag: true);



                    // Navigator.of(context).pushReplacement(
                    //   // widget.activityContext,
                    //   MaterialPageRoute(
                    //     builder: (_) => AadhaarUiScreen(),
                    //   ),
                    // );
                    kycProvider.sendAadhaarOtp(context);
                    if(true){

                    }else{
                      Utility.showSingleTextToast("something Went Wrong");
                    }

                  }

                }


              },
              child: Container(
                decoration:  BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [Colors.blue, Colors.blue]
                    // :[Constants.secondaryColorWithOpacity, Constants.blackColorWithOpacity]
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 16),
                      child: (kycProvider.isLoading == true)?Container(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ):Text(
                        "Verify",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget verifyAdharWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // ElevatedButton(
          //   onPressed: () {
          //     kycProvider.pickImageAndRecognizeText();
          //   },
          //   child: Text('Pick Image and Recognize Text'),
          // ),
          // SizedBox(height: 20),
          // ElevatedButton(
          //   onPressed: () {
          //     kycProvider.clickImageAndRecognizeText();
          //   },
          //   child: Text('Click Image and Recognize Text'),
          // ),
          // SizedBox(height: 20),
          // Text(
          //     kycProvider.recognizedText,
          //   style: TextStyle(
          //     fontSize: 18,
          //     color: Colors.black
          //   )
          // ),

          SizedBox(height: 20),

          MyTextField(
            fillColor: (themeProvider.defaultTheme)
                ?Color(0xffCACAD3):Color(0xff2c2c31),
            borderColor: (themeProvider.defaultTheme)
                ?Color(0xffCACAD3):Color(0xff2c2c31),
            textStyle: TextStyle(
              color: (themeProvider.defaultTheme)
                  ?Colors.black:Colors.white,
            ),
            // focusNode: _focusNode,
            margin: EdgeInsets.zero,
            elevation: 0,
            scrollPadding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom
            ),
            // margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            controller: kycProvider.aadharCardController,
            borderRadius: 8,
            isFilled: true,
            counterText: "",
            maxLength: 12,
            // elevation: 0,
            // fillColor: Colors.transparent,
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            onChanged: (value) {},
            // labelStyle: const TextStyle(
            //   fontSize: 15,
            //   color: Constanpts.accentColor
            // ),
            // borderColor: (themeProvider.defaultTheme)
            //     ?Colors.black
            //     :Color(0xffE2E2E2),
            labelText: "",
            hintText: "Enter aadhar card number",
            hintTextStyle: TextStyle(
                color: (themeProvider.defaultTheme)
                    ?Colors.black
                    :Colors.white
            ),
            labelStyle: TextStyle(
              color: (themeProvider.defaultTheme)
                  ?Colors.black
                  :Colors.white,
            ),
            // maxLength: 10,
            // isLabelEnabled: false,
            leading: Padding(
              padding: EdgeInsets.fromLTRB(20, 15, 10, 15),
              child: Text(
                "",
                style: TextStyle(
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)
                        ?Colors.black
                        :Colors.white
                ),
              ),
            ),
            overrideHintText: true,
            // hintTextStyle: TextStyles.hintStyle,
            focusedBorderColor: (themeProvider.defaultTheme)
                ?Colors.black
                :Colors.white,
            isPasswordField: false,
            borderWidth: 1,
            // leading: const Icon(
            //   Icons.subject,
            //   color: Constant.textColorDescription,
            //   size: 25,
            // ),
            isEnabled: true,
            showLeadingWidget: false,
            // textStyle: TextStyle(
            //     fontSize: 14,
            //     color: (themeProvider.defaultTheme)
            //         ?Colors.black
            //         :Colors.white
            // ),

            keyboardType: TextInputType.number,
            // validator: (value) {
            //   if (value!.isEmpty) {
            //     // return TranslationKeys.enterPhoneNumber;
            //   }else if(value.length > 10){
            //     return TranslationKeys.enterValidNumber;
            //   }
            //   return null;
            // },
          ),

          SizedBox(
            height: 16,
          ),

          aadhaarCardSection(context),


        ],
      ),
    );
  }

  Widget aadhaarCardSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0.0, right: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Upload Aadharcard Image",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: (themeProvider.defaultTheme)
                        ?Colors.black
                        :Colors.white
                ),
              ),

              Row(
                children: [
                  (kycProvider.aadharFrontImage.path != "")// && kycProvider.aadharBackImage.path != "")
                      ?Container():InkWell(
                    onTap: () async {
                      final image = await kycProvider.picker.pickImage(source: ImageSource.gallery, imageQuality: 40);
                      print("image extenstion");
                      print(image!.path.split(".").last);
                      if(image.path.split(".").last == "png" || image.path.split(".").last == "PNG" || image.path.split(".").last == "jpeg" || image.path.split(".").last == "jpg"){
                        // verificationController.droneImage1.value = File(image.path);
                        if(kycProvider.aadharFrontImage.path == ""){
                          kycProvider.aadharFrontImage = File(image.path);
                          kycProvider.recognizedText = await kycProvider.recognizeTextFromImage(XFile(image.path));
                          String extractedAadhaarNumber = kycProvider.extractAadhaarNumber(kycProvider.recognizedText);
                          kycProvider.aadharCardController.text = extractedAadhaarNumber.replaceAll(" ", "");

                        }else{
                          kycProvider.aadharBackImage = File(image.path);
                        }



                      }else{
                        // Utility.showToastSuccess(TranslationKeys.invalidImageFormat, TranslationKeys.imageShouldBeEitherPngJpgOrJpegFormat);
                      }
                    },
                    child: Icon(
                      Icons.upload,
                      size: 24,
                      color: (themeProvider.defaultTheme)
                          ?Colors.black
                          :Colors.white,
                    ),
                  ),

                  SizedBox(
                    width: 10,
                  ),

                  (kycProvider.aadharFrontImage.path != "")// && kycProvider.aadharBackImage.path != "")
                      ?Container():InkWell(
                    onTap: () async {
                      final image = await kycProvider.picker.pickImage(source: ImageSource.camera, imageQuality: 40);
                      print("image extenstion");
                      print(image!.path.split(".").last);
                      if(image.path.split(".").last == "png" || image.path.split(".").last == "PNG" || image.path.split(".").last == "jpeg" || image.path.split(".").last == "jpg"){
                        // verificationController.droneImage1.value = File(image.path);
                        if(kycProvider.aadharFrontImage.path == ""){
                          kycProvider.aadharFrontImage = File(image.path);
                          kycProvider.recognizedText = await kycProvider.recognizeTextFromImage(XFile(image.path));
                          String extractedAadhaarNumber = kycProvider.extractAadhaarNumber(kycProvider.recognizedText);
                          kycProvider.aadharCardController.text = extractedAadhaarNumber.replaceAll(" ", "");

                        }else{
                          kycProvider.aadharBackImage = File(image.path);
                        }



                      }else{
                        // Utility.showToastSuccess(TranslationKeys.invalidImageFormat, TranslationKeys.imageShouldBeEitherPngJpgOrJpegFormat);
                      }
                    },
                    child: Icon(
                      Icons.camera_alt,
                      size: 22,
                      color: (themeProvider.defaultTheme)
                          ?Colors.black
                          :Colors.white,
                    ),
                  ),
                ],
              )


            ],
          ),

          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Text(
              "Please upload the Aadhaar image in Png or Jpg format",
              textScaleFactor: 0.9,
              style: TextStyle(
                  fontSize: 10,
                color: (themeProvider.defaultTheme)
                    ?Colors.black
                    :Colors.white,
              ),
            ),
          ),


          (kycProvider.aadharFrontImage.path == "")?Container():SizedBox(
            height: 16,
          ),



          (kycProvider.aadharFrontImage.path == "")?Container():Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: (kycProvider.aadharFrontImage.path != "link")?Image.file(
                  kycProvider.aadharFrontImage,
                  fit: BoxFit.fill,

                ):Image.network(
                  kycProvider.aadharFrontImageLink,
                  fit: BoxFit.fill,
                ),
              ),

              SizedBox(
                height: 12,
              ),

              Text(
                "Aadhaar Front Image",
                textScaleFactor: 0.9,
                style: TextStyle(
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)
                        ?Colors.black
                        :Colors.white
                ),
              ),

              SizedBox(
                height: 4,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      "${kycProvider.aadharFrontImage.path.split('/').last}",
                      textScaleFactor: 0.9,
                      style: TextStyle(
                          fontSize: 10,
                          color: (themeProvider.defaultTheme)
                              ?Colors.black
                              :Colors.white
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          kycProvider.aadharFrontImage = File("");
                        },
                        child: Icon(
                          Icons.delete,
                          size: 16,
                          color: (themeProvider.defaultTheme)
                              ?Colors.black
                              :Colors.white,
                        ),
                      ),

                      SizedBox(
                        width: 16,
                      ),

                      Icon(
                        Icons.check,
                        size: 16,
                        color:  (themeProvider.defaultTheme)
                              ?Colors.black
                              :Colors.white
                      )
                    ],
                  )
                ],
              ),

              SizedBox(
                height: 4,
              ),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color(0xff219994),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.circle,
                      color: Colors.transparent,
                      size: 4,
                    ),

                  ],
                ),
              )
            ],
          ),

          (kycProvider.aadharBackImage.path == "")?Container():SizedBox(
            height: 16,
          ),


          (kycProvider.aadharBackImage.path == "")?Container():Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: (kycProvider.aadharBackImage.path != "link")?Image.file(
                  kycProvider.aadharBackImage,
                  fit: BoxFit.fill,

                ):Image.network(
                  kycProvider.aadharBackImageLink,
                  fit: BoxFit.fill,
                ),
              ),

              SizedBox(
                height: 12,
              ),

              Text(
                "Aadhaar Back Image",
                textScaleFactor: 0.9,
                style: TextStyle(
                    fontSize: 14,
                    color: (themeProvider.defaultTheme)
                        ?Colors.black
                        :Colors.white
                ),
              ),

              SizedBox(
                height: 4,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      "${kycProvider.aadharBackImage.path.split('/').last}",
                      textScaleFactor: 0.9,
                      style: TextStyle(
                          fontSize: 10,
                        color: (themeProvider.defaultTheme)
                            ?Colors.black
                            :Colors.white
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          kycProvider.aadharBackImage = File("");
                        },
                        child: Icon(
                          Icons.delete,
                          size: 16,
                          color:  (themeProvider.defaultTheme)
                                ?Colors.black
                                :Colors.white
                        ),
                      ),

                      SizedBox(
                        width: 16,
                      ),

                      Icon(
                        Icons.check,
                        size: 16,
                        color: (themeProvider.defaultTheme)
                            ?Colors.black
                            :Colors.white
                      )
                    ],
                  )
                ],
              ),

              SizedBox(
                height: 4,
              ),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color(0xff219994),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.circle,
                      color: Colors.transparent,
                      size: 4,
                    ),

                  ],
                ),
              )
            ],
          ),


          SizedBox(
            height: 24,
          ),

          Divider(
            color: (themeProvider.defaultTheme)
                ?Colors.black
                :Color(0xffD2D2D2),
          ),
        ],
      ),
    );
  }


}
