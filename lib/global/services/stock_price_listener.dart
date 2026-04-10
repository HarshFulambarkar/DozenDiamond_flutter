import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';

class StockPriceListener extends ChangeNotifier {
  IO.Socket? _socket;
  IO.Socket? get socket => _socket;

  set updateSocketConnection(IO.Socket? newSocket) {
    _socket = newSocket;
  }
}
