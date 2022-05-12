import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sing_app/blocs/wallet_detail/wallet_detail_bloc.dart';
import 'package:sing_app/blocs/wallet_detail/wallet_detail_event.dart';
import 'package:sing_app/blocs/wallet_detail/wallet_detail_nft_bloc.dart';
import 'package:sing_app/blocs/wallet_detail/wallet_detail_nft_event.dart';
import 'package:sing_app/blocs/wallet_detail/wallet_detail_nft_state.dart';
import 'package:sing_app/blocs/wallet_detail/wallet_detail_state.dart';
import 'package:sing_app/blocs/wallet_detail/wallet_detail_token_bloc.dart';
import 'package:sing_app/blocs/wallet_detail/wallet_detail_token_event.dart';
import 'package:sing_app/blocs/wallet_detail/wallet_detail_token_state.dart';
import 'package:sing_app/config/app_config.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/models/balance.dart';
import 'package:sing_app/data/models/moralis_nft.dart';
import 'package:sing_app/event_bus/event_bus_event.dart';
import 'package:sing_app/screens/select_token_screen.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/number_format_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/routes.dart';

import '../application.dart';

class WalletDetailScreen extends StatefulWidget {
  const WalletDetailScreen({Key? key}) : super(key: key);

  @override
  _WalletDetailScreenState createState() => _WalletDetailScreenState();
}

