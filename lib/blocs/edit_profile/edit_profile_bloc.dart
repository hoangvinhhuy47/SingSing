import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/root/root_bloc.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/data/models/user_profile.dart';
import 'package:sing_app/data/repository/ss_repository.dart';
import 'package:sing_app/data/repository/wallet_repository.dart';
import 'package:sing_app/event_bus/event_bus_event.dart';
import 'package:sing_app/oauth2/oauth2_manager.dart';
import 'package:sing_app/oauth2/oauth2_token.dart';
import 'package:sing_app/oauth2/oauth2_user_info.dart';

import '../../application.dart';
import 'edit_profile_event.dart';
import 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final SsRepository ssRepository;
  final BaseWalletRepository walletRepository;
  // Oauth2UserInfo? oauth2UserInfo;
  UserProfile? userProfile;

  EditProfileBloc({
    required this.ssRepository,
    required this.walletRepository,
  }) : super(EditProfileStateInitial()) {
    on<EditProfileStarted>((event, emit) async {
      await _mapEditProfileEventStartToState(emit);
    });
    on<EditProfileEventSaving>((event, emit) async {
      await _mapEditProfileEventSavingToState(event, emit);
    });
  }

  Future<void> _mapEditProfileEventStartToState(
      Emitter<EditProfileState> emit) async {
    emit(const EditProfileStateLoading(showLoading: true));

    final data = await walletRepository.getUserProfile();
    if(data.success && data.data != null){
      UserProfile? _user = data.data;
      if(_user != null) {
        Oauth2Manager.instance.storeUser(_user);
        App.instance.user = _user;
      }
    }

    userProfile =  await Oauth2Manager.instance.getUser();
    if(userProfile != null) {
      emit(EditProfileStateLoadedUserInfo());
      App.instance.eventBus.fire(EventBusChangeUserInfoSuccessful(email: userProfile!.email));
      return;
    }

    emit(EditProfileStateLoadedUserInfoError());
  }

  Future<void> _mapEditProfileEventSavingToState(
      EditProfileEventSaving event, Emitter<EditProfileState> emit) async {
    emit(const EditProfileStateLoading(showLoading: true));

    final response = await ssRepository.changeUserInfo(
        // email: event.email,
        firstName: event.firstName,
        lastName: event.lastName);
    if (response.success) {
      userProfile =  await Oauth2Manager.instance.getUser();
      if(userProfile != null) {
        // userProfile!.email = event.email;
        userProfile!.firstName = event.firstName;
        userProfile!.lastName = event.lastName;
        Oauth2Manager.instance.storeUser(userProfile!);
      }

      // App.instance.eventBus.fire(EventBusChangeUserInfoSuccessful(email: event.email));
      emit(EditProfileStateSaved());
      return;
    }
    emit(EditProfileStateErrorSaving(message: response.error?.message ?? l('User information changed failed')));
  }
}
