import 'package:dozen_diamond/navigateAuthentication/screens/navigate_authentication_screen.dart';
import 'package:dozen_diamond/navigateAuthentication/stateManagement/navigate_authentication_provider.dart';
import 'package:dozen_diamond/socket_manager/stateManagement/web_socket_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AccountBlockedScreen extends StatefulWidget {
  @override
  _AccountBlockedScreenState createState() => _AccountBlockedScreenState();
}

class _AccountBlockedScreenState extends State<AccountBlockedScreen> {
  @override
  late NavigateAuthenticationProvider navigateAuthenticationProvider;
  late WebSocketServiceProvider webSocketServiceProvider;

  Widget build(BuildContext context) {
    print("hello from the account block screen");
    navigateAuthenticationProvider =
        Provider.of<NavigateAuthenticationProvider>(context, listen: true);
    webSocketServiceProvider =
        Provider.of<WebSocketServiceProvider>(context, listen: true);
    print(
        "here is the websocketProvider ${webSocketServiceProvider.blockedMessage.length}");
    return Container(
      color: Colors.black.withOpacity(0.7), // Background with opacity
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.memory(
              base64Decode(webSocketServiceProvider.iconBase64),
              width: 80,
              height: 80,
            ),
            SizedBox(height: 20),
            Text(
              webSocketServiceProvider.blockedMessage[0],
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              "${webSocketServiceProvider.blockedMessage[1]}\n ${webSocketServiceProvider.blockedMessage[2]}",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            webSocketServiceProvider.showAnotherLoginButton
                ? ElevatedButton(
                    onPressed: () {
                      SharedPreferences.getInstance().then((value) async {
                        await value.remove("reg_id");
                        await value.remove("reg_user");
                        Navigator.of(context).pop();
                        navigateAuthenticationProvider.selectedIndex = 1;

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  NavigateAuthenticationScreen()),
                          (Route<dynamic> route) =>
                              false, // this removes all previous routes
                        );

                        // Navigator.of(context).pushRemove(
                        //     '/', (Route<dynamic> route) => false);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      // primary: Colors.red, // Button color
                    ),
                    child: Text('Login with another account',
                        style: TextStyle(color: Colors.white)))
                : Container()
          ],
        ),
      ),
    );
  }
}
