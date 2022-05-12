import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/profile/profile_screen_bloc.dart';
import 'package:sing_app/blocs/profile/profile_screen_event.dart';
import 'package:sing_app/blocs/root/root_bloc.dart';
import 'package:sing_app/blocs/select_language/select_language_bloc.dart';
import 'package:sing_app/blocs/select_language/select_language_event.dart';
import 'package:sing_app/blocs/select_language/select_language_state.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/ss_appbar.dart';


class SelectLanguageScreen extends StatefulWidget {
  const SelectLanguageScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SelectLanguageScreenState createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late SelectLanguageBloc _selectLanguageBloc;
  late ProfileScreenBloc _profileScreenBloc;

  @override
  void initState() {
    _selectLanguageBloc = BlocProvider.of<SelectLanguageBloc>(context);
    _profileScreenBloc = BlocProvider.of<ProfileScreenBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _selectLanguageBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBloc();
  }

  _buildAppBar() {
    return SSAppBar(
      isBackNavigation: true,
      showShadow: false,
      title: l('Language'),
    );
  }

  Widget _buildBloc() {
    return BlocConsumer<SelectLanguageBloc, SelectLanguageState>(
      listener: (ctx, state) {
        if(state is OnChangedLanguageState) {
          _profileScreenBloc.add(OnChangeLanguageProfileScreenEvent(langCode: state.langCode));
        }
      },
      // buildWhen: (preState, nextState) {
      //   return nextState is! UserInfoRefreshState;
      // },
      builder: (ctx, state) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: _buildAppBar(),
          body: SafeArea(
            left: false,
            right: false,
            child: _buildBody(),
          ),
        );;
      },
    );
  }

  _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        _buildRow('vn.png', 'Việt Nam', LangCode.vi),
        const SizedBox(height: 12),
        _buildRow('en.png', 'English', LangCode.en),
      ],
    );
  }

  Widget _buildRow(String icon, String title, LangCode langCode) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          border: langCode.code == _selectLanguageBloc.currentLanguageCode ? Border.all(
            color: const Color(0xFF6C34FF),
          ) : null,
          color: const Color(0xFF242B43),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        padding: const EdgeInsets.fromLTRB(20, 13, 20, 13),
        child: Row(
          children: [
            ImageUtil.loadAssetsImage(fileName: icon, width: 18, height: 12),
            const SizedBox(width: 22),
            Text(
              title,
              style: s(context, color: ColorUtil.lightGrey, fontSize: 16),
            ),
            const Spacer(),
            if(langCode.code == _selectLanguageBloc.currentLanguageCode) ImageUtil.loadAssetsImage(fileName: 'language_selected.svg'),
          ],
        ),
      ),
      onTap: () => _onTapChangeLanguage(langCode),
    );
  }

  _onTapChangeLanguage(LangCode langCode) async {
    _selectLanguageBloc.add(OnChangeLanguage(langCode: langCode));
    // Locale newLocale = langCode == LangCode.en ? const Locale('en', 'US') : const Locale('vi', 'VN');
    // MyApp.setLocale(context, newLocale);
  }
}
