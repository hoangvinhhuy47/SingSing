import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sing_app/application.dart';
import 'package:sing_app/blocs/forum_detail/forum_detail_screen_bloc.dart';
import 'package:sing_app/blocs/forum_detail/forum_detail_screen_event.dart';
import 'package:sing_app/blocs/forum_detail/forum_detail_screen_state.dart';
import 'package:sing_app/data/models/media.dart';
import 'package:sing_app/data/models/post.dart';
import 'package:sing_app/routes.dart';
import 'package:sing_app/screens/forums/post_report_view.dart';
import 'package:sing_app/utils/alert_util.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/dialog/custom_alert_dialog.dart';
import 'package:sing_app/widgets/dialog/loading_dialog.dart';
import 'package:sing_app/widgets/forum/comment_box_widget.dart';
import 'package:sing_app/widgets/forum/item_pinned_post_widget.dart';
import 'package:sing_app/widgets/forum/item_post_widget.dart';
import 'package:sing_app/widgets/s2e_appbar.dart';
import '../../config/app_localization.dart';
import '../../constants/constants.dart';
import '../../data/event_bus/event_bus_event.dart';
import '../../utils/image_util.dart';
import '../../widgets/indicator_loadmore.dart';
import '../../widgets/forum/item_comment_post.dart';
import '../../widgets/ink_click_item.dart';
import 'create_new_post_bottom_sheet.dart';

const numberOfMember = 7;

class ForumDetailScreen extends StatefulWidget {
  const ForumDetailScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForumDetailState();
}

class _ForumDetailState extends State<ForumDetailScreen> {
  late ForumDetailScreenBLoc _bloc;

  final _scrollPostController = ScrollController();
  final _scrollPinnedController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isDeleteDialogShow = false;

