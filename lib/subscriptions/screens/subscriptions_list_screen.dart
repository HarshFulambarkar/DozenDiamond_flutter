import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';

import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../create_ladder_easy/widgets/custom_container.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../helper/razorpay_web_helper.dart'
if (dart.library.io) '../helper/razorpay_mobile_helper.dart';
import '../models/subscription_plan_data.dart';
import '../stateManagement/subscription_provider.dart';

class SubscriptionsListScreen extends StatefulWidget {
  const SubscriptionsListScreen({super.key});

  @override
  State<SubscriptionsListScreen> createState() =>
      _SubscriptionsListScreenState();
}

class _SubscriptionsListScreenState extends State<SubscriptionsListScreen> {
  late SubscriptionProvider subscriptionProvider;
  late CurrencyConstants currencyConstantsProvider;
  late ThemeProvider themeProvider;

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      // setupRazorpayHandlers(
      //   onSuccess: (paymentId, orderId, signature) {
      //     print("Payment successful: ${paymentId} ${paymentId} ${signature}");
      //     subscriptionProvider.verifyPayment(orderId, paymentId, signature, context);
      //     // Handle success in your app (e.g., update UI, send to backend)
      //   },
      //   onFailure: () {
      //     print("Payment failed or dismissed by the user");
      //     Fluttertoast.showToast(msg: "Payment Failed");
      //     // Handle failure or cancellation (e.g., show a message)
      //   },
      // );
    } else {
      _razorpay = Razorpay();
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    }
  }

void openCheckout(String subscriptionId, String planId) {
  print("inside openCheckout");
  
  var options = {
    'key': 'rzp_live_RsBeeDVuymVbDR',
    'amount': subscriptionProvider.generateOrderData.amount,
    'currency': subscriptionProvider.generateOrderData.currency,
    'name': 'DozenDiamonds Trading Platform',
    'description': 'Access to trading platform',
    'order_id': subscriptionProvider.generateOrderData.id,
    'prefill': {'name': '', 'email': '', 'contact': ''},
    'theme': {'color': '#F37254'},
  };

  print(options);

  try {
    if (kIsWeb) {
      // Web implementation if needed
        //       subscriptionProvider.isSubscriptionButtonLoading = false;
        // openRazorpayCheckoutWeb(options);

        // js.context.callMethod('openRazorpayCheckout', [jsonEncode(options)]);
    } else {
      // Store current plan ID before opening Razorpay
      _currentPlanId = planId;
      _razorpay.open(options);
    }
  } catch (e) {
    subscriptionProvider.setPlanLoading(planId, false);
    print(e.toString());
  }
}

// Add a variable to track current plan ID
String? _currentPlanId;

void _handlePaymentSuccess(PaymentSuccessResponse response) {
  print("Payment successful: ${response.paymentId}");
  subscriptionProvider.verifyPayment(
    response.orderId,
    response.paymentId,
    response.signature,
    context,
    _currentPlanId ?? '', // Pass the current plan ID
  );
}

void _handlePaymentError(PaymentFailureResponse response) {
  if (_currentPlanId != null) {
    subscriptionProvider.setPlanLoading(_currentPlanId!, false);
  }
  print("Payment failed: ${response.code} | ${response.message}");
}

