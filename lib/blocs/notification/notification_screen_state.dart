import 'package:equatable/equatable.dart';

abstract class NotificationScreenState extends Equatable {
  const NotificationScreenState();

  @override
  List<Object> get props => [];
}

class NotificationScreenInitialState extends NotificationScreenState{}

class NotificationScreenStateLoading extends NotificationScreenState {
  final bool showLoading;

  const NotificationScreenStateLoading({required this.showLoading});

  @override
  List<Object> get props => [showLoading];
}

class NotificationScreenLoadedState extends NotificationScreenState {}

class ReadNotificationState extends NotificationScreenState {
  final String notificationId;

  const ReadNotificationState({
    required this.notificationId,
  });

  @override
  List<Object> get props => [notificationId];
}