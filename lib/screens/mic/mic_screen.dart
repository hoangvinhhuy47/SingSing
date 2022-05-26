import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/mic/mic_screen_bloc.dart';
import 'package:sing_app/blocs/mic/mic_screen_state.dart';
import 'package:sing_app/blocs/tabbar/tabbar_bloc.dart';
import 'package:sing_app/blocs/tabbar/tabbar_event.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/screens/mic/components/equipment_item.dart';
import 'package:sing_app/screens/mic/components/noequipment_item.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/styles.dart';

const imageSize = 10.0;

class MicScreen extends StatefulWidget {
  const MicScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MicScreenState();
}

class _MicScreenState extends State<MicScreen> {
  late Completer<void> _refreshCompleter;
  late TabBarBloc _tabBarBloc;
  late MicScreenBloc _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _tabBarBloc = BlocProvider.of(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MicScreenBloc, MicScreenState>(builder: (ctx, state) {
      return _buildBody();
    }, listener: (ctx, state) {
      if (state is MicScreenGetEquipmentSuccessState) {
        _hideRefreshIndicator();
      }
    });
  }

  Widget _buildBody() {
    return RefreshIndicator(
      color: ColorUtil.primary,
      backgroundColor: ColorUtil.appBackground,
      onRefresh: _onRefresh,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
            horizontal: MyStyles.horizontalMargin,
            vertical: MyStyles.verticalMargin),
        children: [
          Text(
            l('Mic Equipment'),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: s(context, fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: MyStyles.horizontalMargin,
          ),
          NoEquipmentItem(
            onPressedAddEquip: () {
              _tabBarBloc.add(const TabbarPressed(index: 2));
            },
            onPressedGoMarket: () {
              _tabBarBloc.add(const TabbarPressed(index: 3));
            },
          ),
          const SizedBox(
            height: MyStyles.horizontalMargin,
          ),
          EquipmentItem(
            onPressedChangeEquip: () {
              _tabBarBloc.add(const TabbarPressed(index: 2));
            },
          ),
          const SizedBox(
            height: MyStyles.horizontalMargin,
          ),
        ],
      ),
    );
  }

  void _hideRefreshIndicator() {
    if (!_refreshCompleter.isCompleted) {
      _refreshCompleter.complete();
      _refreshCompleter = Completer();
    }
  }

  Future<void> _onRefresh() async {}
}
