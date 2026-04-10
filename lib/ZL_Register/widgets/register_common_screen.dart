// // import 'package:dozen_diamond/DD_Navigation/stateManagement/navigation_provider.dart';
// // import 'package:dozen_diamond/Settings/stateManagement/theme_provider.dart';
//
// import 'package:provider/provider.dart';
//
// // import '../../AA_positions/screens/position_tab.dart';
// // import '../../AB_Ladder/screens/ladder_tab.dart';
// // import '../../AC_trades/screens/modify_trade.dart';
// // import '../../AC_trades/screens/trade_tab.dart';
// // import '../../AD_Orders/screens/modify_orders.dart';
// // import '../../AD_Orders/screens/orders_tab.dart';
// // import '../../AE_Activity/screens/activity_tab.dart';
// // import '../../createLadder/screens/createladderSelectStock.dart';
// // import '../../createLadder/screens/createladder_step2.dart';
// // import '../../createLadder/screens/createladder_step3.dart';
// // import '../../createLadder/screens/createladder_step4.dart';
// // import '../../F_Funds/screens/aboutPaperCash.dart';
// // import '../../F_Funds/screens/addFunds.dart';
// // import '../../F_Funds/screens/withdrawFunds.dart';
// // import '../../login/screens/forgot_password_screen.dart';
// // import '../../login/screens/login_page.dart';
// // import '../../Settings/screens/multiple_ladder_creation_setting.dart';
// // import '../../Settings/screens/notification_page1.dart';
// // import '../../Settings/screens/push_notification_page.dart';
// // import '../../Settings/screens/settings_page.dart';
// // import '../../Settings/screens/support_app_page.dart';
// // import '../../Settings/screens/switch_trade_options.dart';
// // import '../../Settings/screens/theme_screen.dart';
// // import '../../Settings/screens/trading_options_info.dart';
// // import '../../Settings/screens/unused_code_old.dart';
// // import '../../ZH_Analysis/screens/select_analysis_type.dart';
// // import '../../ZH_analysisAlpha/screens/analysis_alpha.dart';
// // import '../../ZH_analysisPriceVsNumberOfStocks/screens/analysisDifferentialCostVsNOS.dart';
// // import '../../ZH_analysisPriceVsNumberOfStocks/screens/analysisPriceVsNOS.dart';
// // import '../../ZH_analysisPriceVsNumberOfStocks/screens/analysisPriceVsValue.dart';
// // import '../../ZH_analysisPriceVsNumberOfStocks/screens/analysisValueVsNOS.dart';
// // import '../../ZH_analysisPriceVsNumberOfStocks/screens/averageCostVsNOS.dart';
// // import '../../ZH_analysisPriceVsNumberOfStocks/screens/averageCostVsPrice.dart';
// // import '../../ZH_analysisPriceVsNumberOfStocks/screens/extraCashVsPrice.dart';
// // import '../../ZH_analysisProfitVsPrice/screens/analysis_profit_vs_price.dart';
// // import '../../ZH_analysisSettledClosestTrade/screens/analysis_settled_closest_trade.dart';
// // import '../../ZH_analysisSettledRecentTrade/screens/analysis_settled_recent_trade.dart';
// // import '../../ZH_analysisTradeAnalytics/screens/analysis_trade_analytics.dart';
// // import '../../ZH_analysisUnsettledClosestBuy/screens/analysis_unsettled_closest_buy.dart';
// // import '../../ZH_analysisUnsettledRecentBuy/screens/analysis_unsettled_recent_buy.dart';
// // import '../../ZI_Search/screens/search_page.dart';
// // import '../../ZI_Search/screens/sector_wise_stock_dialog.dart';
// // import '../../ZI_Search/screens/stock_by_sector_page.dart';
// // import '../../ZL_Register/screens/signup_page.dart';
// // import '../../ZM_mpin/screens/mpin_generation_page.dart';
// // import '../../ZM_mpin/screens/mpin_validator_page.dart';
//
// import 'package:flutter/material.dart';
//
// import '../../ZM_mpin/screens/mpin_validator_page.dart';
// import '../../login/screens/forgot_password_screen.dart';
// import '../../login/screens/login_page.dart';
// import '../screens/signup_page.dart';
// import '../stateManagement/register_common_screen_provider.dart';
//
// class RegisterCommonScreen extends StatefulWidget {
//   final int? bottomNavigatonIndex;
//
//   final bool enableBackButton;
//   final bool enableMenuButton;
//   final int goToIndex;
//   final Function? updateIndex;
//   final bool initiallyExpanded;
//   final String selectedTicker;
//   const RegisterCommonScreen({
//     super.key,
//     this.bottomNavigatonIndex,
//     this.enableBackButton = false,
//     this.enableMenuButton = true,
//     this.goToIndex = 0,
//     this.updateIndex,
//     this.initiallyExpanded = true,
//     this.selectedTicker = "Select ticker",
//   });
//
//   @override
//   State<RegisterCommonScreen> createState() => _RegisterCommonScreenState();
// }
//
// class _RegisterCommonScreenState extends State<RegisterCommonScreen> {
//   int selectedIndex = 0;
//
//   bool displayFilterDialog = true;
//
//   late RegisterCommonScreenProvider registerCommonScreenProvider;
//
//   List get pages => [
//         SignUpPage(),
//         LoginPage(),
//         MpinValidatorPage(),
//         MpinValidatorPage(fetchUserData: true),
//         ForgotPasswordScreen()
//       ];
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     registerCommonScreenProvider =
//         Provider.of<RegisterCommonScreenProvider>(context, listen: true);
//     return Scaffold(
//       body: pages[registerCommonScreenProvider.selectedIndex],
//     );
//   }
// }
