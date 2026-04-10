import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Splash_Screen/Screen/splashScreen.dart';
import '../../localization/translation_keys.dart';
import '../functions/utils.dart';


class NoInternetScreen extends StatefulWidget {

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  late Stream<ConnectivityResult> _connectivityStream;


  @override
  void initState() {
    super.initState();

    _connectivityStream = Connectivity()
        .onConnectivityChanged
        .map((results) => results.isNotEmpty ? results.first : ConnectivityResult.none);

  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<ConnectivityResult>(
          stream: _connectivityStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              final connectivityResult = snapshot.data;
              // setState(() {
              bool _isConnected = (connectivityResult == ConnectivityResult.mobile ||
                  connectivityResult == ConnectivityResult.ethernet ||
                  connectivityResult == ConnectivityResult.vpn ||
                  connectivityResult == ConnectivityResult.wifi);
              // });



            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off, size: 100, color: Colors.red),
                  SizedBox(height: 20),
                  Text(
                    TranslationKeys.noInternetConnection.tr,
                    // "No Internet Connection",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    TranslationKeys.pleaseCheckYourConnectionAndTryAgain.tr,
                    // "Please check your connection and try again."
                  ),

                  SizedBox(height: 10),
                  Container(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () async {
                        final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
                        // setState(() {


                        if (connectivityResult.contains(ConnectivityResult.mobile) ||
                            connectivityResult.contains(ConnectivityResult.wifi) ||
                            connectivityResult.contains(ConnectivityResult.ethernet) ||
                            connectivityResult.contains(ConnectivityResult.vpn)) {
                          // setState(() {
                          //   isLoading = true;
                          // });
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SplashScreen(),
                            ),
                          );

                        } else if (connectivityResult.contains(ConnectivityResult.wifi)) {

                          // setState(() {
                          //   isLoading = true;
                          // });

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SplashScreen(),
                            ),
                          );


                        } else {

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please connect to internet first",
                              ),
                            ),
                          );

                        }


                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child:

                      (isLoading)?Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,

                          ),
                        ),
                      ):Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Icon(
                            Icons.refresh,
                            color: Colors.white,
                          ),

                          SizedBox(
                            width: 5,
                          ),

                          Text(
                            TranslationKeys.retry.tr,
                            // 'Retry',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }
}
