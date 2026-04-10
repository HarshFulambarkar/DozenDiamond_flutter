import 'package:dozen_diamond/DD_Navigation/widgets/bottom_nav_bar.dart';

import '../../AC_trades/models/reduce_trade_request.dart';
import 'package:flutter/material.dart';
import '../models/get_all_unsettled_trade_list_response.dart';
import '../services/trades_rest_api_service.dart';

class ReduceTradeConfirmDialog extends StatefulWidget {
  final Data tradeData;
  final int? totalPositonAfterAction;
  final String? reduceOrderPrice;
  final int? reduceTradeUnit;
  final int? stockCurrentPosition;
  final bool? limitOrder;
  final String? currentBalance;
  final double? balanceAfterReduce;
  ReduceTradeConfirmDialog({
    super.key,
    required this.tradeData,
    required this.totalPositonAfterAction,
    required this.reduceOrderPrice,
    required this.reduceTradeUnit,
    required this.stockCurrentPosition,
    required this.limitOrder,
    required this.currentBalance,
    this.balanceAfterReduce,
  });

  @override
  State<ReduceTradeConfirmDialog> createState() =>
      _ReduceTradeConfirmDialogState();
}

class _ReduceTradeConfirmDialogState extends State<ReduceTradeConfirmDialog> {
  @override
  Widget build(BuildContext context) {
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
        "Reduce Trade",
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
              Expanded(child: Text("$stockName position after reducing trade")),
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
                // "${stockCurrentPosition * stockCurrentPrice}",
                "N/A",
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
                  child: Text("$stockName total value after reducing trade")),
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
              Expanded(child: Text("Account balance after reducing trade")),
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
                      .reduceTrade(ReduceTradeRequest(
                    tradeId: widget.tradeData.tradeId,
                    tradeOrderPrice: widget.reduceOrderPrice,
                    tradeUnit: widget.reduceTradeUnit,
                  ))
                      .then((value) {
                    if (value.status!) {
                      if (!widget.limitOrder!) {
                        print("paneer");
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "$stockName  $reduceTradeUnit units sold successfully at $reduceOrderPrice"),
                          ),
                        );
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => BottomNavigationbar(
                            enableBackButton: false,
                            enableMenuButton: true,
                            bottomNavigatonIndex: 3,
                            goToIndex: 1,
                          ),
                        ));
                      } else {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Sell open order placed successfully for $stockName at $reduceOrderPrice for $reduceTradeUnit units"),
                          ),
                        );
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => BottomNavigationbar(
                            enableBackButton: false,
                            enableMenuButton: true,
                            bottomNavigatonIndex: 3,
                            goToIndex: 2,
                          ),
                        ));
                      }
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
                  'Reduce',
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
