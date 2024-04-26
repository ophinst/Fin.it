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
      _socket = IO.io('https://finit-api-ahawuso3sq-et.a.run.app',
          IO.OptionBuilder()
              .setTransports(['websocket'])
              .enableAutoConnect() // Enable auto-connect
              .enableForceNew() // Force to establish a new connection
              .build());
      _connectSocket();
      print('Socket connected');
    } catch (e) {
      print('Failed to connect to socket: $e');
      throw e; // Rethrow the exception if needed
    }
  }

  void _connectSocket() {
    _socket?.onConnect((data) => print('Connected'));
    _socket?.onConnectError((data) => print('Connect Error: $data'));
    _socket?.onDisconnect((data) => print('Disconnected'));

    // Implement reconnection logic
    _socket?.onReconnecting((data) {
      print('Reconnecting...');
      // Add your custom reconnection logic here, if needed
    });

    _socket?.onReconnectFailed((data) {
      print('Reconnection failed.');
      // Add your custom logic for failed reconnection here, if needed
    });
  }

  IO.Socket? get socket => _socket;
}
