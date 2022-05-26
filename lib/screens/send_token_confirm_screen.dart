import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sing_app/blocs/send_token_confirm/send_token_confirm_screen_bloc.dart';
import 'package:sing_app/blocs/send_token_confirm/send_token_confirm_screen_event.dart';
import 'package:sing_app/blocs/send_token_confirm/send_token_confirm_screen_state.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/logger_util.dart';
import 'package:sing_app/utils/number_format_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/dialog/custom_alert_dialog.dart';
import 'package:sing_app/widgets/dialog/loading_dialog.dart';

import '../manager/app_lock_manager.dart';
import '../utils/app_lock_util.dart';

class SendTokenConfirmScreen extends StatefulWidget {
  const SendTokenConfirmScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SendTokenConfirmScreenState createState() => _SendTokenConfirmScreenState();
}

class _SendTokenConfirmScreenState extends State<SendTokenConfirmScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late SendTokenConfirmScreenBloc _sendTokenConfirmScreenBloc;

  @override
  void initState() {
    _sendTokenConfirmScreenBloc =
        BlocProvider.of<SendTokenConfirmScreenBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _sendTokenConfirmScreenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      body: SafeArea(
        left: false,
        right: false,
        child: _buildBody(),
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      backgroundColor: ColorUtil.primary,
      systemOverlayStyle: systemUiOverlayStyle,
      elevation: 0.0,
      centerTitle: true,
      leading: IconButton(
        icon: ImageUtil.loadAssetsImage(fileName: 'ic_back.svg'),
        tooltip: l('Back'),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(l('Transfer')),
    );
  }

  _buildBody() {
    return BlocConsumer<SendTokenConfirmScreenBloc,
        SendTokenConfirmScreenState>(
      listener: (ctx, state) {
        LoggerUtil.info('SendTokenConfirmScreen: $state');
        if (state is SendTokenConfirmScreenStateSending) {
          // final alert = AlertDialog(
          //   backgroundColor: Colors.transparent,
          //   content: Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       const SpinKitRing(
          //         color: Colors.white,
          //         lineWidth: 2,
          //         size: 32,
          //       ),
          //       Container(margin: const EdgeInsets.only(left: 7),
          //           child: Text(l("Sending..."),
          //               style: const TextStyle(color: ColorUtil.white)
          //           )),
          //     ],
          //   ),
          // );
          // showDialog(barrierDismissible: false,
          //   context:context,
          //   builder:(BuildContext context){
          //     return alert;
          //   },
          // );
          LoadingDialog.show(context, l('Sending...'));
        }
        if (state is SendTokenConfirmScreenStateSent) {
          var count = 0;
          Navigator.popUntil(context, (route) {
            return count++ == 4;
          });
        }
        if (state is SendTokenConfirmScreenStateErrorSending) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
          ));
        }
      },
      builder: (ctx, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Column(
              children: [
                _buildBalanceBox(),
                _buildInfoBox(),
                _buildTotalBox(),
              ],
            )),
            if (_sendTokenConfirmScreenBloc.gasFeeCalculated &&
                !_sendTokenConfirmScreenBloc.isSending)
              _buildConfirmButton(),
          ],
        );
      },
    );
  }

  _buildInfoBox() {
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
          _buildInfoItem(l('From'),
              _getAddressText(_sendTokenConfirmScreenBloc.wallet.address)),
          _buildDivider(),
          _buildInfoItem(l('Asset'), _sendTokenConfirmScreenBloc.symbol),
          _buildDivider(),
          _buildInfoItem(
              l('To'), _getAddressText(_sendTokenConfirmScreenBloc.address)),
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

  _buildTotalBox() {
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
            padding: const EdgeInsets.fromLTRB(0, 18, 0, 18),
            child: Row(
              children: [
                Text(
                  l('Network Fee'),
                  style: MyStyles.of(context)
                      .tooltipText()
                      .copyWith(fontWeight: FontWeight.w400),
                ),
                Text(
                  ' *',
                  style: MyStyles.of(context).tooltipText().copyWith(
                      fontWeight: FontWeight.w400, color: ColorUtil.mainPink),
                ),
                Expanded(
                    child: _sendTokenConfirmScreenBloc.gasFeeCalculated
                        ? Text(
                            '${_sendTokenConfirmScreenBloc.networkGasFee?.gasFeeNative} ${_sendTokenConfirmScreenBloc.networkGasFee?.nativeSymbol} ≈ \$${NumberFormatUtil.currencyFormat(_sendTokenConfirmScreenBloc.networkGasFee?.gasFeeUsd ?? 0)}',
                            textAlign: TextAlign.end,
                            style: MyStyles.of(context).valueText(),
                          )
                        : Row(
                            children: const [
                              Spacer(),
                              SpinKitRing(
                                color: Colors.white,
                                lineWidth: 2,
                                size: 16,
                              )
                            ],
                          )),
              ],
            ),
          ),
          if (_sendTokenConfirmScreenBloc.gasFeeCalculated) _buildDivider(),
          if (_sendTokenConfirmScreenBloc.gasFeeCalculated)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 18, 0, 8),
              child: Row(
                children: [
                  Text(
                    l('Total'),
                    style: MyStyles.of(context)
                        .valueText()
                        .copyWith(fontWeight: FontWeight.w800, fontSize: 20),
                  ),
                  Expanded(
                    child: Text(
                      '\$${NumberFormatUtil.currencyFormat(_sendTokenConfirmScreenBloc.price * _sendTokenConfirmScreenBloc.amount + (_sendTokenConfirmScreenBloc.networkGasFee?.gasFeeUsd ?? 0))}',
                      textAlign: TextAlign.end,
                      style: MyStyles.of(context)
                          .valueText()
                          .copyWith(fontWeight: FontWeight.w800, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  _buildBalanceBox() {
    var price = _getDollarPrice();
    price = price.isNotEmpty ? '\$$price' : '';
    return Container(
      width: double.infinity,
      height: 146,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: Image.asset(assetImg('bg_transfer.png')).image,
              fit: BoxFit.cover)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              _sendTokenConfirmScreenBloc.amount.toString(),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            price,
            style: TextStyle(
                color: Colors.white.withOpacity(0.75),
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  _buildConfirmButton() {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
            vertical: MyStyles.horizontalMargin, horizontal: 54),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xffBF26E5), Color(0xff3C14DA)]),
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: TextButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 24)),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ))),
              onPressed: _onPressConfirm,
              child: Text(
                l('Confirm'),
                style: const TextStyle(color: Colors.white),
              )),
        ));
  }

  Future _onPressConfirm() async {
    AppLockUtil.checkPassCode(
      context: context,
      condition: AppLockManager.instance.transactionSigning,
      function: () {
        _eventConfirmSend();
      },
    );
  }

  void _eventConfirmSend() {
    if (_sendTokenConfirmScreenBloc.networkGasFee != null &&
        _sendTokenConfirmScreenBloc.wallet.balance != null &&
        _sendTokenConfirmScreenBloc.wallet.balance!.balance <
            _sendTokenConfirmScreenBloc.networkGasFee!.gasFeeNative +
                _sendTokenConfirmScreenBloc.amount) {
      CustomAlertDialog.show(
        context,
        title: l('Notify'),
        leftAction: () {
          Navigator.pop(context);
        },
        leftText: l('OK'),
        content: l('Balance is not enough'),
        isLeftPositive: true,
      );
    }else{
      _sendTokenConfirmScreenBloc.add(SendTokenConfirmScreenSending());
    }
  }

  String _getDollarPrice() {
    final price = _sendTokenConfirmScreenBloc.price;
    if (price <= 0) {
      return '';
    }
    final value = _sendTokenConfirmScreenBloc.amount;
    if (value == 0) {
      return '';
    }

    final totalPrice = price * value;
    return NumberFormatUtil.currencyFormat(totalPrice);
  }

  String _getAddressText(String? address) {
    if (address != null && address.length > 20) {
      return '${address.substring(0, 10)}...${address.substring(address.length - 10)}';
    }
    return '...';
  }
}
