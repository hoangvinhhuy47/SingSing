

import 'package:sing_app/db/db_constants.dart';
import 'package:sing_app/db/db_manager.dart';

class LogTransaction {
  String walletId = '';
  String tokenContract = '';
  bool isSend = false;
  String receiveAddress = '';
  int amount = 0;
  String transactionHash = '';
  int timestamp = 0;
  String description = '';

  LogTransaction({
    required this.walletId,
    required this.tokenContract,
    required this.isSend,
    required this.receiveAddress,
    required this.amount,
    required this.transactionHash,
    required this.timestamp,
    required this.description,
  });

  LogTransaction.fromDbMap(Map<dynamic, dynamic> json) {
    walletId = json[columnWalletId];
    tokenContract = json[columnWalletId];
    isSend = false;
    receiveAddress = json[columnReceiveAddress]; //Parse.toIntValue(json['decimals']);
    amount = json[columnAmount];
    transactionHash = json[columnTransactionHash];
    timestamp = json[columnTimestamp];
    description = json[columnReceiveAddress];
  }

  // LogTransaction.fromJsonCovalent(Map<dynamic, dynamic> json) {
  //   chainId = Parse.toIntValue(json['chain_id']);
  //   name = json['name'];
  //   symbol = json['symbol'];
  //   decimals = Parse.toIntValue(json['decimals']);
  // }

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = <String, dynamic>{};
//   data['network_id'] = chainId;
//   data['network_id'] = networkId;
//   data['symbol'] = symbol;
//   return data;
// }
}
