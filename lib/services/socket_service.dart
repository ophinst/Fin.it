import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();

  factory SocketService() {
    return _instance;
  }

  SocketService._internal();

  IO.Socket? _socket;

  Future<void> initializeSocket() async {
    try {
      _socket = IO.io(
        'https://finit-api-ahawuso3sq-et.a.run.app',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableReconnection() // Enable reconnection
            .setReconnectionAttempts(5) // Number of reconnection attempts
            .setReconnectionDelay(5000) // Time between each reconnection attempt (in ms)
            .build(),
      );
      _connectSocket();
      print('Socket initialized');
    } catch (e) {
      print('Failed to initialize socket: $e');
      throw e; // Rethrow the exception if needed
    }
  }

  void _connectSocket() {
    _socket?.onConnect((_) => print('Socket connected'));
    _socket?.onConnectError((data) {
      print('Connection error: $data');
    });
    _socket?.onError((data) => print('Socket error: $data'));
    _socket?.onDisconnect((_) {
      print('Socket disconnected');
    });
    _socket?.onReconnect((_) => print('Socket reconnected'));
    _socket?.onReconnectAttempt((_) => print('Attempting to reconnect...'));
    _socket?.onReconnectError((data) => print('Reconnection error: $data'));
    _socket?.onReconnectFailed((_) => print('Reconnection failed'));
  }

  IO.Socket? get socket => _socket;

  void dispose() {
    _socket?.disconnect();
    _socket = null;
  }
}
