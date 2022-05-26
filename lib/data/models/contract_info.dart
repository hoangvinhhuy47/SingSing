import 'package:sing_app/utils/parse_util.dart';

class ContractInfo {
  int chainId = 0;
  String name = '';
  String symbol = '';
  int decimals = 0;

  ContractInfo({
    required this.chainId,
    required this.name,
    required this.symbol,
    required this.decimals,
  });

  ContractInfo.fromJson(Map<dynamic, dynamic> json) {
    chainId = Parse.toIntValue(json['chain_id']);
    name = json['name'];
    symbol = json['symbol'];
    decimals = Parse.toIntValue(json['decimals']);
  }

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = <String, dynamic>{};
//   data['network_id'] = chainId;
//   data['network_id'] = networkId;
//   data['symbol'] = symbol;
//   return data;
// }
}
