import 'dart:isolate';
import 'dart:typed_data';
import 'package:bip39/bip39.dart' as bip39;

Future<Uint8List> mnemonicToSeed(String mnemonic) async {
  ReceivePort receivePort = ReceivePort();
  Isolate isolate = await Isolate.spawn(_mnemonicToSeed, receivePort.sendPort);
  SendPort sendPort = await receivePort.first;
  Uint8List seed = await _sendReceive(mnemonic, sendPort);
  if (isolate != null) {
    isolate.kill(priority: Isolate.immediate);
    isolate = null;
  }
  return seed;
}

_mnemonicToSeed(SendPort sendPort) async {
  ReceivePort port = ReceivePort();
  sendPort.send(port.sendPort);
  await for (var msg in port) {
    String mnemonic = msg[0];
    SendPort replyTo = msg[1];
    Uint8List seed = bip39.mnemonicToSeed(mnemonic);
    replyTo.send(seed);
  }
}

Future _sendReceive(String mnemonic, SendPort port) {
  ReceivePort response = ReceivePort();
  port.send([mnemonic, response.sendPort]);
  return response.first;
}
