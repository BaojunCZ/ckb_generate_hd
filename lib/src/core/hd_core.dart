import 'dart:typed_data';

import 'package:ckb_generate_hd/src/core/coin.dart';
import 'package:ckb_generate_hd/src/core/hd_index_wallet.dart';

class HDCore {
  Coin _coin;

  HDCore(Uint8List privateKey) {
    _coin = Coin(privateKey);
  }

  HDIndexWallet getReceiveWallet(int index) {
    return HDIndexWallet(_coin.getReceivePrivateKey(index), true, index);
  }

  HDIndexWallet getChangeWallet(int index) {
    return HDIndexWallet(_coin.getChangePrivateKey(index), false, index);
  }
}
