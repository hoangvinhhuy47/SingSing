import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/image_util.dart';

Widget BuildBtnPlayVideo(
    {required BuildContext context,
    void Function()? onPress,
    String path = "",
    double size = 0}) {
  final double sizePhoto = size == 0 ? 60 : size;
  return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          child: ImageUtil.loadAssetsImage(
              fileName: path == '' ? 'btn_play_video.svg' : path,
              width: sizePhoto,
              height: sizePhoto),
          onTap: onPress,
        ),
      ));
}
