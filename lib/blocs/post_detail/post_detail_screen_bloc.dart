import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/application.dart';
import 'package:sing_app/blocs/post_detail/post_detail_screen_event.dart';
import 'package:sing_app/blocs/post_detail/post_detail_screen_state.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/models/comment.dart';
import 'package:sing_app/data/repository/forum_repository.dart';
import 'package:sing_app/data/repository/ss_repository.dart';
import 'package:sing_app/utils/extensions/string_extension.dart';

import '../../data/event_bus/event_bus_event.dart';
import '../../data/models/forum.dart';
import '../../data/models/graph_url_info_model.dart';
import '../../data/models/post.dart';
import '../../data/models/user_profile.dart';

class PostDetailScreenBloc
    extends Bloc<PostDetailScreenEvent, PostDetailScreenState> {
  final bool isFocusInput;
  final bool isOpenGallery;
  Forum? forum;
  Post? post;
  final String? postId;
  final BaseForumRepository forumRepository;
  final BaseSsRepository ssRepository;
  final UserProfile? user = App.instance.userApp;

  int _totalComment = 0;
  bool _isLoadingComment = false;

  int get totalComment => _totalComment;

  bool get isLoadingComment => _isLoadingComment;

  File? file;
  GraphUrlInfo? graphUrlInfo;

  PostDetailScreenBloc({
    required this.forumRepository,
    required this.ssRepository,
    required this.post,
    required this.postId,
    required this.forum,
    required this.isFocusInput,
    required this.isOpenGallery,
  }) : super(PostDetailScreenInitialState()) {
    on<PostDetailScreenStartedEvent>((event, emit) async {
      await _mapPostDetailStartedEventToState(event, emit);
    });

    on<PostDetailRefreshEvent>((event, emit) async {
      add(const PostDetailGetCommentsEvent(isRefresh: true));
      add(const PostDetailScreenGetPostDetailEvent(isRefresh: true));
    });
    on<PostDetailGetCommentsEvent>((event, emit) async {
      await _mapGetCommentEventToState(event, emit);
    });
    on<PostDetailScreenLikePostEvent>((event, emit) async {
      await _mapPostDetailLikePostEventToState(event, emit);
    });

    on<PostDetailScreenGetImageFromGallerySuccessEvent>((event, emit) async {
      await _mapGetImageFromGallerySuccessEventToState(event, emit);
    });
    on<PostDetailScreenOnPressSendEvent>((event, emit) async {
      await _mapOnPressSendEventToState(event, emit);
    });
    on<PostDetailScreenRemoveFileEvent>((event, emit) async {
      await _mapPostDetailScreenRemoveFileEventToState(event, emit);
    });

    on<PostDetailScreenPinPostEvent>((event, emit) async {
      await _mapPostDetailScreenPinPostEventToState(event, emit);
    });
    on<PostDetailScreenRemovePinPostEvent>((event, emit) async {
      await _mapPostDetailScreenRemovePinPostEventToState(event, emit);
    });
    on<PostDetailScreenDeletePostEvent>((event, emit) async {
      await _mapPostDetailScreenDeletePostEventToState(event, emit);
    });
    on<PostDetailScreenReportPostEvent>((event, emit) async {
      await _mapPostDetailScreenReportPostEventToState(event, emit);
    });
    on<PostDetailScreenGetPostDetailEvent>((event, emit) async {
      await _mapGetPostDetailEventToState(event, emit);
    });
    on<PostDetailScreenRemoveCommentErrorEvent>((event, emit) async {
      await _mapRemoveCommentErrorEventToState(event, emit);
    });

    on<PostDetailScreenLikeCommentEvent>((event, emit) async {
      await _mapLikeCommentEventToState(event, emit);
    });

    on<PostDetailScreenGetReplyCommentEvent>((event, emit) async {
      await _mapGetReplyCommentEventToState(event, emit);
    });
  }

  Future _mapPostDetailStartedEventToState(PostDetailScreenStartedEvent event,
      Emitter<PostDetailScreenState> emit) async {
    if (postId?.isNotEmpty ?? false) {
      emit(const GetPostDetailLoadingState(isLoading: true));
      final res = await forumRepository.getPostDetail(postId: postId!);
      emit(const GetPostDetailLoadingState(isLoading: false));

      if (res.success) {
        post = res.data;
        forum = res.data?.group;
      } else {
        emit(GetPostDetailErrorState(
            message: res.error?.message ?? l('Get post detail error')));
        return;
      }
    }

    if (post != null) {
      add(const PostDetailGetCommentsEvent(isRefresh: true));
    }
  }

  Future _mapGetCommentEventToState(PostDetailGetCommentsEvent event,
      Emitter<PostDetailScreenState> emit) async {
    _isLoadingComment = true;
    emit(const PostDetailGetCommentsIsLoadingState(isLoading: true));
    emit(const PostDetailGetCommentsSuccessState());

    if (post != null) {
      final res = await forumRepository.getPostDetailComments(
          postId: post!.postId,
          offset: event.isRefresh ? 0 : post!.comments.length);
      if (res.success) {
        if (event.isRefresh) {
          post!.comments = res.data!;
        } else {
          post!.comments.addAll(res.data!);
        }
        _totalComment = res.pagination!.total;
      }
    }
    _isLoadingComment = false;
    emit(const PostDetailGetCommentsIsLoadingState(isLoading: false));
    emit(const PostDetailGetCommentsSuccessState());
    emit(PostDetailScreenInitialState());
  }

  Future _mapPostDetailLikePostEventToState(PostDetailScreenLikePostEvent event,
      Emitter<PostDetailScreenState> emit) async {
    if (post != null) {
      bool actionIsLike = !post!.isLiked;
      post!.isLiked = actionIsLike;
      if (actionIsLike) {
        post!.likeCount++;
      } else {
        post!.likeCount--;
      }
      emit(PostDetailScreenInitialState());
      emit(const PostDetailLikeSuccessState());
      App.instance.eventBus.fire(EventBusRefreshForumDetailScreenStateEvent());

      await forumRepository.likePost(
          postId: post!.postId, isLike: actionIsLike);
    }
  }

  Future _mapGetImageFromGallerySuccessEventToState(
      PostDetailScreenGetImageFromGallerySuccessEvent event,
      Emitter<PostDetailScreenState> emit) async {
    file = event.file;
    emit(PostDetailScreenInitialState());
    emit(const PostDetailGetImageSuccessfullyState());
  }

  _mapOnPressSendEventToState(PostDetailScreenOnPressSendEvent event,
      Emitter<PostDetailScreenState> emit) async {
    if (post != null) {
      final File? fileUpload = file;
      String mediaId = "";
      file = null;

      CommentModel commentTemp = _displayLocalComment(event);
      emit(PostDetailScreenInitialState());
      emit(const PostDetailCommentSuccessfullyState());

      if (fileUpload != null) {
        final resUploadPhoto =
            await forumRepository.uploadFilePhoto(file: fileUpload);
        if (resUploadPhoto.success && resUploadPhoto.data["media_id"] != null) {
          mediaId = resUploadPhoto.data["media_id"];
        } else {
          setCommentError(commentTemp, emit, event);
          return;
        }
      }
      String url = event.message.getFirstUrl();
      if (url.isNotEmpty) {
        final res = await ssRepository.getUrlInfo(url: url);
        if (res.success) {
          graphUrlInfo = res.data;
        } else {
          if(res.error?.code==400){
            emit(PostDetailScreenUrlNowAllowState());
            emit(PostDetailScreenInitialState());
          }
          setCommentError(commentTemp, emit, event);
          return;
        }
      }

      final res = await forumRepository.commentPost(
          postId: post!.postId,
          message: event.message,
          mediaId: mediaId,
          commentId: event.commentModel?.commentId,
          graphUrlInfo: graphUrlInfo);

      graphUrlInfo = null;
      if (res.success) {
        await replaceCommentTemp(commentTemp,res.data, emit, event);
      }else{
        setCommentError(commentTemp, emit, event);
        return;
      }
      // add(const PostDetailGetCommentsEvent(isRefresh: true));
      emit(PostDetailScreenInitialState());
    }
  }

  CommentModel _displayLocalComment(PostDetailScreenOnPressSendEvent event) {
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final commentTemp = CommentModel(
      username: user?.getFullName() ?? '',
      commentId: timestamp,
      avatar: App.instance.userApp?.avatar ?? "",
      message: event.message,
      state: CommentState.posting,
    );
    if (event.commentModel == null) {
      post!.comments.insert(0, commentTemp);
    } else {
      CommentModel parentComment = post!.comments[post!.comments.indexWhere(
          (element) => element.commentId == event.commentModel?.commentId)];
      parentComment.childs?.data ??= [];
      parentComment.childs?.data?.insert(0, commentTemp);
      parentComment.childs?.pagination?.total += 1;
    }
    post!.commentCount++;

    return commentTemp;
  }

  void setCommentError(
      CommentModel commentTemp,
      Emitter<PostDetailScreenState> emit,
      PostDetailScreenOnPressSendEvent event) {
    commentTemp.state = CommentState.error;
    if (event.commentModel == null) {
      post!.comments[post!.comments.indexWhere(
              (element) => element.commentId == commentTemp.commentId)] =
          commentTemp;
    } else {
      CommentModel parentComment = post!.comments[post!.comments.indexWhere(
          (element) => element.commentId == event.commentModel?.commentId)];
      parentComment.childs?.data?[parentComment.childs?.data?.indexWhere(
              (element) => element.commentId == commentTemp.commentId) ??
          -1] = commentTemp;
    }
    emit(PostDetailScreenInitialState());
    emit(const PostDetailCommentSuccessfullyState());
  }

  Future replaceCommentTemp(
      CommentModel commentTemp,
      CommentModel newComment,
      Emitter<PostDetailScreenState> emit,
      PostDetailScreenOnPressSendEvent event) async {
    if(newComment.createdAt.isEmpty){
      setCommentError(commentTemp, emit, event);
    } else if (event.commentModel == null) {
      post!.comments[post!.comments.indexWhere(
              (element) => element.commentId == commentTemp.commentId)] =
          newComment;
    } else {
      CommentModel parentComment = post!.comments[post!.comments.indexWhere(
          (element) => element.commentId == event.commentModel?.commentId)];
      parentComment.childs?.data?.removeWhere(
          (element) => element.commentId == commentTemp.commentId);
      parentComment.childs?.data?.insert(0, newComment);
    }
    emit(PostDetailScreenInitialState());
    emit(const PostDetailCommentSuccessfullyState());
  }

  _mapPostDetailScreenRemoveFileEventToState(
      PostDetailScreenRemoveFileEvent event,
      Emitter<PostDetailScreenState> emit) {
    file = null;
    emit(PostDetailScreenInitialState());
  }

  _mapPostDetailScreenPinPostEventToState(PostDetailScreenPinPostEvent event,
      Emitter<PostDetailScreenState> emit) async {
    if (post != null && forum != null) {
      emit(const GetPostDetailLoadingState(
          isLoading: true, message: '${'Loading'} ...'));
      final resJson = await forumRepository.pinPost(postId: post!.postId);
      if (resJson.success) {
        forum!.pinnedPosts.insert(0, post!);
        App.instance.eventBus
            .fire(EventBusRefreshForumDetailScreenStateEvent());
        emit(const PostDetailScreenPinnedPostSuccessState(isSuccess: true));
      } else {
        emit(const PostDetailScreenPinnedPostSuccessState(isSuccess: false));
      }
      emit(const GetPostDetailLoadingState(isLoading: false));
      emit(PostDetailScreenInitialState());
    }
  }

  _mapPostDetailScreenRemovePinPostEventToState(
      PostDetailScreenRemovePinPostEvent event,
      Emitter<PostDetailScreenState> emit) async {
    if (post != null && forum != null) {
      emit(const GetPostDetailLoadingState(
          isLoading: true, message: '${'Loading'} ...'));
      final String postId = post!.postId;
      final resJson = await forumRepository.removePinPost(postId: postId);
      if (resJson.success) {
        forum!.pinnedPosts.removeWhere((element) => element.postId == postId);
        App.instance.eventBus
            .fire(EventBusRefreshForumDetailScreenStateEvent());
        emit(const PostDetailScreenRemovePinnedPostSuccessState(
            isSuccess: true));
      } else {
        emit(const PostDetailScreenRemovePinnedPostSuccessState(
            isSuccess: false));
      }
      emit(const GetPostDetailLoadingState(isLoading: false));
      emit(PostDetailScreenInitialState());
    }
  }

  _mapPostDetailScreenDeletePostEventToState(
      PostDetailScreenDeletePostEvent event,
      Emitter<PostDetailScreenState> emit) async {
    if (post != null && forum != null) {
      emit(const GetPostDetailLoadingState(
          isLoading: true, message: '${'Deleting'} ...'));
      final String postId = post!.postId;
      final res = await forumRepository.deletePost(postId: postId);
      if (res.success) {
        forum!.posts.removeWhere((element) => element.postId == postId);
        forum!.pinnedPosts.removeWhere((element) => element.postId == postId);
        App.instance.eventBus
            .fire(EventBusForumDetailScreenDeletePostSuccessEvent());
        emit(const PostDetailScreenDeletePostSuccessState(isSuccess: true));
      } else {
        emit(PostDetailScreenDeletePostSuccessState(
            isSuccess: false, message: res.error?.message ?? ''));
      }
      emit(const GetPostDetailLoadingState(isLoading: false));
    }
  }

  _mapPostDetailScreenReportPostEventToState(
      PostDetailScreenReportPostEvent event,
      Emitter<PostDetailScreenState> emit) async {
    if (post != null) {
      emit(const GetPostDetailLoadingState(
          isLoading: true, message: '${'Reporting'} ...'));

      final res = await forumRepository.reportPost(
          content: event.content, postId: post!.postId);
      emit(const GetPostDetailLoadingState(isLoading: false));
      if (res.success) {
        emit(PostDetailScreenReportSuccessState(content: event.content));
      } else {
        emit(PostDetailScreenReportSuccessState(
            content: event.content,
            error: res.error?.message ?? "Something wrong"));
      }
    }
  }

  _mapGetPostDetailEventToState(PostDetailScreenGetPostDetailEvent event,
      Emitter<PostDetailScreenState> emit) async {
    if (post != null && forum != null) {
      if (!event.isRefresh) {
        emit(const GetPostDetailLoadingState(
            isLoading: true, message: '${'Loading'} ...'));
      }
      final res = await forumRepository.getPostDetail(postId: post!.postId);
      if (!event.isRefresh) {
        emit(const GetPostDetailLoadingState(isLoading: false));
      }

      if (res.success && res.data != null) {
        post!.message = res.data!.message;
        post!.medias = res.data!.medias;
        post!.link = res.data!.link;
        forum!.posts[forum!.posts
            .indexWhere((element) => element.postId == post!.postId)] = post!;
        App.instance.eventBus
            .fire(EventBusRefreshForumDetailScreenStateEvent());
        emit(PostDetailScreenInitialState());
      }
    }
  }

  _mapRemoveCommentErrorEventToState(
      PostDetailScreenRemoveCommentErrorEvent event,
      Emitter<PostDetailScreenState> emit) async {
    if (post != null && forum != null) {
      post!.comments.removeWhere((element) {
        element.childs?.data
            ?.removeWhere((child) => child.state == CommentState.error);
        if (element.state == CommentState.error) {
          return true;
        }
        return false;
      });
      forum!.posts[forum!.posts
          .indexWhere((element) => element.postId == post!.postId)] = post!;
      App.instance.eventBus.fire(EventBusRefreshForumDetailScreenStateEvent());
    }
  }

  _mapLikeCommentEventToState(PostDetailScreenLikeCommentEvent event,
      Emitter<PostDetailScreenState> emit) async {
    if (post != null && forum != null) {
      bool actionIsLike = !(event.commentModel.isLiked ?? false);
      if (event.parentModel != null) {
        int indexParentComment = post!.comments.indexOf(event.parentModel!);
        if (indexParentComment >= 0) {
          int indexChildComment = post!
              .comments[indexParentComment].childs!.data!
              .indexOf(event.commentModel);
          if (indexChildComment >= 0) {
            CommentModel commentModel = post!
                .comments[indexParentComment].childs!.data![indexChildComment];
            commentModel.isLiked = actionIsLike;
            if (actionIsLike) {
              commentModel.likeCount = commentModel.likeCount! + 1;
            } else {
              commentModel.likeCount = commentModel.likeCount! - 1;
            }
          }
        }
      } else {
        int indexComment = post!.comments.indexOf(event.commentModel);
        if (indexComment >= 0) {
          CommentModel commentModel = post!.comments[indexComment];
          commentModel.isLiked = actionIsLike;
          if (actionIsLike) {
            commentModel.likeCount = commentModel.likeCount! + 1;
          } else {
            commentModel.likeCount = commentModel.likeCount! - 1;
          }
        }
      }
      emit(PostDetailScreenLikeCommentState());
      emit(PostDetailScreenInitialState());
      final resJson = await forumRepository.likeComment(
          postId: post!.postId,
          commentId: event.commentModel.commentId,
          isLike: actionIsLike);
      if (resJson.success) {
      } else {}
    }
  }

  _mapGetReplyCommentEventToState(PostDetailScreenGetReplyCommentEvent event,
      Emitter<PostDetailScreenState> emit) async {
    if (post != null) {
      int indexParentComment = post!.comments.indexOf(event.commentModel);
      if (indexParentComment >= 0) {
        emit(PostDetailScreenLoadingGetReplyCommentsState(isLoading: true,commentModel: event.commentModel));
        final resJson = await forumRepository.getReplyComment(
            postId: post!.postId,
            commentId: event.commentModel.commentId,
            offset: post!.comments[indexParentComment].childs?.data?.length ?? 0,
            limit: post!.comments[indexParentComment].childs?.pagination?.limit ?? 5,
        );
        if (resJson.success && resJson.data != null) {
          post!.comments[indexParentComment].childs?.data?.addAll(resJson.data!);
          post!.comments[indexParentComment].childs?.pagination = resJson.pagination;
          emit(PostDetailScreenLoadingGetReplyCommentsState(isLoading: false,commentModel: event.commentModel));
          emit(PostDetailScreenGetReplyCommentsState());
          emit(PostDetailScreenInitialState());
        }
      }
    }
  }
}
