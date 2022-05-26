import 'package:equatable/equatable.dart';

abstract class NotificationScreenEvent extends Equatable {
  const NotificationScreenEvent();

  @override
  List<Object> get props => [];
}


class NotificationScreenStarted extends NotificationScreenEvent {}

class ReadAllNotifications extends NotificationScreenEvent {}


class ReadNotification extends NotificationScreenEvent {
  final String notificationId;

  const ReadNotification({
    required this.notificationId,
  });

  @override
  List<Object> get props => [notificationId];
}


class NotificationScreenLoadMoreEvent extends NotificationScreenEvent {}