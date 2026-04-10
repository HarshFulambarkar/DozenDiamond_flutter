
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../global/models/http_api_exception.dart';
import '../../global/stateManagement/user_config_provider.dart';
import '../models/generate_order_data.dart';
import '../models/generate_order_data_response.dart';
import '../models/subscribe_data.dart';
import '../models/subscribe_data_response.dart';
import '../models/subscribed_data.dart';
import '../models/subscribed_data_response.dart';
import '../models/subscription_plan_data.dart';
import '../models/subscription_plan_data_response.dart';
import '../models/verify_payment_response.dart';
import '../models/verify_subscription_payment_response.dart';
import '../screens/subscribed_screen.dart';
import '../service/subscription_rest_api_service.dart';

class SubscriptionProvider extends ChangeNotifier {
  final GlobalKey<NavigatorState> navigatorKey;

  // Map to track loading state for each plan individually
  Map<String, bool> _isPaymentLoading = {};

  Map<String, bool> get isPaymentLoading => _isPaymentLoading;

  // Helper method to check if a specific plan is loading
  bool isPlanLoading(String planId) {
    return _isPaymentLoading[planId] ?? false;
  }

  // Helper method to set loading state for a specific plan
  void setPlanLoading(String planId, bool isLoading) {
    _isPaymentLoading[planId] = isLoading;
    notifyListeners();
  }

  // Clear all loading states (useful for error scenarios)
  void clearAllLoadingStates() {
    _isPaymentLoading.clear();
    notifyListeners();
  }

  List<SubscriptionPlanData> _subscriptionList = [];

  List<SubscriptionPlanData> get subscriptionList => _subscriptionList;

  set subscriptionList(List<SubscriptionPlanData> value) {
    _subscriptionList = value;
    notifyListeners();
  }

  SubscribedData _subscribedData = SubscribedData();

  SubscribedData get subscribedData => _subscribedData;

  set subscribedData(SubscribedData value) {
    _subscribedData = value;
    notifyListeners();
  }

  SubscriptionPlanData _selectedSubscribeData = SubscriptionPlanData();

  SubscriptionPlanData get selectedSubscribeData => _selectedSubscribeData;

  set selectedSubscribeData(SubscriptionPlanData value) {
    _selectedSubscribeData = value;
    notifyListeners();
  }

  late Razorpay _razorpay;

  GenerateOrderData _generateOrderData = GenerateOrderData();

  GenerateOrderData get generateOrderData => _generateOrderData;

  set generateOrderData(GenerateOrderData value) {
    _generateOrderData = value;
    notifyListeners();
  }

  // Remove this single loading flag since we're using the map
  // bool _isSubscriptionButtonLoading = false;
  // bool get isSubscriptionButtonLoading => _isSubscriptionButtonLoading;
  // set isSubscriptionButtonLoading(bool value) {
  //   _isSubscriptionButtonLoading = value;
  //   notifyListeners();
  // }

  SubscriptionProvider(this.navigatorKey) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print(response.toString());
    print(
        "Payment successful: ${response.orderId} ${response.paymentId} ${response.signature}");
    verifySubscription(subscribeData.id);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Clear loading state for the current plan on error
    if (subscribeData.planId != null) {
      setPlanLoading(subscribeData.planId.toString(), false);
    }
    Fluttertoast.showToast(msg: "Payment failed: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Clear loading state for the current plan
    if (subscribeData.planId != null) {
      setPlanLoading(subscribeData.planId.toString(), false);
    }
    print("External wallet selected: ${response.walletName}");
  }

  SubscribeData _subscribeData = SubscribeData();

  SubscribeData get subscribeData => _subscribeData;

  set subscribeData(SubscribeData value) {
    _subscribeData = value;
    notifyListeners();
  }

  bool _isSubscribed = false;

  bool get isSubscribed => _isSubscribed;

