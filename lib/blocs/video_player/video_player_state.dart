import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sing_app/oauth2/oauth2_user_info.dart';

@immutable
abstract class VideoPlayerState extends Equatable {
  const VideoPlayerState();

  @override
  List<Object> get props => [];
}

class VideoPlayerStateInitial extends VideoPlayerState {}
class VideoPlayerStateLoading extends VideoPlayerState {}
class VideoPlayerStateLoaded extends VideoPlayerState {}
