import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sing_app/blocs/tabbar/tabbar_bloc.dart';
import 'package:sing_app/blocs/tabbar/tabbar_event.dart';
import 'package:sing_app/blocs/tabbar/tabbar_state.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/event_bus/event_bus_event.dart';
import 'package:sing_app/routes.dart';
import 'package:sing_app/screens/forums/forum_screen.dart';
import 'package:sing_app/screens/user_profile_screen.dart';
import 'package:sing_app/screens/wallet_screen.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';

import '../application.dart';

enum TabItem { buyNft, scan, wallet, forum, userProfile }

class TabBarScreen extends StatefulWidget {
  static const String routeName = '/tab';

  const TabBarScreen({Key? key}) : super(key: key);

  @override
  _TabBarScreenState createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> with RouteAware {
  late TabBarBloc _tabBarBloc;

  int _selectedIndex = 0;
  final imageSize = 24.0;
  late StreamSubscription _onNewNotificationListener;
  late StreamSubscription _onLoginLogoutSuccessListener;

  List<BottomNavigationBarItem> _getTabBarItems() {
    return [
      // BottomNavigationBarItem(
      //   label: l('Buy NFT'),
      //   icon: SvgPicture.asset(assetImg('ic_buy_nft.svg'), width: imageSize, height: imageSize,),
      //   activeIcon: SvgPicture.asset(assetImg('ic_buy_nft.svg'), color: ColorUtil.white, width: imageSize, height: imageSize,),
      // ),
      // BottomNavigationBarItem(
      //   label: l('Scan'),
      //   icon: SvgPicture.asset(assetImg('ic_scan.svg'), width: imageSize, height: imageSize,),
      //   activeIcon: SvgPicture.asset(assetImg('ic_scan.svg'), color: ColorUtil.white, width: imageSize, height: imageSize,),
      // ),
      BottomNavigationBarItem(
        label: l('Wallet'),
        icon:_buildBottomBarIcon('ic_wallet.svg', false),
        activeIcon: _buildBottomBarIcon('ic_wallet.svg', true),
      ),
      BottomNavigationBarItem(
        label: l('Forums'),
        icon: _buildBottomBarIcon('ic_forum.svg', false),
        activeIcon: _buildBottomBarIcon('ic_forum.svg', true),
      ),
      BottomNavigationBarItem(
        label: l('Profile'),
        icon: _buildBottomBarIcon('ic_profile.svg', false),
        activeIcon: _buildBottomBarIcon('ic_profile.svg', true)
      ),

    ];
  }

  Widget _buildBottomBarIcon(String iconName, bool isActive) {
    return Container(
      padding: const EdgeInsets.only(bottom: 4),
      child: SvgPicture.asset(
        assetImg(iconName),
        color: isActive ? ColorUtil.white : null,
        width: imageSize,
        height: imageSize,
      ),
    );
  }
  // OVERRIDE

  @override
  void initState() {
    _tabBarBloc = BlocProvider.of<TabBarBloc>(context);
    _onNewNotificationListener = App.instance.eventBus.on<EventBusOnNewNotificationEvent>().listen((event) {
      setState(() {});
    });
    _onLoginLogoutSuccessListener = App.instance.eventBus.on<EventBusLoginLogoutSuccessEvent>().listen((event) {
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
      appBar: AppBar(
        backgroundColor: ColorUtil.primary,
        elevation: 0.0,
        systemOverlayStyle: systemUiOverlayStyle,
        centerTitle: true,
        title: ImageUtil.loadAssetsImage(
            fileName: 'logo_singsing_text.svg', width: 106, height: 35),
        leading: _buildLeadingWidget(),
        actions: [
          if(App.instance.isLoggedIn)
            IconButton(
              icon: ImageUtil.loadAssetsImage(
                  fileName: App.instance.hasNewNotification ?  'ic_notification_badge.svg' : 'ic_notification.svg',
                  width: 18,
                  height: 18
              ),
              onPressed: () {
                Navigator.pushNamed(context, Routes.notificationScreen);
              },
            )

        ],
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
    if(_selectedIndex == 0) {
      return IconButton(
        icon: ImageUtil.loadAssetsImage(fileName: 'ic_add.svg', width: 20, height: 20),
        onPressed: () {
          Navigator.pushNamed(context, Routes.newWalletScreen);
        },
      );
    } else if(_selectedIndex == 1 && App.instance.isLoggedIn) {
      return IconButton(
        icon: ImageUtil.loadAssetsImage(fileName: 'ic_search_forum.svg', width: 18, height: 18),
        onPressed: () {
          App.instance.eventBus.fire(EventBusNavigateToForumSearch());
        },
      );
    }

    return const SizedBox();
  }

  Widget _buildBottomBar() {
    return BlocBuilder<TabBarBloc, TabbarState>(
      buildWhen: (preState, nextState) => nextState is TabbarChanged,
      builder: (ctx, state) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: ColorUtil.appBackground,
          elevation: 0.0,
          items: _getTabBarItems(),
          currentIndex: state is TabbarChanged ? state.index : 0,
          selectedItemColor: ColorUtil.white,
          unselectedItemColor: const Color(0xFF828282),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          unselectedFontSize: 12.0,
          selectedFontSize: 12.0,
          onTap: _onItemTapped,
        );
      },
    );
  }

  // METHODS

  List<Widget> getTabBarWidgetItem(BuildContext context) {
    return [
      // const NftScreen(),
      // const ScanQrCodeScreen(),
      const WalletScreen(),
      const ForumScreen(),
      const UserProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    _tabBarBloc.add(TabbarPressed(index: index));
  }

}
