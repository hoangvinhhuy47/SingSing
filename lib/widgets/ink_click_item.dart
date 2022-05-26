import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InkClickItem extends StatelessWidget {
  final Function()? onTap;
  final Widget child;
  final Color color;
  final bool isEnabled;
  final BorderRadius? borderRadius;

  final EdgeInsetsGeometry padding;

  const InkClickItem(
      {Key? key,
      required this.onTap,
      required this.child,
      this.color = Colors.transparent,
      this.borderRadius,
      this.padding = EdgeInsets.zero,
      this.isEnabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isEnabled ? color : Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        splashColor: isEnabled ? null : Colors.transparent,
        enableFeedback: true,
        borderRadius: borderRadius,
        onTap: isEnabled ? onTap : () {},
        child: Ink(
          padding: padding,
          child: InkWell(
            child: child,
          ),
        ),
      ),
    );
  }
}
