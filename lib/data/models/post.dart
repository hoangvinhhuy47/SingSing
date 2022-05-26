import 'package:sing_app/data/models/comment.dart';
import 'package:sing_app/data/models/forum.dart';
import 'package:sing_app/data/models/graph_url_info_model.dart';
import 'package:sing_app/data/models/user_profile.dart';

import 'media.dart';

class Post {
  Post({
    required this.mediaCount,
    required this.likeCount,
    required this.commentCount,
    required this.message,
    required this.ordering,
    required this.isFeatured,
    required this.createdAt,
    required this.medias,
    required this.postId,
    required this.user,
    required this.comments,
    required this.isLiked,
    required this.group,
    this.link,
  });

  int mediaCount;
  int likeCount;
  int commentCount;
  String message;
  int ordering;
  bool isFeatured;
  String createdAt;
  List<MediaModel> medias;
  String postId;
  UserProfile user;
  List<CommentModel> comments;
  bool isLiked;
  GraphUrlInfo? link;
  Forum? group;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        mediaCount: json["media_count"] ?? 0,
        likeCount: json["like_count"] ?? 0,
        commentCount: json["comment_count"] ?? 0,
        message: json["message"] ?? '',
        ordering: json["ordering"] ?? 0,
        isFeatured: json["is_featured"] ?? false,
        createdAt: json["created_at"] ?? '',
        medias: json.containsKey('medias')
            ? List<MediaModel>.from(
                json["medias"].map((x) => MediaModel.fromJson(x)))
            : [],
        postId: json["post_id"] ?? '',
        user: json.containsKey('user')
            ? UserProfile.fromJson(json["user"])
            : UserProfile(
                userId: '',
                hasMasterPin: false,
                username: '',
                email: '',
                firstName: '',
                lastName: '',
                nickname: '',
                googleId: '',
                facebookId: '',
                attributes: {},
                avatar: '',
                type: 0,
                symbol: '',
                amount: 0,
                emailVerified: false
        ),
        link: json.containsKey('link') && json['link'].isNotEmpty
            ? GraphUrlInfo.fromJson(json["link"])
            : null,
        comments: json.containsKey('comments')
            ? List<CommentModel>.from(
                json["comments"].map((x) => CommentModel.fromJson(x)))
            : [],
        group: json.containsKey('group')?Forum.fromJson(json['group']):null,
        isLiked: json["is_liked"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "media_count": mediaCount,
        "like_count": likeCount,
        "comment_count": commentCount,
        "message": message,
        "ordering": ordering,
        "is_featured": isFeatured,
        "created_at": createdAt,
        "medias": List<dynamic>.from(medias.map((x) => x.toJson())),
        "post_id": postId,
        "user": user.toJson(),
        "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
        "is_liked": isLiked,
        "group": group,
        "link": link,
      };
}
