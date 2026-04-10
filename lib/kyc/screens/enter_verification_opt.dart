import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../global/functions/screenWidthRecoginzer.dart';
import '../provider/kyc_provider.dart';
import '../utility/utils.dart';
import '../widgets/custom_container.dart';
import '../widgets/otp_input.dart';
import 'aadhaar_ui_screen.dart';

class EnterVerificationOpt extends StatelessWidget {

  late KycProvider kycProvider;

  @override
  Widget build(BuildContext context) {
    kycProvider = Provider.of<KycProvider>(context, listen: true);
    double screenWidth = screenWidthRecognizer(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF15181F),
      body: Center(
        child: Container(
          width: screenWidth,
            color: Colors.white,
            child: enterVerificationOtp(context)
        ),
      ),
    );
  }

  Widget enterVerificationOtp(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Please enter verification code you received on your linked Aadhaar phone number",
            // "Ask Start OTP to user",
            style: TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.bold
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: PinInputTextField(
              pinLength: 6,
              decoration: const BoxLooseDecoration(
                  enteredColor: Colors.black,
                  textStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.black
                  )
              ),
              controller: kycProvider.aadhaarVerificationOtpController,
              autoFocus: false,
              textInputAction: TextInputAction.done,
              onChanged: (v) {
                if(v.length ==6){

                  // _onFormSubmitted();
                }
              },
              // onSubmit: (pin) {
              //   if (pin.length == 6) {
              //     _onFormSubmitted();
              //   } else {
              //     showToast("Invalid OTP", Colors.red);
              //   }
              // },
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomContainer(
                  height: 50,
                  width: 150,
                  backgroundColor: Colors.green,
                  borderRadius: 50,
                  onTap: () async {
                    if(kycProvider.isLoading == false) {
                      if(kycProvider.aadhaarVerificationOtpController.text.length == 6){

                        final value  = await kycProvider.submitAadhaarOtp();

                        print(value);

                        if(value){
                          print('in side value');
                          Navigator.of(context).pushReplacement(
                            // widget.activityContext,
                            MaterialPageRoute(
                              builder: (_) => AadhaarUiScreen(),
                            ),
                          );

                        }else{
                          print('in side else');
                        }
                      }else{
                        Utility.showSingleTextToast("Enter 6 digit Otp");
                      }
                    }


                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Container(
                      //   width: 50,
                      // ),
                      (kycProvider.isLoading == true)?Container(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ):Text(
                        "Verify OTP",
                        // "Submit Start OTP",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ],
                  )
              ),
            ],
          )
        ],
      ),
    );
  }
}
