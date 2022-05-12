import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/data/models/balance.dart';
import 'package:sing_app/data/models/bscscan_log_transaction.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/number_format_util.dart';
import 'package:sing_app/utils/parse_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/utils/extensions/string_extension.dart';

import '../../application.dart';

class LogTransactionTile extends StatelessWidget {
  final BscScanLogTransaction logTransaction;
  final Balance balance;
  final Function()? onPressed;

   const LogTransactionTile({
     Key? key,
     required this.logTransaction,
     required this.balance,
     this.onPressed,
   }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.only(top: 16, bottom: 16, left: 24, right: 24),
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    String address = App.instance.currentWallet!.address;
    bool isSent = logTransaction.from != null && logTransaction.from!.toLowerCase() == address.toLowerCase();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: ImageUtil.loadAssetsImage(
              width: 15,
              height: 15,
              fit: BoxFit.scaleDown,
              fileName: isSent ? 'ic_transfer.svg' : 'ic_receive_token.svg',
              color: const Color(0xFF4C10F4)),
        ),
        Expanded(child: _buildContentText(context, isSent)),
        const SizedBox(width: 10),
        _buildTextValue(context, isSent),
      ],
    );
  }

  Widget _buildTextValue(BuildContext context, bool isSent) {
    String txValue = logTransaction.value ?? '0';
    if(balance.decimals > 0) {
        num value = num.tryParse(txValue) ?? 0;
        num decimals = pow(10,balance.decimals);
        txValue = NumberFormatUtil.tokenFormat(value / decimals, decimalDigits: balance.decimals);
    }
    if(txValue.length > 10) {
      txValue = txValue.substring(0, 10);
    }
    return Text(
      '${isSent ? '-' : '+'} $txValue ${balance.symbol}',
      style: s(
          context,
          fontSize: 13,
          color: isSent ? Colors.white : Colors.green
      ),
    );
  }

  Widget _buildTextAddress(BuildContext context, bool isSent) {
    String txAddress = '';
    if(isSent) {
      if(logTransaction.to != null && logTransaction.to!.length > 10) {
        txAddress = logTransaction.to?.cutBlockChainAddress() ?? '';
      }
    } else {
      if(logTransaction.from != null) {
        txAddress = logTransaction.from!.cutBlockChainAddress();
      }
    }

    return Text(
      txAddress,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: s(context, color: const Color(0xFFA7A7A7), fontSize: 13),
    );
  }

  Widget _buildContentText(BuildContext context, bool isSent) {
    if(logTransaction.hash != null && logTransaction.hash!.length < 30) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isSent ? l('Sent') : l('Received'),
          maxLines: 1,
          style: s(context, color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              '${isSent ? l('To') : l('From')}: ',
              maxLines: 1,
              // overflow: TextOverflow.ellipsis,
              style: s(context, color: const Color(0xFFA7A7A7), fontSize: 13),
            ),
            Flexible(
              child: _buildTextAddress(context, isSent),
            ),

          ],
        ),
      ],
    ) ;
  }

}
