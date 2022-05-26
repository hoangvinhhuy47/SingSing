import 'package:equatable/equatable.dart';

abstract class ForumMemberScreenEvent extends Equatable {
  const ForumMemberScreenEvent();

  @override
  List<Object> get props => [];
}

class ForumMemberScreenInitialEvent extends ForumMemberScreenEvent {
}
class ForumMemberScreenGetMemberEvent extends ForumMemberScreenEvent {
  final bool isRefresh;
  final String keyword;
  final bool isSearch;

  const ForumMemberScreenGetMemberEvent({this.isRefresh = false, this.keyword = '',this.isSearch = false});
}
