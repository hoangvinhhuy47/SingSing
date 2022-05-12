import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sing_app/blocs/tabbar/tabbar_bloc.dart';
import 'package:sing_app/blocs/tabbar/tabbar_event.dart';
import 'package:sing_app/blocs/tabbar/tabbar_state.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/screens/user_profile_screen.dart';
import 'package:sing_app/screens/wallet_screen.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/logger_util.dart';

enum TabItem {
  buyNft,
  scan,
  wallet,
  userProfile
}

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
        icon: SvgPicture.asset(assetImg('ic_wallet.svg'), width: imageSize, height: imageSize,),
        activeIcon: SvgPicture.asset(assetImg('ic_wallet.svg'), color: ColorUtil.white, width: imageSize, height: imageSize,),
      ),
      BottomNavigationBarItem(
        label: l('Profile'),
        icon: SvgPicture.asset(assetImg('ic_profile.svg'), width: imageSize, height: imageSize,),
        activeIcon: SvgPicture.asset(assetImg('ic_profile.svg'), color: ColorUtil.white, width: imageSize, height: imageSize,),
      ),
    ];
  }

  // OVERRIDE

  @override
  void initState() {
    _tabBarBloc = BlocProvider.of<TabBarBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _tabBarBloc.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didPush() {
  }

  @override
  void didPopNext() {
  }

  // BUILD

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomBar(),
      appBar: AppBar(
        backgroundColor: ColorUtil.primary,
        elevation: 0.0,
        systemOverlayStyle: systemUiOverlayStyle,
        title: ImageUtil.loadAssetsImage(fileName: 'logo_singsing_text.svg', width: 106, height: 35),
        // leading: IconButton(
        //   icon: ImageUtil.loadAssetsImage(fileName: 'ic_notification.svg'),
        //   onPressed: () {  },
        // ),
        // actions: [
        //   IconButton(
        //     icon: ImageUtil.loadAssetsImage(fileName: 'ic_add.svg'),
        //     onPressed: () {  },
        //   )
        // ],
      ),
      body: BlocConsumer<TabBarBloc, TabbarState>(
        listener: (context, state) {
          if (state is TabbarChanged) {
            _selectedIndex = state.index;
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

  Widget _buildBottomBar() {
    return BlocBuilder<TabBarBloc, TabbarState>(
      buildWhen: (preState, nextState) => nextState is TabbarChanged,
      builder: (ctx, state) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: ColorUtil.primary,
          elevation: 0.0,
          items: _getTabBarItems(),
          currentIndex: state is TabbarChanged ? state.index : 0,
          selectedItemColor: ColorUtil.secondary,
          unselectedItemColor: ColorUtil.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
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
      const UserProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    LoggerUtil.info('_onItemTapped: $index $_tabBarBloc');
    if (_selectedIndex != index) {
      _tabBarBloc.add(
        TabbarPressed(index: index),
      );
    }
  }
}
