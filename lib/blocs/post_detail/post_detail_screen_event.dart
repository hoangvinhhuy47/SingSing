import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../data/models/comment.dart';

abstract class PostDetailScreenEvent extends Equatable {
  const PostDetailScreenEvent();

  @override
  List<Object> get props => [];
}

class PostDetailScreenStartedEvent extends PostDetailScreenEvent {}

class PostDetailGetCommentsEvent extends PostDetailScreenEvent {
  final bool isRefresh;

  const PostDetailGetCommentsEvent({this.isRefresh = false});
}

class PostDetailRefreshEvent extends PostDetailScreenEvent {}

class PostDetailScreenGetImageFromGallerySuccessEvent
    extends PostDetailScreenEvent {
  final File file;

  const PostDetailScreenGetImageFromGallerySuccessEvent({required this.file});
}

class PostDetailScreenLikePostEvent extends PostDetailScreenEvent {
  const PostDetailScreenLikePostEvent();
}

class PostDetailScreenOnPressSendEvent extends PostDetailScreenEvent {
  final String message;
  final CommentModel? commentModel;

  const PostDetailScreenOnPressSendEvent({required this.message,this.commentModel});
}

class PostDetailScreenRemoveFileEvent extends PostDetailScreenEvent {
  const PostDetailScreenRemoveFileEvent();
}

class PostDetailScreenPinPostEvent extends PostDetailScreenEvent {
  const PostDetailScreenPinPostEvent();
}

class PostDetailScreenRemovePinPostEvent extends PostDetailScreenEvent {
  const PostDetailScreenRemovePinPostEvent();
}

class PostDetailScreenDeletePostEvent extends PostDetailScreenEvent {
  const PostDetailScreenDeletePostEvent();
}

class PostDetailScreenReportPostEvent extends PostDetailScreenEvent {
  final String content;

  const PostDetailScreenReportPostEvent({required this.content});
}

class PostDetailScreenGetPostDetailEvent extends PostDetailScreenEvent {
  final bool isRefresh;

  const PostDetailScreenGetPostDetailEvent({this.isRefresh = false});
}

class PostDetailScreenRemoveCommentErrorEvent extends PostDetailScreenEvent {}

class PostDetailScreenLikeCommentEvent extends PostDetailScreenEvent {
  final CommentModel commentModel;
  final CommentModel? parentModel;

  const PostDetailScreenLikeCommentEvent({required this.commentModel, this.parentModel});
}

class PostDetailScreenGetReplyCommentEvent extends PostDetailScreenEvent {
  final CommentModel commentModel;

  const PostDetailScreenGetReplyCommentEvent({required this.commentModel});
}
