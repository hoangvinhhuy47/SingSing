// import 'package:sing_app/utils/parse_util.dart';
//
// import 'nft.dart';
//
// class CovalentNft {
//   int? contractDecimals = 0;
//   String? contractName = '';
//   String? contractTickerSymbol = '';
//   String? contractAddress = '';
//   List<String>? supportsErc = [];
//   String? logoUrl = '';
//   String? lastTransferredAt;
//   String? type;
//   String? balance;
//   List<CovalentNftDetail>? nftData = [];
//
//   CovalentNft({
//     this.contractDecimals,
//     this.contractName,
//     this.contractTickerSymbol,
//     this.contractAddress,
//     this.supportsErc,
//     this.logoUrl,
//     this.lastTransferredAt,
//     this.type,
//     this.balance,
//     this.nftData,
//   });
//
//   CovalentNft.fromJson(Map<dynamic, dynamic> json) {
//     contractDecimals = json['contract_decimals'];
//     contractName = json['contract_name'];
//     contractTickerSymbol = json['contract_ticker_symbol'];
//     contractAddress = json['contract_address'];
//
//     supportsErc = <String>[];
//     if (json['supports_erc'] != null) {
//       json['supports_erc'].forEach((item) {
//         supportsErc!.add(item);
//       });
//     }
//
//     logoUrl = json['logo_url'];
//     lastTransferredAt = json['last_transferred_at'];
//     type = json['type'];
//     balance = json['balance'];
//
//     nftData = <CovalentNftDetail>[];
//     if (json['nft_data'] != null) {
//       json['nft_data'].forEach((item) {
//         final nftDetail = CovalentNftDetail.fromJson(item);
//         nftDetail.contractName = contractName;
//         nftDetail.contractTickerSymbol = contractTickerSymbol;
//         nftDetail.contractAddress = contractAddress;
//         nftData!.add(nftDetail);
//       });
//     }
//   }
//
// // Map<String, dynamic> toJson() {
// //   final Map<String, dynamic> data = <String, dynamic>{};
// //   data['network_id'] = chainId;
// //   data['network_id'] = networkId;
// //   data['symbol'] = symbol;
// //   return data;
// // }
// }
//
// class CovalentNftDetail {
//   String? tokenId = '';
//   String? tokenBalance = '';
//   String? tokenUrl = '';
//   List<String>? supportsErc = [];
//   String? tokenPriceWei = '';
//   String? tokenQuoteRateEth = '';
//   String? originalOwner = '';
//   Nft? externalData;
//   String? owner = '';
//   String? ownerAddress = '';
//   String? burned = '';
//
//   //extra data
//   String? contractName;
//   String? contractTickerSymbol;
//   String? contractAddress;
//
//   CovalentNftDetail({
//     this.tokenId,
//     this.tokenBalance,
//     this.tokenUrl,
//     this.supportsErc,
//     this.tokenPriceWei,
//     this.tokenQuoteRateEth,
//     this.originalOwner,
//     this.externalData,
//     this.owner,
//     this.ownerAddress,
//     this.burned,
//   });
//
//   CovalentNftDetail.fromJson(Map<dynamic, dynamic> json) {
//     tokenId = json['token_id'];
//     tokenBalance = json['token_balance'];
//     tokenUrl = json['token_url'];
//
//     supportsErc = <String>[];
//     if (json['supports_erc'] != null) {
//       json['supports_erc'].forEach((item) {
//         supportsErc!.add(item);
//       });
//     }
//
//     tokenPriceWei = json['token_price_wei'];
//     tokenQuoteRateEth = json['token_quote_rate_eth'];
//     originalOwner = json['original_owner'];
//     externalData = Nft.fromJson(json['external_data']);
//     owner = json['owner'];
//     ownerAddress = json['owner_address'];
//     burned = json['burned'];
//   }
//
// }
//
