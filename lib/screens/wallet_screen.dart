import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sing_app/blocs/root/root_bloc.dart';
import 'package:sing_app/blocs/root/root_event.dart';
import 'package:sing_app/blocs/wallet/wallet_screen_bloc.dart';
import 'package:sing_app/blocs/wallet/wallet_screen_event.dart';
import 'package:sing_app/blocs/wallet/wallet_screen_state.dart';
import 'package:sing_app/data/event_bus/event_bus_event.dart';
import 'package:sing_app/routes.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/logger_util.dart';
import 'package:sing_app/utils/number_format_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/login_register_view.dart';

import '../application.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late RootBloc _rootBloc;
  late WalletScreenBloc _walletScreenBloc;

  static const tokenIconSize = 50.0;
  static const listItemHeight = 91.0;
  static const itemBorderRadius = 12.0;

  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  late Completer<void> _refreshCompleter;

  late StreamSubscription _changeWalletNameListener;
  late StreamSubscription _onChangedLanguageListener;

  @override
  void initState() {
    _rootBloc = BlocProvider.of<RootBloc>(context);
    _walletScreenBloc = BlocProvider.of<WalletScreenBloc>(context);
    _refreshCompleter = Completer<void>();
    App.instance.eventBus.on<EventBusNewWalletCreatingSuccessful>().listen((event) {
      if(App.instance.isLoggedIn){
        _refreshIndicatorKey.currentState?.show();
      } else {
        _walletScreenBloc.add(WalletScreenEventReload());
      }
    });

    _changeWalletNameListener = App.instance.eventBus.on<EventBusChangeWalletNameSuccessful>().listen((event) {
      _walletScreenBloc.add(ChangeWalletNameSuccessful(event.walletId, event.name));
    });

    _onChangedLanguageListener = App.instance.eventBus.on<EventChangedLanguage>().listen((event) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _walletScreenBloc.close();
    _changeWalletNameListener.cancel();
    _onChangedLanguageListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletScreenBloc, WalletScreenState>(
      listener: (ctx, state) {
        if(state is WalletScreenStateUserInfoFetched){
          _hideRefreshIndicator();
        }
      },
      // buildWhen: (preState, nextState) {
      //   return nextState is! UserInfoRefreshState;
      // },
      builder: (ctx, state) {
        LoggerUtil.info('WalletScreen build state: $state');
        if(state is WalletScreenStateInitial || (state is WalletScreenStateLoading && state.showLoading)){
          return const SpinKitRing(
            color: Colors.white,
            lineWidth: 2,
            size: 32,
          );
        } else {
          if(App.instance.isLoggedIn || _walletScreenBloc.localWallets.isNotEmpty){
            return _buildAuthView();
          } else {
            return _buildUnAuthView();
          }
        }
      },
    );
  }

  _buildUnAuthView(){
    return LoginRegisterView(
      onLoginPressed: (){
        _rootBloc.add(ShowLoginPopupEvent());
      },
      onRegisterPressed: (){
        _rootBloc.add(ShowRegistrationPopupEvent());
      },
      onSettingsPressed: (){
        Navigator.pushNamed(context, Routes.unauthSettingsScreen);
      },
    );
  }

  _buildAuthView(){
    return RefreshIndicator(
        color: Colors.white,
        backgroundColor: ColorUtil.primary,
        key: _refreshIndicatorKey,
        child: ListView.separated(
          itemCount: _walletScreenBloc.wallets.length + _walletScreenBloc.localWallets.length,
          padding: const EdgeInsets.symmetric(horizontal: MyStyles.horizontalMargin, vertical: MyStyles.horizontalMargin),
          itemBuilder: (context, index) {
            return _buildListViewItem(index);
          },
          separatorBuilder: (ctx, index) => Container(
            height: MyStyles.horizontalMargin,
          ),
        ),
        onRefresh: onRefresh
    );
  }

  _buildListViewItem(int index){
    return Container(
      height: listItemHeight,
      decoration: BoxDecoration(
        color: const Color(0xFF242B43),
        borderRadius: BorderRadius.circular(itemBorderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(itemBorderRadius),
        child: Material(
          child: Ink(
            decoration: const BoxDecoration(
              color: ColorUtil.primary,
            ),
            child: InkWell(
              child: _buildListViewItemContent(index),
              onTap: () => onTapWalletItem(index),
            ),
          ),
        ),
      ),
    );
  }

  _buildListViewItemContent(int index){
    final item = _walletScreenBloc.getWallet(index);

    return Padding(
      padding: const EdgeInsets.all(MyStyles.horizontalMargin),
      child: Row(
        children: [
          Container(
            width: tokenIconSize,
            height: tokenIconSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(tokenIconSize/2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(tokenIconSize/2),
              child: ImageUtil.loadAssetsImage(
                  fileName: chainIcon(item.secretType), height: tokenIconSize),
            ),
          ),
          Expanded(
              child: Padding(padding: const EdgeInsets.only(left: MyStyles.horizontalMargin, right: MyStyles.horizontalMargin),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(child: Text(item.description,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontSize: 20),
                        ),),
                        const SizedBox(width: 5,),
                        _buildWalletTag(item.isLocal),
                      ],
                    ),
                    Text(item.balance != null ? '${NumberFormatUtil.tokenFormat(item.balance!.balance)} ${item.balance!.symbol}' : '0',
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),),
                  ],
                ),
              ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletTag(bool isLocal){
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 10,
    );
    const radius = 10.0;
    const padding = EdgeInsets.symmetric(horizontal: 7, vertical: 3);
    if(isLocal){
      return Container(
        child: const Text('CryptoWallet', style: textStyle,),
        padding: padding,
        decoration: BoxDecoration(
          color: ColorUtil.blockBg,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
    } else {
      return Container(
        padding: padding,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: ColorUtil.defaultGradientButton),
          borderRadius: BorderRadius.circular(radius),
        ),
        child: const Text('SingSingWallet', style: textStyle),
      );
    }
  }


  Future<void> onRefresh() async {
    _walletScreenBloc.add(WalletScreenEventReload());
    return _refreshCompleter.future;
  }
  void _hideRefreshIndicator() {
    _refreshCompleter.complete();
    _refreshCompleter = Completer();
  }

  void onTapWalletItem(int index) {
    App.instance.currentWallet = _walletScreenBloc.getWallet(index);
    App.instance.allBalances = [];
    App.instance.availableBalances = [];
    Navigator.pushNamed(context, Routes.walletDetailScreen, arguments: {'wallet': _walletScreenBloc.getWallet(index)},);
  }
}



