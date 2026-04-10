import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../Settings/stateManagement/theme_provider.dart';
import '../../create_ladder_easy/widgets/custom_container.dart';
import '../../localization/translation_keys.dart';

class InProgressDialog extends StatelessWidget {

  late ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {

    double screenWidth = screenWidthRecognizer(context);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.only(bottom: 5),
        width: screenWidth,
        decoration: BoxDecoration(
          color: themeProvider.defaultTheme
              ? Color(0XFFF5F5F5)
              : Color(
              0xFF15181F), //value.defaultTheme ? Colors.white : Color(0xFF15181F),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white54,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildTopHeadingSection(context),

            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16.0),
              child: Text(
                "We are checking your CDSL and NSDL authorization status, please wait till we are processing you request",
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xfff0f0f0)
                ),
              ),
            ),

            SizedBox(
              height: 10,
            ),

            buildBottomButtonSection(context),

            SizedBox(
              height: 10,
            ),

          ],
        ),
      ),
    );
  }

  Widget buildTopHeadingSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close),
          iconSize: 20,
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 10,
          ),
          child: Text(
            "CDSL & NSDL Authorization in process",
            style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xfff0f0f0)
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }

  Widget buildBottomButtonSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // CustomContainer(
          //   padding: 0,
          //   paddingEdge: EdgeInsets.zero,
          //   margin: EdgeInsets.zero,
          //   borderRadius: 12,
          //   backgroundColor: Colors.transparent,
          //   onTap: () async {
          //     Navigator.pop(context);
          //   },
          //   child: Padding(
          //     padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8.0),
          //     child: Text(
          //         TranslationKeys.cancel,
          //         style: GoogleFonts.poppins(
          //             fontSize: 14.5,
          //             fontWeight: FontWeight.w500,
          //             color: Color(0xfff0f0f0)
          //         )
          //     ),
          //   ),
          // ),
          //
          // SizedBox(
          //   width: 5,
          // ),

          CustomContainer(
            padding: 0,
            paddingEdge: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            borderRadius: 12,
            backgroundColor: (false)
                ?Color(0xffa8a8a8):Color(0xfff0f0f0),
            onTap: () async {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8.0),
              child: Text(
                  TranslationKeys.ok,
                  style: GoogleFonts.poppins(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    color: (false)
                        ?Color(0xfff0f0f0)
                        :Color(0xff000000),
                  )
              ),
            ),
          )
        ],
      ),
    );
  }
}
