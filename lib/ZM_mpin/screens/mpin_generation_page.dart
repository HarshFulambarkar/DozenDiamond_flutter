import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:dozen_diamond/global/widgets/error_dialog.dart';
import 'package:provider/provider.dart';
import 'package:dozen_diamond/navigateAuthentication/stateManagement/navigate_authentication_provider.dart';

import '../../ZM_mpin/models/get_mpin_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pin_code_fields/pin_code_fields.dart';
import '../../global/functions/helper.dart';
import '../../login/widgets/background_image.dart';
import '../services/mpin_rest_api_service.dart';

class MpinGenerationPageOld extends StatefulWidget {
  const MpinGenerationPageOld({super.key, required this.regId});
  final int regId;

  @override
  State<MpinGenerationPageOld> createState() => _MpinGenerationPageState();
}

class _MpinGenerationPageState extends State<MpinGenerationPageOld> {
  final textEditingController = TextEditingController();
  bool _isObscure = true;

  late NavigateAuthenticationProvider navigateAuthenticationProvider;

  ApiStateProvider? _apiStateProvider;

  @override
  void initState() {
    super.initState();
    _apiStateProvider = Provider.of(context, listen: false);
  }

  Future<void> _submitUserMpin() async {
    if (textEditingController.text.length < 6) return;
    progressbar(context);
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
      Navigator.of(context).pop();
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
      textEditingController.clear();
      Navigator.pop(context);
      restApiErrorDialog(context,
          error: err, apiState: _apiStateProvider!, action: _submitUserMpin);
    });
  }

  Future<void> confirmGenerateMPinDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Are you sure you want to generate \n an M-PIN ?'),
            actions: [
              Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                      child: ElevatedButton(
                    child: Text('Proceed'),
                    onPressed: () async {
                      Navigator.pop(context);
                      await _submitUserMpin();
                    },
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: OutlinedButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      textEditingController.clear();
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  )),
                  SizedBox(
                    width: 5,
                  ),
                ],
              )
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
              side: const BorderSide(
                color: Colors.white,
                width: 1,
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            backgroundColor: const Color(0xFF15181F),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    navigateAuthenticationProvider =
        Provider.of<NavigateAuthenticationProvider>(context, listen: true);
    double screenWidthRecoginzer = screenWidthRecognizer(context);
    return Center(
      child: Container(
        width: screenWidthRecoginzer,
        child: Stack(
          children: [
            const BackgroundImage(),
            Scaffold(
              // resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              body: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: SizedBox(
                          width: 280,
                          height: 150,
                          child: Image.asset(
                            "lib/global/assets/logos/dozendiamond_logo.jpeg",
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.amber,
                                alignment: Alignment.center,
                                child: const Text(
                                  'Whoops!',
                                  style: TextStyle(fontSize: 30),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Generate 6-digit M-pin",
                              style: TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.bold),
                            ),
                            InkWell(
                              child: Icon(
                                _isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
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
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: PinCodeTextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          length: 6,
                          obscureText: _isObscure,
                          obscuringCharacter: "*",
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            activeColor: Colors.blue,
                            activeFillColor: Colors.blue,
                            disabledColor: Colors.white,
                            errorBorderColor: Colors.white,
                            inactiveColor: Colors.white,
                            inactiveFillColor: Colors.white,
                            selectedColor: Colors.white,
                            selectedFillColor: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          animationDuration: const Duration(milliseconds: 300),
                          controller: textEditingController,
                          onCompleted: (v) async {
                            confirmGenerateMPinDialog();
                          },
                          onChanged: (value) {
                            print(value);
                          },
                          beforeTextPaste: (text) {
                            return true;
                          },
                          appContext: context,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
