

import 'dart:convert';

import '../model/base_response.dart';
import '../model/error_response.dart';
import '../model/send_aadhaar_otp_response.dart';
import '../model/submit_aadhaar_otp_response.dart';
import '../utility/constants.dart';
import '../utility/utils.dart';
import 'kyc_api_routes.dart';
import 'package:http/http.dart' as http;

class KycApiService {

  static Map<String, String> headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'X-API-Key': Constants.aadhaarVerificationApiKey,
    'X-Auth-Type': 'API-Key',
  };

  Future<BaseResponse<SendAadhaarOtpResponse>> generateOtp(String aadhaarNumber, String consent) async {

    final url = Uri.parse('${Constants.verificationBaseUrl}${KycApiRoutes.aadhaarVerificationGenerateOtp}');

    final body = jsonEncode({
      'aadhaar_number': aadhaarNumber,
      'consent': consent,
    });

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      // Handle successful response
      print('OTP generated successfully: ${response.body}');
      return BaseResponse()..data = SendAadhaarOtpResponse.fromJson(jsonDecode(response.body));
    } else {
      // Handle error response
      print('Failed to generate OTP: ${response.statusCode}');
      print(response.body);
      Utility.showSingleTextToast(response.body);

      return BaseResponse()
             ..setException(ErrorResponse.fromJson(jsonDecode(response.body)));

    }
  }

  // Function to submit OTP
  Future<BaseResponse<SubmitAadhaarOtpResponse>> submitOtp(String transactionId, String otp, bool includeXml, String shareCode) async {

    final url = Uri.parse('${Constants.verificationBaseUrl}${KycApiRoutes.aadhaarVerificationSubmitOtp}');

    final body = jsonEncode({
      'otp': otp,
      'include_xml': includeXml,
      'share_code': shareCode,
    });

    final response = await http.post(
      url,
      headers: {
        ...headers,
        'X-Transaction-ID': transactionId,
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print('44');
      // Handle successful response
      print('OTP submitted successfully: ${response.body}');
      return BaseResponse()..data = SubmitAadhaarOtpResponse.fromJson(jsonDecode(response.body));
    } else {
      print('11');
      // Handle error response
      print('Failed to submit OTP: ${response.statusCode}');
      print(response.body);
      return BaseResponse()
        ..setException(ErrorResponse.fromJson(jsonDecode(response.body)));
    }
  }

}


// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// import '../utility/constants.dart';
//
// // Define a base URL and headers for reuse
// const String baseUrl = 'https://api.gridlines.io/aadhaar-api/boson/';
//
//
// // Function to generate OTP
//
//
// void main() async {
//   // Example usage
//   await generateOtp('337XXXXXXXXX', 'Y');
//   await submitOtp('your-transaction-id', '345579', true, '1234');
// }
