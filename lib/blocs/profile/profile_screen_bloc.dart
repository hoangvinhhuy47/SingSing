import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:sing_app/blocs/profile/profile_screen_event.dart';
import 'package:sing_app/blocs/profile/profile_screen_state.dart';
import 'package:sing_app/blocs/root/root_bloc.dart';
import 'package:sing_app/data/models/user_profile.dart';
import 'package:sing_app/data/repository/media_repository.dart';
import 'package:sing_app/data/repository/ss_repository.dart';
import 'package:sing_app/oauth2/oauth2_manager.dart';

import '../../application.dart';

class ProfileScreenBloc extends Bloc<ProfileScreenEvent, ProfileScreenState> {
  final BaseSsRepository ssRepository;
  final BaseMediaRepository mediaRepository;
  final RootBloc rootBloc;

  UserProfile? userProfile = App.instance.userApp;
  File? fileUploadAvatar;

  ProfileScreenBloc({
    required this.ssRepository,
    required this.mediaRepository,
    required this.rootBloc,
  }) : super(ProfileScreenStateInitial()){
    on<ProfileScreenEventStarted>((event, emit) async {
      emit(ProfileScreenStateLoading(showLoading: event.isRefreshing));
      await _mapProfileScreenEventStartedToState(emit);
    });
    on<ProfileScreenShowLoadingEvent>((event, emit) async {
      emit(ProfileScreenStateLoading(showLoading: event.isLoading));
    });

    on<ProfileScreenEventLogout>((event, emit) async {
      await _mapProfileScreenEventLogoutToState(emit);
    });
    on<ProfileScreenEventReload>((event, emit) async {
      await _mapProfileScreenEventReloadToState(emit);
    });
    on<ProfileScreenEventUploadAvatar>((event, emit) async {
      await _mapProfileScreenEventUploadAvatarToState(emit, event);
    });
    on<ProfileScreenEventUploadCover>((event, emit) async {
      await _mapProfileScreenEventUploadCoverToState(emit, event);
    });

    on<ChangeUserInfoSuccessfulEvent>((event, emit) async {
      emit(ChangeUserInfoSuccessfulState(email: event.email));
    });
  }

  Future<void> _mapProfileScreenEventStartedToState(Emitter<ProfileScreenState> emit) async {
    final user = await Oauth2Manager.instance.getUserApp();
    if (user != null) {
      final responseNftProfile = await ssRepository.getUserProfile();
      if(responseNftProfile.error == null){
        userProfile = responseNftProfile.data;
      }
      emit(const ProfileScreenStateUserInfoFetched(loggedIn: true));
    } else {
      emit(const ProfileScreenStateUserInfoFetched(loggedIn: false));
    }
  }

  Future<void> _mapProfileScreenEventLogoutToState(Emitter<ProfileScreenState> emit) async {
    emit(ProfileScreenStateLoggingOut());
    await Oauth2Manager.instance.logout();
    emit(ProfileScreenStateLoggedOut());
  }

  Future<void> _mapProfileScreenEventReloadToState(Emitter<ProfileScreenState> emit) async {
    emit(const ProfileScreenStateLoading());

    final response = await ssRepository.getUserProfile();

    if(response.success && response.data != null){
      await Oauth2Manager.instance.storeUserApp(response.data!);
      App.instance.userApp = response.data;

      //nft profile for cover image
      final responseNftProfile = await ssRepository.getUserProfile();
      if(responseNftProfile.error == null){
        userProfile = responseNftProfile.data;
      }

      emit(const ProfileScreenStateUserInfoFetched(loggedIn: true));
    } else {
      await _mapProfileScreenEventLogoutToState(emit);
    }
  }

  Future<void> _mapProfileScreenEventUploadAvatarToState(Emitter<ProfileScreenState> emit, ProfileScreenEventUploadAvatar event) async{
    fileUploadAvatar = event.file;
    emit(ProfileScreenStateUploadAvatar(file: event.file));

    final response = await mediaRepository.uploadAvatar(file: event.file, mimeType: event.mimeType);
    if(response.success){
      final response= await ssRepository.getUserProfile();
      if(response.success && response.data != null){
        await Oauth2Manager.instance.storeUserApp(response.data!);
        App.instance.userApp = response.data;
        emit(const ProfileScreenStateUserInfoFetched(loggedIn: true));
      }
    } else {
      fileUploadAvatar = null;
      emit(ProfileScreenStateUploadAvatarError());
    }
  }

  Future<void> _mapProfileScreenEventUploadCoverToState(Emitter<ProfileScreenState> emit, ProfileScreenEventUploadCover event) async{
    emit(const ProfileScreenStateLoading());
    final response = await ssRepository.uploadCover(file: event.file, mimeType: event.mimeType);
    if(response.error == null){
      final response = await ssRepository.getUserProfile();
      if(response.error == null){
        userProfile = response.data;
        emit(const ProfileScreenStateUserInfoFetched(loggedIn: true));
      }
    } else {
      emit(ProfileScreenStateUploadCoverError(message: response.error?.message ?? ''));
    }
  }

}
