import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class VideoPlayerEvent extends Equatable {
  const VideoPlayerEvent();

  @override
  List<Object> get props => [];
}

class VideoPlayerEventStarted extends VideoPlayerEvent {}

class VideoPlayerEventPlayPause extends VideoPlayerEvent{}