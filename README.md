Generate CKB HD Wallet

## Usage

A simple usage example:

```dart
import 'package:ckb_generate_hd/ckb_generate_hd.dart';
import 'package:ckb_sdk/ckb-utils/network.dart';

main() async {
  final generation = CKBHDGeneration.createNew(Network.TestNet, "http://localhost:8114");
  await generation.init();
  final receive = generation.receiveByIndex(0);
  print(generation.mnemonic);
  print(receive.toJson());
}
```

## HDIndexWallet

```dart
Map<String, dynamic> toJson() => <String, dynamic>{
        'privateKey': hex.encode(privateKey),
        'publicKey': hex.encode(publicKey),
        'type': isReceive ? 'Receive' : 'Change',
        'index': index,
        'path': path,
        'lockHash': lockHash,
        'address': getAddress(Constant.netWork),
        'blake160': blake160
      };
```
