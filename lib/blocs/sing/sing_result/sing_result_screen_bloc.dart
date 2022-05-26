import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/sing/sing_result/sing_result_screen_event.dart';
import 'package:sing_app/blocs/sing/sing_result/sing_result_screen_state.dart';

import '../../../data/models/song_model.dart';

class SingResultScreenBloc
    extends Bloc<SingResultScreenEvent, SingResultScreenState> {
  final SongModel songModel;

  SingResultScreenBloc({required this.songModel})
      : super(SingResultScreenInitialState());
}
