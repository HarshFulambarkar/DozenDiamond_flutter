import 'package:dozen_diamond/socket_manager/model/ddstock_socket_data_response.dart';

import '../services/global_rest_api_service.dart';

class Testing {

  Future<void> testWatchListData(DdStock watchlistData) async {
    if(double.tryParse(watchlistData.upDownPercentage ?? "0")!.isInfinite) {
      Map<String, dynamic> request = {
        "title": "Watchlist",
        "message": "Infinity Value in watchlist",
      };

      final res = await GlobalRestApiService().sendTestingMail(request);
    }

    if(double.tryParse(watchlistData.upDownPercentage ?? "0")!.isNaN) {

      Map<String, dynamic> request = {
        "title": "Watchlist",
        "message": "NaN Value in watchlist",
      };

      final res = await GlobalRestApiService().sendTestingMail(request);

    }

  }

}