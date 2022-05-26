import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/buttons/gradient_button.dart';

class FSGrantPermissionDialog extends StatelessWidget {
  final String title;
  final String description;
  final String primaryText;
  final String secondaryText;
  final Function()? primaryPressed;
  final Function()? secondaryPressed;

  const FSGrantPermissionDialog({
    required this.title,
    required this.description,
    required this.primaryText,
    required this.secondaryText,
    required this.primaryPressed,
    required this.secondaryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 16,
            ),
            _buildHeader(),
            const SizedBox(
              height: 16,
            ),
            _buildBody(context),
            const SizedBox(
              height: 16,
            ),
            _buildActionsButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return ImageUtil.loadAssetsImage(fileName: 'ic_notification_logo.png');
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: MyStyles.horizontalMargin),
          child: Text(
            title,
            style: s(context, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          description,
          style: s(context, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActionsButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GradientButton(
            text: primaryText,
            onPressed: primaryPressed,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: GradientButton(
            text: secondaryText,
            onPressed: secondaryPressed,
          ),
        ),
      ],
    );
  }

  static show({
    required BuildContext context,
    required String title,
    required String description,
    required String primaryText,
    required String secondaryText,
    required Function primaryPressed,
    required Function secondaryPressed,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return WillPopScope(
          onWillPop: () async => false,
          child: FSGrantPermissionDialog(
            title: title,
            description: description,
            primaryText: primaryText,
            secondaryText: secondaryText,
            primaryPressed: () {
              if (primaryPressed != null) {
                primaryPressed();
              }
              Navigator.pop(context);
            },
            secondaryPressed: () {
              if (secondaryPressed != null) {
                secondaryPressed();
              }
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
