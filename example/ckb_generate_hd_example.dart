import 'package:ckb_generate_hd/ckb_generate_hd.dart';
import 'package:ckb_sdk/ckb-utils/network.dart';

main() async {
  final generation = CKBHDGeneration.createNew(Network.TestNet, "http://localhost:8114");
  await generation.init();
  final receive = generation.receiveByIndex(0);
  print(generation.mnemonic);
  print(receive.toJson());
}
