import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:dozen_diamond/global/widgets/error_dialog.dart';
import 'package:provider/provider.dart';

import '../../ZG_signupEmail/services/signup_email_rest_api_service.dart';
import '../../global/models/http_api_exception.dart';
import '../../login/models/login_user_request.dart';
import '../../login/widgets/background_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ZG_signupEmail/models/verify_email_request.dart';
import '../../login/services/login_rest_api_service.dart';
import '../../login/widgets/login_button.dart';
import '../../ZG_signupEmail/widgets/verify_email_dialog.dart';
import '../../login/widgets/signup_button.dart';
import '../../navigateAuthentication/stateManagement/navigate_authentication_provider.dart';

class LoginPageOld extends StatefulWidget {
  final bool forgotMpin;
  const LoginPageOld({
    Key? key,
    this.forgotMpin = false,
  }) : super(key: key);

  @override
  State<LoginPageOld> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPageOld> {
  final textEditingController = TextEditingController();
  final textEditingController1 = TextEditingController();
  late NavigateAuthenticationProvider navigateAuthenticationProvider;

  bool _isObscure = true;

  final bool _isObscure1 = false;

  ApiStateProvider? _apiStateProvider;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    print("in login screen");
    super.initState();
    navigateAuthenticationProvider =
        Provider.of<NavigateAuthenticationProvider>(context, listen: false);
    SharedPreferences.getInstance().then((value) async {
      if (value.getInt("reg_id") != null && !widget.forgotMpin) {
        navigateAuthenticationProvider.previousIndex =
            navigateAuthenticationProvider.selectedIndex;
        navigateAuthenticationProvider.selectedIndex = 3;
      }
    });
    _apiStateProvider = Provider.of(context, listen: false);
  }

