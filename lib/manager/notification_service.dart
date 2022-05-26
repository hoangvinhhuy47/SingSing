
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/utils/logger_util.dart';
import 'package:sing_app/utils/storage_utils.dart';
import 'package:sing_app/widgets/dialog/fs_grant_permission_dialog.dart';

import '../application.dart';
import '../data/event_bus/event_bus_event.dart';
import '../routes.dart';
import 'navigation_service.dart';

const int GRANT_NOTIFICATION_PROMPT_COUNT = 5;

typedef NotificationHandler = Future<dynamic> Function(
    Map<String, dynamic> message);

class NotificationChannel {
  static const String onMessage = 'onMessage';
  static const String onLaunch = 'onLaunch';
  static const String onResume = 'onResume';
  static const String onBackgroundMessage = 'onBackgroundMessage';
}

class NotificationService {
  factory NotificationService() => instance;

  NotificationService._internal();

  static final NotificationService instance = NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Methods

  Future initialize() async {
    final String? token = await getToken();

    // LoggerUtil.info('FirebaseToken: $token');

    _initLocalNotification(
      onSelectNotification: (String? payload) async {
        // LoggerUtil.info('onSelectNotification payload: $payload');
        // NavigationService.instance.navigateTo(Routes.NOTIFICATION_SCREEN);
      },
    );

    _firebaseMessaging.requestPermission();

    // Called when app in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleNotification(message, 'onMessage');
    });

    // Call when user click notification and app in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotification(message, 'onResume');
    });

    // Call when user click notification and app
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async{
      _handleNotification(message, 'onLaunch');
    });
  }

  void _handleNotification(
    RemoteMessage message,
    String channel,
  ) {
    // LoggerUtil.info('handleNotification channel: $channel: ReceiveNotification: ${message.notification?.title} - data: ${message.data}}');
    App.instance.hasNewNotification = true;
    App.instance.eventBus.fire(EventBusOnNewNotificationEvent());

    final context = NavigationService.instance.navigatorKey.currentContext;
    if(context != null) {
      // BlocProvider.of<NotificationBloc>(context).add(NotificationCountUpdate());

      if (channel == NotificationChannel.onResume ||
          channel == NotificationChannel.onLaunch) {
        if (message.data['_id'] is String &&
            message.data['_id'].isNotEmpty) {

          NavigationService.instance.navigateTo(
            Routes.notificationDetailScreen,
            args: {
              'notificationId': message.data['_id'],
            },
          );
          return;
        }
        NavigationService.instance.navigateTo(Routes.notificationDetailScreen);
      }
      if (channel == NotificationChannel.onMessage) {
        _showNotificationWithDefaultSound(message);
      }
    }
  }

  void _initLocalNotification({required Future Function(String?) onSelectNotification}) {
    const initializationSettingsAndroid = AndroidInitializationSettings('ic_noti_logo');
    const initializationSettingsIOS = IOSInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );
  }

  Future _showNotificationWithDefaultSound(RemoteMessage message) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iOSPlatformChannelSpecifics = IOSNotificationDetails();

    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
    if (Platform.isIOS) {
      await _flutterLocalNotificationsPlugin.show(
        0,
        message.data['title'],
        message.data['body'],
        platformChannelSpecifics,
        payload: 'Default_Sound',
      );
    } else if (Platform.isAndroid) {
      await _flutterLocalNotificationsPlugin.show(
        0,
        message.data['title'],
        message.data['body'],
        platformChannelSpecifics,
        payload: 'Default_Sound',
      );
    }
  }
}

extension NotificationServiceUtils on NotificationService {
  Future<String?> getToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      return token;
    } catch (exeption) {
      LoggerUtil.error(exeption.toString());
      return '';
    }
  }

  Future checkIfUserGrantNotification({required BuildContext context}) async {
    final PermissionStatus status = await Permission.notification.status;
    if (status.isGranted) {
      return;
    }
    await _promptNotificationPermission(context);
  }

  Future _promptNotificationPermission(BuildContext context) async {
    final int count = await StorageUtils.getInt(key: 'userActiveCountWhileNotGrantNotification', defaultValue: 1) ;

    if (count == GRANT_NOTIFICATION_PROMPT_COUNT) {
      // Show platform notification permission dialog
      FSGrantPermissionDialog.show(
        context: context,
        title: l('prompt_notification_title'),
        description: l('prompt_notification_description'),
        primaryText: l('Go to settings'),
        secondaryText: l('Later'),
        primaryPressed: () async {
          // If user tap 'Open Setting'
          AppSettings.openAppSettings();
          await StorageUtils.deleteKey('userActiveCountWhileNotGrantNotification');
        },
        secondaryPressed: () async {
          // If user tap 'Later'
          await StorageUtils.deleteKey('userActiveCountWhileNotGrantNotification');
        },
      );
    } else {
      final int newCount = count + 1;
      await StorageUtils.setInt(key: 'userActiveCountWhileNotGrantNotification', value: newCount);
    }
  }
}

