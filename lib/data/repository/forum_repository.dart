import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sing_app/data/data_provider/base_api.dart';
import 'package:sing_app/data/data_provider/forum_api_provider.dart';
import 'package:sing_app/data/models/comment.dart';
import 'package:sing_app/data/models/forum.dart';
import 'package:sing_app/data/models/graph_url_info_model.dart';
import 'package:sing_app/data/models/user_profile.dart';
import 'package:sing_app/data/response/ss_response.dart';

import '../models/post.dart';

abstract class BaseForumRepository {
  /// FORUMS
  Future<PaginatorSsResponse<Forum>> getForums({int offset, String keyword});

  Future<DefaultSsResponse<Forum>> getForumDetail({required String forumId});

  Future<PaginatorSsResponse<Post>> getForumDetailPosts(
      {required String forumId, int offset});

  Future<PaginatorSsResponse<Post>> getForumDetailPinnedPosts(
      {required String forumId, int offset});

  Future<PaginatorSsResponse<UserProfile>> getForumDetailMembers(
      {required String forumId, int offset, String keyword});

  /// POSTS
  Future<DefaultSsResponse> createNewPost({
    required String forumId,
    required String message,
    required List<String> medias,
    GraphUrlInfo? graphUrlInfo,
  });

  Future<DefaultSsResponse> updatePost(
      {required String postId,
      required String message,
      required List<String> medias,
      GraphUrlInfo? graphUrlInfo});

  Future<DefaultSsResponse<Post>> getPostDetail({required String postId});

  Future<PaginatorSsResponse<CommentModel>> getPostDetailComments(
      {required String postId, int offset});

  Future<DefaultSsResponse> likePost(
      {required String postId, required bool isLike});

  Future<DefaultSsResponse> pinPost({required String postId});

  Future<DefaultSsResponse> removePinPost({required String postId});

  Future<DefaultSsResponse> deletePost({required String postId});

  Future<DefaultSsResponse> commentPost(
      {required String postId,
      required String message,
      required String mediaId,
      String? commentId,
      GraphUrlInfo? graphUrlInfo});

  Future<DefaultSsResponse> reportPost(
      {required String postId, required String content});

  Future<DefaultSsResponse> likeComment(
      {required String postId,
      required String commentId,
      required bool isLike});

  Future<PaginatorSsResponse<CommentModel>> getReplyComment(
      {required String postId, required String commentId, int offset = 0,int limit = 5});

  ///MEDIA
  Future<DefaultSsResponse> uploadAssetPhoto({required MultipartFile multipartFile});

  Future<DefaultSsResponse> uploadFilePhoto({required File file});

  Future<DefaultSsResponse> uploadVideo({required File file});

  Future<DefaultSsResponse> deleteMedia({required String mediaId});
}

class ForumRepository extends BaseForumRepository {
  late ForumApiProvider _forumApiProvider;

  ForumRepository(BaseAPI baseAPI) {
    _forumApiProvider = ForumApiProvider(baseAPI);
  }

  @override
  Future<PaginatorSsResponse<Forum>> getForums(
      {int offset = 0, String keyword = ''}) async {
    return _forumApiProvider.getForums(offset: offset, keyword: keyword);
  }

  @override
  Future<DefaultSsResponse<Forum>> getForumDetail({required String forumId}) {
    return _forumApiProvider.getForumDetail(forumId: forumId);
  }

  @override
  Future<PaginatorSsResponse<Post>> getForumDetailPosts(
      {required String forumId, int offset = 0}) {
    return _forumApiProvider.getForumDetailPosts(
        forumId: forumId, offset: offset);
  }

  @override
  Future<PaginatorSsResponse<Post>> getForumDetailPinnedPosts(
      {required String forumId, int offset = 0}) {
    return _forumApiProvider.getForumDetailPinnedPosts(
        forumId: forumId, offset: offset);
  }

  @override
  Future<PaginatorSsResponse<UserProfile>> getForumDetailMembers(
      {required String forumId, int offset = 0, String keyword = ''}) {
    return _forumApiProvider.getForumDetailMembers(
        forumId: forumId, offset: offset, keyword: keyword);
  }

  @override
  Future<DefaultSsResponse<Post>> getPostDetail({required String postId}) {
    return _forumApiProvider.getPostDetail(postId: postId);
  }

  @override
  Future<PaginatorSsResponse<CommentModel>> getPostDetailComments(
      {required String postId, int offset = 0}) {
    return _forumApiProvider.getPostDetailComments(
        postId: postId, offset: offset);
  }

  @override
  Future<DefaultSsResponse> createNewPost(
      {required String forumId,
      required String message,
      required List<String> medias,
      GraphUrlInfo? graphUrlInfo}) {
    return _forumApiProvider.createNewPosts(
        forumId: forumId,
        message: message,
        medias: medias,
        graphUrlInfo: graphUrlInfo);
  }

  @override
  Future<DefaultSsResponse> likePost(
      {required String postId, required bool isLike}) {
    return _forumApiProvider.likePost(postId: postId, isLike: isLike);
  }

  @override
  Future<DefaultSsResponse> removePinPost({required String postId}) {
    return _forumApiProvider.removePinPost(postId: postId);
  }

  @override
  Future<DefaultSsResponse> pinPost({required String postId}) {
    return _forumApiProvider.pinPost(postId: postId);
  }

  @override
  Future<DefaultSsResponse> deletePost({required String postId}) {
    return _forumApiProvider.deletePost(postId: postId);
  }

  @override
  Future<DefaultSsResponse> uploadAssetPhoto({
    required MultipartFile multipartFile,
  }) {
    return _forumApiProvider.uploadPhoto(multipartFile: multipartFile);
  }

  @override
  Future<DefaultSsResponse> uploadVideo({required File file}) {
    return _forumApiProvider.uploadVideo(file: file);
  }

  @override
  Future<DefaultSsResponse> uploadFilePhoto({required File file}) {
    return _forumApiProvider.uploadFilePhoto(file: file);
  }

  @override
  Future<DefaultSsResponse> commentPost(
      {required String postId,
      required String message,
      required String mediaId,
      String? commentId,
      GraphUrlInfo? graphUrlInfo}) {
    return _forumApiProvider.commentPost(
        postId: postId,
        message: message,
        mediaId: mediaId,
        commentId: commentId,
        graphUrlInfo: graphUrlInfo);
  }

  @override
  Future<DefaultSsResponse> reportPost(
      {required String postId, required String content}) {
    return _forumApiProvider.reportPost(postId: postId, content: content);
  }

  @override
  Future<DefaultSsResponse> updatePost(
      {required String postId,
      required String message,
      required List<String> medias,
      GraphUrlInfo? graphUrlInfo}) {
    return _forumApiProvider.updatePost(
        postId: postId,
        message: message,
        medias: medias,
        graphUrlInfo: graphUrlInfo);
  }

  @override
  Future<DefaultSsResponse> deleteMedia({required String mediaId}) {
    return _forumApiProvider.deleteMedia(mediaId: mediaId);
  }

  @override
  Future<DefaultSsResponse> likeComment(
      {required String postId,
      required String commentId,
      required bool isLike}) {
    return _forumApiProvider.likeComment(
        postId: postId, commentId: commentId, isLike: isLike);
  }

  @override
  Future<PaginatorSsResponse<CommentModel>> getReplyComment(
      {required String postId, required String commentId, int offset = 0, int limit = 5}) {
    return _forumApiProvider.getReplyComment(
        postId: postId, commentId: commentId, offset: offset,limit:limit);
  }
}
