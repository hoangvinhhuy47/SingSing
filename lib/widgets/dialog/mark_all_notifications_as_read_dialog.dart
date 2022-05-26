import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/buttons/gradient_button.dart';

class MarkAllNotificationsAsReadDialog {
  static void show(BuildContext context, {required Function onPressed}) {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black12.withOpacity(0.6),
      context: context,
      builder: (ctx) {
        return _MarkAllNotificationsAsReadDialogWidget(onPressed: onPressed);
      },
    );
  }
}

class _MarkAllNotificationsAsReadDialogWidget extends StatelessWidget {
  final Function onPressed;

  const _MarkAllNotificationsAsReadDialogWidget({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: 345,
          height: 210,
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
          ),
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
          l('Read All'),
          // textAlign: TextAlign.center,
          style: s(context,
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 14),
        const Divider(
          height: 1,
          color: Color(0xFF353B4F),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 100,
          child: Center(
            child: Text(
              l('Mark all notifications as read'),
              textAlign: TextAlign.center,
              style: s(context,
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: DefaultGradientButton(
                width: 146,
                height: 40,
                text: l('Confirm'),
                onPressed: () {
                  Navigator?.pop(context);
                  onPressed();
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DefaultButton(
                width: 146,
                height: 40,
                text: l('Cancel'),
                onPressed: () {
                  Navigator?.pop(context);
                },
              ),
            ),
          ],
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
