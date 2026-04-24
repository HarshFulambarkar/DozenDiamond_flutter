
import 'package:dozen_diamond/ZL_Register/constants/countryCodeFlags.dart';
import 'package:dozen_diamond/ZL_Register/models/get_resgistered_user_request.dart';
import 'package:dozen_diamond/ZL_Register/models/mobile_number_codes_model.dart';
import 'package:dozen_diamond/global/functions/helper.dart';
import 'package:dozen_diamond/localization/stringConstants.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Settings/stateManagement/theme_provider.dart';
import '../../global/constants/shared_preferences_manager.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/stateManagement/app_config_provider.dart';
import '../../global/widgets/common_image.dart';
import '../../global/widgets/custom_container.dart';
import '../../global/widgets/error_dialog.dart';
import '../../global/widgets/my_text_field.dart';
import '../../navigateAuthentication/stateManagement/navigate_authentication_provider.dart';
import '../models/country_state_model.dart';
import '../services/signup_rest_api_service.dart';

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
    bool isContinueButtonEnabled = false;
  // Error message variables
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

  String cityFieldError = "";
  bool showCityFieldError = false;

  String? _country = "India";
  String? _state;
  City? _city;

String? validateEmail(String email) {
  if (email.isEmpty) {
    return "* Required";
  }
  
  // Check for spaces
  if (email.contains(' ')) {
    return "Email cannot contain spaces";
  }
  
  // Check for missing '@'
  if (!email.contains('@')) {
    return "Invalid email";
  }
  
  // Split email into local part and domain
  List<String> parts = email.split('@');
  
  // Check for multiple '@' symbols
  if (parts.length != 2) {
    return "Invalid email";
  }
  
  String localPart = parts[0];
  String domainPart = parts[1];
  
  // Check for missing username
  if (localPart.isEmpty) {
    return "Invalid email";
  }
  
  // NEW: Check if email username starts with any special character
  // Only allow A-Z, a-z, 0-9 at the beginning
  if (localPart.isNotEmpty) {
    String firstChar = localPart[0];
    RegExp validStartChar = RegExp(r'^[a-zA-Z0-9]');
    if (!validStartChar.hasMatch(firstChar)) {
      return "Email username cannot start with special characters";
    }
  }
  
  // Check if email starts with dot
  if (localPart.startsWith('.')) {
    return "Email cannot start with dot";
  }
  
  // Check if email ends with dot
  if (localPart.endsWith('.')) {
    return "Email cannot end with dot";
  }
  
  // Check for consecutive dots
  if (localPart.contains('..')) {
    return "Email cannot contain consecutive dots";
  }
  
  // Check for missing domain name
  if (domainPart.isEmpty || domainPart.startsWith('.')) {
    return "Invalid email";
  }
  
  // Check for missing top-level domain
  if (!domainPart.contains('.')) {
    return "Invalid email";
  }
  
  // Split domain into domain name and TLD
  List<String> domainParts = domainPart.split('.');
  
  // Check for empty domain name or TLD
  if (domainParts.length < 2) {
    return "Invalid email";
  }
  
  String domainName = domainParts[0];
  String tld = domainParts[1];
  
  // Check if domain name is empty or starts with hyphen
  if (domainName.isEmpty || domainName.startsWith('-') || domainName.endsWith('-')) {
    return "Invalid email";
  }
  
  // Check if TLD is empty or too short
  if (tld.isEmpty || tld.length < 2) {
    return "Invalid email";
  }
  
  // NEW: Check domain part for any special characters (only letters, numbers, dots, hyphens allowed)
  // This means no special characters like ! @ # $ % ^ & * ( ) + = { } [ ] | \ : ; " ' < > , ? / etc.
  RegExp validDomainChars = RegExp(r'^[a-zA-Z0-9.\-]+$');
  if (!validDomainChars.hasMatch(domainPart)) {
    return "Domain part cannot contain special characters";
  }
  
  // Check local part for valid characters (only allow letters, numbers, dots, underscores, hyphens, plus)
  // But we already checked for consecutive dots and leading/trailing dots
  RegExp validLocalChars = RegExp(r'^[a-zA-Z0-9._\-+]+$');
  if (!validLocalChars.hasMatch(localPart)) {
    return "Email username contains invalid characters";
  }
  
  // Check TLD contains only letters
  RegExp validTldChars = RegExp(r'^[a-zA-Z]+$');
  if (!validTldChars.hasMatch(tld)) {
    return "Invalid top-level domain";
  }
  
  // Optional: Check email length (max 254 characters as per RFC)
  if (email.length > 254) {
    return "Email too long (max 254 characters)";
  }
  
  return null; // Valid email
}

