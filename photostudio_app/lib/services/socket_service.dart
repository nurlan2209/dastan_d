import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class SocketService {
  IO.Socket? _socket;
  Function(Map<String, dynamic>)? onNotification;

  Future<void> connect() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    _socket = IO.io(
      ApiConfig.socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      if (userId != null) {
        _socket!.emit('join', userId);
      }
    });

    _socket!.on('notification', (data) {
      if (onNotification != null) {
        onNotification!(data);
      }
    });
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
  }
}