void _handleExternalWallet(ExternalWalletResponse response) {
  if (_currentPlanId != null) {
    subscriptionProvider.setPlanLoading(_currentPlanId!, false);
  }
  print("External wallet selected: ${response.walletName}");
}

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    subscriptionProvider = Provider.of<SubscriptionProvider>(
      context,
      listen: true,
    );
    currencyConstantsProvider = Provider.of<CurrencyConstants>(
      context,
      listen: true,
    );
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    return PopScope(
      onPopInvokedWithResult: ((value, result) async {
        Navigator.pop(context);
        // return false;
      }),
      canPop: false,
      child: Scaffold(
        backgroundColor: (themeProvider.defaultTheme)
            ? Color(0xfff0f0f0) //Color(0XFFF5F5F5)
            : Color(0xFF15181F),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: Container(
                    width: screenWidth == 0 ? null : screenWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 45),

                        SizedBox(height: 10),

                        // SizedBox(
                        //   height: AppBar().preferredSize.height * 1.5,
                        // ),
                        Container(
                          margin: EdgeInsets.fromLTRB(20, 0, 5, 0),
                          child: Text(
                            "Subscription",
                            style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'Britanica',
                              color: (themeProvider.defaultTheme)
                                  ? Color(0xff141414)
                                  : Color(0xFFffffff),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),

                        SizedBox(height: 10),

                        if (subscriptionProvider.isSubscribed) ...[
                          SizedBox(height: 10),

                          subscribedCard(context),
                          SizedBox(height: 10),
                          Container(
                            margin: EdgeInsets.fromLTRB(20, 0, 5, 0),
                            child: Text(
                              "More Plans",
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'Britanica',
                                color: (themeProvider.defaultTheme)
                                    ? Color(0xff141414)
                                    : Color(0xFFffffff),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                        if (subscriptionProvider.isGettingSubscriptionPlans)
                          Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        if (!subscriptionProvider.isGettingSubscriptionPlans)
                          ...(subscriptionProvider.subscriptionList.isNotEmpty)
                              ? subscriptionProvider.subscriptionList
                              .map(
                                (subscription) =>
                            // subscriptionCard(subscription, context))
                            subscriptionCardNew(
                              subscription,
                              context,
                            ),
                          )
                              .toList()
                              : [Center(child: Text("No Subscription found"))],
                      ],
                    ),
                  ),
                ),
                CustomHomeAppBarWithProviderNew(
                  backButton: true,
                  widthOfWidget: screenWidth,
                  isForPop:
                  true, //these leadingAction button is not working, I have tired making it work, but it isn't.
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget subscribedCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12.0, bottom: 0),
      child: CustomContainer(
        borderRadius: 15,
        // backgroundColor: Color(0xff28282a),
        backgroundColor: (themeProvider.defaultTheme)
            ? Color(0xffdadde6)
            : Color(0xff2c2c31),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${subscriptionProvider.subscribedData.planName ?? "-"}',
                        // "Basic Plan",
                        style: GoogleFonts.poppins(
                          color: (themeProvider.defaultTheme)
                              ? Color(0xff141414)
                              : Color(0xfff0f0f0),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        width: screenWidthRecognizer(context) * 0.7,
                        child: Text(
                          '${subscriptionProvider.subscribedData.description ?? "-"}',

                          // "You will get full app access with paper trading in this plan.",
                          style: TextStyle(
                            color: (themeProvider.defaultTheme)
                                ? Color(0xff141414)
                                : Color(0xffa2b0bc), //Color(0xff545455),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            // Optional: limits the text to 2 lines
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Icon(
                  //   CupertinoIcons.cube_box,
                  //   color: Colors.white,
                  //   size: 20,
                  // )
                ],
              ),

              SizedBox(height: 10),

              Text(
                "Billed monthly on ${subscriptionProvider.subscribedData.nextBillingDate}",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  color: (themeProvider.defaultTheme)
                      ? Color(0xff141414)
                      : Color(0xfff0f0f0),
                ),
              ),

              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: '',
                          children: <InlineSpan>[
                            TextSpan(
                              text:
                              // (subscription.subscriptionPlanAmount == null)
                              //     ?"-"
                              //     :"${currencyConstantsProvider.currency}${(subscription.subscriptionPlanAmount!.toDouble() / 100)} ",
                              (subscriptionProvider.subscribedData.amount ==
                                  null)
                                  ? "-"
                                  : "${currencyConstantsProvider.currency}${(subscriptionProvider.subscribedData.amount!.toDouble() / 100)} ",
                              style: TextStyle(
                                fontSize: 16,
                                color: (themeProvider.defaultTheme)
                                    ? Color(0xff141414)
                                    : Color(0xfff0f0f0),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text:
                              "/${subscriptionProvider.subscribedData.duration ?? ""}",
                              style: TextStyle(
                                fontSize: 16,
                                color: (themeProvider.defaultTheme)
                                    ? Color(0xff141414)
                                    : Color(0xfff0f0f0),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Text(
                        // "Subscribe & Pay",
                        "Subscribed",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: (themeProvider.defaultTheme)
                              ? Color(0xff141414)
                              : Color(0xfff0f0f0),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  Text(
                    "",
                    // "Cancel subscription",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      color: Color(0xff1a94f2),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

// In your subscriptionCardNew method, replace the existing onTap and loading logic:

Widget subscriptionCardNew(
    SubscriptionPlanData subscription,
    BuildContext context,
    ) {
  // Get loading state for this specific plan
  bool isThisPlanLoading = subscriptionProvider.isPlanLoading(subscription.id.toString());
  
  return Padding(
    padding: const EdgeInsets.only(left: 12, right: 12.0, bottom: 0),
    child: CustomContainer(
      borderRadius: 15,
      backgroundColor: (themeProvider.defaultTheme)
          ? Color(0xffdadde6)
          : Color(0xff2c2c31),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${subscription.name ?? "-"}',
                      style: GoogleFonts.poppins(
                        color: (themeProvider.defaultTheme)
                            ? Color(0xff141414)
                            : Color(0xfff0f0f0),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      width: screenWidthRecognizer(context) * 0.7,
                      child: Text(
                        '${subscription.description ?? "-"}',
                        style: TextStyle(
                          color: (themeProvider.defaultTheme)
                              ? Color(0xff141414)
                              : Color(0xffa2b0bc),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: '',
                        children: <InlineSpan>[
                          TextSpan(
                            text: (subscription.amountPaise == null)
                                ? "-"
                                : "${currencyConstantsProvider.currency}${(subscription.amountPaise!.toDouble() / 100).toStringAsFixed(2)} ",
                            style: TextStyle(
                              fontSize: 16,
                              color: (themeProvider.defaultTheme)
                                  ? Color(0xff141414)
                                  : Color(0xfff0f0f0),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: "/month",
                            style: TextStyle(
                              fontSize: 16,
                              color: (themeProvider.defaultTheme)
                                  ? Color(0xff141414)
                                  : Color(0xfff0f0f0),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomContainer(
                      paddingEdge: EdgeInsets.zero,
                      margin: EdgeInsets.zero,
                      padding: 0,
                      borderRadius: 10,
                      backgroundColor: (themeProvider.defaultTheme)
                          ? Color(0xff141414)
                          : Color(0xffffffff),
                      onTap: () async {
                        String planId = subscription.id.toString();
                        
                        // Check if THIS specific plan is already loading
                        if (!subscriptionProvider.isPlanLoading(planId)) {
                          // Set loading for THIS plan only
                          subscriptionProvider.setPlanLoading(planId, true);
                          
                          try {
                            final value = await subscriptionProvider.createOrder(planId);
                            
                            print("below is value");
                            print(value);
                            
                            if (value) {
                              if (subscriptionProvider.generateOrderData.id != null) {
                                openCheckout(
                                  subscriptionProvider.generateOrderData.id!,
                                  planId, // Pass planId to track which plan is being processed
                                );
                              } else {
                                Fluttertoast.showToast(msg: "Something Went Wrong");
                                subscriptionProvider.setPlanLoading(planId, false);
                              }
                            } else {
                              subscriptionProvider.setPlanLoading(planId, false);
                            }
                          } catch (e) {
                            print("Error: $e");
                            subscriptionProvider.setPlanLoading(planId, false);
                            Fluttertoast.showToast(msg: "Something Went Wrong");
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 6,
                          bottom: 6.0,
                        ),
                        child: isThisPlanLoading
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  left: 15,
                                  right: 15.0,
                                ),
                                child: SizedBox(
                                  height: 15,
                                  width: 15,
                                  child: CircularProgressIndicator(
                                    color: (themeProvider.defaultTheme)
                                        ? Color(0xff1a94f2)
                                        : Color(0xff141414),
                                  ),
                                ),
                              )
                            : Text(
                                "Subscribe",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: (themeProvider.defaultTheme)
                                      ? Color(0xff1a94f2)
                                      : Color(0xff141414),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
}