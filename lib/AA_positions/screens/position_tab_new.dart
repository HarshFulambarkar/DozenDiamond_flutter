import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../AB_Ladder/stateManagement/ladder_provider.dart';
import '../../Settings/stateManagement/theme_provider.dart';
import '../../ZZZZY_TradingMainPage/stateManagement/trade_main_provider.dart';
import '../../global/constants/currency_constants.dart';
import '../../global/services/num_formatting.dart';
import '../../global/widgets/custom_container.dart';
import '../../global/widgets/my_text_field.dart';
import '../../global/widgets/shimmer_loading_view.dart';
import '../models/close_position_request.dart';
import '../models/get_all_open_position_response.dart';
import '../services/positions_rest_api_service.dart';
import '../stateManagement/position_provider.dart';

class PositionTabNew extends StatefulWidget {
  final String? selectedTicker;
  const PositionTabNew({super.key, this.selectedTicker});

  @override
  State<PositionTabNew> createState() => _PositionTabNewState();
}

class _PositionTabNewState extends State<PositionTabNew> {
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
    _positionProvider!
        .fetchPositions(_currencyConstantsProvider!)
        .then((value) {})
        .catchError((err) {
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
            maxLength: 2,
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

  @override
  Widget build(BuildContext context) {
    positionProvider = Provider.of<PositionProvider>(context, listen: true);
    themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    double screenWidth = screenWidthRecognizer(context);
    return Consumer<PositionProvider>(builder: (_, state, __) {
      // Checking if loading is required
      if (state.isLoading) {
        return buildPositionLoadingWidget(context, screenWidth);
        // return Center(child: Text("N/A"));
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
            return buildPositionSectionNew(
              position: state.positions!.data![index],
              index: index,
            );
          },
          itemCount: state.positions?.data?.length ?? 0,
        );
      }
    });
  }

