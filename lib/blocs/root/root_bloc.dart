import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sing_app/blocs/root/root_event.dart';
import 'package:sing_app/blocs/root/root_state.dart';
import 'package:sing_app/config/app_config.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/data_provider/base_api.dart';
import 'package:sing_app/data/data_provider/ss_api.dart';
import 'package:sing_app/data/models/user_profile.dart';
import 'package:sing_app/data/repository/ss_repository.dart';
import 'package:sing_app/data/repository/wallet_repository.dart';
import 'package:sing_app/oauth2/oauth2_manager.dart';
import 'package:sing_app/utils/logger_util.dart';
import 'package:sing_app/utils/storage_utils.dart';

import '../../application.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  late BaseWalletRepository _walletRepository;
  late SsRepository _ssRepository;


  RootBloc() : super(Uninitialized()){
    final BaseAPI baseAPI =
    BaseAPI(rootBloc: this, baseUrl: AppConfig.instance.values.apiUrl);
    _walletRepository = WalletRepository(baseAPI);

    final SsAPI ssApi = SsAPI(rootBloc: this);
    _ssRepository = SsRepository(ssApi);

    on<AppStarted>(_mapAppStartedToState);
    on<NoInternet>((event, emit) async {
      emit(NoInternetConnection());
    });
    on<LoggedIn>((event, emit) async {
      emit(LoggedInSuccess());
      final data = await _walletRepository.getUserProfile();
      if(data.success && data.data != null){
        App.instance.user = data.data;
        await Oauth2Manager.instance.storeUser(App.instance.user!);
        emit(GetUserProfileSuccess());
      } else {
        await _mapLoggedOutToState(emit);
      }
    });
    on<LoggedOut>((event, emit) async {
      App.instance.user = null;
      emit(LoggedOutSuccess());
    });
    on<ShowLoginPopupEvent>((event, emit) async {
      emit(ShowLoginPopup());
    });
    on<ShowRegistrationPopupEvent>((event, emit) async {
      emit(ShowRegistrationsPopup());
    });
    on<HideLoginPopupEvent>((event, emit) async {
      emit(HideOath2Popup());
    });
    on<AccessTokenExpired>(_mapAccessTokenExpiredToState);
    on<DismissAccessTokenExpiredAlert>((event, emit) async {
      _isShowingExpiredTokenAlert = false;
    });
    on<HideIntroScreen>(_mapHideIntroScreenToState);
  }

  Future<void> _mapAppStartedToState(AppStarted event, Emitter<RootState> emit) async {
    // notification
    if (await Permission.notification.request().isGranted) {
      LoggerUtil.debug('Notification enabled');
    }
    //get local app config
    final savedConfig = await StorageUtils.getString(key: appConfigStorageKey, defaultValue: '');
    if(savedConfig.isNotEmpty){
      LoggerUtil.debug('got local app config $savedConfig');
      try{
        final data = jsonDecode(savedConfig);
        AppConfig.instance.values.merge(data);
        LoggerUtil.debug('load local app config ok');
      }catch(e){
        LoggerUtil.error('error loading local app config $e');
      }
    }
    LoggerUtil.debug('getting app config online');
    // Get cloud config
    final cloudConfigResponse = await _ssRepository.getCloudConfig(
        versionCode: int.tryParse(App.instance.appBuildNumber) ?? 0,
        os: Platform.isIOS ? 'ios' : 'android'
    );
    LoggerUtil.debug('getting app config online ok');
    if(cloudConfigResponse.success && cloudConfigResponse.data != null) {
      //save cloud config
      LoggerUtil.debug('Saving online app config');
      await StorageUtils.setString(key: appConfigStorageKey, value: jsonEncode(cloudConfigResponse.data));
      try{
        AppConfig.instance.values.merge(cloudConfigResponse.data!);
      }catch(e){
        LoggerUtil.error('error merging local app config $e');
      }
    } else {
      LoggerUtil.error('error getting app config online $cloudConfigResponse');
    }

    // Get access token
    final token = await Oauth2Manager.instance.getToken();
    if(token != null){
      final response = await _walletRepository.getUserProfile();
      if(response.success && response.data != null){
        App.instance.user = response.data;
        Oauth2Manager.instance.storeUser(App.instance.user!);
      }
    }

    if(App.instance.user != null) {
      emit(Authenticated());
      return;
    } else {
      await Oauth2Manager.instance.clearAllData();
    }

    final isFirstLaunch = await StorageUtils.getBool(
        key: Constants.isFirstLaunchKey, defaultValue: true);
    if(isFirstLaunch){
      emit(OpenIntroScreen());
    } else {
      emit(Unauthenticated());
    }
  }


  bool _isShowingExpiredTokenAlert = false;

  Future<void> _mapAccessTokenExpiredToState(AccessTokenExpired event, Emitter<RootState> emit) async {
    if (!_isShowingExpiredTokenAlert) {
      _isShowingExpiredTokenAlert = true;
      await _mapLoggedOutToState(emit);
      emit(ShowAccessTokenExpiredAlert());
    }
  }

  Future<void> _mapLoggedOutToState(Emitter<RootState> emit) async {
    await Oauth2Manager.instance.clearAllData();
    emit(LoggedOutSuccess());
  }

  Future<void> _mapHideIntroScreenToState(HideIntroScreen event, Emitter<RootState> emit) async {
    emit(Unauthenticated());
  }

}