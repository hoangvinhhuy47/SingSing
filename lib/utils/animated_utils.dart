import 'package:flutter/material.dart';

Widget animatedItem(BuildContext context, Widget child) {
  return TweenAnimationBuilder(
    duration: const Duration(milliseconds: 500),
    builder: (BuildContext context, dynamic value, Widget? child) {
      return Transform.scale(
        scale: value,
        alignment: Alignment.center,
        child: child,
      );
    },
    tween: Tween(begin: 0.0, end: 1.0),
    child: child,
  );
}
