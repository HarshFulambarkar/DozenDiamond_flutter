import 'package:dozen_diamond/ZL_Register/constants/countryCodeFlags.dart';
import 'package:dozen_diamond/ZL_Register/models/get_resgistered_user_request.dart';
import 'package:dozen_diamond/ZL_Register/models/mobile_number_codes_model.dart';
import 'package:dozen_diamond/global/functions/helper.dart';
import 'package:dozen_diamond/localization/stringConstants.dart';
import 'package:dozen_diamond/login/models/login_user_request.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:validators/validators.dart';

import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZG_signupEmail/models/verify_email_request.dart';
import '../../ZG_signupEmail/widgets/verify_email_dialog.dart';
import '../../global/constants/shared_preferences_manager.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/models/http_api_exception.dart';
import '../../global/stateManagement/app_config_provider.dart';
import '../../global/widgets/common_image.dart';
import '../../global/widgets/custom_container.dart';
import '../../global/widgets/error_dialog.dart';
import '../../global/widgets/my_text_field.dart';
import '../../navigateAuthentication/stateManagement/navigate_authentication_provider.dart';
import '../models/country_state_model.dart';
import '../services/signup_rest_api_service.dart';
import '../widgets/country_state_selector.dart';

class SignUpPageNew extends StatefulWidget {
  final bool forgotMpin;
  final CountryStateCityData countryStateCityData;
  const SignUpPageNew({
    Key? key,
    this.forgotMpin = false,
    required this.countryStateCityData,
  }) : super(key: key);

  @override
  State<SignUpPageNew> createState() => _SignUpPageNewState();
}

