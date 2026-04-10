import 'package:dozen_diamond/AB_Ladder/models/ladder_list_model.dart';
import 'package:flutter/material.dart';

class EmptyLadderProvider extends ChangeNotifier {
  FilterOption _ladStatus = FilterOption.inactive;
  FilterOption get ladStatus => _ladStatus;
  set ladStatus(FilterOption ladStatusBunch) {
    _ladStatus = ladStatusBunch;
    notifyListeners();
  }
}