  Future<void> verifyEmailShootOtp() async {
    final result =
        await SignupEmailRestApiService().verifyEmail(VerifyEmailRequest(
      email: textEditingController.text,
    ));
    if (mounted) {
      if (result?.status == true) {
        return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return VerifyEmailDialog(
              resendOtp: verifyEmailShootOtp,
            );
          },
        );
      }
    }
  }

  void _loginUser() async {
    LoginRestApiService()
        .getLoginUser(LoginUserRequest(
      useremail: textEditingController.text,
      password: textEditingController1.text,
    ))
        .then((res) {
      ApiStateProvider().resetApiRetry();
      SharedPreferences.getInstance().then((pref) {
        if (widget.forgotMpin || !res!.data!.regMpinExist!) {
          print("in if");
          navigateAuthenticationProvider.previousIndex =
              navigateAuthenticationProvider.selectedIndex;
          navigateAuthenticationProvider.regId = res!.data!.regId!;
          navigateAuthenticationProvider.selectedIndex = 6;
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => MpinGenerationPage(
          //       regId: res!.data!.regId!,
          //     ),
          //   ),
          // );
        } else if (res.data?.regAccountStatus == "BLOCKED") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Account Blocked"),
                content: Text(
                    "Your account is blocked. Please login with another account."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );
        } else {
          print("in else");
          print(res.data?.regEmail);
          pref.setString("reg_user", res.data?.regUsername ?? "");
          pref.setString("reg_user_email", res.data?.regEmail ?? "");
          pref.setString(
              "reg_account_status", res.data?.regAccountStatus ?? "");
          pref.setInt("reg_id", res.data!.regId!);
          navigateAuthenticationProvider.previousIndex =
              navigateAuthenticationProvider.selectedIndex;
          navigateAuthenticationProvider.selectedIndex = 3;
        }
      });
    }).catchError((err) {
      textEditingController1.clear();
      if (err.runtimeType == HttpApiException &&
          err.errorCode == 400 &&
          err.errorTitle == "User's email address is not verified.") {
        Fluttertoast.showToast(
          msg: 'Email sent to registered email ID containing verification pin!',
        );
        verifyEmailShootOtp();
      } else {
        print("hello from the error dialog");
        restApiErrorDialog(context,
            error: err, action: _loginUser, apiState: _apiStateProvider!);
      }
    });
  }

  Widget formFieldMaker({
    String? Function(String?)? validator,
    String? label,
    required bool isHidden,
    Widget? icon,
    required void Function()? onPressed,
    required TextEditingController controllerName,
    required IconData iconName,
    required String validatorName,
    TextInputType? keyboardType,
    AutovalidateMode? autovalidateMode,
    String? hintText,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      margin: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        autofocus: false,
        obscureText: isHidden,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        controller: controllerName,
        autovalidateMode: autovalidateMode,
        decoration: InputDecoration(
          suffixIconColor: Colors.white,
          errorStyle: TextStyle(color: Colors.yellow, fontSize: 18),
          errorMaxLines: 3,
          suffixIcon: icon == null
              ? null
              : IconButton(
                  onPressed: onPressed,
                  icon: icon,
                ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(17),
            child: Icon(iconName, color: Colors.white),
          ),
          focusColor: Colors.white,
          labelStyle: const TextStyle(
            color: Colors.white,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 1,
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 1,
            ),
          ),
          labelText: label,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.white,
          ),
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    navigateAuthenticationProvider =
        Provider.of<NavigateAuthenticationProvider>(context, listen: true);
    return WillPopScope(
      onWillPop: () async {
        navigateAuthenticationProvider.selectedIndex =
            navigateAuthenticationProvider.previousIndex;
        navigateAuthenticationProvider.previousIndex =
            navigateAuthenticationProvider.selectedIndex;
        return false;
      },
      child: Center(
        child: Container(
          width: screenWidth,
          child: Stack(
            children: [
              const BackgroundImage(),
              Scaffold(
                appBar: widget.forgotMpin == true
                    ? AppBar(
                        backgroundColor: Colors.transparent,
                        leading: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            navigateAuthenticationProvider.selectedIndex =
                                navigateAuthenticationProvider.previousIndex;
                            navigateAuthenticationProvider.previousIndex =
                                navigateAuthenticationProvider.selectedIndex;
                            // navigateAuthenticationProvider.selectedIndex = 4;
                          },
                        ))
                    : AppBar(
                        backgroundColor: Colors.transparent,
                      ),
                // resizeToAvoidBottomInset: false,
                backgroundColor: Colors.transparent,
                body: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: SizedBox(
                                  width: 150,
                                  height: 150,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(7),
                                    child: Image.asset(
                                      "lib/global/assets/logos/dozendiamond_logo.jpeg",
                                      fit: BoxFit.fill,
                                      errorBuilder:
                                          (context, error, stackTrace) {
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
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              if (widget.forgotMpin) ...[
                                const FittedBox(
                                  child: Text(
                                    "Please enter your Credential\nfor resetting your Mpin.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.lightBlueAccent,
                                        height: 1.3),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: Column(
                                  children: [
                                    Form(
                                      key: _formkey,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          formFieldMaker(
                                            isHidden: _isObscure1,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            onPressed: () {},
                                            label: 'Email',
                                            hintText:
                                                "Enter your email address",
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            // validator: (value2) {
                                            //   if (value2!.isEmpty) {
                                            //     return "* Required";
                                            //   } else if (!RegExp(
                                            //           r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                            //       .hasMatch(value2)) {
                                            //     return "Enter Correct Email Address";
                                            //   } else {
                                            //     return null;
                                            //   }
                                            // },
                                            validator: (value2) {
                                              if (value2!.isEmpty) {
                                                return "* Required";
                                              } else if (!RegExp(
                                                  r'^[\w\-.+]+@([\w-]+\.)+[\w-]{2,4}$')
                                                  .hasMatch(value2)) {
                                                return "Enter Correct Email Address";
                                              } else {
                                                return null;
                                              }
                                            },
                                            controllerName:
                                                textEditingController,
                                            iconName: FontAwesomeIcons.envelope,
                                            validatorName: 'email',
                                          ),
                                          formFieldMaker(
                                            // autovalidateMode:
                                            //     AutovalidateMode.onUserInteraction,
                                            onPressed: () {
                                              setState(
                                                () {
                                                  _isObscure = !_isObscure;
                                                },
                                              );
                                            },
                                            icon: Icon(
                                              _isObscure
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                            label: 'Password',
                                            hintText: "Enter your password",
                                            keyboardType:
                                                TextInputType.streetAddress,
                                            // validator: (value3) {
                                            //   if (value3!.isEmpty) {
                                            //     return "* Required";
                                            //   } else if (value3.length < 8) {
                                            //     return "Password should be atleast 8 characters";
                                            //   } else if (!RegExp(r'[A-Z]')
                                            //       .hasMatch(value3)) {
                                            //     return "Password should contain at least one upper case letter.";
                                            //   } else if (!RegExp(r'[a-z]')
                                            //       .hasMatch(value3)) {
                                            //     return "Password should contain at least one lower case letter.";
                                            //   } else if (!RegExp(r'\d')
                                            //       .hasMatch(value3)) {
                                            //     return "Password should contain at least one digit character.";
                                            //   } else if (!RegExp(
                                            //           r'[!@#$%^&*(),.?":{}|<>]')
                                            //       .hasMatch(value3)) {
                                            //     return "Password should contain at least one special character.";
                                            //   } else {
                                            //     return null;
                                            //   }
                                            // },
                                            isHidden: _isObscure,
                                            controllerName:
                                                textEditingController1,
                                            iconName: Icons.lock_outline,
                                            validatorName: 'password',
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                top: 20, right: 8),
                                            child: InkWell(
                                              onTap: () {
                                                print(
                                                    navigateAuthenticationProvider
                                                        .selectedIndex);
                                                navigateAuthenticationProvider
                                                        .previousIndex =
                                                    navigateAuthenticationProvider
                                                        .selectedIndex;
                                                navigateAuthenticationProvider
                                                    .selectedIndex = 4;
                                                print(
                                                    navigateAuthenticationProvider
                                                        .selectedIndex);
                                              },
                                              child: const Text(
                                                "Forgot Password",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          10, 30, 10, 0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                child: LoginButton(
                                                  sizeOfButton: 0.30,
                                                  fun: () {
                                                    if (_formkey.currentState
                                                            ?.validate() ==
                                                        true) {
                                                      _loginUser();
                                                    }
                                                  },
                                                  buttonText: widget.forgotMpin
                                                      ? 'Continue'
                                                      : 'LOGIN',
                                                  bottomNavigatonIndex: 2,
                                                ),
                                              ),
                                              if (!widget.forgotMpin) ...[
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                Flexible(
                                                    child: SignUpButton(
                                                  sizeOfButton: 0.30,
                                                  buttonText: 'SIGNUP',
                                                )),
                                              ],
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50,
                                    ),
                                    Text(
                                      "All right reserved\nCopyright @${DateTime.now().year}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        height: 1.5,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    )
                                  ],
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
            ],
          ),
        ),
      ),
    );
  }
}
