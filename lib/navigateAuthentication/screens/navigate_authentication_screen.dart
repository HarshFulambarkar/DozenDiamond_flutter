import 'dart:io';

import 'package:dozen_diamond/ZL_Register/screens/signup_page_new.dart';
import 'package:dozen_diamond/global/stateManagement/app_config_provider.dart';
import 'package:dozen_diamond/login/screens/forgot_password_screen_new.dart';
import 'package:dozen_diamond/login/screens/forgot_password_verification.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ZG_signupEmail/widgets/verify_email_screen_new.dart';
import '../../ZG_signupEmail/widgets/verify_only_email_screen_new.dart';
import '../../ZG_signupEmail/widgets/verify_only_phone_number_screen_new.dart';
import '../../ZL_Register/models/country_state_model.dart';
import '../../ZM_mpin/screens/mpin_generation_page_new.dart';
import '../../ZM_mpin/screens/mpin_validator_page_new.dart';
import '../../global/screens/no_internet_screen.dart';
import '../../global/stateManagement/connectivity_provider.dart';
import '../../kyc/screens/verify_aadhaar_screen.dart';
import '../../login/screens/enter_new_password_screen_new.dart';
import '../../login/screens/login_page_new.dart';
import '../stateManagement/navigate_authentication_provider.dart';
class NavigateAuthenticationScreen extends StatefulWidget {
  @override
  State<NavigateAuthenticationScreen> createState() =>
      _NavigateAuthenticationScreenState();
}

class _NavigateAuthenticationScreenState
    extends State<NavigateAuthenticationScreen> {
  bool displayFilterDialog = true;

  late NavigateAuthenticationProvider navigateAuthenticationProvider;
  late ConnectivityProvider connectivityProvider;

  CountryStateCityData countryStateCityData = CountryStateCityData();

  List get pages => [
        // SignUpPage(), // 0
        SignUpPageNew(countryStateCityData: countryStateCityData), // 0
        // LoginPage(), // 1
        LoginPageNew(), // 1
        // MpinValidatorPage(), // 2
        // MpinValidatorPage(fetchUserData: true), // 3
        MpinValidatorPageNew(), // 2
        MpinValidatorPageNew(fetchUserData: true), // 3
        ForgotPasswordScreenNew(), // 5
        // ForgotPasswordScreen(), // 4
        // LoginPage(forgotMpin: true,), // 5
        LoginPageNew(
          forgotMpin: true,
        ), // 5
        // MpinGenerationPage(
        //   regId: navigateAuthenticationProvider.regId,
        // ), // 6
        MpinGenerationPageNew(
          regId: navigateAuthenticationProvider.regId,
        ), // 6

        VerifyEmailScreenNew(), // 7
        ForgotPasswordVerificationScreen(), // 8
        EnterNewPasswordScreenNew(), // 9
        VerifyOnlyEmailScreenNew(), // 10
        VerifyOnlyPhoneNumberScreenNew(), // 11
        VerifyAadhaarScreen() // 12

      ];

  @override
  void initState() {
    super.initState();

    handlePopUp();
    loadCountryData();
  }

  loadCountryData() {
    countryStateCityData.load();
  }

  handlePopUp() async {
    AppConfigProvider appConfigProvider =
        Provider.of<AppConfigProvider>(context, listen: false);
    await appConfigProvider.getAppConfig();
    if (kIsWeb == false) {
      if (Platform.isIOS || Platform.isAndroid) {
        appConfigProvider.handleAppUpdate(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    navigateAuthenticationProvider =
        Provider.of<NavigateAuthenticationProvider>(context, listen: true);
    connectivityProvider = Provider.of<ConnectivityProvider>(context, listen: true);

    return
      // (connectivityProvider.connectionStatus.contains(ConnectivityResult.wifi) ||
      //   connectivityProvider.connectionStatus.contains(ConnectivityResult.mobile) ||
      //   connectivityProvider.connectionStatus.contains(ConnectivityResult.ethernet) ||
      //   connectivityProvider.connectionStatus.contains(ConnectivityResult.vpn))?
      (true)?Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Scaffold(
          body: pages[navigateAuthenticationProvider.selectedIndex],
        ),
      ):NoInternetScreen();
  }
}
