abstract class ForumSearchScreenEvent {
  const ForumSearchScreenEvent();
}

class ForumSearchScreenInitialEvent extends ForumSearchScreenEvent {}

class ForumSearchScreenSearchEvent extends ForumSearchScreenEvent {
  final bool isSearch;
  final String keyword;

  const ForumSearchScreenSearchEvent({this.isSearch = false, this.keyword = ''});
}