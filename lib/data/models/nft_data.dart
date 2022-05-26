import 'nft.dart';

class NftData {
  String? tokenId = '';
  String? tokenUrl = '';
  String? originalOwner = '';
  Nft? metaData;

  NftData({
    this.tokenId,
    this.tokenUrl,
    this.originalOwner,
    this.metaData,
  });

  NftData.fromJson(Map<String, dynamic> json) {
    tokenId = json['token_id'];
    tokenUrl = json['token_url'];
    originalOwner = json['original_owner'];
    metaData = Nft.fromJson(json['external_data']);
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['name'] = name;
  //   data['description'] = description;
  //   data['background_color'] = backgroundColor;
  //   data['external_url'] = externalUrl;
  //   data['image'] = image;
  //   // data['token_id'] = tokenId;
  //   data['attributes'] = attributes?.map((v) => v.toJson()).toList();
  //   return data;
  // }
}