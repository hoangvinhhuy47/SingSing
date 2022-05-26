import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/wallet_s2e/in_game_wallet/in_game_wallet_screen_bloc.dart';
import 'package:sing_app/blocs/wallet_s2e/in_game_wallet/in_game_wallet_screen_state.dart';
import 'package:sing_app/blocs/wallet_s2e/in_game_wallet/items/items_tab_bloc.dart';
import 'package:sing_app/blocs/wallet_s2e/in_game_wallet/items/items_tab_event.dart';
import 'package:sing_app/blocs/wallet_s2e/in_game_wallet/points/points_tab_bloc.dart';
import 'package:sing_app/blocs/wallet_s2e/in_game_wallet/points/points_tab_event.dart';
import 'package:sing_app/screens/wallet_s2e/in_game_wallet/items_tab.dart';
import 'package:sing_app/screens/wallet_s2e/in_game_wallet/points_tab.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/styles.dart';

class InGameWalletScreen extends StatefulWidget {
  const InGameWalletScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InGameWalletScreenState();
}

class _InGameWalletScreenState extends State<InGameWalletScreen>
    with TickerProviderStateMixin {
  late InGameWalletScreenBloc _bloc;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(_tabControllerListener);
  }

  void _tabControllerListener() {
    if(_tabController.indexIsChanging){
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InGameWalletScreenBloc, InGameWalletScreenState>(
        builder: (ctx, state) {
          return _buildBody(ctx, state);
        },
        listener: (ctx, state) {});
  }

  Widget _buildBody(BuildContext ctx, InGameWalletScreenState state) {
    return Column(
      children: [
        Container(
          margin:
              const EdgeInsets.symmetric(horizontal: MyStyles.horizontalMargin),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: ColorUtil.backgroundSecondary),
          child: TabBar(
              indicator: BoxDecoration(
                color: ColorUtil.deepPurple,
                borderRadius: BorderRadius.circular(50),
              ),
              controller: _tabController,
              indicatorColor: Colors.transparent,
              tabs: const [
                Tab(height: 36, child: Text('Points')),
                Tab(height: 36, child: Text('Items')),
              ]),
        ),
        Expanded(
          child: IndexedStack(
             index: _tabController.index,
              children: [
                _buildPointsTab(),
                _buildItemsTab(),
              ]),
        )
      ],
    );
  }

  Widget _buildPointsTab() {
    return BlocProvider<PointsTabBloc>(
      create: (ctx) => PointsTabBloc()..add(PointTabStartedEvent()),
      child: const PointsTab(),
    );
  }

  Widget _buildItemsTab() {
    return BlocProvider<ItemsTabBloc>(
      create: (ctx) => ItemsTabBloc()..add(ItemsTabStartedEvent()),
      child: const ItemsTab(),
    );
  }
}
