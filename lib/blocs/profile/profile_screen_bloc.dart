import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:sing_app/blocs/profile/profile_screen_event.dart';
import 'package:sing_app/blocs/profile/profile_screen_state.dart';
import 'package:sing_app/blocs/root/root_bloc.dart';
import 'package:sing_app/data/models/nft_user_profile.dart';
import 'package:sing_app/data/repository/media_repository.dart';
import 'package:sing_app/data/repository/singnft_repository.dart';
import 'package:sing_app/data/repository/wallet_repository.dart';
import 'package:sing_app/oauth2/oauth2_manager.dart';
import 'package:sing_app/utils/logger_util.dart';

import '../../application.dart';

class ProfileScreenBloc extends Bloc<ProfileScreenEvent, ProfileScreenState> {
  final BaseWalletRepository walletRepository;
  final BaseMediaRepository mediaRepository;
  final BaseSingNftRepository nftRepository;
  final RootBloc rootBloc;

  NftUserProfile? nftUserProfile;
  File? fileUploadAvatar;

  ProfileScreenBloc({
    required this.walletRepository,
    required this.mediaRepository,
    required this.nftRepository,
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

    on<OnChangeLanguageProfileScreenEvent>((event, emit) async {
      emit(OnChangedLanguageState(langCode: event.langCode));
    });

    on<ChangeUserInfoSuccessfulEvent>((event, emit) async {
      emit(ChangeUserInfoSuccessfulState(email: event.email));
    });
  }

  Future<void> _mapProfileScreenEventStartedToState(Emitter<ProfileScreenState> emit) async {
    final user = await Oauth2Manager.instance.getUser();
    if (user != null) {
      final responseNftProfile = await nftRepository.getUserProfile();
      if(responseNftProfile.error == null){
        nftUserProfile = responseNftProfile.user;
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

    final response = await walletRepository.getUserProfile();
    if(response.success && response.data != null){
      await Oauth2Manager.instance.storeUser(response.data!);
      App.instance.user = response.data;

      //nft profile for cover image
      final responseNftProfile = await nftRepository.getUserProfile();
      if(responseNftProfile.error == null){
        nftUserProfile = responseNftProfile.user;
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
      final response = await walletRepository.getUserProfile();
      if(response.success && response.data != null){
        await Oauth2Manager.instance.storeUser(response.data!);
        App.instance.user = response.data;
        emit(const ProfileScreenStateUserInfoFetched(loggedIn: true));
      }
    } else {
      fileUploadAvatar = null;
      emit(ProfileScreenStateUploadAvatarError());
    }
  }

  Future<void> _mapProfileScreenEventUploadCoverToState(Emitter<ProfileScreenState> emit, ProfileScreenEventUploadCover event) async{
    emit(const ProfileScreenStateLoading());
    final response = await nftRepository.uploadCover(file: event.file, mimeType: event.mimeType);
    LoggerUtil.info('upload cover response: $response');
    if(response.error == null){
      final response = await nftRepository.getUserProfile();
      if(response.error == null){
        nftUserProfile = response.user;
        emit(const ProfileScreenStateUserInfoFetched(loggedIn: true));
      }
    } else {
      emit(ProfileScreenStateUploadCoverError(message: response.error?.message ?? ''));
    }
  }

}
