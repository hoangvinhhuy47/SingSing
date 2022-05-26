import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/application.dart';
import 'package:sing_app/blocs/forum_detail/forum_detail_screen_event.dart';
import 'package:sing_app/blocs/forum_detail/forum_detail_screen_state.dart';
import 'package:sing_app/data/models/user_profile.dart';
import 'package:sing_app/data/repository/forum_repository.dart';

import '../../config/app_localization.dart';
import '../../data/models/forum.dart';
import '../../data/models/post.dart';

class ForumDetailScreenBLoc
    extends Bloc<ForumDetailScreenEvent, ForumDetailScreenState> {
  final BaseForumRepository forumRepository;
  final Forum forum;
  final UserProfile? user = App.instance.userApp;

  bool _isRefreshing = false;
  bool _isPinnedPostsLoading = true;
  bool _isPostsLoading = true;

  int _totalPost = 0;

  int _totalPinnedPost = 0;

  int get totalPost => _totalPost;

  int get totalPinnedPost => _totalPinnedPost;

  bool get isRefreshing => _isRefreshing;

  bool get isPinnedPostsLoading => _isPinnedPostsLoading;

  bool get isPostsLoading => _isPostsLoading;


  ForumDetailScreenBLoc({
    required this.forumRepository,
    required this.forum,
  }) : super(ForumDetailScreenInitialState()) {
    on<ForumDetailScreenStartedEvent>((event, emit) async {
      if (event.isRefresh) {
        await Future.wait([
          _mapEventGetForumDetailToState(emit),
          _mapEventGetForumPostsToState(null, emit),
          _mapEventGetForumPinnedPostsToState(null, emit),
          _mapEventGetForumMembersToState(emit),
        ]).then((value) {
          emit(ForumDetailScreenReloadDoneState());
          emit(ForumDetailScreenInitialState());
        });
      } else {
        add(GetForumDetailEvent());
        add(const GetForumDetailPostsEvent(isRefresh: true));
        add(const GetForumDetailPinnedPostsEvent(isRefresh: true));
        add(const GetForumDetailMembersEvent(isRefresh: true));
      }
    });

    on<GetForumDetailEvent>((event, emit) async {
      await _mapEventGetForumDetailToState(emit);
    });
    on<GetForumDetailPostsEvent>((event, emit) async {
      await _mapEventGetForumPostsToState(event, emit);
    });
    on<GetForumDetailPinnedPostsEvent>((event, emit) async {
      await _mapEventGetForumPinnedPostsToState(event, emit);
    });
    on<GetForumDetailMembersEvent>((event, emit) async {
      await _mapEventGetForumMembersToState(emit);
    });
    on<ForumDetailScreenLikePostEvent>((event, emit) async {
      await _mapEventLikePostToState(event, emit);
    });
    on<ForumDetailScreenPinPostEvent>((event, emit) async {
      await _mapEventPinPostToState(event, emit);
    });
    on<ForumDetailScreenRemovePinPostEvent>((event, emit) async {
      await _mapEventRemovePinPostToState(event, emit);
    });
    on<ForumDetailScreenDeletePostEvent>((event, emit) async {
      await _mapEventDeletePostToState(event, emit);
    });
    on<ForumDetailScreenReportPostEvent>((event, emit) async {
      await _mapEventReportPostToState(event, emit);
    });

    on<ForumDetailRefreshEvent>((event, emit) async {
      emit(ForumDetailScreenLikePostSuccessState());
      emit(ForumDetailScreenInitialState());
    });
    on<ForumDetailScreenGetPostDetailEvent>((event, emit) async {
      await _mapGetPostDetailEventToState(event, emit);
    });
  }

  Future _mapEventGetForumDetailToState(
      Emitter<ForumDetailScreenState> emit) async {
    final res = await forumRepository.getForumDetail(forumId: forum.groupId);
    if (res.success && res.data != null) {
      Forum forumRes = res.data!;
      forum.cloneForum(forumRes);
      user?.type = forum.userType;
    }
    emit(ForumDetailScreenForumState(forum: forum));
    emit(ForumDetailScreenInitialState());

  }

  Future _mapEventGetForumPostsToState(GetForumDetailPostsEvent? event,
      Emitter<ForumDetailScreenState> emit) async {
    _isPostsLoading = true;
    emit(ForumDetailScreenPostsRefreshState());
    final res = await forumRepository.getForumDetailPosts(
        forumId: forum.groupId, offset: event == null||event.isRefresh ? 0 : forum.posts.length);
    if (res.success) {
      if (event == null||event.isRefresh) {
        forum.posts = res.data!;
      } else {
        forum.posts.addAll(res.data!);
      }
      _totalPost = res.pagination!.total;
    }
    _isPostsLoading = false;
    emit(ForumDetailScreenPostsState());
    emit(ForumDetailScreenInitialState());
  }

  Future _mapEventGetForumPinnedPostsToState(
      GetForumDetailPinnedPostsEvent? event,
      Emitter<ForumDetailScreenState> emit) async {
    _isPinnedPostsLoading = true;
    emit(const ForumDetailScreenLoadMorePinnedPostsState());
    final res = await forumRepository.getForumDetailPinnedPosts(
        forumId: forum.groupId,
        offset:
            event == null ||event.isRefresh? 0 : forum.pinnedPosts.length);
    if (res.success) {
      if (event==null||event.isRefresh) {
        forum.pinnedPosts = res.data!;
      } else {
        forum.pinnedPosts.addAll(res.data!);
      }
      _totalPinnedPost = res.pagination!.total;
    } else {}
    _isPinnedPostsLoading = false;
    emit(ForumDetailScreenPinnedPostsState(pinnedPosts: forum.pinnedPosts));
    emit(ForumDetailScreenInitialState());
  }

  Future _mapEventGetForumMembersToState(
      Emitter<ForumDetailScreenState> emit) async {
    final res =
        await forumRepository.getForumDetailMembers(forumId: forum.groupId);
    if (res.success) {
      forum.members = res.data!;
    }
    emit(ForumDetailScreenInitialState());
    emit(ForumDetailScreenInitialState());
    return;
  }

  Future _mapEventLikePostToState(ForumDetailScreenLikePostEvent event,
      Emitter<ForumDetailScreenState> emit) async {
    bool actionIsLike = !forum.posts[event.postIndex].isLiked;
    forum.posts[event.postIndex].isLiked = actionIsLike;
    if (actionIsLike) {
      forum.posts[event.postIndex].likeCount++;
    } else {
      forum.posts[event.postIndex].likeCount--;
    }

    emit(ForumDetailScreenLikePostSuccessState());
    emit(ForumDetailScreenInitialState());
    final resJson = await forumRepository.likePost(
        postId: forum.posts[event.postIndex].postId, isLike: actionIsLike);
    if (resJson.success) {
    } else {}
  }

  Future _mapEventPinPostToState(ForumDetailScreenPinPostEvent event,
      Emitter<ForumDetailScreenState> emit) async {
    emit(ForumDetailScreenDialogLoadingState(
        isShow: true, message: l('Loading') + ' ...'));
    final resJson = await forumRepository.pinPost(postId: event.post.postId);
    if (resJson.success) {
      forum.pinnedPosts.insert(0, event.post);
      emit(const ForumDetailScreenPinnedPostSuccessState(isSuccess: true));
    } else {
      emit(const ForumDetailScreenPinnedPostSuccessState(isSuccess: false));
    }
    emit(const ForumDetailScreenDialogLoadingState(isShow: false));
    emit(ForumDetailScreenInitialState());
  }

  Future _mapEventRemovePinPostToState(
      ForumDetailScreenRemovePinPostEvent event,
      Emitter<ForumDetailScreenState> emit) async {
    emit(ForumDetailScreenDialogLoadingState(
        isShow: true, message: l('Loading') + ' ...'));
    final String postId = event.post.postId;
    final resJson = await forumRepository.removePinPost(postId: postId);
    if (resJson.success) {
      forum.pinnedPosts.removeWhere((element) => element.postId == postId);
      emit(
          const ForumDetailScreenRemovePinnedPostSuccessState(isSuccess: true));
    } else {
      emit(const ForumDetailScreenRemovePinnedPostSuccessState(
          isSuccess: false));
    }
    emit(const ForumDetailScreenDialogLoadingState(isShow: false));
    emit(ForumDetailScreenInitialState());
  }

  Future _mapEventDeletePostToState(ForumDetailScreenDeletePostEvent event,
      Emitter<ForumDetailScreenState> emit) async {
    final String postId = event.post.postId;
    emit(ForumDetailScreenDialogLoadingState(
        isShow: true, message: l('Deleting') + ' ...'));
    final res = await forumRepository.deletePost(postId: postId);

    if (res.success) {
      forum.posts.removeWhere((element) {
        return element.postId == postId;
      });
      forum.pinnedPosts.removeWhere((element) {
        return element.postId == postId;
      });
      emit(const ForumDetailScreenDeletePostSuccessState(isSuccess: true));
      emit(ForumDetailScreenInitialState());
    } else {
      emit(ForumDetailScreenDeletePostSuccessState(
          isSuccess: false, message: res.error?.message ?? ''));
    }
    emit(const ForumDetailScreenDialogLoadingState(isShow: false));
    emit(ForumDetailScreenInitialState());
  }

  Future _mapEventReportPostToState(ForumDetailScreenReportPostEvent event,
      Emitter<ForumDetailScreenState> emit) async {
    emit(ForumDetailScreenDialogLoadingState(
        isShow: true, message: l('Reporting') + ' ...'));
    final res = await forumRepository.reportPost(
        content: event.content, postId: event.postId);
    emit(const ForumDetailScreenDialogLoadingState(isShow: false));

    if (res.success) {
      emit(ForumDetailScreenReportSuccessState(content: event.content));
    } else {
      emit(ForumDetailScreenReportSuccessState(
          content: event.content,
          error: res.error?.message ?? "Something wrong"));
    }
  }

  _mapGetPostDetailEventToState(ForumDetailScreenGetPostDetailEvent event,
      Emitter<ForumDetailScreenState> emit) async {
    emit(ForumDetailScreenDialogLoadingState(
        isShow: true, message: l('Loading') + ' ...'));
    final res = await forumRepository.getPostDetail(postId: event.postId);
    emit(const ForumDetailScreenDialogLoadingState(isShow: false));

    if (res.success && res.data != null) {
      Post post = res.data!;
      if (event.isAddPost) {
        forum.posts.insert(0, post);
      } else {
        /// is update
        forum.posts[forum.posts
            .indexWhere((element) => element.postId == post.postId)] = post;
        forum.pinnedPosts[forum.pinnedPosts
            .indexWhere((element) => element.postId == post.postId)] = post;
      }
    }

    add(ForumDetailRefreshEvent());
  }
}
