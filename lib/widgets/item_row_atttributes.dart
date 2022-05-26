import 'package:flutter/cupertino.dart';

import '../utils/image_util.dart';
import '../utils/styles.dart';

Widget buildItemRow(BuildContext context,
    {required String leftText,
    required String rightText,
    TextStyle? leftStyle,
    TextStyle? rightStyle,
    EdgeInsets? padding,
    String pathIconRight = "",
    bool positionIconRight = true,
    double iconSize = 16,
      int flexLeft = 1,
      int flexRight = 1,
    Color? iconColor}) {
  return Padding(
    padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Visibility(
          visible: leftText.isNotEmpty,
          child: Flexible(
            flex: flexLeft,
            child: Text(leftText,
                overflow: TextOverflow.ellipsis,
                style: leftStyle ?? s(context, fontSize: 16)),
          ),
        ),
        Visibility(
          visible: rightText.isNotEmpty || pathIconRight.isNotEmpty,
          child: Flexible(
            flex: flexRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildIconRight(
                    path: pathIconRight,
                    color: iconColor,
                    visible: pathIconRight.isNotEmpty && !positionIconRight,
                    iconSize: iconSize),
                Flexible(
                  child: Text(
                    rightText,
                    style: rightStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildIconRight(
                    path: pathIconRight,
                    color: iconColor,
                    visible: pathIconRight.isNotEmpty && positionIconRight,
                    iconSize: iconSize)
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildIconRight(
    {required String path,
    Color? color,
    required bool visible,
    required double iconSize}) {
  return Visibility(
    visible: visible,
    child: Padding(
      padding: EdgeInsets.only(left: 4),
      child: ImageUtil.loadAssetsImage(
          fileName: path, width: iconSize, height: iconSize, color: color),
    ),
  );
}
