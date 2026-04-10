import 'package:dozen_diamond/DD_Navigation/stateManagement/navigation_provider.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Settings/stateManagement/theme_provider.dart';
import '../../global/services/num_formatting.dart';
import '../../global/stateManagement/app_config_provider.dart';
import '../stateManagement/custom_home_app_bar_provider.dart';

class CustomHomeAppBarWithProvider extends StatefulWidget {
  final Function? leadingAction;
  final bool backButton;
  final double widthOfWidget;
  final bool isForPop;
  final int backIndex;
  const CustomHomeAppBarWithProvider({
    super.key,
    this.leadingAction,
    this.backButton = true,
    this.backIndex = -1,
    this.widthOfWidget = 0,
    this.isForPop = false,
  });

  @override
  State<CustomHomeAppBarWithProvider> createState() =>
      _CustomHomeAppBarWithProviderState();
}

class _CustomHomeAppBarWithProviderState
    extends State<CustomHomeAppBarWithProvider> {
  late CustomHomeAppBarProvider customHomeAppBarProvider;
  late NavigationProvider navigationProvider;
  late CurrencyConstants currencyConstants;
  late ThemeProvider themeProvider;
  late AppConfigProvider appConfigProvider;

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

  Widget _extraCashWidget(
      String title, double? extraCashGenerated, double? extraCashLeft) {
    String extraCash =
        "${amountToInrFormat(context, extraCashGenerated)}/\n${amountToInrFormat(context, extraCashLeft)}";
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: (themeProvider.defaultTheme) ? Colors.white : Colors.white,
            ),
          ),
          Text(
            extraCash,
            style: TextStyle(
              color: (themeProvider.defaultTheme) ? Colors.white : Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget _currencyFieldsWidget(String title, double? value) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: (themeProvider.defaultTheme) ? Colors.white : Colors.white,
            ),
          ),
          Text(
            amountToInrFormat(context, value) ?? "N/A",
            style: TextStyle(
              color: (themeProvider.defaultTheme) ? Colors.white : Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget _unitsFieldWidget(String title, int? value) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: (themeProvider.defaultTheme) ? Colors.white : Colors.white,
            ),
          ),
          Text(
            value != null ? intToUnits(value) : "N/A",
            style: TextStyle(
              color: (themeProvider.defaultTheme) ? Colors.white : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _mainAppBarContent(double netAssetValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        widget.backButton
            ? IconButton(
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
              )
            : IconButton(
                onPressed: () {
                  widget.leadingAction!();
                },
                icon: Icon(
                  Icons.menu,
                  color: (themeProvider.defaultTheme)
                      ? Colors.white
                      : Colors.white,
                ),
              ),
        GestureDetector(
          onTap: () {
            customHomeAppBarProvider.onTapOfAppBar();
          },
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    // portfolioCashDetails.cashLeft != null &&
                    //         accountDetails!.data!.usrAccuntPositionValue != null
                    //     ? "NAV ${amountToInrFormat(context,(portfolioCashDetails.cashLeft! + double.parse(accountDetails!.data!.usrAccuntPositionValue!)))}"
                    // "NAV N/A",
                    "NAV ${amountToInrFormat(context, netAssetValue)}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: (themeProvider.defaultTheme)
                          ? Colors.white
                          : Colors.white,
                    ),
                  ),
                  Text(
                    currencyConstants.currency == '₹'
                        ? "Primary (INR)"
                        : "Primary (USD)",
                    style: TextStyle(
                      color: (themeProvider.defaultTheme)
                          ? Colors.white
                          : Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            customHomeAppBarProvider.onTapOfAppBar();
          },
          child: Row(
            children: [
              customHomeAppBarProvider.isExpanded!
                  ? Icon(
                      Icons.keyboard_double_arrow_up,
                      color: (themeProvider.defaultTheme)
                          ? Colors.white
                          : Colors.white,
                    )
                  : Icon(
                      Icons.keyboard_double_arrow_down_outlined,
                      color: (themeProvider.defaultTheme)
                          ? Colors.white
                          : Colors.white,
                    ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: (appConfigProvider.appConfigData.data?.logo?.ddUrl !=
                            null)
                        ? Image.network(
                            "${appConfigProvider.appConfigData.data?.logo?.ddUrl ?? ""}",
                            // "https://gratisography.com/wp-content/uploads/2024/10/gratisography-cool-cat-800x525.jpg",
                            headers: {
                              "Accept": "image/*",
                              'Access-Control-Allow-Origin': '*'
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                "lib/global/assets/logos/dozendiamond_logo.jpeg",
                                fit: BoxFit.contain,
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                                width:
                                    MediaQuery.of(context).size.width * 0.125,
                              );
                            },
                            fit: BoxFit.contain,
                            height: MediaQuery.of(context).size.height * 0.04,
                            width: MediaQuery.of(context).size.width * 0.125,
                          )
                        : Image.asset(
                            "lib/global/assets/logos/dozendiamond_logo.jpeg",
                            fit: BoxFit.contain,
                            height: MediaQuery.of(context).size.height * 0.04,
                            width: MediaQuery.of(context).size.width * 0.125,
                          ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "v${appConfigProvider.appConfigData.data?.versionFrontend ?? customHomeAppBarProvider.frontendVersion}.${appConfigProvider.appConfigData.data?.versionBackend ?? customHomeAppBarProvider.backendVersion}.${appConfigProvider.appConfigData.data?.versionServer ?? customHomeAppBarProvider.databaseVersion}",
                    style: TextStyle(
                      color: (themeProvider.defaultTheme)
                          ? Colors.white
                          : Colors.white,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
        AnimatedContainer(
          width: screenWidth,
          height: customHomeAppBarProvider.isExpanded!
              ? customHomeAppBarProvider.accountInfoBarHeight
              : AppBar().preferredSize.height * 1.1,
          decoration: BoxDecoration(
            color: customHomeAppBarProvider.isExpanded!
                ? const Color(0xFF0066C0)
                : const Color(0xFF0066C0),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          duration: const Duration(milliseconds: 200),
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: AppBar().preferredSize.height,
                child: _mainAppBarContent(netAssetValue),
              ),
              const SizedBox(
                height: 10,
              ),
              _currencyFieldsWidget("Position Value", positionValues),
              _currencyFieldsWidget(
                  "Unsold stocks cost",
                  customHomeAppBarProvider
                      .getUserAccountDetails?.data?.accountUnsoldStocksCost),
              _currencyFieldsWidget(
                "Unrealized Profit",
                accountUnrealizedProfit,
                // customHomeAppBarProvider
                //     .getUserAccountDetails?.data?.accountUnsoldStocksCashGain,
              ),
              _currencyFieldsWidget(
                  "Realized Profit",
                  customHomeAppBarProvider
                      .getUserAccountDetails?.data?.accountRealizedProfit),
              _currencyFieldsWidget("NAV", netAssetValue
                  //  customHomeAppBarProvider
                  // .getUserAccountDetails?.data?.accountCashLeft

                  ),
              if (Provider.of<CustomHomeAppBarProvider>(context)
                  .accountInfoBarFieldVisibility
                  .showUnallocatedCashLeftForTrading)
                _currencyFieldsWidget(
                    // "(a)Unallocated cash left for trading",
                    "(a)Unallocated cash",
                    customHomeAppBarProvider
                        .getUserAccountDetails?.data?.accountUnallocatedCash),
              if (Provider.of<CustomHomeAppBarProvider>(context)
                  .accountInfoBarFieldVisibility
                  .showCashNeededForActiveLadders)
                _currencyFieldsWidget(
                    "(b)Cash needed for ladders",
                    customHomeAppBarProvider.getUserAccountDetails?.data
                        ?.accountCashNeededForActiveLadders),
              if (Provider.of<CustomHomeAppBarProvider>(context)
                  .accountInfoBarFieldVisibility
                  .showExtraCash)
                _extraCashWidget(
                    "Extra cash (c)left/(d)generated",
                    customHomeAppBarProvider
                        .getUserAccountDetails?.data?.accountExtraCashLeft,
                    customHomeAppBarProvider.getUserAccountDetails?.data
                        ?.accountExtraCashGenerated),
              if (Provider.of<CustomHomeAppBarProvider>(context)
                  .accountInfoBarFieldVisibility
                  .showCashForNewLadders)
                _currencyFieldsWidget(
                    "Cash for new ladders(a+c)",
                    customHomeAppBarProvider
                        .getUserAccountDetails?.data?.accountCashForNewLadders),
              if (Provider.of<CustomHomeAppBarProvider>(context)
                  .accountInfoBarFieldVisibility
                  .showFundsInPlay)
                _currencyFieldsWidget(
                    "Funds in play",
                    customHomeAppBarProvider
                        .getUserAccountDetails?.data?.accountFundsInPlay),
              Divider(
                color:
                    (themeProvider.defaultTheme) ? Colors.white : Colors.white,
                thickness: 2,
                height: 13,
                endIndent: 5,
                indent: 5,
              ),
              _unitsFieldWidget(
                  "Number of tickers",
                  customHomeAppBarProvider.getUserAccountDetails?.data
                      ?.accountSelectedTickersCount),
              _unitsFieldWidget(
                  "Active ladders",
                  customHomeAppBarProvider
                      .getUserAccountDetails?.data?.accountActiveLaddersCount),
              _unitsFieldWidget(
                  "Inactive ladders",
                  customHomeAppBarProvider.getUserAccountDetails?.data
                      ?.accountInactiveLaddersCount),
              _unitsFieldWidget(
                  "Cash Empty ladders",
                  customHomeAppBarProvider
                      .getUserAccountDetails?.data?.accountCashEmptyCount),
              _unitsFieldWidget(
                  "Trades",
                  customHomeAppBarProvider.getUserAccountDetails?.data
                      ?.accountUnsettledTradesCount),
              _unitsFieldWidget(
                  "Orders",
                  customHomeAppBarProvider
                      .getUserAccountDetails?.data?.accountOpenOrdersCount),
            ],
          ),
        ),
      ],
    );
  }
}
