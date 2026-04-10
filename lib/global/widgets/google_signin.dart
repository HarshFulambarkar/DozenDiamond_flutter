// // Copyright 2013 The Flutter Authors. All rights reserved.
// // Use of this source code is governed by a BSD-style license that can be
// // found in the LICENSE file.

// // ignore_for_file: avoid_print

// import 'dart:async';
// import 'dart:convert' show json, jsonDecode;

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:google_sign_in_web/web_only.dart' as web;
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../ZG_signupEmail/models/verify_email_request.dart';
// import '../../ZG_signupEmail/services/signup_email_rest_api_service.dart';
// import '../../authentication/services/authentication_rest_api_service.dart';
// import '../../login/models/login_user_response.dart';
// import '../../login/stateManagement/auth_provider.dart';
// import '../../navigateAuthentication/stateManagement/navigate_authentication_provider.dart';
// import '../../profile/stateManagement/profile_provider.dart';
// import '../constants/api_constants.dart';
// import '../constants/constants.dart';
// import '../constants/shared_preferences_manager.dart';
// import '../functions/http_api_helpers.dart';
// import '../functions/utils.dart';
// import '../models/http_api_exception.dart';
// import 'error_dialog.dart';


// /// To run this example, replace this value with your client ID, and/or
// /// update the relevant configuration files, as described in the README.
// String? clientId;

// /// To run this example, replace this value with your server client ID, and/or
// /// update the relevant configuration files, as described in the README.
// String? serverClientId;

// /// The scopes required by this application.
// // #docregion CheckAuthorization
// const List<String> scopes = <String>[
//   'https://www.googleapis.com/auth/contacts.readonly',
// ];
// // #enddocregion CheckAuthorization

// /// The SignInDemo app.
// class GoogleSigninWeb extends StatefulWidget {
//   final BuildContext context;
//   final bool forgotMpin;
//   const GoogleSigninWeb({
//     Key? key,
//     required this.context,
//     required this.forgotMpin,
//   }) : super(key: key);

//   @override
//   State createState() => _GoogleSigninWebState();
// }

// class _GoogleSigninWebState extends State<GoogleSigninWeb> {
//   GoogleSignInAccount? _currentUser;
//   bool _isAuthorized = false; // has granted permissions?
//   String _contactText = '';
//   String _errorMessage = '';
//   String _serverAuthCode = '';

//   late AuthProvider authProvider;

//   Widget _button = Container();

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     authProvider = Provider.of<AuthProvider>(context);
//   }

//   @override
//   void initState() {
//     super.initState();

//     // Utility().log("inside initi status");
//     // #docregion Setup
//     final GoogleSignIn signIn = GoogleSignIn.instance;
//     unawaited(signIn
//         .initialize(clientId: ApiConstant.clientIdWeb, serverClientId: null)
//         .then((_) {
//       signIn.authenticationEvents
//           .listen(_handleAuthenticationEvent)
//           .onError(_handleAuthenticationError);

//       /// This example always uses the stream-based approach to determining
//       /// which UI state to show, rather than using the future returned here,
//       /// if any, to conditionally skip directly to the signed-in state.
//       // signIn.attemptLightweightAuthentication();

//       setState(() {
//         _button = web.renderButton();
//       });

//     }));
//     // #enddocregion Setup

//   }

//   late ProfileProvider profileProvider;
//   late NavigateAuthenticationProvider navigateAuthenticationProvider;

//   final textEditingController = TextEditingController();
//   final textEditingController1 = TextEditingController();

//   Future<void> _handleAuthenticationEvent(
//       GoogleSignInAuthenticationEvent event) async {

//     // Utility().log("inside _handleAuthenticationEvent");
//     // #docregion CheckAuthorization
//     final GoogleSignInAccount? user = // ...
//     // #enddocregion CheckAuthorization
//     switch (event) {
//       GoogleSignInAuthenticationEventSignIn() => event.user,
//       GoogleSignInAuthenticationEventSignOut() => null,
//     };

//     // Check for existing authorization.
//     // #docregion CheckAuthorization
//     final GoogleSignInClientAuthorization? authorization =
//     await user?.authorizationClient.authorizationForScopes(scopes);
//     // #enddocregion CheckAuthorization

//     // setState(() {
//     _currentUser = user;
//     _isAuthorized = authorization != null;
//     _errorMessage = '';

