import 'dart:io';
import 'package:dio/dio.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/data_provider/api_manager.dart';
import 'package:sing_app/data/data_provider/base_api.dart';
import 'package:sing_app/data/models/graph_url_info_model.dart';
import 'package:sing_app/data/response/ss_response.dart';
import 'package:path/path.dart' as path_manager;
import 'package:sing_app/data/models/comment.dart';
import 'package:sing_app/data/models/forum.dart';
import 'package:sing_app/data/models/post.dart';
import 'package:sing_app/data/models/user_profile.dart';

class ForumApiProvider {
  late BaseAPI _baseAPI;

  ForumApiProvider(BaseAPI baseAPI) {
    _baseAPI = baseAPI;
  }

  /// FORUM
  Future<PaginatorSsResponse<Forum>> getForums({int offset = 0,
    String keyword = '',
    int limit = Constants.defaultApiLimit}) async {
    try {
      final Map resJson = await _baseAPI
          .request(manager: ApiManager(ApiType.getForums), queryParams: {
        'offset': offset,
        'keyword': keyword,
        'limit': limit,
      });
      final res = PaginatorSsResponse.fromMap(resJson);
      if (res.success && res.data != null) {
        final List<Forum> items = [];
        for (final itemJson in res.data ?? []) {
          final item = Forum.fromJson(itemJson);
          items.add(item);
        }
        return PaginatorSsResponse<Forum>(
            data: items, pagination: res.pagination);
      } else {
        return PaginatorSsResponse(error: res.error, success: false);
      }
    } catch (e) {
      return PaginatorSsResponse<Forum>.withError(
          SsError(message: e.toString()));
    }
  }

  Future<DefaultSsResponse<Forum>> getForumDetail(
      {required String forumId}) async {
    try {
      final Map resJson = await _baseAPI.request(
          manager: ApiManager(ApiType.getForumDetail, additionalPath: forumId));
      final res = DefaultSsResponse.fromMap(resJson);
      if (res.success && res.data != null) {
        return DefaultSsResponse<Forum>(data: Forum.fromJson(res.data));
      } else {
        return DefaultSsResponse(error: res.error, success: false);
      }
    } catch (e) {
      return DefaultSsResponse<Forum>.withError(SsError(message: e.toString()));
    }
  }

  Future<PaginatorSsResponse<Post>> getForumDetailPosts(
      {required String forumId,
        int offset = 0,
        int limit = Constants.defaultApiLimit}) async {
    try {
      final Map resJson = await _baseAPI.request(
          manager: ApiManager(ApiType.getForumPosts, additionalPath: forumId),
          queryParams: {
            'offset': offset,
            'limit': limit,
          });
      final res = PaginatorSsResponse.fromMap(resJson);

      if (res.success && res.data != null) {
        final List<Post> posts = [];
        for (final itemJson in res.data ?? []) {
          final post = Post.fromJson(itemJson);
          posts.add(post);
        }
        return PaginatorSsResponse<Post>(
            data: posts, pagination: res.pagination);
      }
      return PaginatorSsResponse(error: res.error, success: false);
    } catch (e) {
      return PaginatorSsResponse.withError(SsError(message: e.toString()));
    }
  }

  Future<PaginatorSsResponse<Post>> getForumDetailPinnedPosts(
      {required String forumId,
        int offset = 0,
        int limit = Constants.defaultApiLimit}) async {
    try {
      final Map resJson = await _baseAPI.request(
          manager:
          ApiManager(ApiType.getForumPinnedPosts, additionalPath: forumId),
          queryParams: {
            'offset': offset,
            'limit': limit,
          });

      final res = PaginatorSsResponse.fromMap(resJson);
      if (res.success && res.data != null) {
        final List<Post> posts = [];
        for (final itemJson in res.data ?? []) {
          final post = Post.fromJson(itemJson);
          posts.add(post);
        }
        return PaginatorSsResponse<Post>(
            data: posts, pagination: res.pagination);
      }
      return PaginatorSsResponse(error: res.error, success: false);
    } catch (e) {
      return PaginatorSsResponse.withError(SsError(message: e.toString()));
    }
  }

  Future<PaginatorSsResponse<UserProfile>> getForumDetailMembers(
      {required String forumId,
        int offset = 0,
        String keyword = '',
        int limit = Constants.defaultApiLimit}) async {
    try {
      final Map resJson = await _baseAPI.request(
          manager: ApiManager(ApiType.getForumMembers, additionalPath: forumId),
          queryParams: {
            'offset': offset,
            "keyword": keyword,
            'limit': limit,
          });
      final res = PaginatorSsResponse.fromMap(resJson);
      if (res.success && res.data != null) {
        final List<UserProfile> users = [];
        for (final itemJson in res.data ?? []) {
          final user = UserProfile.fromJson(itemJson);
          users.add(user);
        }
        return PaginatorSsResponse<UserProfile>(
            data: users, pagination: res.pagination);
      }
      return PaginatorSsResponse(error: res.error, success: false);
    } catch (e) {
      return PaginatorSsResponse.withError(SsError(message: e.toString()));
    }
  }

