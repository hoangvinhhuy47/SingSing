import 'package:sing_app/db/db_constants.dart';

import 'balance.dart';

class Wallet {
  String id = '';
  String address = '';
  String walletType = '';
  String secretType = '';
  String createdAt = '';
  bool archived = false;
  String alias = '';
  String description = '';
  bool primary = false;
  bool hasCustomPin = false;
  String? identifier;
  Balance? balance;
  String? mnemonic;
  String? privateKey;

  bool isLocal = false;//user imported
  int importMethod = 0;//user import method

  Wallet(
      {required this.id,
        required this.address,
        required this.walletType,
        required this.secretType,
        required this.createdAt,
        required this.archived,
        required this.alias,
        required this.description,
        required this.primary,
        required this.hasCustomPin,
        required this.identifier,
        required this.balance});

  Wallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    walletType = json['walletType'];
    secretType = json['secretType'];
    createdAt = json['createdAt'];
    archived = json['archived'];
    alias = json['alias'];
    description = json['description'];
    primary = json['primary'];
    hasCustomPin = json['hasCustomPin'];
    identifier = json['identifier'];
    balance =
    json['balance'] != null ? Balance.fromJson(json['balance']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['address'] = address;
    data['walletType'] = walletType;
    data['secretType'] = secretType;
    data['createdAt'] = createdAt;
    data['archived'] = archived;
    data['alias'] = alias;
    data['description'] = description;
    data['primary'] = primary;
    data['hasCustomPin'] = hasCustomPin;
    data['identifier'] = identifier;
    if (balance != null) {
      data['balance'] = balance!.toJson();
    }
    return data;
  }

  Wallet.fromDbMap(Map map) {
    id = map[columnWalletId];
    address = map[columnAddress];
    walletType = '';
    secretType = map[columnSecretType];
    createdAt = map[columnTimestamp].toString();
    archived = false;
    alias = '';
    description = map[columnName];
    primary = false;
    hasCustomPin = false;
    identifier = '';
    importMethod = map[columnImportMethod];
    isLocal = true;
    privateKey = map[columnPrivateKey];
    mnemonic = map[columnMnemonic];
  }
}