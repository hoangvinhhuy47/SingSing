class Balance {
  String walletId = '';
  bool available = false;
  String secretType = '';
  double balance = 0.0;
  String gasBalance = '';
  String symbol = '';
  String gasSymbol = '';
  String rawBalance = '';
  String rawGasBalance = '';
  int decimals = 0;
  String? tokenAddress; // smart contract address
  bool isHidden = false;

  Balance({
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
    gasBalance = json['gasBalance'];
    symbol = json['symbol'];
    gasSymbol = json['gasSymbol'];
    rawBalance = json['rawBalance'];
    rawGasBalance = json['rawGasBalance'];
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
}