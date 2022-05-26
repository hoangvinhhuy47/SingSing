import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/data/models/admin_keycloark_user_info.dart';
import 'package:sing_app/data/repository/ss_repository.dart';
import 'package:sing_app/utils/logger_util.dart';

import 'change_email_event.dart';
import 'change_email_state.dart';

class ChangeEmailBloc extends Bloc<ChangeEmailEvent, ChangeEmailState> {
  final SsRepository ssRepository;
  AdminKeycloarkUserInfo? adminKeycloarkUserInfo;

  ChangeEmailBloc({
    required this.ssRepository,
  }) : super(ChangeEmailStateInitial()) {

    on<ChangeEmailStarted>((event, emit) async {
      await _mapChangeEmailEventStartToState(emit);
    });
    on<ChangeEmailEventSaving>((event, emit) async {
      await _mapEditChangeEmailEventSavingToState(event, emit);
    });
  }

  Future<void> _mapChangeEmailEventStartToState(Emitter<ChangeEmailState> emit) async {
    emit(ChangeEmailStateInitial());
  }

  Future<void> _mapEditChangeEmailEventSavingToState(
      ChangeEmailEventSaving event,
      Emitter<ChangeEmailState> emit) async {
    emit(const ChangeEmailStateLoading(showLoading: true));

    final response = await ssRepository.changeEmail(email: event.newEmail);
    LoggerUtil.info('change email response: ${response.success} - ${response.error?.message}');
    if (response.success) {
      emit(ChangeEmailStateSaved(message: response.data ?? ''));
    } else {
      emit(ChangeEmailStateErrorSaving(message: response.error?.message ?? l('Password changed failed')));
    }

  }
}
