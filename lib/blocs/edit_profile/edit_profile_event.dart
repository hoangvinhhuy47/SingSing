import 'package:equatable/equatable.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object> get props => [];
}

class EditProfileStarted extends EditProfileEvent {}

class EditProfileEventSaving extends EditProfileEvent {
  // final String email;
  final String firstName;
  final String lastName;

  const EditProfileEventSaving({
    // required this.email,
    required this.firstName,
    required this.lastName
  });

  @override
  List<Object> get props => [firstName, lastName];
}