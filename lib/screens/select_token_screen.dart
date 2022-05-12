import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/select_token/select_token_bloc.dart';
import 'package:sing_app/blocs/select_token/select_token_event.dart';
import 'package:sing_app/blocs/select_token/select_token_state.dart';
import 'package:sing_app/config/app_config.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/models/balance.dart';
import 'package:sing_app/data/models/wallet.dart';
import 'package:sing_app/routes.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/logger_util.dart';
import 'package:sing_app/utils/number_format_util.dart';
import 'package:sing_app/utils/styles.dart';

import '../application.dart';

enum SelectTokenScreenType {
  send,
  receive,
}

class SelectTokenScreen extends StatefulWidget {
  final SelectTokenScreenType screenType;
  // final List<Balance> tokens;
  final Map<String, double> priceTable;
  // final Wallet wallet;
  const SelectTokenScreen({
    Key? key,
    required this.screenType,
    required this.priceTable,
    // required this.wallet,
  }) : super(key: key);

  @override
  _SelectTokenScreenState createState() => _SelectTokenScreenState();
}

class _SelectTokenScreenState extends State<SelectTokenScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late SelectTokenBloc _selectTokenBloc;

  static const listItemHeight = 84.0;
  static const itemBorderRadius = 16.0;

  @override
  void initState() {
    _selectTokenBloc = BlocProvider.of<SelectTokenBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _selectTokenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // appBar: _buildAppBar(),
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
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: ImageUtil.loadAssetsImage(fileName: 'ic_search.svg'),
          tooltip: l('Search'),
          onPressed: () => {
            _selectTokenBloc.add(OnTapBtnSeachEvent())
            // _selectTokenBloc.isSearching = _selectTokenBloc.isSearching;
          },
        )
      ],
      title: _selectTokenBloc.isSearching
          ? _buildSearchTextField()
          : Text(widget.screenType == SelectTokenScreenType.send
              ? l('Select Token')
              : l('Receive Token')),
    );
  }

  Widget _buildSearchAppBar() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        IconButton(
          icon: ImageUtil.loadAssetsImage(fileName: 'ic_back.svg'),
          tooltip: l('Back'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        _selectTokenBloc.isSearching ? _buildSearchTextField() : _buildTitle(),
        IconButton(
          iconSize: 15,
          padding: const EdgeInsets.all(2),
          splashRadius: 20,
          icon: ImageUtil.loadAssetsImage(fileName: _selectTokenBloc.isSearching ? 'ic_close_dialog_white.svg' : 'ic_search.svg'),
          tooltip: l('Search'),
          onPressed: () => {
            _selectTokenBloc.add(OnTapBtnSeachEvent())
            // _selectTokenBloc.isSearching = _selectTokenBloc.isSearching;
          },
        )
      ],
    );
  }

  Widget _buildSearchTextField() {
    return Flexible(
      child: TextField(
        maxLines: 1,
        decoration: const InputDecoration(
          fillColor: Color(0xFF242B43),
          filled: true,
          hintText: 'Search',
          contentPadding: EdgeInsets.fromLTRB(15, 0, 10, 0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(width: 1, color: Colors.transparent),
          ),
          border: OutlineInputBorder(
              // borderSide: BorderSide(color: Color(0xFF413D3D))
              ),
          // suffixIcon: IconButton(
          //     onPressed: () {
          //
          //     },
          //     icon: ImageUtil.loadAssetsImage(fileName: 'ic_search_setting_wallet.svg'))
        ),
        style: s(context, color: Colors.white, fontSize: 14),
        onChanged: (text) {
          _selectTokenBloc.add(OnTextSearchChangedEvent(text: text));
        },
      ),
    );
  }

  Widget _buildTitle() {
    return Expanded(
      child: Text(
        widget.screenType == SelectTokenScreenType.send
            ? l('Select Token')
            : l('Receive Token'),
        textAlign: TextAlign.center,
        style: s(context, color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget _buildBloc() {
    return BlocConsumer<SelectTokenBloc, SelectTokenState>(
      listener: (ctx, state) {
        // LoggerUtil.info('setting wallet screen state: $state');
      },
      // buildWhen: (preState, nextState) {
      //   return nextState is! UserInfoRefreshState;
      // },
      builder: (ctx, state) {
        return _buildBody();
      },
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildSearchAppBar(),
        Flexible(
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.all(MyStyles.horizontalMargin),
            itemCount: _selectTokenBloc.balances.length,
            itemBuilder: (context, index) {
              return _buildListViewItem(index);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: MyStyles.horizontalMargin,
              );
            },
          ),
        ),
      ],
    );
    // return ListView.separated(
    //   padding: const EdgeInsets.all(MyStyles.horizontalMargin),
    //   itemCount: _selectTokenBloc.balances.length,
    //   itemBuilder: (context, index){
    //     return _buildListViewItem(index);
    //   },
    //   separatorBuilder: (BuildContext context, int index) {
    //     return const SizedBox(height: MyStyles.horizontalMargin,);
    //   },
    // );
  }

  Widget _buildListViewItem(int index) {
    return Container(
      height: listItemHeight,
      padding: const EdgeInsets.all(1.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xffBF26E5), Color(0xff3C14DA)]),
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
              onTap: () => _onTapItemIndex(index),
            ),
          ),
        ),
      ),
    );
  }

  _onTapItemIndex(int index) {
    final item = _selectTokenBloc.balances[index];

    if (widget.screenType == SelectTokenScreenType.send) {
      final price = widget.priceTable[item.symbol.toUpperCase()];
      // if (price == null) {
      //   return;
      // }

      final Map<String, dynamic> args = {
        'name': item.symbol,
        'balance': item.balance,
        'price': price,
        'secret_type': item.secretType,
        'wallet': App.instance.currentWallet,
        'token_address': item.tokenAddress
      };
      LoggerUtil.info('sendTokenScreen param: $args');
      Navigator.pushNamed(context, Routes.sendTokenScreen, arguments: args);
    } else {
      final String logo;
      if (item.tokenAddress?.isNotEmpty ?? false) {
        logo =
            '$tokenIconHost${item.secretType.toLowerCase()}/${item.tokenAddress!}.png';
      } else {
        logo = tokenIcon(item.secretType);
      }

      final Map<String, dynamic> args = {};
      args['balance'] = item;
      args['logo'] = logo;
      args['address'] = App.instance.currentWallet!.address;
      Navigator.pushNamed(context, Routes.receiveTokenScreen, arguments: args);
    }
  }

  static const tokenIconSize = 42.0;
  Widget _buildListViewItemContent(int index) {
    final item = _selectTokenBloc.balances[index];
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: MyStyles.horizontalMargin + 8,
          vertical: MyStyles.horizontalMargin),
      child: Row(
        children: [
          Container(
            width: tokenIconSize,
            height: tokenIconSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(tokenIconSize / 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(tokenIconSize / 2),
              child: _buildTokenIcon(item),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: MyStyles.horizontalMargin,
                right: MyStyles.horizontalMargin),
            child: Text(
              item.symbol,
              style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 18),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  NumberFormatUtil.tokenFormat(item.balance),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  _getDollarPrice(NumberFormatUtil.tokenFormat(item.balance), item.symbol),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: ColorUtil.mainPink),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTokenIcon(Balance item) {
    if (item.tokenAddress?.isNotEmpty ?? false) {
      if(AppConfig.instance.isSingSingContract(item.tokenAddress!)) {
        return ImageUtil.loadAssetsImage(
            fileName:'ic_singsing_token.png',
            height: Constants.tokenIconSize);
      }
      return ImageUtil.loadNetWorkImage(
          url: '$tokenIconHost${item.secretType.toLowerCase()}/${item.tokenAddress!}.png',
          height: tokenIconSize);
    } else {
      return ImageUtil.loadAssetsImage(
          fileName: tokenIcon(item.secretType), height: tokenIconSize);
    }
  }

  _getDollarPrice(String? balance, String? symbol) {
    if (balance == null ||
        balance.isEmpty ||
        symbol == null ||
        symbol.isEmpty) {
      return '0';
    }

    final price = widget.priceTable[symbol.toUpperCase()];
    if (price == null) {
      return '';
    }
    final value = NumberFormatUtil.parse(balance);
    if (value == 0) {
      return '0';
    }

    final totalPrice = price * value;
    return '\$' + totalPrice.toStringAsFixed(5);
  }
}
