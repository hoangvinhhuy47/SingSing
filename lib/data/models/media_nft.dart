import 'package:json_annotation/json_annotation.dart';
part 'media_nft.g.dart';

@JsonSerializable()
class MediaNft{

  MediaNft({this.url});

  @JsonKey(name: 'url')
  String? url;


  factory MediaNft.fromJson(Map<String, dynamic> json) =>
      _$MediaNftFromJson(json);

  Map<String, dynamic> toJson() => _$MediaNftToJson(this);

}