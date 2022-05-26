// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) => CommentModel(
      username: json['username'] as String? ?? "",
      avatar: json['avatar'] as String? ?? "",
      firstName: json['first_name'] as String? ?? "",
      lastName: json['last_name'] as String? ?? "",
      message: json['message'] as String? ?? "",
      userId: json['user_id'] as String? ?? "",
      createdAt: json['created_at'] as String? ?? "",
      commentId: json['comment_id'] as String? ?? "",
      media: json['media'] == null
          ? null
          : MediaModel.fromJson(json['media'] as Map<String, dynamic>),
      childs: json['childs'] == null
          ? null
          : ChildComment.fromJson(json['childs'] as Map<String, dynamic>),
      isLiked: json['is_liked'] as bool? ?? false,
      likeCount: json['like_count'] as int? ?? 0,
    )..link = json['link'] == null
        ? null
        : GraphUrlInfo.fromJson(json['link'] as Map<String, dynamic>);

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'avatar': instance.avatar,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'message': instance.message,
      'user_id': instance.userId,
      'created_at': instance.createdAt,
      'comment_id': instance.commentId,
      'media': instance.media,
      'link': instance.link,
      'childs': instance.childs,
      'is_liked': instance.isLiked,
      'like_count': instance.likeCount,
    };

ChildComment _$ChildCommentFromJson(Map<String, dynamic> json) => ChildComment(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: json['pagination'] == null
          ? null
          : Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChildCommentToJson(ChildComment instance) =>
    <String, dynamic>{
      'data': instance.data,
      'pagination': instance.pagination,
    };