  set isSubscribed(bool value) {
    _isSubscribed = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<bool> subscribe(String planId) async {
    try {
      Map<String, dynamic> request = {
        "plan_id": planId,
      };

      SubscribeDataResponse? res =
          await SubscriptionRestApiService().subscribe(request);

      if (res.status! && res.data != null) {
        subscribeData = res.data!;

        print("below is subscribeData.id");
        print(subscribeData.id);
        final options = {
          'key': 'rzp_live_obtwaSdefyy35Y', // Replace with your Razorpay live key
          'subscription_id': subscribeData.id,
          'name': 'Dozen Diamonds',
          'description': selectedSubscribeData.description,
        };
        print(jsonEncode(options));
        _razorpay.open(options);
        return true;
      } else {
        return false;
      }
    } on HttpApiException catch (err) {
      print(err.errorSuggestion);
      print(err.errorTitle);
      print(err.errorCode);
      Fluttertoast.showToast(msg: err.errorTitle);
      return false;
    }
  }

  bool isGettingSubscriptionPlans = false;
  
  Future<bool> getSubscriptionPlans() async {
    isGettingSubscriptionPlans = true;
    notifyListeners();
    try {
      SubscriptionPlanDataResponse? res = await SubscriptionRestApiService()
          .getSubscriptionPlans();

      if (res.status!) {
        (res.data ?? []).sort(
              (a, b) => a.amountPaise!.compareTo(b.amountPaise!),
        );
        subscriptionList = res.data ?? [];
        isGettingSubscriptionPlans = false;
        notifyListeners();
        return true;
      } else {
        isGettingSubscriptionPlans = false;
        notifyListeners();
        return false;
      }
    } on HttpApiException catch (err) {
      print(err.errorSuggestion);
      print(err.errorTitle);
      print(err.errorCode);
      Fluttertoast.showToast(msg: err.errorTitle);
      isGettingSubscriptionPlans = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> createOrder(String planId) async {
    try {
      var uuid = Uuid();

      Map<String, dynamic> request = {
        "planId": planId,
        "idempotencyKey": uuid.v4(),
      };

      GenerateOrderDataResponse? res =
          await SubscriptionRestApiService().createOrder(request);

      if (res.status!) {
        generateOrderData = res.data!;
        return true;
      } else {
        return false;
      }
    } on HttpApiException catch (err) {
      print(err.errorSuggestion);
      print(err.errorTitle);
      print(err.errorCode);
      Fluttertoast.showToast(msg: err.errorTitle);
      return false;
    }
  }

  Future<bool> verifyPayment(String? orderId, String? paymentId, String? signature, BuildContext context, String planId) async {
    print("in verifyPayment");
    print(orderId);
    print(paymentId);
    print(signature);

    try {
      Map<String, dynamic> request = {
        'razorpay_order_id': orderId,
        'razorpay_payment_id': paymentId,
        'razorpay_signature': signature,
      };

      VerifyPaymentResponse? res =
          await SubscriptionRestApiService().verifyPayment(request);

      if (res.status!) {
        Fluttertoast.showToast(msg: res.message ?? "Payment successfully done");
        getSubscribedDetails(context);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => SubscribedScreen(),
          ),
        );
        // Clear loading state for this plan
        setPlanLoading(planId, false);
        return true;
      } else {
        // Clear loading state for this plan
        setPlanLoading(planId, false);
        return false;
      }
    } on HttpApiException catch (err) {
      print(err.errorSuggestion);
      print(err.errorTitle);
      print(err.errorCode);
      Fluttertoast.showToast(msg: err.errorTitle);
      // Clear loading state for this plan
      setPlanLoading(planId, false);
      return false;
    }
  }

  Future<bool> verifySubscription(String? subscriptionId) async {
    print("in verifySubscription");
    print(subscriptionId);

    try {
      Map<String, dynamic> request = {
        'subscription_id': subscriptionId,
      };

      VerifySubscriptionPaymentResponse? res =
          await SubscriptionRestApiService().verifySubscription(request);

      if (res.status == 'success') {
        Fluttertoast.showToast(msg: res.message ?? "Payment successfully done");
        // Clear loading state for this plan
        if (subscribeData.planId != null) {
          setPlanLoading(subscribeData.planId.toString(), false);
        }
        return true;
      } else {
        // Clear loading state for this plan
        if (subscribeData.planId != null) {
          setPlanLoading(subscribeData.planId.toString(), false);
        }
        return false;
      }
    } on HttpApiException catch (err) {
      // Clear loading state for this plan
      if (subscribeData.planId != null) {
        setPlanLoading(subscribeData.planId.toString(), false);
      }
      print(err.errorSuggestion);
      print(err.errorTitle);
      print(err.errorCode);
      Fluttertoast.showToast(msg: err.errorTitle);
      return false;
    }
  }

  Future<bool> getSubscribedDetails(BuildContext context) async {
    print("in getSubscribedDetails");

    try {
      SubscribedDataResponse? res = await SubscriptionRestApiService()
          .getSubscribedDetails();

      if (res.status ?? false) {
        isSubscribed = true;
        subscribedData = res.data ?? SubscribedData();
        UserConfigProvider userConfigProvider = Provider.of<UserConfigProvider>(
          context,
          listen: false,
        );
        userConfigProvider.getUserConfigData();
        return true;
      } else {
        return false;
      }
    } on HttpApiException catch (err) {
      print(err.errorSuggestion);
      print(err.errorTitle);
      print(err.errorCode);
      Fluttertoast.showToast(msg: err.errorTitle);
      return false;
    }
  }
}






// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:uuid/uuid.dart';

// import '../../global/models/http_api_exception.dart';
// import '../../global/stateManagement/user_config_provider.dart';
// import '../models/generate_order_data.dart';
// import '../models/generate_order_data_response.dart';
// import '../models/subscribe_data.dart';
// import '../models/subscribe_data_response.dart';
// import '../models/subscribed_data.dart';
// import '../models/subscribed_data_response.dart';
// import '../models/subscription_plan_data.dart';
// import '../models/subscription_plan_data_response.dart';
// import '../models/verify_payment_response.dart';
// import '../models/verify_subscription_payment_response.dart';
// import '../screens/subscribed_screen.dart';
// import '../service/subscription_rest_api_service.dart';

// class SubscriptionProvider extends ChangeNotifier {
//   // SubscriptionProvider(
//   //     this.navigatorKey);

//   final GlobalKey<NavigatorState> navigatorKey;

//   Map<String, bool> _isPaymentLoading = {};

//   Map<String, bool> get isPaymentLoading => _isPaymentLoading;

//   set isPaymentLoading(Map<String, bool> value) {
//     _isPaymentLoading = value;
//     notifyListeners();
//   }

//   List<SubscriptionPlanData> _subscriptionList = [];

//   List<SubscriptionPlanData> get subscriptionList => _subscriptionList;

//   set subscriptionList(List<SubscriptionPlanData> value) {
//     _subscriptionList = value;
//     notifyListeners();
//   }

//   SubscribedData _subscribedData = SubscribedData();

//   SubscribedData get subscribedData => _subscribedData;

//   set subscribedData(SubscribedData value) {
//     _subscribedData = value;
//     notifyListeners();
//   }

//   SubscriptionPlanData _selectedSubscribeData = SubscriptionPlanData();

//   SubscriptionPlanData get selectedSubscribeData => _selectedSubscribeData;

//   set selectedSubscribeData(SubscriptionPlanData value) {
//     _selectedSubscribeData = value;
//     notifyListeners();

//   }

//   late Razorpay _razorpay;

//   GenerateOrderData _generateOrderData = GenerateOrderData();

//   GenerateOrderData get generateOrderData => _generateOrderData;

//   set generateOrderData(GenerateOrderData value) {
//     _generateOrderData = value;
//     notifyListeners();

//   }

//   bool _isSubscriptionButtonLoading = false;

//   bool get isSubscriptionButtonLoading => _isSubscriptionButtonLoading;

//   set isSubscriptionButtonLoading(bool value) {
//     _isSubscriptionButtonLoading = value;
//     notifyListeners();
//   }

//   SubscriptionProvider(this.navigatorKey) {
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   }

