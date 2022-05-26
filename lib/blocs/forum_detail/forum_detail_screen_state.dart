import 'package:equatable/equatable.dart';
import 'package:sing_app/data/models/forum.dart';
import 'package:sing_app/data/models/post.dart';

abstract class ForumDetailScreenState extends Equatable {
  const ForumDetailScreenState();

  @override
  List<Object> get props => [];
}

class ForumDetailScreenInitialState extends ForumDetailScreenState {}

class ForumDetailScreenReloadDoneState extends ForumDetailScreenState {}

class ForumDetailScreenLoadingState extends ForumDetailScreenState {
  final bool isLoading;

  const ForumDetailScreenLoadingState({this.isLoading = false});
}

class ForumDetailScreenForumState extends ForumDetailScreenState {
  final Forum forum;

  const ForumDetailScreenForumState({required this.forum});

  @override
  List<Object> get props => [forum];
}

class ForumDetailScreenPostsRefreshState extends ForumDetailScreenState {}

class ForumDetailScreenPostsState extends ForumDetailScreenState {}

class ForumDetailScreenPinnedPostsState extends ForumDetailScreenState {
  final List<Post> pinnedPosts;

  const ForumDetailScreenPinnedPostsState({required this.pinnedPosts});

  @override
  List<Object> get props => [pinnedPosts];
}

class ForumDetailScreenLoadMorePinnedPostsState extends ForumDetailScreenState {
  const ForumDetailScreenLoadMorePinnedPostsState();
}

class ForumDetailScreenPinnedPostSuccessState extends ForumDetailScreenState {
  final bool isSuccess;

  const ForumDetailScreenPinnedPostSuccessState({required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class ForumDetailScreenRemovePinnedPostSuccessState
    extends ForumDetailScreenState {
  final bool isSuccess;

  const ForumDetailScreenRemovePinnedPostSuccessState(
      {required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class ForumDetailScreenDeletePostSuccessState extends ForumDetailScreenState {
  final bool isSuccess;
  final String message;

  const ForumDetailScreenDeletePostSuccessState(
      {required this.isSuccess, this.message = ''});

  @override
  List<Object> get props => [isSuccess];
}

class ForumDetailScreenLikePostSuccessState extends ForumDetailScreenState {}

class ForumDetailScreenDialogLoadingState extends ForumDetailScreenState {
  final bool isShow;
  final String message;

  const ForumDetailScreenDialogLoadingState(
      {required this.isShow, this.message = '...'});

  @override
  List<Object> get props => [isShow];
}

class ForumDetailScreenReportSuccessState extends ForumDetailScreenState {
  final String error;
  final String content;

  const ForumDetailScreenReportSuccessState(
      {this.error = '', required this.content});

  @override
  List<Object> get props => [error];
}