//     // });



//     if(user != null) {
//       login(user!, widget.context).then((res) {
//         profileProvider = Provider.of<ProfileProvider>(widget.context, listen: false);
//         navigateAuthenticationProvider = Provider.of<NavigateAuthenticationProvider>(widget.context, listen: false);
//         ApiStateProvider().resetApiRetry();
//         SharedPreferences.getInstance().then((pref) {
//           if(res!.data!.emailVerified == false || res.data!.phoneVerified == false) {

//             pref.setString("reg_user", res.data?.regUsername ?? "");
//             pref.setString("reg_user_email", res.data?.regEmail ?? "");
//             pref.setString(
//                 "reg_account_status", res.data?.regAccountStatus ?? "");
//             pref.setInt("reg_id", res.data!.regId!);

//             if(res.data!.phoneVerified == false) {

//               profileProvider.getProfileData();
//               profileProvider.sendVerifyPhoneNumberOtp(context);
//             }

//             if(res.data!.emailVerified == false) {

//               verifyEmailShootOtp();

//             }



//             navigateAuthenticationProvider.selectedEmail =
//                 textEditingController.text;

//             navigateAuthenticationProvider.previousIndex =
//                 navigateAuthenticationProvider.selectedIndex;
//             navigateAuthenticationProvider.selectedIndex = 7;

//           } else if (widget.forgotMpin || !res!.data!.regMpinExist!) {
//             print("in if");
//             navigateAuthenticationProvider.previousIndex =
//                 navigateAuthenticationProvider.selectedIndex;
//             navigateAuthenticationProvider.regId = res!.data!.regId!;
//             navigateAuthenticationProvider.selectedIndex = 6;
//             // Navigator.pushReplacement(
//             //   context,
//             //   MaterialPageRoute(
//             //     builder: (context) => MpinGenerationPage(
//             //       regId: res!.data!.regId!,
//             //     ),
//             //   ),
//             // );
//           } else if (res.data?.regAccountStatus == "BLOCKED") {
//             showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return AlertDialog(
//                   title: Text("Account Blocked"),
//                   content: Text(
//                       "Your account is blocked. Please login with another account."),
//                   actions: [
//                     TextButton(
//                       onPressed: () {
//                         Navigator.of(context).pop(); // Close the dialog
//                       },
//                       child: Text("OK"),
//                     ),
//                   ],
//                 );
//               },
//             );
//           } else {
//             print("in else");
//             print(res.data?.regEmail);
//             pref.setString("reg_user", res.data?.regUsername ?? "");
//             pref.setString("reg_user_email", res.data?.regEmail ?? "");
//             pref.setString(
//                 "reg_account_status", res.data?.regAccountStatus ?? "");
//             pref.setInt("reg_id", res.data!.regId!);
//             if(res.data!.emailVerified == false || res.data!.phoneVerified == false) {

//               if(res.data!.emailVerified == false) {

//                 profileProvider.getProfileData();
//                 profileProvider.sendVerifyPhoneNumberOtp(context);
//               }

//               if(res.data!.emailVerified == false) {

//                 verifyEmailShootOtp();

//               }



//               navigateAuthenticationProvider.selectedEmail =
//                   textEditingController.text;

//               navigateAuthenticationProvider.previousIndex =
//                   navigateAuthenticationProvider.selectedIndex;
//               navigateAuthenticationProvider.selectedIndex = 7;

//             } else {

//               navigateAuthenticationProvider.previousIndex =
//                   navigateAuthenticationProvider.selectedIndex;
//               navigateAuthenticationProvider.selectedIndex = 3;

//             }
//             // navigateAuthenticationProvider.previousIndex =
//             //     navigateAuthenticationProvider.selectedIndex;
//             // navigateAuthenticationProvider.selectedIndex = 3;
//           }
//         });
//       }).catchError((err) {
//         authProvider.googleLoginButtonClick = false;
//         textEditingController1.clear();
//         if (err.runtimeType == HttpApiException &&
//             err.errorCode == 400 &&
//             err.errorTitle == "User's email address is not verified.") {
//           Fluttertoast.showToast(
//             msg: 'Email sent to registered email ID containing verification pin!',
//           );
//           // verifyEmailShootOtp();
//         } else {
//           print("hello from the error dialog");
//           // restApiErrorDialog(context,
//           //     error: err, action: _loginUser, apiState: _apiStateProvider!);
//         }
//       });;
//     }


