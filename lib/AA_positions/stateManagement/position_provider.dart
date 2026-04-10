import 'dart:convert';

import 'package:dozen_diamond/global/constants/currency_constants.dart';
import 'package:dozen_diamond/global/models/http_api_exception.dart';
import 'package:flutter/material.dart';

import '../models/get_all_open_position_response.dart';
import '../services/positions_rest_api_service.dart';

class PositionProvider extends ChangeNotifier {
  GetAllOpenPositionsResponse? _positions;
  List<bool> _positionVisible = [];
  bool _isLoading = true;

  GetAllOpenPositionsResponse? get positions => _positions;
  List<bool> get positionVisible => _positionVisible;
  bool get isLoading => _isLoading;

  List<String?> productType = [
    "MARKET",
    "LIMIT",
  ];

  Map<String, dynamic> _isPositionsExpanded = {};

  Map<String, dynamic> get isPositionsExpanded => _isPositionsExpanded;

  set isPositionsExpanded(Map<String, dynamic> value) {
    _isPositionsExpanded = value;
    notifyListeners();
  }

  String _selectedProductType = "LIMIT";

  String get selectedProductType => _selectedProductType;

  set selectedProductType(String value) {
    _selectedProductType = value;
    notifyListeners();
  }

  String _limitPrice = "null";

  String get limitPrice => _limitPrice;

  set limitPrice(String value) {
    _limitPrice = value;
    notifyListeners();
  }

  String _limitPriceTimeInMin = "null";

  String get limitPriceTimeInMin => _limitPriceTimeInMin;

  set limitPriceTimeInMin(String value) {
    _limitPriceTimeInMin = value;
    notifyListeners();
  }

  String _limitPriceErrorText = "";

  String get limitPriceErrorText => _limitPriceErrorText;

  set limitPriceErrorText(String value) {
    _limitPriceErrorText = value;
    notifyListeners();
  }

  String _limitPriceTimeInMinErrorText = "";

  String get limitPriceTimeInMinErrorText => _limitPriceTimeInMinErrorText;

  set limitPriceTimeInMinErrorText(String value) {
    _limitPriceTimeInMinErrorText = value;
    notifyListeners();
  }

  bool _showLimitPriceTextField = true;

  bool get showLimitPriceTextField => _showLimitPriceTextField;

  set showLimitPriceTextField(bool value) {
    _showLimitPriceTextField = value;
    notifyListeners();
  }

  Future<bool> fetchPositions(
      CurrencyConstants currencyConstantsProvider) async {
    try {
      GetAllOpenPositionsResponse? res = await PositionRestApiService()
          .getAllOpenPositions(currencyConstantsProvider);

      if (res?.status == true && res?.data != null) {
        _isLoading = false;
        _positions = res!;
        defaultVisibilitySOfPositionBtns = res.data!.length;
        for(int i=0;i<res.data!.length; i++) {
          isPositionsExpanded[res.data![i].postnId.toString()] = true;
        }
        notifyListeners();
        return true;
      } else {
        throw HttpApiException(errorCode: 404);
      }
    } catch (e) {
      print('inside error of fetch position');
      print(e);
      throw e;
    }
  }

  set defaultVisibilitySOfPositionBtns(int i) {
    _positionVisible.clear();
    for (int j = 0; j < i; j++) {
      _positionVisible.add(false);
    }
  }

  set updatePositionBtnVisibilityAtIndex(int i) {
    _positionVisible[i] = !_positionVisible[i];
    for (int j = 0; j < _positionVisible.length; j++) {
      if (i != j) {
        _positionVisible[j] = false;
      }
    }
    notifyListeners();
  }

  set disableVisibilityPositionBtnAtIndex(int i) {
    _positionVisible[i] = false;
    notifyListeners();
  }
}
