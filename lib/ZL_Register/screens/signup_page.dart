import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:dozen_diamond/global/widgets/error_dialog.dart';
import 'package:provider/provider.dart';
import 'package:dozen_diamond/ZL_Register/models/mobile_number_codes_model.dart';

import '../../global/constants/custom_colors_light.dart';
import '../../global/functions/helper.dart';

import '../../ZL_register/widgets/custom_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:validators/validators.dart';

import '../../navigateAuthentication/stateManagement/navigate_authentication_provider.dart';
import '../constants/countryCodeFlags.dart';
import '../models/get_resgistered_user_request.dart';
import '../services/signup_rest_api_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SignUpPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  TextEditingController mobilenoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  // late RegisterCommonScreenProvider registerCommonScreenProvider;
  late NavigateAuthenticationProvider navigateAuthenticationProvider;
  bool _isObscure = true;
  bool _isObscure2 = true;
  final bool _isObscure1 = false;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  ApiStateProvider? _apiStateProvider;
  // final _formfield = GlobalKey<FormState>();

  MobileNumberCodeModel? selectedMobileNumberCode;
  @override
  void initState() {
    super.initState();
    _apiStateProvider = Provider.of(context, listen: false);
    // registerCommonScreenProvider =
    //     Provider.of<RegisterCommonScreenProvider>(context, listen: false);
  }

  void _registerUser() async {
    SignupRestApiService()
        .getRegisteredUser(RegisterUserRequest(
      emailId: emailController.text,
      mobileNo:
          "${selectedMobileNumberCode?.countryCode}-${mobilenoController.text}",
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      password: passwordController.text,
      confirmPassword: confirmpasswordController.text,
    ))
        .then((res) {
      showCustomAlertDialogFromHelper(context, res!.message.toString(), () {
        navigateAuthenticationProvider.previousIndex =
            navigateAuthenticationProvider.selectedIndex;
        navigateAuthenticationProvider.selectedIndex = 1;
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => LoginPage()));
      });
    }).catchError((err) {
      restApiErrorDialog(context, error: err, apiState: _apiStateProvider!);
    });
  }

  Widget formFieldMaker({
    String? Function(String?)? validator,
    String? label,
    required bool isHidden,
    required Widget icon,
    required void Function()? onPressed,
    required TextEditingController controllerName,
    required IconData iconName,
    required String validatorName,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    AutovalidateMode? autovalidateMode,
    String? hintText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      child: TextFormField(
        inputFormatters: inputFormatters,
        autofocus: false,
        obscureText: isHidden,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        controller: controllerName,
        autovalidateMode: autovalidateMode,
        decoration: InputDecoration(
          errorStyle: TextStyle(color: Colors.yellow, fontSize: 18),
          suffixIconColor: Colors.white,
          errorMaxLines: 3,
          suffixIcon: IconButton(
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

  Widget formUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        formFieldMaker(
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
          ],
          isHidden: _isObscure1,
          icon: const SizedBox(),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onPressed: () {},
          label: 'First Name',
          hintText: "Enter your first name",
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value!.isEmpty) {
              return "* Required";
            } else if (value.length < 3) {
              return "first name should be atleast 3 characters";
            } else if (RegExp('[0-9]').hasMatch(value) || !isAlpha(value)) {
              return "No number or Special character allowed";
            } else if (value.length > 15) {
              return "first name should not be greater than 15 characters";
            } else {
              return null;
            }
          },
          controllerName: firstNameController,
          iconName: Icons.person_outline,
          validatorName: 'name',
        ),
        formFieldMaker(
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
          ],
          isHidden: _isObscure1,
          icon: const SizedBox(),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onPressed: () {},
          label: 'Last Name',
          hintText: "Enter your last name",
          keyboardType: TextInputType.name,
          validator: (value1) {
            if (value1!.isEmpty) {
              return "* Required";
            } else if (value1.length < 3) {
              return "last name should be atleast 3 characters";
            } else if (value1.contains(" ")) {
              return "Space is not allowed in password";
            } else if (RegExp('[0-9]').hasMatch(value1) || !isAlpha(value1)) {
              return "No number or Special character allowed";
            } else if (value1.length > 15) {
              return "last name should not be greater than 15 characters";
            } else {
              return null;
            }
          },
          controllerName: lastNameController,
          iconName: Icons.person_outline,
          validatorName: 'name',
        ),
        formFieldMaker(
          isHidden: _isObscure1,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          icon: const SizedBox(),
          onPressed: () {},
          label: 'Email',
          hintText: "Enter your email address",
          keyboardType: TextInputType.emailAddress,
          // validator: (value2) {
          //   if (value2!.isEmpty) {
          //     return "* Required";
          //   } else if (value2.contains(" ")) {
          //     return "Space is not allowed in password";
          //   } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
          //       .hasMatch(value2)) {
          //     return "Enter valid Email Address";
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
        formFieldMaker(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onPressed: () {
            setState(
              () {
                _isObscure = !_isObscure;
              },
            );
          },
          icon: Icon(
            _isObscure ? Icons.visibility : Icons.visibility_off,
          ),
          label: 'Password',
          hintText: "Enter your password",
          keyboardType: TextInputType.text,
          validator: (value3) {
            if (value3!.isEmpty) {
              return "* Required";
            } else if (value3.contains(" ")) {
              return "Space is not allowed in password";
            } else if (value3.length < 8) {
              return "Password should be atleast 8 characters";
            } else if (!RegExp(r'[A-Z]').hasMatch(value3)) {
              return "Password should contain at least one upper case letter.";
            } else if (!RegExp(r'[a-z]').hasMatch(value3)) {
              return "Password should contain at least one lower case letter.";
            } else if (!RegExp(r'\d').hasMatch(value3)) {
              return "Password should contain at least one number.";
            } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value3)) {
              return "Password should contain at least one special character.";
            } else {
              return null;
            }
          },
          isHidden: _isObscure,
          controllerName: passwordController,
          iconName: Icons.lock_outline,
          validatorName: 'password',
        ),
        formFieldMaker(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onPressed: () {
            setState(
              () {
                _isObscure2 = !_isObscure2;
              },
            );
          },
          icon: Icon(
            _isObscure2 ? Icons.visibility : Icons.visibility_off,
          ),
          label: 'Confirm Password',
          hintText: "Enter your password",
          isHidden: _isObscure2,
          keyboardType: TextInputType.text,
          validator: (value4) {
            if (value4!.isEmpty) {
              return "* Required";
            } else if (value4.contains(" ")) {
              return "Space is not allowed in password";
            } else if (value4.length < 8) {
              return "Password should be atleast 8 characters";
            } else if (!RegExp(r'[A-Z]').hasMatch(value4)) {
              return "Password should contain at least one upper case letter.";
            } else if (!RegExp(r'[a-z]').hasMatch(value4)) {
              return "Password should contain at least one lower case letter.";
            } else if (!RegExp(r'\d').hasMatch(value4)) {
              return "Password should contain at least one number.";
            } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value4)) {
              return "Password should contain at least one special character.";
            } else if (confirmpasswordController.text !=
                passwordController.text) {
              return "Password Missmatch";
            } else {
              return null;
            }
          },
          controllerName: confirmpasswordController,
          iconName: Icons.lock_outline,
          validatorName: 'password',
        ),
        const SizedBox(
          height: 5,
        ),
        MobileNumberCodeDropDown(
          selectedValue: selectedMobileNumberCode,
          options: mobileNumberCodes,
          onChanged: (p0) {
            setState(() {
              selectedMobileNumberCode = p0;
            });
          },
          hintText: "Select Country Code",
        ),
        const SizedBox(
          height: 5,
        ),
        formFieldMaker(
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
          ],
          autovalidateMode: AutovalidateMode.onUserInteraction,
          isHidden: _isObscure1,
          icon: const SizedBox(),
          onPressed: () {},
          label: 'Mobile No.',
          hintText: "Enter your mobile number",
          keyboardType: TextInputType.number,
          validator: (value5) {
            if (value5!.isEmpty) {
              return "* Required";
            } else if (value5.length < 10) {
              return "Mobile number cannot be less than 9 characters";
            } else if (value5.contains(" ")) {
              return "Space is not allowed in password";
            } else if (value5.length > 10) {
              return "Mobile number cannot be greater than 11 characters";
            } else {
              return null;
            }
          },
          controllerName: mobilenoController,
          iconName: Icons.call,
          validatorName: 'password',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidthRecoginzer = screenWidthRecognizer(context);
    navigateAuthenticationProvider =
        Provider.of<NavigateAuthenticationProvider>(context, listen: true);
    return Center(
      child: Container(
        width: screenWidthRecoginzer,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color(0xFF15181F),
            centerTitle: true,
            title: SizedBox(
              height: 40,
              width: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  "lib/global/assets/logos/dozendiamond_logo.jpeg",
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          backgroundColor: const Color(0xFF15181F),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Sign Up',
                      style: kHeadingbig,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Create an account now and start trading with us.",
                      style: kBodyTextbig,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Form(key: _formkey, child: formUI()),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Center(
                          child: Text(
                            "By signing up, you agree to our ",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                "Terms of use ",
                                style: TextStyle(
                                    color: Color(0xFF0099CC), fontSize: 16),
                              ),
                            ),
                            Center(
                              child: Text(
                                "and",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                            Center(
                              child: Text(
                                " Privacy and policy",
                                style: TextStyle(
                                    color: Color(0xFF0099CC), fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formkey.currentState?.validate() == true ||
                                  selectedMobileNumberCode != null) {
                                if (selectedMobileNumberCode == null) {
                                  showCustomAlertDialogFromHelper(
                                      context, "Please select country code");
                                } else {
                                  _registerUser();
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              // backgroundColor: const Color(0xFF0099CC),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 100,
                                vertical: 0,
                              ),
                            ),
                            child: const Text(
                              style: TextStyle(
                                fontSize: 20,
                              ),
                              'SIGN UP',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Center(
                          child: Text(
                            " Already have an account? ",
                            style: TextStyle(color: Colors.white, fontSize: 16),
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
                              "Sign In",
                              style: TextStyle(
                                color: Color(0xFF0099CC),
                                decoration: TextDecoration.underline,
                                fontSize: 16,
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
        ),
      ),
    );
  }
}
