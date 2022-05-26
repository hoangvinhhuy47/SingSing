import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/buttons/gradient_button.dart';

import '../outline_widget.dart';

class TransactionFeeInfoDialog {
  static void show(BuildContext context, {required Function onPressed}) {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black12.withOpacity(0.6),
      context: context,
      builder: (ctx) {
        return _TransactionFeeInfoDialogWidget(onPressed: onPressed);
      },
    );
  }
}

class _TransactionFeeInfoDialogWidget extends StatelessWidget {
  final Function onPressed;

  const _TransactionFeeInfoDialogWidget({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlineWidget(
        // gradient: const LinearGradient(colors: ColorUtil.defaultGradientButton),//
        radius: 24,
        child: Container(
          width: 335,
          height: 250,
          decoration: BoxDecoration(
            color: const Color(0xFF20273F),
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
          child: Stack(
            children: [
              Positioned.fill(
                child: Align(
                    alignment: Alignment.topRight,
                    child: _btnClose(context),
                ),
              ),

              _buildContent(context),
            ],
          ) ,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        Text(
          l('Network Fee'),
          // textAlign: TextAlign.center,
          style: s(context,
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),
        const Divider(
          height: 1,
          color: Color(0xFF353B4F),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 100,
          child: Center(
            child: Text(
              l('Network fee info'),
              textAlign: TextAlign.center,
              style: s(context,
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
        const SizedBox(height: 10),
        DefaultGradientButton(
          text: 'OK',
          onPressed: () {
            Navigator?.pop(context);
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _btnClose(BuildContext context) {
    return Material(
      color: Colors.transparent, // Use here Material widget
      child: Ink(
        width: 35,
        height: 35,
        padding: const EdgeInsets.fromLTRB(0, 5, 10, 0),
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          onTap: () {
            Navigator?.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: ImageUtil.loadAssetsImage(
              fileName: 'ic_close_dialog_white.svg',
              height: 30,
            ),
          ),
        ),
      ),
    );
  }
}
