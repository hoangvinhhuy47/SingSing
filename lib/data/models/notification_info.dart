
class NotificationInfo {
  static const actionLikePost = 'like_post';
  static const actionCommentPost = 'comment_post';


  String id = '';
  String title = '';
  int isRead = 0;
  String createdAt = '';
  String image = '';
  String action = '';
  String targetId = '';

  //int userId = -1;


  NotificationInfo({
    required this.id,
    required this.title,
    required this.isRead,
    required this.createdAt,
    required this.image,
    required this.action,
    required this.targetId,
  });

  NotificationInfo.fromJson(Map<String, dynamic> json) {
    id = json['notification_id'] ?? '';
    title = json['title'] ?? '';
    isRead = json['is_read'];
    createdAt = json['created_at'] ?? '';
    image = json['image'] ?? '';
    action = json['action'] ?? '';
    targetId = json['data']['target_id'] ?? false;
  }


  Map<String, dynamic> toJson() {
    return {
      'notification_id': id,
      'title': title,
      'is_read': isRead,
      'created_at': createdAt,
      'image': image,
      'action': action,
      'target_id': targetId,
    };
  }

}


