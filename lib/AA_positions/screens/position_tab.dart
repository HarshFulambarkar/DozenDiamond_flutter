import 'dart:convert';

import 'package:dozen_diamond/AA_positions/stateManagement/position_provider.dart';
import 'package:dozen_diamond/AB_Ladder/stateManagement/ladder_provider.dart';
import 'package:dozen_diamond/ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../AA_positions/models/close_position_request.dart';
import 'package:flutter/material.dart';

import '../../Settings/stateManagement/theme_provider.dart';
import '../../global/functions/screenWidthRecoginzer.dart';
import '../../global/services/num_formatting.dart';
import '../../global/widgets/custom_container.dart';
import '../../global/widgets/my_text_field.dart';
import '../../global/widgets/shimmer_loading_view.dart';
import '../models/get_all_open_position_response.dart';
import '../services/positions_rest_api_service.dart';

class PositionsTab extends StatefulWidget {
  final String? selectedTicker;
  const PositionsTab({super.key, this.selectedTicker});

  @override
  State<PositionsTab> createState() => _PositionsTabState();
}

class _PositionsTabState extends State<PositionsTab> {
  List<bool> activePositionVisible = [];
  bool isError = false;
  GetAllOpenPositionsResponse? getAllPositionResponse;
  PositionProvider? _positionProvider;
  TradeMainProvider? _tradeMainProvider;
  ClosePositionRequest? closePositionReq;
  LadderProvider? _ladderProvider;
  CurrencyConstants? _currencyConstantsProvider;
  String? stockName;
  late ThemeProvider themeProvider;

  late PositionProvider positionProvider;

  @override
  void initState() {
    super.initState();
    _positionProvider = Provider.of(context, listen: false);
    _tradeMainProvider = Provider.of(context, listen: false);
    _ladderProvider = Provider.of(context, listen: false);
    _currencyConstantsProvider = Provider.of(context, listen: false);
    getPosition();
  }

  void getPosition() {
    print("inside getPosition");
    _positionProvider!
        .fetchPositions(_currencyConstantsProvider!)
        .then((value) {
          print("inside then");
    })
        .catchError((err) {
          print("inside catch error");
      print(err);
    });
  }

