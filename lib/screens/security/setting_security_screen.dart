import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/setting_security/setting_security_bloc.dart';
import 'package:sing_app/blocs/setting_security/setting_security_event.dart';
import 'package:sing_app/blocs/setting_security/setting_security_state.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/enum.dart';
import 'package:sing_app/manager/app_lock_manager.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/s2e_appbar.dart';

import '../../constants/constants.dart';
import '../../routes.dart';

class SettingSecurityScreen extends StatefulWidget {
  const SettingSecurityScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SettingSecurityScreenState createState() => _SettingSecurityScreenState();
}

class _SettingSecurityScreenState extends State<SettingSecurityScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late SettingSecurityBloc _settingSecurityBloc;
  // late RootBloc _rootBloc;

  @override
  void initState() {
    _settingSecurityBloc = BlocProvider.of<SettingSecurityBloc>(context);
    // _rootBloc = BlocProvider.of<RootBloc>(context);

    super.initState();
  }

  @override
  void dispose() {
    _settingSecurityBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: S2EAppBar(
        title: l('Security'),
        isBackNavigation: true,
      ),
      body: _buildBloc(),
    );
  }

  Widget _buildBloc() {
    return BlocConsumer<SettingSecurityBloc, SettingSecurityState>(
      listener: (ctx, state) {
        // if(state is ChangePasswordStateErrorSaving && state.message.isNotEmpty) {
        //   showSnackBarError(context: context, message: state.message);
        // }
      },
      builder: (ctx, state) {
        return _buildBody();
      },
    );
  }

  Widget _buildBody() {
    return Container(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(18, 10, 6, 10),
              decoration: BoxDecoration(
                color: ColorUtil.blockBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(l('App Lock'),
                      style: s(context, fontSize: 16, color: Colors.white)),
                  const Spacer(),
                  CupertinoSwitch(
                    value: AppLockManager.instance.enableAppLock,
                    onChanged: (bool value) async {
                      if(value) {
                        // enable app lock
                        await Navigator.pushNamed(context, Routes.verifyPasscodeScreen, arguments: {'is_login': false});
                        setState(() {});
                      } else {
                        await Navigator.pushNamed(
                            context, Routes.localAuthScreen, arguments: {
                          LocalAuthScreenArgs.isWaitingDisableLocalAuth: true
                        });
                        setState(() {});
                        // LoggerUtil.info('result verify code: $result');
                        // if (result is bool && result == true) {
                        //   await AppLockManager.instance.disableSecurity();
                        //   _settingSecurityBloc.add(const SettingSecurityEventAppLockChanged(enable: false));
                        // }
                      }

                    },
                  )
                ],
              ),
            ),
            if (AppLockManager.instance.enableAppLock) _buildSettingAppLock(),
          ],
        ));
  }

  Widget _buildSettingAppLock() {
    return Column(
      children: [
        const SizedBox(height: 36),
        Container(
          decoration: BoxDecoration(
            color: ColorUtil.blockBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _onTapAutoLock,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(18, 13, 6, 13),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l('Auto Lock'),
                              style: s(context, fontSize: 14, color: const Color(0xFFB1BBD2), fontWeight: FontWeight.w400)),
                          const SizedBox(height: 5),
                          Text(AppLockManager.instance.autoLockDuration.title,
                              style: s(context, fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const Spacer(),
                      const SizedBox(width: 8),
                      ImageUtil.loadAssetsImage(fileName: 'ic_arrow_right.svg'),
                      const SizedBox(width: 6)
                    ],
                  ),
                ),
              ),
              const Divider(
                color: Color(0xFF394C94),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _onTapLockMethod,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(18, 13, 6, 13),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l('Lock Method'),
                              style: s(context, fontSize: 14, color: const Color(0xFFB1BBD2), fontWeight: FontWeight.w400)),
                          const SizedBox(height: 5),
                          Text(AppLockManager.instance.unlockMethod.title,
                              style: s(context, fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const Spacer(),
                      const SizedBox(width: 8),
                      ImageUtil.loadAssetsImage(fileName: 'ic_arrow_right.svg'),
                      const SizedBox(width: 6)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 17),
        Row(
          children: [
            Text(l('Ask authentication for'),
                style:
                    s(context, color: const Color(0xFFB1BBD2), fontSize: 14)),
          ],
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.fromLTRB(18, 10, 6, 10),
          decoration: BoxDecoration(
            color: ColorUtil.blockBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Text(l('Transaction Signing'),
                  style: s(context, fontSize: 16, color: Colors.white)),
              const Spacer(),
              CupertinoSwitch(
                value: AppLockManager.instance.transactionSigning,
                onChanged: (bool value) {
                  _settingSecurityBloc.add(
                      SettingSecurityEventTransactionSigningChanged(
                          enable: value));
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  _onTapAutoLock() async {
    await Navigator.pushNamed(context, Routes.selectAutoLockTimeScreen);
    _settingSecurityBloc.add(AutoLockDurationChangedEvent(autoLockDuration: AppLockManager.instance.autoLockDuration));
  }

  _onTapLockMethod() async{
    // showSnackBar(context, message: l('Coming soon'));
    await Navigator.pushNamed(context, Routes.selectUnlockMethodScreen);
    _settingSecurityBloc.add(UnlockMethodChangedEvent(unlockMethod: AppLockManager.instance.unlockMethod));
  }
}
