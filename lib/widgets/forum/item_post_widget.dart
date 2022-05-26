import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/models/media.dart';
import 'package:sing_app/utils/forum_util.dart';

import '../../config/app_localization.dart';
import '../../data/models/post.dart';
import '../../data/models/user_profile.dart';
import '../../routes.dart';
import '../../utils/color_util.dart';
import '../../utils/image_util.dart';
import '../../utils/string_util.dart';
import '../../utils/styles.dart';
import '../ink_click_item.dart';
import '../text_view_more.dart';
import '../url_preview_widget.dart';
import 'item_media_widget.dart';

class ItemPostWidget extends StatefulWidget {
  final Post item;
  final UserProfile? user;
  final List<Post> posts;
  final List<Post> pinnedPosts;
  final void Function(ActionsDialog) onPressItemAction;
  final void Function() onPressLikePost;
  final void Function() onPressCommentPost;
  final bool isDetailPost;

  const ItemPostWidget(
      {Key? key,
      required this.item,
      required this.user,
      required this.onPressItemAction,
      required this.posts,
      required this.pinnedPosts,
      required this.onPressLikePost,
      required this.onPressCommentPost,
      this.isDetailPost = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemPostWidgetState();
}

class _ItemPostWidgetState extends State<ItemPostWidget> {
  final double avatarSize = 40;
  bool canClick = true;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(avatarSize / 2),
              child: ImageUtil.loadNetWorkImage(
                url: widget.item.user.avatar,
                height: avatarSize,
                width: avatarSize,
                placeHolder: assetImg('ic_user_profile.svg'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                          child: Text(
                        widget.item.user.getFullName(),
                        style: s(context, fontSize: 20),
                        overflow: TextOverflow.ellipsis,
                      )),
                      const SizedBox(width: 8),
                      Visibility(
                          visible: widget.item.user.isMod(),
                          child: ImageUtil.loadAssetsImage(
                              fileName: 'ic_forum_mode.svg')),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    StringUtil.getPositionAndTimePost(widget.item),
                    style: s(context,
                        fontSize: 14, color: ColorUtil.textSecondaryColor),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Visibility(
            //   visible: item.isFeatured,
            //   child: RichText(
            //     text: TextSpan(
            //       children: [
            //         WidgetSpan(
            //             child: ImageUtil.loadAssetsImage(
            //                 fileName: 'ic_pinned.svg',
            //                 color: ColorUtil.textSecondaryColor)),
            //         const WidgetSpan(child: SizedBox(width: 8)),
            //         TextSpan(
            //             text: l('Pinned'),
            //             style: ls(context,
            //                 color: ColorUtil.textSecondaryColor))
            //       ],
            //     ),
            //   ),
            // ),
            const SizedBox(width: 12),
            IconButton(
              onPressed: () => onOpenPostActionDialog(context,
                  item: widget.item,
                  user: widget.user,
                  pinnedPosts: widget.pinnedPosts,
                  posts: widget.posts,
                  onPressItemAction: widget.onPressItemAction),
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
        Visibility(
          visible: widget.item.message.isNotEmpty,
          child: widget.isDetailPost
              ? Text(widget.item.message.trim(), style: s(context, fontSize: 18))
              : TextViewMore(
                  text: widget.item.message.trim(),
                  textStyle: const TextStyle(fontSize: 18)),
        ),
        const SizedBox(height: 16),
        widget.item.medias.isNotEmpty
            ? ItemMediaWidget(
                context: context,
                post: widget.item,
                onTap: (itemMedia, index) {
                  _onPressPostImage(context, widget.item.medias, index);
                },
              )
            : widget.item.link != null
                ? UrlPreviewWidget(graphUrlInfo: widget.item.link!)
                : const SizedBox(),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                '${widget.item.likeCount} ${l(widget.item.likeCount <= 1 ? 'Like' : 'Likes')}',
                style: s(context,
                    color: ColorUtil.textSecondaryColor, fontSize: 18)),
            Text(
                '${widget.item.commentCount} ${l(widget.item.commentCount <= 1 ? 'Comment' : 'Comments')}',
                style: s(context,
                    color: ColorUtil.textSecondaryColor, fontSize: 18)),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(color: ColorUtil.dividerColor, height: 0),
        Row(
          children: [
            Expanded(
              child: InkClickItem(
                  borderRadius: BorderRadius.circular(4),
                  onTap: () {
                    if (canClick) {
                      widget.onPressLikePost();
                      canClick = false;
                      _timer = Timer(
                          const Duration(milliseconds: Constants.debounceClick),
                          () => {canClick = true});
                    }
                  },
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ImageUtil.loadAssetsImage(
                                color: widget.item.isLiked
                                    ? null
                                    : ColorUtil.textSecondaryColor,
                                fileName: widget.item.isLiked
                                    ? 'ic_like_active.svg'
                                    : 'ic_like_inactive.svg'),
                            Text("  " + l('Like'),
                                style: s(context,
                                    color: widget.item.isLiked
                                        ? ColorUtil.lightBlue
                                        : ColorUtil.textSecondaryColor,
                                    fontSize: 18))
                          ]),
                    ),
                  )),
            ),
            Expanded(
              child: InkClickItem(
                  borderRadius: BorderRadius.circular(4),
                  onTap: widget.onPressCommentPost,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ImageUtil.loadAssetsImage(
                                color: ColorUtil.textSecondaryColor,
                                fileName: 'ic_comment_post.svg'),
                            Text("  " + l('Comment'),
                                style: s(context,
                                    color: ColorUtil.textSecondaryColor,
                                    fontSize: 18))
                          ]),
                    ),
                  )),
            ),
          ],
        ),
        const Divider(color: ColorUtil.dividerColor, height: 0),
      ],
    );
  }

  _onPressPostImage(BuildContext context, List<MediaModel> medias, index) {
    Navigator.pushNamed(context, Routes.previewImageGalleryScreen, arguments: {
      PreviewImageScreenArgs.medias: medias,
      PreviewImageScreenArgs.initialIndex: index,
    });
  }
}
