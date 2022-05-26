import '../../data/models/post.dart';

abstract class ForumDetailScreenEvent {
  const ForumDetailScreenEvent();
}

class ForumDetailScreenStartedEvent extends ForumDetailScreenEvent {
  final bool isRefresh;

  const ForumDetailScreenStartedEvent({this.isRefresh = false});
}

class GetForumDetailEvent extends ForumDetailScreenEvent {}

class GetForumDetailPostsEvent extends ForumDetailScreenEvent {
  final bool isRefresh;

  const GetForumDetailPostsEvent({this.isRefresh = false});
}

class GetForumDetailPinnedPostsEvent extends ForumDetailScreenEvent {
  final bool isRefresh;

  const GetForumDetailPinnedPostsEvent({this.isRefresh = false});
}

class GetForumDetailMembersEvent extends ForumDetailScreenEvent {
  final bool isRefresh;

  const GetForumDetailMembersEvent({this.isRefresh = false});
}

class ForumDetailScreenLikePostEvent extends ForumDetailScreenEvent {
  final int postIndex;

  const ForumDetailScreenLikePostEvent({required this.postIndex});
}

class ForumDetailScreenPinPostEvent extends ForumDetailScreenEvent {
  final Post post;

  const ForumDetailScreenPinPostEvent({required this.post});
}

class ForumDetailScreenRemovePinPostEvent extends ForumDetailScreenEvent {
  final Post post;

  const ForumDetailScreenRemovePinPostEvent({required this.post});
}

class ForumDetailScreenDeletePostEvent extends ForumDetailScreenEvent {
  final Post post;

  const ForumDetailScreenDeletePostEvent({required this.post});
}

class ForumDetailScreenReportPostEvent extends ForumDetailScreenEvent {
  final String postId;
  final String content;

  const ForumDetailScreenReportPostEvent(
      {required this.postId, required this.content});
}

class ForumDetailRefreshEvent extends ForumDetailScreenEvent {}

class ForumDetailScreenGetPostDetailEvent extends ForumDetailScreenEvent {
  final String postId;

  final bool isAddPost;

  const ForumDetailScreenGetPostDetailEvent(
      {required this.postId, required this.isAddPost});
}
