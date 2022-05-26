class MediaModel{
  MediaModel({
    required this.mediaId,
    required this.type,
    required this.original,
    required this.thumb,

  });

  String mediaId;
  String type;
  String original;
  String thumb;

  factory MediaModel.fromJson(Map<String, dynamic> json) => MediaModel(
    mediaId: json["media_id"] ?? '',
    type: json["type"] ?? '',
    original: json["original"] ?? '',
    thumb: json["thumb"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "media_id": mediaId,
    "type": type,
    "original": original,
    "thumb": thumb,
  };

  bool isMediaNotEmpty() {
    return !(original.isEmpty && thumb.isEmpty);
  }
}
