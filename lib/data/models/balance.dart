import 'package:sing_app/db/db_constants.dart';
import 'package:sing_app/utils/parse_util.dart';

class Balance {
  int id = 0;
  String walletId = '';
  bool available = false;
  String secretType = '';
  double balance = 0.0;
  double gasBalance = 0.0;
  String symbol = '';
  String gasSymbol = '';
  double rawBalance = 0.0;
  double rawGasBalance = 0.0;
  int decimals = 0;
  String? tokenAddress; // smart contract address
  bool isHidden = false;
  bool isLocal = false;

  Balance({
      required this.id,
      required this.walletId,
      required this.available,
      required this.secretType,
      required this.balance,
      required this.gasBalance,
      required this.symbol,
      required this.gasSymbol,
      required this.rawBalance,
      required this.rawGasBalance,
      required this.decimals,
      required this.tokenAddress
    }
  );

  Balance.fromJson(Map<String, dynamic> json) {
    walletId = json['walletId'] ?? '';
    available = json['available'];
    secretType = json['secretType'];
    String value = json['balance'] ?? '0';
    try {
      balance = double.parse(value);
    }catch(_){

    }
    try {
      balance = double.parse(value);
    }catch(_){

    }
    gasBalance = Parse.toDoubleValue(json['gasBalance']);
    symbol = json['symbol'];
    gasSymbol = json['gasSymbol'];
    rawBalance = Parse.toDoubleValue(json['rawBalance']);
    rawGasBalance = Parse.toDoubleValue(json['rawGasBalance']);
    decimals = json['decimals'];
    tokenAddress = json['tokenAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['walletId'] = walletId;
    data['available'] = available;
    data['secretType'] = secretType;
    data['balance'] = balance;
    data['gasBalance'] = gasBalance;
    data['symbol'] = symbol;
    data['gasSymbol'] = gasSymbol;
    data['rawBalance'] = rawBalance;
    data['rawGasBalance'] = rawGasBalance;
    data['decimals'] = decimals;
    data['tokenAddress'] = tokenAddress;
    return data;
  }

  Balance.fromDbMap(Map map) {
    id = map[columnId];
    walletId = map[columnWalletId];
    available = true;
    secretType = map[columnSecretType];
    balance = map[columnBalance];
    gasBalance = map[columnGasBalance];
    symbol = map[columnSymbol];
    gasSymbol = map[columnGasSymbol];
    rawBalance = map[columnRawBalance];
    rawGasBalance = map[columnRawGasBalance];
    decimals = map[columnDecimals];
    tokenAddress = map[columnTokenAddress];
    isLocal = true;
  }
}