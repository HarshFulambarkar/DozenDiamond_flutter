import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:flutter/material.dart';

class TradingOptionsInfo extends StatelessWidget {
  const TradingOptionsInfo({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = screenWidthRecognizer(context);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  width: screenWidth,
                  margin: const EdgeInsets.only(left: 20.0, top: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                        iconSize: 35,
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(left: 15, right: 20, top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("About Trading Options",
                                style: TextStyle(fontSize: 25)),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                                "Our Trading options are divided into 4 categories for proper understanding of trading mechanism.",
                                style: TextStyle(fontSize: 15)),
                            SizedBox(
                              height: 40,
                            ),
                            Text("Simulated Trading with Simulated Prices",
                                style: TextStyle(fontSize: 20)),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                                "Real Time trading involves real cash in your portfolio for processing ladders orders, these option will let you generate real cash based on the real market",
                                style: TextStyle(fontSize: 14)),
                            SizedBox(
                              height: 25,
                            ),
                            Text("Simulated Trading with Real Prices",
                                style: TextStyle(fontSize: 20)),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                                "Real Time trading involves real cash in your portfolio for processing ladders orders, these option will let you generate real cash based on the real market",
                                style: TextStyle(fontSize: 14)),
                            SizedBox(
                              height: 25,
                            ),
                            Text("Paper Trading",
                                style: TextStyle(fontSize: 20)),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                                "Paper Trading is where you can place your orders with our stock brokers with simulated cash",
                                style: TextStyle(fontSize: 14)),
                            SizedBox(
                              height: 25,
                            ),
                            Text("Trading with Real cash ",
                                style: TextStyle(fontSize: 20)),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                                "Real cash trading involves real cash in your portfolio for processing ladders orders, these option will let you generate real cash based on the real market",
                                style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: screenWidth * 0.8, // Adjust the width as needed
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(30),
                        right: Radius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
