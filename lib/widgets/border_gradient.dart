import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/color_util.dart';

class BorderGradient extends StatelessWidget {
  final Gradient? gradientColor;
  final Color? color;
  final BorderRadius borderRadius;
  final double borderWidth;

  final Color backgroundItem;
  final Widget child;

  const BorderGradient(
      {Key? key,
      this.gradientColor,
      required this.borderRadius,
      this.backgroundItem = ColorUtil.primary,
      required this.child,
      this.borderWidth = 1,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        gradient: gradientColor,
        borderRadius: borderRadius,
      ),
      padding: EdgeInsets.all(borderWidth),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: child,
      ),
    );
  }
}
