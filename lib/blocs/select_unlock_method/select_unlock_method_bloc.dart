import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/select_unlock_method/select_unlock_method_event.dart';
import 'package:sing_app/blocs/select_unlock_method/select_unlock_method_state.dart';
import 'package:sing_app/manager/app_lock_manager.dart';

class SelectUnlockMethodBloc
    extends Bloc<SelectUnlockMethodEvent, SelectUnlockMethodState> {
  SelectUnlockMethodBloc() : super(SelectUnlockMethodStateInitial()) {
    on<SelectUnlockMethodEventStarted>((event, emit) async {
      emit(SelectUnlockMethodStateInitial());
    });

    on<UnlockMethodChangedEvent>((event, emit) async {
      AppLockManager.instance.onUnlockMethodChanged(event.unlockMethod);
      emit(UnlockMethodChangedState(unlockMethod: event.unlockMethod));
    });
  }
}
