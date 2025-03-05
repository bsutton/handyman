import 'dart:convert';
import 'dart:io';

import 'config.dart';
import 'logger.dart';

/// A UDP server that collects app start data from hmb.
Future<void> startCollector() async {
  // Define the port to listen on.
  const port = 4040;

  // Bind the socket to any available IPv4 address on the specified port.
  final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
  qlog('UDP server is running on ${socket.address.address}:$port');

  // Define the file where messages will be appended.
  final file = File(Config.hmbStartsYaml);

  // Listen for incoming UDP packets.
  socket.listen((event) async {
    if (event == RawSocketEvent.read) {
      // Try to receive a datagram.
      final dg = socket.receive();
      if (dg != null) {
        // Decode the incoming packet's data.
        final message = utf8.decode(dg.data);

        if (message.contains('business name:')) {
          qlog('Received packet:\n$message');

          try {
            // Append the message to the YAML file followed by a newline.
            await file.writeAsString('$message\n', mode: FileMode.append);
            qlog('Message appended to ${Config.hmbStartsYaml}');
          } catch (error) {
            qlog('Error appending to file: $error');
          }
        }
      }
    }
  });
}
