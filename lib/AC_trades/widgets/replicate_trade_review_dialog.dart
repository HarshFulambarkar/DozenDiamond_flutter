import '../../AC_trades/models/replicate_trade_request.dart';
import 'package:flutter/material.dart';

import '../services/trades_rest_api_service.dart';

class ReplicateTradeReviewDialog extends StatefulWidget {
  final String? stockName;
  final int? tradeUnit;
  final int? tradeId;
  final int? totalPositionAfterAction;
  final double? tradeExecutionPrice;
  final int? stockCurrentPosition;
  final String? stockCurrentPrice;
  final double? currentBalance;
  final double? balanceAfterReplicate;
  ReplicateTradeReviewDialog({
    super.key,
    required this.stockName,
    required this.tradeUnit,
    required this.tradeExecutionPrice,
    required this.tradeId,
    required this.totalPositionAfterAction,
    required this.stockCurrentPosition,
    required this.stockCurrentPrice,
    required this.currentBalance,
    required this.balanceAfterReplicate,
  });

  @override
  State<ReplicateTradeReviewDialog> createState() =>
      _ReplicateTradeReviewDialogState();
}

class _ReplicateTradeReviewDialogState
    extends State<ReplicateTradeReviewDialog> {
  @override
  Widget build(BuildContext context) {
    String? stockName = widget.stockName;
    int? totalPositionAfterReplicate = widget.totalPositionAfterAction;
    double? tradeExecutionPrice = widget.tradeExecutionPrice;
    int? tradeUnit = widget.tradeUnit;
    double? stockCurrentPrice = double.parse(widget.stockCurrentPrice!);
    int? currentPosition = widget.stockCurrentPosition;
    double? profitLossAfterTrade =
        (totalPositionAfterReplicate! - currentPosition!) *
            tradeExecutionPrice!;
    double? stockCurrentValue = stockCurrentPrice * currentPosition;
    double? stockTotalValueAfterReplicate =
        totalPositionAfterReplicate * tradeExecutionPrice;
    double? currentBalance = widget.currentBalance;
    double? balanceAfterReplicate = widget.balanceAfterReplicate;
    double? balanceDifferenceAfterReplicate =
        balanceAfterReplicate! - currentBalance!;
    return AlertDialog(
      title: Text(
        "Replicate trade confirmation",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.orangeAccent,
          fontWeight: FontWeight.w500,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text("$stockName current position")),
              Expanded(
                child: Text(
                  "$currentPosition units",
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text("$stockName position after replicating trade")),
              Expanded(
                child: RichText(
                  text: TextSpan(
                      text: "$totalPositionAfterReplicate units",
                      children: [
                        TextSpan(
                            text: "\n(+$tradeUnit)",
                            style: TextStyle(
                              color: Colors.green,
                            ))
                      ]),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text("$stockName current total value")),
              Expanded(
                  child: Text(
                "$stockCurrentValue",
                textAlign: TextAlign.end,
              )),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child:
                      Text("$stockName total value after replicating trade")),
              Expanded(
                child: RichText(
                  text: TextSpan(
                      text: "$stockTotalValueAfterReplicate",
                      children: [
                        TextSpan(
                            text: "\n(+$profitLossAfterTrade)",
                            style: TextStyle(
                              color: profitLossAfterTrade < 0
                                  ? Colors.red
                                  : Colors.green,
                            ))
                      ]),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text("Current balance")),
              Expanded(
                child: Text(
                  "$currentBalance",
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text("Account balance after replicating trade")),
              Expanded(
                child: RichText(
                  text: TextSpan(text: "$balanceAfterReplicate", children: [
                    TextSpan(
                        text:
                            "\n(${balanceDifferenceAfterReplicate > 0 && balanceDifferenceAfterReplicate != 0 ? '+' : ''}$balanceDifferenceAfterReplicate)",
                        style: TextStyle(
                          color: balanceDifferenceAfterReplicate < 0
                              ? Colors.red
                              : Colors.green,
                        ))
                  ]),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ),
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
                      .replicateTrade(ReplicateTradeRequest(
                          tradeId: widget.tradeId,
                          tradeExePrice:
                              (widget.tradeExecutionPrice).toString(),
                          tradeUnit: widget.tradeUnit))
                      .then((res) {
                    if (res.status!) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "$stockName buy open order placed successfully at $tradeExecutionPrice for $tradeUnit units"),
                        ),
                      );
                      // bottomNavigationBar
                    } else {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("${res.msg}")));
                    }
                  });
                },
                child: Text('Replicate', style: TextStyle(fontSize: 18)),
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
