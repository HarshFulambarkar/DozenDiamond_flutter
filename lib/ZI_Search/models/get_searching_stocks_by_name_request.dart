class GetSearchingStocksByNameRequest {
  final String stockName;
  final int pageNumber;
  final String sectorName;

  GetSearchingStocksByNameRequest(
      {required this.stockName, required this.pageNumber, required this.sectorName});
}
