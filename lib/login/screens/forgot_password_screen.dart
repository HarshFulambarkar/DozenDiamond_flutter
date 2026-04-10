import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:dozen_diamond/global/widgets/error_dialog.dart';
import 'package:provider/provider.dart';

import '../../global/functions/helper.dart';

import '../../global/models/http_api_exception.dart';
import '../../login/widgets/forgotPasswordDialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../login/models/forgot_password_request.dart';
import '../../login/services/login_rest_api_service.dart';
import '../../navigateAuthentication/stateManagement/navigate_authentication_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  late NavigateAuthenticationProvider navigateAuthenticationProvider;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  ApiStateProvider? _apiStateProvider;
  final bool _isObscure1 = false;
  @override
  void initState() {
    super.initState();
    _apiStateProvider = Provider.of(context, listen: false);
  }

  Future<void> forgotPassword() async {
    try {
      await LoginRestApiService().forgotPassword(ForgotPasswordRequest(
        email: emailController.text.toString(),
      ));
      ApiStateProvider().resetApiRetry();
      if (mounted) {
        Fluttertoast.showToast(
            msg:
                'Email sent successfully to registered email ID containing OTP to reset password.',
            backgroundColor: Colors.black38);
        showDialog(
          context: context,
          builder: (context) {
            return const ForgotPasswordDialog();
          },
        );
      }
    } on HttpApiException catch (err) {
      emailController.clear();
      restApiErrorDialog(context,
          error: err, action: forgotPassword, apiState: _apiStateProvider!);
    }
  }

  Widget formFieldMaker({
    String? Function(String?)? validator,
    String? label,
    required bool isHidden,
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
          errorStyle: TextStyle(color: Colors.yellow, fontSize: 18),
          errorMaxLines: 3,
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
    double screenWidthRecoginzer = screenWidthRecognizer(context);
    navigateAuthenticationProvider =
        Provider.of<NavigateAuthenticationProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: const Color(0xFF15181F),
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            if (navigateAuthenticationProvider.previousIndex == 5) {
              navigateAuthenticationProvider.previousIndex = 3;
              navigateAuthenticationProvider.selectedIndex = 5;
            } else {
              navigateAuthenticationProvider.selectedIndex = 1;
            }
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFF15181F),
        centerTitle: true,
        title: const Text("Forgot Password"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: screenWidthRecoginzer,
            child: Column(
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
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  child: const Center(
                    child: Text(
                      "Enter Email Address",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Form(
                  key: _formkey,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    child: formFieldMaker(
                      isHidden: _isObscure1,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onPressed: () {},
                      label: 'Email',
                      hintText: "example@gmail.com",
                      keyboardType: TextInputType.emailAddress,
                      // validator: (value2) {
                      //   if (value2!.isEmpty) {
                      //     return "* Required";
                      //   } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
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
                      controllerName: emailController,
                      iconName: FontAwesomeIcons.envelope,
                      validatorName: 'email',
                    ),
                  ),
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      navigateAuthenticationProvider.previousIndex =
                          navigateAuthenticationProvider.selectedIndex;
                      navigateAuthenticationProvider.selectedIndex = 1;
                    },
                    child: const Text(
                      "Back to sign in",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formkey.currentState?.validate() == true) {
                              if (emailController.text.toString() == "") {
                                showCustomAlertDialogFromHelper(
                                    context, "email is required ");
                                emailController.clear();
                              }
                              await forgotPassword();
                            }
                          },
                          child: const Text("Send"),
                        ),
                      ),
                    ),
                  ],
                ),
                // Center(
                //   child: Container(
                //     margin: EdgeInsets.only(top: 30, bottom: 10),
                //     child: Text(
                //       "or",
                //       textAlign: TextAlign.center,
                //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                //     ),
                //   ),
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Image.asset(
                //       "lib/global/assets/images/google.png",
                //       scale: 2,
                //     ),
                //     SizedBox(
                //       width: MediaQuery.of(context).size.width * 0.04,
                //     ),
                //     Image.asset(
                //       "lib/global/assets/images/facebook.png",
                //       scale: 2,
                //     ),
                //     SizedBox(
                //       width: MediaQuery.of(context).size.width * 0.04,
                //     ),
                //     Image.asset(
                //       "lib/global/assets/images/apple.png",
                //       scale: 2,
                //       color: Colors.white,
                //     ),
                //   ],
                // ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: const Text(
                      "Don't have an Account?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: OutlinedButton(
                          onPressed: () {
                            navigateAuthenticationProvider.previousIndex =
                                navigateAuthenticationProvider.selectedIndex;
                            navigateAuthenticationProvider.selectedIndex = 0;
                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(
                            //     // PlanBuy()
                            //     builder: (context) => const SignUpPage(),
                            //   ),
                            // );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            side: const BorderSide(
                              color: Color(0xFF0099CC),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'Sign up',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF0099CC),
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
