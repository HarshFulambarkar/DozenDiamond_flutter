class SearchRestApiRoutes {
  static const String addStockToSelectedStockList = "/selected-stock/add";
  static const String getSelectedStockList = "/selected-stock/fetch/";
  static const String deleteStockFromSelectedStockList =
      "/selected-stock/remove";
  static const String getSearchingStocksByName = "name";
  static const String getSearchingStocksByNameNew = "/stock-symbol/search";
  static const String getStockNameList = "getbsestocksnamebysector/";
  static const String getSectorWiseStockList = "ticker/sector-list";
  static const String resetCreationStockList =
      "/ladder-creation-all-stock/reset";
  static const String getBseStockNameBySector = "/getbsestocksnamebysector";
  static const String searchTicker = "ticker/search";
}
