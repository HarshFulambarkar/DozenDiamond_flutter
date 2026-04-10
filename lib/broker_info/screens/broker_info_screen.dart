import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DD_Navigation/stateManagement/navigation_provider.dart';
import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider.dart';
import '../../ZB_accountInfoBar/widgets/custom_home_app_bar_with_provider_new.dart';
import '../../create_ladder_easy/widgets/custom_container.dart';
import '../../global/constants/currency_constants.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/services/num_formatting.dart';
import '../stateManagement/broker_info_provider.dart';

class BrokerInfoScreen extends StatefulWidget {

  @override
  State<BrokerInfoScreen> createState() => _BrokerInfoScreenState();
}

class _BrokerInfoScreenState extends State<BrokerInfoScreen> {
  late NavigationProvider navigationProvider;

  late CurrencyConstants currencyConstantsProvider;

  late BrokerInfoProvider brokerInfoProvider;

  late ThemeProvider themeProvider;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startApiCall();
  }

  void _startApiCall() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      brokerInfoProvider = Provider.of<BrokerInfoProvider>(context, listen: false);

      print("below is closeTimer");
      print(brokerInfoProvider.closeTimer);
      if(brokerInfoProvider.closeTimer) {
        _timer?.cancel();
      } else {

        brokerInfoProvider.getHoldings();
        brokerInfoProvider.getAllHoldings();

      }


    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    navigationProvider = Provider.of<NavigationProvider>(context, listen: true);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    currencyConstantsProvider = Provider.of<CurrencyConstants>(context, listen: true);
    brokerInfoProvider = Provider.of<BrokerInfoProvider>(context, listen: true);

    double screenWidth = screenWidthRecognizer(context);

    return WillPopScope(
      onWillPop: () async {
        navigationProvider.selectedIndex =
            navigationProvider.previousSelectedIndex;

        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Center(
                  child: Container(
                    width: screenWidth == 0 ? null : screenWidth,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 45,
                          ),
                          // SizedBox(
                          //   height: AppBar().preferredSize.height * 1.5,
                          // ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      brokerInfoProvider.getCustomerProfile();
                                      brokerInfoProvider.selectedTab = "Profile";
                                    },
                                    child: CustomContainer(
                                        borderRadius: 8,
                                        height: 50,
                                        borderColor: (themeProvider.defaultTheme)?Colors.black:Colors.white,
                                        backgroundColor: (brokerInfoProvider.selectedTab == "Profile")
                                            ? Color(0xff23a42e)
                                            : Colors.transparent, //(themeProvider.defaultTheme)?Colors.white:Colors.black,
                                        child: Center(
                                          child: Text("Profile",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500)),
                                        )),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      brokerInfoProvider.getHoldings();
                                      brokerInfoProvider.getAllHoldings();
                                      brokerInfoProvider.selectedTab = "Holdings";
                                    },
                                    child: CustomContainer(
                                        borderRadius: 8,
                                        height: 50,
                                        borderColor: (themeProvider.defaultTheme)?Colors.black:Colors.white,
                                        backgroundColor: (brokerInfoProvider.selectedTab == "Holdings")
                                            ? Color(0xff23a42e) //Color.fromARGB(255, 193, 84, 34)
                                            : Colors.transparent, //(themeProvider.defaultTheme)?Colors.white:Colors.black,
                                        child: Center(
                                          child: Text("Holdings",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500)),
                                        )),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      brokerInfoProvider.getCustomerFundsAndMargins();
                                      brokerInfoProvider.selectedTab = "Funds & Margins";
                                    },
                                    child: CustomContainer(
                                        borderColor: (themeProvider.defaultTheme)?Colors.black:Colors.white,
                                        borderRadius: 8,
                                        height: 50,
                                        backgroundColor: (brokerInfoProvider.selectedTab == "Funds & Margins")
                                            ? Color(0xff23a42e) //Color.fromARGB(255, 193, 84, 34)
                                            : Colors.transparent, //(themeProvider.defaultTheme)?Colors.white:Colors.black,
                                        child: Center(
                                          child: Text("Funds & Margins",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500)),
                                        )),
                                  ),
                                )
                              ]),
                          SizedBox(height: 20),
                          (brokerInfoProvider.selectedTab == "Holdings")
                              ? buildHoldingsSection(context)
                              : (brokerInfoProvider.selectedTab == "Funds & Margins")
                              ?buildFundsAndMarginSection(context) //Text("Funds & Margins")
                              :buildBrokerProfileSection(context),
                        ],
                      ),
                    ),
                  ),
                ),
                CustomHomeAppBarWithProviderNew(
                  backButton: true,
                  widthOfWidget: screenWidth,
                  backIndex:
                  1, //these leadingAction button is not working, I have tired making it work, but it isn't.
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBrokerProfileSection(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Client Code",
                ),
              ),

              Expanded(
                child: Text(
                  brokerInfoProvider.brokerProfileData.clientcode ?? "Not Available",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
              )
            ],
          ),

          SizedBox(
            height: 5,
          ),

          Divider(),

          SizedBox(
            height: 5,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Name",
                ),
              ),

              Expanded(
                child: Text(
                  brokerInfoProvider.brokerProfileData.name ?? "Not Available",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
              )
            ],
          ),

          SizedBox(
            height: 5,
          ),

          Divider(),

          SizedBox(
            height: 5,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Email",
                ),
              ),

              Expanded(
                child: Text(
                  brokerInfoProvider.brokerProfileData.email ?? "Not Available",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
              )
            ],
          ),

          SizedBox(
            height: 5,
          ),

          Divider(),

          SizedBox(
            height: 5,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Mobile Number",
                ),
              ),

              Expanded(
                child: Text(
                  brokerInfoProvider.brokerProfileData.mobileno ?? "Not Available",
                  textAlign: TextAlign.right,
                  style: TextStyle(

                    fontWeight: FontWeight.w300,
                  ),
                ),
              )
            ],
          ),

          SizedBox(
            height: 5,
          ),

          Divider(),

          SizedBox(
            height: 5,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Exchanges",
                ),
              ),

              Expanded(
                child: Text(
                  brokerInfoProvider.brokerProfileData.exchanges.toString().replaceAll("]", "").replaceAll("[", ""),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
              )
            ],
          ),

          SizedBox(
            height: 5,
          ),

          Divider(),

          SizedBox(
            height: 5,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Products",
                ),
              ),

              Expanded(
                child: Text(
                  brokerInfoProvider.brokerProfileData.products.toString().replaceAll("]", "").replaceAll("[", ""),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
              )
            ],
          ),

          SizedBox(
            height: 5,
          ),

          Divider(),

          SizedBox(
            height: 5,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Last Login Time",
                ),
              ),

              Expanded(
                child: Text(
                  brokerInfoProvider.brokerProfileData.lastlogintime ?? "Not Available",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
              )
            ],
          ),

          SizedBox(
            height: 5,
          ),

          Divider(),

          SizedBox(
            height: 5,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Broker",
                ),
              ),

              Expanded(
                child: Text(
                  brokerInfoProvider.brokerProfileData.broker ?? "Not Available",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
              )
            ],
          ),

          SizedBox(
            height: 5,
          ),

          Divider(),

          SizedBox(
            height: 5,
          ),

        ],
      ),
    );
  }

  Widget buildFundsAndMarginSection(BuildContext context) {
    return Container(
      child: Column(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Net",
                ),
              ),

              Expanded(
                child: Text(
                  "${currencyConstantsProvider.currency}${brokerInfoProvider.fundsAndMarginsData.net ?? 'Not Available'}",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
              )
            ],
          ),

          SizedBox(
            height: 5,
          ),

          Divider(),

          SizedBox(
            height: 5,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Available Cash",
                ),
              ),

              Expanded(
                child: Text(
                  "${currencyConstantsProvider.currency}${brokerInfoProvider.fundsAndMarginsData.availablecash ?? 'Not Available'}",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
              )
            ],
          ),

          SizedBox(
            height: 5,
          ),

          Divider(),

          SizedBox(
            height: 5,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Available Intra day pay in",
                ),
              ),

              Expanded(
                child: Text(
                  "${currencyConstantsProvider.currency}${brokerInfoProvider.fundsAndMarginsData.availableintradaypayin ?? 'Not Available'}",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
              )
            ],
          ),

          SizedBox(
            height: 5,
          ),

          Divider(),

          SizedBox(
            height: 5,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Available Limit Margin",
                ),
              ),

              Expanded(
                child: Text(
                  brokerInfoProvider.fundsAndMarginsData.availablelimitmargin ?? "Not Available",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
              )
            ],
          ),

          SizedBox(
            height: 5,
          ),

          Divider(),

          SizedBox(
            height: 5,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Collateral",
                ),
              ),

              Expanded(
                child: Text(
                  brokerInfoProvider.fundsAndMarginsData.collateral ?? "Not Available",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
              )
            ],
          ),

          SizedBox(
            height: 5,
          ),

          Divider(),

          SizedBox(
            height: 5,
          ),

        ],
      ),
    );
  }

  Widget buildHoldingsSection(BuildContext context) {
    return Container(
      child: (brokerInfoProvider.holdingData.isEmpty)
          ? Center(
        child: Text(
          "No Holdings to Show",
        ),
      )
          : ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: brokerInfoProvider.holdingData.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {

          return Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: 0, horizontal: 4),
                padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 6,
                    bottom: 6),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    // Stock Icon and Name
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.end,
                              children: [
                                Text(
                                  brokerInfoProvider.holdingData[index].tradingsymbol ?? "-",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                    " ${brokerInfoProvider.holdingData[index].exchange ?? '-'}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color:
                                        Colors.grey[
                                        600])),
                              ],
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              // '${currencyConstantsProvider.currency}${stock['price'].toStringAsFixed(2)}',
                              '${currencyConstantsProvider.currency} ${brokerInfoProvider.holdingData[index].averageprice ?? "-"}',
                              style: TextStyle(
                                fontSize: 14,
                                // color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Stock Change and Remove Button
                    Column(
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      crossAxisAlignment:
                      CrossAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .end,
                              children: [
                                Text(
                                  "${amountToInrFormat(context, double.tryParse(brokerInfoProvider.holdingData[index].profitandloss.toString() ?? ""))}",
                                  style: TextStyle(
                                      color: (brokerInfoProvider.holdingData[index].profitandloss! >= 0)
                                          ? Colors.green
                                          : Colors.red,
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                "${brokerInfoProvider.holdingData[index].pnlpercentage.toString()}%",
                                  // "${webSocketServiceProvider.updatedAtList[stock.wlTickerId]}",
                                  style: TextStyle(
                                      color: (brokerInfoProvider.holdingData[index].pnlpercentage! >= 0)
                                          ? Colors.green
                                          : Colors.red,
                                      // Colors.grey
                                  ),
                                ),
                                // Text(
                                //   (stock.change == null)
                                //       ? ""
                                //       : '${stock.change!.replaceAll("-", "")}%',
                                //   // '${currencyConstantsProvider.currency}${stock['price'].toStringAsFixed(2)}',
                                //   // '${stock['exchange']}',
                                //   style: TextStyle(
                                //     fontSize: 14,
                                //     color: Colors
                                //         .grey[600],
                                //   ),
                                // ),
                              ],
                            ),
                            Icon(
                              (brokerInfoProvider.holdingData[index].profitandloss! >= 0)
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              // stock.isPositive!
                              //     ? Icons.arrow_drop_up
                              //     : Icons
                              //     .arrow_drop_down,
                              color: (brokerInfoProvider.holdingData[index].profitandloss! >= 0)
                                  ? Colors.green
                                  : Colors.red,
                              size: 25,
                            ),
                            SizedBox(height: 4),
                            // Column(
                            //   mainAxisAlignment:
                            //   MainAxisAlignment
                            //       .center,
                            //   mainAxisSize:
                            //   MainAxisSize.max,
                            //   children: [
                            //     GestureDetector(
                            //       onTap: () {
                            //
                            //       },
                            //       child: Icon(
                            //           Icons
                            //               .remove_circle_outline,
                            //           color:
                            //           Colors.grey,
                            //           size: 20),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8, right: 8.0),
                child: Divider(
                  height: 1,
                  color: Colors.grey,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
