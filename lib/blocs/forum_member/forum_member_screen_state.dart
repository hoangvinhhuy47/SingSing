import 'package:equatable/equatable.dart';

abstract class ForumMemberScreenState extends Equatable {
  const ForumMemberScreenState();

  @override
  List<Object> get props => [];
}

class ForumMemberScreenInitialState extends ForumMemberScreenState {}

class ForumMemberScreenLoadDataSuccessState extends ForumMemberScreenState {}

class ForumMemberScreenMemberState extends ForumMemberScreenState {}
class ForumMemberScreenLoadMoreState extends ForumMemberScreenState {}

class ForumMemberScreenSetMemberSearchSuccessState extends ForumMemberScreenState {}

