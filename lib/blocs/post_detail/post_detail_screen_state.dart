import 'package:equatable/equatable.dart';

import '../../data/models/comment.dart';

abstract class PostDetailScreenState extends Equatable {
  const PostDetailScreenState();

  @override
  List<Object> get props => [];
}

class PostDetailScreenInitialState extends PostDetailScreenState {}

class PostDetailGetCommentsIsLoadingState extends PostDetailScreenState {
  final bool isLoading;

  const PostDetailGetCommentsIsLoadingState({this.isLoading = true});

  @override
  List<Object> get props => [isLoading];
}

class GetPostDetailLoadingState extends PostDetailScreenState {
  final bool isLoading;
  final String message;

  const GetPostDetailLoadingState({required this.isLoading, this.message = ''});

  @override
  List<Object> get props => [isLoading, message];
}

class GetPostDetailErrorState extends PostDetailScreenState {
  final String message;

  const GetPostDetailErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class PostDetailGetCommentsSuccessState extends PostDetailScreenState {
  const PostDetailGetCommentsSuccessState();
}

class PostDetailLikeSuccessState extends PostDetailScreenState {
  const PostDetailLikeSuccessState();
}

class PostDetailGetImageSuccessfullyState extends PostDetailScreenState {
  const PostDetailGetImageSuccessfullyState();
}

class PostDetailCommentSuccessfullyState extends PostDetailScreenState {
  const PostDetailCommentSuccessfullyState();
}

class PostDetailScreenPinnedPostSuccessState extends PostDetailScreenState {
  final bool isSuccess;

  const PostDetailScreenPinnedPostSuccessState({required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class PostDetailScreenRemovePinnedPostSuccessState
    extends PostDetailScreenState {
  final bool isSuccess;

  const PostDetailScreenRemovePinnedPostSuccessState({required this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class PostDetailScreenDeletePostSuccessState extends PostDetailScreenState {
  final bool isSuccess;
  final String message;

  const PostDetailScreenDeletePostSuccessState(
      {required this.isSuccess, this.message = ''});

  @override
  List<Object> get props => [isSuccess];
}

class PostDetailScreenReportSuccessState extends PostDetailScreenState {
  final String error;
  final String content;

  const PostDetailScreenReportSuccessState(
      {this.error = '', required this.content});

  @override
  List<Object> get props => [error];
}
class PostDetailScreenLikeCommentState extends PostDetailScreenState {}
class PostDetailScreenGetReplyCommentsState extends PostDetailScreenState {}
class PostDetailScreenLoadingGetReplyCommentsState extends PostDetailScreenState {
  final bool isLoading;
  final CommentModel commentModel;

  const PostDetailScreenLoadingGetReplyCommentsState({required this.isLoading,required this.commentModel});
}
class PostDetailScreenUrlNowAllowState extends PostDetailScreenState {}

