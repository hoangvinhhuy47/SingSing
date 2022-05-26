import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sing_app/utils/color_util.dart';

class DividerDash extends StatelessWidget {
  const DividerDash({
    Key? key,
    this.height = 1,
    this.dashWidth = 8.0,
    this.color = ColorUtil.white,
  }) : super(key: key);
  final double height;
  final double dashWidth;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashHeight = height;
        final dashCount = (boxWidth / (1.5 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