  Future<DefaultSsResponse> createNewPosts({required String forumId,
    required String message,
    required List<String> medias,
    GraphUrlInfo? graphUrlInfo}) async {
    try {
      final linkParam = graphUrlInfo != null
          ? {
        "domain": graphUrlInfo.domain,
        "title": graphUrlInfo.title,
        "image": graphUrlInfo.image,
        "url": graphUrlInfo.url,
      }
          : {};
      final Map resJson = await _baseAPI.request(
        manager: ApiManager(ApiType.createPost),
        optionalPath: '/$forumId/feed',
        bodyParams: {"message": message, "medias": medias, "link": linkParam},
      );
      final res = DefaultSsResponse.fromMap(resJson);
      if (res.success && res.data != null) {
        return res;
      } else {
        return DefaultSsResponse(success: false, error: res.error);
      }
    } catch (e) {
      return DefaultSsResponse.withError(SsError(message: e.toString()));
    }
  }

  Future<DefaultSsResponse> updatePost({required String postId,
    required String message,
    required List<String> medias,
    GraphUrlInfo? graphUrlInfo}) async {
    try {
      final linkParam = graphUrlInfo != null
          ? {
        "domain": graphUrlInfo.domain,
        "title": graphUrlInfo.title,
        "image": graphUrlInfo.image,
        "url": graphUrlInfo.url,
      }
          : {};
      final Map resJson = await _baseAPI.request(
        manager: ApiManager(ApiType.updatePost, additionalPath: postId),
        bodyParams: {"message": message, "medias": medias, "link": linkParam},
      );
      final res = DefaultSsResponse.fromMap(resJson);
      if (res.success && res.data != null) {
        return res;
      } else {
        return DefaultSsResponse(success: false, error: res.error);
      }
    } catch (e) {
      return DefaultSsResponse.withError(SsError(message: e.toString()));
    }
  }

  /// POSTS
  Future<DefaultSsResponse<Post>> getPostDetail(
      {required String postId}) async {
    try {
      final resJson = await _baseAPI.request(
          manager: ApiManager(ApiType.getPostDetail, additionalPath: postId));
      final res = DefaultSsResponse.fromMap(resJson);
      if (res.success && res.data != null) {
        return DefaultSsResponse(
          data: Post.fromJson(res.data),
        );
      } else {
        return DefaultSsResponse(error: res.error, success: false);
      }
    } catch (e) {
      return DefaultSsResponse.withError(SsError(message: e.toString()));
    }
  }

  Future<PaginatorSsResponse<CommentModel>> getPostDetailComments(
      {required String postId,
        required int offset,
        int limit = Constants.defaultApiLimit}) async {
    try {
      final resJson = await _baseAPI.request(
        manager: ApiManager(ApiType.getPostComments, additionalPath: postId),
        queryParams: {
          'offset': offset,
          'limit': limit,
        },
      );
      final res = PaginatorSsResponse.fromMap(resJson);
      if (res.success && res.data != null) {
        final List<CommentModel> comments = [];
        for (final Map<String, dynamic> itemJson in res.data ?? []) {
          final item = CommentModel.fromJson(itemJson);
          comments.add(item);
        }
        return PaginatorSsResponse<CommentModel>(
            data: comments, pagination: res.pagination);
      } else {
        return PaginatorSsResponse(data: null, success: false);
      }
    } catch (e) {
      return PaginatorSsResponse.withError(SsError(message: e.toString()));
    }
  }

  Future<DefaultSsResponse> likePost(
      {required String postId, required bool isLike}) async {
    try {
      Map resJson;
      if (isLike) {
        resJson = await _baseAPI.request(
          manager: ApiManager(ApiType.likePost, additionalPath: postId),
        );
      } else {
        resJson = await _baseAPI.request(
          manager: ApiManager(ApiType.unlikePost, additionalPath: postId),
        );
      }
      final res = DefaultSsResponse.fromMap(resJson);
      if (res.success && res.data != null) {
        return DefaultSsResponse(data: res.data);
      } else {
        return DefaultSsResponse(success: false);
      }
    } catch (e) {
      return DefaultSsResponse.withError(SsError(message: e.toString()));
    }
  }

