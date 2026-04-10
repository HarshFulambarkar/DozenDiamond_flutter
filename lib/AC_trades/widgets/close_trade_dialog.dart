import '../../AC_trades/models/total_position_trade_action_request.dart';
import '../models/get_all_unsettled_trade_list_response.dart';
import 'package:flutter/material.dart';

import '../../AC_trades/widgets/close_trade_confirm_dialog.dart';
import '../services/trades_rest_api_service.dart';

class CloseTradeDialog extends StatefulWidget {
  final Data tradeData;
  CloseTradeDialog({super.key, required this.tradeData});

  @override
  State<CloseTradeDialog> createState() => _CloseTradeDialogState();
}

class _CloseTradeDialogState extends State<CloseTradeDialog> {
  bool repurchaseAfterSale = false;
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.white;
    }
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "${widget.tradeData.tradeTicker} Close trade",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.redAccent,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text("Close trade units")),
                Expanded(
                    child: Text(
                  "${widget.tradeData.tradeTotalUnits}",
                  textAlign: TextAlign.end,
                ))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(child: Text("Opened at")),
                Expanded(
                    child: Text(
                  "${widget.tradeData.tradeExecutionPrice}",
                  textAlign: TextAlign.end,
                ))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(child: Text("Closing at")),
                Expanded(
                    child: Text(
                  "N/A",
                  // "${widget.tradeData.stockCurrentPrice}",
                  textAlign: TextAlign.end,
                ))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(
                    // "Repurchase at ${widget.tradeData.tradeExePrice} after sale?"
                    "N/A")),
                Flexible(
                  child: Checkbox(
                    value: repurchaseAfterSale,
                    onChanged: (value) {
                      setState(() {
                        repurchaseAfterSale = !repurchaseAfterSale;
                      });
                    },
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
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
                  // TradesRestApiService()
                  //     .totalPositionTradeAction(TotalPositionTradeActionRequest(
                  //         tradeId: widget.tradeData.tradeId,
                  //         tradeOrderPrice: widget.tradeData.stockCurrentPrice,
                  //         tradeType: "reduce",
                  //         tradeUnit: widget.tradeData.tradeUnit))
                  //     .then(
                  //   (value) {
                  //     if (value.status!) {
                  //       Navigator.pop(context);
                  //       showDialog(
                  //           context: context,
                  //           barrierDismissible: false,
                  //           builder: (context) {
                  //             return CloseTradeConfirmDialog(
                  //               tradeData: widget.tradeData,
                  //               totalPositonAfterAction: value.data!.totalUnit,
                  //               reduceOrderPrice:
                  //                   widget.tradeData.stockCurrentPrice,
                  //               reduceTradeUnit: widget.tradeData.tradeUnit,
                  //               stockCurrentPosition:
                  //                   value.data!.curntPositionUnit,
                  //               currentBalance: value.data!.curntBalance,
                  //               balanceAfterReduce:
                  //                   double.tryParse(value.data!.futureBalance!),
                  //               repurchaseAfterSale: repurchaseAfterSale,
                  //             );
                  //           });
                  //     }
                  //   },
                  // );
                },
                child: Text('Close trade', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