//     // If the user has already granted access to the required scopes, call the
//     // REST API.
//     if (user != null && authorization != null) {
//       unawaited(_handleGetContact(user));
//     }
//   }

//   Future<void> verifyEmailShootOtp() async {
//     final result =
//     await SignupEmailRestApiService().verifyEmail(VerifyEmailRequest(
//       email: textEditingController.text,
//     ));
//     if (mounted) {
//       if (result?.status == true) {
//         navigateAuthenticationProvider.selectedEmail =
//             textEditingController.text;

//         // navigateAuthenticationProvider.previousIndex =
//         //     navigateAuthenticationProvider.selectedIndex;
//         // navigateAuthenticationProvider.selectedIndex = 7;

//         navigateAuthenticationProvider.previousIndex =
//             navigateAuthenticationProvider.selectedIndex;
//         navigateAuthenticationProvider.selectedIndex = 10;

//         // return showDialog(
//         //   barrierDismissible: false,
//         //   context: context,
//         //   builder: (context) {
//         //     return VerifyEmailDialog(
//         //       resendOtp: verifyEmailShootOtp,
//         //     );
//         //   },
//         // );
//       }
//     }
//   }

//   Future<void> _handleAuthenticationError(Object e) async {

//     // Utility().log("inside _handleAuthenticationError");

//     setState(() {
//       _currentUser = null;
//       _isAuthorized = false;
//       _errorMessage = e is GoogleSignInException
//           ? _errorMessageFromSignInException(e)
//           : 'Unknown error: $e';
//     });
//   }

//   Future<LoginUserResponse> login(GoogleSignInAccount googleAccount, BuildContext context) async {
//     if (googleAccount != null) {
//       print("inside googleAccount if condition");
//       final auth = await googleAccount.authentication;
//       final idToken = auth.idToken;

//       String fcmToken = await SharedPreferenceManager.getFCMToken() ?? "";
//       print("below is idToken");
//       print(idToken);
//       print(googleAccount.authentication);
//       // Send token to your Node.js backend for verification

//       AuthenticationRestApiService authentication = AuthenticationRestApiService();
//       String token = await authentication.generateToken();
//       // final response = await http.post(Uri.parse("${ApiConstant.domain}/user/auth/google"),
//       // final response = await http.post(Uri.parse("${ApiConstant.domain}/user/auth/googleSignUp"),

//       // String url = "${ApiConstant.domain}/user/auth/googleSignIn";
//       String url = "${ApiConstant.domain}/user/auth/google";

//       // if(isSignup) {
//       //   url = "${ApiConstant.domain}/user/auth/googleSignUp";
//       // }
//       final response = await http.post(Uri.parse("${url}"),
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization': token,
//           },
//           body: json.encode({
//             'google_token': idToken,
//             'fcm_token': fcmToken,
//           }));

//       print("below is after response");
//       print(response.body);
//       if (httpStatusChecker(response)) {
//         dynamic apiResponse = jsonDecode(response.body);

//         LoginUserResponse data = LoginUserResponse().fromJson(apiResponse);

//         print("before saving issuper");
//         print(data.data!.isSuper);
//         SharedPreferenceManager.saveUserAccessToken(data.data!.token ?? "");
//         SharedPreferenceManager.saveIsSuper(data.data!.isSuper ?? false);

//         return LoginUserResponse().fromJson(apiResponse);
//       } else {
//         throw HttpApiException(errorCode: 404);
//       }


//     }
//   }

