import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:sing_app/blocs/auth_screen/auth_screen_bloc.dart';
import 'package:sing_app/blocs/detail_market/detail_market_bloc.dart';
import 'package:sing_app/blocs/market/market_screen_bloc.dart';
import 'package:sing_app/blocs/mic/mic_screen_bloc.dart';
import 'package:sing_app/blocs/notification/notification_screen_bloc.dart';
import 'package:sing_app/blocs/root/root_bloc.dart';
import 'package:sing_app/blocs/sing/sing_screen/sing_screen_bloc.dart';
import 'package:sing_app/blocs/sing/sing_screen/sing_screen_event.dart';
import 'package:sing_app/blocs/tabbar/tabbar_bloc.dart';
import 'package:sing_app/blocs/wallet/wallet_screen_bloc.dart';
import 'package:sing_app/blocs/wallet/wallet_screen_event.dart';
import 'package:sing_app/blocs/wallet_s2e/wallet_s2e_screen_bloc.dart';
import 'package:sing_app/data/data_provider/base_api.dart';
import 'package:sing_app/data/repository/bscscan_repository.dart';
import 'package:sing_app/data/repository/media_repository.dart';
import 'package:sing_app/data/repository/singnft_repository.dart';
import 'package:sing_app/data/repository/song_repository.dart';
import 'package:sing_app/data/repository/wallet_repository.dart';
import 'package:sing_app/manager/notification_service.dart';
import 'package:sing_app/routes.dart';
import 'package:sing_app/services/firebase_analytics_service.dart';
import 'package:sing_app/services/navigation_service.dart';
import 'package:sing_app/utils/theme_util.dart';
import 'blocs/forum/forum_screen_bloc.dart';
import 'blocs/forum/forum_screen_event.dart';
import 'blocs/local_auth/local_auth_bloc.dart';
import 'blocs/notification/notification_screen_event.dart';
import 'config/app_config.dart';
import 'data/data_provider/ss_api.dart';
import 'data/repository/covalent_repository.dart';
import 'data/repository/forum_repository.dart';
import 'data/repository/moralis_repository.dart';
import 'data/repository/ss_repository.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final routes = Routes();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    NotificationService.instance.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // Close keyboard when tap outside input zone (textField,...)
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
      child: _buildRepositoryProvider(
        child: _buildPrimaryBlocProvider(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppConfig.instance.name,
            theme: ThemeUtil.appTheme,
            initialRoute: Routes.root,
            navigatorKey: NavigationService.instance.navigatorKey,
            onGenerateRoute: (settings) => routes.routePage(settings),
            navigatorObservers: [
              NavigationHistoryObserver(),
              FirebaseAnalyticsService().appAnalyticsObserver()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryBlocProvider({required Widget child}) {
    return MultiBlocProvider(
      providers: [
        // BOTTOM NAV
        BlocProvider<TabBarBloc>(
          create: (context) {
            return TabBarBloc();
          },
        ),
        BlocProvider<NotificationScreenBloc>(
          create: (context) => NotificationScreenBloc(
            ssRepository: RepositoryProvider.of<SsRepository>(context),
          )..add(NotificationScreenStarted()),
        ),
        // TAB WALLET SCREEN
        BlocProvider<WalletScreenBloc>(
          create: (context) => WalletScreenBloc(
            walletRepository: RepositoryProvider.of<WalletRepository>(context),
          )..add(const WalletScreenEventStarted()),
        ),
        BlocProvider<ForumScreenBloc>(
          create: (context) => ForumScreenBloc(
            forumRepository: RepositoryProvider.of<ForumRepository>(context),
          )..add(const GetForumEvent()),
        ),
        // BlocProvider<ProfileScreenBloc>(
        //   create: (context) => ProfileScreenBloc(
        //       ssRepository: RepositoryProvider.of<SsRepository>(context),
        //       mediaRepository: RepositoryProvider.of<MediaRepository>(context),
        //       rootBloc: BlocProvider.of<RootBloc>(context))
        //     ..add(const ProfileScreenEventStarted()),
        // ),
        BlocProvider<SingScreenBloc>(
          create: (context) => SingScreenBloc(
              songRepository: RepositoryProvider.of<SongRepository>(context))
            ..add(const SingScreenGetSongsEvent()),
        ),
        BlocProvider<MicScreenBloc>(
          create: (context) => MicScreenBloc(),
        ),
        BlocProvider<WalletS2EScreenBloc>(
          create: (context) => WalletS2EScreenBloc(),
        ),
        BlocProvider<MarketScreenBloc>(
          create: (context) => MarketScreenBloc(),
        ),
        BlocProvider<DetailMarketScreenBloc>(
            create: (context) => DetailMarketScreenBloc()),
        // BlocProvider<VerifyPasscodeBloc>(
        //   create: (context) {
        //     return VerifyPasscodeBloc(isLogin: true);
        //   },
        // ),
        BlocProvider<LocalAuthBloc>(
          create: (context) {
            return LocalAuthBloc(isWaitingDisableLocalAuthSetting: false);
          },
        ),
        BlocProvider<AuthScreenBloc>(
          create: (context) {
            return AuthScreenBloc(
              ssRepository: RepositoryProvider.of<SsRepository>(context),
            );
          },
        ),
      ],
      child: child,
    );
  }

  Widget _buildRepositoryProvider({required Widget child}) {
    final BaseAPI baseAPI = BaseAPI(
        rootBloc: BlocProvider.of<RootBloc>(context),
        baseUrl: AppConfig.instance.values.apiUrl);
    final BaseAPI singAPI = BaseAPI(
        rootBloc: BlocProvider.of<RootBloc>(context),
        baseUrl: AppConfig.instance.values.singApiUrl);
    final BaseAPI baseSingNftApi = BaseAPI(
        rootBloc: BlocProvider.of<RootBloc>(context),
        baseUrl: AppConfig.instance.values.singNftApiUrl);
    final BaseAPI baseMediaApi = BaseAPI(
        rootBloc: BlocProvider.of<RootBloc>(context),
        baseUrl: AppConfig.instance.values.mediaUrl);
    final BaseAPI baseCovalentApi = BaseAPI(
        rootBloc: BlocProvider.of<RootBloc>(context),
        baseUrl: AppConfig.instance.values.covalentApiUrl);
    final BaseAPI baseBscScanApi = BaseAPI(
        rootBloc: BlocProvider.of<RootBloc>(context),
        baseUrl: AppConfig.instance.values.bscScanUrl);
    final BaseAPI baseMoralisApi = BaseAPI(
        rootBloc: BlocProvider.of<RootBloc>(context),
        baseUrl: AppConfig.instance.values.moralisUrl);
    final SsAPI ssApi = SsAPI(rootBloc: BlocProvider.of<RootBloc>(context));

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SongRepository>(
          create: (ctx) => SongRepository(singAPI),
        ),
        RepositoryProvider<WalletRepository>(
          create: (ctx) => WalletRepository(baseAPI),
        ),
        RepositoryProvider<ForumRepository>(
          create: (ctx) => ForumRepository(singAPI),
        ),
        RepositoryProvider<SingNftRepository>(
          create: (ctx) => SingNftRepository(baseSingNftApi),
        ),
        RepositoryProvider<MediaRepository>(
          create: (ctx) => MediaRepository(baseMediaApi),
        ),
        RepositoryProvider<MediaRepository>(
          create: (ctx) => MediaRepository(baseMediaApi),
        ),
        RepositoryProvider<CovalentRepository>(
          create: (ctx) => CovalentRepository(baseCovalentApi),
        ),
        RepositoryProvider<BscScanRepository>(
          create: (ctx) => BscScanRepository(baseBscScanApi),
        ),
        RepositoryProvider<MoralisRepository>(
          create: (ctx) => MoralisRepository(baseMoralisApi),
        ),
        RepositoryProvider<SsRepository>(
          create: (ctx) => SsRepository(ssApi),
        ),
      ],
      child: child,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
