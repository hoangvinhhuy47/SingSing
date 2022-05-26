import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/transaction_detail/transaction_detail_screen_bloc.dart';
import 'package:sing_app/blocs/transaction_detail/transaction_detail_screen_state.dart';
import 'package:sing_app/config/app_config.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/models/balance.dart';
import 'package:sing_app/data/models/bscscan_log_transaction.dart';
import 'package:sing_app/data/models/covalent_log_transaction.dart';
import 'package:sing_app/data/models/internal_web_view.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/date_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/logger_util.dart';
import 'package:sing_app/utils/number_format_util.dart';
import 'package:sing_app/utils/parse_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/utils/url_util.dart';
import 'package:sing_app/widgets/buttons/gradient_button.dart';
import 'package:sing_app/utils/extensions/string_extension.dart';
import 'package:sing_app/widgets/dialog/transaction_fee_info_dialog.dart';

import '../application.dart';

class TransactionDetailScreen extends StatefulWidget {
  final Map<String, dynamic> args;
  const TransactionDetailScreen({Key? key, required this.args}) : super(key: key);

  @override
  _TransactionDetailScreenState createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  late TransactionDetailScreenBloc _transactionDetailScreenBloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late BscScanLogTransaction? _transaction;
  late Balance _balance;
  late String _dollarPrice;
  bool _isSent = false;

  @override
  void initState() {
    _transactionDetailScreenBloc =
        BlocProvider.of<TransactionDetailScreenBloc>(context);
    _transaction = widget.args['transaction'];
    _balance = widget.args['balance'];
    _dollarPrice = widget.args['dollar_price'];

    String address = App.instance.currentWallet!.address;
    _isSent = _transaction?.from != null && _transaction?.from!.toLowerCase() == address.toLowerCase();

    super.initState();
  }