class _SignUpPageNewState extends State<SignUpPageNew> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  StringConstants strings = StringConstants();
  MobileNumberCodeModel selectedCountryCode = mobileNumberCodes[0];
  String firstNameFieldError = "";
  bool showFirstNameFieldError = false;
  String lastNameFieldError = "";
  bool showLastNameFieldError = false;
  String emailFieldError = "";
  bool showEmailFieldError = false;
  String passwordFieldError = "";
  bool showPasswordFieldError = false;
  String rePasswordFieldError = "";
  bool showRePasswordFieldError = false;
  String phoneNumberFieldError = "";
  bool showPhoneNumberFieldError = false;

  String countryFieldError = "";
  bool showCountryFieldError = false;

  String stateFieldError = "";
  bool showStateFieldError = false;

  String? _country = "India";
  String? _state;
  City? _city;

  bool? termsAndConditionAccepted = false;

  late NavigateAuthenticationProvider navigateAuthenticationProvider;
  late ThemeProvider themeProvider;
  late AppConfigProvider appConfigProvider;
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

  void _registerUser() async {
    String fcmToken = await SharedPreferenceManager.getFCMToken() ?? "";
    SignupRestApiService()
        .getRegisteredUser(RegisterUserRequest(
      emailId: emailController.text,
      mobileNo: "${selectedCountryCode.countryCode}-${numberController.text}",
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      password: passwordController.text,
      confirmPassword: confirmpasswordController.text,
      fcmToken: fcmToken,
      country: _country,
      state: _state,
      city: _city?.name,
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    navigateAuthenticationProvider = Provider.of<NavigateAuthenticationProvider>(context, listen: true);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    appConfigProvider = Provider.of<AppConfigProvider>(context, listen: true);

    return PopScope(
        canPop: false,
        onPopInvokedWithResult: ((value, result) async {

          navigateAuthenticationProvider.selectedIndex = 1;


          // navigateAuthenticationProvider.selectedIndex =
          //     navigateAuthenticationProvider.previousIndex;
          // navigateAuthenticationProvider.previousIndex =
          //     navigateAuthenticationProvider.selectedIndex;
          // return false;
        }),
        child: Center(
          child: Container(
            width: screenWidth,
            child: Scaffold(
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
              backgroundColor: (themeProvider.defaultTheme)?Colors.white:Colors.transparent, //Colors.transparent,
              body: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16.0),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonImage(
                            imageUrl: appConfigProvider.appConfigData.data?.logo?.koshUrl ?? "", // "https://example.com/photo.png",
                            fallbackAsset: "lib/global/assets/logos/dozendiamond_logo.jpeg",
                            width: 25,
                          ),
                          // Image.asset(
                          //   "lib/global/assets/logos/dozendiamond_logo.jpeg",
                          //   width: 25,
                          // ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            strings.signUpTitle,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Britanica",
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(strings.signUpBody,
                              style: strings.subtitleStyleForSignup),
                          SizedBox(
                            height: 15,
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
                          buildFirstNameAndLastNameField(context, screenWidth),
                          SizedBox(
                            height: 15,
                          ),
                          buildEmailField(context, screenWidth),
                          SizedBox(
                            height: 15,
                          ),
                          buildCountryStateField(context, screenWidth),
                          SizedBox(
                            height: 15,
                          ),
                          buildPasswordField(context, screenWidth),
                          SizedBox(
                            height: 15,
                          ),
                          buildRePasswordField(context, screenWidth),
                          SizedBox(height: 15),
                          buildPhoneNumberField(context, screenWidth),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              bottomNavigationBar:
                  buildBottomNavigationSection(context, screenWidth),
            ),
          ),
        ));
  }

  Widget buildFirstNameAndLastNameField(
      BuildContext context, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.firstName,
                style: strings.aboveFieldText,
              ),
              const SizedBox(height: 3),
              SizedBox(
                height: 40,
                child: MyTextField(
                  isFilled: true,
                  fillColor: (themeProvider.defaultTheme)
                      ?Color(0xffCACAD3):Color(0xff2c2c31),
                  borderColor: (themeProvider.defaultTheme)
                      ?Color(0xffCACAD3):Color(0xff2c2c31),
                  textStyle: TextStyle(
                    color: (themeProvider.defaultTheme)
                        ?Colors.black:Colors.white,
                  ),
                  controller: firstNameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  focusedBorderColor: Color(0xff5cbbff),
                  borderRadius: 8,
                  labelText: '',
                  validator: (value) {
                    if (value!.isEmpty) {
                      firstNameFieldError = "* required";
                      showFirstNameFieldError = true;
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        setState(() {});
                      });
                      return null;
                    } else if (value.length < 3) {
                      firstNameFieldError =
                          "first name should be atleast 3 characters";
                      showFirstNameFieldError = true;
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        setState(() {});
                      });
                      return null;
                    } else if (RegExp('[0-9]').hasMatch(value) ||
                        !isAlpha(value)) {
                      firstNameFieldError =
                          "No number or Special character allowed";
                      showFirstNameFieldError = true;
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        setState(() {});
                      });
                      return null;
                    } else if (value.length > 15) {
                      firstNameFieldError =
                          "first name should not be greater than 15 characters";

                      showFirstNameFieldError = true;
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        setState(() {});
                      });
                      return null;
                    } else {
                      firstNameFieldError = "";
                      showFirstNameFieldError = false;
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        setState(() {});
                      });
                      return null;
                    }
                  },
                  onChanged: (value) {},
                ),
              ),
              showFirstNameFieldError
                  ? Text(firstNameFieldError, style: strings.warningText)
                  : Container()
            ],
          ),
        ),
        const SizedBox(width: 10), // Space between fields
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.lastName,
                style: strings.aboveFieldText,
              ),
              const SizedBox(height: 3),
              SizedBox(
                height: 40,
                child: MyTextField(
                  isFilled: true,
                  fillColor: (themeProvider.defaultTheme)
                      ?Color(0xffCACAD3):Color(0xff2c2c31),
                  borderColor: (themeProvider.defaultTheme)
                      ?Color(0xffCACAD3):Color(0xff2c2c31),
                  textStyle: TextStyle(
                    color: (themeProvider.defaultTheme)
                        ?Colors.black:Colors.white,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  elevation: 0,
                  controller: lastNameController,
                  margin: EdgeInsets.zero,
                  focusedBorderColor: const Color(0xff5cbbff),
                  borderRadius: 8,
                  labelText: '',
                  validator: (value1) {
                    if (value1!.isEmpty) {
                      lastNameFieldError = "* Required";
                      showLastNameFieldError = true;
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        setState(() {});
                      });
                      return null;
                    } else if (value1.length < 3) {
                      lastNameFieldError =
                          "last name should be atleast 3 characters";
                      showLastNameFieldError = true;
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        setState(() {});
                      });
                      return null;
                    }
                    // else if (value1.contains(" ")) {
                    //   lastNameFieldError = "Space is not allowed in last name";
                    //   showLastNameFieldError = true;
                    //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    //     setState(() {});
                    //   });
                    //   return null;
                    // }
                    else if (RegExp('[0-9]').hasMatch(value1)) { //  || !isAlpha(value1)) {
                      lastNameFieldError =
                          "No number or Special character allowed";
                      showLastNameFieldError = true;
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        setState(() {});
                      });
                      return null;
                    } else if (value1.length > 15) {
                      lastNameFieldError =
                          "last name should not be greater than 15 characters";
                      showLastNameFieldError = true;
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        setState(() {});
                      });
                      return null;
                    } else {
                      lastNameFieldError = "";
                      showLastNameFieldError = false;
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        setState(() {});
                      });
                      return null;
                    }
                  },
                  onChanged: (value) {},
                ),
              ),
              showLastNameFieldError
                  ? Text(lastNameFieldError, style: strings.warningText)
                  : Container()
            ],
          ),
        ),
      ],
    );
  }

  Widget buildCountryStateField(BuildContext context, double screenWidth) {
    final countries = widget.countryStateCityData.countries;
    final states = _country != null
        ? widget.countryStateCityData.statesOf(_country!)
        : <String>[];
    final cities = (_country != null && _state != null)
        ? widget.countryStateCityData.citiesOf(_country!, _state!)
        : <City>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Country of legal residence",
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 3),
          ],
        ),
        // Country selector
        IgnorePointer(
          child: SizedBox(
            height: 40,
            child: CustomContainer(
              padding: 0,
              borderRadius: 8,
              margin: EdgeInsets.zero,
              backgroundColor: (themeProvider.defaultTheme)
                  ?Color(0xffCACAD3):Color(0xff2c2c31),
              borderColor: (themeProvider.defaultTheme)
                  ?Color(0xffCACAD3):Color(0xff2c2c31),
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    dropdownColor: (themeProvider.defaultTheme)
                        ?Color(0xffCACAD3):Color(0xff2c2c31),
                    hint: Text(
                      'Select country',
                      style: TextStyle(
                        color: (themeProvider.defaultTheme)
                            ?Colors.black:Colors.white,
                      ),
                    ),
                    value: _country,
                    menuMaxHeight: 200,
                    items: countries
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (c) {
                      if (c == null) return;
                      setState(() {
                        _country = c;
                        _state = null;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        ),

        showCountryFieldError
            ? Text(countryFieldError, style: strings.warningText)
            : Container(),

        // State selector
        if (states.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(
                height: 15,
              ),


              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "State of legal residence",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 3),
                ],
              ),

              SizedBox(
                height: 40,
                child: CustomContainer(
                  borderRadius: 8,
                  padding: 0,
                  margin: EdgeInsets.zero,
                  backgroundColor: (themeProvider.defaultTheme)
                      ?Color(0xffCACAD3):Color(0xff2c2c31),
                  borderColor: (themeProvider.defaultTheme)
                      ?Color(0xffCACAD3):Color(0xff2c2c31),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: (themeProvider.defaultTheme)
                            ?Color(0xffCACAD3):Color(0xff2c2c31),
                        isExpanded: true,
                        hint: Text(
                          'Select State',
                          style: TextStyle(
                            color: (themeProvider.defaultTheme)
                                ?Colors.black:Colors.white,
                          ),
                        ),
                        value: _state,
                        menuMaxHeight: 200,
                        items: states
                            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (s) {
                          if (s == null) return;
                          setState(() {
                            _state = s;
                            _city = null;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),

              showStateFieldError
                  ? Text(stateFieldError, style: strings.warningText)
                  : Container(),
            ],
          ),

        if(cities.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(
                height: 15,
              ),


              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "City of legal residence",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 3),
                ],
              ),

              SizedBox(
                height: 40,
                child: CustomContainer(
                  borderRadius: 8,
                  padding: 0,
                  margin: EdgeInsets.zero,
                  backgroundColor: (themeProvider.defaultTheme)
                      ?Color(0xffCACAD3):Color(0xff2c2c31),
                  borderColor: (themeProvider.defaultTheme)
                      ?Color(0xffCACAD3):Color(0xff2c2c31),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<City>(
                        dropdownColor: (themeProvider.defaultTheme)
                            ?Color(0xffCACAD3):Color(0xff2c2c31),
                        isExpanded: true,
                        hint: Text(
                          'Select City',
                          style: TextStyle(
                            color: (themeProvider.defaultTheme)
                                ?Colors.black:Colors.white,
                          ),
                        ),
                        value: _city,
                        menuMaxHeight: 200,
                        items: cities
                            .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                            .toList(),
                        onChanged: (s) {
                          if (s == null) return;
                          setState(() {
                            _city = s;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),

              showStateFieldError
                  ? Text(stateFieldError, style: strings.warningText)
                  : Container(),
            ],
          ),
      ],
    );

    // return CountryStateCityPicker(
    //   data: widget.countryStateCityData,
    //   onSelection: (country, state, city) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text('Chose ${city.name}, $state in $country'),
    //       ),
    //     );
    //   },
    // );
  }

  Widget buildEmailField(BuildContext context, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.email,
          style: strings.aboveFieldText,
        ),
        const SizedBox(height: 3),
        SizedBox(
          height: 40,
          child: MyTextField(
            isFilled: true,
            fillColor: (themeProvider.defaultTheme)
                ?Color(0xffCACAD3):Color(0xff2c2c31),
            borderColor: (themeProvider.defaultTheme)
                ?Color(0xffCACAD3):Color(0xff2c2c31),
            textStyle: TextStyle(
              color: (themeProvider.defaultTheme)
                  ?Colors.black:Colors.white,
            ),
            controller: emailController,
            elevation: 0,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            margin: EdgeInsets.zero,
            focusedBorderColor:
                (showEmailFieldError) ? Color(0xffd41f1f) : Color(0xff5cbbff),
            borderRadius: 8,
            labelText: '',
            validator: (value) {
              if (value!.isEmpty) {
                emailFieldError = "* Required";
                showEmailFieldError = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              } else if (!RegExp(r'^[\w\-.+]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                emailFieldError = "Enter Correct Email Address";
                showEmailFieldError = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              } else {
                emailFieldError = "";
                showEmailFieldError = false;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              }
            },
            onChanged: (value) {},
          ),
        ),
        showEmailFieldError
            ? Text(
                emailFieldError,
                style: strings.warningText,
              )
            : Container(),
      ],
    );
  }

  Widget buildPasswordField(BuildContext context, screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.password,
          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w300),
        ),
        SizedBox(
          height: 3,
        ),
        SizedBox(
          height: 40,
          child: MyTextField(
            isFilled: true,
            fillColor: (themeProvider.defaultTheme)
                ?Color(0xffCACAD3):Color(0xff2c2c31),
            borderColor: (themeProvider.defaultTheme)
                ?Color(0xffCACAD3):Color(0xff2c2c31),
            textStyle: TextStyle(
              color: (themeProvider.defaultTheme)
                  ?Colors.black:Colors.white,
            ),
            controller: passwordController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            elevation: 0,
            margin: EdgeInsets.zero,
            focusedBorderColor: Color(0xff5cbbff),
            maxLine: 1,
            borderRadius: 8,
            isPasswordField: true,
            labelText: '',
            validator: (value3) {
              if (value3!.isEmpty) {
                passwordFieldError = "* Required";
                showPasswordFieldError = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              } else if (value3.contains(" ")) {
                passwordFieldError = "Space is not allowed in password";
                showPasswordFieldError = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              } else if (value3.length < 8) {
                passwordFieldError = "Password should be atleast 8 characters";
                showPasswordFieldError = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              } else if (!RegExp(r'[A-Z]').hasMatch(value3)) {
                passwordFieldError =
                    "Password should contain at least one upper case letter.";
                showPasswordFieldError = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              } else if (!RegExp(r'[a-z]').hasMatch(value3)) {
                passwordFieldError =
                    "Password should contain at least one lower case letter.";
                showPasswordFieldError = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              } else if (!RegExp(r'\d').hasMatch(value3)) {
                passwordFieldError =
                    "Password should contain at least one number.";
                showPasswordFieldError = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value3)) {
                passwordFieldError =
                    "Password should contain at least one special character.";
                showPasswordFieldError = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              } else {
                passwordFieldError = "";
                showPasswordFieldError = false;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              }
            },
            onChanged: (value) {},
          ),
        ),
        showPasswordFieldError
            ? Text(passwordFieldError, style: strings.warningText)
            : Container()
      ],
    );
  }

  Widget buildRePasswordField(BuildContext context, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.confirmPassword,
          style: strings.aboveFieldText,
        ),
        const SizedBox(height: 3),
        SizedBox(
          height: 40,
          child: MyTextField(
            isFilled: true,
            fillColor: (themeProvider.defaultTheme)
                ?Color(0xffCACAD3):Color(0xff2c2c31),
            borderColor: (themeProvider.defaultTheme)
                ?Color(0xffCACAD3):Color(0xff2c2c31),
            textStyle: TextStyle(
              color: (themeProvider.defaultTheme)
                  ?Colors.black:Colors.white,
            ),
            controller: confirmpasswordController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            elevation: 0,
            isPasswordField: true,
            maxLine: 1,
            margin: EdgeInsets.zero,
            // borderColor: Color(0xff2c2c31),
            focusedBorderColor: const Color(0xff5cbbff),
            borderRadius: 8,
            labelText: '',
            validator: (value4) {
              if (confirmpasswordController.text !=
                  passwordController.text) {
                rePasswordFieldError = "Password Mismatch";
                showRePasswordFieldError = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              } else if (value4!.isEmpty) {
                rePasswordFieldError = "* Required";
                showRePasswordFieldError = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              } else if (value4.contains(" ")) {
                rePasswordFieldError = "Space is not allowed in password";
                showRePasswordFieldError = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              } else if (value4.length < 8) {
                rePasswordFieldError =
                    "Password should be atleast 8 characters";
                showRePasswordFieldError = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              } else if (!RegExp(r'[A-Z]').hasMatch(value4)) {
                rePasswordFieldError =
                    "Password should contain at least one upper case letter.";
                showRePasswordFieldError = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              } else if (!RegExp(r'[a-z]').hasMatch(value4)) {
                rePasswordFieldError =
                    "Password should contain at least one lower case letter.";
                showRePasswordFieldError = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              } else if (!RegExp(r'\d').hasMatch(value4)) {
                rePasswordFieldError =
                    "Password should contain at least one number.";
                showRePasswordFieldError = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value4)) {
                rePasswordFieldError =
                    "Password should contain at least one special character.";
                showRePasswordFieldError = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              } else if (confirmpasswordController.text !=
                  passwordController.text) {
                rePasswordFieldError = "Password Mismatch";
                showRePasswordFieldError = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              } else {
                rePasswordFieldError = "";
                showRePasswordFieldError = false;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              }
            },
            onChanged: (value) {
              setState(
                () {
                  // confirmpasswordController.text = value;
                },
              );
            },
          ),
        ),
        showRePasswordFieldError
            ? Text(rePasswordFieldError, style: strings.warningText)
            : Container()
      ],
    );
  }

  Widget buildPhoneNumberField(BuildContext context, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.phoneNumber,
          style: strings.aboveFieldText,
        ),
        const SizedBox(height: 3),
        SizedBox(
          height: 40,
          child: MyTextField(
            isFilled: true,
            fillColor: (themeProvider.defaultTheme)
                ?Color(0xffCACAD3):Color(0xff2c2c31),
            borderColor: (themeProvider.defaultTheme)
                ?Color(0xffCACAD3):Color(0xff2c2c31),
            textStyle: TextStyle(
              color: (themeProvider.defaultTheme)
                  ?Colors.black:Colors.white,
            ),
            selectedCountryCode: selectedCountryCode,
            onChangedForNumber: (MobileNumberCodeModel? newValue) {
              if (newValue != null) {
                setState(() {
                  print("here is the value ${newValue.countryCode}");
                  selectedCountryCode = newValue;
                  print("here is the value ${selectedCountryCode.countryCode}");
                });
              }
            },
            controller: numberController,
            keyboardType: TextInputType.numberWithOptions(),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            isForPhoneNumber: true,
            elevation: 0,
            margin: EdgeInsets.zero,
            // borderColor: Color(0xff2c2c31),
            focusedBorderColor: const Color(0xff5cbbff),
            borderRadius: 8,
            labelText: '',
            validator: (value5) {
              if (value5!.isEmpty) {
                phoneNumberFieldError = "* Required";
                showPhoneNumberFieldError = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              } else if (value5.length < 10) {
                phoneNumberFieldError =
                    "Mobile number cannot be less than 10 characters";
                showPhoneNumberFieldError = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              } else if (value5.contains(" ")) {
                phoneNumberFieldError = "Space is not allowed in password";
                showPhoneNumberFieldError = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              } else if (value5.length > 10) {
                phoneNumberFieldError =
                    "Mobile number cannot be greater than 11 characters";
                showPhoneNumberFieldError = true;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              } else {
                phoneNumberFieldError = "";
                showPhoneNumberFieldError = false;
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {});
                });
                return null;
              }
            },
            onChanged: (value) {
              setState(
                () {
                  numberController.text = value;
                },
              );
            },
          ),
        ),
        showPhoneNumberFieldError
            ? Text(phoneNumberFieldError, style: strings.warningText)
            : Container()
      ],
    );
  }

  Widget buildBottomNavigationSection(BuildContext context, screenWidth) {
    return Container(
      width: screenWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(
                  width: 30,
                  height: 30,
                  child: Checkbox(
                    tristate: true, // Example with tristate
                    value: termsAndConditionAccepted, //ladderAddOrWithdrawCashProvider.updateCheckbox,
                    activeColor: Colors.blue,
                    side: BorderSide(
                        color: (themeProvider.defaultTheme)
                            ? Colors.black
                            : Colors.white),
                    onChanged: (bool? newValue) {
                      setState(() {
                        termsAndConditionAccepted = !termsAndConditionAccepted!;
                      });

                    },
                  ),
                ),

                SizedBox(
                  width: 8
                ),

                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                  
                          text: strings.termsAndConditions,
                          style: strings.aboveFieldText.copyWith(
                            color: (themeProvider.defaultTheme)?Colors.black:Colors.white,
                          ),
                        ),
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              // Handle the tap event
                              final Uri url = Uri.parse("https://dozendiamonds.com/terms-of-use/");
                              await launchUrl(url, mode: LaunchMode.externalApplication);
                            },
                          text: strings.termsOfUse,
                          style: strings.linkTextWithUnderline,
                        ),
                        // WidgetSpan(
                        //   alignment: PlaceholderAlignment.bottom,
                        //   child: InkWell(
                        //     onTap: () async {
                        //       // Handle terms of use click
                        //       final Uri url = Uri.parse("https://dozendiamonds.com/terms-of-use/");
                        //       await launchUrl(url, mode: LaunchMode.externalApplication);
                        //     },
                        //     child: Text(
                        //       strings.termsOfUse,
                        //       style: strings.linkTextWithUnderline,
                        //     ),
                        //   ),
                        // ),
                        TextSpan(
                          text: ' ${strings.and} ',
                          style: strings.aboveFieldText.copyWith(
                            color: (themeProvider.defaultTheme)?Colors.black:Colors.white,
                          ),
                        ),
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              // Handle the tap event
                              final Uri url = Uri.parse("https://dozendiamonds.com/privacy-policy/");
                              await launchUrl(url, mode: LaunchMode.externalApplication);
                            },
                          text: strings.privacyPolicy,
                          style: strings.linkTextWithUnderline,
                        ),
                        // WidgetSpan(
                        //   alignment: PlaceholderAlignment.bottom,
                        //   child: InkWell(
                        //     onTap: () async {
                        //       // Handle privacy policy click
                        //       final Uri url = Uri.parse("https://dozendiamonds.com/privacy-policy/");
                        //       await launchUrl(url, mode: LaunchMode.externalApplication);
                        //     },
                        //     child: Text(
                        //       strings.privacyPolicy,
                        //       style: strings.linkTextWithUnderline,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16.0),
                    child: CustomContainer(
                      onTap: () {
                        //  if (_formkey.currentState?.validate() == true ||
                        //               selectedMobileNumberCode != null) {
                        //             if (selectedMobileNumberCode == null) {
                        //               showCustomAlertDialogFromHelper(
                        //                   context, "Please select country code");
                        //             } else {

                        if(_country == null) {
                          setState(() {
                            showCountryFieldError = true;
                            countryFieldError = "Please select Country";
                          });

                        } else if(_state == null) {
                          setState(() {
                            showStateFieldError = true;
                            stateFieldError = "Please select State";
                          });

                        }  else if(_city == null) {
                          setState(() {
                            showStateFieldError = true;
                            stateFieldError = "Please select City";
                          });

                        } else {
                          setState(() {
                            showCountryFieldError = false;
                            countryFieldError = "";

                            showStateFieldError = false;
                            stateFieldError = "";
                          });

                          if(termsAndConditionAccepted == true) {
                            _registerUser();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Please select checkbox and accept our terms and condition."),
                              ),
                            );
                          }


                        }

                        // _registerUser();

                        //   }
                        // }
                      },
                      backgroundColor: Color(0xfff0f0f0),
                      borderRadius: 12,
                      height: 52,
                      width: screenWidth - 34,
                      child: Center(
                        child: Text(
                          strings.continueButton,
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Row(
                    children: [
                      Text(
                        strings.alreadyHaveAccount,
                        style: GoogleFonts.poppins(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          navigateAuthenticationProvider.previousIndex =
                              navigateAuthenticationProvider.selectedIndex;
                          navigateAuthenticationProvider.selectedIndex = 1;
                        },
                        child: Text(
                          strings.logInText,
                          style: strings.linkText,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 18,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