//   // Calls the People API REST endpoint for the signed-in user to retrieve information.
//   Future<void> _handleGetContact(GoogleSignInAccount user) async {
//     setState(() {
//       _contactText = 'Loading contact info...';
//     });
//     final Map<String, String>? headers =
//     await user.authorizationClient.authorizationHeaders(scopes);
//     if (headers == null) {
//       setState(() {
//         _contactText = '';
//         _errorMessage = 'Failed to construct authorization headers.';
//       });
//       return;
//     }
//     final http.Response response = await http.get(
//       Uri.parse('https://people.googleapis.com/v1/people/me/connections'
//           '?requestMask.includeField=person.names'),
//       headers: headers,
//     );
//     if (response.statusCode != 200) {
//       if (response.statusCode == 401 || response.statusCode == 403) {
//         setState(() {
//           _isAuthorized = false;
//           _errorMessage = 'People API gave a ${response.statusCode} response. '
//               'Please re-authorize access.';
//         });
//       } else {
//         print('People API ${response.statusCode} response: ${response.body}');
//         setState(() {
//           _contactText = 'People API gave a ${response.statusCode} '
//               'response. Check logs for details.';
//         });
//       }
//       return;
//     }
//     final Map<String, dynamic> data =
//     json.decode(response.body) as Map<String, dynamic>;
//     final String? namedContact = _pickFirstNamedContact(data);
//     setState(() {
//       if (namedContact != null) {
//         _contactText = 'I see you know $namedContact!';
//       } else {
//         _contactText = 'No contacts to display.';
//       }
//     });
//   }

//   String? _pickFirstNamedContact(Map<String, dynamic> data) {
//     final List<dynamic>? connections = data['connections'] as List<dynamic>?;
//     final Map<String, dynamic>? contact = connections?.firstWhere(
//           (dynamic contact) => (contact as Map<Object?, dynamic>)['names'] != null,
//       orElse: () => null,
//     ) as Map<String, dynamic>?;
//     if (contact != null) {
//       final List<dynamic> names = contact['names'] as List<dynamic>;
//       final Map<String, dynamic>? name = names.firstWhere(
//             (dynamic name) =>
//         (name as Map<Object?, dynamic>)['displayName'] != null,
//         orElse: () => null,
//       ) as Map<String, dynamic>?;
//       if (name != null) {
//         return name['displayName'] as String?;
//       }
//     }
//     return null;
//   }

//   // Prompts the user to authorize `scopes`.
//   //
//   // If authorizationRequiresUserInteraction() is true, this must be called from
//   // a user interaction (button click). In this example app, a button is used
//   // regardless, so authorizationRequiresUserInteraction() is not checked.
//   Future<void> _handleAuthorizeScopes(GoogleSignInAccount user) async {
//     try {
//       // #docregion RequestScopes
//       final GoogleSignInClientAuthorization authorization =
//       await user.authorizationClient.authorizeScopes(scopes);
//       // #enddocregion RequestScopes

//       // The returned tokens are ignored since _handleGetContact uses the
//       // authorizationHeaders method to re-read the token cached by
//       // authorizeScopes. The code above is used as a README excerpt, so shows
//       // the simpler pattern of getting the authorization for immediate use.
//       // That results in an unused variable, which this statement suppresses
//       // (without adding an ignore: directive to the README excerpt).
//       // ignore: unnecessary_statements
//       authorization;

//       setState(() {
//         _isAuthorized = true;
//         _errorMessage = '';
//       });
//       unawaited(_handleGetContact(_currentUser!));
//     } on GoogleSignInException catch (e) {
//       _errorMessage = _errorMessageFromSignInException(e);
//     }
//   }

//   // Requests a server auth code for the authorized scopes.
//   //
//   // If authorizationRequiresUserInteraction() is true, this must be called from
//   // a user interaction (button click). In this example app, a button is used
//   // regardless, so authorizationRequiresUserInteraction() is not checked.
//   Future<void> _handleGetAuthCode(GoogleSignInAccount user) async {
//     try {
//       // #docregion RequestServerAuth
//       final GoogleSignInServerAuthorization? serverAuth =
//       await user.authorizationClient.authorizeServer(scopes);
//       // #enddocregion RequestServerAuth

//       setState(() {
//         _serverAuthCode = serverAuth == null ? '' : serverAuth.serverAuthCode;
//       });
//     } on GoogleSignInException catch (e) {
//       _errorMessage = _errorMessageFromSignInException(e);
//     }
//   }

//   Future<void> _handleSignOut() async {
//     // Disconnect instead of just signing out, to reset the example state as
//     // much as possible.
//     await GoogleSignIn.instance.disconnect();
//   }

