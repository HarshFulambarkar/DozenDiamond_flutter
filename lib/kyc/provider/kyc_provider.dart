import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../model/aadhaar_data.dart';
import '../screens/enter_verification_opt.dart';
import '../services/kyc_api_service.dart';
import '../utility/utils.dart';
import '../widgets/custom_bottom_sheets.dart';

class KycProvider extends ChangeNotifier {
  KycProvider(this.navigatorKey);
  final GlobalKey<NavigatorState> navigatorKey;

  final ImagePicker picker = ImagePicker();

  TextEditingController panCardController = TextEditingController();

  File _aadharFrontImage = File("");

  File get aadharFrontImage => _aadharFrontImage;

  set aadharFrontImage(File value) {
    _aadharFrontImage = value;
    notifyListeners();
  }

  String _aadharFrontImageLink = "";

  String get aadharFrontImageLink => _aadharFrontImageLink;

  set aadharFrontImageLink(String value) {
    _aadharFrontImageLink = value;
    notifyListeners();
  }

  File _aadharBackImage = File("");

  File get aadharBackImage => _aadharBackImage;

  set aadharBackImage(File value) {
    _aadharBackImage = value;
    notifyListeners();
  }

  String _aadharBackImageLink = "";

  String get aadharBackImageLink => _aadharBackImageLink;

  set aadharBackImageLink(String value) {
    _aadharBackImageLink = value;
    notifyListeners();
  }

  TextEditingController aadharCardController = TextEditingController();

  String _recognizedText = 'No text recognized yet';

  String get recognizedText => _recognizedText;

  set recognizedText(String value) {
    _recognizedText = value;
    notifyListeners();
  }

  TextEditingController aadhaarVerificationOtpController = TextEditingController();

  AadhaarData _aadhaarData = AadhaarData();

  AadhaarData get aadhaarData => _aadhaarData;

  set aadhaarData(AadhaarData value) {
    _aadhaarData = value;
    notifyListeners();
  }

  String _transactionId = "";

  String get transactionId => _transactionId;

  set transactionId(String value) {
    _transactionId = value;
    notifyListeners();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> clickImageAndRecognizeText() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final text = await recognizeTextFromImage(pickedFile);

      recognizedText = text;

    }
  }

  Future<void> pickImageAndRecognizeText() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final text = await recognizeTextFromImage(pickedFile);

      recognizedText = text;

    }
  }

  String extractAadhaarNumber(String text) {
    final RegExp aadhaarRegExp = RegExp(r'\b\d{4} \d{4} \d{4}\b');
    final match = aadhaarRegExp.firstMatch(text);
    return match?.group(0) ?? 'Not found';
  }

  Future<String> recognizeTextFromImage(XFile imageFile) async {
    // final textRecognizer = TextRecognizer();
    // final inputImage = InputImage.fromFilePath(imageFile.path);
    //
    // final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    // await textRecognizer.close();
    //
    // // Combine all blocks of text into a single string
    // return recognizedText.blocks.map((block) => block.text).join('\n');
    return "";
  }

  Future<void> sendAadhaarOtp(BuildContext context) async {
    isLoading = true;
    await KycApiService().generateOtp(aadharCardController.text, 'Y').then((value) {
      if (value.data != null) {
        transactionId = value.data!.data!.transactionId!;
        Utility.showSingleSuccessToast(value.data!.data!.message!);

        CustomBottomSheets.showBottomSheetWithHeightWithoutClose(
            EnterVerificationOpt(), context,
            height: 230, enableDrag: false, isDismissible: false);

      } else {
        // Utility.showSingleSuccessToast("Something went wrong");
      }
    });

    isLoading = false;
  }

  Future<bool> submitAadhaarOtp() async {
    isLoading = true;
    final value = await KycApiService().submitOtp(transactionId, aadhaarVerificationOtpController.text, true, '1234');
    if(value.data != null) {
      print('1');
      if (value.data!.data != null) {
        print('2');
        // Utility.showSingleSuccessToast(value.data!.data!.message!);
        aadhaarData = value.data!.data!.aadhaarData!;
        // Navigator.pop(navigatorKey.currentState!.context);
        isLoading = false;
        return true;

      } else {
        print('3');
        // Navigator.pop(navigatorKey.currentState!.context);
        Utility.showSingleSuccessToast("Something went wrong");
        isLoading = false;
        return false;
      }
    }else {
      print('4');
      Utility.showSingleSuccessToast("Something went wrong");
      isLoading = false;
      return false;
    }
  }

}