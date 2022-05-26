
import 'package:equatable/equatable.dart';

abstract class ArticleScreenState extends Equatable {
  const ArticleScreenState();

  @override
  List<Object> get props => [];
}

class ArticleScreenInitialState extends ArticleScreenState{}

class ArticleScreenLoadingState extends ArticleScreenState{
  final bool isLoading;

  const ArticleScreenLoadingState({required this.isLoading});

  @override
  List<Object> get props => [isLoading];
}

class ArticleScreenSuccessState extends ArticleScreenState{
  final bool isSuccess;
  final String? message;

  const ArticleScreenSuccessState({required this.isSuccess,this.message});
}