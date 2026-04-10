import 'package:flutter/material.dart';

import 'ladder_creation_tickers_response.dart';

class LadderCreationScreen1 {
  String? clpTicker;
  int? clpTickerId;
  List<LadderDetails>? ladderDetails;
  int? clpStockId;
  String? clpExchange;
  TextEditingController? clpInitialPurchasePrice;
  TextEditingController? targetPriceMultiplier;
  TextEditingController? clpTargetPrice;
  TextEditingController? clpMinimumPrice;
  LadderCreationScreen1({
    required this.clpTicker,
    required this.clpTickerId,
    required this.ladderDetails,
    required this.clpStockId,
    required this.clpInitialPurchasePrice,
    required this.targetPriceMultiplier,
    required this.clpTargetPrice,
    required this.clpMinimumPrice,
  });
}
