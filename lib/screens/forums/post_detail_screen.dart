import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sing_app/application.dart';
import 'package:sing_app/blocs/post_detail/post_detail_screen_event.dart';
import 'package:sing_app/blocs/post_detail/post_detail_screen_state.dart';
import 'package:sing_app/data/event_bus/event_bus_event.dart';
import 'package:sing_app/screens/forums/create_new_post_bottom_sheet.dart';
import 'package:sing_app/screens/forums/post_report_view.dart';
import 'package:sing_app/widgets/dialog/custom_alert_dialog.dart';
import 'package:sing_app/widgets/forum/item_post_widget.dart';
import 'package:sing_app/widgets/indicator_loadmore.dart';
import 'package:sing_app/widgets/ink_click_item.dart';
import 'package:sing_app/widgets/s2e_appbar.dart';

import '../../blocs/post_detail/post_detail_screen_bloc.dart';
import '../../config/app_localization.dart';
import '../../constants/constants.dart';
import '../../data/models/comment.dart';
import '../../utils/alert_util.dart';
import '../../utils/color_util.dart';
import '../../utils/file_util.dart';
import '../../utils/image_util.dart';
import '../../utils/styles.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/forum/item_comment_post.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetailScreen> {
  late final PostDetailScreenBloc _bloc;
  late final FocusNode _myFocusNode;
  late final TextEditingController _textEditingController;
  late final ScrollController _scrollCommentsController;
  late final Completer<void> _refreshCompleter;
  late final ImagePicker _picker;

  bool textFieldIsEmpty = true;
  bool isDeleteDialogShow = false;
  bool isReportDialogShow = false;
  late StreamSubscription _fetchNewPostListener;

  CommentModel? commentReply;
  CommentModel? commentParent;

  @override
  void initState() {
    _picker = ImagePicker();
    _scrollCommentsController = ScrollController();
    _textEditingController = TextEditingController();
    _bloc = BlocProvider.of<PostDetailScreenBloc>(context);
    _myFocusNode = FocusNode();
    _scrollCommentsController.addListener(_paginationComments);
    _refreshCompleter = Completer();
    if (_bloc.isFocusInput) {
      Future.delayed(
        const Duration(milliseconds: 300),
        () {
          _myFocusNode.requestFocus();
        },
      );
    }
    if (_bloc.isOpenGallery) {
      _onPressAttachPhoto();
    }

    _fetchNewPostListener = App.instance.eventBus
        .on<EventBusFetchNewPostInPostDetailSuccessEvent>()
        .listen((event) {
      _bloc.add(const PostDetailScreenGetPostDetailEvent());
    });
    super.initState();
  }

  @override
  void dispose() {
    _bloc.add(PostDetailScreenRemoveCommentErrorEvent());
    _myFocusNode.dispose();
    _bloc.close();
    _fetchNewPostListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBloc();
  }

  Widget _buildScreen(ctx, state) {
    final bool isLoading =
        (state is GetPostDetailLoadingState && state.isLoading);
    final String message =
        (state is GetPostDetailLoadingState ? state.message : '');
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: LoadingIndicator(
          isLoading: isLoading,
          text: message,
          child: _buildBody(ctx, state),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return S2EAppBar(
      backgroundColor: ColorUtil.primary,
      leadWidget: IconButton(
        icon: ImageUtil.loadAssetsImage(fileName: 'ic_back.svg'),
        tooltip: l('Back'),
        onPressed: _onPressBack,
      ),
      title: _bloc.post == null
          ? ''
          : AppLocalization.instance.locale.languageCode == 'vi'
              ? '${l('s post')} ${_bloc.post?.user.getFullName() ?? ''}'
              : '${_bloc.post?.user.getFullName()} \' ${l('s post')}',
      // actionWidgets: [
      //   IconButton(
      //     icon: true // todo condition update ic notification badge
      //         ? ImageUtil.loadAssetsImage(fileName: 'ic_notification_post.svg')
      //         : ImageUtil.loadAssetsImage(
      //             fileName: 'ic_notification_badge.svg'),
      //     tooltip: l('Notification'),
      //     onPressed: _onPressNotification,
      //   ),
      // ],
    );
  }

  Widget _buildBloc() {
    return BlocConsumer<PostDetailScreenBloc, PostDetailScreenState>(
      listener: (ctx, state) {
        if (state is PostDetailGetCommentsIsLoadingState && !state.isLoading) {
          if (!_refreshCompleter.isCompleted) {
            _refreshCompleter.complete();
            _refreshCompleter = Completer();
          }
        }
        if (state is PostDetailScreenPinnedPostSuccessState) {
          if (state.isSuccess) {
          } else {}
        }

        if (state is PostDetailScreenRemovePinnedPostSuccessState) {
          if (state.isSuccess) {
          } else {}
        }
        if (state is PostDetailScreenDeletePostSuccessState) {
          if (state.isSuccess) {
            Fluttertoast.showToast(msg: l('Post deleted'));
            Navigator.pop(context);
          } else {
            showSnackBarError(context: context, message: state.message);
          }
        }
        if (state is PostDetailScreenReportSuccessState) {
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
        if (state is GetPostDetailErrorState) {
          CustomAlertDialog.show(ctx,
              content: state.message,
              leftText: 'OK',
              isLeftPositive: true,
              isShowTitle: false, leftAction: () {
            Navigator.pop(context);
            Navigator.pop(context);
          });
        }
        if (state is PostDetailScreenUrlNowAllowState) {
          CustomAlertDialog.show(
            context,
            title: l('Notify'),
            content: l('This url violates our community standards'),
            leftText: 'OK',
            isLeftPositive: true,
            leftAction: () {
              Navigator.pop(context);
            },
          );
        }
      },
      buildWhen: (preState, nextState) {
        if (nextState is GetPostDetailErrorState) {
          return false;
        }
        return true;
      },
      builder: (ctx, state) {
        return _buildScreen(ctx, state);
      },
    );
  }

  Widget _buildBody(ctx, state) {
    if (_bloc.post == null && _bloc.forum == null) return Container();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SizedBox(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: MyStyles.horizontalMargin, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ItemPostWidget(
                              item: _bloc.post!,
                              user: _bloc.user,
                              onPressItemAction: _onPressItemAction,
                              posts: _bloc.forum!.posts,
                              pinnedPosts: _bloc.forum!.pinnedPosts,
                              onPressLikePost: _onPressActionLikePost,
                              onPressCommentPost: _onPressActionCommentPost),
                          const Divider(
                              color: ColorUtil.dividerColor, height: 0),
                          const SizedBox(height: 26),
                          _buildListComments(state),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        _writeCommentBox(),
      ],
    );
  }

  Widget _buildListComments(state) {
    return Visibility(
      visible:
          _bloc.post?.comments.isNotEmpty ?? false || _bloc.isLoadingComment,
      child: ListView.separated(
          controller: _scrollCommentsController,
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (ctx,index) =>_buildItemComment(ctx,index,state),
          separatorBuilder: (ctx, index) => const SizedBox(height: 16),
          itemCount: (_bloc.post?.comments.length ?? 0) +
              (_bloc.isLoadingComment ? 1 : 0)),
      replacement: Center(
        child: Column(
          children: [
            const SizedBox(height: 32),
            ImageUtil.loadAssetsImage(fileName: 'ic_comments_three_dots.svg'),
            const SizedBox(height: 12),
            Text(
              l('There are no comments yet'),
              style: s(context,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: ColorUtil.mainBlue),
            ),
            const SizedBox(height: 58),
          ],
        ),
      ),
    );
  }

  Widget _writeCommentBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (commentReply != null)
            Row(
              children: [
                Text(l('Reply'), style: s(context)),
                Flexible(
                  child: Text(
                    ' ${commentReply?.getUserFullName()}',
                    style: s(context),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                InkClickItem(
                    borderRadius: BorderRadius.circular(8),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    onTap: () {
                      setState(() {
                        commentReply = null;
                        commentParent = null;
                      });
                    },
                    child: Text(
                      l('Cancel'),
                      style: s(context, color: ColorUtil.textSecondaryColor),
                    )),
              ],
            ),
          Stack(
            alignment: Alignment.center,
            children: [
              _bloc.file != null
                  ? Padding(
                      padding: const EdgeInsets.all(8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _bloc.file!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : const SizedBox(),
              Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                  onTap: () => _onRemoveFilePicked(),
                  child:
                      ImageUtil.loadAssetsImage(fileName: 'ic_remove_file.svg'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(45),
                child: ImageUtil.loadNetWorkImage(
                    url: App.instance.userApp?.avatar ?? '',
                    height: 45,
                    width: 45),
              ),
              const SizedBox(width: 14),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    _myFocusNode.requestFocus();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: ColorUtil.backgroundItemColor,
                        borderRadius: BorderRadius.circular(22)),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 18),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: TextField(
                              controller: _textEditingController,
                              focusNode: _myFocusNode,
                              onChanged: (text) {
                                setState(() {
                                  textFieldIsEmpty = text.isEmpty;
                                });
                              },
                              maxLines: 4,
                              minLines: 1,
                              decoration: InputDecoration.collapsed(
                                  border: InputBorder.none,
                                  hintText: l('Write a comment') + ' ...'),
                            ),
                          ),
                        ),
                        InkClickItem(
                          borderRadius: BorderRadius.circular(20),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          onTap: _onPressAttachPhoto,
                          child: ImageUtil.loadAssetsImage(
                              fileName: 'ic_attach_photo.svg'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkClickItem(
                borderRadius: BorderRadius.circular(12),
                padding: const EdgeInsets.all(8),
                isEnabled: !(textFieldIsEmpty && _bloc.file == null),
                onTap: _onPressSendComment,
                child: AnimatedSwitcher(
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  duration: const Duration(
                      milliseconds: Constants.shortAnimationDuration),
                  child: ImageUtil.loadAssetsImage(
                      key: ValueKey(textFieldIsEmpty ? 0 : 1),
                      fileName: textFieldIsEmpty && _bloc.file == null
                          ? 'ic_send_inactive.svg'
                          : 'ic_send_active.svg'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildItemComment(ctx, index, state) {
    if (index >= _bloc.post!.comments.length) {
      return const IndicatorLoadMore();
    }

    final item = _bloc.post!.comments[index];
    return ItemCommentPost(
      key: UniqueKey(),
      commentModel: item,
      onLike: (commentModel, parentModel) {
        _bloc.add(PostDetailScreenLikeCommentEvent(
            commentModel: commentModel, parentModel: parentModel));
      },
      onReply: (commentReply, commentParent) {
        _myFocusNode.requestFocus();
        setState(() {
          this.commentReply = commentReply;
          this.commentParent = commentParent;
        });
      },
      onViewMoreReplyComment: (commentModel){
        _bloc.add(PostDetailScreenGetReplyCommentEvent(commentModel: commentModel));
      },
      isLoadingReplyComment:
          (state is PostDetailScreenLoadingGetReplyCommentsState &&
              state.isLoading &&
              state.commentModel.commentId == item.commentId),
    );
  }

  _onPressBack() {
    _myFocusNode.unfocus();
    Navigator.pop(context);
  }

  _onPressActionLikePost() {
    _bloc.add(const PostDetailScreenLikePostEvent());
  }

  _onPressActionCommentPost() {
    _myFocusNode.requestFocus();
  }

  _onPressAttachPhoto() async {
    File? file = await onGetPhotoFromGallery(
        context: context, funcPermission: () {}, picker: _picker);
    if (file != null) {
      FileCheck fileCheck = validateFile(type: FileType.photo, file: file);
      if (fileCheck == FileCheck.allow) {
        _bloc.add(PostDetailScreenGetImageFromGallerySuccessEvent(file: file));
      }
    }
  }

  _onPressItemAction(ActionsDialog enumAction) {
    Navigator.pop(context);

    switch (enumAction) {
      case ActionsDialog.pin:
        _bloc.add(const PostDetailScreenPinPostEvent());
        break;
      case ActionsDialog.unPin:
        _bloc.add(const PostDetailScreenRemovePinPostEvent());
        break;
      case ActionsDialog.edit:
        _onPressCreateNewPost();
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
              _bloc.add(const PostDetailScreenDeletePostEvent());
            },
            rightAction: () => {Navigator.pop(context)},
            backListener: () {
              isDeleteDialogShow = false;
            });
        break;
      case ActionsDialog.cancel:
        break;
      case ActionsDialog.report:
        isReportDialogShow = true;
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
              isReportDialogShow = false,
              if (content.toString().isNotEmpty)
                _bloc.add(PostDetailScreenReportPostEvent(content: content))
            });
        break;
    }
  }

  void _paginationComments() {
    if (_bloc.post != null &&
        _scrollCommentsController.position.extentAfter < 300 &&
        _bloc.post!.comments.length < _bloc.totalComment &&
        !_bloc.isLoadingComment) {
      _bloc.add(const PostDetailGetCommentsEvent());
    }
  }

  Future<void> _onRefresh() {
    _bloc.add(PostDetailRefreshEvent());
    return _refreshCompleter.future;
  }

  _onPressSendComment() {
    if (_textEditingController.text.isEmpty && _bloc.file == null) {
      Fluttertoast.showToast(msg: 'Write something');
      return;
    }

    _myFocusNode.unfocus();
    _bloc.add(PostDetailScreenOnPressSendEvent(
        message: _textEditingController.text,
        commentModel: commentParent ?? commentReply));
    _textEditingController.text = "";
    setState(() {
      commentReply = null;
      commentParent = null;
    });
  }

  _onRemoveFilePicked() {
    _bloc.add(const PostDetailScreenRemoveFileEvent());
  }

  _onPressCreateNewPost() {
    if (_bloc.forum != null && _bloc.post != null) {
      showModalBottomSheet(
          context: context,
          backgroundColor: ColorUtil.transparent,
          isScrollControlled: true,
          builder: (BuildContext ctx) {
            return FractionallySizedBox(
              heightFactor: 0.9,
              child: CreateNewPostBottomSheet(
                isOpenGalleryImmediately: false,
                forum: _bloc.forum!,
                postEdit: _bloc.post!,
                fromType: CreateNewPostBottomSheetFromType.postDetail,
              ),
            );
          });
    }
  }
}
