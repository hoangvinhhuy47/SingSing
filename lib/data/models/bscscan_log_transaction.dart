import 'package:sing_app/utils/date_util.dart';
import 'package:sing_app/utils/logger_util.dart';
import 'package:sing_app/utils/parse_util.dart';

class BscScanLogTransaction {
  String? blockNumber;
  String? timeStamp;
  String? hash;
  String? nonce;
  String? blockHash;
  String? transactionIndex;
  String? from;
  String? to;
  String? value;
  String? gas;
  String? gasPrice;
  String? isError;
  String? txReceiptStatus;
  String? input;
  String? contractAddress;
  String? cumulativeGasUsed;
  String? gasUsed;
  String? confirmations;

  String? date;
  String? sortDate;

  BscScanLogTransaction({
    this.blockNumber,
    this.timeStamp,
    this.hash,
    this.nonce,
    this.blockHash,
    this.transactionIndex,
    this.from,
    this.to,
    this.value,
    this.gas,
    this.gasPrice,
    this.isError,
    this.txReceiptStatus,
    this.input,
    this.contractAddress,
    this.cumulativeGasUsed,
    this.gasUsed,
    this.confirmations,
    this.date,
    this.sortDate,
  });

  BscScanLogTransaction.fromJson(Map<dynamic, dynamic> json) {
    blockNumber = json['blockNumber'];
    timeStamp = json['timeStamp'];
    hash = json['hash'];
    nonce = json['nonce'];
    blockHash = json['blockHash'];
    transactionIndex = json['transactionIndex'];
    from = json['from'];
    to = json['to'];
    value = json['value'];
    gas = json['gas'];
    gasPrice = json['gasPrice'];
    isError = json['isError'];
    txReceiptStatus = json['txreceipt_status'];
    contractAddress = json['contractAddress'];
    cumulativeGasUsed = json['cumulativeGasUsed'];
    gasUsed = json['gasUsed'];
    confirmations = json['confirmations'];

    if (timeStamp != null && timeStamp!.isNotEmpty) {
      try {
        final _time = Parse.toIntValue(timeStamp);
        date = _time.toDateString(format: 'MM-dd-yyyy');
        sortDate = _time.toDateString(format: 'yyyy-MM-dd');
      } catch (ex) {
        LoggerUtil.error(
            'BscScanLogTransaction fromJson error: ${ex.toString()}');
      }
    }
  }

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = <String, dynamic>{};
//   data['network_id'] = chainId;
//   data['network_id'] = networkId;
//   data['symbol'] = symbol;
//   return data;
// }
}
