import 'dart:convert';

import 'nft.dart';

class MoralisNft {
  String? tokenAddress;
  String? tokenId = '';
  String? blockNumberMinted;
  String? ownerOf;
  String? blockNumber;
  String? amount;
  String? contractType;
  String? name;
  String? symbol;
  String? tokenUri;

  String? syncedAt;
  int? isValid = 0;
  int? syncing = 0;
  int? frozen = 0;

  Nft? externalData;

  MoralisNft({
    this.tokenAddress,
    this.tokenId,
    this.blockNumberMinted,
    this.ownerOf,
    this.blockNumber,
    this.amount,
    this.contractType,
    this.name,
    this.symbol,
    this.tokenUri,
    this.externalData,
    this.syncedAt,
    this.isValid = 0,
    this.syncing = 0,
    this.frozen = 0
  });

  MoralisNft.fromJson(Map<dynamic, dynamic> json) {
    tokenAddress = json['token_address'];
    tokenId = json['token_id'];
    blockNumberMinted = json['block_number_minted'];
    ownerOf = json['owner_of'];
    blockNumber = json['block_number'];
    amount = json['amount'];
    contractType = json['contract_type'];
    name = json['name'];
    symbol = json['symbol'];
    tokenUri = json['token_uri'];

    if(json['metadata'] != null) {
      Map<String, dynamic> valueMap = jsonDecode(json['metadata']);
      externalData = Nft.fromJson(valueMap);
    }

    syncedAt = json['synced_at'];

    isValid = json['is_valid'];
    syncing = json['syncing'];
    frozen = json['frozen'];
  }

}