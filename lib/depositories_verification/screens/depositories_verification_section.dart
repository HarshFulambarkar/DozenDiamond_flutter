import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../create_ladder_easy/widgets/custom_container.dart';
import '../../localization/translation_keys.dart';
import '../stateManagement/depositories_verification_provider.dart';

class DepositoriesVerificationSection extends StatelessWidget {

  late DepositoriesVerificationProvider depositoriesVerificationProvider;

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    depositoriesVerificationProvider = Provider.of<DepositoriesVerificationProvider>(context, listen: true);

    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15.0),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              children: [
                Text(
                  TranslationKeys.cdslAndNsdlDepositoriesAuthenticationStatus,
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                  ),
                ),

                IconButton(
                  onPressed: () {

                  },
                  icon: Icon(Icons.info_outline),
                  iconSize: 20,
                )
              ],
            ),
          ),


          Container(
            width: screenWidth - 32,
            child: Text(
              (depositoriesVerificationProvider.depositoriesVerificationStatus == "not_authorized")
                  ?"you are not authorized with any of the depositories (CDSL or NSDL), please authorize your self and then try again, if you are already authorize click on the button below and check you authorization status"
                  :"Our system is checking your CDSL & NSDL authentication status. Please wait till we are checking your status",
              style: GoogleFonts.poppins(
                fontSize: 12,
              ),
            ),
          ),

          SizedBox(
            height: 5,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              CustomContainer(
                padding: 0,
                paddingEdge: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                borderRadius: 50,
                backgroundColor: (depositoriesVerificationProvider.depositoriesVerificationStatus == "not_authorized")
                    ?Colors.redAccent:Colors.green,
                onTap: () async {
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 6, right: 6, top: 2, bottom: 4.0),
                  child: Text(
                      depositoriesVerificationProvider.depositoriesVerificationStatus,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: (true)
                            ?Color(0xfff0f0f0)
                            :Color(0xff000000),
                      )
                  ),
                ),
              ),

              CustomContainer(
                padding: 0,
                paddingEdge: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                borderRadius: 12,
                backgroundColor: (false)
                    ?Color(0xffa8a8a8):Color(0xfff0f0f0),
                onTap: () async {
                  if(depositoriesVerificationProvider.depositoriesVerificationStatus == "not_authorized") {
                    depositoriesVerificationProvider.checkDepositoriesVerificationStatus();
                  } else {
                    depositoriesVerificationProvider.getDepositoriesVerificationStatus();
                  }
                  // Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6.0),
                  child: Text(
                      TranslationKeys.checkStatus,
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: (false)
                            ?Color(0xfff0f0f0)
                            :Color(0xff000000),
                      )
                  ),
                ),
              ),
            ],
          ),

          SizedBox(
            height: 10,
          ),

          Divider(
            height: 10,
          ),
        ],
      ),
    );
  }
}
