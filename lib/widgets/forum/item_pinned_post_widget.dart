import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../data/models/post.dart';
import '../../data/models/user_profile.dart';
import '../../utils/color_util.dart';
import '../../utils/forum_util.dart';
import '../../utils/image_util.dart';
import '../../utils/string_util.dart';
import '../../utils/styles.dart';
import '../button_play_video.dart';
import '../ink_click_item.dart';
import '../url_preview_widget.dart';

class ItemPinnedPostWidget extends StatelessWidget {
  final Post item;
  final void Function() onPressPost;
  final UserProfile? user;
  final List<Post> posts;
  final List<Post> pinnedPosts;
  final void Function(ActionsDialog actionsDialog) onPressItemAction;

  const ItemPinnedPostWidget(
      {Key? key,
      required this.item,
      required this.onPressPost,
      required this.user,
      required this.posts,
      required this.pinnedPosts,
      required this.onPressItemAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: InkClickItem(
        padding: const EdgeInsets.all(MyStyles.horizontalMargin),
        color: ColorUtil.backgroundItemColor,
        borderRadius: BorderRadius.circular(12),
        onTap: onPressPost,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: ImageUtil.loadNetWorkImage(
                    url: item.user.avatar,
                    height: 45,
                    width: 45,
                    placeHolder: assetImg('ic_user_profile.svg'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                              child: Text(
                            item.user.getFullName(),
                            style: s(context, fontSize: 20),
                            overflow: TextOverflow.ellipsis,
                          )),
                          const SizedBox(width: 8),
                          Visibility(
                              visible: item.user.isMod(),
                              child: ImageUtil.loadAssetsImage(
                                  fileName: 'ic_forum_mode.svg')),
                        ],
                      ),
                      Text(
                        StringUtil.getPositionAndTimePinnedPost(item),
                        style:  s(context,
                            color: ColorUtil.textSecondaryColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () => onOpenPostActionDialog(context,
                      item: item,
                      user: user,
                      pinnedPosts: pinnedPosts,
                      posts: posts,
                      onPressItemAction: onPressItemAction),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: ImageUtil.loadAssetsImage(
                    fileName: 'ic_three_dots_horizontal.svg',
                    color: ColorUtil.colorButton,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              item.message,
              maxLines: item.medias.isEmpty && item.link == null ? 12 : 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            item.medias.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ImageUtil.loadNetWorkImage(
                            url: item.medias[0].thumb,
                            height: 220,
                            width: double.infinity),
                        Visibility(
                            visible: item.medias[0].type == "video",
                            child: BuildBtnPlayVideo(
                                context: context, onPress: () {})),
                      ],
                    ),
                  )
                : item.link != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: UrlPreviewWidget(
                            graphUrlInfo: item.link!,
                            type: UrlPreviewWidgetType.typePinPost),
                      )
                    : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
