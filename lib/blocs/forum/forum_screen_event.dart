abstract class ForumScreenEvent {
  const ForumScreenEvent();
}

class GetForumEvent extends ForumScreenEvent {
  final bool isRefresh;

  const GetForumEvent({this.isRefresh = false});
}
