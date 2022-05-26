import 'package:flutter/cupertino.dart';

class BorderOutLine extends StatelessWidget {
  final BorderRadius borderRadius;
  final double? width;
  final double? height;
  final Color? backgroundItem;
  final Widget child;
  final Color colorOutline;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Alignment? alignment;

  const BorderOutLine({
    Key? key,
    required this.borderRadius,
    this.width,
    this.backgroundItem,
    this.margin,
    required this.child,
    required this.colorOutline,
    this.height,
    this.padding,
    this.alignment,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      margin: margin,
      alignment: alignment,
      decoration: BoxDecoration(
          color: backgroundItem,
          borderRadius: borderRadius,
          border: Border.all(
            color: colorOutline,
            width: 1
          )),
      child: child,
    );
  }
}
