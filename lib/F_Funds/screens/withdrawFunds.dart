import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:flutter/material.dart';

import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../global/constants/custom_colors_light.dart';

class WithdrawFunds extends StatelessWidget {
  const WithdrawFunds({super.key});

  Widget balanceCard(String title, String val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        Flexible(
          child: Text(
            val,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // drawer: const NavigationDrawerWidget(),
      // appBar: AppBar(
      //   leading: IconButton(
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //     },
      //     icon: const Icon(
      //       Icons.arrow_back_ios_new_outlined,
      //       color: Colors.white,
      //     ),
      //   ),
      //   elevation: 0,
      //   backgroundColor: const Color(0xFF15181F),
      //   title: Row(
      //     children: [
      //       ClipRRect(
      //         borderRadius: BorderRadius.circular(9.9),
      //         child: Image.asset(
      //           "lib/global/assets/logos/appBarLogo.png",
      //           fit: BoxFit.contain,
      //           height: MediaQuery.of(context).size.height * 0.055,
      //           width: MediaQuery.of(context).size.width * 0.65,
      //         ),
      //       ),
      //       IconButton(
      //         onPressed: () {},
      //         // chrome_reader_mode_outlined
      //         icon: SizedBox(
      //           width: 30,
      //           height: 60,
      //           child: Image.asset(
      //             "lib/global/assets/icons/docs.png",
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              // padding: const EdgeInsets.only(top: 60.0),
              padding: const EdgeInsets.only(top: 45.0),
              child: ListView(children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                  child: const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Withdraw Funds",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(children: [
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Card(
                        elevation: 1,
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                balanceCard("Closing Balance :", "10,250.00"),
                                balanceCard(
                                    "Unsettled Transaction Sum :", "250.00"),
                                balanceCard("Credits :", "250"),
                              ]),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Withdrawable Balance :",
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          ),
                          Text(
                            "10,250.00 Rs",
                            style: TextStyle(fontSize: 30),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: Colors.white60),
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                            decoration: BoxDecoration(
                              color: Colors.transparent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const TextField(
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 0.7,
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.white,
                                  ),
                                ),
                                hintText: 'Enter Amount To Withdraw',
                                hintStyle: TextStyle(color: Colors.white),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 10),
                                border: InputBorder.none,
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: CurrencyIcon(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              style: kBodyText,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 120, vertical: 5),
                                  child: OutlinedButton(
                                    onPressed: () {},
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      side: const BorderSide(
                                        color: Color(0xFF0099CC),
                                      ),
                                    ),
                                    child: const Text(
                                      'Continue',
                                      style: TextStyle(
                                        color: Color(0xFF0099CC),
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: Colors.white60),
                    const Text(
                      " Past Withdrawls",
                      style: TextStyle(fontSize: 20),
                    ),
                    Transaction("2022-12-01", "1000 Dr", "1500",
                        "asd32asghsd3as3o", 'debit'),
                    Transaction("2022-11-10", "500 Dr", "1500",
                        "as234as21s3as3o", 'debit'),
                    Transaction("2022-11-10", "1000 dr", "2000",
                        "as4a2s3sqwes3o", 'debit'),
                  ]),
                ),
              ]),
            ),
            CustomHomeAppBarWithProviderNew(backButton: true),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Transaction extends StatelessWidget {
  Transaction(this.date, this.amount, this.balance, this.id, this.type,
      {super.key});
  String date, amount, balance, id, type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date, style: const TextStyle(fontSize: 20)),
              Text(amount,
                  style: TextStyle(
                      fontSize: 20,
                      color: type == 'credit'
                          ? Colors.greenAccent
                          : Colors.redAccent)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                " UPI Id : $id",
                style: const TextStyle(color: Colors.grey, fontSize: 15),
              ),
              Text("Balance : $balance Rs",
                  style: const TextStyle(color: Colors.grey, fontSize: 15)),
            ],
          ),
          const Divider(
            color: Color.fromARGB(255, 212, 212, 212),
          )
        ],
      ),
    );
  }
}
