import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/select_auto_lock_time/select_auto_lock_time_event.dart';
import 'package:sing_app/blocs/select_auto_lock_time/select_auto_lock_time_state.dart';
import 'package:sing_app/constants/enum.dart';
import 'package:sing_app/manager/app_lock_manager.dart';




class SelectAutoLockTimeBloc extends Bloc<SelectAutoLockTimeEvent, SelectAutoLockTimeState> {

  AutoLockDuration? autoLockDuration;

  SelectAutoLockTimeBloc() : super(SelectAutoLockTimeStateInitial()) {

    on<SelectAutoLockTimeEventStarted>((event, emit) async {
      emit(SelectAutoLockTimeStateInitial());
    });

    on<AutoLockTimeChangedEvent>((event, emit) async {
      autoLockDuration = event.autoLockDuration;
      AppLockManager.instance.onAutoLockDurationChanged(autoLockDuration!);
      emit(AutoLockTimeChangedState(autoLockDuration: event.autoLockDuration));
    });

  }

  // Future<void> _mapAutoLockTimeChangedEventToState(AutoLockTimeChangedEvent event, Emitter<SelectAutoLockTimeState> emit) async {
  //
  //   emit(AppLockChangedState(enable: event.enable));
  // }

}
