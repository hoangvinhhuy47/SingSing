import 'package:flutter/material.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/border_outline.dart';
import 'package:sing_app/widgets/ink_click_item.dart';

const double radiusBox = 5;
const imageSize = 18.0;

class NoEquipmentItem extends StatelessWidget {
  const NoEquipmentItem({
    Key? key,
    required this.onPressedGoMarket,
    required this.onPressedAddEquip,
  }) : super(key: key);
  final void Function() onPressedGoMarket;
  final void Function() onPressedAddEquip;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BorderOutLine(
            backgroundItem: ColorUtil.backgroundSecondary,
            borderRadius: BorderRadius.circular(4),
            padding: const EdgeInsets.symmetric(vertical: 36),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  l('Non-equip'),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: s(context, fontSize: 14, fontWeight: FontWeight.w400),
                ),
                InkClickItem(
                  onTap: () {
                    onPressedAddEquip();
                  },
                  child: Container(
                    height: 44.0,
                    width: 88.0,
                    decoration: BoxDecoration(
                      color: ColorUtil.primary,
                      borderRadius: BorderRadius.circular(radiusBox * 5),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ImageUtil.loadAssetsImage(
                            fileName: 'ic_add_custom_token.svg',
                            width: imageSize,
                            height: imageSize),
                        const SizedBox(width: 5),
                        Text(
                          ('Add'),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: s(context,
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            colorOutline: ColorUtil.lightBlue),
        const SizedBox(
          height: 30,
        ),
        Container(
          height: 0.05,
          color: ColorUtil.grey100,
        ),
        const SizedBox(
          height: 90,
        ),
        _buildGoMarket(context),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }

  Widget _buildGoMarket(BuildContext context) {
    return InkClickItem(
      onTap: () {
        onPressedGoMarket();
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              l('Tips: Find Mic in marketplace'),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: s(context, fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l('Go Marketplace'),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: s(context,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: ColorUtil.lightBlue),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                ImageUtil.loadAssetsImage(
                    fileName: 'ic_next.svg',
                    width: imageSize,
                    height: imageSize),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
