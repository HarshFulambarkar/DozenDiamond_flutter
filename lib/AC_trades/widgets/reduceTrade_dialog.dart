import '../models/get_all_unsettled_trade_list_response.dart';
import '../../AC_trades/models/total_position_trade_action_request.dart';
import '../../AC_trades/widgets/reduce_trade_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:pinput/pinput.dart';

import '../services/trades_rest_api_service.dart';

class ReduceTradeDialog extends StatefulWidget {
  final Data tradeData;
  ReduceTradeDialog({super.key, required this.tradeData});

  @override
  State<ReduceTradeDialog> createState() => _ReduceTradeDialogState();
}

class _ReduceTradeDialogState extends State<ReduceTradeDialog> {
  bool _limitOrder = false;
  final _reduceTradeUnitController = TextEditingController();
  final _limitOrderPriceController = TextEditingController();
  final _limitOrderReduceTrade = ValueNotifier<bool>(false);
  final _reduceTradeFormKey = GlobalKey<FormState>();
  bool _limitPriceGreaterthanCurrent = false;
  ScrollController _scrollController = ScrollController();
  FocusNode _reduceTradePriceFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    // _limitOrderPriceController.text = widget.tradeData
    // _limitOrderPriceController.text = widget.tradeData.stockCurrentPrice!;
    _limitOrderReduceTrade.addListener(() {
      if (mounted) {
        setState(() {
          if (_limitOrderReduceTrade.value) {
            _limitOrder = true;
            _reduceTradePriceFocus.requestFocus();
          } else {
            _limitOrder = false;
            // _limitOrderPriceController.text =
            //     widget.tradeData.stockCurrentPrice!;
          }
        });
      }
    });
  }

  InputDecoration textFormFieldDecoration(String hintText) {
    return InputDecoration(
      errorMaxLines: 8,
      errorStyle: TextStyle(color: Colors.yellow, fontSize: 18),
      hintText: hintText,
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
      hintStyle: TextStyle(color: Colors.grey),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: _limitOrder ? Colors.white : Colors.grey,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: _limitOrder ? Colors.white : Colors.grey,
        ),
      ),
    );
  }

  String? sellOrderPriceValid(String? value) {
    RegExp regex = RegExp(r'(\..*){2,}');
    if (value == null || value.isEmpty) {
      return 'Please enter valid value';
    } else if (regex.hasMatch(value)) {
      return 'More than one "." not allowed';
    } else if (RegExp(r'\.').hasMatch(value) &&
        !RegExp(r'\.\d+').hasMatch(value)) {
      return "Please enter valid value";
    } else if (RegExp(r'^0+$').hasMatch(value)) {
      return "Please enter value greater than zero";
    }
    //  else if (double.parse(_limitOrderPriceController.text) <
    //     double.parse(widget.tradeData.stockCurrentPrice!)) {
    //   return "Please enter sell price greater or equal to current stock price";
    // }
    else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 10),
      title: Text(
        "Reduce Trade",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.blue,
        ),
      ),
      content: Form(
        key: _reduceTradeFormKey,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Enter the number of units to reduce"),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                  controller: _reduceTradeUnitController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter number of units to reduce';
                    } else if (RegExp(r'^0+$').hasMatch(value)) {
                      return "Please enter value greater than zero";
                    } else if (int.parse(value) >
                        widget.tradeData.tradeTotalUnits!) {
                      return "Please enter quantity less than or equal trade quantity (${widget.tradeData.tradeTotalUnits!} units)";
                    } else {
                      return null;
                    }
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: textFormFieldDecoration('Units')),
              SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Market/Limit order",
                      textAlign: TextAlign.start,
                    ),
                  ),
                  AdvancedSwitch(
                    height: 25,
                    activeColor: Colors.blue,
                    inactiveColor: Colors.blueGrey,
                    controller: _limitOrderReduceTrade,
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: Text("Selling price")),
                  // SizedBox(
                  //   width: 10,
                  //   height: 50,
                  // ),
                  Expanded(
                    child: TextFormField(
                      controller: _limitOrderPriceController,
                      keyboardType: TextInputType.number,
                      readOnly: !_limitOrder,
                      focusNode: _reduceTradePriceFocus,
                      validator: sellOrderPriceValid,
                      onChanged: (value) {
                        Future.delayed(Duration(milliseconds: 500), () {
                          _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.ease);
                        });
                        if (mounted) {
                          setState(() {
                            // _limitPriceGreaterthanCurrent =
                            //     double.parse(_limitOrderPriceController.text) !=
                            //         double.parse(
                            //             widget.tradeData.stockCurrentPrice!);
                          });
                        }
                      },
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^[0-9\.]+$')),
                      ],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: textFormFieldDecoration('Sell order price'),
                      style: TextStyle(
                          color: _limitOrder ? Colors.white : Colors.grey),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
                  if (_reduceTradeFormKey.currentState!.validate() &&
                      _reduceTradeUnitController.length > 0) {
                    TradesRestApiService()
                        .totalPositionTradeAction(
                            TotalPositionTradeActionRequest(
                                tradeId: widget.tradeData.tradeId,
                                tradeOrderPrice:
                                    _limitOrderPriceController.text,
                                tradeType: "reduce",
                                tradeUnit:
                                    int.parse(_reduceTradeUnitController.text)))
                        .then(
                      (value) {
                        if (value.status!) {
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return ReduceTradeConfirmDialog(
                                  tradeData: widget.tradeData,
                                  totalPositonAfterAction:
                                      value.data!.totalUnit,
                                  reduceOrderPrice:
                                      _limitOrderPriceController.text,
                                  reduceTradeUnit: int.parse(
                                      _reduceTradeUnitController.text),
                                  limitOrder: _limitOrder
                                  //  &&
                                  //     _limitOrderPriceController.text !=
                                  //         widget.tradeData.stockCurrentPrice
                                  ,
                                  stockCurrentPosition:
                                      value.data!.curntPositionUnit,
                                  currentBalance: value.data!.curntBalance,
                                  balanceAfterReduce: double.tryParse(
                                      value.data!.futureBalance!),
                                );
                              });
                        }
                      },
                    );
                  }
                },
                child: Text(
                    '${_limitOrder && _limitPriceGreaterthanCurrent ? "Place order" : "Execute order"}',
                    style: TextStyle(fontSize: 18)),
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