//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     print(response.toString());
//     print(
//         "Payment successful: ${response.orderId} ${response.paymentId} ${response.signature}");
//     // verifyPayment(
//     //     response.orderId, response.paymentId, response.signature);
//     verifySubscription(subscribeData.id);
//     // Handle successful subscription activation here.
//   }

//   void _handlePaymentError(PaymentFailureResponse response) {
//     // Your logic on error
//     isPaymentLoading[subscribeData.planId.toString()] = false;
//   }

//   void _handleExternalWallet(ExternalWalletResponse response) {
//     // Your logic on external wallet
//     isPaymentLoading[subscribeData.planId.toString()] = false;
//   }


//   // List<Map<String, dynamic>> subscriptionList = [
//     // {
//     //   'plan_id': 'plan_PHwnUTiSs9Vctk',
//     //   "subscription_name" : "Basic Plan", //"Rs. 1000 per month",
//     //   "subscription_description": "You will get full app access with paper trading in this plan.",
//     //   "subscription_price": 1000,
//     // },
//   //   {
//   //     'plan_id': 'plan_PHwnUTiSs9Vctk',
//   //     "subscription_name" : "Advance Plan", //"Rs. 1000 per month",
//   //     "subscription_description": "You will get full app access with paper trading in this plan.",
//   //     "subscription_price": 5000,
//   //   },
//   //   // {
//   //   //   "subscription_name" : "Gold Plan", //"Rs. 1000 per month",
//   //   //   "subscription_description": "You will get full app access with paper trading in this plan.",
//   //   //   "subscription_price": 10000,
//   //   // },
//   //   // {
//   //   //   "subscription_name" : "Premium Plan", //"Rs. 1000 per month",
//   //   //   "subscription_description": "You will get full app access with paper trading in this plan.",
//   //   //   "subscription_price": 20000,
//   //   // },
//   // ];

