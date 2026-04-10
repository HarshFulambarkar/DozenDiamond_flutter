import 'package:dozen_diamond/AA_positions/stateManagement/position_provider.dart';
import 'package:dozen_diamond/AB_Ladder/stateManagement/ladder_provider.dart';
import 'package:dozen_diamond/AC_trades/stateManagement/trades_provider.dart';
import 'package:dozen_diamond/AD_Orders/stateManagement/order_provider.dart';
import 'package:dozen_diamond/AE_Activity/stateManagement/activity_provider.dart';
import 'package:dozen_diamond/ZB_accountInfoBar/stateManagement/custom_home_app_bar_provider.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:provider/provider.dart';

import '../../AC_trades/models/close_trade_request.dart';
import 'package:flutter/material.dart';
import '../models/get_all_unsettled_trade_list_response.dart';

import '../services/trades_rest_api_service.dart';

class CloseTradeConfirmDialog extends StatefulWidget {
  final Data tradeData;
  final int? totalPositonAfterAction;
  final String? reduceOrderPrice;
  final int? reduceTradeUnit;
  final int? stockCurrentPosition;
  final String? currentBalance;
  final double? balanceAfterReduce;
  final bool? repurchaseAfterSale;
  const CloseTradeConfirmDialog({
    super.key,
    required this.tradeData,
    this.totalPositonAfterAction,
    this.reduceOrderPrice,
    this.reduceTradeUnit,
    this.stockCurrentPosition,
    this.currentBalance,
    this.balanceAfterReduce,
    this.repurchaseAfterSale,
  });

  @override
  State<CloseTradeConfirmDialog> createState() =>
      _CloseTradeConfirmDialogState();
}

class _CloseTradeConfirmDialogState extends State<CloseTradeConfirmDialog> {
  TradesProvider? _tradesProvider;
  OrderProvider? _orderProvider;
  PositionProvider? _positionProvider;
  LadderProvider? _ladderProvider;
  ActivityProvider? _activityProvider;
  CustomHomeAppBarProvider? _customHomeAppBarProvider;
  CurrencyConstants? _currencyConstantsProvider;

  Future<void> refreshDataAfterCloseTrade() async {
    try {
      await _tradesProvider!.fetchTrades(_currencyConstantsProvider!);
      await _orderProvider!.fetchOrders(_currencyConstantsProvider!);
      await _positionProvider!.fetchPositions(_currencyConstantsProvider!);
      await _ladderProvider!.fetchAllLadder(_currencyConstantsProvider!);
      await _activityProvider!.fetchActivities();
      await _customHomeAppBarProvider!.fetchUserAccountDetails();
    } on HttpApiException catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    _currencyConstantsProvider =
        Provider.of<CurrencyConstants>(context, listen: true);
    String? stockName = widget.tradeData.tradeTicker;
    int? totalPositionAfterAction = widget.totalPositonAfterAction!;
    double reduceOrderPrice = double.parse(widget.reduceOrderPrice!);
    int? reduceTradeUnit = widget.reduceTradeUnit;
    int? stockCurrentPosition = widget.stockCurrentPosition!;
    // double? stockCurrentPrice =
    //     double.parse(widget.tradeData.stockCurrentPrice!);
    double? gainLossOnReplicate =
        (totalPositionAfterAction - stockCurrentPosition) * reduceOrderPrice;
    double currentBalance = double.parse(widget.currentBalance!);
    double balanceAfterReduce = widget.balanceAfterReduce!;
    double? differenceBalanceAfterReplicate =
        balanceAfterReduce - currentBalance;
    return AlertDialog(
      contentPadding: EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 10),
      title: Text(
        "Close Trade",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.red,
        ),
      ),
      content: SingleChildScrollView(
          child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text("$stockName current position")),
              Expanded(
                  child: Text(
                "$stockCurrentPosition",
                textAlign: TextAlign.end,
              ))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(child: Text("$stockName position after closing trade")),
              Expanded(
                  child: RichText(
                text: TextSpan(
                    text: "${widget.totalPositonAfterAction}",
                    children: [
                      TextSpan(
                        text: "\n(-$reduceTradeUnit)",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      )
                    ]),
                textAlign: TextAlign.end,
              ))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(child: Text("$stockName current total value")),
              Expanded(
                  child: Text(
                "N/A",
                // "${stockCurrentPosition * stockCurrentPrice}",
                textAlign: TextAlign.end,
              ))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                  child: Text("$stockName total value after closing trade")),
              Expanded(
                  child: RichText(
                text: TextSpan(
                    text: "${totalPositionAfterAction * reduceOrderPrice}",
                    children: [
                      TextSpan(
                        text: " \n($gainLossOnReplicate)",
                        style: TextStyle(
                          color: gainLossOnReplicate < 0
                              ? Colors.red
                              : Colors.green,
                        ),
                      )
                    ]),
                textAlign: TextAlign.end,
              ))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(child: Text("Current account balance")),
              Expanded(
                  child: Text(
                "$currentBalance",
                textAlign: TextAlign.end,
              ))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(child: Text("Account balance after closing trade")),
              Expanded(
                  child: RichText(
                text: TextSpan(text: "$balanceAfterReduce", children: [
                  TextSpan(
                    text:
                        "\n(${differenceBalanceAfterReplicate > 0 && differenceBalanceAfterReplicate != 0 ? '+' : ''}$differenceBalanceAfterReplicate)",
                    style: TextStyle(
                      color: differenceBalanceAfterReplicate < 0
                          ? Colors.red
                          : Colors.green,
                    ),
                  )
                ]),
                textAlign: TextAlign.end,
              ))
            ],
          ),
        ],
      )),
      actions: [
        Row(
          children: [
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  TradesRestApiService()
                      .closeTradeById(CloseTradeRequest(
                          tradeId: widget.tradeData.tradeId,
                          repurchaseAfterSale: widget.repurchaseAfterSale))
                      .then((value) async {
                    if (value!.status!) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "$stockName $reduceTradeUnit units sold successfully at $reduceOrderPrice."),
                        ),
                      );
                      await refreshDataAfterCloseTrade();
                    } else {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${value.msg}"),
                        ),
                      );
                    }
                  });
                },
                child: Text(
                  'Close',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel', style: TextStyle(fontSize: 18)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
          ],
        )
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
        side: const BorderSide(
          color: Colors.white,
          width: 1,
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      backgroundColor: const Color(0xFF15181F),
    );
  }
}