// Alternative: More strict version - No special characters ANYWHERE except dot and hyphen
String? validateEmailStrict(String email) {
  if (email.isEmpty) {
    return "* Required";
  }
  
  // Check for spaces
  if (email.contains(' ')) {
    return "Email cannot contain spaces";
  }
  
  // Check for missing '@'
  if (!email.contains('@')) {
    return "Invalid email";
  }
  
  // Split email into local part and domain
  List<String> parts = email.split('@');
  
  // Check for multiple '@' symbols
  if (parts.length != 2) {
    return "Invalid email";
  }
  
  String localPart = parts[0];
  String domainPart = parts[1];
  
  // Check for missing username
  if (localPart.isEmpty) {
    return "Invalid email";
  }
  
  // Check if email username starts with any special character
  if (localPart.isNotEmpty) {
    String firstChar = localPart[0];
    RegExp validStartChar = RegExp(r'^[a-zA-Z0-9]');
    if (!validStartChar.hasMatch(firstChar)) {
      return "Email username cannot start with special characters";
    }
  }
  
  // Check if email starts with dot
  if (localPart.startsWith('.')) {
    return "Email cannot start with dot";
  }
  
  // Check if email ends with dot
  if (localPart.endsWith('.')) {
    return "Email cannot end with dot";
  }
  
  // Check for consecutive dots
  if (localPart.contains('..')) {
    return "Email cannot contain consecutive dots";
  }
  
  // Check for missing domain name
  if (domainPart.isEmpty || domainPart.startsWith('.')) {
    return "Invalid email";
  }
  
  // Check for missing top-level domain
  if (!domainPart.contains('.')) {
    return "Invalid email";
  }
  
  // Split domain into domain name and TLD
  List<String> domainParts = domainPart.split('.');
  
  // Check for empty domain name or TLD
  if (domainParts.length < 2) {
    return "Invalid email";
  }
  
  String domainName = domainParts[0];
  String tld = domainParts[1];
  
  // Check if domain name is empty or starts with hyphen
  if (domainName.isEmpty || domainName.startsWith('-') || domainName.endsWith('-')) {
    return "Invalid email";
  }
  
  // Check if TLD is empty or too short
  if (tld.isEmpty || tld.length < 2) {
    return "Invalid email";
  }
  
  // STRICT: No special characters allowed in domain part at all
  // Only letters, numbers, dots, and hyphens
  RegExp validDomainChars = RegExp(r'^[a-zA-Z0-9.\-]+$');
  if (!validDomainChars.hasMatch(domainPart)) {
    return "Domain cannot contain special characters (only letters, numbers, dots, and hyphens allowed)";
  }
  
  // STRICT: No special characters in local part except dot, underscore, hyphen, plus
  // But cannot start with special character (already checked above)
  RegExp validLocalChars = RegExp(r'^[a-zA-Z0-9._\-+]+$');
  if (!validLocalChars.hasMatch(localPart)) {
    return "Username can only contain letters, numbers, dots, underscores, hyphens, and plus sign";
  }
  
  // Check TLD contains only letters
  RegExp validTldChars = RegExp(r'^[a-zA-Z]+$');
  if (!validTldChars.hasMatch(tld)) {
    return "Top-level domain must contain only letters";
  }
  
  // Check email length
  if (email.length > 254) {
    return "Email too long (max 254 characters)";
  }
  
  return null;
}


  bool? termsAndConditionAccepted = false;

  late NavigateAuthenticationProvider navigateAuthenticationProvider;
  late ThemeProvider themeProvider;
  late AppConfigProvider appConfigProvider;

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

  // Helper method to validate all fields before submission
