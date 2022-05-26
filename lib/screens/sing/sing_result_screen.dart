import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/sing/sing_result/sing_result_screen_bloc.dart';
import 'package:sing_app/blocs/sing/sing_result/sing_result_screen_state.dart';
import 'package:sing_app/blocs/tabbar/tabbar_bloc.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/utils/theme_util.dart';
import 'package:sing_app/widgets/item_row_atttributes.dart';
import 'package:sing_app/widgets/s2e_appbar.dart';

import '../../widgets/divider_dash.dart';
import '../../widgets/hint_go_to_market_widget.dart';
import '../../widgets/sing/item_song.dart';

class SingResultScreen extends StatefulWidget {
  const SingResultScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SingResultScreenState();
}

class _SingResultScreenState extends State<SingResultScreen> {
  late SingResultScreenBloc _bloc;
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
    return BlocConsumer<SingResultScreenBloc, SingResultScreenState>(
        builder: _buildBody, listener: (context, state) {});
  }

  Widget _buildBody(BuildContext context, SingResultScreenState state) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              ItemSong(item: _bloc.songModel, isResult: true,horizontalPadding: 32,),
              const SizedBox(height: 24),
              Text(
                'Awesome!!!', //todo update this data
                style: s(context, fontWeight: MyFontWeight.bold, fontSize: 28),
              ),
              buildItemRow(
                context,
                leftText: 'Your Total Score',
                rightText: '72',
                //todo update this data
                leftStyle: s(context, fontSize: 20, color: ColorUtil.grey100),
                rightStyle: s(context,
                    fontSize: 36,
                    color: ColorUtil.grey100,
                    fontWeight: MyFontWeight.bold),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 34),
              ),
              const Divider(color: ColorUtil.deepPurple),
              const SizedBox(height: 8),
              buildItemRow(context,
                  leftText: 'Your Total Earn',
                  rightText: '10',
                  //todo update this data
                  pathIconRight: 'logo_singsing.svg',
                  iconColor: ColorUtil.yellow500,
                  iconSize: 24,
                  leftStyle: s(context, fontSize: 20, color: ColorUtil.grey100),
                  rightStyle: s(context,
                      fontSize: 36,
                      color: ColorUtil.grey100,
                      fontWeight: MyFontWeight.bold),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  positionIconRight: false),
              const Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                child: DividerDash(),
              ),
              buildItemRow(
                context,
                leftText: 'Score Earn',
                rightText: '8',
                //todo update this data
                leftStyle: s(context, fontSize: 16, color: ColorUtil.grey100),
                rightStyle: s(context,
                    fontSize: 24,
                    color: ColorUtil.grey100,
                    fontWeight: MyFontWeight.bold),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 6),
              ),
              buildItemRow(
                context,
                leftText: 'Bonus (Equip mic)',
                rightText: '+ 2',
                //todo update this data
                leftStyle: s(context, fontSize: 16, color: ColorUtil.grey100),
                rightStyle: s(context,
                    fontSize: 24,
                    color: ColorUtil.grey100,
                    fontWeight: MyFontWeight.bold),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 6),
              ),
              const SizedBox(height: 16),
              const Divider(color: ColorUtil.deepPurple),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: MyStyles.horizontalMargin),
                child: hintGoToMarket(context,
                    text:
                        ' Tips: Equip good Mic increase\nbonus Sing score & Token to earn',
                    tabBarBloc: _tabBarBloc),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return S2EAppBar(
      leadWidget: IconButton(
        icon: ImageUtil.loadAssetsImage(fileName: 'btn_close.svg'),
        tooltip: 'Close',
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
