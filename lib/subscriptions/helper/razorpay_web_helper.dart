// import 'dart:js' as jss;
// import 'dart:convert';

// void openRazorpayCheckoutWeb(Map<String, dynamic> options) {
//   final optionsJson = jsonEncode(options);
//   jss.context.callMethod('openRazorpayCheckout', [optionsJson]);
// }

// void setupRazorpayHandlers({
//   required Function(String paymentId, String orderId, String signature) onSuccess,
//   required Function() onFailure,
// }) {
//     // Register the success handler
//     jss.context['paymentSuccessHandler'] = (response) {
//       print(response['razorpay_payment_id']);
//       final paymentId = response['razorpay_payment_id'];
//       final orderId = response['razorpay_order_id'];
//       final signature = response['razorpay_signature'];
//       if (paymentId != null) {
//         onSuccess(paymentId, orderId, signature);
//       } else {
//         print("Error: paymentId not found in response.");
//       }
//       // final paymentId = js.JsObject.jsify(response)['razorpay_payment_id'];
//       // onSuccess(paymentId);
//     };

//     // Register the failure handler
//     jss.context['paymentFailureHandler'] = (response) {
//       print(response);
//       onFailure();
//     };

// }