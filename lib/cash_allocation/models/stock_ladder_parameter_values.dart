class StockLadderParameterValues {
  int? clpId;
  int? clpUserId;
  int? clpStockId;
  bool? isLadderCreated;
  String? clpTargetPrice;
  String? clpMinimumPrice;
  String? clpInitialPurchasePrice;
  int? clpDefaultBuySellQuantity;
  int? clpInitialBuyQuantity;
  String? clpCashAllocated;
  String? clpStockName;

  StockLadderParameterValues(
      {this.clpId,
      this.clpUserId,
      this.clpStockId,
      this.isLadderCreated,
      this.clpTargetPrice,
      this.clpMinimumPrice,
      this.clpInitialPurchasePrice,
      this.clpDefaultBuySellQuantity,
      this.clpInitialBuyQuantity,
      this.clpCashAllocated,
      this.clpStockName});
}
