import 'dart:async';
import 'dart:convert';
import 'package:multicast_dns/multicast_dns.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:uuid/uuid.dart';

class MultiplayerSession {
  final String sessionId;
  final String hostIp;
  final List<String> players;
  final bool isHost;
  WebSocketChannel? channel;

  MultiplayerSession({
    required this.sessionId,
    required this.hostIp,
    required this.players,
    required this.isHost,
    this.channel,
  });
}

class Networking {
  static Future<String> getLocalIp() async {
    final info = NetworkInfo();
    return await info.getWifiIP() ?? '127.0.0.1';
  }

  static Future<String> createSession() async {
    // Generate a unique session ID
    return const Uuid().v4();
  }

  static Future<void> advertiseSession(String sessionId, String hostIp) async {
    // Use multicast_dns to advertise session
    final MDnsClient client = MDnsClient();
    await client.start();
    // This is a placeholder; actual implementation would use PTR/SRV records
    // and periodic broadcasting
    // ...
    client.stop();
  }

  static Future<List<String>> discoverSessions() async {
    // Use multicast_dns to discover sessions
    final MDnsClient client = MDnsClient();
    await client.start();
    // This is a placeholder; actual implementation would query for PTR/SRV records
    // ...
    client.stop();
    return [];
  }

  static WebSocketChannel connectToHost(String hostIp, String sessionId) {
    // Connect to host's WebSocket server
    final uri = Uri.parse('ws://$hostIp:8080/$sessionId');
    return WebSocketChannel.connect(uri);
  }

  static StreamSubscription listen(
    WebSocketChannel channel,
    void Function(dynamic) onData,
  ) {
    return channel.stream.listen(onData);
  }

  static void send(WebSocketChannel channel, dynamic data) {
    channel.sink.add(jsonEncode(data));
  }

  static void close(WebSocketChannel channel) {
    channel.sink.close(status.goingAway);
  }
}
