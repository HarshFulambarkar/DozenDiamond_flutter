class FilteredHistoricalDataWithGivenInterval {
  List<double> filteredData;
  double maxHistoricalValues;
  double minHistoricalValues;
  String startingHistoricalDate;
  String endingHistoricalDate;
  Map<int, String> xAxisDateLabels;

  FilteredHistoricalDataWithGivenInterval(
      this.filteredData,
      this.maxHistoricalValues,
      this.minHistoricalValues,
      this.xAxisDateLabels,
      this.startingHistoricalDate,
      this.endingHistoricalDate);
}
