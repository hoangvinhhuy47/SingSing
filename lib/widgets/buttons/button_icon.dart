import 'package:flutter/material.dart';
import 'package:sing_app/utils/image_util.dart';

class Button_Icon extends StatelessWidget {
  final positionIcon position;
  final double? width;
  final double? height;
  final double iconSize;
  final Color? backgroundItem;
  final String imageIcon;
  final Widget child;
  const Button_Icon(
      {Key? key,
      required this.position,
      this.width,
      this.height,
      required this.iconSize,
      this.backgroundItem,
      required this.imageIcon,
      required this.child})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: backgroundItem,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          position == positionIcon.left
              ? ImageUtil.loadAssetsImage(
                  fileName: imageIcon,
                  width: iconSize,
                  height: iconSize,
                )
              : const SizedBox(
                  width: 5,
                ),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: child,
          ),
          position == positionIcon.right
              ? ImageUtil.loadAssetsImage(
                  fileName: imageIcon,
                  width: iconSize,
                  height: iconSize,
                )
              : const SizedBox(
                  width: 5,
                ),
        ],
      ),
    );
  }
}

enum positionIcon { left, right,none }