  @override
  void dispose() {
    _transactionDetailScreenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionDetailScreenBloc,
        TransactionDetailScreenState>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: _buildAppBar(),
          body: _buildBody(context),
        );
      },
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
      title: Text(_isSent ? l('Sent') : l('Received')),
    );
  }

  _buildBody(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Column(
          children: [
            _buildPriceBox(),
            _buildInfoBox(),
            _buildFeeBox(),
          ],
        )),
        DefaultButton(
          text: l('MORE DETAILS'),
          onPressed: _onTapBtnMoreDetails,
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  _buildFeeBox() {
    return Container(
      transform: Matrix4.translationValues(0.0, -50.0, 0.0),
      padding: const EdgeInsets.symmetric(
          vertical: 12, horizontal: MyStyles.horizontalMargin),
      margin: const EdgeInsets.symmetric(
          vertical: 12, horizontal: MyStyles.horizontalMargin),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF242A3E),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0x00000000).withOpacity(0.25),
            offset: const Offset(0, 4),
            blurRadius: 4,
          )
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Row(
              children: [
                Text(
                  l('Network Fee'),
                  style: MyStyles.of(context)
                      .tooltipText()
                      .copyWith(fontWeight: FontWeight.w400),
                ),
                const SizedBox(width: 10),
                _buildBtnInfoNetworkFee(),
                Expanded(
                    child: _buildTextFeeValue(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _buildDivider(),
          _buildInfoItem(l('Nonce'), '${_transaction?.nonce}'),
        ],
      ),
    );
  }

  Widget _buildBtnInfoNetworkFee() {
    return Material(
      color: Colors.transparent, // Use here Material widget
      child: Ink(
        width: 30,
        height: 30,
        child: InkWell(
          // customBorder: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(30),
          // ),
          onTap: () {
            TransactionFeeInfoDialog.show(context, onPressed: (){

            });
          },
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: ImageUtil.loadAssetsImage(
              fileName: 'ic_info_tooltip.svg',
              height: 25,
            ),
          ),
        ),
      ),
    );
  }

  _buildInfoBox() {
    String date = '';
    String status = '';
    if(_transaction != null) {
      try{
        final _time = Parse.toIntValue(_transaction!.timeStamp);
        date = _time.toDateString(format: 'MM/dd/yyyy, hh:mm a');
      } catch(ex) {
        LoggerUtil.error('_buildInfoBox error: ${ex.toString()}');
      }

      // date = _transaction!.timeStamp?.convertCovalentDateToString(format: 'MM/dd/yyyy, hh:mm a') ?? '';
      status = '';
      if(_transaction!.isError?.isNotEmpty ?? false) {
        status = _transaction!.isError == '0' ? l('Completed') : l('Failed');
      } else {
        status = l('Completed');
      }

    }

    return Container(
      transform: Matrix4.translationValues(0.0, -50.0, 0.0),
      padding: const EdgeInsets.symmetric(
          vertical: 12, horizontal: MyStyles.horizontalMargin),
      margin: const EdgeInsets.symmetric(
          vertical: 12, horizontal: MyStyles.horizontalMargin),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF242A3E),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0x00000000).withOpacity(0.25),
            offset: const Offset(0, 4),
            blurRadius: 4,
          )
        ],
      ),
      child: Column(
        children: [
          _buildInfoItem(l('Date'), date),
          _buildDivider(),
          _buildInfoItem(l('Status'), status),
          _buildDivider(),
          _buildInfoItem(
              _isSent ? l('Recipient') : l('From'),
              '${_isSent ? _transaction?.to?.cutBlockChainAddress() : _transaction?.from?.cutBlockChainAddress()}'
          ),
        ],
      ),
    );
  }

  _buildDivider() {
    return Container(
      height: 1,
      width: double.infinity,
      decoration: const BoxDecoration(color: Color(0xFF353B4F)),
    );
  }

  _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        children: [
          Text(
            label,
            style: MyStyles.of(context)
                .tooltipText()
                .copyWith(fontWeight: FontWeight.w400),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: MyStyles.of(context).valueText(),
            ),
          ),
        ],
      ),
    );
  }

  _buildPriceBox() {
    return Container(
      width: double.infinity,
      height: 146,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: Image.asset(assetImg('bg_transfer.png')).image,
              fit: BoxFit.cover)),
      child: Column(
        children: [
          const SizedBox(height: 30),
          _buildTextTransactionValue(),
          const SizedBox(height: 6),
          _buildTextTransactionUsdValue(),
        ],
      ),
    );
  }

  Widget _buildTextTransactionUsdValue() {
    String txValue = _transaction?.value ?? '0';
    if(_balance.decimals > 0) {
      double value = Parse.toDoubleValue(txValue);
      txValue = NumberFormatUtil.tokenFormat(value / pow(10,_balance.decimals), decimalDigits: _balance.decimals);
    }
    if(txValue.length > 10) {
      txValue = txValue.substring(0, 10);
    }
    double value = Parse.toDoubleValue(txValue);
    if(value < 0) value = 0;


    String _priceValue = '';
    // if(_transactionDetailScreenBloc.price > 0) {
    //   _priceValue = '≈ ${(_transactionDetailScreenBloc.price * value).toStringAsFixed(2)}\$';
    // }
    if(_dollarPrice.isNotEmpty) {
      _priceValue = '≈ $_dollarPrice';
    }
    return Text(_priceValue,
      style: s(context,
          color: const Color(0xFFD1D1D1),
          fontSize: 14,
          fontWeight: FontWeight.w400),
    );
  }

  Widget _buildTextTransactionValue() {
    String txValue = _transaction?.value ?? '0';
    if(_balance.decimals > 0) {
      num value = num.tryParse(txValue) ?? 0;
      num decimals = pow(10,_balance.decimals);
      txValue = NumberFormatUtil.tokenFormat(value / decimals, decimalDigits: _balance.decimals);
    }
    if(txValue.length > 10) {
      txValue = txValue.substring(0, 10);
    }
    return Text(
      '${_isSent ? '-' : '+'} $txValue ${_balance.symbol}',
      style: s(
          context,
          fontSize: 32,
          color: Colors.white,
          fontWeight: FontWeight.w700
      ),
    );
  }

  Widget _buildTextFeeValue(BuildContext context) {
    if(_transaction == null) {
      return Text('0',
        textAlign: TextAlign.end,
        style: s(
          context,
          fontSize: 14,
          color: Colors.white,
        ),
      );
    }
    String _textFeeValue = '';
    if(_balance.decimals > 0) {
      int _decimals = _balance.decimals;
      if(App.instance.currentWallet?.secretType == secretTypeBsc) {
        _decimals = 8;
      }
      _textFeeValue = NumberFormatUtil.tokenFormat(Parse.toIntValue(_transaction!.gasUsed) / pow(10,_decimals), decimalDigits: _balance.decimals);
    }

    String _symbol = _balance.symbol;
    if(App.instance.currentWallet?.secretType == secretTypeBsc) {
      _symbol = 'BNB';
    }
    return Text(
      '$_textFeeValue $_symbol',
      textAlign: TextAlign.end,
      style: s(
          context,
          fontSize: 14,
          color: Colors.white,
      ),
    );
  }

  _onTapBtnMoreDetails() {
    String _rootUrl = '';
    if(App.instance.currentWallet?.secretType?.isNotEmpty ?? false) {
      _rootUrl = '${AppConfig.instance.values.supportChains[App.instance.currentWallet?.secretType]?.scanUrl}';
    }


    UrlUtil.openWeb(context,
      InternalWebViewModel(
        title: 'Scan transaction',
        url: '${_rootUrl}tx/${_transaction?.hash}',
      ),
    );
  }
}
