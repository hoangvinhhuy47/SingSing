import 'package:flutter/cupertino.dart';
import 'package:sing_app/blocs/tabbar/tabbar_bloc.dart';
import 'package:sing_app/routes.dart';
import 'package:sing_app/utils/theme_util.dart';

import '../blocs/tabbar/tabbar_event.dart';
import '../utils/color_util.dart';
import '../utils/image_util.dart';
import '../utils/styles.dart';
import 'ink_click_item.dart';

Widget hintGoToMarket(
  BuildContext context, {
  required String text, void Function()? onTap, required TabBarBloc tabBarBloc,
}) {
  return Column(
    children: [
      const SizedBox(height: 16),
      Center(
        child: Text(
          text,
          style: s(context, fontSize: 16).copyWith(height: 2),
          textAlign: TextAlign.center,
        ),
      ),
      const SizedBox(height: 12),
      InkClickItem(
        onTap: () {
          if (onTap == null) {
            Navigator.popUntil(
                context, (route) => route.settings.name == Routes.root);
            tabBarBloc.add(const TabbarPressed(index: 3));
          } else {
            onTap();
          }
        },
        padding: const EdgeInsets.symmetric(
            vertical: 12, horizontal: MyStyles.horizontalMargin),
        borderRadius: BorderRadius.circular(50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Go Marketplace',
                style: s(context, fontSize: 16, color: ColorUtil.cyan,fontWeight: MyFontWeight.bold)),
            const SizedBox(width: 8),
            ImageUtil.loadAssetsImage(fileName: 'ic_next.svg', height: 16)
          ],
        ),
      ),
      const SizedBox(height: 16),
    ],
  );
}
