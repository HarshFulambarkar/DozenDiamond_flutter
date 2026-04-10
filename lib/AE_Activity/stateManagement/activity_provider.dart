import 'package:dozen_diamond/AE_Activity/models/get_new_user_activity_response.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:flutter/material.dart';

import '../services/activity_rest_api_service.dart';

class ActivityProvider extends ChangeNotifier {
  GetNewUserActivityResponse? _activities;
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  GetNewUserActivityResponse? get activities => _activities;

  List<String?> sortType = [
    "Date",
    "Stocks",
    "Activity",
    "Unit",
    "Price",
    "NET P/L"
  ];

  String _selectedSortType = "Date";

  String get selectedSortType => _selectedSortType;

  set selectedSortType(String value) {
    _selectedSortType = value;
    notifyListeners();
  }

  bool _isAscending = false;

  bool get isAscending => _isAscending;

  set isAscending(bool value) {
    _isAscending = value;
    notifyListeners();
  }

  List<String?> levelType = [
    "LEVEL1",
    "LEVEL2",
    "LEVEL3",
    "LEVEL4",
    "LEVEL5"
  ];

  String _selectedLevelType = "LEVEL1";

  String get selectedLevelType => _selectedLevelType;

  set selectedLevelType(String value) {
    _selectedLevelType = value;
    notifyListeners();
  }

  String? _selectedLadder = null;

  String? get selectedLadder => _selectedLadder;

  set selectedLadder(String? value) {
    _selectedLadder = value;
    notifyListeners();
  }

  Future<bool> fetchActivities() async {
    print("inside fetchActivities");
    try {
      String sortAs = "DESC";
      String sortType = "Date";
      if (isAscending) {
        sortAs = "ASC";
      } else {
        sortAs = "DESC";
      }

      if (selectedSortType == "NET P/L") {
        sortType = "NATPorL";
      } else {
        sortType = selectedSortType;
      }

      GetNewUserActivityResponse? res =
          await ActivityRestApiService().getNewUserActivity(sortType, sortAs, selectedLevelType);
      if (res?.status == true && res?.data != null) {
        _isLoading = false;
        _activities = res;
        notifyListeners();
        return true;
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      throw e;
    }
  }

  bool changeExpanded(int index) {
    if (activities!.data![index].isExpanded!) {
      activities!.data![index].isExpanded = false;
    } else {
      activities!.data![index].isExpanded = true;
    }

    return activities!.data![index].isExpanded!;
  }
}
