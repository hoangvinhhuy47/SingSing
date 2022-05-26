import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:headset_connection_event/headset_event.dart';
import 'package:sing_app/blocs/sing/sing_to_earn/sing_to_earn_screen_event.dart';
import 'package:sing_app/blocs/sing/sing_to_earn/sing_to_earn_screen_state.dart';
import 'package:sing_app/data/models/song_model.dart';

class SingToEarnScreenBloc
    extends Bloc<SingToEarnScreenEvent, SingToEarnScreenState> {
  final SongModel songModel;
  int _timeCountDown = 30;
  bool _isShowTips = false;
  bool _isSinging = false;
  int _singTime = 0;

  int get timeCountDown => _timeCountDown;

  bool get isShowTips => _isShowTips;

  bool get isSinging => _isSinging;

  int get singTime => _singTime;

  SingToEarnScreenBloc({required this.songModel})
      : super(SingToEarnScreenInitialState()) {
    on<SingToEarnScreenDecreaseCountDownTimeEvent>((event, emit) {
      _timeCountDown -= 1;
      emit(SingToEarnScreenUpdateState());
      emit(SingToEarnScreenInitialState());
    });
    on<SingToEarnScreenUpdateIsShowTipsEvent>((event, emit) {
      _isShowTips = event.isShowTips;
      emit(SingToEarnScreenUpdateState());
      emit(SingToEarnScreenInitialState());
    });
    on<SingToEarnScreenUpdateIsSingingEvent>((event, emit) {
      _isSinging = event.isSinging;
      emit(SingToEarnScreenUpdateState());
      emit(SingToEarnScreenInitialState());
    });
    on<SingToEarnScreenIncreaseSingTimeEvent>((event, emit) {
      _singTime += 1;
      emit(SingToEarnScreenUpdateState());
      emit(SingToEarnScreenInitialState());
    });
    on<SingToEarnScreenDetectHeadphoneEvent>((event, emit) async {
      HeadsetEvent headsetPlugin = HeadsetEvent();
      headsetPlugin.getCurrentState.then((_val) {
        _isShowTips = _val == HeadsetState.DISCONNECT;
      });

      emit(SingToEarnScreenUpdateState());
      emit(SingToEarnScreenInitialState());
    });
  }
}
