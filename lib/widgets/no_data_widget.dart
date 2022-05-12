
import 'package:flutter/material.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';

class NoDataWidget extends StatelessWidget {

  final Widget? icon;
  final String? text;
  final Color? textColor;
  final String? buttonText;
  final NoDataType? type;
  final Function? onPressed;

  const NoDataWidget({
    Key? key,
    this.icon,
    this.text,
    this.textColor,
    this.buttonText,
    this.onPressed,
    this.type = NoDataType.hasError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          icon ??
              ImageUtil.loadAssetsImage(
                fileName: type == NoDataType.hasError ? 'ic_has_error.svg' : 'ic_not_found.svg',
                height: 200,
              ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              text ?? (type == NoDataType.hasError ? l('Has error') : l('No data')),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: textColor ?? Colors.white,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildButton(context),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    if (onPressed != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(60 / 2),
        child: Material(
          color: ColorUtil.primary,
          child: InkWell(
            onTap: () => onPressed!(),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 16,
                horizontal: MediaQuery.of(context).size.width * 0.25,
              ),
              child: Text(buttonText ?? (type == NoDataType.hasError ? l('Try again') : l('Refresh')),
                textAlign: TextAlign.center,
                style: s(context, color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
        ),
      );
    }
    return Container();
  }
}

enum NoDataType {
  hasError,
  emptyList,
}
