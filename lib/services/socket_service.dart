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
              // .enableAutoConnect() // Enable auto-connect
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
    _socket?.onConnectError((data) {
      print('Connect Error: $data');
      _reconnectSocket(); // Attempt to reconnect on connect error
    });
    _socket?.onDisconnect((data) {
      print('Disconnected');
      _reconnectSocket(); // Attempt to reconnect on disconnect
    });

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

  void _reconnectSocket() {
    print('Attempting to reconnect...');
    _socket?.disconnect(); // Disconnect the existing socket
    _socket?.connect(); // Attempt to reconnect
  }

  IO.Socket? get socket => _socket;

  void dispose() {
    _socket?.disconnect(); // Disconnect the socket
    _socket = null; // Set the socket instance to null
  }
}
