import 'dart:typed_data';

import 'package:ckb_generate_hd/src/constant/constant.dart';
import 'package:ckb_generate_hd/src/core/coin.dart';
import 'package:ckb_generate_hd/src/core/credential.dart';
import 'package:ckb_sdk/ckb-types/item/script.dart';
import 'package:ckb_sdk/ckb-utils/crypto/crypto.dart' as crypto;
import 'package:ckb_sdk/ckb-utils/network.dart';
import 'package:ckb_sdk/ckb-utils/number.dart';
import 'package:ckb_sdk/ckb_address/ckb_address.dart';
import 'package:convert/convert.dart';

class HDIndexWallet {
  final Uint8List privateKey;
  Uint8List _publicKey;
  final bool isReceive;
  final int index;
  String _lockHash;
  String _address;
  String _blake160;

  HDIndexWallet(this.privateKey, this.isReceive, this.index);

  Uint8List get publicKey {
    if (_publicKey == null) _publicKey = Credential.fromPrivateKeyBytes(privateKey).publicKey;
    return _publicKey;
  }

  String getAddress(Network network) {
    if (_address == null) _address = CKBAddress(network).generate(bytesToHex(publicKey));
    return _address;
  }

  String get path => Coin.getPath(isReceive, index);

  String get blake160 {
    if (_blake160 == null) _blake160 = crypto.blake160(bytesToHex(publicKey));
    return _blake160;
  }

  Script get lockScript {
    Script script = Script(Constant.codeHash, [hexAdd0x(blake160)]);
    return script;
  }

  String get lockHash {
    if (_lockHash == null) _lockHash = lockScript.scriptHash;
    return _lockHash;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'privateKey': hex.encode(privateKey),
        'publicKey': hex.encode(publicKey),
        'type': isReceive ? 'Receive' : 'Change',
        'index': index,
        'lockHash': lockHash,
        'address': getAddress(Constant.netWork),
        'blake160': blake160
      };
}