class _WalletDetailScreenState extends State<WalletDetailScreen>
    with TickerProviderStateMixin {
  late WalletDetailBloc _walletDetailBloc;
  late WalletDetailTokenBloc _walletDetailTokenBloc;
  late WalletDetailNftBloc _walletDetailNftBloc;
  late TabController _tabController;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _refreshIndicatorKeyNft = GlobalKey<RefreshIndicatorState>();
  late Completer<void> _refreshCompleterNft;

  final _refreshIndicatorKeyToken = GlobalKey<RefreshIndicatorState>();
  late Completer<void> _refreshCompleterToken;

  late StreamSubscription _customTokenListener;
  late StreamSubscription _transferNftListener;
  late StreamSubscription _transferTokenListener;
  late StreamSubscription _changeWalletNameListener;
  @override
  void initState() {
    _walletDetailBloc = BlocProvider.of<WalletDetailBloc>(context);
    _walletDetailTokenBloc = BlocProvider.of<WalletDetailTokenBloc>(context);
    _walletDetailNftBloc = BlocProvider.of<WalletDetailNftBloc>(context);
    _refreshCompleterNft = Completer<void>();
    _refreshCompleterToken = Completer<void>();

    _customTokenListener = App.instance.eventBus.on<EventBusAddCustomTokenSuccess>().listen((event) {
      _walletDetailTokenBloc.add(WalletDetailTokenEventReload());
    });
    _transferNftListener = App.instance.eventBus.on<EventBusTransferNftSuccessful>().listen((event) {
      _walletDetailNftBloc.add(WalletDetailNftEventReload());
    });
    _transferTokenListener = App.instance.eventBus.on<EventBusTransferTokenSuccessful>().listen((event) {
      _walletDetailTokenBloc.add(WalletDetailTokenEventReload());
    });
    _changeWalletNameListener = App.instance.eventBus.on<EventBusChangeWalletNameSuccessful>().listen((event) {
      _walletDetailTokenBloc.add(ChangeWalletNameSuccessful(event.walletId, event.name));
    });

    super.initState();
  }

  @override
  void dispose() {
    _walletDetailBloc.close();
    _walletDetailTokenBloc.close();
    _walletDetailNftBloc.close();

    _customTokenListener.cancel();
    _transferNftListener.cancel();
    _transferTokenListener.cancel();
    _changeWalletNameListener.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabController = TabController(
      length: AppConfig.instance.values.nftEnable ? 2 : 1,
      initialIndex: _walletDetailBloc.selectedTabIndex(),
      vsync: this,
    );
    _tabController.addListener(_onTabChangedListener);

    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      body: SafeArea(
        left: false,
        right: false,
        child: _buildBloc(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: ColorUtil.primary,
      systemOverlayStyle: systemUiOverlayStyle,
      elevation: 0.0,
      leading: IconButton(
        icon: ImageUtil.loadAssetsImage(fileName: 'ic_back.svg'),
        tooltip: l('Back'),
        onPressed: () =>
            Navigator.of(context).pop(_walletDetailBloc.nameChanged),
      ),
      actions: [
        IconButton(
          icon: ImageUtil.loadAssetsImage(fileName: 'ic_gear.svg'),
          tooltip: l('Setting'),
          onPressed: _onTapSetting,
        )
      ],
      title: Text(l('Wallet detail')),
    );
  }

  _buildBloc() {
    return BlocConsumer<WalletDetailBloc, WalletDetailState>(
        listener: (ctx, state) {
      if (state is WalletDetailTabBarChanged) {
        if (state.index == 0) {
          if (!_walletDetailTokenBloc.isDataLoaded()) {
            _refreshIndicatorKeyToken.currentState?.show();
          } else {
            _walletDetailTokenBloc.add(WalletDetailTokenEventStart());
          }
        } else if (state.index == 1) {
          if (!_walletDetailNftBloc.isDataLoaded()) {
            _refreshIndicatorKeyNft.currentState?.show();
          } else {
            _walletDetailNftBloc.add(WalletDetailNftEventStart());
          }
        }
      }
    }, builder: (ctx, state) {
      return Column(
        children: [
          Container(
            margin: const EdgeInsets.only(
                bottom: MyStyles.horizontalMargin,
                left: MyStyles.horizontalMargin,
                right: MyStyles.horizontalMargin),
            decoration: BoxDecoration(
                color: const Color(0xFF353B4F),
                borderRadius: BorderRadius.circular(50)),
            child: Theme(
              data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: _buildTabBar(),
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _walletDetailBloc.selectedTabIndex(),
              children: getTabBarWidgetItem(state),
            ),
          ),
        ],
      );
    });
  }

  List<Widget> getTabBarWidgetItem(WalletDetailState state) {
    return [
      _buildTokenView(),
      if(AppConfig.instance.values.nftEnable)
        _buildNftView(),
    ];
  }

  Widget _buildTabBar() {
    return TabBar(
      unselectedLabelColor: const Color(0xFFBBCEFF),
      indicatorColor: Colors.transparent,
      indicator: BoxDecoration(
        color: const Color(0xFF5F667E),
        borderRadius: BorderRadius.circular(50),
      ),
      controller: _tabController,
      tabs: [
        const Tab(
          height: 36,
          child: Text(
            'Tokens',
          ),
        ),
        if(AppConfig.instance.values.nftEnable)
          const Tab(
            height: 36,
            child: Text(
              'NFT',
            ),
          ),
      ],
    );
  }

  _buildTokenView() {
    return BlocConsumer<WalletDetailTokenBloc, WalletDetailTokenState>(
        listener: (ctx, state) {
      if (state is WalletDetailTokenStateLoaded) {
        _hideRefreshIndicatorToken();
      }
      //update btc price in tab nft
      if (state is WalletDetailTokenStatePriceUpdate &&
          _tabController.index == 1) {
        _walletDetailNftBloc.add(WalletDetailNftEventTokenPriceUpdate());
      }
    }, builder: (ctx, state) {
      return RefreshIndicator(
        color: Colors.white,
        backgroundColor: ColorUtil.primary,
        key: _refreshIndicatorKeyToken,
        onRefresh: onRefreshToken,
        child: ListView.separated(
          itemCount: App.instance.availableBalances.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildSummary();
            }
            return _buildTokenItemView(index - 1);
          },
          separatorBuilder: (ctx, index) => Container(
            height: 1,
            decoration: const BoxDecoration(color: Color(0xFF413D3D)),
          ),
        ),
      );
    });
  }

  _buildNftView() {
    return BlocConsumer<WalletDetailNftBloc, WalletDetailNftState>(
        listener: (ctx, state) {
      if (state is WalletDetailNftStateLoaded) {
        _hideRefreshIndicatorNft();
      }
    }, builder: (ctx, state) {
      return RefreshIndicator(
          color: Colors.white,
          backgroundColor: ColorUtil.primary,
          key: _refreshIndicatorKeyNft,
          child: ListView.builder(
            itemCount: (_walletDetailNftBloc.listNfts.length / 2.0).ceil() + 1,
            // This creates two columns with two items in each column
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  children: [
                    _buildSummary(),
                    Container(
                      margin: const EdgeInsets.only(
                          bottom: MyStyles.horizontalMargin * 2),
                      height: 1,
                      decoration: const BoxDecoration(color: Color(0xFF413D3D)),
                    ),
                  ],
                );
              }
              final rowIndex = index - 1;
              final itemIndex1 = rowIndex * 2;
              final itemIndex2 = rowIndex * 2 + 1;
              final item1 = itemIndex1 < _walletDetailNftBloc.listNfts.length
                  ? _walletDetailNftBloc.listNfts[itemIndex1]
                  : null;
              final item2 = itemIndex2 < _walletDetailNftBloc.listNfts.length
                  ? _walletDetailNftBloc.listNfts[itemIndex2]
                  : null;
              return Padding(
                padding: const EdgeInsets.only(
                    left: MyStyles.horizontalMargin,
                    right: MyStyles.horizontalMargin,
                    bottom: MyStyles.horizontalMargin),
                child: Row(
                  children: [
                    _buildNftItemView(item1, 1),
                    _buildNftItemView(item2, 2),
                  ],
                ),
              );
            },
          ),
          onRefresh: onRefreshNft);
    });
  }

  Widget _buildNftItemView(MoralisNft? item, int position) {
    if (item == null) {
      return Container();
    }

    final size = MediaQuery.of(context).size;
    final itemWidth = size.width / 2 - MyStyles.horizontalMargin * 2;
    final itemHeight = itemWidth / (160 / 200);
    String nftTitle = '';

    if (item.externalData != null && item.externalData!.name != null) {
      nftTitle = item.externalData!.name!;
    } else if (item.tokenId != null) {
      nftTitle = item.tokenId!;
    }

    return Padding(
      padding: EdgeInsets.only(
          left: position == 1 ? 0 : MyStyles.horizontalMargin,
          right: position == 1 ? MyStyles.horizontalMargin : 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Stack(
          children: [
            Stack(
              children: [
                Container(
                  width: itemWidth,
                  height: itemHeight,
                  decoration: const BoxDecoration(color: Color(0xFF3E4357)),
                ),
                SizedBox(
                  width: itemWidth,
                  height: itemWidth,
                  child: ImageUtil.loadNetWorkImage(
                      url: item.externalData?.image ?? '',
                      height: itemWidth,
                      fit: BoxFit.cover),
                ),
              ],
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: Ink(
                  child: InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            height: 40,
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Center(
                              child: Text(
                                nftTitle,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                            )),
                      ],
                    ),
                    onTap: () => _onTapNft(item),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTokenItemView(int index) {
    final item = App.instance.availableBalances[index];
    return Material(
      child: Ink(
        decoration: const BoxDecoration(
          color: ColorUtil.primary,
        ),
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.all(MyStyles.horizontalMargin + 8),
            child: Row(
              children: [
                Container(
                  width: Constants.tokenIconSize,
                  height: Constants.tokenIconSize,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(Constants.tokenIconSize / 2),
                  ),
                  child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(Constants.tokenIconSize / 2),
                      child: _buildTokenIcon(item)),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: MyStyles.horizontalMargin,
                      right: MyStyles.horizontalMargin),
                  child: Text(
                    item.symbol,
                    style:
                        const TextStyle(color: Color(0xFFFFFFFF), fontSize: 18),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        NumberFormatUtil.tokenFormat(item.balance),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Color(0xFFFFFFFF)),
                      ),
                      Text(
                        _getDollarPrice(
                            NumberFormatUtil.tokenFormat(item.balance),
                            item.symbol),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Color(0xFFAA88D4)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          onTap: () => _onTapItemIndex(index),
        ),
      ),
    );
  }

  Widget _buildTokenIcon(Balance item) {
    if (item.tokenAddress?.isNotEmpty ?? false) {
      if (AppConfig.instance.isSingSingContract(item.tokenAddress!)) {
        return ImageUtil.loadAssetsImage(
            fileName: 'ic_singsing_token.png', height: Constants.tokenIconSize);
      }
      return ImageUtil.loadNetWorkImage(
          url:
              '$tokenIconHost${item.secretType.toLowerCase()}/${item.tokenAddress!}.png',
          height: Constants.tokenIconSize);
    } else {
      return ImageUtil.loadAssetsImage(
          fileName: tokenIcon(item.secretType),
          height: Constants.tokenIconSize);
    }
  }

  Widget _buildSummary() {
    return Container(
      margin: const EdgeInsets.only(
        left: MyStyles.horizontalMargin,
        right: MyStyles.horizontalMargin,
        bottom: MyStyles.horizontalMargin * 2,
      ),
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Color(0x40000000),
              offset: Offset(0, 4),
              blurRadius: 4,
            )
          ],
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF313544)),
      child: Column(
        children: [
          _buildBalanceText(),
          _buildSendAndReceiveButtons(),
        ],
      ),
    );
  }

  Widget _buildBalanceText() {
    return GestureDetector(
      onTap: () {
        _walletDetailBloc.add(
            WalletDetailEventShowHideBalance(!_walletDetailBloc.showBalance()));
      },
      child: Container(
        width: double.infinity,
        height: 148,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xffBF26E5), Color(0xff3C14DA)]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _walletDetailBloc.wallet.description,
                    style: const TextStyle(color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: ImageUtil.loadAssetsImage(
                        fileName: _walletDetailBloc.showBalance()
                            ? 'ic_visibility_2.svg'
                            : 'ic_visibility.svg'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                _walletDetailBloc.showBalance()
                    ? _getDollarPrice(
                        NumberFormatUtil.tokenFormat(
                            _walletDetailBloc.wallet.balance?.balance ?? 0.0),
                        _walletDetailBloc.wallet.balance?.symbol)
                    : '******',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              _walletDetailBloc.showBalance()
                  ? _getBtcPrice(
                      NumberFormatUtil.tokenFormat(
                          _walletDetailBloc.wallet.balance?.balance ?? 0.0),
                      _walletDetailBloc.wallet.balance?.symbol)
                  : '******',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.75),
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  _getDollarPrice(String? balance, String? symbol) {
    if (balance == null ||
        balance.isEmpty ||
        symbol == null ||
        symbol.isEmpty) {
      return '0';
    }

    final price = _walletDetailTokenBloc.priceTable[symbol.toUpperCase()];
    if (price == null) {
      return '';
    }
    final value = NumberFormatUtil.parse(balance);
    if (value == 0) {
      return '0';
    }

    final totalPrice = price * value;
    return '\$${NumberFormatUtil.currencyFormat(totalPrice)}';
  }

  _getBtcPrice(String? balance, String? symbol) {
    if (balance == null ||
        balance.isEmpty ||
        symbol == null ||
        symbol.isEmpty) {
      return '0';
    }

    final price = _walletDetailTokenBloc.priceTable[symbol.toUpperCase()];
    if (price == null) {
      return '';
    }
    final value = NumberFormatUtil.parse(balance);
    if (value == 0) {
      return '0';
    }

    //btc
    final btcPrice = _walletDetailTokenBloc.priceTable['BTC'];
    if (btcPrice == null) {
      return '';
    }

    final dBtcPrice = price / btcPrice;
    return '${NumberFormatUtil.tokenFormat(dBtcPrice)} BTC';
  }

  Widget _buildSendAndReceiveButtons() {
    return Padding(
      padding: const EdgeInsets.only(
          left: MyStyles.horizontalMargin,
          right: MyStyles.horizontalMargin,
          top: 4,
          bottom: 4),
      child: Row(
        children: [
          _buildButton(SelectTokenScreenType.send),
          _buildButton(SelectTokenScreenType.receive),
        ],
      ),
    );
  }

  Widget _buildButton(SelectTokenScreenType screenType) {
    return Expanded(
      child: TextButton.icon(
        onPressed: () => {
          Navigator.pushNamed(context, Routes.selectTokenScreen, arguments: {
            'type': screenType,
            'tokens': App.instance.availableBalances,
            'price_table': _walletDetailTokenBloc.priceTable,
            'wallet': _walletDetailBloc.wallet
          })
        },
        icon: SvgPicture.asset(assetImg(screenType == SelectTokenScreenType.send
            ? 'ic_send.svg'
            : 'ic_receive.svg')),
        label: Text(
          l(screenType == SelectTokenScreenType.send ? 'Send' : 'Receive'),
          style: TextStyle(
            color: const Color(0xFFFFFFFF).withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  void _onTabChangedListener() {
    if (_tabController.indexIsChanging) {
      _walletDetailBloc
          .add(WalletDetailTabBarPressedEvent(_tabController.index));
    }
  }

  _onTapSetting() async {
    final result = await Navigator.pushNamed(
        context, Routes.settingWalletScreen,
        arguments: {'wallet': _walletDetailBloc.wallet});
    if (result == true) {
      _walletDetailBloc.nameChanged = true;
      // _walletDetailBloc.add(WalletDetailEventReload());
      // _walletDetailTokenBloc.add(WalletDetailTokenEventStart());
    }
  }

  _onTapItemIndex(int index) {
    final item = App.instance.availableBalances[index];
    Navigator.pushNamed(context, Routes.tokenDetailScreen, arguments: {
      'token': item,
      'price_table': _walletDetailTokenBloc.priceTable,
    });
  }

  _onTapNft(MoralisNft item) {
    if (item.externalData == null) {
      return;
    }
    Navigator.pushNamed(context, Routes.nftDetailScreen, arguments: {
      'nft': item,
      'wallet': App.instance.currentWallet,
    });
  }

  Future<void> onRefreshNft() async {
    _walletDetailNftBloc.add(WalletDetailNftEventReload());
    return _refreshCompleterNft.future;
  }

  void _hideRefreshIndicatorNft() {
    _refreshCompleterNft.complete();
    _refreshCompleterNft = Completer();
  }

  Future<void> onRefreshToken() async {
    _walletDetailTokenBloc.add(WalletDetailTokenEventReload());
    return _refreshCompleterToken.future;
  }

  void _hideRefreshIndicatorToken() {
    _refreshCompleterToken.complete();
    _refreshCompleterToken = Completer();
  }
}
