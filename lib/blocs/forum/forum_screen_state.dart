import 'package:equatable/equatable.dart';
import 'package:sing_app/data/models/forum.dart';

abstract class ForumScreenState extends Equatable {
  const ForumScreenState();

  @override
  List<Object> get props => [];
}

class ForumScreenInitialState extends ForumScreenState {}

class ForumScreenLoadingState extends ForumScreenState {
  final bool isLoading;

  const ForumScreenLoadingState({this.isLoading = false});
}

class ForumScreenLoadDataSuccessState extends ForumScreenState {
  const ForumScreenLoadDataSuccessState();
}

class ForumsState extends ForumScreenState {
  final List<Forum> forums;

  const ForumsState({required this.forums});
}