  late Completer<void> _refreshCompleter;
  late StreamSubscription _refreshForumDetailStateListener;
  late StreamSubscription _fetchNewPostListener;
  late StreamSubscription _deletePostListener;
  late StreamSubscription _onNewNotificationListener;
  @override
  void initState() {
    _bloc = BlocProvider.of<ForumDetailScreenBLoc>(context);
    _refreshCompleter = Completer();

    _scrollPostController.addListener(_paginationPosts);
    _scrollPinnedController.addListener(_paginationPinned);

    _refreshForumDetailStateListener = App.instance.eventBus.on<EventBusRefreshForumDetailScreenStateEvent>().listen((event) {
      _bloc.add(ForumDetailRefreshEvent());
    });

    _fetchNewPostListener = App.instance.eventBus.on<EventBusFetchNewPostInForumDetailSuccessEvent>().listen((event) {
      _bloc.add(ForumDetailScreenGetPostDetailEvent(postId: event.postId, isAddPost: event.isAddPost));
    });
    _deletePostListener = App.instance.eventBus.on<EventBusForumDetailScreenDeletePostSuccessEvent>().listen((event) {
      setState(() {});
    });

    _onNewNotificationListener = App.instance.eventBus.on<EventBusOnNewNotificationEvent>().listen((event) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _deletePostListener.cancel();
    _refreshForumDetailStateListener.cancel();
    _fetchNewPostListener.cancel();
    _onNewNotificationListener.cancel();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ColorUtil.primary,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: _buildBloc(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return S2EAppBar(
      isBackNavigation: true,
      actionWidgets: [
        IconButton(
          icon: ImageUtil.loadAssetsImage(
              fileName: App.instance.hasNewNotification
                  ? 'ic_notification_badge.svg'
                  : 'ic_notification.svg',
              width: 18,
              height: 18),
          tooltip: l('Notification'),
          onPressed: _onPressNotification,
        )
      ],
      title: l('SuperFan Club'),
      titleFontSize: 18,
    );
  }

  Widget _buildBloc() {
    final memberPhotoSize =
        MediaQuery.of(context).size.width / (numberOfMember + 1) - 4;
    return BlocConsumer<ForumDetailScreenBLoc, ForumDetailScreenState>(
      listener: (ctx, state) {
        if (state is ForumDetailScreenReloadDoneState) hideRefreshIndicator();

        if (state is ForumDetailScreenPinnedPostSuccessState) {
          if (state.isSuccess) {
          } else {}
        }

        if (state is ForumDetailScreenRemovePinnedPostSuccessState) {
          if (state.isSuccess) {
          } else {}
        }

        if (state is ForumDetailScreenDeletePostSuccessState) {
          if (state.isSuccess) {
            Fluttertoast.showToast(msg: l('Post deleted'));
          } else {
            showSnackBarError(context: context, message: state.message);
          }
        }
        if (state is ForumDetailScreenDialogLoadingState) {
          if (state.isShow) {
            LoadingDialog.show(context, state.message);
          } else {
            Navigator.pop(context);
          }
        }
        if (state is ForumDetailScreenReportSuccessState) {
          if (state.error.isEmpty) {
            CustomAlertDialog.show(ctx,
                content:
                    '${l("Reported")} ${state.content}\n${l('Thanks for letting us know.')}',
                asset: 'ic_checked_circle.svg',
                leftText: 'OK',
                isLeftPositive: true, leftAction: () {
              Navigator.pop(context);
            });
          } else {
            showSnackBarError(context: context, message: state.error);
          }
        }
      },
      builder: (ctx, state) {
        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              controller: _scrollPostController,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: MyStyles.horizontalMargin),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: ImageUtil.loadNetWorkImage(
                              url: _bloc.forum.cover,
                              height: 200,
                              width: double.maxFinite,
                              fit: BoxFit.fitWidth),
                        ),
                        const SizedBox(height: 20),
                        Text(_bloc.forum.title,
                            style: s(context, fontSize: 22)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(_bloc.forum.memberCount.toString(),
                                style: s(context, fontSize: 14)),
                            Text(' SuperFans',
                                style: s(context,
                                    fontSize: 14,
                                    color: ColorUtil.textSecondaryColor))
                          ],
                        ),
                        const SizedBox(height: 20),
                        InkClickItem(
                            borderRadius: BorderRadius.circular(17),
                            onTap: _onPressMemberList,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                for (var i = 0; i < numberOfMember; i++)
                                  _buildItemFan(i, memberPhotoSize)
                              ],
                            )),
                      ],
                    ),
                  ),

                  _buildDivider(),

                  /// Create new post
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: MyStyles.horizontalMargin),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: ImageUtil.loadNetWorkImage(
                            url: App.instance.userApp?.avatar ?? '',
                            height: 45,
                            width: 45,
                            placeHolder: assetImg('ic_user_profile.svg'),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: InkClickItem(
                            onTap: () => _onPressCreateNewPost(
                                isOpenGalleryImmediately: false),
                            color: ColorUtil.backgroundItemColor,
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 22),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    l('Write something') + ' ...',
                                    style: s(context,
                                        color: ColorUtil.textSecondaryColor,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18),
                                  ),
                                  InkClickItem(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 11, horizontal: 22),
                                    borderRadius: BorderRadius.circular(22),
                                    onTap: () => _onPressCreateNewPost(
                                        isOpenGalleryImmediately: true),
                                    child: ImageUtil.loadAssetsImage(
                                        fileName: 'ic_attach_photo.svg'),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  _buildDivider(),

                  /// Text FEATURED
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: MyStyles.horizontalMargin),
                    child: Visibility(
                      visible: _bloc.forum.pinnedPosts.isNotEmpty,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Featured',
                              style: MyStyles.of(context)
                                  .screenTitleText()
                                  .copyWith()),
                          const SizedBox(height: 20),
                        ],
                      ),
                      replacement: const SizedBox(height: 8),
                    ),
                  ),

                  Visibility(
                    visible: !(_bloc.isPinnedPostsLoading &&
                        _bloc.forum.pinnedPosts.isEmpty),
                    replacement: const IndicatorLoadMore(),
                    child: Visibility(
                      visible: _bloc.forum.pinnedPosts.isNotEmpty,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 390,
                            child: ListView.separated(
                              controller: _scrollPinnedController,
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: MyStyles.horizontalMargin),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (ctx, index) =>
                                  _buildItemPinnedPost(ctx, index),
                              separatorBuilder: (ctx, index) => const Padding(
                                  padding: EdgeInsets.only(right: 20)),
                              itemCount: _bloc.forum.pinnedPosts.length +
                                  (_bloc.forum.pinnedPosts.length <
                                              _bloc.totalPinnedPost ||
                                          _bloc.isPinnedPostsLoading
                                      ? 1
                                      : 0),
                            ),
                          ),
                          _buildDivider(),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: MyStyles.horizontalMargin),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l('News Feed'),
                            style: MyStyles.of(context)
                                .screenTitleText()
                                .copyWith()),
                        const SizedBox(height: MyStyles.horizontalMargin)
                      ],
                    ),
                  ),

                  /// POSTS
                  Visibility(
                    replacement: const IndicatorLoadMore(),
                    visible:
                        !(_bloc.isPostsLoading && _bloc.forum.posts.isEmpty),
                    child: Visibility(
                      visible: _bloc.forum.posts.isNotEmpty,
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(bottom: 8),
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: _itemPost,
                        separatorBuilder: (ctx, index) => Visibility(
                            visible: index != _bloc.forum.posts.length - 1,
                            child: _buildDivider(height: 0)),
                        itemCount: _bloc.forum.posts.length +
                            (_bloc.forum.posts.length < _bloc.totalPost
                                ? 1
                                : 0),
                      ),
                      replacement: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ImageUtil.loadAssetsImage(
                                fileName: 'ic_forum_placeholder.svg'),
                            Text(l('There are no posts yet')),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void hideRefreshIndicator() {
    if (!_refreshCompleter.isCompleted) {
      _refreshCompleter.complete();
      _refreshCompleter = Completer();
    }
  }

  Widget _buildDivider({double height = 40}) {
    return Divider(color: Colors.black, height: height, thickness: 6);
  }

  Widget _buildItemFan(index, double memberPhotoSize) {
    if (index >= _bloc.forum.members.length) {
      return SizedBox(width: memberPhotoSize);
    }
    final item = _bloc.forum.members[index];
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(memberPhotoSize / 2),
          child: ImageUtil.loadNetWorkImage(
            url: item.avatar,
            height: memberPhotoSize,
            width: memberPhotoSize,
            fit: BoxFit.cover,
            placeHolder: assetImg('ic_user_profile.svg'),
          ),
        ),
        Visibility(
          child: Container(
            width: memberPhotoSize,
            height: memberPhotoSize,
            decoration: BoxDecoration(
                color: ColorUtil.blurBgColor,
                borderRadius: BorderRadius.circular(memberPhotoSize / 2)),
          ),
          visible: index == numberOfMember - 1,
        ),
        Visibility(
          child: ImageUtil.loadAssetsImage(
              fileName: 'ic_three_dots_horizontal.svg'),
          visible: index == numberOfMember - 1,
        ),
      ],
    );
  }

  Widget _itemPost(BuildContext ctx, int index) {
    if (index >= _bloc.forum.posts.length) return const IndicatorLoadMore();

    final Post item = _bloc.forum.posts[index];
    return InkClickItem(
      key: ObjectKey(item.postId),
      onTap: () => _onPressPost(post: item),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: MyStyles.horizontalMargin, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ItemPostWidget(
              isDetailPost: false,
              item: item,
              user: _bloc.user,
              onPressItemAction: (enumAction) =>
                  _onPressItemAction(enumAction, item),
              posts: _bloc.forum.posts,
              pinnedPosts: _bloc.forum.pinnedPosts,
              onPressLikePost: () =>
                  _bloc.add(ForumDetailScreenLikePostEvent(postIndex: index)),
              onPressCommentPost: () =>
                  _onPressPost(post: item, isComment: true),
            ),
            const SizedBox(height: 16),
            CommentBoxWidget(
                onPressComment: () => _onPressPost(post: item, isComment: true),
                onPressPhotoGallery: () =>
                    _onPressPost(post: item, isOpenGallery: true)),
            SizedBox(height: item.comments.isNotEmpty ? 16 : 0),
            ListView.separated(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (ctx, index) => ItemCommentPost(
                    commentModel: item.comments[index],
                    onPress: () => {_onPressPost(post: item)},
                    isShortComment: true),
                separatorBuilder: (ctx, index) => const SizedBox(height: 12),
                itemCount: item.comments.isNotEmpty ? 1 : 0),
          ],
        ),
      ),
    );
  }

  Widget _buildItemPinnedPost(BuildContext ctx, int index) {
    if (index >= _bloc.forum.pinnedPosts.length) {
      return const IndicatorLoadMore();
    }
    final item = _bloc.forum.pinnedPosts[index];
    return ItemPinnedPostWidget(
      item: item,
      onPressPost: () => {_onPressPost(post: item)},
      user: _bloc.user,
      posts: _bloc.forum.posts,
      pinnedPosts: _bloc.forum.pinnedPosts,
      onPressItemAction: (ActionsDialog actionsDialog) {
        _onPressItemAction(actionsDialog, item);
      },
    );
  }

  _onPressNotification() {
    Navigator.of(context).pushNamed(Routes.notificationScreen,
        arguments: {'forum': _bloc.forum});
  }

  _onPressCreateNewPost({required bool isOpenGalleryImmediately, Post? post}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: ColorUtil.transparent,
        isScrollControlled: true,
        builder: (BuildContext ctx) {
          return FractionallySizedBox(
            heightFactor: 0.9,
            child: CreateNewPostBottomSheet(
              isOpenGalleryImmediately: isOpenGalleryImmediately,
              forum: _bloc.forum,
              postEdit: post,
              fromType: CreateNewPostBottomSheetFromType.forumDetail,
            ),
          );
        });
  }

  _onPressPost(
      {required Post post,
      bool isComment = false,
      bool isOpenGallery = false}) {
    Navigator.pushNamed(context, Routes.postDetailScreen, arguments: {
      PostDetailScreenArgs.isFocusCommentField: isComment,
      PostDetailScreenArgs.isOpenGallery: isOpenGallery,
      PostDetailScreenArgs.post: post,
      PostDetailScreenArgs.forum: _bloc.forum,
    }).then((value) {
      if (value == true) {
        _bloc.add(ForumDetailRefreshEvent());
      }
    });
  }

  _onPressMemberList() {
    Navigator.pushNamed(context, Routes.forumMemberScreen, arguments: {
      ForumMemberScreenArgs.initMember: _bloc.forum.members,
      ForumMemberScreenArgs.forum: _bloc.forum,
    });
  }

  onPressReportPost(Post item) {
    showModalBottomSheet(
        context: context,
        backgroundColor: ColorUtil.transparent,
        isScrollControlled: true,
        builder: (BuildContext ctx) {
          return FractionallySizedBox(
            heightFactor: 0.9,
            child: PostReportView(),
          );
        }).then((content) => {
          if (content.toString().isNotEmpty)
            _bloc.add(ForumDetailScreenReportPostEvent(
                content: content, postId: item.postId))
        });
  }

  onPressPostImage(List<MediaModel> medias, index) {
    Navigator.pushNamed(context, Routes.previewImageGalleryScreen, arguments: {
      PreviewImageScreenArgs.medias: medias,
      PreviewImageScreenArgs.initialIndex: index,
    });
  }

  _onPressItemAction(ActionsDialog enumAction, Post item) {
    Navigator.pop(context);
    switch (enumAction) {
      case ActionsDialog.pin:
        _bloc.add(ForumDetailScreenPinPostEvent(post: item));
        break;
      case ActionsDialog.unPin:
        _bloc.add(ForumDetailScreenRemovePinPostEvent(post: item));
        break;
      case ActionsDialog.edit:
        _onPressCreateNewPost(isOpenGalleryImmediately: false, post: item);
        break;
      case ActionsDialog.delete:
        isDeleteDialogShow = true;
        CustomAlertDialog.show(context,
            title: l('Delete'),
            content: l(
                'Are you sure you want to permanently remove this post from SingSing?'),
            leftText: l('Delete'),
            rightText: l('Cancel'),
            isLeftPositive: true,
            leftAction: () {
              Navigator.pop(context);
              _bloc.add(ForumDetailScreenDeletePostEvent(post: item));
            },
            rightAction: () => {Navigator.pop(context)},
            backListener: () {
              isDeleteDialogShow = false;
            });
        break;
      case ActionsDialog.cancel:
        break;
      case ActionsDialog.report:
        showModalBottomSheet(
            context: context,
            backgroundColor: ColorUtil.transparent,
            isScrollControlled: true,
            builder: (BuildContext ctx) {
              return FractionallySizedBox(
                heightFactor: 0.9,
                child: PostReportView(),
              );
            }).then((content) => {
              if (content.toString().isNotEmpty)
                _bloc.add(ForumDetailScreenReportPostEvent(
                    content: content, postId: item.postId))
            });
        break;
    }
  }

  Future<void> _onRefresh() {
    _bloc.add(const ForumDetailScreenStartedEvent(isRefresh: true));
    return _refreshCompleter.future;
  }

  void _paginationPosts() {
    if (_scrollPostController.position.extentAfter < 300 &&
        _bloc.forum.posts.length < _bloc.totalPost &&
        !_bloc.isPostsLoading) {
      _bloc.add(const GetForumDetailPostsEvent());
    }
  }

  void _paginationPinned() {
    if (_scrollPostController.position.extentAfter < 150 &&
        _bloc.forum.pinnedPosts.length < _bloc.totalPinnedPost &&
        !_bloc.isPostsLoading) {
      _bloc.add(const GetForumDetailPinnedPostsEvent());
    }
  }
}
