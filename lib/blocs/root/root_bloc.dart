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
import 'package:sing_app/data/repository/ss_repository.dart';
import 'package:sing_app/data/repository/wallet_repository.dart';
import 'package:sing_app/manager/app_lock_manager.dart';
import 'package:sing_app/manager/notification_service.dart';
import 'package:sing_app/oauth2/oauth2_manager.dart';
import 'package:sing_app/utils/logger_util.dart';
import 'package:sing_app/utils/storage_utils.dart';

import '../../application.dart';
import '../../data/event_bus/event_bus_event.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  final tag = 'RootBloc';
  late BaseWalletRepository _walletRepository;
  late SsRepository _ssRepository;


  RootBloc() : super(Uninitialized()){
    final BaseAPI baseAPI =
    BaseAPI(rootBloc: this, baseUrl: AppConfig.instance.values.apiUrl);
    _walletRepository = WalletRepository(baseAPI);

    final SsAPI ssApi = SsAPI(rootBloc: this);
    _ssRepository = SsRepository(ssApi);

    on<AppStarted>((event,emit)async{
      // _mapAppStartedToState(event,emit);
      App.instance.userApp = await Oauth2Manager.instance.getUserApp();
      if(App.instance.userApp != null) {
        emit(Authenticated());
      } else {
        emit(Unauthenticated());
      }
    });
    on<NoInternet>((event, emit) async {
      emit(NoInternetConnection());
    });
    on<LoggedIn>((event, emit) async {
      emit(LoggedInSuccess());
      final data = await _ssRepository.getUserProfile();
      if(data.success && data.data != null){
        App.instance.userApp = data.data;
        await Oauth2Manager.instance.storeUserApp(App.instance.userApp!);
        await _setupNotificationDevice();
        emit(GetUserProfileSuccess());
        App.instance.eventBus.fire(EventBusLoginLogoutSuccessEvent());
      } else {
        await _mapLoggedOutToState(emit);
      }
    });
    on<GetUserProfileSuccessEvent>((event, emit) async {
      emit(GetUserProfileSuccess());
    });

    on<LoggedOut>((event, emit) async {
      App.instance.onLogout();
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
      App.instance.onLogout();
      emit(LoggedOutSuccess());
    });
    on<HideIntroScreen>(_mapHideIntroScreenToState);
    on<AutoLockAppEvent>((event, emit) async {
      emit(AutoLockApp(timeStamp: event.timeStamp));
    });
    on<LocalAuthSuccess>(_mapLocalAuthSuccessToState);

  }

  Future<void> _mapAppStartedToState(AppStarted event, Emitter<RootState> emit) async {

    // notification
    if (await Permission.notification.request().isGranted) {
      LoggerUtil.debug('Notification enabled');
    }

    App.instance.userApp = await Oauth2Manager.instance.getUserApp();

    await AppLockManager.instance.init();

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
      final forceUpdate = cloudConfigResponse.data?['force_update'];
      final updateMessage = cloudConfigResponse.data?['update_message'] ?? '';
      final updateUrl = cloudConfigResponse.data?['update_url']??'';
      LoggerUtil.debug('Saving online app config forceUpdate: $forceUpdate - updateMessage: $updateMessage - updateUrl: $updateUrl');

      await StorageUtils.setString(key: appConfigStorageKey, value: jsonEncode(cloudConfigResponse.data));
      emit(NewVersionAvailable(updateMessage,forceUpdate,updateUrl));
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
      final response = await _ssRepository.getUserProfile();

      if(response.success && response.data != null){
        App.instance.userApp = response.data;
        Oauth2Manager.instance.storeUserApp(App.instance.userApp!);
      } else {
        App.instance.userApp = await Oauth2Manager.instance.getUserApp();
      }
    }

    LoggerUtil.debug('User info: ${App.instance.userApp?.toJson().toString()}');
    if(App.instance.userApp != null) {
      await _setupNotificationDevice();
      emit(Authenticated());
      if(AppLockManager.instance.enableAppLock) {
        emit(AutoLockApp(timeStamp: DateTime.now().millisecondsSinceEpoch));
      }
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
      if(AppLockManager.instance.enableAppLock) {
        emit(AutoLockApp(timeStamp: DateTime.now().millisecondsSinceEpoch));
      }
    }


  }

  Future<void> _mapLocalAuthSuccessToState(LocalAuthSuccess event, Emitter<RootState> emit) async {
    if(App.instance.userApp != null) {
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
    _removeNotificationDevice();
  }

  Future<void> _mapHideIntroScreenToState(HideIntroScreen event, Emitter<RootState> emit) async {
    emit(Unauthenticated());
  }


  Future<void> _setupNotificationDevice() async {
    final String? deviceToken = await NotificationService.instance.getToken();
    LoggerUtil.info('Setup notification device token: $deviceToken', tag: tag);

    if(deviceToken != null) {
      await _ssRepository.addDeviceToken(deviceToken: deviceToken);
    }

  }

  Future<void> _removeNotificationDevice() async {
    final String? deviceToken = await NotificationService.instance.getToken();
    LoggerUtil.info('_removeNotificationDevice deviceToken: $deviceToken');
    // await _deleteDevice(deviceToken: deviceToken);
    if(deviceToken != null) {
      await _ssRepository.deleteDeviceToken(deviceToken: deviceToken);
    }
  }

}