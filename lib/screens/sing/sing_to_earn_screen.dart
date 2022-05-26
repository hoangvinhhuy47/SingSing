import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/sing/sing_to_earn/sing_to_earn_screen_bloc.dart';
import 'package:sing_app/blocs/sing/sing_to_earn/sing_to_earn_screen_state.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/routes.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/lyric_util.dart';
import 'package:sing_app/widgets/dialog/custom_alert_dialog.dart';
import 'package:sing_app/widgets/ink_click_item.dart';
import 'package:sing_app/widgets/radius_widget.dart';
import 'package:sing_app/widgets/s2e_appbar.dart';

import '../../blocs/sing/sing_to_earn/sing_to_earn_screen_event.dart';
import '../../utils/string_util.dart';
import '../../utils/styles.dart';

const double photoSize = 85;

class SingToEarnScreen extends StatefulWidget {
  const SingToEarnScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SingToEarnScreenState();
}

class _SingToEarnScreenState extends State<SingToEarnScreen> {
  late SingToEarnScreenBloc _bloc;

  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _bloc.add(SingToEarnScreenDetectHeadphoneEvent());
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _bloc.add(SingToEarnScreenDecreaseCountDownTimeEvent());
      if (_bloc.timeCountDown == 0) {
        _cancelCountDown();
        _startNow();

      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
    _cancelCountDown();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SingToEarnScreenBloc, SingToEarnScreenState>(
        builder: _buildBody, listener: (context, state) {});
  }

  Widget _buildBody(BuildContext context, state) {
    return WillPopScope(
      onWillPop: () async {
        return !_bloc.isSinging;
      },
      child: Scaffold(
        appBar: _bloc.isSinging
            ? null
            : S2EAppBar(
                automaticallyImplyLeading: true,
              ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLyrics(context),
            _buildTips(context),
            _buildSongPlayView(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSongPlayView(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: ColorUtil.backgroundSecondary),
      padding: const EdgeInsets.symmetric(
          horizontal: MyStyles.horizontalMargin * 1.5,
          vertical: MyStyles.horizontalMargin * 1.5),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: ImageUtil.loadNetWorkImage(
                url: _bloc.songModel.thumbnail, height: photoSize,width: photoSize),
          ),
          const SizedBox(width: 24),
          Flexible(
            child: SizedBox(
              height: photoSize,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _bloc.songModel.name,
                    style: s(context, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _bloc.songModel.singer,
                    style: s(context, fontSize: 11, color: ColorUtil.grey300),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkClickItem(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          if (_bloc.isSinging) {
                            _endSing(forceEnd: true);
                          } else {
                            _startNow();
                          }
                        },
                        child: RadiusWidget(
                          color: _bloc.isSinging
                              ? ColorUtil.pink500
                              : ColorUtil.primary,
                          child: Text(
                            _bloc.isSinging
                                ? 'End'
                                : 'Start now (${_bloc.timeCountDown}s)',
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _bloc.isSinging,
                        child: ImageUtil.loadLottieAnimation(
                            height: 35,
                            fileName: 'assets/lottie/SoundWave.json',
                            fullPath: true),
                      ),
                      Visibility(
                        visible: _bloc.isSinging,
                        child: Text(
                          '${StringUtil.getDurationTimeInMinute(seconds: _bloc.singTime)} / ${StringUtil.getDurationTimeInMinute(seconds: _bloc.songModel.duration)}',
                          style: s(context, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTips(BuildContext context) {
    return Visibility(
      visible: _bloc.isShowTips,
      child: Container(
        decoration: const BoxDecoration(color: ColorUtil.deepPurple),
        padding: const EdgeInsets.symmetric(
            horizontal: MyStyles.horizontalMargin,
            vertical: MyStyles.verticalMargin),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tips: Recommend use good\nheadphone for best experience',
              style: s(context, fontSize: 16).copyWith(height: 2),
            ),
            InkClickItem(
              borderRadius: BorderRadius.circular(12),
              padding: const EdgeInsets.all(24),
              onTap: _hideTips,
              child: ImageUtil.loadAssetsImage(
                  fileName: 'ic_close_dialog_white.svg'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLyrics(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
            horizontal: MyStyles.horizontalMargin, vertical: 50),
        child: Text(
          _bloc.songModel.lyric,
          style: s(context, fontSize: 28),
        ),
      ),
    );
  }

  void _hideTips() {
    _bloc.add(const SingToEarnScreenUpdateIsShowTipsEvent(isShowTips: false));
  }

  void _startNow() {
    _hideTips();
    _bloc.add(const SingToEarnScreenUpdateIsSingingEvent(isSinging: true));
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _bloc.add(SingToEarnScreenIncreaseSingTimeEvent());
      if (_bloc.singTime >= (_bloc.songModel.duration)) {
        _cancelCountDown();
        _endSing();
      }
    });
    _loadSongLyric();
  }

  void _endSing({bool forceEnd = false}) {
    if (forceEnd) {
      CustomAlertDialog.show(context,
          content:
              'Do you want to end singing early and go to AI assessment now ? It might effect your final score',
          leftText: 'Yes',
          isShowButtonClose: false,
          isShowTitle: false,
          rightText: 'No',
          isRightPositive: true, rightAction: () {
        Navigator.pop(context);
      }, leftAction: () {
        Navigator.pop(context);
        _navigateToCalculateScore();
      });
    } else {
      _navigateToCalculateScore();
    }
  }

  void _navigateToCalculateScore() {
    Navigator.pushNamedAndRemoveUntil(context, Routes.calculateScoreS2EScreen,
        (r) => r.settings.name == Routes.songDetailScreen,
        arguments: {SingToEarnScreenArgs.songModel: _bloc.songModel});
  }

  void _cancelCountDown() {
    _countdownTimer?.cancel();
  }

  Future<void> _loadSongLyric() async {
    final lyrics = await LyricUtil.loadSongLyric(context: context, filePath: 'assets/files/test_lyric.txt');

  }
}
