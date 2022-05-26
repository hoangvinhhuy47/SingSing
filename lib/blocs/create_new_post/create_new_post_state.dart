import 'package:equatable/equatable.dart';

abstract class CreateNewPostState extends Equatable {
  const CreateNewPostState();

  @override
  List<Object> get props => [];
}

class CreateNewPostInitialState extends CreateNewPostState {}

class NewFileState extends CreateNewPostState {}

class CreateNewPostLoadingIndicatorState extends CreateNewPostState {
  final bool isLoading;
  final String message;

  const CreateNewPostLoadingIndicatorState(
      {this.isLoading = false, this.message = '...'});
}

class CreateNewPostSuccessfullyState extends CreateNewPostState {
  final bool isSuccess;
  final String? errorMessage;

  const CreateNewPostSuccessfullyState({required this.isSuccess,this.errorMessage});

  @override
  List<Object> get props => [isSuccess];
}

class UpdatePostSuccessfullyState extends CreateNewPostState {
  final bool isSuccess;
  final String? errorMessage;

  const UpdatePostSuccessfullyState({required this.isSuccess,this.errorMessage});

  @override
  List<Object> get props => [isSuccess];
}

class CreateNewPostOpenGalleryState extends CreateNewPostState {}
class CreateNewPostGetInfoUrlSuccessState extends CreateNewPostState {}
class CreateNewPostGetInfoUrlLoadingState extends CreateNewPostState {
  final bool isLoading;

  const CreateNewPostGetInfoUrlLoadingState({required this.isLoading});
}

class CreateNewPostPopupUrlNotAllowState extends CreateNewPostState {
  final String message;
  const CreateNewPostPopupUrlNotAllowState({required this.message});
}
