import 'package:dozen_diamond/DD_Navigation/stateManagement/navigation_provider.dart';
import 'package:dozen_diamond/Settings/stateManagement/theme_provider.dart';
import 'package:dozen_diamond/ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
import 'package:dozen_diamond/global/stateManagement/app_config_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../global/constants/currency_constants.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/services/num_formatting.dart';
import '../../global/stateManagement/app_config_provider.dart';
import '../stateManagement/custom_home_app_bar_provider.dart';

class CustomHomeAppBarWithProviderNew extends StatefulWidget
    // implements PreferredSizeWidget
{
  final Function? leadingAction;
  final bool backButton;
  final double widthOfWidget;
  final bool isForPop;
  final int backIndex;
  const CustomHomeAppBarWithProviderNew({
    super.key,
    this.leadingAction,
    this.backButton = true,
    this.backIndex = -1,
    this.widthOfWidget = 0,
    this.isForPop = false,
  });

  @override
  State<CustomHomeAppBarWithProviderNew> createState() => _CustomHomeAppBarWithProviderNewState();

  // @override
  // Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomHomeAppBarWithProviderNewState extends State<CustomHomeAppBarWithProviderNew> {

  late CustomHomeAppBarProvider customHomeAppBarProvider;
  late NavigationProvider navigationProvider;
  late CurrencyConstants currencyConstants;
  late ThemeProvider themeProvider;
  late AppConfigProvider appConfigProvider;
  late TradeMainProvider tradeMainProvider;

  bool isNAVExpanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      customHomeAppBarProvider =
          Provider.of<CustomHomeAppBarProvider>(context, listen: false);
      customHomeAppBarProvider.callInitialApi();
    });
    navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);
  }


  @override
  Widget build(BuildContext context) {


    double screenWidth = screenWidthRecognizer(context);
    currencyConstants = Provider.of<CurrencyConstants>(context, listen: true);
    appConfigProvider = Provider.of<AppConfigProvider>(context, listen: true);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    tradeMainProvider = Provider.of<TradeMainProvider>(context, listen: true);
    customHomeAppBarProvider =
        Provider.of<CustomHomeAppBarProvider>(context, listen: true);
    double positionValues =
        customHomeAppBarProvider.getUserAccountDetails?.data?.positionValues ??
            0.0;
    double unsoldStockCost = (customHomeAppBarProvider
        .getUserAccountDetails?.data?.accountUnsoldStocksCost ??
        0.0);
    double cashNeededForActiveLadder = (customHomeAppBarProvider
        .getUserAccountDetails?.data?.accountCashNeededForActiveLadders ??
        0.0);
    double cashNeededForInactiveLadder = (customHomeAppBarProvider
        .getUserAccountDetails?.data?.accountCashNeededForInactiveLadders ??
        0.0);

    double cashForNewLadder = (customHomeAppBarProvider
        .getUserAccountDetails?.data?.accountCashForNewLadders ??
        0.0);
    double netAssetValue =
        positionValues + cashForNewLadder + cashNeededForActiveLadder;

    if(tradeMainProvider.tradingOptions == TradingOptions.tradingWithRealCash) {
      // netAssetValue = positionValues + (customHomeAppBarProvider.getUserAccountDetails?.data?.accountTransactionCashLeft ?? 0.0);
      netAssetValue = customHomeAppBarProvider.getUserAccountDetails?.data?.totalAccountValue ?? 0;
    }
// Print each value along with a description
//     print('NAV is here Position Values: $positionValues');
//     print('NAV is here Cash for New Ladder: $cashForNewLadder');
//     print(
//         'NAV is here Cash Needed for Active Ladder: $cashNeededForActiveLadder');
//     print('NAV is here Net Asset Value: $netAssetValue');
    //  + cashNeededForInactiveLadder;
    double accountUnrealizedProfit = positionValues - unsoldStockCost;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: screenWidth,
          child: ListView(
            shrinkWrap: true,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [


              Container(
                height: 45,
                width: screenWidth,
                child: AppBar(
                  backgroundColor: (tradeMainProvider.tradingOptions == TradingOptions.simulationTradingWithSimulatedPrices)
                      ?Color(0xFF0066C0) // Colors.green
                      :(tradeMainProvider.tradingOptions == TradingOptions.simulationTradingWithRealValues)
                      ?Colors.yellow[800]
                      :(tradeMainProvider.tradingOptions == TradingOptions.tradingWithRealCash)
                      ?Colors.red
                      :Color(0xFF0066C0),
                  // backgroundColor: Color(0xFF0066C0), // Color(0xff2C2C31),
                  leading: (widget.backButton)?IconButton(
                    onPressed: widget.isForPop
                        ? () {
                      Navigator.pop(context);
                    }
                        : () {
                      widget.backIndex == -1
                          ? navigationProvider.selectedIndex--
                          : navigationProvider.selectedIndex =
                          widget.backIndex;
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: (themeProvider.defaultTheme)
                          ? Colors.white
                          : Colors.white,
                    ),
                  ):InkWell(
                    onTap: () {
                      widget.leadingAction!();
                      // _key.currentState!.openDrawer();
                    },
                    child: Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                  ),
                  centerTitle: true,
                  title: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      setState(() {
                        isNAVExpanded = !isNAVExpanded;
                      });

                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "NAV ${amountToInrFormat(context, netAssetValue)}",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.white
                          ),
                        ),

                        Icon(
                            (isNAVExpanded)?Icons.keyboard_arrow_up:Icons.keyboard_arrow_down,
                            color: Colors.white, //Colors.white.withOpacity(0.6)
                        ),

                        // SizedBox(
                        //   width: 20,
                        // )
                      ],
                    ),
                  ),
                  actions: [
                    // Icon(
                    //   Icons.lightbulb_outline,
                    //   color: Colors.white,
                    // ),

                    Icon(
                      Icons.circle,
                      size: 10,
                      color: (tradeMainProvider.tradingOptions == TradingOptions.simulationTradingWithSimulatedPrices)
                          ?Colors.green
                          :(tradeMainProvider.tradingOptions == TradingOptions.simulationTradingWithRealValues)
                          ?Colors.yellow
                          :(tradeMainProvider.tradingOptions == TradingOptions.tradingWithRealCash)
                          ?Colors.red
                          :Colors.red,
                    ),

                    SizedBox(
                      width: 5,
                    ),

                    Text(
                      (tradeMainProvider.tradingOptions == TradingOptions.simulationTradingWithSimulatedPrices)
                          ?"Simulation"
                          :(tradeMainProvider.tradingOptions == TradingOptions.simulationTradingWithRealValues)
                          ?"Real Time"
                          :(tradeMainProvider.tradingOptions == TradingOptions.tradingWithRealCash)
                          ?"Real"
                          :"",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.white
                      ),
                    ),



                    SizedBox(
                      width: 10,
                    ),
                  ],



                ),
              ),

              Container(
                  width: screenWidth,
                  child: buildExpandedSection()
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildExpandedSection() {

    double screenWidth = screenWidthRecognizer(context);
    currencyConstants = Provider.of<CurrencyConstants>(context, listen: true);
    appConfigProvider = Provider.of<AppConfigProvider>(context, listen: true);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    customHomeAppBarProvider =
        Provider.of<CustomHomeAppBarProvider>(context, listen: true);
    double positionValues =
        customHomeAppBarProvider.getUserAccountDetails?.data?.positionValues ??
            0.0;
    double unsoldStockCost = (customHomeAppBarProvider
        .getUserAccountDetails?.data?.accountUnsoldStocksCost ??
        0.0);
    double cashNeededForActiveLadder = (customHomeAppBarProvider
        .getUserAccountDetails?.data?.accountCashNeededForActiveLadders ??
        0.0);
    double cashNeededForInactiveLadder = (customHomeAppBarProvider
        .getUserAccountDetails?.data?.accountCashNeededForInactiveLadders ??
        0.0);

    double cashForNewLadder = (customHomeAppBarProvider
        .getUserAccountDetails?.data?.accountCashForNewLadders ??
        0.0);
    double netAssetValue =
        positionValues + cashForNewLadder + cashNeededForActiveLadder;

    if(tradeMainProvider.tradingOptions == TradingOptions.tradingWithRealCash) {
      // netAssetValue = positionValues + (customHomeAppBarProvider.getUserAccountDetails?.data?.accountTransactionCashLeft ?? 0.0);
      netAssetValue = customHomeAppBarProvider.getUserAccountDetails?.data?.totalAccountValue ?? 0;
    }
// Print each value along with a description
//     print('NAV is here Position Values: $positionValues');
//     print('NAV is here Cash for New Ladder: $cashForNewLadder');
//     print(
//         'NAV is here Cash Needed for Active Ladder: $cashNeededForActiveLadder');
//     print('NAV is here Net Asset Value: $netAssetValue');
    //  + cashNeededForInactiveLadder;
    double accountUnrealizedProfit = positionValues - unsoldStockCost;

    return (isNAVExpanded)?Container(
      color: Color(0xFF0066C0), // Color(0xff2C2C31),
      child: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32.0, bottom: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            // _currencyFieldsWidget("Withdrawable Cash", customHomeAppBarProvider.getUserAccountDetails?.data?.withdrawableCash),

            _currencyFieldsWidget("Position Value", positionValues),

            _currencyFieldsWidget("Unsold stocks cost", customHomeAppBarProvider.getUserAccountDetails?.data?.accountUnsoldStocksCost),

            _currencyFieldsWidget("Unrealized Profit", accountUnrealizedProfit,),

            _currencyFieldsWidget("Realized Profit", customHomeAppBarProvider.getUserAccountDetails?.data?.accountRealizedProfit),

            _currencyFieldsWidget("NAV", netAssetValue),

            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Column(
                children: [
                  if (Provider.of<CustomHomeAppBarProvider>(context).accountInfoBarFieldVisibility.showUnallocatedCashLeftForTrading)
                    _currencyFieldsWidget("(a)Unallocated cash", customHomeAppBarProvider.getUserAccountDetails?.data?.accountUnallocatedCash),

                  if (Provider.of<CustomHomeAppBarProvider>(context).accountInfoBarFieldVisibility.showCashNeededForActiveLadders)
                    _currencyFieldsWidget("(b)Cash needed for ladders", customHomeAppBarProvider.getUserAccountDetails?.data?.accountCashNeededForActiveLadders),

                  if (Provider.of<CustomHomeAppBarProvider>(context).accountInfoBarFieldVisibility.showExtraCash)
                    _extraCashWidget("Extra cash (c)left/(d)generated", customHomeAppBarProvider.getUserAccountDetails?.data?.accountExtraCashLeft, customHomeAppBarProvider.getUserAccountDetails?.data?.accountExtraCashGenerated),
                ],
              ),
            ),



            if (Provider.of<CustomHomeAppBarProvider>(context).accountInfoBarFieldVisibility.showCashForNewLadders)
              _currencyFieldsWidget("Cash for new ladders(a+c)", customHomeAppBarProvider.getUserAccountDetails?.data?.accountCashForNewLadders),

            if (Provider.of<CustomHomeAppBarProvider>(context).accountInfoBarFieldVisibility.showFundsInPlay)
              _currencyFieldsWidget("Funds in play", customHomeAppBarProvider.getUserAccountDetails?.data?.accountFundsInPlay),

            SizedBox(
              height: 5,
            ),

            Divider(
              color: (themeProvider.defaultTheme) ? Colors.white : Colors.white,
              thickness: 1,
              height: 13,
              endIndent: 5,
              indent: 5,
            ),

            SizedBox(
              height: 5,
            ),

            // Divider(
            //   color: Color(0xff2c2c31),
            //   thickness: 1,
            // ),

            _unitsFieldWidget("Number of tickers", customHomeAppBarProvider.getUserAccountDetails?.data?.accountSelectedTickersCount),

            _unitsFieldWidget("Active ladders", customHomeAppBarProvider.getUserAccountDetails?.data?.accountActiveLaddersCount),

            _unitsFieldWidget("Inactive ladders", customHomeAppBarProvider.getUserAccountDetails?.data?.accountInactiveLaddersCount),

            _unitsFieldWidget("Cash Empty ladders", customHomeAppBarProvider.getUserAccountDetails?.data?.accountCashEmptyCount),

            _unitsFieldWidget("Trades", customHomeAppBarProvider.getUserAccountDetails?.data?.accountUnsettledTradesCount),

            _unitsFieldWidget("Orders", customHomeAppBarProvider.getUserAccountDetails?.data?.accountOpenOrdersCount),

          ],
        ),
      ),
    ):Container(height: 1,);
  }

  Widget _currencyFieldsWidget(String title, double? value) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              color: (themeProvider.defaultTheme) ? Colors.white : Colors.white,
            ),
          ),
          Text(
            amountToInrFormat(context, value) ?? "N/A",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              color: (themeProvider.defaultTheme) ? Colors.white : Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget _extraCashWidget(
      String title, double? extraCashGenerated, double? extraCashLeft) {
    String extraCash =
        "${amountToInrFormat(context, extraCashGenerated)}/${amountToInrFormat(context, extraCashLeft)}";
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: screenWidthRecognizer(context) * 0.47,
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                color: (themeProvider.defaultTheme) ? Colors.white : Colors.white,
              ),
            ),
          ),

          Container(
            width: screenWidthRecognizer(context) * 0.32,
            child: Text(
              extraCash,
              textAlign: TextAlign.end,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                color: (themeProvider.defaultTheme) ? Colors.white : Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _unitsFieldWidget(String title, int? value) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              color: (themeProvider.defaultTheme) ? Colors.white : Colors.white,
            ),
          ),
          Text(
            value != null ? intToUnits(value) : "N/A",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              color: (themeProvider.defaultTheme) ? Colors.white : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