//   SubscribeData _subscribeData = SubscribeData();

//   SubscribeData get subscribeData => _subscribeData;

//   set subscribeData(SubscribeData value) {
//     _subscribeData = value;
//     notifyListeners();
//   }

//   bool _isSubscribed = false;

//   bool get isSubscribed => _isSubscribed;

//   set isSubscribed(bool value) {
//     _isSubscribed = value;
//     notifyListeners();
//   }

//   @override
//   void dispose() {
//     _razorpay.clear();
//     super.dispose();
//   }

//   Future<bool> subscribe(String planId) async {
//     try {

//       Map<String, dynamic> request = {
//         "plan_id": planId,
//       };

//       SubscribeDataResponse? res =
//       await SubscriptionRestApiService().subscribe(request);

//       if(res.status! && res.data != null) {
//         subscribeData = res.data!;

//         // 2. Open Razorpay Checkout for authentication transaction

//         print("below is subscribeData.id");
//         print(subscribeData.id);
//         final options = {
//           // 'key': 'rzp_test_7xgb6XiL2s3DFC',
//           // 'key': 'rzp_test_q7aB5O2oetukBz',
//           'key': 'rzp_live_obtwaSdefyy35Y', // Replace with your Razorpay live key
//           'subscription_id': subscribeData.id,
//           'name': 'Dozen Diamonds',
//           // 'description': selectedSubscribeData.subscriptionPlanDescription,
//           'description': selectedSubscribeData.description,
//           // 'prefill': {
//           //   'contact': 'user_phone',
//           //   'email': 'user_email',
//           // },
//         };
//         print(jsonEncode(options));
//         _razorpay.open(options);
//         return true;
//       } else {
//         return false;
//       }

//     } on HttpApiException catch (err) {
//       print(err.errorSuggestion);
//       print(err.errorTitle);
//       print(err.errorCode);
//       Fluttertoast.showToast(msg: err.errorTitle);
//       return false;
//     }
//   }

//   bool isGettingSubscriptionPlans = false;
//   Future<bool> getSubscriptionPlans() async {
//     isGettingSubscriptionPlans = true;
//     notifyListeners();
//     try {
//       SubscriptionPlanDataResponse? res = await SubscriptionRestApiService()
//           .getSubscriptionPlans();

//       if (res.status!) {
//         (res.data ?? []).sort(
//               (a, b) => a.amountPaise!.compareTo(b.amountPaise!),
//         );
//         subscriptionList = res.data ?? [];
//         isGettingSubscriptionPlans = false;
//         return true;
//       } else {
//         // subscriptionList = [SubscriptionPlanData(
//         //   subscriptionPlanId: 2,
//         //   subscriptionPlanName: "Basic Plan",
//         //   subscriptionPlanAmount: 100,
//         //   subscriptionPlanDescription: "You will get full app access with paper trading in this plan.",
//         //
//         //
//         // )];
//         isGettingSubscriptionPlans = false;
//         notifyListeners();
//         return false;
//       }
//     } on HttpApiException catch (err) {
//       print(err.errorSuggestion);
//       print(err.errorTitle);
//       print(err.errorCode);
//       // subscriptionList = [SubscriptionPlanData(
//       //   subscriptionPlanId: 1,
//       //   subscriptionPlanName: "Basic Plan",
//       //   subscriptionPlanAmount: 100,
//       //   subscriptionPlanDescription: "You will get full app access with paper trading in this plan.",
//       //
//       //
//       // )];
//       Fluttertoast.showToast(msg: err.errorTitle);
//       isGettingSubscriptionPlans = false;
//       notifyListeners();
//       return false;
//     }
//   }

