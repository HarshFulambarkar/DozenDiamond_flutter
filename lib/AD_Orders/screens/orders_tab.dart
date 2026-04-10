import 'package:dozen_diamond/AD_Orders/stateManagement/order_provider.dart';
import 'package:dozen_diamond/ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:dozen_diamond/global/widgets/info_alert_dialog.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../AB_Ladder/stateManagement/ladder_provider.dart';
import '../../AD_orders/screens/modify_orders.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:dozen_diamond/AD_Orders/models/get_all_open_order_list_response.dart';
import '../../Settings/stateManagement/theme_provider.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/services/num_formatting.dart';
import '../../global/widgets/my_text_field.dart';
import '../../global/widgets/shimmer_loading_view.dart';
import '../models/close_order_request.dart';
import '../services/orders_rest_api_service.dart';
import '../../global/functions/utils.dart';

class OrdersTab extends StatefulWidget {
  final String? selectedTicker;
  const OrdersTab({super.key, this.selectedTicker});

  @override
  State<OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> {
  List<bool> orderActionVisible = [];
  bool isError = false;
  GetAllOpenOrderListResponse? getAllStockOrderListResponse;
  OrderProvider? _orderProvider;
  CurrencyConstants? _currencyConstantsProvider;
  late LadderProvider ladderProvider;
  late ThemeProvider themeProvider;

  TradeMainProvider? _tradeMainProvider;
  @override
  void initState() {
    super.initState();

    _tradeMainProvider = Provider.of<TradeMainProvider>(context, listen: false);
    _orderProvider = Provider.of<OrderProvider>(context, listen: false);
    _currencyConstantsProvider = Provider.of(context, listen: false);
    callInitialApi();
  }

  void closeOrder(
      CloseOrderRequest closeOrderReq, String stockName, String orderType) {
    OrdersRestApiService().closeOrder(closeOrderReq).then((res) {
      if (res.status!) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  "$stockName ${orderType.toLowerCase()} order closed successfully!")));
        }
      }
      Navigator.pop(context);
      _orderProvider!.fetchOrders(_currencyConstantsProvider!);
    }).catchError((err) {
      Navigator.pop(context);
      print(err);
    });
  }

  Future<void> callInitialApi() async {
    try {
      await _orderProvider!.fetchOrders(_currencyConstantsProvider!);
    } on HttpApiException catch (err) {
      print(err);
    }
  }

  Future<void> modifyOrderDialog(String? stockName, String? orderType1,
      int? quantity, String? entryPrice) {
    String orderType = orderType1 == 'BUY' ? 'Buy' : 'Sell';
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Modify order for $stockName',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
            content: Text(
                'Are you sure you want to modify open $orderType order ? \n Quantity: $quantity units \n $orderType entry: $entryPrice '),
            actions: [
              Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ModifyOrdersPage()));
                        },
                        child: Text('Proceed')),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(
                        color: Colors.blue,
                      )),
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
        });
  }

  Future<void> closeOrderDialog(String? stockName, String? orderType1,
      int? quantity, String? entryPrice, CloseOrderRequest? closeOrderReq) {
    String orderType = orderType1 == 'BUY' ? 'Buy' : 'Sell';
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Cancel order for $stockName',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
            content: Text(
                'Are you sure you want to close $orderType open order ? \nQuantity: $quantity units \n$orderType entry: $entryPrice'),
            actions: [
              Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        closeOrder(closeOrderReq!, stockName!, orderType1!);
                      },
                      child: Text(
                          'Cancel order',
                        style: TextStyle(
                            color: Colors.white
                        ),
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
                      child: Text('Cancel'),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(
                        color: Colors.blue,
                      )),
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
        });
  }

  Future<void> orderPartialSellBuyDialog(Data? orderData, int i) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setStateSB) {
            return AlertDialog(
              title: Text(
                'Partial ${orderData?.orderType} Order',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  Text('Enter Limit Price'),

                  SizedBox(
                    height: 5,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 40,
                        child: MyTextField(
                          isFilled: true,
                          fillColor: (themeProvider.defaultTheme)
                              ?Color(0xffCACAD3):Color(0xff2c2c31),
                          borderColor: (themeProvider.defaultTheme)
                              ?Color(0xffCACAD3):Color(0xff2c2c31),
                          textStyle: TextStyle(
                            color: (themeProvider.defaultTheme)
                                ?Colors.black:Colors.white,
                          ),
                          maxLength: 9,
                          elevation: 0,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.number,
                          // textStyle: (themeProvider.defaultTheme)
                          //     ? TextStyle(color: Colors.black)
                          //     : kBodyText,
                          // borderColor: Color(0xff2c2c31),
                          margin: EdgeInsets.zero,
                          focusedBorderColor: ((_orderProvider!.limitPriceErrorText != ""))
                              ? Color(0xffd41f1f)
                              : Color(0xff5cbbff),
                          counterText: "",
                          textInputFormatters: [
                            // FilteringTextInputFormatter.digitsOnly

                            FilteringTextInputFormatter.allow(
                              RegExp(r'^[0-9,\.]+$'),
                            ),
                          ],
                          borderRadius: 8,

                          labelText: '',
                          onChanged: (value) {
                            print(value);

                            print(value);

                            double limitPrice = double.tryParse(value) ?? 0.0;

                            if (value.isEmpty) {
                              _orderProvider!.limitPrice = 'null';
                            } else {

                              double tickSize = 0;

                              if(orderData?.orderExchange == "NSE") {

                                if(limitPrice < 250) {
                                  tickSize = 0.01;
                                } else if(limitPrice < 1000) {
                                  tickSize = 0.05;
                                } else if(limitPrice < 5000) {
                                  tickSize = 0.10;
                                } else if(limitPrice < 10000) {
                                  tickSize = 0.50;
                                } else if(limitPrice < 20000) {
                                  tickSize = 1.00;
                                } else {
                                  tickSize = 5.00;
                                }

                              } else if(orderData?.orderExchange == "BSE") {
                                if(limitPrice < 100) {
                                  tickSize = 0.01;
                                } else {
                                  tickSize = 0.05;
                                }

                              }

                              // double remainder = (limitPrice % tickSize);
                              // double remainder = limitPrice.remainder(tickSize);
                              double divided = limitPrice / tickSize;
                              // int x = divided.floor();

                              double remainder = limitPrice - (tickSize * divided);

                              // const scale = 2; // 2 decimals (0.05 is representable with 2 decimals)
                              // final aUnits = Utility().toUnits(limitPrice.toString(), scale);   // 30000
                              // final bUnits = Utility().toUnits(tickSize.toString(), scale);  // 5
                              // final remainder = aUnits % bUnits;

                              print("below is remainder");
                              print(limitPrice);
                              print(tickSize);
                              print(remainder);

                              if(remainder == 0) {

                                _orderProvider!.limitPrice = value;
                                _orderProvider!.limitPriceErrorText = "";

                              } else {
                                _orderProvider!.limitPrice = 'null';
                                _orderProvider!.limitPriceErrorText = "Limit price should be multiplier of $tickSize";
                              }

                            }

                            setStateSB(() {});
                          },
                        ),
                      ),

                      (_orderProvider!.limitPriceErrorText == "")
                          ? Container()
                          : Text(_orderProvider!.limitPriceErrorText,
                          style: TextStyle(color: Colors.red))
                    ],
                  ),

                  SizedBox(
                    height: 10,
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
                            // stockName = stock;

                            if(_orderProvider!.limitPrice == 'null' || _orderProvider!.limitPrice == "") {
                              _orderProvider!.limitPriceErrorText = "Please enter limit price";
                            } else {
                              double currentPrice = (double.tryParse(_orderProvider!.limitPrice) ?? 0.0);
                                  // orderData?.currentPrice ?? 0.0;
                              double entryPrice;

                              double stepSize = 0;

                              for (int i = 0;
                              i < ladderProvider.stockLadders.length;
                              i++) {
                                for (int j = 0;
                                j <
                                    ladderProvider
                                        .stockLadders[i].ladders.length;
                                j++) {
                                  if (orderData?.orderLadderId ==
                                      ladderProvider
                                          .stockLadders[i].ladders[j].ladId) {
                                    stepSize = ladderProvider
                                        .stockLadders[i].ladders[j].ladStepSize;
                                    print("inside ifff");
                                    print(stepSize);
                                  }
                                }
                              }

                              if (orderData?.orderType == 'BUY') {

                                entryPrice = orderData?.orderOpenPrice ?? 0.0;
                                // stepSize = double.tryParse(
                                //         orderData.opoBuyStepSize ?? '') ??
                                //     0.0;
                                print("below are values for buy");
                                print(currentPrice);
                                print(entryPrice);
                                print(stepSize);
                                print(entryPrice + stepSize);
                                if (currentPrice < (entryPrice + stepSize) &&
                                    currentPrice != entryPrice) {
                                  if(currentPrice < orderData!.orderOpenPrice) {

                                    InfoAlertDialog().showInfoAlertDialog(
                                      context,
                                      "Warning",
                                      "limit price must be less than last order price",
                                    );

                                  } else {
                                    Navigator.pop(context);
                                    await _orderProvider!.calculatePartialBuySell(
                                        "Buy",
                                        i - 1,
                                        _currencyConstantsProvider!,
                                        stepSize,
                                        context, currentPrice);
                                  }

                                } else {
                                  InfoAlertDialog().showInfoAlertDialog(
                                    context,
                                    "Warning",
                                    "Partial Buy at this price is not possible as the current price is higher than the last trade executed price.",
                                  );
                                }
                              } else {
                                entryPrice = orderData?.orderOpenPrice ?? 0.0;
                                // stepSize = double.tryParse(
                                //         orderData.opoSellStepSize ?? '') ??
                                //     0.0;
                                print("below are values for sell");
                                print(currentPrice);
                                print(entryPrice);
                                print(stepSize);
                                print(entryPrice - stepSize);
                                if (currentPrice > (entryPrice - stepSize) &&
                                    currentPrice != entryPrice) {
                                  if(currentPrice > orderData!.orderOpenPrice) {

                                    InfoAlertDialog().showInfoAlertDialog(
                                      context,
                                      "Warning",
                                      "limit price must be greater than last order price",
                                    );

                                  } else {
                                    Navigator.pop(context);
                                    await _orderProvider!.calculatePartialBuySell(
                                        "Sell",
                                        i - 1,
                                        _currencyConstantsProvider!,
                                        stepSize,
                                        context, currentPrice);
                                  }

                                } else {
                                  InfoAlertDialog().showInfoAlertDialog(
                                    context,
                                    "Warning",
                                    "Partial Sell at this price is not possible as the current price is lower than the last trade executed price.",
                                  );
                                }
                              }
                            }

                            setStateSB(() {});
                          },
                          child: Text(
                            'Proceed',
                            style: TextStyle(
                                color: Colors.white
                            ),
                          )),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              color: Colors.blue
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Colors.blue,
                            )),
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
          });
        });
  }

  Future<void> closeOrderDialogNew(String? stockName, String orderId) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Cancel order for $stockName',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
            content: Text(
                'Are you sure you want to cancel $stockName order ?'),
            actions: [
              Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _orderProvider!.cancelOrder(orderId, _currencyConstantsProvider!);

                      },
                      child: Text(
                        'Cancel order',
                        style: TextStyle(
                            color: Colors.white
                        ),
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
                      child: Text(
                          'Cancel',
                        style: TextStyle(
                          color: (themeProvider.defaultTheme)?Colors.black:Colors.white,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.blue,
                          )),
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
        });
  }

  Widget orderUI({
    required BuildContext context,
    required Data orderData,
    required int i,
    required OrderProvider orderState,
  }) {
    if (_tradeMainProvider!.selectedTickerForSimulation.ticker ==
            "Select ticker" ||
        (orderData.orderType == 'BUY' &&
            _tradeMainProvider!.selectedTickerForSimulation.ticker ==
                orderData.orderStockName) ||
        (orderData.orderType == 'SELL' &&
            _tradeMainProvider!.selectedTickerForSimulation.ticker ==
                orderData.orderStockName)) {
      // double currentPrice = double.tryParse(orderData.c) ?? 0.0;
      return InkWell(
        onTap: () {
          orderState.toggleOrderActionBtnVisibilityAtIndex = i - 1;
        },
        child: Container(
          padding: const EdgeInsets.only(left: 0, right: 0, bottom: 10, top: 0),
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 0, top: 5),
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(
              width: 1,
              color: (themeProvider.defaultTheme)?Colors.black:Colors.white54,
            ),
          )),
          child: Column(
            children: [
              Row(
                children: [
                  Text("$i"),
                  SizedBox(width: 5),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (orderData.orderType == "BUY")
                              Expanded(
                                child: Text(
                                  //  ${orderData.opoBuyLadderName?.trim()}
                                  "${orderData.orderStockName?.trim()} (${orderData.orderExchange}) :Lad-${orderData.orderLadName} ${orderData.orderUnits}UNITS",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: (themeProvider.defaultTheme)?Colors.black:Colors.white,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            if (orderData.orderType == "SELL")
                              Expanded(
                                child: Text(
                                  //  ${orderData.opoSellLadName?.trim()}
                                  "${orderData.orderStockName?.trim()} (${orderData.orderExchange}) Lad-${orderData.orderLadName}: ${orderData.orderUnits}UNITS",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: (themeProvider.defaultTheme)?Colors.black:Colors.white,
                                    fontWeight: FontWeight.normal,
                                  ),
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
                            Text(
                              orderData.orderType == "BUY"
                                  ? "Buy Entry@ : ${amountToInrFormat(context, orderData.orderOpenPrice)}"
                                  : "Sell Entry@ : ${amountToInrFormat(context, orderData.orderOpenPrice)}",
                              style: TextStyle(
                                color: (themeProvider.defaultTheme)?Colors.black:orderData.orderType == "BUY"
                                    ? Colors.green
                                    : Colors.orange,
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            if (orderData.orderType == "BUY")
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Order cost: ${amountToInrFormat(context, orderData.orderOpenPrice * orderData.orderUnits)}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]),
                                  ),
                                  Text(
                                    "Estimated Brokerage: ${amountToInrFormat(context, orderData.estimatedBrokerageCost ?? 0.0)}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]),
                                  ),
                                  Text(
                                    "Estimated Other Charges: ${amountToInrFormat(context, orderData.estimatedTotalTax ?? 0.0)}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]),
                                  ),
                                  Text(
                                    "Ticket# :  ${orderData.orderId}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]),
                                  ),
                                ],
                              )
                            else
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Order return: ${amountToInrFormat(context, orderData.orderOpenPrice * (-orderData.orderUnits))}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]),
                                  ),
                                  Text(
                                    "Estimated Brokerage: ${amountToInrFormat(context, orderData.estimatedBrokerageCost ?? 0.0)}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]),
                                  ),
                                  Text(
                                    "Estimated Total Charges: ${amountToInrFormat(context, orderData.estimatedTotalTax ?? 0.0)}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]),
                                  ),
                                  Text(
                                    "Ticket# : ${orderData.orderId}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: (themeProvider.defaultTheme)?Colors.black:Colors.yellow[200]),
                                  ),
                                ],
                              )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(
                          left: 0,
                          bottom: 5,
                          top: 10,
                        ),
                        child: Provider.of<TradeMainProvider>(context,
                                        listen: false)
                                    .tradingOptions ==
                                TradingOptions
                                    .simulationTradingWithSimulatedPrices
                            ? Text(
                                "${amountToInrFormat(context, orderData.currentPrice)}\nSimulated price",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.green),
                                textAlign: TextAlign.end,
                              )
                            : Text(
                                "${amountToInrFormat(context, orderData.currentPrice)}\nCurrent price",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.green),
                                textAlign: TextAlign.end,
                              )),
                  )
                ],
              ),
              Visibility(
                visible: orderState.orderActionVisible[i - 1],
                child: Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: (orderData.noFollowup == false)
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              // setState(() {
                              //   orderActionVisible[index] = false;
                              // });

                              if (orderData.noFollowup == false) {
                                Fluttertoast.showToast(
                                    msg: "This feature will unlock soon!");
                              }

                              // int? quantity;partial
                              // String? stockName;
                              // String? entryPrice;

                              // if (getAllStockOrderListResponse
                              //         ?.data?[index].orderType ==
                              //     'BUY') {
                              //   quantity = getAllStockOrderListResponse!
                              //       .data![index].opoDefBuyQty;
                              //   stockName = getAllStockOrderListResponse!
                              //       .data![index].opoBuyStockName;
                              //   entryPrice = getAllStockOrderListResponse
                              //       ?.data?[index].opoBuyEntry;
                              // } else {
                              //   quantity = getAllStockOrderListResponse
                              //       ?.data?[index].opoDefSellQty;
                              //   stockName = getAllStockOrderListResponse
                              //       ?.data?[index].opoSellStockName;
                              //   entryPrice = getAllStockOrderListResponse
                              //       ?.data?[index].opoSellEntry;
                              // }
                              // modifyOrderDialog(
                              //     stockName,
                              //     getAllStockOrderListResponse
                              //         ?.data?[index].orderType,
                              //     quantity,
                              //     entryPrice);
                            },
                            child: Text(
                              'Modify',
                              style: TextStyle(color: Colors.white),
                            ))),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: (orderData.noFollowup == false)
                                  ? Colors.orangeAccent
                                  : Colors.grey,
                            ),
                            onPressed: () async {

                              orderPartialSellBuyDialog(orderData, i);

                              // double currentPrice =
                              //     orderData.currentPrice ?? 0.0;
                              // double entryPrice;
                              //
                              // double stepSize = 0;
                              //
                              // for (int i = 0;
                              //     i < ladderProvider.stockLadders.length;
                              //     i++) {
                              //   for (int j = 0;
                              //       j <
                              //           ladderProvider
                              //               .stockLadders[i].ladders.length;
                              //       j++) {
                              //     if (orderData.orderLadderId ==
                              //         ladderProvider
                              //             .stockLadders[i].ladders[j].ladId) {
                              //       stepSize = ladderProvider
                              //           .stockLadders[i].ladders[j].ladStepSize;
                              //       print("inside ifff");
                              //       print(stepSize);
                              //     }
                              //   }
                              // }
                              //
                              // if (orderData.orderType == 'BUY') {
                              //
                              //   entryPrice = orderData.orderOpenPrice ?? 0.0;
                              //   // stepSize = double.tryParse(
                              //   //         orderData.opoBuyStepSize ?? '') ??
                              //   //     0.0;
                              //   print("below are values for buy");
                              //   print(currentPrice);
                              //   print(entryPrice);
                              //   print(stepSize);
                              //   print(entryPrice + stepSize);
                              //   if (currentPrice < (entryPrice + stepSize) &&
                              //       currentPrice != entryPrice) {
                              //     await orderState.calculatePartialBuySell(
                              //         "Buy",
                              //         i - 1,
                              //         _currencyConstantsProvider!,
                              //         stepSize,
                              //         context);
                              //   } else {
                              //     InfoAlertDialog().showInfoAlertDialog(
                              //       context,
                              //       "Warning",
                              //       "Partial Buy at this price is not possible as the current price is higher than the last trade executed price.",
                              //     );
                              //   }
                              // } else {
                              //   entryPrice = orderData.orderOpenPrice ?? 0.0;
                              //   // stepSize = double.tryParse(
                              //   //         orderData.opoSellStepSize ?? '') ??
                              //   //     0.0;
                              //   print("below are values for sell");
                              //   print(currentPrice);
                              //   print(entryPrice);
                              //   print(stepSize);
                              //   print(entryPrice - stepSize);
                              //   if (currentPrice > (entryPrice - stepSize) &&
                              //       currentPrice != entryPrice) {
                              //     await orderState.calculatePartialBuySell(
                              //         "Sell",
                              //         i - 1,
                              //         _currencyConstantsProvider!,
                              //         stepSize,
                              //         context);
                              //   } else {
                              //     InfoAlertDialog().showInfoAlertDialog(
                              //       context,
                              //       "Warning",
                              //       "Partial Sell at this price is not possible as the current price is lower than the last trade executed price.",
                              //     );
                              //   }
                              // }

                              if (orderData.noFollowup == false) {}
                            },
                            child: Text(
                              orderData.orderType == 'BUY'
                                  ? 'Partial buy'
                                  : 'Partial sell',
                              style: TextStyle(color: Colors.white),
                            ))),
                    SizedBox(
                      width: 10,
                    ),
                    (orderData.orderFollowUp == "PARTIAL_NO_FOLLOW_UP")?Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: (orderData.noFollowup == false)
                                ? Colors.red
                                : Colors.grey,
                          ),
                          onPressed: () {
                            // orderState.toggleOrderActionBtnVisibilityAtIndex =
                            //     i - 1;

                            // int? quantity;
                            // String? stockName;
                            // String? entryPrice;
                            // CloseOrderRequest? closeOrderReq;
                            // if (orderData.orderType == 'BUY') {
                            //   quantity = orderData.opoDefBuyQty;
                            //   stockName = orderData.opoBuyStockName;
                            //   entryPrice = orderData.opoBuyEntry;
                            //   closeOrderReq = CloseOrderRequest(
                            //       orderId: orderData.opoBuyId.toString(),
                            //       orderType: 'BUY');
                            // } else {
                            //   quantity = orderData.opoDefSellQty;
                            //   stockName = orderData.opoSellStockName;
                            //   entryPrice = orderData.opoSellEntry;
                            //   closeOrderReq = CloseOrderRequest(
                            //       orderId: orderData.opoSellId.toString(),
                            //       orderType: 'SELL');
                            // }
                            // closeOrderDialog(stockName, orderData.orderType,
                            //     quantity, entryPrice, closeOrderReq);

                            closeOrderDialogNew(orderData.orderStockName, orderData.orderId.toString());

                            // if (orderData.noFollowup == false) {}
                          },
                          child: Text('Cancel order',
                            style: TextStyle(
                                color: Colors.white
                            ),
                          )),
                    ):Container()
                  ],
                ),
              )
            ],
          ),
        ),
        splashColor: Colors.transparent,
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    ladderProvider = Provider.of<LadderProvider>(context, listen: true);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    double screenWidth = screenWidthRecognizer(context);

    return Consumer<OrderProvider>(builder: (_, state, __) {
      return state.isLoading
          ? buildOrdersLoadingWidget(context, screenWidth) //Center(child: Text("N/A"))
          : state.orders!.data!.isEmpty
              ? Center(
                  child: Text(
                    "No open orders",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return orderUI(
                      context: context,
                      orderData: state.orders!.data![index],
                      i: index + 1,
                      orderState: state,
                    );
                  },
                  itemCount: state.orders!.data!.length,
                );
    });


  }

  Widget buildOrdersLoadingWidget(BuildContext context, double screenWidth) {
    return ListView.builder(
        itemCount: 5,
        itemBuilder: (context, stockIndex) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (themeProvider.defaultTheme)
                        ?ShimmerLoadingView.loadingContainerDark(screenWidth * 0.6, 25)
                        :ShimmerLoadingView.loadingContainer(
                        screenWidth * 0.6, 25
                    ),

                    Row(
                      children: [
                        (themeProvider.defaultTheme)
                            ?ShimmerLoadingView.loadingContainerDark(60, 25)
                            :ShimmerLoadingView.loadingContainer(60, 25),

                        SizedBox(
                            width: 5
                        ),

                        (themeProvider.defaultTheme)
                            ?ShimmerLoadingView.loadingContainerDark(60, 25)
                            :ShimmerLoadingView.loadingContainer(60, 25),
                      ],
                    )




                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (themeProvider.defaultTheme)
                        ?ShimmerLoadingView.loadingContainerDark(screenWidth * 0.4, 25)
                        :ShimmerLoadingView.loadingContainer(
                        screenWidth * 0.4, 25
                    ),

                    Row(
                      children: [
                        (themeProvider.defaultTheme)
                            ?ShimmerLoadingView.loadingContainerDark(40, 25)
                            :ShimmerLoadingView.loadingContainer(40, 25),

                        SizedBox(
                            width: 5
                        ),

                        (themeProvider.defaultTheme)
                            ?ShimmerLoadingView.loadingContainerDark(60, 25)
                            :ShimmerLoadingView.loadingContainer(60, 25),
                      ],
                    )




                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (themeProvider.defaultTheme)
                        ?ShimmerLoadingView.loadingContainerDark(screenWidth * 0.3, 25)
                        :ShimmerLoadingView.loadingContainer(
                        screenWidth * 0.3, 25
                    ),

                    Row(
                      children: [
                        (themeProvider.defaultTheme)
                            ?ShimmerLoadingView.loadingContainerDark(50, 25)
                            :ShimmerLoadingView.loadingContainer(50, 25),

                        SizedBox(
                            width: 5
                        ),

                        (themeProvider.defaultTheme)
                            ?ShimmerLoadingView.loadingContainerDark(10, 25)
                            :ShimmerLoadingView.loadingContainer(10, 25),
                      ],
                    )




                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (themeProvider.defaultTheme)
                        ?ShimmerLoadingView.loadingContainerDark(screenWidth * 0.3, 25)
                        :ShimmerLoadingView.loadingContainer(
                        screenWidth * 0.3, 25
                    ),

                    Row(
                      children: [
                        (themeProvider.defaultTheme)
                            ?ShimmerLoadingView.loadingContainerDark(50, 25)
                            :ShimmerLoadingView.loadingContainer(50, 25),

                        SizedBox(
                            width: 5
                        ),

                        (themeProvider.defaultTheme)
                            ?ShimmerLoadingView.loadingContainerDark(50, 25)
                            :ShimmerLoadingView.loadingContainer(50, 25),
                      ],
                    )




                  ],
                ),
              ],
            ),
          );
        }
    );
  }
}
