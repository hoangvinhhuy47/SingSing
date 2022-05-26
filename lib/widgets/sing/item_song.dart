import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sing_app/data/models/song_model.dart';

import '../../utils/color_util.dart';
import '../../utils/image_util.dart';
import '../../utils/string_util.dart';
import '../../utils/styles.dart';
import '../ink_click_item.dart';

const double photoSize = 75;

class ItemSong extends StatelessWidget {
  final SongModel item;
  final Function()? onTap;
  final bool isBottomBorder;
  final bool isResult;
  final double horizontalPadding;

  const ItemSong(
      {Key? key,
      required this.item,
      this.onTap,
      this.horizontalPadding = MyStyles.horizontalMargin,
      this.isBottomBorder = false,
      this.isResult = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkClickItem(
      onTap: onTap,
      color: ColorUtil.backgroundSecondary,
      child: Container(
        height: MyStyles.verticalMargin * 2 + photoSize,
        padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding, vertical: MyStyles.verticalMargin),
        decoration: BoxDecoration(
            // color: ColorUtil.backgroundSecondary,
            border: Border(
                bottom: BorderSide(
                    width: isBottomBorder ? 1 : 0,
                    color: ColorUtil.deepPurple))),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: ImageUtil.loadNetWorkImage(
                  url: item.thumbnail,
                  width: photoSize,
                  height: photoSize,
                  fit: BoxFit.cover),
            ),
            const SizedBox(width: MyStyles.horizontalMargin),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: s(context, fontSize: 16),
                  ),
                  Text(
                    item.singer,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style:
                        s(context, fontSize: 11, color: Colors.grey.shade300),
                  ),
                  Visibility(
                    visible: isResult,
                    child: Text(
                      StringUtil.getDurationTimeInMinute(
                          seconds: item.duration),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: s(context, fontSize: 11, color: ColorUtil.grey100),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
