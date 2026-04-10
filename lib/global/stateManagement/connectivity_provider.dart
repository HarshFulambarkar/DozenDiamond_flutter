import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityProvider extends ChangeNotifier {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];

  List<ConnectivityResult> get connectionStatus => _connectionStatus;

  set connectionStatus(List<ConnectivityResult> value) {
    _connectionStatus = value;
    notifyListeners();
  }

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  ConnectivityProvider() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    checkConnection(); // Initial check
  }


  Future<void> checkConnection() async {
    _updateConnectionStatus(await _connectivity.checkConnectivity());
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    _connectionStatus = result;
    notifyListeners();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
