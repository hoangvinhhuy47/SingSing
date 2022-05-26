import 'package:sing_app/utils/parse_util.dart';

class CovalentLogTransaction {
  String blockSignedAt = '';
  int blockHeight = 0;
  String txHash = '';
  int txOffset = 0;
  bool successful = false;
  String fromAddress = '';
  String? fromAddressLabel;
  String? toAddress;
  String? toAddressLabel;
  String value = '';
  String? valueQuote;
  int gasOffered = 0;
  int gasSpent = 0;
  String? gasPrice;
  String? gasQuote;
  String? gasQuoteRate;

  CovalentLogTransaction({
    required this.blockSignedAt,
    required this.blockHeight,
    required this.txHash,
    required this.txOffset,
    required this.successful,
    required this.fromAddress,
    required this.fromAddressLabel,
    required this.toAddress,
    required this.toAddressLabel,
    required this.value,
    required this.valueQuote,
    required this.gasOffered,
    required this.gasSpent,
    required this.gasPrice,
    required this.gasQuote,
    required this.gasQuoteRate,
  });

  CovalentLogTransaction.fromJson(Map<dynamic, dynamic> json) {
    blockSignedAt = json['block_signed_at'];
    blockHeight = Parse.toIntValue(json['block_height']);
    txHash = json['tx_hash'];

    txOffset = Parse.toIntValue(json['tx_offset']);
    successful = Parse.toBoolValue(json['successful']);
    fromAddress = json['from_address'];
    fromAddressLabel = json['from_address_label'];
    toAddress = json['to_address'];
    toAddressLabel = json['to_address_label'];
    value = json['value'];
    valueQuote = json['value_quote'];
    gasOffered = json['gas_offered'];
    gasSpent = json['gas_spent'];
    gasPrice = json['gas_price'];
    gasQuote = json['gas_quote'];
    gasQuoteRate = json['gas_quote_rate'];
  }

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = <String, dynamic>{};
//   data['network_id'] = chainId;
//   data['network_id'] = networkId;
//   data['symbol'] = symbol;
//   return data;
// }
}