//   Future<bool> createOrder(String planId) async {
//     try {

//       var uuid = Uuid();

//       Map<String, dynamic> request = {
//         "planId": planId,
//         "idempotencyKey": uuid.v4(),
//       };

//       // Map<String, dynamic> request = {
//       //   "plan_id": planId,
//       // };

//       GenerateOrderDataResponse? res =
//       await SubscriptionRestApiService().createOrder(request);

//       if(res.status!) {
//         generateOrderData = res.data!;
//         return true;
//       } else {
//         return false;
//       }

//     } on HttpApiException catch (err) {
//       print(err.errorSuggestion);
//       print(err.errorTitle);
//       print(err.errorCode);
//       Fluttertoast.showToast(msg: err.errorTitle);
//       return false;
//     }
//   }

//   Future<bool> verifyPayment(String? orderId, String? paymentId, String? signature, BuildContext context) async {
//     print("in verifyPayment");
//     print(orderId);
//     print(paymentId);
//     print(signature);

//     try {

//       Map<String, dynamic> request = {
//         'razorpay_order_id': orderId,
//         'razorpay_payment_id': paymentId,
//         'razorpay_signature': signature,
//       };

//       VerifyPaymentResponse? res =
//       await SubscriptionRestApiService().verifyPayment(request);

//       if(res.status!) {

//         Fluttertoast.showToast(msg: res.message ?? "Payment successfully done");
//         getSubscribedDetails(context);
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (context) => SubscribedScreen(),
//           ),
//         );
//         isSubscriptionButtonLoading = false;
//         return true;
//       } else {
//         isSubscriptionButtonLoading = false;
//         return false;
//       }

//     } on HttpApiException catch (err) {
//       print(err.errorSuggestion);
//       print(err.errorTitle);
//       print(err.errorCode);
//       Fluttertoast.showToast(msg: err.errorTitle);
//       isSubscriptionButtonLoading = false;
//       return false;
//     }
//   }

//   Future<bool> verifySubscription(String? subscriptionId) async {
//     print("in verifyPayment");
//     print(subscriptionId);

//     try {

//       Map<String, dynamic> request = {
//         'subscription_id': subscriptionId,
//       };

//       VerifySubscriptionPaymentResponse? res =
//       await SubscriptionRestApiService().verifySubscription(request);

//       if(res.status == 'success') {

//         Fluttertoast.showToast(msg: res.message ?? "Payment successfully done");
//         isPaymentLoading[subscribeData.planId.toString()] = false;
//         return true;
//       } else {
//         isPaymentLoading[subscribeData.planId.toString()] = false;
//         return false;
//       }

//     } on HttpApiException catch (err) {
//       isPaymentLoading[subscribeData.planId.toString()] = false;
//       print(err.errorSuggestion);
//       print(err.errorTitle);
//       print(err.errorCode);
//       Fluttertoast.showToast(msg: err.errorTitle);
//       return false;
//     }
//   }


//   Future<bool> getSubscribedDetails(BuildContext context) async {
//     print("in getSubscribedDetails");

//     try {
//       SubscribedDataResponse? res = await SubscriptionRestApiService()
//           .getSubscribedDetails();

//       if (res.status ?? false) {
//         isSubscribed = true;
//         subscribedData = res.data ?? SubscribedData();
//         UserConfigProvider userConfigProvider = Provider.of<UserConfigProvider>(
//           context,
//           listen: false,
//         );
//         userConfigProvider.getUserConfigData();
//         return true;
//       } else {
//         return false;
//       }
//     } on HttpApiException catch (err) {
//       print(err.errorSuggestion);
//       print(err.errorTitle);
//       print(err.errorCode);
//       Fluttertoast.showToast(msg: err.errorTitle);
//       return false;
//     }
//   }

// }