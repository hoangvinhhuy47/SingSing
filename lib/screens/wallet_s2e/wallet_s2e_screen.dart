import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/wallet_s2e/in_game_wallet/in_game_wallet_screen_bloc.dart';
import 'package:sing_app/blocs/wallet_s2e/singsing_wallet/singsing_wallet_screen_bloc.dart';
import 'package:sing_app/blocs/wallet_s2e/wallet_s2e_screen_bloc.dart';
import 'package:sing_app/screens/wallet_s2e/in_game_wallet/in_game_wallet_screen.dart';
import 'package:sing_app/screens/wallet_s2e/singsing_wallet/singsing_wallet_screen.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/utils/theme_util.dart';
import '../../blocs/wallet_s2e/wallet_s2e_screen_state.dart';

class WalletS2EScreen extends StatefulWidget {
  const WalletS2EScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WalletS2EScreenState();
}

class _WalletS2EScreenState extends State<WalletS2EScreen>
    with TickerProviderStateMixin {
  late WalletS2EScreenBloc _bloc;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _tabController = TabController(
      length: 2,
      initialIndex: 0,
      vsync: this,
    );
    _tabController.addListener(_onTabChangedListener);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletS2EScreenBloc, WalletS2EScreenState>(
        builder: _buildBody, listener: (ctx, state) {});
  }

  Widget _buildBody(ctx, state) {
    return Column(
      children: [
        const SizedBox(
          height: MyStyles.horizontalMargin,
        ),
        TabBar(
          controller: _tabController,
          indicatorColor: Colors.transparent,
          tabs: [
            _buildTab(text: 'Ingame Wallet', index: 0),
            _buildTab(text: 'SingSing Wallet', index: 1),
          ],
        ),
        Expanded(
          child: IndexedStack(
            index: _tabController.index,
            children: [
              _buildInGameWalletView(),
              _buildSingSingWalletView(),
            ],
          ),
        )
      ],
    );
  }

  Tab _buildTab({required String text, required int index}) {
    return Tab(
      child: Column(
        children: [
          Text(
            text,
            style: _isTabSelected(index)
                ? _styleTabBarSelected()
                : _styleTabBarUnSelected(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Visibility(
            visible: _isTabSelected(index),
            child: Container(
              width: 16,
              height: 6,
              margin: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                  color: ColorUtil.buttonLight,
                  borderRadius: BorderRadius.circular(20)),
            ),
          )
        ],
      ),
    );
  }

  bool _isTabSelected(int index) => _tabController.index == index;

  Widget _buildInGameWalletView() {
    return BlocProvider<InGameWalletScreenBloc>(
      create: (ctx) => InGameWalletScreenBloc(),
      child: const InGameWalletScreen(),
    );
  }

  Widget _buildSingSingWalletView() {
    return BlocProvider<SingSingWalletScreenBloc>(
      create: (ctx) => SingSingWalletScreenBloc(),
      child: const SingSingWalletScreen(),
    );
  }

  TextStyle _styleTabBarUnSelected() {
    return s(context,
        fontSize: 20,
        fontWeight: MyFontWeight.regular,
        color: ColorUtil.grey300);
  }

  TextStyle _styleTabBarSelected() {
    return s(context, fontSize: 20, fontWeight: MyFontWeight.bold);
  }

  _onTabChangedListener() {
    if (_tabController.index != _tabController.previousIndex) {
      setState(() {});
    }
  }
}