  void closePositionRequest(ClosePositionRequest requst) async {
    await PositionRestApiService().closePosition(requst).then((res) {
      if (res.status!) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("position closed successfully"),
            ),
          );
        }
      }
    }).catchError((err) {
      print(err);
    });
    _positionProvider!.fetchPositions(_currencyConstantsProvider!);
  }

  Future<void> closePositionDialog(String? positionId, int? quantity) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setStateSB) {
            return AlertDialog(
              title: Text(
                'Close position',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text('Select Product type'),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // buildClosePositionDropDown(context, setStateSB),

                  Text('Enter Minimum Limit Price'),

                  SizedBox(
                    height: 5,
                  ),
                  (positionProvider.showLimitPriceTextField)
                      ? buildClosePositionPriceTextField(context)
                      : Container(),

                  SizedBox(
                    height: 10,
                  ),

                  Text('Enter Time in Min'),

                  SizedBox(
                    height: 5,
                  ),
                  buildClosePositionTimeInMinTextField(context),
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
                            ClosePositionRequest closePositionReq;
                            // stockName = stock;

                            if (positionProvider.selectedProductType == "LIMIT" && (positionProvider.limitPrice == 'null' || positionProvider.limitPriceTimeInMin == 'null')) {

                              if(positionProvider.limitPrice == 'null') {
                                positionProvider.limitPriceErrorText = "Please enter min limit price";
                              }

                              if(positionProvider.limitPriceTimeInMin == 'null') {
                                positionProvider.limitPriceTimeInMinErrorText = "Please enter time in min";
                              }


                            } else {
                              if (positionProvider.selectedProductType ==
                                  "LIMIT") {
                                closePositionReq = ClosePositionRequest(
                                    postnId: int.parse(positionId ?? "0"),
                                    productType: positionProvider.selectedProductType,
                                    minLimitPrice: double.parse(positionProvider.limitPrice),
                                    timeInMin: int.parse(positionProvider.limitPriceTimeInMin)

                                );
                              } else {
                                closePositionReq = ClosePositionRequest(
                                  postnId: int.parse(positionId ?? "0"),
                                  productType:
                                      positionProvider.selectedProductType,
                                  minLimitPrice: null,
                                );
                              }
                              Navigator.pop(context);
                              closePositionRequest(closePositionReq);
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

  Widget buildClosePositionPriceTextField(BuildContext context) {
    return Column(
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
            focusedBorderColor: ((positionProvider.limitPriceErrorText != ""))
                ? Color(0xffd41f1f)
                : Color(0xff5cbbff),
            counterText: "",
            textInputFormatters: [
              FilteringTextInputFormatter.digitsOnly

              // FilteringTextInputFormatter.allow(
              //   RegExp(r'^[0-9,\.]+$'),
              // ),
            ],
            borderRadius: 8,

            labelText: '',
            onChanged: (value) {
              print(value);

              print(value);

              if (value.isEmpty) {
                positionProvider.limitPrice = 'null';
              } else {
                positionProvider.limitPrice = value;
              }
            },
          ),
        ),

        // MyTextField(
        //   textInputFormatters: <TextInputFormatter>[
        //     FilteringTextInputFormatter.digitsOnly
        //   ],
        //   borderRadius: 5,
        //
        //   currencyFormat: false,
        //   isFilled: true,
        //   elevation: 0,
        //   isLabelEnabled: false,
        //   borderWidth: 1,
        //   fillColor: Colors.transparent,
        //   contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
        //
        //   onChanged: (value) {
        //     print(value);
        //
        //     if (value.isEmpty) {
        //       positionProvider.limitPrice = 'null';
        //     } else {
        //       positionProvider.limitPrice = value;
        //     }
        //   },
        //   borderColor: Colors.white,
        //   labelText: "Enter Price",
        //   hintText: "Enter Price",
        //   maxLength: 9,
        //   counterText: "",
        //
        //   overrideHintText: true,
        //
        //   focusedBorderColor: Colors.white,
        //   isPasswordField: false,
        //
        //   isEnabled: true,
        //   // showLeadingWidget: true,
        //
        //   keyboardType: TextInputType.number,
        //
        //   validator: (value) {},
        // ),
        (positionProvider.limitPriceErrorText == "")
            ? Container()
            : Text(positionProvider.limitPriceErrorText,
                style: TextStyle(color: Colors.red))
      ],
    );
  }

  Widget buildClosePositionTimeInMinTextField(BuildContext context) {
    return Column(
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
            maxLength: 4,
            elevation: 0,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
            // textStyle: (themeProvider.defaultTheme)
            //     ? TextStyle(color: Colors.black)
            //     : kBodyText,
            // borderColor: Color(0xff2c2c31),
            margin: EdgeInsets.zero,
            focusedBorderColor: ((positionProvider.limitPriceTimeInMinErrorText != ""))
                ? Color(0xffd41f1f)
                : Color(0xff5cbbff),
            counterText: "",
            textInputFormatters: [
              FilteringTextInputFormatter.digitsOnly

              // FilteringTextInputFormatter.allow(
              //   RegExp(r'^[0-9,\.]+$'),
              // ),
            ],
            borderRadius: 8,

            labelText: '',
            onChanged: (value) {
              print(value);

              print(value);

              if (value.isEmpty) {
                positionProvider.limitPriceTimeInMin = 'null';
              } else {
                positionProvider.limitPriceTimeInMin = value;
              }
            },
          ),
        ),

        // MyTextField(
        //   textInputFormatters: <TextInputFormatter>[
        //     FilteringTextInputFormatter.digitsOnly
        //   ],
        //   borderRadius: 5,
        //
        //   currencyFormat: false,
        //   isFilled: true,
        //   elevation: 0,
        //   isLabelEnabled: false,
        //   borderWidth: 1,
        //   fillColor: Colors.transparent,
        //   contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
        //
        //   onChanged: (value) {
        //     print(value);
        //
        //     if (value.isEmpty) {
        //       positionProvider.limitPrice = 'null';
        //     } else {
        //       positionProvider.limitPrice = value;
        //     }
        //   },
        //   borderColor: Colors.white,
        //   labelText: "Enter Price",
        //   hintText: "Enter Price",
        //   maxLength: 9,
        //   counterText: "",
        //
        //   overrideHintText: true,
        //
        //   focusedBorderColor: Colors.white,
        //   isPasswordField: false,
        //
        //   isEnabled: true,
        //   // showLeadingWidget: true,
        //
        //   keyboardType: TextInputType.number,
        //
        //   validator: (value) {},
        // ),
        (positionProvider.limitPriceTimeInMinErrorText == "")
            ? Container()
            : Text(positionProvider.limitPriceTimeInMinErrorText,
            style: TextStyle(color: Colors.red))
      ],
    );
  }

  Widget buildClosePositionDropDown(BuildContext context, setStateSB) {
    return CustomContainer(
      borderColor: Colors.white,
      borderWidth: 1,
      backgroundColor: Colors.transparent,
      height: 40,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8.0),
        child: DropdownButtonHideUnderline(
            child: DropdownButton<String?>(
          onChanged: (String? value) {
            // tradeMainState.updateSelectedTickerForSimulation =
            //     value;
            positionProvider.selectedProductType = value!;

            print(positionProvider.selectedProductType);

            if (positionProvider.selectedProductType == "MARKET") {
              positionProvider.limitPrice = 'null';
            }

            if (positionProvider.selectedProductType == "LIMIT") {
              positionProvider.showLimitPriceTextField = true;
            } else {
              positionProvider.showLimitPriceTextField = false;
            }
            setStateSB(() {});
          },
          dropdownColor: Colors.black,
          value: positionProvider.selectedProductType,
          items: positionProvider.productType
              .map((sortType) => DropdownMenuItem<String>(
                    child: Text(sortType!),
                    value: sortType,
                  ))
              .toList(),
        )),
      ),
    );
  }

  Widget positionUI({required Data position, required int index}) {
    int newIndex = index + 1;
    double currentValue = (position.postnTotalQuantity * position.currentPrice);

    print("inside positionUI");
    print(_tradeMainProvider!.selectedTickerForSimulation.ticker);
    print(position.postnTicker);
    print(jsonEncode(position));
    if (_tradeMainProvider!.selectedTickerForSimulation.ticker ==
            "Select ticker" ||
        _tradeMainProvider!.selectedTickerForSimulation.ticker ==
            position.postnTicker) {
      return InkWell(
        onTap: () {
          _positionProvider!.updatePositionBtnVisibilityAtIndex = index;
        },
        child: Container(
          padding:
              const EdgeInsets.only(left: 0, right: 0, bottom: 10, top: 10),
          margin:
              const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: Colors.white54,
              ),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text("$newIndex"),
                  const SizedBox(width: 5),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${position.postnTicker} (${position.postnExchange})",
                              style: TextStyle(
                                fontSize: 16,
                                color: (themeProvider.defaultTheme)
                                    ? Colors.black
                                    : Colors.white,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Quantity: ${position.postnTotalQuantity} Units",
                          style: TextStyle(
                            fontSize: 16,
                            // color: Colors.awhite,
                            color: (themeProvider.defaultTheme)
                                ? Colors.black
                                : Colors.yellow[200],
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Realized profit:",
                              ),
                              TextSpan(
                                text:
                                    " ${amountToInrFormat(context, (position.postnCashGain - position.postnUnsoldStockCashGain))}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.green,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Text(
                          "Avg. purch. price: ${amountToInrFormat(context, position.postnAveragePurchasePrice)}",
                          style: TextStyle(
                            fontSize: 16,
                            // color: Colors.white,
                            color: (themeProvider.defaultTheme)
                                ? Colors.black
                                : Colors.yellow[200],
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          "Cash spent on unsold stock: ${amountToInrFormat(context, -position.postnUnsoldStockCashGain)}",
                          style: TextStyle(
                            fontSize: 16,
                            // color: Colors.white,
                            color: (themeProvider.defaultTheme)
                                ? Colors.black
                                : Colors.yellow[200],
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          "Total Cash Spent: ${amountToInrFormat(context, -position.postnCashGain)}",
                          // "Cash spent: ${amountToInrFormat(context, -position.postnUnsoldStockCashGain)}",
                          style: TextStyle(
                            fontSize: 16,
                            // color: Colors.white,
                            color: (themeProvider.defaultTheme)
                                ? Colors.black
                                : Colors.yellow[200],
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          "Cash allocated: ${amountToInrFormat(context, position.postnCashAllocated)}",
                          style: TextStyle(
                            fontSize: 16,
                            // color: Colors.white,
                            color: (themeProvider.defaultTheme)
                                ? Colors.black
                                : Colors.yellow[200],
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          "Actual Brokerage: ${amountToInrFormat(context, position.actualBrokerageCost)}",
                          style: TextStyle(
                            fontSize: 16,
                            // color: Colors.white,
                            color: (themeProvider.defaultTheme)
                                ? Colors.black
                                : Colors.yellow[200],
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          "Other Charges: ${amountToInrFormat(context, position.otherBrokerageCharges)}",
                          style: TextStyle(
                            fontSize: 16,
                            // color: Colors.white,
                            color: (themeProvider.defaultTheme)
                                ? Colors.black
                                : Colors.yellow[200],
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          "Extra cash generated: ${amountToInrFormat(context, position.postnExtraCashGenerated)}",
                          style: TextStyle(
                            fontSize: 16,
                            // color: Colors.white,
                            color: (themeProvider.defaultTheme)
                                ? Colors.black
                                : Colors.indigo[200],
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(
                        left: 0,
                        bottom: 5,
                        top: 10,
                      ),
                      child:
                          Provider.of<TradeMainProvider>(context, listen: false)
                                      .tradingOptions ==
                                  TradingOptions
                                      .simulationTradingWithSimulatedPrices
                              ? Text(
                                  "${amountToInrFormat(context, position.currentPrice)}\nSimulated price",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.green,
                                  ),
                                  textAlign: TextAlign.end,
                                )
                              : Text(
                                  "${amountToInrFormat(context, position.currentPrice)}\nCurrent price",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.green,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                    ),
                  ),
                ],
              ),
              Visibility(
                  visible: _positionProvider!.positionVisible[index],
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (position.noFollowup == false) {
                              _positionProvider!
                                  .updatePositionBtnVisibilityAtIndex = index;
                              // Fluttertoast.showToast(
                              //     msg: "This feature will unlock soon");
                              // ClosePositionRequest closePositionReq =
                              // ClosePositionRequest(
                              //     postnId: position.postnId.toString(),
                              //     productType: position.p,
                              //     limitPrice: position.posStockName);
                              closePositionDialog(
                                position.postnId.toString(),
                                position.postnTotalQuantity,
                              );
                            } else {
                              position.noFollowup = false;
                              setState(() {});
                            }
                          },
                          child: Text(
                            (position.noFollowup == false)
                                ? 'Close position'
                                : 'Cancel close position',
                            style: TextStyle(color: Colors.white),
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
                            _positionProvider!
                                .disableVisibilityPositionBtnAtIndex = index;
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.blue),
                          ),
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(
                            color: Colors.blue,
                          )),
                        ),
                      ),
                    ],
                  )),
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
    positionProvider = Provider.of<PositionProvider>(context, listen: true);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    double screenWidth = screenWidthRecognizer(context);

    return Consumer<PositionProvider>(builder: (_, state, __) {
      // Checking if loading is required
      if (state.isLoading) {
        return buildPositionLoadingWidget(context, screenWidth); // Center(child: Text("N/A"));
      } else {
        // If not loading, display positions or "No positions" message
        return state.positions!.data!.isEmpty
            ? Center(
                child: Text(
                  "No positions",
                  style: TextStyle(fontSize: 18),
                ),
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  return positionUI(
                    position: state.positions!.data![index],
                    index: index,
                  );
                },
                itemCount: state.positions?.data?.length ?? 0,
              );
      }
    });
  }

  Widget buildPositionLoadingWidget(BuildContext context, double screenWidth) {
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
