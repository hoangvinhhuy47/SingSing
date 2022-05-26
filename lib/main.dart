 import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sing_app/blocs/root/root_bloc.dart';
import 'package:sing_app/blocs/root/root_event.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/my_app.dart';
import 'package:sing_app/utils/simple_bloc_delegate.dart';
import 'application.dart';
import 'config/app_config.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await runZonedGuarded (() async {
    var flavor = Flavor.staging;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    App.instance.appName = packageInfo.appName;
    App.instance.appVersion = packageInfo.version;
    App.instance.appBuildNumber = packageInfo.buildNumber;

    switch (packageInfo.packageName) {
      case appProductionPackageName:
        flavor = Flavor.production;
        break;
      case appStagingAndroidPackageName:
      case appStagingIOSPackageName:
        flavor = Flavor.staging;
        break;
      case appDevelopmentAndroidPackageName:
      case appDevelopmentIOSPackageName:
        flavor = Flavor.development;
        break;
      default:
        break;
    }
    await AppLocalization.instance.init();
    await Firebase.initializeApp();

    AppConfig(flavor, '');
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    BlocOverrides.runZoned(
      () => runApp(BlocProvider<RootBloc>(
        create: (context) => RootBloc()..add(AppStarted()),
        child: const MyApp(),
      )),
      blocObserver: SimpleBlocObserver(),
    );
  }, (error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}
