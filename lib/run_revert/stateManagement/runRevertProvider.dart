import 'package:dozen_diamond/run_revert/model/fetch_run_id_response.dart';
import 'package:dozen_diamond/run_revert/model/revert_run_id_request.dart';
import 'package:dozen_diamond/run_revert/service/runRevertService.dart';
import 'package:flutter/material.dart';

class RunRevertProvider extends ChangeNotifier {
  int _selectedRunId = -1;

  int get selectedRunId => _selectedRunId;

  set selectedRunId(int value) {
    _selectedRunId = value;
    notifyListeners();
  }

  List<RecentRun> _revertRunData = [];

  List<RecentRun> get revertRunData => _revertRunData;

  set revertRunData(List<RecentRun> value) {
    _revertRunData = value;
    notifyListeners();
  }

  FetchRunIdResponse _fetchRunIdResponse = FetchRunIdResponse();

  FetchRunIdResponse get fetchRunIdResponse => _fetchRunIdResponse;

  set fetchRunIdResponse(FetchRunIdResponse value) {
    _fetchRunIdResponse = value;
    notifyListeners();
  }

  int currentPage = 1;
  int limit = 10;
  int totalPages = 1;
  bool isLoading = false;

  Future<void> getAllRunOfAUser({int? page}) async {
    if (isLoading) return;

    try {
      isLoading = true;
      notifyListeners();

      final response = await RunRevertService().getAllRunOfAUser(
        page: page ?? currentPage,
        limit: limit,
      );

      _fetchRunIdResponse = response;

      // Server-driven pagination
      currentPage = response.data?.page ?? 1;
      totalPages = response.data?.totalPages ?? 1;

      revertRunData = response.data?.recentRun ?? [];
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> revertRunIdOfAUser() async {
    try {
      await RunRevertService()
          .revertTheRunIdOfAUser(RevertRunIdRequest(runId: selectedRunId));
    } catch (e) {
      throw e;
    }
  }
}