// Replace your existing validateAllFields() method with this updated version
bool validateAllFields() {
  bool isValid = true;
  
  // Validate First Name
  if (firstNameController.text.isEmpty) {
    firstNameFieldError = "* Required";
    showFirstNameFieldError = true;
    isValid = false;
  } else if (firstNameController.text.length < 2) {
    firstNameFieldError = "First name should be at least 2 characters";
    showFirstNameFieldError = true;
    isValid = false;
  } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(firstNameController.text)) {
    firstNameFieldError = "Only alphabets are allowed";
    showFirstNameFieldError = true;
    isValid = false;
  } else if (firstNameController.text.length > 15) {
    firstNameFieldError = "First name should not exceed 15 characters";
    showFirstNameFieldError = true;
    isValid = false;
  } else {
    firstNameFieldError = "";
    showFirstNameFieldError = false;
  }
  
  // Validate Last Name
  if (lastNameController.text.isEmpty) {
    lastNameFieldError = "* Required";
    showLastNameFieldError = true;
    isValid = false;
  } else if (lastNameController.text.length < 3) {
    lastNameFieldError = "Last name should be at least 3 characters";
    showLastNameFieldError = true;
    isValid = false;
  } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(lastNameController.text)) {
    lastNameFieldError = "Only alphabets are allowed";
    showLastNameFieldError = true;
    isValid = false;
  } else if (lastNameController.text.length > 15) {
    lastNameFieldError = "Last name should not exceed 15 characters";
    showLastNameFieldError = true;
    isValid = false;
  } else {
    lastNameFieldError = "";
    showLastNameFieldError = false;
  }
  
  // Validate Email
  String? emailValidationError = validateEmail(emailController.text.trim());
  if (emailValidationError != null) {
    emailFieldError = emailValidationError;
    showEmailFieldError = true;
    isValid = false;
  } else {
    emailFieldError = "";
    showEmailFieldError = false;
  }
  
  // Validate Country
  if (_country == null || _country!.isEmpty) {
    countryFieldError = "Please select your country";
    showCountryFieldError = true;
    isValid = false;
  } else {
    countryFieldError = "";
    showCountryFieldError = false;
  }
  
  // Validate State
  if (_state == null || _state!.isEmpty) {
    stateFieldError = "Please select your state";
    showStateFieldError = true;
    isValid = false;
  } else {
    stateFieldError = "";
    showStateFieldError = false;
  }
  
  // Validate City
  if (_city == null) {
    cityFieldError = "Please select your city";
    showCityFieldError = true;
    isValid = false;
  } else {
    cityFieldError = "";
    showCityFieldError = false;
  }
  
  // Validate Password
  if (passwordController.text.isEmpty) {
    passwordFieldError = "* Required";
    showPasswordFieldError = true;
    isValid = false;
  } else if (passwordController.text.contains(" ")) {
    passwordFieldError = "Spaces are not allowed in password";
    showPasswordFieldError = true;
    isValid = false;
  } else if (passwordController.text.length < 8) {
    passwordFieldError = "Password must be at least 8 characters";
    showPasswordFieldError = true;
    isValid = false;
  } else if (!RegExp(r'[A-Z]').hasMatch(passwordController.text)) {
    passwordFieldError = "Password must contain at least one uppercase letter";
    showPasswordFieldError = true;
    isValid = false;
  } else if (!RegExp(r'[a-z]').hasMatch(passwordController.text)) {
    passwordFieldError = "Password must contain at least one lowercase letter";
    showPasswordFieldError = true;
    isValid = false;
  } else if (!RegExp(r'\d').hasMatch(passwordController.text)) {
    passwordFieldError = "Password must contain at least one number";
    showPasswordFieldError = true;
    isValid = false;
  } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(passwordController.text)) {
    passwordFieldError = "Password must contain at least one special character";
    showPasswordFieldError = true;
    isValid = false;
  } else {
    passwordFieldError = "";
    showPasswordFieldError = false;
  }
  
  // Validate Confirm Password
  if (confirmpasswordController.text.isEmpty) {
    rePasswordFieldError = "* Required";
    showRePasswordFieldError = true;
    isValid = false;
  } else if (confirmpasswordController.text != passwordController.text) {
    rePasswordFieldError = "Passwords do not match";
    showRePasswordFieldError = true;
    isValid = false;
  } else if (confirmpasswordController.text.contains(" ")) {
    rePasswordFieldError = "Spaces are not allowed in password";
    showRePasswordFieldError = true;
    isValid = false;
  } else if (confirmpasswordController.text.length < 8) {
    rePasswordFieldError = "Password must be at least 8 characters";
    showRePasswordFieldError = true;
    isValid = false;
  } else if (!RegExp(r'[A-Z]').hasMatch(confirmpasswordController.text)) {
    rePasswordFieldError = "Password must contain at least one uppercase letter";
    showRePasswordFieldError = true;
    isValid = false;
  } else if (!RegExp(r'[a-z]').hasMatch(confirmpasswordController.text)) {
    rePasswordFieldError = "Password must contain at least one lowercase letter";
    showRePasswordFieldError = true;
    isValid = false;
  } else if (!RegExp(r'\d').hasMatch(confirmpasswordController.text)) {
    rePasswordFieldError = "Password must contain at least one number";
    showRePasswordFieldError = true;
    isValid = false;
  } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(confirmpasswordController.text)) {
    rePasswordFieldError = "Password must contain at least one special character";
    showRePasswordFieldError = true;
    isValid = false;
  } else {
    rePasswordFieldError = "";
    showRePasswordFieldError = false;
  }
  
  // Validate Phone Number
  if (numberController.text.isEmpty) {
    phoneNumberFieldError = "* Required";
    showPhoneNumberFieldError = true;
    isValid = false;
  } else if (numberController.text.length != 10) {
    phoneNumberFieldError = "Mobile number must be exactly 10 digits";
    showPhoneNumberFieldError = true;
    isValid = false;
  } else if (!RegExp(r'^[0-9]+$').hasMatch(numberController.text)) {
    phoneNumberFieldError = "Only digits are allowed";
    showPhoneNumberFieldError = true;
    isValid = false;
  } else {
    phoneNumberFieldError = "";
    showPhoneNumberFieldError = false;
  }
  
  // Validate Terms & Conditions - Always show snackbar if not accepted
  if (termsAndConditionAccepted != true) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Please accept the Terms & Conditions to continue"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
    isValid = false;
  }
  
  // IMPORTANT: Call setState to update the UI with all error messages
  setState(() {});
  
  return isValid;
}



