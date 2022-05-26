import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sing_app/blocs/video_player/video_player_event.dart';
import 'package:sing_app/blocs/video_player/video_player_state.dart';

class VideoPlayerBloc extends Bloc<VideoPlayerEvent, VideoPlayerState> {

  VideoPlayerBloc() : super(VideoPlayerStateInitial()){
    on<VideoPlayerEventStarted>((event, emit) async {
      await _mapVideoPlayerEventStartedToState(emit);
    });
  }

  Future<void> _mapVideoPlayerEventStartedToState(Emitter<VideoPlayerState> emit) async {
    emit(VideoPlayerStateLoading());

    emit(VideoPlayerStateLoaded());
  }

}
