import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/unauth_settings/unauth_settings_bloc.dart';
import 'package:sing_app/blocs/unauth_settings/unauth_settings_event.dart';
import 'package:sing_app/blocs/unauth_settings/unauth_settings_state.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/s2e_appbar.dart';

import '../../application.dart';
import '../../data/event_bus/event_bus_event.dart';
import '../../routes.dart';

class UnauthSettingsScreen extends StatefulWidget {
  final tag = 'UnauthSettingsScreen';

  const UnauthSettingsScreen({Key? key}) : super(key: key);

  @override
  _UnauthSettingsScreenState createState() => _UnauthSettingsScreenState();
}

class _UnauthSettingsScreenState extends State<UnauthSettingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late UnauthSettingsBloc _unauthSettingsBloc;

  late StreamSubscription _onChangedLanguageListener;

  @override
  void initState() {
    _unauthSettingsBloc = BlocProvider.of<UnauthSettingsBloc>(context);
    _onChangedLanguageListener =
        App.instance.eventBus.on<EventChangedLanguage>().listen((event) {
          _unauthSettingsBloc.add(OnChangedLanguageEvent(langCode: event.langCode));
        });
    super.initState();
  }

  @override
  void dispose() {
    _unauthSettingsBloc.close();
    _onChangedLanguageListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBloc();
  }

  Widget _buildBloc() {
    return BlocConsumer<UnauthSettingsBloc, UnauthSettingsState>(
      listener: (ctx, state) {},
      // buildWhen: (preState, nextState) {
      //   return nextState is! UserInfoRefreshState;
      // },
      builder: (ctx, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          key: _scaffoldKey,
          appBar: S2EAppBar(
            isBackNavigation: true,
            title: l('Settings'),
          ),
          body: SafeArea(
            left: false,
            right: false,
            child: _buildBody(),
          ),
        );
        // return _buildBody();
      },
    );
  }

  Widget _buildBody() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        children: [
          _buildListViewItem(
            icon: AppLocalization.instance.currentLangCode == LangCode.en
                ? 'en.png'
                : 'vn.png',
            title: l('Language'),
            iconColor: null,
            onPressed: () async {
              Navigator.pushNamed(context, Routes.selectLanguageScreen);
            },
          ),
          _buildListViewItem(
            icon: 'ic_security.svg',
            title: l('Security'),
            onPressed: () async {
              Navigator.pushNamed(context, Routes.settingSecurityScreen);
            },
          ),
        ],
      ),
    );
  }

  _buildListViewItem(
      {required String icon,
        required String title,
        required void Function() onPressed,
        bool rightArrow = true,
        Color? iconColor = ColorUtil.lightGrey}) {
    return Material(
      child: Ink(
        decoration: const BoxDecoration(
          color: ColorUtil.primary,
        ),
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.only(
                left: MyStyles.horizontalMargin,
                top: MyStyles.horizontalMargin,
                bottom: MyStyles.horizontalMargin,
                right: MyStyles.horizontalMargin / 2),
            child: Row(
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: ImageUtil.loadAssetsImage(
                      fileName: icon,
                      height: 18,
                      color: iconColor,
                      fit: BoxFit.scaleDown),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: MyStyles.horizontalMargin,
                        right: MyStyles.horizontalMargin),
                    child: Text(
                      title,
                      style: const TextStyle(
                          color: ColorUtil.lightGrey, fontSize: 16),
                    ),
                  ),
                ),
                if (rightArrow)
                  ImageUtil.loadAssetsImage(
                      fileName: 'ic_arrow_right.svg',
                      color: ColorUtil.lightGrey),
              ],
            ),
          ),
          onTap: onPressed,
        ),
      ),
    );
  }
}
