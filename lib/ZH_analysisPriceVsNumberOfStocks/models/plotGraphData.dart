class PlotGraphData {
  List<Orders>? orders;

  PlotGraphData({this.orders});
}

class Orders {
  double? executionPrice;
  int? totalUnits;
  double? value;
  String? tradeType;

  Orders({this.executionPrice, this.totalUnits, this.value, this.tradeType});
}
