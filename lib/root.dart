import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:sing_app/blocs/root/root_bloc.dart';
import 'package:sing_app/blocs/root/root_event.dart';
import 'package:sing_app/blocs/root/root_state.dart';
import 'package:sing_app/blocs/tabbar/tabbar_bloc.dart';
import 'package:sing_app/config/app_localization.dart';

import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/constants/extension_constant.dart';
import 'package:sing_app/data/models/internal_web_view.dart';

import 'package:sing_app/constants/enum.dart';
import 'package:sing_app/manager/app_lock_manager.dart';

import 'package:sing_app/routes.dart';
import 'package:sing_app/screens/account_management/auth_screen.dart';
import 'package:sing_app/screens/s2e_tabbar_screen.dart';

import 'package:sing_app/utils/logger_util.dart';
import 'package:sing_app/utils/storage_utils.dart';

import 'package:sing_app/utils/url_util.dart';
import 'package:sing_app/widgets/dialog/custom_alert_dialog.dart';
import 'package:store_redirect/store_redirect.dart';

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> with WidgetsBindingObserver {
  final tag = 'Root';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final NavigationHistoryObserver _navigatorHistoryObserver =
      NavigationHistoryObserver();

  late RootBloc _rootBloc;
  late TabBarBloc _tabBarBloc;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _rootBloc = BlocProvider.of<RootBloc>(context);
    _tabBarBloc = BlocProvider.of<TabBarBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    AppLockManager.instance.isOpenGallery = false;
    WidgetsBinding.instance.removeObserver(this);
    _rootBloc.close();
    _tabBarBloc.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    LoggerUtil.info('didChangeAppLifecycleState state: $state', tag: tag);
    if (state == AppLifecycleState.resumed) {
      // FlutterAppBadger.removeBadge();
    }

    if (state == AppLifecycleState.paused) {
      AppLockManager.instance.isLocalAuthSuccess = false;
      StorageUtils.setInt(
          key: 'idle_time', value: DateTime.now().millisecondsSinceEpoch);
    } else if (AppLockManager.instance.enableAppLock &&
        state == AppLifecycleState.resumed) {
      final lastName = _navigatorHistoryObserver.history.last.settings.name;
      LoggerUtil.info('didChangeAppLifecycleState last route: $lastName',
          tag: tag);
      if (Platform.isAndroid) {
        if (lastName != Routes.localAuthScreen) {
          checkAppAutoLock();
        }
      } else if (Platform.isIOS) {
        if (lastName != Routes.localAuthScreen &&
            !AppLockManager.instance.isLocalAuthSuccess) {
          checkAppAutoLock();
        }
      }
    }
  }

  Future<bool> checkAppAutoLock() async {
    int timeAppPause =
        await StorageUtils.getInt(key: 'idle_time', defaultValue: 0);
    int duration =
        (DateTime.now().millisecondsSinceEpoch - timeAppPause) ~/ 1000;
    LoggerUtil.info(
        'checkAppAutoLock last time app visible: $timeAppPause - duration: $duration',
        tag: tag);
    if (AppLockManager.instance.autoLockDuration.seconds <= 0) {
      LoggerUtil.info('lock app immediately', tag: tag);
      _rootBloc.add(
          AutoLockAppEvent(timeStamp: DateTime.now().millisecondsSinceEpoch));
    } else if (duration > AppLockManager.instance.autoLockDuration.seconds) {
      LoggerUtil.info('auto lock app, duration: $duration', tag: tag);
      _rootBloc.add(
          AutoLockAppEvent(timeStamp: DateTime.now().millisecondsSinceEpoch));
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: null,
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: BlocListener<RootBloc, RootState>(
          listener: (ctx, state) async {
            // if (state is AutoLockApp) {
            //   if (!AppLockManager.instance.isOpenGallery) {
            //     LoggerUtil.info(
            //         'ModalRoute.of(context)?.settings.name: ${ModalRoute.of(context)?.settings.name}');
            //     final result =
            //         await Navigator.pushNamed(context, Routes.localAuthScreen);
            //     LoggerUtil.info('result verify code: $result');
            //     if (result is bool && result == true) {
            //       // Navigator.popUntil(context, (route) => route.isFirst);
            //     }
            //   }
            //   AppLockManager.instance.isOpenGallery = false;
            // }
            //
            // if (state is LoggedInSuccess) {
            //   BlocProvider.of<WalletScreenBloc>(context).add(
            //     const WalletScreenShowLoadingEvent(isLoading: true),
            //   );
            //   BlocProvider.of<ProfileScreenBloc>(context).add(
            //     const ProfileScreenShowLoadingEvent(isLoading: true),
            //   );
            // }
            //
            // if (state is GetUserProfileSuccess || state is LoggedOutSuccess) {
            //   BlocProvider.of<WalletScreenBloc>(context).add(
            //     const WalletScreenEventStarted(isRefreshing: true),
            //   );
            //   BlocProvider.of<ProfileScreenBloc>(context).add(
            //     const ProfileScreenEventStarted(isRefreshing: true),
            //   );
            //   BlocProvider.of<ForumScreenBloc>(context).add(
            //     const GetForumEvent(),
            //   );
            // }
            //
            // if (state is Authenticated) {
            //   // Check if user has grant notification permission
            //   // If not, show prompt once in a while
            //   NotificationService.instance.checkIfUserGrantNotification(context: ctx);
            // }
            //
            // if (state is ShowLoginPopup) {
            //   BlocProvider.of<WalletScreenBloc>(context).add(
            //     const WalletScreenShowLoadingEvent(isLoading: true),
            //   );
            //   BlocProvider.of<ProfileScreenBloc>(context).add(
            //     const ProfileScreenShowLoadingEvent(isLoading: true),
            //   );
            //   _showLoginPopup();
            // }
            //
            // if(state is HideOath2Popup){
            //   BlocProvider.of<WalletScreenBloc>(context).add(
            //     const WalletScreenShowLoadingEvent(isLoading: false),
            //   );
            //   BlocProvider.of<ProfileScreenBloc>(context).add(
            //     const ProfileScreenShowLoadingEvent(isLoading: false),
            //   );
            // }
            //
            // if (state is ShowRegistrationsPopup) {
            //   _showRegistrationsPopup();
            // }
            //
            if (state is ShowAccessTokenExpiredAlert) {
              _showAccessTokenExpiredAlert();
            }
            //
            // if (state is NewVersionAvailable &&
            //     state.typeUpdateApp > TypeUpdateApp.noUpdate.value) {
            //   _showAlertUpdate(
            //       state.typeUpdateApp, state.version, state.updateUrl);
            // }
          },
          child: BlocBuilder<RootBloc, RootState>(
            buildWhen: (preState, nextState) {
              ///SING SING APP
              // if (nextState is LoggedOutSuccess) {
              //   return false;
              // }
              // if (nextState is LoggedInSuccess ||
              //     nextState is GetUserProfileSuccess) {
              //   return false;
              // }
              // if (nextState is ShowAccessTokenExpiredAlert) {
              //   return false;
              // }
              // if (nextState is ShowLoginPopup ||
              //     nextState is ShowRegistrationsPopup) {
              //   return false;
              // }
              // if (nextState is HideOath2Popup) {
              //   return false;
              // }
              // if (nextState is NewVersionAvailable) {
              //   return false;
              // }
              // if (nextState is AutoLockApp) {
              //   return false;
              // }
              return true;
            },
            builder: (context, state) {
              // LoggerUtil.info('========= Root builder state: $state');
              // if (state is OpenIntroScreen) {
              //   return const IntroScreen();
              // }
              // else if (state is Authenticated || state is Unauthenticated) {
              //   return const TabBarScreen();
              // }
              // else {
              //   return const SplashView();
              // }

              if (state is Unauthenticated || state is LoggedOutSuccess) {
                return const AuthScreen();
              }
              return const S2ETabBarScreen();
            },
          ),
        ),
      ),
    );
  }

  // Future _showLoginPopup() async {
  //   Navigator.popUntil(context, (route) => route.isFirst);
  //   Oauth2Dialog(
  //       context: context,
  //       onLoginResult: (Oauth2Token? token, String? message) {
  //         LoggerUtil.info('_showLoginPopup onLoginResult token: $token - message: $message');
  //         if (token != null && token.accessToken.isNotEmpty) {
  //           _rootBloc.add(LoggedIn(token: token));
  //         } else {
  //           _rootBloc.add(HideLoginPopupEvent());
  //           if (message?.isNotEmpty ?? false) {
  //             showSnackBarError(context: context, message: message!);
  //           }
  //         }
  //         LoggerUtil.info('_showLoginPopup onLoginResult hide popup');
  //         Navigator.of(context).pop();
  //       }).show();
  // }
  //
  // Future _showRegistrationsPopup() async {
  //   Navigator.popUntil(context, (route) => route.isFirst);
  //   Oauth2Dialog(
  //       context: context,
  //       isRegistrations: true,
  //       onLoginResult: (Oauth2Token? token, String? message) {
  //         LoggerUtil.info('_showRegistrationsPopup onLoginResult token: $token - message: $message');
  //         if (token != null && token.accessToken.isNotEmpty) {
  //           _rootBloc.add(LoggedIn(token: token));
  //         } else {
  //           _rootBloc.add(HideLoginPopupEvent());
  //           if (message?.isNotEmpty ?? false) {
  //             showSnackBarError(context: context, message: message!);
  //           }
  //         }
  //         LoggerUtil.info('_showRegistrationsPopup onLoginResult hide popup');
  //         Navigator.of(context).pop();
  //       }).show();
  // }

  Future _showAccessTokenExpiredAlert() async {
    Navigator.popUntil(context, (route) => route.isFirst);
    CustomAlertDialog.show(
      context,
      content: 'Session expired. Please login again.',
      isShowButtonClose: false,
      isShowTitle: false,
      leftText: 'OK',
      isLeftPositive: true,
      leftAction: () {
        _rootBloc.add(DismissAccessTokenExpiredAlert());
        Navigator.pop(context);
      },
    );
  }

  _showAlertUpdate(int typeUpdateApp, String message, String updateUrl) {
    Navigator.popUntil(context, (route) => route.isFirst);
    CustomAlertDialog.show(
      context,
      title: l('Update'),
      content: message,
      leftText: l('Update'),
      backListener: () {
        if (typeUpdateApp != TypeUpdateApp.forceUpdate.value) {
          Navigator.pop(context, true);
        }
      },
      isLeftPositive: true,
      leftAction: () {
        if (typeUpdateApp != TypeUpdateApp.forceUpdate.value) {
          Navigator.pop(context, true);
        }
        if (updateUrl.trim().isNotEmpty) {
          UrlUtil.openWeb(context,
              InternalWebViewModel(title: l('Update'), url: updateUrl));
        } else {
          StoreRedirect.redirect(
              androidAppId: "net.singsing.app",
              iOSAppId: ""); // TODO update iosAppId
        }
      },
      rightText: typeUpdateApp == TypeUpdateApp.update.value ? l('Cancel') : "",
      rightAction: () {
        Navigator.pop(context, true);
      },
      isShowButtonClose: typeUpdateApp != TypeUpdateApp.forceUpdate.value,
    );
  }
}
