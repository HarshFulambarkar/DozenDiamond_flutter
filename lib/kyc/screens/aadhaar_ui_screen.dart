import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../provider/kyc_provider.dart';
import '../utility/asset_constants.dart';


class AadhaarUiScreen extends StatelessWidget {

  late KycProvider kycProvider;
  late ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    kycProvider = Provider.of<KycProvider>(context, listen: true);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    double screenWidth = screenWidthRecognizer(context);
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
                      // SizedBox(
                      //   height: AppBar().preferredSize.height * 1.5,
                      // ),
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 5, 0),
                        child: Text(
                          "Aadhaar Card Verified Successfully",
                          style: TextStyle(
                              fontSize: 20,
                              color: (themeProvider.defaultTheme)
                                  ?Colors.black
                                  :Color(0xFFffffff),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: verifyAadhaarCardUi(context),
                      )
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

  Widget verifyAadhaarCardUi(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Column(
            children: [

              SizedBox(
                height: 10,
              ),

              Container(
                // height: 257,
                decoration: BoxDecoration(
                  color: (themeProvider.defaultTheme)
                      ?Colors.grey[100]
                      :Colors.black,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10),
                      bottom: Radius.circular(10)
                  ),
                  border: Border.all(
                      color: (themeProvider.defaultTheme)
                      ?Colors.white
                      :Colors.black,
                      width: 1),
                ),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage(AssetConstants.ashokaImage))
                          ),
                        ),

                        SizedBox(
                          width: 10,
                        ),

                        Column(
                          children: [
                            Container(           // orange rectangle box
                              margin: EdgeInsets.fromLTRB(0, 0, 30, 5),
                              height: 15,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.horizontal(left: Radius.circular(0),right: Radius.circular(100)),
                                color: Colors.orange,
                              ),
                              child: Text('Bharat Sarkar',style: TextStyle(color: Colors.black),textAlign: TextAlign.center,),
                            ),
                            Container(            // green rectangle box
                              height: 15,
                              width: 200,
                              margin:EdgeInsets.fromLTRB(20, 0, 0, 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.horizontal(left: Radius.circular(0),right: Radius.circular(100)),
                                color: Colors.lightGreen,
                              ),
                              child: Text('Government Of India',style: TextStyle(color: Colors.black),textAlign: TextAlign.center,),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: (themeProvider.defaultTheme)
                                ?Colors.black
                                :Colors.white),

                          ),
                          child: (kycProvider.aadhaarData.photoBase64 == null)?Container():Image.memory(
                              base64Decode(kycProvider.aadhaarData.photoBase64!.split(",").last)
                          ),
                        ),

                        const SizedBox(
                          width: 15,
                        ),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(

                                child: Container(
                                  width: screenWidthRecognizer(context) * 0.4,
                                  child: Text(
                                    kycProvider.aadhaarData.name ?? "NA",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight:
                                        FontWeight.bold,
                                      color: (themeProvider.defaultTheme)
                                          ?Colors.black
                                          :Colors.white,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                )
                            ),
                            Text(
                              'DOB: ${kycProvider.aadhaarData.dateOfBirth ?? "NA"}',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight:
                                  FontWeight.bold,
                                color: (themeProvider.defaultTheme)
                                    ?Colors.black
                                    :Colors.white,
                              ),
                              textAlign: TextAlign.left,
                            ),

                            Text(
                              kycProvider.aadhaarData.gender ?? "NA",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight:
                                  FontWeight.bold,
                                color: (themeProvider.defaultTheme)
                                    ?Colors.black
                                    :Colors.white,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),

                      ],
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Text(
                      kycProvider.aadharCardController.text,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        color: (themeProvider.defaultTheme)
                            ?Colors.black
                            :Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    Divider(thickness: 3,color: Colors.red,),

                    Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Text(
                          'MERA ADHAR, MERI PEHCHAAN',
                          style: TextStyle(
                              fontSize: 15,fontWeight: FontWeight.bold,color: (themeProvider.defaultTheme)
                              ?Colors.black
                              :Colors.white,),textAlign: TextAlign.center,)
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 40,
          ),

          Column(
            children: [

              Container(

                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: (themeProvider.defaultTheme)
                      ?Colors.white
                      :Colors.black,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10),bottom: Radius.circular(10)),
                  border: Border.all(color: (themeProvider.defaultTheme)
                      ?Colors.white
                      :Colors.black,width: 1),
                ),
                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(

                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage(AssetConstants.ashokaImage))
                          ),
                        ),
                        Column(
                          children: [
                            Container(           // orange rectangle box
                              margin: EdgeInsets.fromLTRB(0, 0, 30, 5),
                              height: 15,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.horizontal(left: Radius.circular(0),right: Radius.circular(100)),
                                color: Colors.orange,
                              ),
                              child: Text('Bharat Sarkar',style: TextStyle(color: Colors.black),textAlign: TextAlign.center,),
                            ),
                            Container(            // green rectangle box
                              height: 15,
                              width: 200,
                              margin:EdgeInsets.fromLTRB(20, 0, 0, 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.horizontal(left: Radius.circular(0),right: Radius.circular(100)),
                                color: Colors.lightGreen,
                              ),
                              child: Text('Government Of India',style: TextStyle(color: Colors.black),textAlign: TextAlign.center,),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          SizedBox(
                            width: 10,
                          ),

                          Container(
                            height: 140,
                            width: 250,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    margin: EdgeInsets.fromLTRB(0, 10, 40, 0),
                                    child: Text(
                                      'Address:',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        color: (themeProvider.defaultTheme)
                                            ?Colors.black
                                            :Colors.white,
                                      ),
                                      textAlign: TextAlign.left,)
                                ),
                                Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 40, 0),
                                    child: Text(
                                      '${kycProvider.aadhaarData.careOf ?? ""}, ${kycProvider.aadhaarData.postOfficeName ?? ""}, ${kycProvider.aadhaarData.state ?? ""}, ${kycProvider.aadhaarData.country ?? ""} - ${kycProvider.aadhaarData.pincode ?? ""}',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        color: (themeProvider.defaultTheme)
                                            ?Colors.black
                                            :Colors.white,
                                      ),
                                      textAlign: TextAlign.left,)
                                ),

                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Text(
                          kycProvider.aadharCardController.text,
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.center,)
                    ),

                    Divider(thickness: 3,color: Colors.red,),
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 15,
                              width: 30,
                              color: Colors.black,
                            ),
                            Container(
                              height: 15,
                              width: 30,
                              color: Colors.black,
                            ),
                            Container(
                              height: 15,
                              width: 30,
                              color: Colors.black,
                            )
                          ],
                        )
                    ),
                  ],
                ),

              ),
            ],
          ),
        ],
      ),
    );
  }
}