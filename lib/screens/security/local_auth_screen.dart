import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sing_app/blocs/local_auth/local_auth_bloc.dart';
import 'package:sing_app/blocs/local_auth/local_auth_event.dart';
import 'package:sing_app/blocs/local_auth/local_auth_state.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/enum.dart';
import 'package:sing_app/constants/extension_constant.dart';
import 'package:sing_app/manager/app_lock_manager.dart';
import 'package:sing_app/routes.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/logger_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/passcode_keyboard.dart';
import 'package:sing_app/widgets/shake_widget.dart';
import 'package:sing_app/widgets/s2e_appbar.dart';
// import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth_ios/types/auth_messages_ios.dart';
import 'package:local_auth_android/types/auth_messages_android.dart';

import '../../constants/constants.dart';


class LocalAuthScreen extends StatefulWidget {

  const LocalAuthScreen({Key? key}) : super(key: key);

  @override
  _LocalAuthScreenState createState() => _LocalAuthScreenState();
}

class _LocalAuthScreenState extends State<LocalAuthScreen> with WidgetsBindingObserver{
  final tag = 'LocalAuthScreen';
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late LocalAuthBloc _localAuthBloc;
  // late RootBloc _rootBloc;
  final shakeKey = GlobalKey<ShakeWidgetState>();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    LoggerUtil.info('didChangeAppLifecycleState state: $state', tag: tag);
    if (state == AppLifecycleState.paused) {
      _popLocalAuthScreen();
    }

  }


  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _localAuthBloc = BlocProvider.of<LocalAuthBloc>(context);
    // _rootBloc = BlocProvider.of<RootBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    LoggerUtil.info('LocalAuthScreen dispose');
    _localAuthBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: S2EAppBar(
            title: l('Login'),
            isBackNavigation: _localAuthBloc.isWaitingDisableLocalAuthSetting
        ),
        body: WillPopScope(
          onWillPop: () async {
            return _localAuthBloc.canBack;
          },
          child: _buildBloc(),
        )

    );
  }

  Widget _buildBloc() {
    return BlocConsumer<LocalAuthBloc, LocalAuthState>(
      listener: (ctx, state) {
        LoggerUtil.info('listener state: $state');
        if(state is LoginPasscodeFailState) {
          shakeKey.currentState?.shake();
        }
        if(state is OnLoginSuccessState) {
          if(_localAuthBloc.isWaitingDisableLocalAuthSetting) {
            AppLockManager.instance.disableSecurity();
          }
          _popLocalAuthScreen();
        }
        if(state is CheckingTouchIdState || state is ShowDialogAuthBiometricState) {
          _showAuthTouchID();
        }

      },
      // buildWhen: (ctx, state) {
      //   return true;
      // },
      builder: (ctx, state) {
        return _buildBody();
      },
    );
  }

  _showAuthTouchID() async {
    var localAuth = LocalAuthentication();

    if(AppLockManager.instance.canCheckBiometrics) {
      try {
        final iosStrings = IOSAuthMessages(
            cancelButton: l('Passcode'),
            goToSettingsButton: l('Settings'),
            goToSettingsDescription: l('Please set up your Touch ID.'),
            lockOut: l('Please reenable your Touch ID')
        );

        final androidStrings = AndroidAuthMessages(
          signInTitle: l('Authentication required'),
          biometricRequiredTitle: l(''),
          biometricHint: '',
          cancelButton: l('Passcode'),
          goToSettingsButton: l('Settings'),
          goToSettingsDescription: l('Please set up your Touch ID'),
        );

        LoggerUtil.info('show auth touch id');
        bool didAuthenticate = await localAuth.authenticate(
            localizedReason: l('Logging in with Touch ID'),
            options: const AuthenticationOptions(
              useErrorDialogs: false,
              biometricOnly: true,
            ),
            authMessages: [iosStrings, androidStrings]
            // biometricOnly: true,
            // useErrorDialogs: false,
            // iOSAuthStrings: iosStrings,
            // androidAuthStrings: androidStrings
        );
        LoggerUtil.info('didAuthenticate: $didAuthenticate');
        if(didAuthenticate) {
          // if(Navigator.canPop(context)) {
          //   Navigator.pop(context);
          // }
          // if(Platform.isAndroid) {
          //   if(Navigator.canPop(context)) {
          //     Navigator.pop(context);
          //   }
          // }
          AppLockManager.instance.isLocalAuthSuccess = true;
          if(_localAuthBloc.isWaitingDisableLocalAuthSetting) {
            AppLockManager.instance.disableSecurity();
          }
          _popLocalAuthScreen();

        } else {
          // emit(LoginPasscodeFailState());
        }

      } on PlatformException catch (e) {
        LoggerUtil.error('local auth error: ${e.message}');
        // if (e.code == auth_error.notAvailable) {
          // Handle this exception here.
        // }
      }
    }
  }

  void _popLocalAuthScreen() {

    Navigator.popUntil(context, (route) {
      LoggerUtil.info('popUntil route.settings.name: ${route.settings.name}', tag: tag);
      if(route.settings.name != Routes.localAuthScreen){
        if(route.settings.arguments != null) {
          (route.settings.arguments as Map<String,dynamic>)[LocalAuthScreenSettingArgs.isPasscodeCorrect.value] = true;
        }

        return true;
      }
      return false;
    });
  }

  Widget _buildBody() {
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
          children: [
            if(Platform.isAndroid && AppLockManager.instance.unlockMethod == UnlockMethod.passcodeAndTouchId) Row(
              children: [
                const Spacer(),
                _buildBtnFingerprint(),
                const SizedBox(width: 30),
              ],
            ),
            SizedBox(height: Platform.isAndroid ? 120 : 150),
            Text(
                l('Enter your passcode'),
                style: s(context, fontSize: 16, color: Colors.white)
            ),
            const SizedBox(height: 40),
            ShakeWidget(
              key: shakeKey,
              shakeOffset: 10,
              child: _buildPasscodeRow(),
            ),
            const Spacer(),
            PasscodeKeyboard(
              onPressedKey: (keyNumber) {
                _localAuthBloc.add(OnTapKeyboardNumberEvent(number: keyNumber));
              },
            ),
          ],
        ));
  }

  Widget _buildBtnFingerprint() {
    return Material(
      child: Ink(
        child: InkWell(
          child: ImageUtil.loadAssetsImage(
              fileName: 'ic_fingerprint.svg',
              color: Colors.white
          ),
          onTap: () => {
            _showAuthTouchID()
          },
        ),
      ),
    );
  }

  Widget _buildPasscodeRow() {
    int dotCount = _localAuthBloc.checkPasscode.length;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 44),
        for(var i = 0; i < dotCount; i++) _buildDot(),
        for(var i = dotCount; i < 6; i++) _buildDash(),
      ],
    );
  }

  Widget _buildDot() {
    return Container(
      margin: const EdgeInsets.all(10),
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFC4C4C4)),
    );
  }

  Widget _buildDash() {
    return Container(
      margin: const EdgeInsets.all(10),
      width: 24,
      height: 5,
      decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white),
    );
  }
}
