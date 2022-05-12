import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:sing_app/blocs/profile/profile_screen_bloc.dart';
import 'package:sing_app/blocs/profile/profile_screen_event.dart';
import 'package:sing_app/blocs/root/root_bloc.dart';
import 'package:sing_app/blocs/tabbar/tabbar_bloc.dart';
import 'package:sing_app/blocs/wallet/wallet_screen_bloc.dart';
import 'package:sing_app/blocs/wallet/wallet_screen_event.dart';
import 'package:sing_app/data/data_provider/base_api.dart';
import 'package:sing_app/data/repository/bscscan_repository.dart';
import 'package:sing_app/data/repository/media_repository.dart';
import 'package:sing_app/data/repository/singnft_repository.dart';
import 'package:sing_app/data/repository/wallet_repository.dart';
import 'package:sing_app/routes.dart';
import 'package:sing_app/services/navigation_service.dart';
import 'package:sing_app/utils/logger_util.dart';
import 'package:sing_app/utils/theme_util.dart';
import 'config/app_config.dart';
import 'data/data_provider/ss_api.dart';
import 'data/repository/covalent_repository.dart';
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
    WidgetsBinding.instance?.addObserver(this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // Close keyboard when tap outside input zone (textField,...)
        WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
      },
      child: _buildRepositoryProvider(
        child: _buildPrimaryBlocProvider(
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppConfig.instance.name,
            theme: ThemeUtil.appTheme,
            initialRoute: Routes.root,
            navigatorKey: NavigationService.instance.navigatorKey,
            onGenerateRoute: (settings) => routes.routePage(settings),
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
        // TAB WALLET SCREEN
        BlocProvider<WalletScreenBloc>(
          create: (context) => WalletScreenBloc(
            walletRepository: RepositoryProvider.of<WalletRepository>(context),
          )..add(const WalletScreenEventStarted()),
        ),
        BlocProvider<ProfileScreenBloc>(
          create: (context) => ProfileScreenBloc(
            walletRepository: RepositoryProvider.of<WalletRepository>(context),
            mediaRepository: RepositoryProvider.of<MediaRepository>(context),
            nftRepository: RepositoryProvider.of<SingNftRepository>(context),
            rootBloc: BlocProvider.of<RootBloc>(context)
          )..add(const ProfileScreenEventStarted()),
        ),
      ],
      child: child,
    );
  }

  Widget _buildRepositoryProvider({required Widget child}) {
    final BaseAPI baseAPI = BaseAPI(rootBloc: BlocProvider.of<RootBloc>(context), baseUrl: AppConfig.instance.values.apiUrl);
    final BaseAPI baseSingNftApi = BaseAPI(rootBloc: BlocProvider.of<RootBloc>(context), baseUrl: AppConfig.instance.values.singNftApiUrl);
    final BaseAPI baseMediaApi = BaseAPI(rootBloc: BlocProvider.of<RootBloc>(context), baseUrl: AppConfig.instance.values.mediaUrl);
    final BaseAPI baseCovalentApi = BaseAPI(rootBloc: BlocProvider.of<RootBloc>(context), baseUrl: AppConfig.instance.values.covalentApiUrl);
    final BaseAPI baseBscScanApi = BaseAPI(rootBloc: BlocProvider.of<RootBloc>(context), baseUrl: AppConfig.instance.values.bscScanUrl);
    final BaseAPI baseMoralisApi = BaseAPI(rootBloc: BlocProvider.of<RootBloc>(context), baseUrl: AppConfig.instance.values.moralisUrl);
    final SsAPI ssApi = SsAPI(rootBloc: BlocProvider.of<RootBloc>(context));
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<WalletRepository>(
          create: (ctx) => WalletRepository(baseAPI),
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
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

}


