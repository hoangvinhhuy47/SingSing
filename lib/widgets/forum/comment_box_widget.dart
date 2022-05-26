import 'package:flutter/cupertino.dart';

import '../../application.dart';
import '../../config/app_localization.dart';
import '../../utils/color_util.dart';
import '../../utils/image_util.dart';
import '../../utils/styles.dart';
import '../ink_click_item.dart';

class CommentBoxWidget extends StatelessWidget {
  final void Function() onPressComment;
  final void Function() onPressPhotoGallery;

  const CommentBoxWidget(
      {Key? key,
      required this.onPressComment,
      required this.onPressPhotoGallery})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: ImageUtil.loadNetWorkImage(
            url: App.instance.userApp?.avatar ?? "",
            height: 35,
            width: 35,
            placeHolder: assetImg('ic_user_profile.svg'),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: InkClickItem(
            color: ColorUtil.backgroundItemColor,
            borderRadius: BorderRadius.circular(50),
            onTap: onPressComment,
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l('Write a comment') + ' ...',
                    style: s(context,
                        color: ColorUtil.textSecondaryColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 16),
                  ),
                  InkClickItem(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      borderRadius: BorderRadius.circular(20),
                      onTap: onPressPhotoGallery,
                      child: ImageUtil.loadAssetsImage(
                          fileName: 'ic_attach_photo.svg')),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
