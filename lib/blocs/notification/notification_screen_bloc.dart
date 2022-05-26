import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/data/models/notification_info.dart';
import 'package:sing_app/utils/logger_util.dart';

import '../../application.dart';
import '../../data/event_bus/event_bus_event.dart';
import '../../data/repository/ss_repository.dart';
import 'notification_screen_event.dart';
import 'notification_screen_state.dart';

class NotificationScreenBloc
    extends Bloc<NotificationScreenEvent, NotificationScreenState> {
  final SsRepository ssRepository;

  final limit = 30;
  int total = 0;
  List<NotificationInfo> notifications = [];
  List<NotificationInfo> unreadNotifications = [];
  // int unreadCount = 0;

  NotificationScreenBloc({
    required this.ssRepository,
  }) : super(NotificationScreenInitialState()) {

    on<NotificationScreenStarted>((event, emit) async {
      await _mapNotificationScreenStartedToState(event, emit);
    });

    on<ReadAllNotifications>((event, emit) async {
      await _mapReadAllNotificationsToState(event, emit);
    });

    on<ReadNotification>((event, emit) async {
      await _mapReadNotificationToState(event, emit);
    });

    on<NotificationScreenLoadMoreEvent>((event, emit) async {
      await _mapLoadMoreEventToState(event, emit);
    });

  }

  Future<void> _mapNotificationScreenStartedToState(
      NotificationScreenEvent event,
      Emitter<NotificationScreenState> emit) async {
    emit(const NotificationScreenStateLoading(showLoading: true));

    final response = await ssRepository.getNotifications(offset: 0, limit: limit);

    // LoggerUtil.info(' notifications response: ${response.data} - ${response.error?.message}');

    if (response.success) {
      notifications = response.data ?? [];
      total = response.pagination?.total ?? 0;

      // reload UI: none new notification
      App.instance.hasNewNotification = false;
      App.instance.eventBus.fire(EventBusOnNewNotificationEvent());
    }

    for (NotificationInfo item in notifications) {
      if (item.isRead == 0) {
        unreadNotifications.add((item));
      }
    }

    emit(NotificationScreenLoadedState());
  }

  Future<void> _mapReadNotificationToState(ReadNotification event,
      Emitter<NotificationScreenState> emit) async {
    // emit(const NotificationScreenStateLoading(showLoading: true));
    final response = await ssRepository.readNotifications(listNotificationIds: [event.notificationId]);

    if (response.success) {
      for (NotificationInfo item in notifications) {
        if (item.id == event.notificationId) {
          item.isRead = 1;
        }
      }
      unreadNotifications.removeWhere((element) {
        if(element.id == event.notificationId) {
          return true;
        }
        return false;
      });
    }

    emit(ReadNotificationState(notificationId: event.notificationId));
  }

  Future<void> _mapReadAllNotificationsToState(
      NotificationScreenEvent event,
      Emitter<NotificationScreenState> emit) async {
    emit(const NotificationScreenStateLoading(showLoading: true));

    final List<String> ids = [];
    for (NotificationInfo item in unreadNotifications) {
      ids.add(item.id);
    }

    final response = await ssRepository.readNotifications(listNotificationIds: ids);

    if (response.success) {
      unreadNotifications = [];
      for (NotificationInfo item in notifications) {
        if (item.isRead == 0) {
          item.isRead = 1;
        }
      }
    }

    emit(NotificationScreenLoadedState());
  }

  Future<void> _mapLoadMoreEventToState(NotificationScreenLoadMoreEvent event, Emitter<NotificationScreenState> emit) async {

    emit(const NotificationScreenStateLoading(showLoading: false));

    final response = await ssRepository.getNotifications(offset: notifications.length, limit: limit);

    if (response.success) {
      final _notifications = response.data ?? [];
      notifications.addAll(_notifications);

      total = response.pagination?.total ?? 0;
      for (NotificationInfo item in _notifications) {
        if (item.isRead == 0) {
          unreadNotifications.add((item));
        }
      }
    }
    emit(NotificationScreenLoadedState());
  }
}
