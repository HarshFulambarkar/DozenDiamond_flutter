import 'package:flutter/material.dart';

class ModifyTrade extends StatefulWidget {
  const ModifyTrade({super.key});

  @override
  State<ModifyTrade> createState() => _ModifyTradeState();
}

class _ModifyTradeState extends State<ModifyTrade> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle(),
        actions: appBarAction(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            children: [
              tradeInformation(),
              SizedBox(
                height: 10,
              ),
              unitAvailable(),
              SizedBox(
                height: 10,
              ),
              takeProfit(),
              SizedBox(
                height: 10,
              ),
              stopLoss(),
              SizedBox(
                height: 10,
              ),
              trailingStop()
            ],
          ),
        ),
      ),
    );
  }

  Widget tradeInformation() {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "100 Units",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 3,
                ),
                Text("Long@ 150->160"),
                SizedBox(
                  height: 3,
                ),
                Text(
                  "TP:- 0   SL:- 0   TS:- 0",
                  style: TextStyle(color: Colors.white60),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  "Ticket# : 5996814d-b292-4124-907e-e84ee2209f96",
                  style: TextStyle(color: Colors.white60),
                ),
                SizedBox(
                  height: 3,
                ),
              ],
            )),
        Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "0.96",
                  style: TextStyle(color: Colors.green),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "-7.9 Pips",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            )),
      ],
    );
  }

  Widget unitAvailable() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Unit(Min. 1)",
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
              Text(
                "2550",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Units Available",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              Text(
                "104,801",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget takeProfit() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Take Profit(Price)",
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "PHP",
                style: TextStyle(color: Colors.white70),
              ),
              Text(
                "0.26 INR",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget stopLoss() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Stop Loss(Price)",
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Take Profit",
                style: TextStyle(color: Colors.white70),
              ),
              Text(
                "0.00 INR/0.0 PIPS",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget trailingStop() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Trailing Stop (Price)",
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Stop Loss",
                style: TextStyle(color: Colors.white70),
              ),
              Text(
                "0.00 INR/0.0 PIPS",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Trade Value",
                style: TextStyle(color: Colors.white70),
              ),
              Text(
                "1,758.74 INR",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Margin required",
                style: TextStyle(color: Colors.white70),
              ),
              Text(
                "52.76 INR",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Margin Available",
                style: TextStyle(color: Colors.white70),
              ),
              Text(
                "2,171.31 INR",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Title appBarTitle() {
    return Title(
        color: Colors.white,
        child: Row(
          children: [
            Text("Trades"),
            SizedBox(
              width: 20,
            ),
            Text('Modify Trades')
          ],
        ));
  }

  List<Widget> appBarAction() {
    return [
      TextButton(
          onPressed: () {},
          child: Text(
            'Submit',
            style: TextStyle(color: Colors.white),
          )),
    ];
  }
}
