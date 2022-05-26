import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/border_outline.dart';
import 'package:sing_app/widgets/ink_click_item.dart';
import 'package:sing_app/widgets/radius_widget.dart';

checkPermission(BuildContext ctx, Function() onGranted) async {
  if (await Permission.microphone.isDenied ||
      await Permission.storage.isDenied ||
      await Permission.camera.isDenied) {
    _alertPermission(ctx, 'microphone, camera and memory');
  } else {
    onGranted();
  }
}

Future<void> _alertPermission(BuildContext context, String title) async {
  const double radiusBox = 5.0;
  double width = MediaQuery.of(context).size.width - 40;
  final titles = 'Please allow SingSing to access your $title in settings?';
  return showDialog(
      context: context,
      barrierColor: Colors.black12.withOpacity(0.6),
      barrierDismissible: false,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
              child: BorderOutLine(
            padding: const EdgeInsets.all(15),
            width: width,
            colorOutline: ColorUtil.backgroundSecondary,
            backgroundItem: ColorUtil.backgroundSecondary,
            height: 190,
            borderRadius: BorderRadius.circular(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  l(titles),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style: s(context,
                      fontSize: 18,
                      color: ColorUtil.white,
                      fontWeight: FontWeight.w400),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkClickItem(
                      onTap: () {
                        AppSettings.openAppSettings();
                        Navigator.pop(context);
                      },
                      child: RadiusWidget(
                        height: 42,
                        radius: radiusBox * 5,
                        width: (width - 50) / 2,
                        alignment: Alignment.center,
                        color: ColorUtil.primary,
                        child: Text(
                          l("Setting"),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: s(context,
                              fontSize: 18,
                              color: ColorUtil.white,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    InkClickItem(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: RadiusWidget(
                        radius: radiusBox * 5,
                        height: 42,
                        width: (width - 50) / 2,
                        alignment: Alignment.center,
                        color: ColorUtil.deepPurple,
                        child: Text(
                          "Cancel",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: s(context,
                              fontSize: 18,
                              color: ColorUtil.white,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )),
        );
      });
}