void _registerUser() async {
  // Trim email before validation
  emailController.text = emailController.text.trim();
  
  // Client-side validation first
  if (!validateAllFields()) {
    return;
  }

  
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
      },
      false
      );
    }).catchError((err) {
      restApiErrorDialog(context, error: err, apiState: _apiStateProvider!);
    });
  }


  // Add this method to show a summary of all validation errors
void showValidationErrorSummary() {
  List<String> errorMessages = [];
  
  // Check First Name
  if (firstNameController.text.isEmpty) {
    errorMessages.add("• First name is required");
  } else if (firstNameController.text.length < 2) {
    errorMessages.add("• First name must be at least 2 characters");
  } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(firstNameController.text)) {
    errorMessages.add("• First name should only contain alphabets");
  } else if (firstNameController.text.length > 15) {
    errorMessages.add("• First name should not exceed 15 characters");
  }
  
  // Check Last Name
  if (lastNameController.text.isEmpty) {
    errorMessages.add("• Last name is required");
  } else if (lastNameController.text.length < 3) {
    errorMessages.add("• Last name must be at least 3 characters");
  } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(lastNameController.text)) {
    errorMessages.add("• Last name should only contain alphabets");
  } else if (lastNameController.text.length > 15) {
    errorMessages.add("• Last name should not exceed 15 characters");
  }
  
  // Check Email
  if (emailController.text.isEmpty) {
    errorMessages.add("• Email address is required");
  } else if (!RegExp(r'^[\w\-.+]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailController.text)) {
    errorMessages.add("• Please enter a valid email address");
  }
  
  // Check Country
  if (_country == null || _country!.isEmpty) {
    errorMessages.add("• Please select your country");
  }
  
  // Check State
  if (_state == null || _state!.isEmpty) {
    errorMessages.add("• Please select your state");
  }
  
  // Check City
  if (_city == null) {
    errorMessages.add("• Please select your city");
  }
  
  // Check Password
  if (passwordController.text.isEmpty) {
    errorMessages.add("• Password is required");
  } else if (passwordController.text.contains(" ")) {
    errorMessages.add("• Password cannot contain spaces");
  } else if (passwordController.text.length < 8) {
    errorMessages.add("• Password must be at least 8 characters");
  } else {
    if (!RegExp(r'[A-Z]').hasMatch(passwordController.text)) {
      errorMessages.add("• Password must contain at least one uppercase letter");
    }
    if (!RegExp(r'[a-z]').hasMatch(passwordController.text)) {
      errorMessages.add("• Password must contain at least one lowercase letter");
    }
    if (!RegExp(r'\d').hasMatch(passwordController.text)) {
      errorMessages.add("• Password must contain at least one number");
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(passwordController.text)) {
      errorMessages.add("• Password must contain at least one special character");
    }
  }
  
  // Check Confirm Password
  if (confirmpasswordController.text.isEmpty) {
    errorMessages.add("• Please confirm your password");
  } else if (confirmpasswordController.text != passwordController.text) {
    errorMessages.add("• Passwords do not match");
  }
  
  // Check Phone Number
  if (numberController.text.isEmpty) {
    errorMessages.add("• Phone number is required");
  } else if (numberController.text.length != 10) {
    errorMessages.add("• Phone number must be exactly 10 digits");
  } else if (!RegExp(r'^[0-9]+$').hasMatch(numberController.text)) {
    errorMessages.add("• Phone number should only contain digits");
  }
  
  // Check Terms & Conditions
  if (termsAndConditionAccepted != true) {
    errorMessages.add("• Please accept the Terms & Conditions");
  }
  
  // Show dialog with all error messages
  if (errorMessages.isNotEmpty) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 28),
              SizedBox(width: 10),
              Text(
                "Validation Errors",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Please fix the following issues:",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 12),
                ConstrainedBox(
  constraints: BoxConstraints(maxHeight: 300),
  child: ListView.builder(
    shrinkWrap: true,
    itemCount: errorMessages.length,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 6.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "•",
              style: TextStyle(
                fontSize: 14,
                color: Colors.red,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                errorMessages[index].substring(2), // Remove the bullet point from message
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ],
        ),
      );
    },
  ),
),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "OK",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }
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
                        },
                      ))
                  : AppBar(
                      backgroundColor: Colors.transparent,
                    ),
              backgroundColor: (themeProvider.defaultTheme)?Colors.white:Colors.transparent,
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
                            imageUrl: appConfigProvider.appConfigData.data?.logo?.koshUrl ?? "",
                            fallbackAsset: "lib/global/assets/logos/dozendiamond_logo.jpeg",
                            width: 25,
                          ),
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
                  focusedBorderColor: showFirstNameFieldError ? Color(0xffd41f1f) : Color(0xff5cbbff),
                  borderRadius: 8,
                  labelText: '',
                  onChanged: (value) {
                    // Real-time validation
                    if (value.isNotEmpty) {
                      if (value.length >= 2 && RegExp(r'^[a-zA-Z]+$').hasMatch(value) && value.length <= 15) {
                        setState(() {
                          firstNameFieldError = "";
                          showFirstNameFieldError = false;
                        });
                      } else if (value.length < 2) {
                        setState(() {
                          firstNameFieldError = "First name should be at least 2 characters";
                          showFirstNameFieldError = true;
                        });
                      } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                        setState(() {
                          firstNameFieldError = "Only alphabets are allowed";
                          showFirstNameFieldError = true;
                        });
                      } else if (value.length > 15) {
                        setState(() {
                          firstNameFieldError = "First name should not exceed 15 characters";
                          showFirstNameFieldError = true;
                        });
                      }
                    } else {
                      setState(() {
                        firstNameFieldError = "";
                        showFirstNameFieldError = false;
                      });
                    }
                  },
                ),
              ),
              if (showFirstNameFieldError)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(firstNameFieldError, style: strings.warningText),
                ),
            ],
          ),
        ),
        const SizedBox(width: 10),
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
                  focusedBorderColor: showLastNameFieldError ? Color(0xffd41f1f) : const Color(0xff5cbbff),
                  borderRadius: 8,
                  labelText: '',
                  onChanged: (value) {
                    // Real-time validation
                    if (value.isNotEmpty) {
                      if (value.length >= 3 && RegExp(r'^[a-zA-Z]+$').hasMatch(value) && value.length <= 15) {
                        setState(() {
                          lastNameFieldError = "";
                          showLastNameFieldError = false;
                        });
                      } else if (value.length < 3) {
                        setState(() {
                          lastNameFieldError = "Last name should be at least 3 characters";
                          showLastNameFieldError = true;
                        });
                      } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                        setState(() {
                          lastNameFieldError = "Only alphabets are allowed";
                          showLastNameFieldError = true;
                        });
                      } else if (value.length > 15) {
                        setState(() {
                          lastNameFieldError = "Last name should not exceed 15 characters";
                          showLastNameFieldError = true;
                        });
                      }
                    } else {
                      setState(() {
                        lastNameFieldError = "";
                        showLastNameFieldError = false;
                      });
                    }
                  },
                ),
              ),
              if (showLastNameFieldError)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(lastNameFieldError, style: strings.warningText),
                ),
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
      SizedBox(
        height: 40,
        child: CustomContainer(
          padding: 0,
          borderRadius: 8,
          margin: EdgeInsets.zero,
          backgroundColor: (themeProvider.defaultTheme)
              ? Color(0xffCACAD3)
              : Color(0xff2c2c31),
          borderColor: showCountryFieldError
              ? Color(0xffd41f1f)
              : (themeProvider.defaultTheme ? Color(0xffCACAD3) : Color(0xff2c2c31)),
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8.0),
            child: DropdownSearch<String>(
              selectedItem: _country,
              items: (filter, infiniteScrollProps) => countries,
              compareFn: (item, selectedItem) => item == selectedItem,
              onSelected: (selectedItem) {
                if (selectedItem == null) return;
                setState(() {
                  _country = selectedItem;
                  _state = null;
                  _city = null;
                  showCountryFieldError = false;
                  countryFieldError = "";
                });
              },
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  hintText: 'Select country',
                  hintStyle: TextStyle(
                    color: (themeProvider.defaultTheme) ? Colors.black : Colors.white,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                ),
              ),
              dropdownBuilder: (context, selectedItem) {
                return Text(
                  selectedItem ?? 'Select country',
                  style: TextStyle(
                    color: (themeProvider.defaultTheme)
                        ? Colors.black
                        : Colors.white,
                  ),
                );
              },
              popupProps: PopupProps.menu(
                showSearchBox: true,
                searchDelay: Duration.zero,
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                    hintText: 'Search country...',
                    hintStyle: TextStyle(
                      color: (themeProvider.defaultTheme)
                          ? Colors.black
                          : Colors.white,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                menuProps: MenuProps(
                  backgroundColor: (themeProvider.defaultTheme)
                      ?Color(0xffCACAD3):Color(0xff2c2c31),
                ),
                itemBuilder: (context, item, isDisabled, isSelected) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: Text(
                    item,
                    style: TextStyle(
                      color: (themeProvider.defaultTheme)
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      if (showCountryFieldError)
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(countryFieldError, style: strings.warningText),
        ),

      if (states.isNotEmpty)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
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
                    ? Color(0xffCACAD3)
                    : Color(0xff2c2c31),
                borderColor: showStateFieldError
                    ? Color(0xffd41f1f)
                    : (themeProvider.defaultTheme ? Color(0xffCACAD3) : Color(0xff2c2c31)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8.0),
                  child: DropdownSearch<String>(
                    selectedItem: _state,
                    items: (filter, infiniteScrollProps) => states,
                    compareFn: (item, selectedItem) => item == selectedItem, 
                    onSelected: (selectedItem) {
                      if (selectedItem == null) return;
                      setState(() {
                        _state = selectedItem;
                        _city = null;
                        showStateFieldError = false;
                        stateFieldError = "";
                      });
                    },
                    decoratorProps: DropDownDecoratorProps(
                      decoration: InputDecoration(
                        
                        hintStyle: TextStyle(
                          color: (themeProvider.defaultTheme)
                              ? Colors.black
                              : Colors.white,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      ),
                    ),
                    dropdownBuilder: (context, selectedItem) {
                      return Text(
                        selectedItem ?? 'Select State',
                        style: TextStyle(
                          color: (themeProvider.defaultTheme)
                              ? Colors.black
                              : Colors.white,
                        ),
                      );
                    },
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchDelay: Duration.zero,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          hintText: 'Search state...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      menuProps: MenuProps(
                        backgroundColor: (themeProvider.defaultTheme)
                      ?Color(0xffCACAD3):Color(0xff2c2c31),
                      ),
                      itemBuilder: (context, item, isDisabled, isSelected) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: Text(
                    item,
                    style: TextStyle(
                      color: (themeProvider.defaultTheme)
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),
                    ),
                  ),
                ),
              ),
            ),
            if (showStateFieldError)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(stateFieldError, style: strings.warningText),
              ),
          ],
        ),

      if (cities.isNotEmpty)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
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
                    ? Color(0xffCACAD3)
                    : Color(0xff2c2c31),
                borderColor: showCityFieldError
                    ? Color(0xffd41f1f)
                    : (themeProvider.defaultTheme ? Color(0xffCACAD3) : Color(0xff2c2c31)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8.0),
                  child: DropdownSearch<City>(
                    selectedItem: _city,
                    items: (filter, infiniteScrollProps) => cities,
                    compareFn: (item, selectedItem) => item.name == selectedItem.name, itemAsString: (City city) => city.name,
                    onSelected: (selectedItem) {
                      if (selectedItem == null) return;
                      setState(() {
                        _city = selectedItem;
                        showCityFieldError = false;
                        cityFieldError = "";
                      });
                    },
                    decoratorProps: DropDownDecoratorProps(
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          color: (themeProvider.defaultTheme)
                              ? Colors.black
                              : Colors.white,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      ),
                    ),
                    dropdownBuilder: (context, selectedItem) {
                      return Text(
                        selectedItem?.name ?? 'Select City',
                        style: TextStyle(
                          color: (themeProvider.defaultTheme)
                              ? Colors.black
                              : Colors.white,
                        ),
                      );
                    },
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchDelay: Duration.zero,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          hintText: 'Search city...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      menuProps: MenuProps(
                        backgroundColor: (themeProvider.defaultTheme)
                      ?Color(0xffCACAD3):Color(0xff2c2c31),
                      ),
                      itemBuilder: (context, item, isDisabled, isSelected) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: Text(
                    item.name,
                    style: TextStyle(
                      color: (themeProvider.defaultTheme)
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),
                    ),
                  ),
                ),
              ),
            ),
            if (showCityFieldError)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(cityFieldError, style: strings.warningText),
              ),
          ],
        ),
    ],
  );
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
              ? Color(0xffCACAD3)
              : Color(0xff2c2c31),
          borderColor: (themeProvider.defaultTheme)
              ? Color(0xffCACAD3)
              : Color(0xff2c2c31),
          textStyle: TextStyle(
            color: (themeProvider.defaultTheme)
                ? Colors.black
                : Colors.white,
          ),
          controller: emailController,
          elevation: 0,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          margin: EdgeInsets.zero,
          focusedBorderColor:
              (showEmailFieldError) ? Color(0xffd41f1f) : Color(0xff5cbbff),
          borderRadius: 8,
          labelText: '',
          onChanged: (value) {
            // Real-time validation
            String? validationError = validateEmail(value.trim());
            setState(() {
              if (validationError != null) {
                emailFieldError = validationError;
                showEmailFieldError = true;
              } else {
                emailFieldError = "";
                showEmailFieldError = false;
              }
            });
          },
        ),
      ),
      if (showEmailFieldError)
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(emailFieldError, style: strings.warningText),
        ),
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
            focusedBorderColor: showPasswordFieldError ? Color(0xffd41f1f) : Color(0xff5cbbff),
            maxLine: 1,
            borderRadius: 8,
            isPasswordField: true,
            labelText: '',
            onChanged: (value) {
              // Real-time validation
              _validatePassword(value);
              // Also validate confirm password if it has content
              if (confirmpasswordController.text.isNotEmpty) {
                _validateConfirmPassword(confirmpasswordController.text);
              }
            },
          ),
        ),
        if (showPasswordFieldError)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(passwordFieldError, style: strings.warningText),
          ),
      ],
    );
  }

  void _validatePassword(String value) {
    if (value.isEmpty) {
      setState(() {
        passwordFieldError = "";
        showPasswordFieldError = false;
      });
    } else if (value.contains(" ")) {
      setState(() {
        passwordFieldError = "Spaces are not allowed in password";
        showPasswordFieldError = true;
      });
    } else if (value.length < 8) {
      setState(() {
        passwordFieldError = "Password must be at least 8 characters";
        showPasswordFieldError = true;
      });
    } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
      setState(() {
        passwordFieldError = "Password must contain at least one uppercase letter";
        showPasswordFieldError = true;
      });
    } else if (!RegExp(r'[a-z]').hasMatch(value)) {
      setState(() {
        passwordFieldError = "Password must contain at least one lowercase letter";
        showPasswordFieldError = true;
      });
    } else if (!RegExp(r'\d').hasMatch(value)) {
      setState(() {
        passwordFieldError = "Password must contain at least one number";
        showPasswordFieldError = true;
      });
    } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      setState(() {
        passwordFieldError = "Password must contain at least one special character";
        showPasswordFieldError = true;
      });
    } else {
      setState(() {
        passwordFieldError = "";
        showPasswordFieldError = false;
      });
    }
  }

  void _validateConfirmPassword(String value) {
    if (value.isEmpty) {
      setState(() {
        rePasswordFieldError = "";
        showRePasswordFieldError = false;
      });
    } else if (value != passwordController.text) {
      setState(() {
        rePasswordFieldError = "Passwords do not match";
        showRePasswordFieldError = true;
      });
    } else if (value.contains(" ")) {
      setState(() {
        rePasswordFieldError = "Spaces are not allowed in password";
        showRePasswordFieldError = true;
      });
    } else if (value.length < 8) {
      setState(() {
        rePasswordFieldError = "Password must be at least 8 characters";
        showRePasswordFieldError = true;
      });
    } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
      setState(() {
        rePasswordFieldError = "Password must contain at least one uppercase letter";
        showRePasswordFieldError = true;
      });
    } else if (!RegExp(r'[a-z]').hasMatch(value)) {
      setState(() {
        rePasswordFieldError = "Password must contain at least one lowercase letter";
        showRePasswordFieldError = true;
      });
    } else if (!RegExp(r'\d').hasMatch(value)) {
      setState(() {
        rePasswordFieldError = "Password must contain at least one number";
        showRePasswordFieldError = true;
      });
    } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      setState(() {
        rePasswordFieldError = "Password must contain at least one special character";
        showRePasswordFieldError = true;
      });
    } else {
      setState(() {
        rePasswordFieldError = "";
        showRePasswordFieldError = false;
      });
    }
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
            focusedBorderColor: showRePasswordFieldError ? Color(0xffd41f1f) : const Color(0xff5cbbff),
            borderRadius: 8,
            labelText: '',
            onChanged: (value) {
              _validateConfirmPassword(value);
            },
          ),
        ),
        if (showRePasswordFieldError)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(rePasswordFieldError, style: strings.warningText),
          ),
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
                  selectedCountryCode = newValue;
                });
              }
            },
            controller: numberController,
            keyboardType: TextInputType.numberWithOptions(),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            isForPhoneNumber: true,
            elevation: 0,
            margin: EdgeInsets.zero,
            focusedBorderColor: showPhoneNumberFieldError ? Color(0xffd41f1f) : const Color(0xff5cbbff),
            borderRadius: 8,
            labelText: '',
            onChanged: (value) {
              // Real-time validation
              if (value.isNotEmpty) {
                if (value.length == 10 && RegExp(r'^[0-9]+$').hasMatch(value)) {
                  setState(() {
                    phoneNumberFieldError = "";
                    showPhoneNumberFieldError = false;
                  });
                } else if (value.length != 10) {
                  setState(() {
                    phoneNumberFieldError = "Mobile number must be exactly 10 digits";
                    showPhoneNumberFieldError = true;
                  });
                } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                  setState(() {
                    phoneNumberFieldError = "Only digits are allowed";
                    showPhoneNumberFieldError = true;
                  });
                }
              } else {
                setState(() {
                  phoneNumberFieldError = "";
                  showPhoneNumberFieldError = false;
                });
              }
              setState(() {
                numberController.text = value;
              });
            },
          ),
        ),
        if (showPhoneNumberFieldError)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(phoneNumberFieldError, style: strings.warningText),
          ),
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
                    tristate: true,
                    value: termsAndConditionAccepted,
                    activeColor: Colors.blue,
                    side: BorderSide(
                        color: (themeProvider.defaultTheme)
                            ? Colors.black
                            : Colors.white),
                    onChanged: (bool? newValue) {
                      setState(() {
                        termsAndConditionAccepted = !termsAndConditionAccepted!;
                        // Enable/disable continue button based on checkbox
                        isContinueButtonEnabled = termsAndConditionAccepted == true;
                      });
                    },
                  ),
                ),
                SizedBox(width: 8),
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
                              final Uri url = Uri.parse("https://dozendiamonds.com/terms-of-use/");
                              await launchUrl(url, mode: LaunchMode.externalApplication);
                            },
                          text: strings.termsOfUse,
                          style: strings.linkTextWithUnderline,
                        ),
                        TextSpan(
                          text: ' ${strings.and} ',
                          style: strings.aboveFieldText.copyWith(
                            color: (themeProvider.defaultTheme)?Colors.black:Colors.white,
                          ),
                        ),
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final Uri url = Uri.parse("https://dozendiamonds.com/privacy-policy/");
                              await launchUrl(url, mode: LaunchMode.externalApplication);
                            },
                          text: strings.privacyPolicy,
                          style: strings.linkTextWithUnderline,
                        ),
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
  child: Tooltip(
    message: isContinueButtonEnabled 
        ? "Click to continue" 
        : "Please accept Terms & Conditions to continue",
    child: Opacity(
      opacity: isContinueButtonEnabled ? 1.0 : 0.5,
      child: CustomContainer(
        onTap: isContinueButtonEnabled
            ? () {
                // Only validate fields - shows red error messages below each field
                if (validateAllFields()) {
                  _registerUser();
                }
              }
            : null, // Disable onTap when button is disabled
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
