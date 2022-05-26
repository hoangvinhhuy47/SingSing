import 'package:sing_app/data/models/media_nft.dart';
import 'package:sing_app/data/models/nft_attribute.dart';

class Nft {
  String? name = '';
  String? description = '';
  String? backgroundColor = '';
  String? externalUrl = '';
  String? image = '';
  // String? tokenId = '0';
  List<NftAttribute>? attributes = [];
  MediaNft? media;

  Nft(
      {required this.name,
        required this.description,
        required this.backgroundColor,
        required this.externalUrl,
        required this.image,
        // required this.tokenId,
        required this.attributes,
       this.media
      });

  Nft.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    backgroundColor = json['background_color'];
    externalUrl = json['external_url'];
    image = json['image'];
    // tokenId = json['token_id'];
    if (json['attributes'] != null) {
      attributes = [];
      json['attributes'].forEach((v) {
        attributes!.add(NftAttribute.fromJson(v));
      });
    }
    if (json['media'] != null) {
      media = MediaNft.fromJson(json['media']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['background_color'] = backgroundColor;
    data['external_url'] = externalUrl;
    data['image'] = image;
    data['media'] = media;
    // data['token_id'] = tokenId;
    data['attributes'] = attributes?.map((v) => v.toJson()).toList();
    return data;
  }
}