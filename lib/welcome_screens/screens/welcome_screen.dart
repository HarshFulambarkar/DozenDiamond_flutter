import 'dart:io';

import 'package:dozen_diamond/global/stateManagement/app_config_provider.dart';
import 'package:dozen_diamond/welcome_screens/models/welcome_screen_data.dart';
import 'package:dozen_diamond/welcome_screens/stateManagement/welcome_screens_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/widgets/custom_container.dart';
import '../../navigateAuthentication/screens/navigate_authentication_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late WelcomeScreensProvider welcomeScreensProvider;

  late AppConfigProvider appConfigProvider;

  void initState() {
    super.initState();
    appConfigProvider = Provider.of<AppConfigProvider>(context, listen: false);
    appConfigProvider.getAppConfig();
  }

  @override
  Widget build(BuildContext context) {
    welcomeScreensProvider =
        Provider.of<WelcomeScreensProvider>(context, listen: true);
    appConfigProvider = Provider.of<AppConfigProvider>(context, listen: true);
    if (appConfigProvider.appConfigData.data?.welcomeScreenData != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        welcomeScreensProvider.welcomeScreenData =
            appConfigProvider.appConfigData.data!.welcomeScreenData!;
      });
    }

    double screenWidth = screenWidthRecognizer(context);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: Center(
          child: Container(
            width: screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 90,
                  child: PageView.builder(
                      onPageChanged: (index) {
                        welcomeScreensProvider.selectedPageIndex = index;
                      },
                      controller: welcomeScreensProvider.pageController,
                      itemCount: welcomeScreensProvider.welcomeScreenData.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 60,
                              child: topImageSection(
                                  context,
                                  welcomeScreensProvider
                                      .welcomeScreenData[index], index),
                            ),
                            Expanded(
                              flex: 30,
                              child: middleTextSection(
                                  context,
                                  welcomeScreensProvider.welcomeScreenData[index],
                                  screenWidth),
                            ),
                          ],
                        );
                      }),
                ),
                Expanded(
                  flex: 8,
                  child: bottomButtonSection(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget topImageSection(
      BuildContext context, WelcomeScreenData welcomeScreensData, int index) {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: (kIsWeb == false)
            // ? FadeInImage(
            //     placeholder: AssetImage("lib/welcome_screens/assets/images/welcome_image_1.png"), // Your asset image
            //     image: NetworkImage(welcomeScreensData.imageUrl ?? ""),
            //     fit: BoxFit.cover,
            //     width: screenWidthRecognizer(context),
            //     imageErrorBuilder: (context, error, stackTrace) {
            //       // In case of an error loading the image
            //       return Image.asset(
            //         "lib/welcome_screens/assets/images/welcome_image_1.png",
            //         fit: BoxFit.cover,
            //         width: screenWidthRecognizer(context),
            //       );
            //     },
            //   )
            // : FadeInImage(
            //     placeholder: AssetImage(
            //         "lib/welcome_screens/assets/images/welcome_image_1.png"
            //     ), // Your asset image
            //     image: NetworkImage(welcomeScreensData.imageUrl ?? ""),
            //     fit: BoxFit.cover,
            //     width: screenWidthRecognizer(context),
            //     imageErrorBuilder: (context, error, stackTrace) {
            //       // In case of an error loading the image
            //       return Image.asset(
            //         "lib/welcome_screens/assets/images/welcome_image_1.png",
            //         fit: BoxFit.cover,
            //         width: screenWidthRecognizer(context),
            //       );
            //     },
            //   )
            ? Image.network(
                welcomeScreensData.imageUrl ?? "",
                // "https://dozendiamonds.com/app/wellcome_image_1.png",
                // "lib/welcome_screens/assets/images/wellcome_image_1.png",
                fit: BoxFit.cover,
                width: screenWidthRecognizer(context),
              )
            : Image.asset(
            // : Image.network(
                (index == 0)
                    ?"lib/welcome_screens/assets/images/welcome_image_1.png"
                    :(index == 1)
                    ?"lib/welcome_screens/assets/images/welcome_image_2.png"
                    :"lib/welcome_screens/assets/images/welcome_image_3.png",
                // "https://dozendiamonds.com/app/wellcome_image_1.png",
                // "lib/welcome_screens/assets/images/wellcome_image_1.png",
                fit: BoxFit.cover,
                width: screenWidthRecognizer(context),
              ),
      ),
    );
  }

  Widget middleTextSection(BuildContext context,
      WelcomeScreenData welcomeScreensData, double screenWidth) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),

            // SvgPicture.asset(
            //   "lib/welcome_screens/assets/icons/kosh_icon.svg",
            //   color: Colors.white,
            // ),

            SizedBox(
              height: 10,
            ),

            Container(
              width: screenWidth * 0.8,
              child: Text(
                welcomeScreensData.title ?? "-",
                // "Enjoy stress-less, \nautomated trading",
                // textScaler: TextScaler.linear(1),
                style: TextStyle(
                    color: Colors.white,
                    fontSize:
                        32 * (screenWidth / 375), //36 * (screenWidth / 375),
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget bottomButtonSection(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16.0, bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: welcomeScreensProvider.welcomeScreenData.map((data) {
                return CustomContainer(
                  height: 15,
                  width: 15,
                  backgroundColor: (data.id ==
                          welcomeScreensProvider
                              .welcomeScreenData[
                                  welcomeScreensProvider.selectedPageIndex]
                              .id)
                      ? Color(0xff3065EB)
                      : Color(0xffCBCBCB),
                );
              }).toList(), // Convert map to list of widgets
            ),

            // Row(
            //   children: [
            //     CustomContainer(
            //       height: 15,
            //       width: 15,
            //       backgroundColor: Color(0xff3065EB),
            //     ),
            //
            //     CustomContainer(
            //       height: 15,
            //       width: 15,
            //       backgroundColor: Color(0xffCBCBCB),
            //     ),
            //
            //     CustomContainer(
            //       height: 15,
            //       width: 15,
            //       backgroundColor: Color(0xffCBCBCB),
            //     ),
            //   ],
            // ),

            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NavigateAuthenticationScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Skip",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(width: 20),
                CustomContainer(
                  // backgroundColor: Color(0xff3065EB),
                  backgroundColor: Color(0xffF0F0F0),
                  // backgroundColor: Color(0xff1E1E1E),
                  width: 109,
                  onTap: () {
                    if (welcomeScreensProvider.selectedPageIndex <
                        welcomeScreensProvider.welcomeScreenData.length - 1) {
                      welcomeScreensProvider.pageController.animateToPage(
                        (welcomeScreensProvider.selectedPageIndex + 1),
                        duration: Duration(milliseconds: 400),
                        curve: Curves.ease,
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NavigateAuthenticationScreen(),
                        ),
                      );
                    }
                  },
                  borderRadius: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 8, bottom: 8.0),
                        child: Text(
                          (welcomeScreensProvider.selectedPageIndex <
                                  welcomeScreensProvider
                                          .welcomeScreenData.length -
                                      1)
                              ? "Next"
                              : "Get Started",
                          style: TextStyle(
                              color: Color(0XFF1A1A25),
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
