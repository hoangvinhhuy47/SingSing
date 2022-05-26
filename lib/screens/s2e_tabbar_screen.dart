import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sing_app/blocs/tabbar/tabbar_bloc.dart';
import 'package:sing_app/blocs/tabbar/tabbar_event.dart';
import 'package:sing_app/blocs/tabbar/tabbar_state.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/event_bus/event_bus_event.dart';
import 'package:sing_app/routes.dart';
import 'package:sing_app/screens/market/market_screen.dart';
import 'package:sing_app/screens/mic/mic_screen.dart';
import 'package:sing_app/screens/sing/sing_screen.dart';
import 'package:sing_app/screens/wallet_s2e/wallet_s2e_screen.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/widgets/custom_bottom_navigation/custom_bottom_navigation.dart';
import 'package:sing_app/widgets/s2e_appbar.dart';

import '../application.dart';

enum TabItem { sing, mic, wallets2e, market }

class S2ETabBarScreen extends StatefulWidget {
  static const String routeName = '/tab';

  const S2ETabBarScreen({Key? key}) : super(key: key);

  @override
  _S2ETabBarScreenState createState() => _S2ETabBarScreenState();
}

class _S2ETabBarScreenState extends State<S2ETabBarScreen> with RouteAware {
  late TabBarBloc _tabBarBloc;

  int _selectedIndex = 0;
  final imageSize = 24.0;
  late StreamSubscription _onNewNotificationListener;
  late StreamSubscription _onLoginLogoutSuccessListener;

  List<BottomNavigationDotBarItem> _getTabBarItems() {
    return [
      BottomNavigationDotBarItem(
        label: "Sing",
        icon: _buildBottomBarIcon('ic_sing.svg', false),
        activeIcon: _buildBottomBarIcon('ic_sing.svg', true),
      ),
      BottomNavigationDotBarItem(
        label: "Mic",
        icon: _buildBottomBarIcon('ic_mic.svg', false),
        activeIcon: _buildBottomBarIcon('ic_mic.svg', true),
      ),
      BottomNavigationDotBarItem(
        label: "Wallet",
        icon: _buildBottomBarIcon('ic_s2e_wallet.svg', false),
        activeIcon: _buildBottomBarIcon('ic_s2e_wallet.svg', true),
      ),
      BottomNavigationDotBarItem(
        label: "Market",
        icon: _buildBottomBarIcon('ic_market.svg', false),
        activeIcon: _buildBottomBarIcon('ic_market.svg', true),
      ),
    ];
  }

  Widget _buildBottomBarIcon(String iconName, bool isActive) {
    return Container(
      padding: const EdgeInsets.only(bottom: 4),
      child: SvgPicture.asset(
        assetImg(iconName),
        color: isActive ? ColorUtil.primary : null,
        width: imageSize,
        height: imageSize,
      ),
    );
  }

  // OVERRIDE

  @override
  void initState() {
    _tabBarBloc = BlocProvider.of<TabBarBloc>(context);
    _onNewNotificationListener = App.instance.eventBus
        .on<EventBusOnNewNotificationEvent>()
        .listen((event) {
      setState(() {});
    });
    _onLoginLogoutSuccessListener = App.instance.eventBus
        .on<EventBusLoginLogoutSuccessEvent>()
        .listen((event) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _onNewNotificationListener.cancel();
    _onLoginLogoutSuccessListener.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didPush() {}

  @override
  void didPopNext() {}

  // BUILD

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomBar(),
      appBar: S2EAppBar(
        systemOverlayStyle: systemUiOverlayStyle,
        leadWidget: _buildLeadingWidget(),
      ),
      body: BlocConsumer<TabBarBloc, TabbarState>(
        listener: (context, state) {
          if (state is TabbarChanged) {
            setState(() {
              _selectedIndex = state.index;
            });
          }
        },
        buildWhen: (preState, nextState) => nextState is TabbarChanged,
        builder: (ctx, state) {
          return IndexedStack(
            // Use IndexedStack to prevent rebuilding when switch between tabs
            index: state is TabbarChanged ? state.index : 0,
            children: getTabBarWidgetItem(context),
          );
        },
      ),
    );
  }

  Widget _buildLeadingWidget() {
    return IconButton(
      icon: ImageUtil.loadAssetsImage(
          fileName: 'ic_s2e_eth.svg', width: 32, height: 32),
      onPressed: () {
        Navigator.pushNamed(context, Routes.userProfileScreen);
      },
    );
  }

  Widget _buildBottomBar() {
    return BlocBuilder<TabBarBloc, TabbarState>(
      buildWhen: (preState, nextState) => nextState is TabbarChanged,
      builder: (ctx, state) {
        return BottomNavigationDotBar(
            selectedIndex: _selectedIndex,
            selectedItemColor: ColorUtil.primary,
            unselectedItemColor: ColorUtil.deepPurple,
            onTap: _onItemTapped,
            fontSize: 12,
            items: _getTabBarItems());
      },
    );
  }

  // METHODS

  List<Widget> getTabBarWidgetItem(BuildContext context) {
    return [
      const SingScreen(),
      const MicScreen(),
      const WalletS2EScreen(),
      const MarketScreen(),
    ];
  }

  void _onItemTapped(int index) {
    _tabBarBloc.add(TabbarPressed(index: index));
  }
}