  Future<DefaultSsResponse> pinPost({required String postId}) async {
    try {
      final resJson = await _baseAPI.request(
        manager: ApiManager(ApiType.pinPost, additionalPath: postId),
      );
      final res = DefaultSsResponse.fromMap(resJson);
      if (res.success && res.data != null) {
        return DefaultSsResponse(data: res.data);
      } else {
        return DefaultSsResponse(success: false);
      }
    } catch (e) {
      return DefaultSsResponse.withError(SsError(message: e.toString()));
    }
  }

  Future<DefaultSsResponse> removePinPost({required String postId}) async {
    try {
      final resJson = await _baseAPI.request(
          manager: ApiManager(ApiType.removePinPost, additionalPath: postId));
      final res = DefaultSsResponse.fromMap(resJson);
      if (res.success && res.data != null) {
        return DefaultSsResponse(data: res.data);
      } else {
        return DefaultSsResponse(success: false);
      }
    } catch (e) {
      return DefaultSsResponse.withError(SsError(message: e.toString()));
    }
  }

  Future<DefaultSsResponse> deletePost({required String postId}) async {
    try {
      final resJson = await _baseAPI.request(
          manager: ApiManager(ApiType.deletePost, additionalPath: postId));
      final res = DefaultSsResponse.fromMap(resJson);
      if (res.success && res.data != null) {
        return DefaultSsResponse(data: res.data);
      } else {
        return DefaultSsResponse(
            success: false, error: SsError(message: res.error?.message ?? ''));
      }
    } catch (e) {
      return DefaultSsResponse.withError(SsError(message: e.toString()));
    }
  }

  Future<DefaultSsResponse<CommentModel>> commentPost({required String postId,
    String? commentId,
    required String message,
    String mediaId = "",
    GraphUrlInfo? graphUrlInfo}) async {
    try {
      final linkParam = graphUrlInfo != null
          ? {
        "domain": graphUrlInfo.domain,
        "title": graphUrlInfo.title,
        "image": graphUrlInfo.image,
        "url": graphUrlInfo.url,
      }
          : {};
      final resJson = await _baseAPI.request(
          manager: ApiManager(ApiType.commentPost, additionalPath: postId),
          bodyParams: {
            "message": message,
            "media_id": mediaId,
            "comment_id": commentId,
            "link": linkParam
          });
      final res = DefaultSsResponse.fromMap(resJson);
      if (res.success && res.data != null) {
        return DefaultSsResponse(data: CommentModel.fromJson(res.data));
      } else {
        return DefaultSsResponse(
            success: false, error: SsError(message: res.error?.message ?? ''));
      }
    } catch (e) {
      return DefaultSsResponse.withError(SsError(message: e.toString()));
    }
  }

  Future<DefaultSsResponse> reportPost(
      {required String postId, required String content}) async {
    try {
      final resJson = await _baseAPI.request(
          manager: ApiManager(ApiType.reportPost, additionalPath: postId),
          bodyParams: {"content": content});
      final res = DefaultSsResponse.fromMap(resJson);
      if (res.success && res.data != null) {
        return DefaultSsResponse(data: res.data);
      } else {
        return DefaultSsResponse(
            success: false, error: SsError(message: res.error?.message ?? ''));
      }
    } catch (e) {
      return DefaultSsResponse.withError(SsError(message: e.toString()));
    }
  }

  Future<DefaultSsResponse> likeComment(
      {required String postId, required String commentId, required bool isLike}) async {
    try {
      Map resJson;
      String additionalPath = '$postId/$commentId';
      if (isLike) {
        resJson = await _baseAPI.request(
          manager: ApiManager(
              ApiType.likeComment, additionalPath: additionalPath),
        );
      } else {
        resJson = await _baseAPI.request(
          manager: ApiManager(
              ApiType.unLikeComment, additionalPath: additionalPath),
        );
      }
      final res = DefaultSsResponse.fromMap(resJson);
      if (res.success && res.data != null) {
        return DefaultSsResponse(data: res.data);
      } else {
        return DefaultSsResponse(success: false);
      }
    } catch (e) {
      return DefaultSsResponse.withError(SsError(message: e.toString()));
    }
  }

