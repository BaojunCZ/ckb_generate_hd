import 'dart:typed_data';

import 'package:ckb_generate_hd/src/constant/constant.dart';
import 'package:ckb_generate_hd/src/core/hd_core.dart';
import 'package:ckb_generate_hd/src/core/hd_index_wallet.dart';
import 'package:ckb_sdk/ckb-utils/network.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:ckb_sdk/ckb_system_contract/ckb_system_contract.dart';
import 'package:ckb_sdk/ckb_system_contract/system_contract.dart';
import 'package:ckb_sdk/ckb-rpc/ckb_api_client.dart';

class CKBHDGeneration {
  HDCore _hdCore;
  final String _mnemonic;

  CKBHDGeneration._(this._mnemonic);

  factory CKBHDGeneration.fromMnemonic(Network network, String nodeUrl, String mnemonic) {
    Constant.netWork = network;
    Constant.nodeUrl = nodeUrl;
    if (!bip39.validateMnemonic(mnemonic)) throw Exception('Wrong mnemonic');
    return CKBHDGeneration._(mnemonic);
  }

  factory CKBHDGeneration.createNew(Network network, String nodeUrl) {
    Constant.netWork = network;
    Constant.nodeUrl = nodeUrl;
    String mnemonic = bip39.generateMnemonic();
    return CKBHDGeneration._(mnemonic);
  }

  String get mnemonic => _mnemonic;

  Future init() async {
    Uint8List seed = bip39.mnemonicToSeed(_mnemonic);
    _hdCore = HDCore(seed);
    SystemContract systemContract =
        await getSystemContract(CKBApiClient(Constant.nodeUrl), Constant.netWork);
    Constant.codeHash = systemContract.codeHash;
  }

  HDIndexWallet receiveByIndex(int index) => _hdCore.getReceiveWallet(index);

  HDIndexWallet changeByIndex(int index) => _hdCore.getChangeWallet(index);
}
