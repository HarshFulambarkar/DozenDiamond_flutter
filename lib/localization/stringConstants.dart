import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StringConstants {
  String signUpTitle = "Create your account";
  String signUpBody =
      "Get access to advanced algorithms, real-time insights, and automated trading strategies.";

  String firstName = "First Name";
  String lastName = "Last Name";
  String firstNameError =
      "Name should not contain numbers or special characters";
  String lastNameError =
      "Name should not contain numbers or special characters";

  String email = "Email";
  String emailError = "Please enter a valid email ID";

  String password = "Password";
  String passwordHint =
      "Your password must be at least 8 characters long, include a mix of uppercase, lowercase, numbers, and special characters.";
  String confirmPassword = "Re-enter password";
  String passwordMismatchError = "Your passwords don’t match, please try again";

  String phoneNumber = "Phone Number";

  String termsAndConditions = "By signing up, you agree to our ";
  String termsOfUse = "Terms of Use ";
  String and = "and ";
  String privacyPolicy = "Privacy Policy";

  String continueButton = "Continue";
  String alreadyHaveAccount = "Already a user? Click here to ";
  String logInText = "Login";
  String forgotPassword = "Forgot Password";
  String forgotPasswordSubTitle =
      "Enter the email associated with your account.";

  String sixDigitVerification =
      "We have sent you a 6-digit verification code at  ";

  String resendCode = "Resend Code";
  String requestAgain = "Code resent. You can request again in ";
  String verificationCode = "Verification code";

  String goBack = "Go Back";

  TextStyle aboveFieldText = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w300,
  );
  TextStyle linkText = GoogleFonts.poppins(
    fontSize: 13, //14.5,
    fontWeight: FontWeight.w600,
    color: Color(0xff1a94f2),
  );
  TextStyle linkTextWithUnderline = GoogleFonts.poppins(
    decoration: TextDecoration.underline,
    fontSize: 13, // 14.5,
    fontWeight: FontWeight.w600,
    color: Color(0xff1a94f2),
  );
  TextStyle warningText = GoogleFonts.poppins(
      fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xffd41f1f));
  TextStyle subtitleStyleForSignup = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: "Britanica",
  );
  TextStyle subtitleStyle = GoogleFonts.poppins(
    fontSize: 14,
    color: Colors.white,
    fontWeight: FontWeight.w400,
  );

  TextStyle infoStyle = GoogleFonts.poppins(
    fontWeight: FontWeight.w400,
    fontSize: 11,
    color: Colors.white,
  );
  TextStyle inkWellStyle = GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    fontSize: 11,
    color: Color(0xff5cbbff),
  );
}