  Future<PaginatorSsResponse<CommentModel>> getReplyComment(
      {required String postId, required String commentId,required int offset,required int limit}) async {
    try {
      Map resJson = await _baseAPI.request(manager: ApiManager(
          ApiType.getReplyComment, additionalPath: '$postId/reply/comments'),queryParams: {
        'comment_id': commentId,
        'offset': offset,
        'limit': limit,
      });
      final res = PaginatorSsResponse.fromMap(resJson);
      if (res.success && res.data != null) {
        final List<CommentModel> items = [];
        for (final itemJson in res.data ?? []) {
          final item = CommentModel.fromJson(itemJson);
          items.add(item);
        }
        return PaginatorSsResponse<CommentModel>(
            data: items, pagination: res.pagination);
      } else {
        return PaginatorSsResponse(error: res.error, success: false);
      }
    } catch (e) {
      return PaginatorSsResponse.withError(
          SsError(message: e.toString()));
    }
  }

  /// MEDIAS
  Future<DefaultSsResponse> uploadPhoto(
      {required MultipartFile multipartFile}) async {
    try {
      final FormData formData = FormData.fromMap({'photo': multipartFile});

      final Map responseJson = await _baseAPI.request(
        manager: ApiManager(ApiType.uploadPhoto),
        bodyParams: formData,
      );

      final response = DefaultSsResponse.fromMap(responseJson);
      return response;
    } catch (exception) {
      return DefaultSsResponse.withError(
        SsError(message: exception.toString()),
      );
    }
  }

  Future<DefaultSsResponse> uploadFilePhoto({required File file}) async {
    try {
      final FormData formData = FormData.fromMap(
        {
          'photo': await MultipartFile.fromFile(file.path,
              filename: path_manager.basename(file.path)),
        },
      );
      final Map responseJson = await _baseAPI.request(
        manager: ApiManager(ApiType.uploadPhoto),
        bodyParams: formData,
      );
      final response = DefaultSsResponse.fromMap(responseJson);
      return response;
    } catch (exception) {
      return DefaultSsResponse.withError(
        SsError(message: exception.toString()),
      );
    }
  }

  Future<DefaultSsResponse> uploadVideo({required File file}) async {
    try {
      final FormData formData = FormData.fromMap(
        {
          'video': await MultipartFile.fromFile(file.path,
              filename: path_manager.basename(file.path)),
        },
      );
      final Map responseJson = await _baseAPI.request(
        manager: ApiManager(ApiType.uploadVideo),
        bodyParams: formData,
      );
      final response = DefaultSsResponse.fromMap(responseJson);
      return response;
    } catch (exception) {
      return DefaultSsResponse.withError(
        SsError(message: exception.toString()),
      );
    }
  }

  Future<DefaultSsResponse> deleteMedia({required String mediaId}) async {
    try {
      final Map resJson = await _baseAPI.request(
        manager: ApiManager(ApiType.deleteMedia, additionalPath: mediaId),
      );

      final res = DefaultSsResponse.fromMap(resJson);
      if (res.success && res.data != null) {
        return DefaultSsResponse(data: res.data);
      } else {
        return DefaultSsResponse(
            success: false, error: SsError(message: res.error?.message ?? ''));
      }
    } catch (exception) {
      return DefaultSsResponse.withError(
        SsError(message: exception.toString()),
      );
    }
  }

// Future<PaginatorSsResponse<NotificationInfo>> getForumNotifications({
//   required String forumId,
//   required offset,
//   required limit,
// }) async {
//   try {
//     final Map resJson = await _baseAPI.request(
//         manager: ApiManager(ApiType.getForumNotifications,
//             additionalPath: forumId),
//         queryParams: {'offset': offset, 'limit': limit});
//
//     final res = PaginatorSsResponse.fromMap(resJson);
//     if (res.success && res.data != null) {
//       final List<NotificationInfo> notifications = [];
//       for (final itemJson in res.data ?? []) {
//         final post = NotificationInfo.fromJson(itemJson);
//         notifications.add(post);
//       }
//       return PaginatorSsResponse<NotificationInfo>(
//           data: notifications, pagination: res.pagination);
//     }
//     return PaginatorSsResponse(error: res.error, success: false);
//   } catch (e) {
//     return PaginatorSsResponse.withError(SsError(message: e.toString()));
//   }
// }
//
// Future<DefaultSsResponse<bool>> readNotifications({
//   required List<String> listNotificationIds,
// }) async {
//   try {
//     Map<String, dynamic> params = {};
//     params['ids'] = listNotificationIds;
//
//     final Map resJson = await _baseAPI.request(
//         manager: ApiManager(ApiType.realAllNotifications),
//         bodyParams: params,
//         isUseAccessToken: true);
//
//     final res = DefaultSsResponse.fromMap(resJson);
//     if (res.success && res.data != null) {
//       return DefaultSsResponse<bool>(
//         data: true,
//       );
//     }
//     return DefaultSsResponse(error: res.error, success: false);
//   } catch (e) {
//     return DefaultSsResponse.withError(SsError(message: e.toString()));
//   }
// }
}
