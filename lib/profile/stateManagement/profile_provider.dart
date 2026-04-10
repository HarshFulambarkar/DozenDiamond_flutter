import 'dart:convert';
import 'dart:developer';

import 'package:dozen_diamond/ZL_Register/models/country_state_model.dart';
import 'package:dozen_diamond/profile/model/update_profile_data_response.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../ZL_Register/constants/countryCodeFlags.dart';
import '../../ZL_Register/models/mobile_number_codes_model.dart';
import '../model/phone_verify_data_response.dart';
import '../model/profile_data.dart';
import '../model/profile_data_response.dart';
import '../services/profile_api_service.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileProvider(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  bool _isEditProfileEnable = false;

  bool get isEditProfileEnable => _isEditProfileEnable;

  set isEditProfileEnable(bool value) {
    _isEditProfileEnable = value;
    notifyListeners();
  }

  ProfileData _profileData = ProfileData();

  ProfileData get profileData => _profileData;

  set profileData(ProfileData value) {
    _profileData = value;
    notifyListeners();
  }

  bool _isProfileLoading = false;

  bool get isProfileLoading => _isProfileLoading;

  set isProfileLoading(bool value) {
    _isProfileLoading = value;
    notifyListeners();
  }

  TextEditingController nameTextEditingController = TextEditingController();
  // TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();

  MobileNumberCodeModel _countryCode = mobileNumberCodes[0];

  MobileNumberCodeModel get countryCode => _countryCode;

  set countryCode(MobileNumberCodeModel value) {
    _countryCode = value;
    notifyListeners();
  }

  // TextEditingController phoneVerifyOtpEditingController = TextEditingController();
  String _phoneVerificationOtp = "";

  String get phoneVerificationOtp => _phoneVerificationOtp;

  set phoneVerificationOtp(String value) {
    _phoneVerificationOtp = value;
    notifyListeners();
  }

  String? _state = null;
  String? get state => _state;

  set state(String? value) {
    _state = value;
    notifyListeners();
  }

  City? _city;

  City? get city => _city;

  set city(City? value) {
    _city = value;
    _cityName = value?.name;
    notifyListeners();
  }

  String? _cityName;
  String? get cityName => _cityName;

  set cityName(String? value) {
    _cityName = value;
    notifyListeners();
  }

  String _country = "India";
  String get country => _country;

  set country(String value) {
    _country = value;
    notifyListeners();
  }

  void fillDataInTextField() {
    nameTextEditingController.text = profileData.regUsername ?? "";
    // emailTextEditingController.text = profileData.regEmail ?? "";
    if(profileData.regMobile != null) {
      if(profileData.regMobile!.split("-").length > 1) {
        phoneTextEditingController.text = profileData.regMobile!.split("-")[1];
      } else {
        phoneTextEditingController.text = profileData.regMobile ?? "";
      }
    }

    countryCode = mobileNumberCodes[0];
    SharedPreferences.getInstance().then((value) {
      value.setString("reg_user", profileData.regUsername ?? "");
    });
  }

  void resetDataInTextField() {
    nameTextEditingController.text = "";
    // emailTextEditingController.text = "";
    phoneTextEditingController.text = "";
    phoneVerificationOtp = "";
    isEditProfileEnable = false;
    isProfileLoading = false;
  }

  Future<void> updateProfile() async {
    isProfileLoading = true;
    try {
      Map<String, dynamic> request = {
        "reg_username": nameTextEditingController.text,
        // "dob": "",
        // "reg_mobile": "${countryCode.countryCode}-${phoneTextEditingController.text}",
        "state": state,
        "city": city?.name,
        "country": country,
      };
      log("updating profile");     print(request);
      UpdateProfileDataResponse? res = await ProfileRestApiService()
          .updateProfileData(request);

      if (res.status!) {
        isProfileLoading = false;
        print(res.data!);
        profileData = res.data!;
        fillDataInTextField();
      } else {
        isProfileLoading = false;
      }
    } catch (e) {
      isProfileLoading = false;
      throw e;
    }
  }

  Future<void> getProfileData() async {

    isProfileLoading = true;
    try {

      ProfileDataResponse? res =
      await ProfileRestApiService().getProfileData();

      if(res.status!) {
        isProfileLoading = false;
        profileData = res.data!;
      } else {

        isProfileLoading = false;
      }
    } catch (e) {
      isProfileLoading = false;
      throw e;
    }

  }

  Future<void> sendVerifyPhoneNumberOtp(BuildContext context) async {

    try {

      final hash = await SmsAutoFill().getAppSignature;
      print("App Signature");
      print(hash);

      Map<String, dynamic> request = {
        // "app_signature": phoneVerificationOtp,
        "app_signature": hash,
      };

      PhoneVerifyDataResponse? res =
      await ProfileRestApiService().sendVerifyPhoneNumberOtp(request);

      if(res.status!) {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Otp Sent Successfully')),
        );
      } else {


      }
    } catch (e) {

      throw e;
    }

  }

  Future<void> verifyPhoneNumber(BuildContext context) async {

    try {

      Map<String, dynamic> request = {
        "otp": phoneVerificationOtp,
      };

      PhoneVerifyDataResponse? res =
      await ProfileRestApiService().verifyPhoneNumber(request);

      if(res.status!) {
        phoneVerificationOtp = "";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Phone Number Verified Successfully')),
        );
      } else {


      }
    } catch (e) {

      throw e;
    }

  }


}