//   Widget _buildBody() {
//     final GoogleSignInAccount? user = _currentUser;
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: <Widget>[
//         if (user != null)
//           ..._buildAuthenticatedWidgets(user)
//         else
//           ..._buildUnauthenticatedWidgets(),
//         if (_errorMessage.isNotEmpty) Text(_errorMessage),
//       ],
//     );
//   }

//   /// Returns the list of widgets to include if the user is authenticated.
//   List<Widget> _buildAuthenticatedWidgets(GoogleSignInAccount user) {
//     return <Widget>[
//       // The user is Authenticated.
//       ListTile(
//         leading: GoogleUserCircleAvatar(
//           identity: user,
//         ),
//         title: Text(user.displayName ?? ''),
//         subtitle: Text(user.email),
//       ),
//       const Text('Signed in successfully.'),
//       if (_isAuthorized) ...<Widget>[
//         // The user has Authorized all required scopes.
//         if (_contactText.isNotEmpty) Text(_contactText),
//         ElevatedButton(
//           child: const Text('REFRESH'),
//           onPressed: () => _handleGetContact(user),
//         ),
//         if (_serverAuthCode.isEmpty)
//           ElevatedButton(
//             child: const Text('REQUEST SERVER CODE'),
//             onPressed: () => _handleGetAuthCode(user),
//           )
//         else
//           Text('Server auth code:\n$_serverAuthCode'),
//       ] else ...<Widget>[
//         // The user has NOT Authorized all required scopes.
//         const Text('Authorization needed to read your contacts.'),
//         ElevatedButton(
//           onPressed: () => _handleAuthorizeScopes(user),
//           child: const Text('REQUEST PERMISSIONS'),
//         ),
//       ],
//       ElevatedButton(
//         onPressed: _handleSignOut,
//         child: const Text('SIGN OUT'),
//       ),
//     ];
//   }

//   /// Returns the list of widgets to include if the user is not authenticated.
//   List<Widget> _buildUnauthenticatedWidgets() {
//     return <Widget>[
//       // const Text('You are not currently signed in.'),
//       // #docregion ExplicitSignIn
//       if (GoogleSignIn.instance.supportsAuthenticate())
//         ElevatedButton(

//           onPressed: () async {
//             // Utility().log("inside onPressed");
//             // try {
//             //   final GoogleSignInAccount? googleAccount = await GoogleSignIn.instance.authenticate();
//             //
//             //   if (googleAccount != null) {
//             //     Utility().log("inside googleAccount if condition");
//             //     final auth = await googleAccount.authentication;
//             //     final idToken = auth.idToken;
//             //
//             //     String fcmToken = await SessionManager.getFCMToken() ?? "";
//             //     Utility().log("below is idToken");
//             //     Utility().log(idToken.toString());
//             //     Utility().log(googleAccount.authentication.toString());
//             //     // Send token to your Node.js backend for verification
//             //
//             //
//             //
//             //     Map<String, dynamic> data = {
//             //       "google_token": idToken,
//             //       "fcm_token": fcmToken
//             //     };
//             //
//             //     final value = await ApiService.googleLogin(data);
//             //
//             //
//             //     Utility().log("below is after response");
//             //
//             //     AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
//             //
//             //     authProvider.loginCheckAndNavigate(false, value, context);
//             //
//             //   }
//             // } catch (e) {
//             //   // #enddocregion ExplicitSignIn
//             //   _errorMessage = e.toString();
//             //   // #docregion ExplicitSignIn
//             // }
//           },
//           child: const Text('SIGN IN'),
//         )
//       else ...<Widget>[
//         if (kIsWeb)
//           _button
//         // web.renderButton()
//         // #enddocregion ExplicitSignIn
//         else
//           const Text(
//               'This platform does not have a known authentication method')
//         // #docregion ExplicitSignIn
//       ]
//       // #enddocregion ExplicitSignIn
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: <Widget>[
//         ..._buildUnauthenticatedWidgets(),
//       ],
//     );
//     // return Scaffold(
//     //     // appBar: AppBar(
//     //     //   title: const Text('Google Sign In'),
//     //     // ),
//     //     body: ConstrainedBox(
//     //       constraints: const BoxConstraints.expand(),
//     //       child: _buildBody(),
//     //     ));
//   }

//   String _errorMessageFromSignInException(GoogleSignInException e) {
//     // In practice, an application should likely have specific handling for most
//     // or all of the, but for simplicity this just handles cancel, and reports
//     // the rest as generic errors.
//     return switch (e.code) {
//       GoogleSignInExceptionCode.canceled => 'Sign in canceled',
//       _ => 'GoogleSignInException ${e.code}: ${e.description}',
//     };
//   }
// }