import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:sing_app/blocs/token_detail/token_detail_screen_bloc.dart';
import 'package:sing_app/blocs/token_detail/token_detail_screen_event.dart';
import 'package:sing_app/blocs/token_detail/token_detail_screen_state.dart';
import 'package:sing_app/config/app_config.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/models/bscscan_log_transaction.dart';
import 'package:sing_app/routes.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/logger_util.dart';
import 'package:sing_app/utils/number_format_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/tiles/load_more_tile.dart';
import 'package:sing_app/widgets/tiles/log_transaction_tile.dart';

import '../application.dart';

class TokenDetailScreen extends StatefulWidget {
  const TokenDetailScreen({Key? key}) : super(key: key);

  @override
  _TokenDetailScreenState createState() => _TokenDetailScreenState();
}

class _TokenDetailScreenState extends State<TokenDetailScreen> {
  late TokenDetailScreenBloc _tokenDetailScreenBloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final ScrollController _scrollController = ScrollController();
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  late Completer<void> _refreshCompleter;

  @override
  void initState() {
    _tokenDetailScreenBloc = BlocProvider.of<TokenDetailScreenBloc>(context);

    _scrollController.addListener(_onScroll);
    _refreshCompleter = Completer<void>();

    super.initState();
  }

  @override
  void dispose() {
    _tokenDetailScreenBloc.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TokenDetailScreenBloc, TokenDetailScreenState>(
      listener: (ctx, state) {
        LoggerUtil.info('wallet screen state: $state');
      },
      builder: (ctx, state) {
        return Scaffold(
          key: _scaffoldKey,
          body: _buildBody(context),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      systemOverlayStyle: systemUiOverlayStyle,
      elevation: 0.0,
      leading: IconButton(
        icon: ImageUtil.loadAssetsImage(fileName: 'ic_back.svg'),
        tooltip: l('Back'),
        onPressed: () => Navigator.of(context).pop(),
      ),
      // actions: [
      //   IconButton(
      //     icon: ImageUtil.loadAssetsImage(fileName: 'ic_chart.svg'),
      //     tooltip: l('Market'),
      //     onPressed: () async {},
      //   )
      // ],
    );
  }

  _buildBody(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: 280,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xffBF26E5), Color(0xff3C14DA)]),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
          ],
        ),
        SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildAppBar(),
                const SizedBox(height: 20),
                ..._buildTokenBalance(),
                const SizedBox(height: 10),
                _tokenDetailScreenBloc.isLoading && _tokenDetailScreenBloc.logTransactions.isEmpty ? _buildLoadingWidget(context) :_buildListLogTransactions(context),
              ],
            ))
      ],
    );
  }

  Widget _buildLoadingWidget(BuildContext context) {
    return const Expanded(
        child: SpinKitRing(
          color: Colors.white,
          lineWidth: 2,
          size: 32,
        )
    );
  }

  Widget _buildListLogTransactions(BuildContext context) {
    return Expanded(
      child: GroupedListView<BscScanLogTransaction, String>(
        physics: const ClampingScrollPhysics(),
        controller: _scrollController,
        elements: _tokenDetailScreenBloc.hasMore ? [..._tokenDetailScreenBloc.logTransactions, BscScanLogTransaction(hash:'-1')] : _tokenDetailScreenBloc.logTransactions,
        groupBy: (element) => element.sortDate ?? '',
        order: GroupedListOrder.DESC,
        itemComparator: (e1, e2) {
          if(e1.timeStamp != null && e2.timeStamp != null) {
            return e1.timeStamp!.compareTo(e2.timeStamp!);
          }
          return 1;
        },
        groupSeparatorBuilder: (String value) {
          var valueDateTime = '';
          try {
            var dateTime = DateFormat('yyyy-MM-dd').parse(value);
            valueDateTime = DateFormat('MM-dd-yyyy').format(dateTime);
          } catch(ex) {
            LoggerUtil.error(ex.toString());
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Text(
              valueDateTime,
              textAlign: TextAlign.left,
              style: s(context,
                  color: const Color(0xFFB1BBD2),
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          );
        },
        itemBuilder: (context, element) {
          if(element.hash == '-1') {
            // view loadmore
            return const LoadMoreTile();
          }
          return LogTransactionTile(
            logTransaction: element,
            balance: _tokenDetailScreenBloc.token,
            onPressed: () {
              String txValue = element.value ?? '0';
              if(_tokenDetailScreenBloc.token.decimals > 0) {
                num value = num.tryParse(txValue) ?? 0;
                num decimals = pow(10,_tokenDetailScreenBloc.token.decimals);
                txValue = NumberFormatUtil.tokenFormat(value / decimals, decimalDigits: _tokenDetailScreenBloc.token.decimals);
              }
              if(txValue.length > 10) {
                txValue = txValue.substring(0, 10);
              }
              final dollarPrice = _getDollarPrice(txValue,
                  _tokenDetailScreenBloc.token.symbol);

              Map<String, dynamic> args = {};
              args['transaction'] = element;
              args['dollar_price'] = dollarPrice;
              args['balance'] = _tokenDetailScreenBloc.token;
              Navigator.pushNamed(context, Routes.transactionDetailScreen, arguments: args);
            },
          );
        },
        separator: Container(
          margin: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          color: const Color(0xFF353B4F),
          height: 1,
        ),
      ),
    );
  }

  _buildTokenBalance() {
    return [
      Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: _buildTokenImage(),
        ),
      ),
      SizedBox.fromSize(
        size: const Size(0.0, 8.0),
      ),
      Text(
        '${NumberFormatUtil.tokenFormat(_tokenDetailScreenBloc.token.balance)} ${_tokenDetailScreenBloc.token.symbol}',
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      SizedBox.fromSize(
        size: const Size(0.0, 8.0),
      ),
      Text(
        _getDollarPrice(NumberFormatUtil.tokenFormat(_tokenDetailScreenBloc.token.balance),
            _tokenDetailScreenBloc.token.symbol),
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
      SizedBox.fromSize(
        size: const Size(0.0, 10.0),
      ),
      _buildButtons(),
    ];
  }

  Widget _buildTokenImage() {
    if (_tokenDetailScreenBloc.token.tokenAddress?.isNotEmpty ?? false) {
      if(AppConfig.instance.isSingSingContract(_tokenDetailScreenBloc.token.tokenAddress!)) {
        return ImageUtil.loadAssetsImage(
            fileName:'ic_singsing_token.png',
            height: Constants.tokenIconSize);
      }
      return ImageUtil.loadNetWorkImage(
          url: '$tokenIconHost${_tokenDetailScreenBloc.token.secretType.toLowerCase()}/${_tokenDetailScreenBloc.token.tokenAddress!}.png',
          height: 60);
    } else {
      return ImageUtil.loadAssetsImage(
          fileName: tokenIcon(_tokenDetailScreenBloc.token.secretType),
          height: 60);
    }
  }

  _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton(
            icon: 'ic_transfer.svg',
            name: l('Transfer'),
            onPressed: _onTransferButtonPressed),
        _buildButton(
            icon: 'ic_receive_token.svg',
            name: l('Receive'),
            onPressed: _onReceiveButtonPressed),
        _buildButton(
            icon: 'ic_copy.svg',
            name: l('Copy'),
            onPressed: _onCopyButtonPressed),
        // _buildButton(
        //     icon: 'ic_more.svg',
        //     name: l('More'),
        //     onPressed: _onMoreButtonPressed),
      ],
    );
  }

  _buildButton(
      {required String icon,
      required String name,
      required void Function() onPressed}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4),
      child: TextButton(
        onPressed: onPressed,
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: ImageUtil.loadAssetsImage(
                  width: 20,
                  height: 20,
                  fit: BoxFit.scaleDown,
                  fileName: icon,
                  color: const Color(0xFF4C10F4)),
            ),
            SizedBox.fromSize(
              size: const Size(0.0, 4.0),
            ),
            Text(
              name,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            )
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

    final price = _tokenDetailScreenBloc.priceTable[symbol.toUpperCase()];
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

  void _onTransferButtonPressed() {
    if (App.instance.currentWallet == null) {
      return;
    }

    final price = _tokenDetailScreenBloc
        .priceTable[_tokenDetailScreenBloc.token.symbol.toUpperCase()];
    // if (price == null) {
    //   return;
    // }
    final Map<String, dynamic> args = {
      'name': _tokenDetailScreenBloc.token.symbol,
      'balance': _tokenDetailScreenBloc.token.balance,
      'secret_type': _tokenDetailScreenBloc.token.secretType,
      'price': price,
      'wallet': App.instance.currentWallet,
      'token_address': _tokenDetailScreenBloc.token.tokenAddress
    };
    LoggerUtil.info('sendTokenScreen param: $args');
    Navigator.pushNamed(context, Routes.sendTokenScreen, arguments: args);
  }

  void _onReceiveButtonPressed() {
    if (App.instance.currentWallet == null) {
      return;
    }

    final String logo;
    if (_tokenDetailScreenBloc.token.tokenAddress?.isNotEmpty ?? false) {
      logo =
          '$tokenIconHost${_tokenDetailScreenBloc.token.secretType.toLowerCase()}/${_tokenDetailScreenBloc.token.tokenAddress!}.png';
    } else {
      logo = tokenIcon(_tokenDetailScreenBloc.token.secretType);
    }

    final Map<String, dynamic> args = {};
    args['balance'] = _tokenDetailScreenBloc.token;
    args['logo'] = logo;
    args['address'] = App.instance.currentWallet!.address;
    Navigator.pushNamed(context, Routes.receiveTokenScreen, arguments: args);
  }

  void _onCopyButtonPressed() async {
    if (App.instance.currentWallet == null) {
      return;
    }

    final address = App.instance.currentWallet!.address;
    final clipboardData = await Clipboard.getData('text/plain');
    if (clipboardData?.text == address) {
      return;
    }

    Clipboard.setData(ClipboardData(text: App.instance.currentWallet!.address));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:
          Text(l('Copied') + ' ' + App.instance.currentWallet!.address),
    ));
  }

  void _onMoreButtonPressed() {}

  // LISTENER

  void _onScroll() {
    final currentScroll = _scrollController.position.pixels;
    final maxScroll = _scrollController.position.maxScrollExtent;
    if (currentScroll == maxScroll && _tokenDetailScreenBloc.hasMore) {
      _tokenDetailScreenBloc.add(TokenDetailScreenEventLoadMore());
    }
  }
}
