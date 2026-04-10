import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:flutter/material.dart';

class AboutPaperCash extends StatelessWidget {
  double screenWidth;
  AboutPaperCash({super.key, this.screenWidth = 0});

  @override
  Widget build(BuildContext context) {
    screenWidth = screenWidthRecognizer(context);
    return Scaffold(
      body: Center(
        child: Container(
          width: screenWidth,
          margin: EdgeInsets.only(left: 20.0, top: 40),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close),
                      iconSize: 35,
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 15, right: 20, top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("About Paper Cash",
                                style: TextStyle(fontSize: 25)),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                                "Paper Cash is not a real cash that you can withdraw to your bank account. Rather it is a demo cash for you to understand the trading process.",
                                style: TextStyle(fontSize: 15)),
                            SizedBox(
                              height: 40,
                            ),
                            Text("Adding Paper Cash/funds",
                                style: TextStyle(fontSize: 25)),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                                "To add paper cash enter the amount in the Text Box, right next to the Add Paper Cash Button",
                                style: TextStyle(fontSize: 15)),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                                "Note: You can only add 10,00,000 Ruppees in one take",
                                style: TextStyle(fontSize: 15))
                          ],
                        )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0, bottom: 10),
                  child: SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("OK"),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(
                                  30), // Adjust the radius as needed
                              right: Radius.circular(
                                  30), // Adjust the radius as needed
                            ),
                          ),
                        ),
                      )),
                )
              ]),
        ),
      ),
    );
  }
}
