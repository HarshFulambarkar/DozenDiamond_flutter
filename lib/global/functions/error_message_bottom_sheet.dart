import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../Settings/stateManagement/theme_provider.dart';
import '../widgets/custom_container.dart';

class ErrorMessageBottomSheetOld extends StatelessWidget {
  final String? status;
  final String? errorTitle;
  final String? errorDescription;
  final String? request;

  ErrorMessageBottomSheetOld({
    this.status,
    this.errorTitle,
    this.errorDescription,
    this.request
  });

  late ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    double screenWidth = screenWidthRecognizer(context);

    return SafeArea(
        child: Center(
          child: Container(
            height: 850,
              width: screenWidth,
              decoration: BoxDecoration(
                color: (themeProvider.defaultTheme)
                    ?Color(0xfff0f0f0)
                    :Color(0xff2c2c31),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [

                Icon(
                  Icons.warning_amber,
                  color: Color(0xffff9e37),
                  size: 30,
                ),

                (kDebugMode)?Container(
                  width: screenWidth * 0.9,
                  child: Center(
                    child: Text(
                      request ?? "",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          color: (themeProvider.defaultTheme)?Color(0xff141414):Color(0xfff0f0f0),
                          fontSize: 10
                      ),
                    ),
                  ),
                ):Container(),

                Container(
                  width: screenWidth * 0.9,
                  child: Center(
                    child: Text(
                      errorTitle ?? "-",
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        color: (themeProvider.defaultTheme)?Color(0xff141414):Color(0xfff0f0f0),
                        fontSize: 20
                      ),
                    ),
                  ),
                ),


                Container(
                  width: screenWidth * 0.9,
                  child: Center(
                    child: Text(
                      errorDescription ?? "-",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: (themeProvider.defaultTheme)?Color(0xff141414):Color(0xfff0f0f0),
                          fontSize: 16
                      ),
                    ),
                  ),
                ),


                CustomContainer(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  backgroundColor: (themeProvider.defaultTheme)?Color(0xff141414):Color(0xfff0f0f0),
                  padding: 0,
                  margin: EdgeInsets.zero,
                  borderRadius: 12,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 25, top: 8, bottom: 8),
                    child: Text(
                      "Got it",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: (themeProvider.defaultTheme)?Color(0xfff0f0f0):Color(0xff1a1a25),
                      ),
                    ),
                  ),
                )


              ],
            ),
          ),
        )
    );
  }
}
