import 'package:json_annotation/json_annotation.dart';

part 'song_model.g.dart';

@JsonSerializable()
class SongModel {
  SongModel({
    required this.songId,
    required this.name,
    required this.singer,
    required this.thumbnail,
    required this.duration,
    required this.lyric,
    required this.demoSong,
    required this.backgroundBeat,
    required this.createdAt,
    required this.standardScore,
  });

  @JsonKey(name: 'song_id')
  String songId;
  String name;
  String singer;
  String thumbnail;
  int duration;
  String lyric;
  @JsonKey(name: 'demo_song')
  String demoSong;
  @JsonKey(name: 'background_beat')
  String backgroundBeat;
  @JsonKey(name: 'created_at')
  String createdAt;
  @JsonKey(name: 'standard_score')
  String standardScore;

  factory SongModel.fromJson(Map<String, dynamic> json) =>
      _$SongModelFromJson(json);

  Map<String, dynamic> toJson() => _$SongModelToJson(this);
}
