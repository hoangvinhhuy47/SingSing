import 'package:flutter/cupertino.dart';

import '../utils/color_util.dart';
import '../utils/styles.dart';

class RadiusWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color color;
  final double radius;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;
  final Alignment? alignment;

  const RadiusWidget(
      {Key? key,
      required this.child,
      this.color = ColorUtil.primary,
      this.radius = 200,
      this.width,
      this.borderRadius,
      this.height,
      this.padding = const EdgeInsets.symmetric(
          horizontal: MyStyles.horizontalMargin, vertical: 8),
      this.alignment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      alignment: alignment,
      decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius ?? BorderRadius.circular(radius)),
      child: child,
    );
  }
}
