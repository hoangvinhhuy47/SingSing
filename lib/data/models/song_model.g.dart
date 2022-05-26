// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SongModel _$SongModelFromJson(Map<String, dynamic> json) => SongModel(
      songId: json['song_id'] as String,
      name: json['name'] as String,
      singer: json['singer'] as String,
      thumbnail: json['thumbnail'] as String,
      duration: json['duration'] as int,
      lyric: json['lyric'] as String,
      demoSong: json['demo_song'] as String,
      backgroundBeat: json['background_beat'] as String,
      createdAt: json['created_at'] as String,
      standardScore: json['standard_score'] as String,
    );

Map<String, dynamic> _$SongModelToJson(SongModel instance) => <String, dynamic>{
      'song_id': instance.songId,
      'name': instance.name,
      'singer': instance.singer,
      'thumbnail': instance.thumbnail,
      'duration': instance.duration,
      'lyric': instance.lyric,
      'demo_song': instance.demoSong,
      'background_beat': instance.backgroundBeat,
      'created_at': instance.createdAt,
      'standard_score': instance.standardScore,
    };
