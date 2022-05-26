import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/date_util.dart';
import 'package:sing_app/widgets/indicator_loadmore.dart';
import 'package:sing_app/widgets/ink_click_item.dart';
import 'package:sing_app/widgets/size_calculate_widget.dart';

import '../../data/models/comment.dart';
import '../../routes.dart';
import '../../utils/image_util.dart';
import '../../utils/styles.dart';
import '../url_preview_widget.dart';

const double subItemSize = 40;
const double commentAvatarSize = 50;
const double shortCommentAvatarSize = 35;

class ItemCommentPost extends StatefulWidget {
  final CommentModel commentModel;
  final CommentModel? parentCommentModel;
  final void Function()? onPress;
  final void Function(CommentModel commentModel, CommentModel? parentModel)?
      onLike;
  final void Function(CommentModel replyModel, CommentModel? parentModel)?
      onReply;
  final void Function(CommentModel commentModel)? onViewMoreReplyComment;
  final bool isShortComment;
  final bool isSubComment;
  final bool isLoadingReplyComment;

  const ItemCommentPost({
    Key? key,
    required this.commentModel,
    this.parentCommentModel,
    this.onPress,
    this.onLike,
    this.onReply,
    this.onViewMoreReplyComment,
    this.isShortComment = false,
    this.isSubComment = false,
    this.isLoadingReplyComment = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemCommentPostState();
}

class _ItemCommentPostState extends State<ItemCommentPost> {
  double heightSubComment = 0;
  bool canClick = true;
  Timer? _timer;

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double avatarSize = widget.isShortComment
        ? shortCommentAvatarSize
        : widget.isSubComment
            ? subItemSize
            : commentAvatarSize;
    final sizeMedia = MediaQuery.of(context).size.width / 2.1;
    return GestureDetector(
      onTap: widget.onPress,
      child: SizeCalculateWidget(
        onChange: (Size size) {
          setState(() {
            heightSubComment = size.height;
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: widget.isSubComment ? 12 : 0),
            Container(
              margin: widget.isSubComment
                  ? const EdgeInsets.only(left: commentAvatarSize / 2)
                  : EdgeInsets.zero,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// For sub comment: line connecting to parent comment
                  Visibility(
                    visible: widget.isSubComment,
                    child: ImageUtil.loadAssetsImage(
                        fileName: 'ic_line_sub_item.svg', width: 20),
                  ),
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(clipBehavior: Clip.none, children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(avatarSize / 2),
                            child: ImageUtil.loadNetWorkImage(
                              url: widget.commentModel.avatar,
                              height: avatarSize,
                              width: avatarSize,
                              placeHolder: assetImg('ic_user_profile.svg'),
                            ),
                          ),

                          /// line connecting to child comment
                          Visibility(
                              visible: !widget.isShortComment &&
                                  (widget.commentModel.childs?.data
                                          ?.isNotEmpty ??
                                      false),
                              child: Positioned(
                                left: avatarSize / 2 + 0.3,
                                top: avatarSize,
                                child: Container(
                                  height: heightSubComment  + 12,
                                  width: 0.7,
                                  color: ColorUtil.mainBlue,
                                ),
                              )),
                        ]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                widget.commentModel.getUserFullName(),
                                style: s(context, fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Visibility(
                                visible: widget.commentModel.message.isNotEmpty,
                                child: Text(widget.commentModel.message.trim(),
                                    maxLines: widget.isShortComment ? 1 : null,
                                    overflow: widget.isShortComment
                                        ? TextOverflow.ellipsis
                                        : null,
                                    style: s(context, fontSize: 18)),
                              ),

                              /// Media - time - like - reply
                              Visibility(
                                visible: !widget.isShortComment,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildMedia(context, sizeMedia),
                                    widget.commentModel.createdAt.isEmpty &&
                                            widget.commentModel.state != null
                                        ? _buildStateCommentJustCommented()
                                        : _buildViewAction(context),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: !widget.isShortComment &&
                  (widget.commentModel.childs?.data?.isNotEmpty ?? false),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: _itemSubComment,
                itemCount: (widget.commentModel.childs?.data?.length ?? 0) +
                    (_isHasMoreSubComment() ? 1 : 0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateCommentJustCommented() {
    return Text(
      widget.commentModel.state == CommentState.posting
          ? l('Posting') + '...'
          : l('Something wrong'),
      style: TextStyle(
          color: widget.commentModel.state == CommentState.error
              ? ColorUtil.formErrorText
              : ColorUtil.textSecondaryColor),
    );
  }

  Widget _buildViewAction(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            /// Time
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text(
                widget.commentModel.createdAt.convertCovalentDateToTimeHasPass(
                    isShort: widget.isSubComment),
                style: s(context, color: ColorUtil.textSecondaryColor),
              ),
            ),

            /// Like
            InkClickItem(
              borderRadius: BorderRadius.circular(6),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              onTap: () {
                if (canClick) {
                  _onPressLike(widget.commentModel, widget.parentCommentModel);
                  canClick = false;
                  _timer = Timer(
                      const Duration(milliseconds: Constants.debounceClick),
                      () => {canClick = true});
                }
              },
              child: Text(
                l('Like'),
                style: s(context,
                    color: widget.commentModel.isLiked ?? false
                        ? ColorUtil.lightBlue
                        : ColorUtil.textSecondaryColor),
              ),
            ),

            ///Reply
            InkClickItem(
              borderRadius: BorderRadius.circular(6),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              onTap: () {
                _onPressReply(
                    replyComment: widget.commentModel,
                    parentComment: widget.parentCommentModel);
              },
              child: Text(
                l('Reply'),
                style: s(context, color: ColorUtil.textSecondaryColor),
              ),
            ),
          ],
        ),

        ///Like count
        Visibility(
          visible: (widget.commentModel.likeCount ?? 0) > 0,
          child: Row(
            children: [
              Text(
                '${widget.commentModel.likeCount ?? 0}',
                style: s(context, color: ColorUtil.textSecondaryColor),
              ),
              const SizedBox(width: 8),
              ImageUtil.loadAssetsImage(
                  height: 11, width: 12, fileName: 'ic_like_active.svg')
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMedia(BuildContext context, double sizeMedia) {
    return Visibility(
      visible: widget.commentModel.media?.isMediaNotEmpty() == true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: InkClickItem(
            onTap: () {
              Navigator.pushNamed(
                  context, Routes.previewImageGalleryScreen, arguments: {
                PreviewImageScreenArgs.singleImage: widget.commentModel.media
              });
            },
            child: ImageUtil.loadNetWorkImage(
                url: widget.commentModel.media?.original ??
                    widget.commentModel.media?.thumb ??
                    '',
                height: sizeMedia,
                width: sizeMedia),
          ),
        ),
      ),
      replacement: widget.commentModel.link != null &&
              !widget.commentModel.link!.isNull()
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: UrlPreviewWidget(
                  graphUrlInfo: widget.commentModel.link!,
                  type: UrlPreviewWidgetType.typeLinkInComment,
                  contentWidth: widget.isSubComment ? 0.4 : 0.45),
            )
          : const SizedBox(height: 8),
    );
  }

  bool _isHasMoreSubComment() {
    int dataLength = widget.commentModel.childs?.data?.length ?? 0;
    int total = widget.commentModel.childs?.pagination?.total ?? 0;
    return dataLength < total;
  }

  int remainComment() {
    int dataLength = widget.commentModel.childs?.data?.length ?? 0;
    int total = widget.commentModel.childs?.pagination?.total ?? 0;
    return total - dataLength;
  }

  Widget _itemSubComment(BuildContext context, int index) {
    if (index >= (widget.commentModel.childs?.data?.length ?? 0)) {
      return SizeCalculateWidget(
        onChange: (Size size) {
          setState(() {
            heightSubComment =
                heightSubComment - size.height - commentAvatarSize;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 8.0, horizontal: commentAvatarSize / 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageUtil.loadAssetsImage(
                  fileName: 'ic_line_sub_item.svg', width: 20),
              widget.isLoadingReplyComment
                  ? const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: IndicatorLoadMore())
                  : InkClickItem(
                      onTap: () {
                        if (widget.onViewMoreReplyComment != null) {
                          widget.onViewMoreReplyComment!(widget.commentModel);
                        }
                      },
                      child: Text(
                          '${l('View more')} ${remainComment()} ${l('Comment').toLowerCase()} ...'),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      borderRadius: BorderRadius.circular(8),
                    ),
            ],
          ),
        ),
      );
    }
    CommentModel? item = widget.commentModel.childs?.data?[index];
    if (item == null) return const SizedBox();
    return SizeCalculateWidget(
      onChange: (Size size) {
        if (!_isHasMoreSubComment() &&
            index == (widget.commentModel.childs!.data!.length - 1)) {
          setState(() {
            heightSubComment =
                heightSubComment - size.height - commentAvatarSize;
          });
        }
      },
      child: ItemCommentPost(
        parentCommentModel: widget.commentModel,
        commentModel: item,
        isSubComment: true,
        onReply: (replyModel, parentComment) {
          _onPressReply(replyComment: replyModel, parentComment: parentComment);
        },
        onLike: (commentModel, parentModel) {
          _onPressLike(commentModel, parentModel);
        },
      ),
    );
  }

  _onPressReply(
      {required CommentModel replyComment, CommentModel? parentComment}) {
    if (widget.onReply != null) {
      widget.onReply!(replyComment, parentComment);
    }
  }

  void _onPressLike(CommentModel item, CommentModel? parentModel) {
    if (widget.onLike != null) {
      widget.onLike!(item, parentModel);
    }
  }
}
