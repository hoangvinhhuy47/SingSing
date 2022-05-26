import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/sing/calculate_score_s2e/calculate_score_s2e_screen_state.dart';

import '../../../data/models/song_model.dart';
import 'calculate_score_s2e_screen_event.dart';

class CalculateScoreS2EScreenBloc
    extends Bloc<CalculateScoreS2EScreenEvent, CalculateScoreS2EScreenState> {
  final SongModel songModel;

  CalculateScoreS2EScreenBloc({required this.songModel})
      : super(CalculateScoreS2EScreenInitialState()) {
    on<CalculateScoreS2EScreenStartedEvent>(
        _mapCalculateScoreStartedEventToState);
  }

  Future<void> _mapCalculateScoreStartedEventToState(
      CalculateScoreS2EScreenStartedEvent event,
      Emitter<CalculateScoreS2EScreenState> emit) async {
    //todo remove this
    await Future.delayed(const Duration(seconds: 3));

    emit(const CalculateScoreS2EDoneState(isSuccess: true));
    emit(CalculateScoreS2EScreenInitialState());
  }
}
