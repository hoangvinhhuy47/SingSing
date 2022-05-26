import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/root/root_bloc.dart';
import 'package:sing_app/blocs/root/root_event.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/storage_utils.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/buttons/gradient_button.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map> data = [
    {
      'description': 'Music\nNFT Made Easy',
      'image': 'intro_music_nft.png',
    },
    {
      'description': 'Join & Empower\nYour Artist',
      'image': 'intro_join.png',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: false,
          bottom: false,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(assetImg("bg_intro.png")),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Center(
                  child: Column(
                    children: [
                      ImageUtil.loadAssetsImage(
                        fileName: 'logo_singsing_purple.png',
                        width: 150,
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 25),
                      ImageUtil.loadAssetsImage(fileName: 'text_singsing.svg'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: MyStyles.horizontalMargin),
                  child: _buildStartButton(),
                ),
                // Expanded(
                //   child: _buildIntroList(),
                // ),
                // _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIntroList() {
    final listIntroScreen = Iterable<Widget>.generate(
      data.length,
      (index) {
        return _buildPhoneIntroScreen(index);
      },
    ).toList();

    return PageView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: data.length,
      onPageChanged: (int page) {
        _onPageChanged(page);
      },
      controller: _pageController,
      itemBuilder: (context, index) {
        return IndexedStack(
          index: index,
          children: listIntroScreen,
        );
      },
    );
  }

  Widget _buildFooter() {
    const double phonePadding = 24;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: phonePadding,
        left: phonePadding,
        right: phonePadding,
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: _buildIntroFooterBar(),
      ),
    );
  }

  Widget _buildStartButton() {
    return DefaultGradientButton(
      text: l('JOIN NOW'),
      titleStyle: s(
        context,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      onPressed: () => _onTapStart(),
    );
  }

  void _onTapStart() async {
    await StorageUtils.setBool(key: Constants.isFirstLaunchKey, value: false);
    BlocProvider.of<RootBloc>(context).add(
      HideIntroScreen(),
    );
  }

  Widget _buildIntroFooterBar() {
    return SizedBox(
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildIndicator(),
        ],
      ),
    );
  }

  Widget _buildIndicator() {
    final List<Widget> list = [];
    for (int i = 0; i < data.length; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return Row(
      children: list,
    );
  }

  Widget _indicator(bool isActive) {
    double indicatorWidth = 12; //isActive ? 15 : 6;
    double indicatorHeight = 12;

    return AnimatedContainer(
      duration: const Duration(microseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: indicatorWidth,
      height: indicatorHeight,
      decoration: BoxDecoration(
        gradient: isActive
            ? const LinearGradient(
                colors: [Color(0xFFBF26E5), Color(0xFF3C14DA)])
            : null,
        shape: BoxShape.circle,
        border: Border.all(
          width: 1,
          color: const Color(0xFF3C14DA),
          style: BorderStyle.solid,
        ),
      ),
    );
  }

  void _onPageChanged(int page) {
    _currentPage = page;
    setState(() {});
  }

  Widget _buildPhoneIntroScreen(int index) {
    Map item = data[index];

    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageUtil.loadAssetsImage(
            fileName: item['image'],
            fit: BoxFit.fitWidth,
          ),
          const SizedBox(height: 20),
          Text(
            item['description'],
            textAlign: TextAlign.center,
            style: s(
              context,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 20),
          if (index == data.length - 1)
            _buildStartButton()
          else
            Container(height: 48)
        ],
      ),
    );
  }
}
