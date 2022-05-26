import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sing_app/blocs/sing/song_detail/song_detail_screen_bloc.dart';
import 'package:sing_app/blocs/sing/song_detail/song_detail_screen_state.dart';
import 'package:sing_app/blocs/tabbar/tabbar_bloc.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/constants/extension_constant.dart';
import 'package:sing_app/utils/alert_songdemo.dart';
import 'package:sing_app/utils/check_permisstion.dart';
import 'package:sing_app/routes.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/string_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/utils/theme_util.dart';
import 'package:sing_app/widgets/border_outline.dart';
import 'package:sing_app/widgets/hint_go_to_market_widget.dart';
import 'package:sing_app/widgets/ink_click_item.dart';
import 'package:sing_app/widgets/mic/mic_box_widget.dart';
import 'package:sing_app/widgets/radius_widget.dart';
import 'package:sing_app/widgets/s2e_appbar.dart';
import 'package:sing_app/widgets/sing/item_song.dart';

import '../../../config/app_localization.dart';
import '../../../widgets/item_row_atttributes.dart';

class SongDetailScreen extends StatefulWidget {
  const SongDetailScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SongDetailScreenState();
}

class _SongDetailScreenState extends State<SongDetailScreen> {
  late SongDetailScreenBloc _bloc;
  late TabBarBloc _tabBarBloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _tabBarBloc = BlocProvider.of(context);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SongDetailScreenBloc, SongDetailScreenState>(
        builder: (ctx, state) {
          return _buildBody();
        },
        listener: (ctx, state) {});
  }

  Widget _buildBody() {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
            horizontal: MyStyles.horizontalMargin,
            vertical: MyStyles.verticalMargin),
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildItemSong(),
            _bloc.micModel != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        _buildTextHeader('Sing to earn'),
                        _buildSingToEarn(),
                        const SizedBox(height: 32),
                        // _buildScoreRange(),
                        _buildTextHeader('Mic Equipment'),
                        _buildMicEquipment(),
                        hintGoToMarket(context,
                            text:
                                'Tips: Equip good Mic increase\nchance gain more points',
                            tabBarBloc: _tabBarBloc),
                      ])
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        _buildTextHeader('Mic Equipment'),
                        _buildMicEquipment(),
                        _buildTextHeader('Sing to earn'),
                        _buildSingToEarn(),
                        const SizedBox(height: 32),
                        // _buildScoreRange(),
                      ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSingToEarn() {
    return _bloc.micModel != null
        ? SizedBox(
            width: double.infinity,
            child: InkClickItem(
                color: ColorUtil.buttonLight,
                borderRadius: BorderRadius.circular(30),
                padding: const EdgeInsets.symmetric(vertical: 14),
                onTap: () {
                  checkPermission(
                      context,
                      () => Navigator.pushNamed(
                              context, Routes.singToEarnScreen, arguments: {
                            SingToEarnScreenArgs.songModel: _bloc.songModel
                          }));
                },
                child: Text(
                  'Sing to earn',
                  textAlign: TextAlign.center,
                  style: s(context, fontSize: 16),
                )),
          )
        : RadiusWidget(
            radius: 4,
            color: ColorUtil.backgroundSecondary,
            child: hintGoToMarket(context,
                text: 'Tips: Can\'t earn without Mic',
                tabBarBloc: _tabBarBloc));
  }

  Widget _buildItemSong() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Column(
        children: [
          ItemSong(item: _bloc.songModel),
          _buildDurationAndPlayButton(),
        ],
      ),
    );
  }

  Widget _buildScoreRange() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: ColorUtil.backgroundSecondary,
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: MyStyles.horizontalMargin, vertical: 14),
      child: Column(
        children: [
          buildItemRow(context,
              leftText: 'Score range',
              rightText: 'To Earn',
              leftStyle:
                  s(context, fontSize: 20, fontWeight: MyFontWeight.bold),
              rightStyle:
                  s(context, fontSize: 20, fontWeight: MyFontWeight.bold),
              padding: EdgeInsets.zero),
          const SizedBox(height: 20),
          const Divider(color: ColorUtil.deepPurple, thickness: 1),
          _buildItemScoreRange(type: SingScoreRangeType.bad),
          _buildItemScoreRange(type: SingScoreRangeType.great),
          _buildItemScoreRange(type: SingScoreRangeType.awesome),
          _buildItemScoreRange(type: SingScoreRangeType.perfect),
        ],
      ),
    );
  }

  Widget _buildMicEquipment() {
    return Visibility(
      visible: _bloc.micModel != null,
      replacement: BorderOutLine(
        borderRadius: BorderRadius.circular(4),
        colorOutline: ColorUtil.cyan,
        child: RadiusWidget(
          radius: 4,
          color: ColorUtil.backgroundSecondary,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Non-equip",
                  style: s(context, fontSize: 16),
                ),
                ActionChip(
                  backgroundColor: ColorUtil.primary,
                  label: Text(
                    'Add',
                    textAlign: TextAlign.center,
                    style: s(context, fontSize: 16),
                  ),
                  onPressed: () {
                    Fluttertoast.showToast(msg: 'Add');
                  },
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  avatar: const Icon(Icons.add, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
      child: MicBox(
          micModel: _bloc.micModel,
          micSize: 250,
          type: MicBoxType.micDetailSongScreen,
          onPressedButton: () {
            Fluttertoast.showToast(msg: 'Go Wallet List Item');
          }),
    );
  }

  Widget _buildTextHeader(String text) {
    return Padding(
        padding: const EdgeInsets.only(top: 32, bottom: 24),
        child: Text(text,
            style: s(context, fontSize: 24, fontWeight: MyFontWeight.bold)));
  }

  Widget _buildItemScoreRange({required SingScoreRangeType type}) {
    return buildItemRow(context,
        leftText: type.scoreRange,
        rightText: type.toEarn,
        pathIconRight:
            type != SingScoreRangeType.bad ? 'logo_singsing.svg' : '',
        iconColor: ColorUtil.yellow500);
  }

  Widget _buildDurationAndPlayButton() {
    return Container(
      color: ColorUtil.deepPurple,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: MyStyles.horizontalMargin,
                vertical: MyStyles.verticalMargin),
            child: Text(
              'Duration   - ${StringUtil.getDurationTimeInMinute(seconds: _bloc.songModel.duration)}',
              style: s(context),
            ),
          ),
          InkClickItem(
            padding: const EdgeInsets.symmetric(
                horizontal: MyStyles.horizontalMargin,
                vertical: MyStyles.verticalMargin),
            onTap: () {
              alertSongDemo(context, _bloc.songModel);
            },
            child: RichText(
                text: TextSpan(children: [
              TextSpan(text: l('Play demo song') + "  "),
              WidgetSpan(
                  child:
                      ImageUtil.loadAssetsImage(fileName: 'ic_play_song.svg'))
            ])),
          )
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return S2EAppBar(
      automaticallyImplyLeading: true,
    );
  }
}
