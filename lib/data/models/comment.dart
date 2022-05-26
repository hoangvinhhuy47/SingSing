import 'package:sing_app/data/response/ss_response.dart';

import '../../constants/constants.dart';
import 'graph_url_info_model.dart';
import 'media.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class CommentModel {
  CommentModel({
    this.username = "",
    this.avatar = "",
    this.firstName = "",
    this.lastName = "",
    this.message = "",
    this.userId = "",
    this.createdAt = "",
    this.commentId = "",
    this.media,
    this.state,
    this.childs,
    this.isLiked = false,
    this.likeCount = 0
  });

  @JsonKey(name: 'username')
  String username;
  @JsonKey(name: 'avatar')
  String avatar;
  @JsonKey(name: 'first_name')
  String firstName;
  @JsonKey(name: 'last_name')
  String lastName;
  @JsonKey(name: 'message')
  String message;
  @JsonKey(name: 'user_id')
  String? userId;
  @JsonKey(name: 'created_at')
  String createdAt;
  @JsonKey(name: 'comment_id')
  String commentId;
  @JsonKey(name: 'media')
  MediaModel? media;
  @JsonKey(name: 'link')
  GraphUrlInfo? link;
  @JsonKey(name: 'childs')
  ChildComment? childs;
  @JsonKey(name: 'is_liked')
  bool? isLiked;
  @JsonKey(name: 'like_count')
  int? likeCount;
  @JsonKey(ignore: true)
  CommentState? state;

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);

  String getUserFullName() {
    // var name = '';
    // if (firstName.isNotEmpty && lastName.isNotEmpty) {
    //   name = '$firstName $lastName';
    // } else {
    //   name = username;
    // }
    return username;
  }
}

@JsonSerializable()
class ChildComment {
  ChildComment({
    this.data,
    this.pagination,
  });

  List<CommentModel>? data;
  Pagination? pagination;

  factory ChildComment.fromJson(Map<String, dynamic> json) =>
      _$ChildCommentFromJson(json);

  Map<String, dynamic> toJson() => _$ChildCommentToJson(this);
}
