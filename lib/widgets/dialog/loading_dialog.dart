import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sing_app/utils/color_util.dart';

class LoadingDialog {
  static void show(BuildContext context, String title, {bool canDismiss = true}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: _LoadingDialogWidget(title: title,canDismiss:canDismiss));
      },
    );
  }
}

class _LoadingDialogWidget extends StatelessWidget {
  final String title;
  final bool canDismiss;

  const _LoadingDialogWidget({Key? key, required this.title,required this.canDismiss}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SpinKitRing(
              color: Colors.white,
              lineWidth: 2,
              size: 32,
            ),
            Container(
                margin: const EdgeInsets.only(left: 7),
                child: Text(title,
                    style: const TextStyle(color: ColorUtil.white))),
          ],
        ),
        onWillPop: () async {
          return canDismiss; // block dismiss dialog by back from devices
        });
  }
}
