import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/data/models/admin_keycloark_user_info.dart';
import 'package:sing_app/data/repository/ss_repository.dart';
import 'package:sing_app/utils/logger_util.dart';

import 'change_password_event.dart';
import 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final SsRepository ssRepository;
  AdminKeycloarkUserInfo? adminKeycloarkUserInfo;

  ChangePasswordBloc({
    required this.ssRepository,
  }) : super(ChangePasswordStateInitial()) {
    on<ChangePasswordStarted>((event, emit) async {
      await _mapChangePasswordEventStartToState(emit);
    });
    on<ChangePasswordEventSaving>((event, emit) async {
      await _mapEditChangePasswordEventSavingToState(event, emit);
    });
  }

  Future<void> _mapChangePasswordEventStartToState(
      Emitter<ChangePasswordState> emit) async {
    emit(ChangePasswordStateInitial());
  }

  Future<void> _mapEditChangePasswordEventSavingToState(
      ChangePasswordEventSaving event,
      Emitter<ChangePasswordState> emit) async {
    emit(const ChangePasswordStateLoading(showLoading: true));

    final response = await ssRepository.changePassword(
        oldPassword: event.oldPassword, newPassword: event.newPassword);
    LoggerUtil.info('change password response: ${response.success} - ${response.error?.message}');
    if (response.success) {
      emit(ChangePasswordStateSaved(message: response.data ?? ''));
    } else {
      emit(ChangePasswordStateErrorSaving(message: response.error?.message ?? l('Password changed failed')));
    }

  }
}
