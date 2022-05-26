import 'dart:convert';

import 'package:sing_app/data/models/post.dart';
import 'package:sing_app/data/models/user_profile.dart';

Forum forumFromJson(String str) => Forum.fromJson(json.decode(str));

String forumToJson(Forum data) => json.encode(data.toJson());

class Forum {
  Forum({
    this.memberCount = 0,
    this.intro = '',
    this.cover = '',
    this.thumb = '',
    this.title = '',
    this.groupId = '',
    this.isJoined = false,
    this.userType =  0,
  });

  int memberCount;
  String intro;
  String cover;
  String thumb;
  String title;
  String groupId;
  bool isJoined;
  int userType;
  List<Post> posts = [];
  List<Post> pinnedPosts = [];
  List<UserProfile> members = [];

  factory Forum.fromJson(Map<String, dynamic> json) => Forum(
        memberCount: json["member_count"],
        intro: json["intro"] ?? '',
        cover: json["cover"] ?? '',
        thumb: json["thumb"] ?? '',
        title: json["title"] ?? '',
        groupId: json["group_id"] ?? '',
        userType: json["user_type"]?? 0,
        isJoined: json["is_joined"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "member_count": memberCount,
        "intro": intro,
        "cover": cover,
        "thumb": thumb,
        "title": title,
        "group_id": groupId,
        "is_joined": isJoined,
        "user_type": userType,
      };

  cloneForum(Forum newForum){
    memberCount = newForum.memberCount;
    intro = newForum.intro;
    cover = newForum.cover;
    thumb = newForum.thumb;
    title = newForum.title;
    userType = newForum.userType;
  }
}
