import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';

class SocketManager {
  late IO.Socket _socket;
  static SocketManager? _instance;

  SocketManager._internal();

  factory SocketManager() {
    if (_instance == null) {
      _instance = SocketManager._internal();
    }
    return _instance!;
  }

  IO.Socket get socket => _socket;

  Future<void> initializeSocket() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("reg_id");

    // _socket = IO.io(
    //   'wss://uatdd.virtualglobetechnology.com?userId=$userId',
    //   <String, dynamic>{
    //     'transports': ['websocket'],
    //     'extraHeaders': {
    //       'access_token':
    //           '5+5`3LaZLjE[>nBq10tLcZ-{?/HlG]:uJZZ[A@LJZ/q+BcG^bBMtA(POv!}l2IohUBB/,%tNMep=B5]6GMLi:uJ}Bpm89`/FRlPG)Q8;K)~`:gI+I?'
    //     },
    //     'autoConnect': true,
    //   },
    // );
    _socket.on('reconnect', (data) {
      print('Reconnect');
      socket.emit(
        'tick',
      );
    });
    _socket.onReconnect((data) {
      print('On Reconnect');
      socket.emit(
        'tick',
      );
    });
    _socket.onReconnectAttempt((data) {
      print('On Reconnect Attempt');
      socket.emit(
        'tick',
      );
    });
    // _socket.onReconnecting((data) {
    //   print('On Reconnecting');
    // });
    _socket.emit(
      'tick',
    );
  }

  void closeSocket() {
    _socket.disconnect();
  }
}
