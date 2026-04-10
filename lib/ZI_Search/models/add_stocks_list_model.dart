class AddStockListModel {
  final String stockName;
  final String subStockDetail;
  final String currentValue;
  final String percentVariation;
  final String sectorName;
  bool isSelected;
  final bool isInProfit;

  AddStockListModel({
    required this.stockName,
    required this.subStockDetail,
    required this.percentVariation,
    required this.currentValue,
    required this.sectorName,
    this.isSelected = false,
    this.isInProfit = false,
  });
}
