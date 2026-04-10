import 'package:flutter/material.dart';

class ModifyOrdersPage extends StatefulWidget {
  const ModifyOrdersPage({super.key});

  @override
  State<ModifyOrdersPage> createState() => _ModifyOrdersPageState();
}

class _ModifyOrdersPageState extends State<ModifyOrdersPage> {
  Widget description(String title) {
    return Container(
      margin: const EdgeInsets.only(left: 17),
      alignment: Alignment.topLeft,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  Widget content(String label1, String title1, String label2, String title2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            alignment: Alignment.topLeft,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    label1,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    title1,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            alignment: Alignment.topLeft,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    label2,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    title2,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Orders",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 30,
            ),
            Text(
              "Modify Order",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(top: 17, right: 10),
            child: const Text(
              "Submit",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            margin:
                const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "INR 2,972 UNITS",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  "44.40",
                  style: TextStyle(
                      color: Colors.white38,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          description("Buy Entry@ 131.850-->132.294"),
          description(
              "TP:- SL:- TS:-                                                              Pips away"),
          description("Expires: 17-Jan-2023 10:18:52 AM"),
          description("Ticket# 5905"),
          const Divider(
            color: Colors.white,
          ),
          content("Units(Min 1)", "2972", "Units Available", "108,660"),
          const SizedBox(
            height: 5,
          ),
          content("Quote", "131.85", "Expiry", "17-Jan-2023 10:18:27 PM"),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 20),
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            const Text(
                              "Expiry",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                child: const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Text("1 Week"),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 20),
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          "PHP",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          "0.22 INR",
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          content(
              "", "Take Profit (Price)", "Take Profit", "0.00 INR / 0.0PIPS"),
          const SizedBox(
            height: 5,
          ),
          content("", "Stop Loss (Price)", "Stop Loss", "0.00 INR / 0.0PIPS"),
          const SizedBox(
            height: 5,
          ),
          content("", "Trailing Stop (Price)", "Margin Required", "59.44 INR"),
          const SizedBox(
            height: 5,
          ),
          content("", "", "Margin Available", "2,171.87 INR"),
        ],
      ),
    );
  }
}