  Widget buildPositionSection({required Data position, required int index}) {
    int newIndex = index + 1;
    double currentValue = (position.postnTotalQuantity * position.currentPrice);
    if (_tradeMainProvider!.selectedTickerForSimulation.ticker == "Select ticker" ||
        _tradeMainProvider!.selectedTickerForSimulation.ticker == position.postnTicker) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 12, right: 12),
        child: CustomContainer(
          onTap: () {
            _positionProvider!.updatePositionBtnVisibilityAtIndex = index;
          },
          padding: 0,
          margin: EdgeInsets.zero,
          borderRadius: 10,
          backgroundColor: (themeProvider.defaultTheme)?Color(0xffdadde6):Color(0xff2c2c31),  //Color(0xff2c2c31),
          child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 12.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                          "#${newIndex}  ",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                          )
                      ),

                      Text(
                          "${position.postnTicker} (${position.postnExchange})",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                          )
                      ),
                    ],
                  ),

                  Divider(
                    color: Colors.grey,
                    thickness: 0.3,
                  ),

                  SizedBox(
                    height: 5,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Quantity: ",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0),
                                ),
                              ),
                              Text(
                                "${position.postnTotalQuantity} Units",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0),
                                ),
                              )
                            ],
                          ),

                          SizedBox(
                            height: 5,
                          ),

                          Row(
                            children: [
                              Text(
                                "Realized profit: ",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                                ),
                              ),
                              Text(
                                "${amountToInrFormat(context, (position.postnCashGain - position.postnUnsoldStockCashGain))}",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                                ),
                              )
                            ],
                          ),

                          SizedBox(
                            height: 5,
                          ),

                          Row(
                            children: [
                              Text(
                                "Avg. purch. price: ",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                                ),
                              ),
                              Text(
                                "${amountToInrFormat(context, position.postnAveragePurchasePrice)}",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                                ),
                              )
                            ],
                          ),

                          SizedBox(
                            height: 5,
                          ),

                          Row(
                            children: [
                              Text(
                                "Cash spent on \nunsold stock: ",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                                ),
                              ),
                              Text(
                                " ${amountToInrFormat(context, -position.postnUnsoldStockCashGain)}",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                                ),
                              )
                            ],
                          ),

                          SizedBox(
                            height: 5,
                          ),

                          Row(
                            children: [
                              Text(
                                "Total Cash Spent: ",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                                ),
                              ),
                              Text(
                                "${amountToInrFormat(context, -position.postnCashGain)}",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                                ),
                              )
                            ],
                          ),

                          SizedBox(
                            height: 5,
                          ),

                          Row(
                            children: [
                              Text(
                                "Cash allocated: ",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                                ),
                              ),
                              Text(
                                "${amountToInrFormat(context, position.postnCashAllocated)}",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                                ),
                              )
                            ],
                          ),

                          SizedBox(
                            height: 5,
                          ),

                          Row(
                            children: [
                              Text(
                                "Actual Brokerage: ",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                                ),
                              ),
                              Text(
                                "${amountToInrFormat(context, position.actualBrokerageCost)}",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                                ),
                              )
                            ],
                          ),

                          SizedBox(
                            height: 5,
                          ),

                          Row(
                            children: [
                              Text(
                                "Other Charges: ",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                                ),
                              ),
                              Text(
                                "${amountToInrFormat(context, position.otherBrokerageCharges)}",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                                ),
                              )
                            ],
                          ),

                          SizedBox(
                            height: 5,
                          ),

                          Row(
                            children: [
                              Text(
                                "Extra cash generated: ",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xffff9e37)
                                ),
                              ),
                              Text(
                                "${amountToInrFormat(context, position.postnExtraCashGenerated)}",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xffff9e37)
                                ),
                              )
                            ],
                          ),
                        ],
                      ),

                      Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${amountToInrFormat(context, position.currentPrice)}",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                                ),
                              ),

                              Text(
                                (Provider.of<TradeMainProvider>(context, listen: false).tradingOptions ==
                                    TradingOptions.simulationTradingWithSimulatedPrices)?"Simulated price":"Current price",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                                ),
                              ),
                            ],
                          ),

                        ],
                      )
                    ],
                  ),

                  Visibility(
                    visible: _positionProvider!.positionVisible[index],
                    child: Column(
                      children: [
                        Divider(
                          color: Colors.grey,
                          thickness: 0.3,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomContainer(
                              backgroundColor: Colors.transparent,
                              onTap: () {
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
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.red,
                                    // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              )
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget buildPositionSectionNew({required Data position, required int index}) {
    int newIndex = index + 1;
    double currentValue = (position.postnTotalQuantity * position.currentPrice);
    if (_tradeMainProvider!.selectedTickerForSimulation.ticker == "Select ticker" ||
        (_tradeMainProvider!.selectedTickerForSimulation.ticker == position.postnTicker && _tradeMainProvider!.selectedTickerForSimulation.tickerExchange == position.postnExchange)) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 12, right: 12),
        child: CustomContainer(
          onTap: () {
            _positionProvider!.updatePositionBtnVisibilityAtIndex = index;
          },
          padding: 0,
          margin: EdgeInsets.zero,
          borderRadius: 10,
          backgroundColor: (themeProvider.defaultTheme)?Color(0xffdadde6):Color(0xff2c2c31),  //Color(0xff2c2c31),
          child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 12.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                          "#${newIndex}  ",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                          )
                      ),

                      Text(
                          "${position.postnTicker} (${position.postnExchange})",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                          )
                      ),
                    ],
                  ),

                  Divider(
                    color: Colors.grey,
                    thickness: 0.3,
                  ),

                  SizedBox(
                    height: 5,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Quantity:",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: (themeProvider.defaultTheme)?Colors.green[800]:Colors.green,
                          // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                        ),
                      ),

                      Text(
                        "${position.postnTotalQuantity} Units",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: (themeProvider.defaultTheme)?Colors.green[800]:Colors.green,
                          // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                        ),
                      )
                    ],
                  ),

                  SizedBox(
                    height: 5,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        (Provider.of<TradeMainProvider>(context, listen: false).tradingOptions ==
                            TradingOptions.simulationTradingWithSimulatedPrices)?"Simulated price":"Current price",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: (themeProvider.defaultTheme)?Colors.green[800]:Colors.green,
                          // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                        ),
                      ),

                      Text(
                        "${amountToInrFormat(context, position.currentPrice)}",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: (themeProvider.defaultTheme)?Colors.green[800]:Colors.green,
                          // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                        ),
                      )
                    ],
                  ),

                  SizedBox(
                    height: 5,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Realized profit:",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: (themeProvider.defaultTheme)?Colors.green[800]:Colors.green,
                          // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                        ),
                      ),

                      Text(
                        "${amountToInrFormat(context, (position.postnCashGain - position.postnUnsoldStockCashGain))}",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: (themeProvider.defaultTheme)?Colors.green[800]:Colors.green,
                          // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                        ),
                      )
                    ],
                  ),

                  SizedBox(
                    height: 5,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Extra cash generated:",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: (themeProvider.defaultTheme)?Colors.green[800]:Colors.green,
                          // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                        ),
                      ),

                      Text(
                        "${amountToInrFormat(context, position.postnExtraCashGenerated)}",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: (themeProvider.defaultTheme)?Colors.green[800]:Colors.green,
                          // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                        ),
                      )
                    ],
                  ),

                  SizedBox(
                    height: 5,
                  ),

                  (positionProvider.isPositionsExpanded[position.postnId.toString()] == false)?Container():Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Avg. purch. price:",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: (themeProvider.defaultTheme)?Color.fromARGB(255, 226, 98, 43):Color.fromARGB(255, 222, 142, 13),
                              // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                            ),
                          ),

                          Text(
                            "${amountToInrFormat(context, position.postnAveragePurchasePrice)}",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: (themeProvider.defaultTheme)?Color.fromARGB(255, 226, 98, 43):Color.fromARGB(255, 222, 142, 13),
                              // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                            ),
                          )
                        ],
                      ),

                      SizedBox(
                        height: 5,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Cash spent on unsold stock:",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: (themeProvider.defaultTheme)?Color.fromARGB(255, 226, 98, 43):Color.fromARGB(255, 222, 142, 13),
                              // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                            ),
                          ),

                          Text(
                            "${amountToInrFormat(context, -position.postnUnsoldStockCashGain)}",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: (themeProvider.defaultTheme)?Color.fromARGB(255, 226, 98, 43):Color.fromARGB(255, 222, 142, 13),
                              // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                            ),
                          )
                        ],
                      ),

                      SizedBox(
                        height: 5,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Cash Spent:",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: (themeProvider.defaultTheme)?Color.fromARGB(255, 226, 98, 43):Color.fromARGB(255, 222, 142, 13),
                              // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                            ),
                          ),

                          Text(
                            "${amountToInrFormat(context, -position.postnCashGain)}",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: (themeProvider.defaultTheme)?Color.fromARGB(255, 226, 98, 43):Color.fromARGB(255, 222, 142, 13),
                              // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                            ),
                          )
                        ],
                      ),

                      SizedBox(
                        height: 5,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Cash allocated:",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: (themeProvider.defaultTheme)?Color.fromARGB(255, 226, 98, 43):Color.fromARGB(255, 222, 142, 13),
                              // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                            ),
                          ),

                          Text(
                            "${amountToInrFormat(context, position.postnCashAllocated)}",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: (themeProvider.defaultTheme)?Color.fromARGB(255, 226, 98, 43):Color.fromARGB(255, 222, 142, 13),
                              // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                            ),
                          )
                        ],
                      ),

                      SizedBox(
                        height: 5,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Actual Brokerage:",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: (themeProvider.defaultTheme)?Colors.indigo[800]:Colors.indigo[200],
                              // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                            ),
                          ),

                          Text(
                            "${amountToInrFormat(context, position.actualBrokerageCost)}",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: (themeProvider.defaultTheme)?Colors.indigo[800]:Colors.indigo[200],
                              // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                            ),
                          )
                        ],
                      ),

                      SizedBox(
                        height: 5,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Other Charges:",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: (themeProvider.defaultTheme)?Colors.indigo[800]:Colors.indigo[200],
                              // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                            ),
                          ),

                          Text(
                            "${amountToInrFormat(context, position.otherBrokerageCharges)}",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: (themeProvider.defaultTheme)?Colors.indigo[800]:Colors.indigo[200],
                              // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                            ),
                          )
                        ],
                      ),

                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),

                  Visibility(
                    visible: _positionProvider!.positionVisible[index],
                    child: Column(
                      children: [
                        Divider(
                          color: Colors.grey,
                          thickness: 0.3,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomContainer(
                              backgroundColor: Colors.transparent,
                              onTap: () {
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
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.red,
                                  // color: (themeProvider.defaultTheme)?Color(0xff0f0f0f):Color(0xfff0f0f0)
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              )
          ),
        ),
      );
    } else {
      return Container();
    }
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
