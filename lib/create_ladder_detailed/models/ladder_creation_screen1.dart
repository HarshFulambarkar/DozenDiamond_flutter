import 'package:dozen_diamond/create_ladder_detailed/models/ladder_creation_tickers_response.dart';
import 'package:flutter/material.dart';

class LadderCreationScreen1 {
  String? clpTicker;
  int? clpTickerId;
  List<LadderDetails>? ladderDetails;
  int? clpStockId;
  String? clpExchange;
  String? currentPrice;
  TextEditingController? clpInitialPurchasePrice;
  Map<String, TextEditingController?> targetPriceMultiplier;
  TextEditingController? clpTargetPrice;
  TextEditingController? clpMinimumPrice;
  LadderCreationScreen1({
    required this.clpTicker,
    required this.clpTickerId,
    required this.ladderDetails,
    required this.clpStockId,
    required this.clpExchange,
    required this.clpInitialPurchasePrice,
    required this.targetPriceMultiplier,
    required this.clpTargetPrice,
    required this.clpMinimumPrice,
    this.currentPrice,
  });
}
