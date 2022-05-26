import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/article/article_screen_bloc.dart';
import 'package:sing_app/blocs/article/article_screen_event.dart';
import 'package:sing_app/blocs/create_wallet_verify_mnemonic/create_wallet_verify_mnemonic_bloc.dart';
import 'package:sing_app/blocs/create_wallet_verify_mnemonic/create_wallet_verify_mnemonic_event.dart';
import 'package:sing_app/blocs/detail_market/detail_market_bloc.dart';
import 'package:sing_app/blocs/detail_nft_s2e/detail_nft_s2e_screen_bloc.dart';
import 'package:sing_app/blocs/forum_detail/forum_detail_screen_bloc.dart';
import 'package:sing_app/blocs/forum_detail/forum_detail_screen_event.dart';
import 'package:sing_app/blocs/forum_member/forum_member_screen_bloc.dart';
import 'package:sing_app/blocs/forum_search/forum_search_screen_bloc.dart';
import 'package:sing_app/blocs/forum_search/forum_search_screen_event.dart.dart';
import 'package:sing_app/blocs/import_wallet/import_wallet_bloc.dart';
import 'package:sing_app/blocs/import_wallet/import_wallet_event.dart';
import 'package:sing_app/blocs/post_detail/post_detail_screen_bloc.dart';
import 'package:sing_app/blocs/preview_image_gallery/preview_image_gallery_bloc.dart';
import 'package:sing_app/blocs/select_language/select_language_bloc.dart';
import 'package:sing_app/blocs/select_language/select_language_event.dart';
import 'package:sing_app/blocs/send_nft/send_nft_screen_bloc.dart';
import 'package:sing_app/blocs/send_nft/send_nft_screen_event.dart';
import 'package:sing_app/blocs/send_token_confirm/send_token_confirm_screen_bloc.dart';
import 'package:sing_app/blocs/send_token_confirm/send_token_confirm_screen_event.dart';
import 'package:sing_app/blocs/setting_security/setting_security_bloc.dart';
import 'package:sing_app/blocs/sing/calculate_score_s2e/calculate_score_s2e_screen_bloc.dart';
import 'package:sing_app/blocs/sing/sing_result/sing_result_screen_bloc.dart';
import 'package:sing_app/blocs/sing/sing_to_earn/sing_to_earn_screen_bloc.dart';
import 'package:sing_app/blocs/sing/song_detail/song_detail_screen_bloc.dart';
import 'package:sing_app/blocs/token_detail/token_detail_screen_bloc.dart';
import 'package:sing_app/blocs/token_detail/token_detail_screen_event.dart';
import 'package:sing_app/blocs/unauth_settings/unauth_settings_bloc.dart';
import 'package:sing_app/blocs/unauth_settings/unauth_settings_event.dart';
import 'package:sing_app/blocs/verify_passcode/verify_passcode_bloc.dart';
import 'package:sing_app/blocs/wallet_detail/wallet_detail_bloc.dart';
import 'package:sing_app/blocs/wallet_detail/wallet_detail_event.dart';
import 'package:sing_app/blocs/wallet_detail/wallet_detail_nft_bloc.dart';
import 'package:sing_app/blocs/wallet_detail/wallet_detail_token_bloc.dart';
import 'package:sing_app/blocs/wallet_s2e/transaction_history/transaction_history_screen_bloc.dart';
import 'package:sing_app/blocs/wallet_s2e/transaction_history/transaction_history_screen_event.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/models/mic_model.dart';
import 'package:sing_app/data/models/super_pass_nft_model.dart';
import 'package:sing_app/data/repository/forum_repository.dart';
import 'package:sing_app/data/repository/singnft_repository.dart';
import 'package:sing_app/data/repository/song_repository.dart';
import 'package:sing_app/data/repository/wallet_repository.dart';
import 'package:sing_app/root.dart';
import 'package:sing_app/screens/account_management/change_email_screen.dart';
import 'package:sing_app/screens/account_management/edit_profile_screen.dart';
import 'package:sing_app/screens/add_custom_token_screen.dart';
import 'package:sing_app/screens/account_management/change_password_screen.dart';
import 'package:sing_app/screens/article_screen.dart';
import 'package:sing_app/screens/change_wallet_name_screen.dart';
import 'package:sing_app/screens/create_wallet_backup_screen.dart';
import 'package:sing_app/screens/create_wallet_screen.dart';
import 'package:sing_app/screens/create_wallet_verify_mnemonic_screen.dart';
import 'package:sing_app/screens/detail_nft_s2e_screen.dart';
import 'package:sing_app/screens/forums/forum_detail_screen.dart';
import 'package:sing_app/screens/forums/forum_member_screen.dart';
import 'package:sing_app/screens/forums/forum_search_screen.dart';
import 'package:sing_app/screens/import_wallet_screen.dart';
import 'package:sing_app/screens/import_wallet_select_chain_screen.dart';
import 'package:sing_app/screens/market/detail_market/detail_market_screen.dart';
import 'package:sing_app/screens/new_wallet_screen.dart';
import 'package:sing_app/screens/nft_detail_screen.dart';
import 'package:sing_app/screens/forums/post_detail_screen.dart';
import 'package:sing_app/screens/forums/preview_image_gallery_screen.dart';
import 'package:sing_app/screens/notification_screen.dart';
import 'package:sing_app/screens/receive_token_screen.dart';
import 'package:sing_app/screens/scan_qrcode_screen.dart';
import 'package:sing_app/screens/security/local_auth_screen.dart';
import 'package:sing_app/screens/security/select_auto_lock_time_screen.dart';
import 'package:sing_app/screens/security/select_unlock_method_screen.dart';
import 'package:sing_app/screens/security/setting_security_screen.dart';
import 'package:sing_app/screens/security/verify_passcode_screen.dart';
import 'package:sing_app/screens/settings%20/select_language_screen.dart';
import 'package:sing_app/screens/select_token_screen.dart';
import 'package:sing_app/screens/send_nft_screen.dart';
import 'package:sing_app/screens/send_token_confirm_screen.dart';
import 'package:sing_app/screens/send_token_scan_qrcode_screen.dart';
import 'package:sing_app/screens/send_token_screen.dart';
import 'package:sing_app/screens/settings%20/setting_wallet_screen.dart';
import 'package:sing_app/screens/settings%20/unauth_setting_screen.dart';
import 'package:sing_app/screens/show_wallet_passphrase_private_key_screen.dart';
import 'package:sing_app/screens/sing/caculate_score_s2e_screen.dart';
import 'package:sing_app/screens/sing/sing_result_screen.dart';
import 'package:sing_app/screens/sing/sing_to_earn_screen.dart';
import 'package:sing_app/screens/sing/song_detail/song_detail_screen.dart';
import 'package:sing_app/screens/token_detail_screen.dart';
import 'package:sing_app/screens/transaction_detail_screen.dart';
import 'package:sing_app/screens/user_profile_screen.dart';
import 'package:sing_app/screens/video_player_screen.dart';
import 'package:sing_app/screens/wallet_detail_screen.dart';
import 'package:sing_app/screens/wallet_s2e/in_game_wallet/transaction_history_screen.dart';
import 'package:sing_app/screens/web_view_screen.dart';
import 'blocs/add_custom_token/add_custom_token_bloc.dart';
import 'blocs/add_custom_token/add_custom_token_event.dart';
import 'blocs/change_email/change_email_bloc.dart';
import 'blocs/change_email/change_email_event.dart';
import 'blocs/change_password/change_password_bloc.dart';
import 'blocs/change_password/change_password_event.dart';
import 'blocs/change_wallet_name/change_wallet_name_bloc.dart';
import 'blocs/change_wallet_name/change_wallet_name_event.dart';
import 'blocs/detail_nft_s2e/detail_nft_s2e_screen_event.dart';
import 'blocs/edit_profile/edit_profile_bloc.dart';
import 'blocs/edit_profile/edit_profile_event.dart';
import 'blocs/forum_member/forum_member_screen_event.dart';
import 'blocs/local_auth/local_auth_bloc.dart';
import 'blocs/local_auth/local_auth_event.dart';
import 'blocs/nft_detail/nft_detail_screen_bloc.dart';
import 'blocs/nft_detail/nft_detail_screen_event.dart';
import 'blocs/notification/notification_screen_bloc.dart';
import 'blocs/notification/notification_screen_event.dart';
import 'blocs/post_detail/post_detail_screen_event.dart';
import 'blocs/profile/profile_screen_bloc.dart';
import 'blocs/profile/profile_screen_event.dart';
import 'blocs/root/root_bloc.dart';
import 'blocs/scan_qrcode/scan_qrcode_bloc.dart';
import 'blocs/scan_qrcode/scan_qrcode_event.dart';
import 'blocs/select_auto_lock_time/select_auto_lock_time_bloc.dart';
import 'blocs/select_auto_lock_time/select_auto_lock_time_event.dart';
import 'blocs/select_token/select_token_bloc.dart';
import 'blocs/select_token/select_token_event.dart';
import 'blocs/select_unlock_method/select_unlock_method_bloc.dart';
import 'blocs/select_unlock_method/select_unlock_method_event.dart';
import 'blocs/setting_security/setting_security_event.dart';
import 'blocs/setting_wallet/setting_wallet_bloc.dart';
import 'blocs/setting_wallet/setting_wallet_event.dart';
import 'blocs/sing/calculate_score_s2e/calculate_score_s2e_screen_event.dart';
import 'blocs/sing/song_detail/song_detail_screen_event.dart';
import 'blocs/transaction_detail/transaction_detail_screen_bloc.dart';
import 'blocs/transaction_detail/transaction_detail_screen_event.dart';
import 'blocs/verify_passcode/verify_passcode_event.dart';
import 'blocs/video_player/video_player_bloc.dart';
import 'blocs/video_player/video_player_event.dart';
import 'data/models/internal_web_view.dart';
import 'data/models/song_model.dart';
import 'data/models/support_chain.dart';
import 'data/repository/bscscan_repository.dart';
import 'data/repository/covalent_repository.dart';
import 'data/repository/media_repository.dart';
import 'data/repository/moralis_repository.dart';
import 'data/repository/ss_repository.dart';

class Routes {
  static const String root = '/';
  static const String selectTokenScreen = '/selectTokenScreen';
  static const String sendTokenScreen = '/sendTokenScreen';
  static const String receiveTokenScreen = '/receiveTokenScreen';
  static const String sendTokenConfirmScreen = '/sendTokenConfirmScreen';
  static const String walletDetailScreen = '/walletDetailScreen';
  static const String settingWalletScreen = '/settingWalletScreen';
  static const String addCustomTokenScreen = '/addCustomTokenScreen';
  static const String scanQrCodeScreen = '/scanQrCodeScreen';
  static const String changeWalletNameScreen = '/changeWalletNameScreen';
  static const String sendTokenScanQrCodeScreen = '/sendTokenScanQrCodeScreen';
  static const String tokenDetailScreen = '/tokenDetailScreen';
  static const String nftDetailScreen = '/nftDetailScreen';
  static const String editProfileScreen = '/editProfileScreen';
  static const String changePasswordScreen = '/changePasswordScreen';
  static const String changeEmailScreen = '/changeEmailScreen';
  static const String sendNftScreen = '/sendNftScreen';
  static const String videoPlayerScreen = '/videoPlayerScreen';
  static const String transactionDetailScreen = '/transactionDetailScreen';
  static const String selectLanguageScreen = '/selectLanguageScreen';
  static const String settingSecurityScreen = '/settingSecurityScreen';
  static const String selectAutoLockTimeScreen = '/selectAutoLockTimeScreen';
  static const String selectUnlockMethodScreen = '/selectUnlockMethodScreen';
  static const String verifyPasscodeScreen = '/verifyPasscodeScreen';
  static const String localAuthScreen = '/localAuthScreen';
  static const String unauthSettingsScreen = '/unauthSettingsScreen';
  static const String notificationDetailScreen = '/notificationDetailScreen';

  static const String WEB_VIEW = '/web_view';
  static const String newWalletScreen = '/newWalletScreen';
  static const String createNewWallet = '/createNewWallet';
  static const String createWalletVerifyMnemonicScreen =
      '/createWalletVerifyMnemonicScreen';
  static const String importWalletSelectChainScreen =
      '/importWalletSelectChainScreen';
  static const String importWalletScreen = '/importWalletScreen';
  static const String createNewWalletBackupScreen =
      '/createNewWalletBackupScreen';
  static const String showWalletPassphraseScreen =
      '/showWalletPassphraseScreen';
  static const String forumDetailScreen = '/forumDetailScreen';
  static const String postDetailScreen = '/postDetailScreen';
  static const String forumMemberScreen = '/forumMemberScreen';
  static const String notificationScreen = '/notificationScreen';
  static const String previewImageGalleryScreen = '/previewImageGalleryScreen';
  static const String forumSearchScreen = '/forumSearchScreen';
  static const String articleScreen = '/articleScreen';

  static const String songDetailScreen = '/songDetailScreen';
  static const String marketDetailScreen = '/marketDetailScreen';
  static const String transactionHistoryScreen = '/transactionHistoryScreen';
  static const String userProfileScreen = '/userProfileScreen';
  static const String detailNftS2EScreen = '/detailNftS2EScreen';
  static const String singToEarnScreen = '/singToEarnScreen';
  static const String calculateScoreS2EScreen = '/calculateScoreS2EScreen';
  static const String singResultScreen = '/singResultScreen';

  CupertinoPageRoute routePage(RouteSettings settings) {
    return CupertinoPageRoute(
      settings: settings,
      builder: (BuildContext context) {
        switch (settings.name) {
          case root:
            return const Root();
          case forumDetailScreen:
            final args =
                settings.arguments as Map<ForumDetailScreenArgs, dynamic>;
            return BlocProvider<ForumDetailScreenBLoc>(
              create: (ctx) => ForumDetailScreenBLoc(
                forumRepository:
                    RepositoryProvider.of<ForumRepository>(context),
                forum: args[ForumDetailScreenArgs.forum],
              )..add(const ForumDetailScreenStartedEvent(isRefresh: false)),
              child: const ForumDetailScreen(),
            );
          case postDetailScreen:
            final args =
                settings.arguments as Map<PostDetailScreenArgs, dynamic>;
            return BlocProvider<PostDetailScreenBloc>(
              create: (ctx) => PostDetailScreenBloc(
                forumRepository:
                    RepositoryProvider.of<ForumRepository>(context),
                ssRepository: RepositoryProvider.of<SsRepository>(context),
                isFocusInput:
                    args[PostDetailScreenArgs.isFocusCommentField] ?? false,
                isOpenGallery:
                    args[PostDetailScreenArgs.isOpenGallery] ?? false,
                post: args[PostDetailScreenArgs.post],
                postId: args[PostDetailScreenArgs.postId],
                forum: args[PostDetailScreenArgs.forum],
              )..add(PostDetailScreenStartedEvent()),
              child: const PostDetailScreen(),
            );
          case forumMemberScreen:
            final args =
                settings.arguments as Map<ForumMemberScreenArgs, dynamic>;
            return BlocProvider<ForumMemberScreenBloc>(
              create: (ctx) => ForumMemberScreenBloc(
                  forumRepository:
                      RepositoryProvider.of<ForumRepository>(context),
                  forum: args[ForumMemberScreenArgs.forum],
                  forumMembers: args[ForumMemberScreenArgs.initMember])
                ..add(ForumMemberScreenInitialEvent()),
              child: const ForumMemberScreen(),
            );
          case notificationScreen:
            return BlocProvider<NotificationScreenBloc>(
              create: (ctx) => NotificationScreenBloc(
                ssRepository: RepositoryProvider.of<SsRepository>(context),
              )..add(NotificationScreenStarted()),
              child: const NotificationScreen(),
            );
          case previewImageGalleryScreen:
            final args =
                settings.arguments as Map<PreviewImageScreenArgs, dynamic>;
            return BlocProvider(
              create: (ctx) => PreviewImageGalleryBloc(
                  medias: args.containsKey(PreviewImageScreenArgs.medias)
                      ? args[PreviewImageScreenArgs.medias]
                      : [],
                  initialIndex:
                      args.containsKey(PreviewImageScreenArgs.initialIndex)
                          ? args[PreviewImageScreenArgs.initialIndex]
                          : 0,
                  singleImage:
                      args.containsKey(PreviewImageScreenArgs.singleImage)
                          ? args[PreviewImageScreenArgs.singleImage]
                          : null),
              child: const PreviewImageGalleryScreen(),
            );

          case forumSearchScreen:
            final args =
                settings.arguments as Map<ForumSearchScreenArgs, dynamic>;
            return BlocProvider<ForumSearchScreenBloc>(
              create: (ctx) => ForumSearchScreenBloc(
                forumRepository:
                    RepositoryProvider.of<ForumRepository>(context),
                initialForums: args[ForumSearchScreenArgs.initialForums],
                initialTotal: args[ForumSearchScreenArgs.initialTotal],
              )..add(ForumSearchScreenInitialEvent()),
              child: const ForumSearchScreen(),
            );
          case selectTokenScreen:
            final Map<String, dynamic> args =
                settings.arguments as Map<String, dynamic>;
            // return SelectTokenScreen(
            //   screenType: args['type'],
            //   priceTable: args['price_table'],
            // );

            return BlocProvider<SelectTokenBloc>(
              create: (ctx) => SelectTokenBloc()..add(SelectTokenEventStart()),
              child: SelectTokenScreen(
                screenType: args['type'],
              ),
            );

          case sendTokenScreen:
            return SendTokenScreen(
              args: settings.arguments as Map<String, dynamic>,
            );
          case receiveTokenScreen:
            return ReceiveTokenScreen(
                args: settings.arguments as Map<String, dynamic>);
          case sendTokenConfirmScreen:
            final args = settings.arguments as Map<String, dynamic>;
            return BlocProvider<SendTokenConfirmScreenBloc>(
              create: (ctx) => SendTokenConfirmScreenBloc(
                wallet: args['wallet'],
                address: args['address'],
                amount: args['amount'],
                price: args['price'] ?? 0.0,
                symbol: args['symbol'],
                tokenAddress: args['token_address'] ?? '',
                isLocal: args['is_local'] ?? false,
                secretType: args['secret_type'] ?? 'BSC',
                walletRepository:
                    RepositoryProvider.of<WalletRepository>(context),
              )..add(SendTokenConfirmScreenStarted()),
              child: const SendTokenConfirmScreen(),
            );
          case walletDetailScreen:
            final walletRepository =
                RepositoryProvider.of<WalletRepository>(context);
            final Map<String, dynamic> args =
                settings.arguments as Map<String, dynamic>;
            return MultiBlocProvider(
              providers: [
                BlocProvider<WalletDetailBloc>(
                  create: (ctx) => WalletDetailBloc(
                    wallet: args['wallet'],
                    walletRepository: walletRepository,
                  )..add(WalletDetailEventStart()),
                ),
                BlocProvider<WalletDetailTokenBloc>(
                  create: (ctx) => WalletDetailTokenBloc(
                    wallet: args['wallet'],
                    walletRepository: walletRepository,
                    covalentRepository:
                        RepositoryProvider.of<CovalentRepository>(context),
                  ),
                ),
                BlocProvider<WalletDetailNftBloc>(
                  create: (ctx) => WalletDetailNftBloc(
                    wallet: args['wallet'],
                    walletRepository: walletRepository,
                    // singNftRepository: RepositoryProvider.of<SingNftRepository>(context),
                    ssRepository: RepositoryProvider.of<SsRepository>(context),
                    moralisRepository:
                        RepositoryProvider.of<MoralisRepository>(context),
                  ),
                ),
              ],
              child: const WalletDetailScreen(),
            );
          case settingWalletScreen:
            final Map<String, dynamic> args =
                settings.arguments as Map<String, dynamic>;
            return BlocProvider<SettingWalletBloc>(
              create: (ctx) => SettingWalletBloc(
                walletRepository:
                    RepositoryProvider.of<WalletRepository>(context),
                singNftRepository:
                    RepositoryProvider.of<SingNftRepository>(context),
                wallet: args['wallet'],
              )..add(SettingWalletEventStart()),
              child: const SettingWalletScreen(),
            );
          case addCustomTokenScreen:
            return BlocProvider<AddCustomTokenBloc>(
              create: (ctx) => AddCustomTokenBloc(
                walletRepository:
                    RepositoryProvider.of<WalletRepository>(context),
                singNftRepository:
                    RepositoryProvider.of<SingNftRepository>(context),
              )..add(AddCustomTokenEventStart()),
              child: const AddCustomTokenScreen(),
            );
          case scanQrCodeScreen:
            return BlocProvider<ScanQrCodeBloc>(
              create: (ctx) => ScanQrCodeBloc()..add(ScanQrCodeEventStart()),
              child: const ScanQrCodeScreen(),
            );
          case changeWalletNameScreen:
            final Map<String, dynamic> args =
                settings.arguments as Map<String, dynamic>;
            return BlocProvider<ChangeWalletNameBloc>(
              create: (ctx) => ChangeWalletNameBloc(
                walletRepository:
                    RepositoryProvider.of<WalletRepository>(context),
                singNftRepository:
                    RepositoryProvider.of<SingNftRepository>(context),
                currentName: args['current_name'],
                wallet: args['wallet'],
              )..add(ChangeWalletNameEventStart()),
              child: const ChangeWalletNameScreen(),
            );
          case showWalletPassphraseScreen:
            return ShowWalletPassphrasePrivateKeyScreen(
                args: settings.arguments as Map<String, dynamic>);
          case sendTokenScanQrCodeScreen:
            return const SendTokenScanQrCodeScreen();
          case tokenDetailScreen:
            final Map<String, dynamic> args =
                settings.arguments as Map<String, dynamic>;
            return BlocProvider<TokenDetailScreenBloc>(
              create: (ctx) => TokenDetailScreenBloc(
                walletRepository:
                    RepositoryProvider.of<WalletRepository>(context),
                covalentRepository:
                    RepositoryProvider.of<CovalentRepository>(context),
                bscScanRepository:
                    RepositoryProvider.of<BscScanRepository>(context),
                token: args['token'],
              )..add(TokenDetailScreenEventStarted()),
              child: const TokenDetailScreen(),
            );
          case nftDetailScreen:
            final Map<String, dynamic> args =
                settings.arguments as Map<String, dynamic>;
            return BlocProvider<NftDetailScreenBloc>(
              create: (ctx) => NftDetailScreenBloc(
                walletRepository:
                    RepositoryProvider.of<WalletRepository>(context),
                covalentRepository:
                    RepositoryProvider.of<CovalentRepository>(context),
                nft: args['nft'],
              )..add(NtfDetailScreenEventStarted()),
              child: const NftDetailScreen(),
            );
          case editProfileScreen:
            return BlocProvider<EditProfileBloc>(
              create: (ctx) => EditProfileBloc(
                ssRepository: RepositoryProvider.of<SsRepository>(context),
              )..add(EditProfileStarted()),
              child: const EditProfileScreen(),
            );
          case changePasswordScreen:
            return BlocProvider<ChangePasswordBloc>(
              create: (ctx) => ChangePasswordBloc(
                ssRepository: RepositoryProvider.of<SsRepository>(context),
              )..add(ChangePasswordStarted()),
              child: const ChangePasswordScreen(),
            );
          case changeEmailScreen:
            return BlocProvider<ChangeEmailBloc>(
              create: (ctx) => ChangeEmailBloc(
                ssRepository: RepositoryProvider.of<SsRepository>(context),
              )..add(ChangeEmailStarted()),
              child: const ChangeEmailScreen(),
            );
          case sendNftScreen:
            final args = settings.arguments as Map<String, dynamic>;
            return BlocProvider<SendNftScreenBloc>(
              create: (ctx) => SendNftScreenBloc(
                wallet: args['wallet'],
                nft: args['nft'],
                walletRepository:
                    RepositoryProvider.of<WalletRepository>(context),
              )..add(SendNftScreenEventStarted()),
              child: const SendNftScreen(),
            );
          case videoPlayerScreen:
            return BlocProvider<VideoPlayerBloc>(
              create: (ctx) => VideoPlayerBloc(
                  // walletRepository: RepositoryProvider.of<WalletRepository>(context),
                  )
                ..add(VideoPlayerEventStarted()),
              child: VideoPlayerScreen(
                  args: settings.arguments as Map<String, dynamic>),
            );
          case transactionDetailScreen:
            final args = settings.arguments as Map<String, dynamic>;
            return BlocProvider<TransactionDetailScreenBloc>(
              create: (ctx) => TransactionDetailScreenBloc(
                  covalentRepository:
                      RepositoryProvider.of<CovalentRepository>(context),
                  balance: args['balance'])
                ..add(TransactionDetailScreenEventStarted()),
              child: TransactionDetailScreen(args: args),
            );
          case selectLanguageScreen:
            return BlocProvider<SelectLanguageBloc>(
              create: (ctx) =>
                  SelectLanguageBloc()..add(SelectLanguageEventStarted()),
              child: const SelectLanguageScreen(),
            );
          case settingSecurityScreen:
            return BlocProvider<SettingSecurityBloc>(
              create: (ctx) =>
                  SettingSecurityBloc()..add(SettingSecurityEventStarted()),
              child: const SettingSecurityScreen(),
            );
          case selectAutoLockTimeScreen:
            return BlocProvider<SelectAutoLockTimeBloc>(
              create: (ctx) => SelectAutoLockTimeBloc()
                ..add(SelectAutoLockTimeEventStarted()),
              child: const SelectAutoLockTimeScreen(),
            );
          case selectUnlockMethodScreen:
            return BlocProvider<SelectUnlockMethodBloc>(
              create: (ctx) => SelectUnlockMethodBloc()
                ..add(SelectUnlockMethodEventStarted()),
              child: const SelectUnlockMethodScreen(),
            );
          case verifyPasscodeScreen:
            final args = settings.arguments as Map<String, dynamic>;
            bool isDisableBackBtn = false;
            if (args.containsKey('is_disable_back_btn')) {
              isDisableBackBtn = args['is_disable_back_btn'];
            }
            return BlocProvider<VerifyPasscodeBloc>(
              create: (ctx) => VerifyPasscodeBloc(
                  isLogin: args['is_login'], isDisableBackBtn: isDisableBackBtn)
                ..add(VerifyPasscodeEventStarted()),
              child: const VerifyPasscodeScreen(),
            );
          case localAuthScreen:
            bool isWaitingDisableLocalAuthSetting = false;
            bool canBack = false;
            if (settings.arguments != null) {
              final args =
                  settings.arguments as Map<LocalAuthScreenArgs, dynamic>;
              if (args
                  .containsKey(LocalAuthScreenArgs.isWaitingDisableLocalAuth)) {
                isWaitingDisableLocalAuthSetting =
                    args[LocalAuthScreenArgs.isWaitingDisableLocalAuth];
              }
              canBack = args.containsKey(LocalAuthScreenArgs.canBack)
                  ? args[LocalAuthScreenArgs.canBack]
                  : false;
            }
            return BlocProvider<LocalAuthBloc>(
              create: (ctx) => LocalAuthBloc(
                  isWaitingDisableLocalAuthSetting:
                      isWaitingDisableLocalAuthSetting,
                  canBack: canBack)
                ..add(LocalAuthEventStarted()),
              child: const LocalAuthScreen(),
            );

          case WEB_VIEW:
            final InternalWebViewModel webView =
                settings.arguments as InternalWebViewModel;
            return WebViewWidget(webViewModel: webView);
          case newWalletScreen:
            return const NewWalletScreen();
          case createNewWallet:
            return CreateNewWalletScreen(
              chain: settings.arguments as SupportChain,
            );
          case createNewWalletBackupScreen:
            return CreateNewWalletBackupScreen(
              chain: settings.arguments as SupportChain,
            );
          case createWalletVerifyMnemonicScreen:
            final args = settings.arguments as Map<String, dynamic>;
            return BlocProvider<CreateWalletVerifyMnemonicBloc>(
              create: (ctx) => CreateWalletVerifyMnemonicBloc(
                  mnemonic: args['mnemonic'], chain: args['chain'])
                ..add(CreateWalletVerifyMnemonicEventStarted()),
              child: const CreateWalletVerifyMnemonicScreen(),
            );
          case importWalletSelectChainScreen:
            final args = settings.arguments as Map<String, dynamic>;
            return ImportWalletSelectChainScreen(
              screenType: args['type']!,
            );
          case importWalletScreen:
            return BlocProvider<ImportWalletBloc>(
              create: (ctx) =>
                  ImportWalletBloc(settings.arguments as SupportChain)
                    ..add(ImportWalletEventStarted()),
              child: const ImportWalletScreen(),
            );
          case unauthSettingsScreen:
            return BlocProvider<UnauthSettingsBloc>(
              create: (ctx) =>
                  UnauthSettingsBloc()..add(UnauthSettingsEventStarted()),
              child: const UnauthSettingsScreen(),
            );
          case articleScreen:
            final args = settings.arguments as Map<ArticleScreenArgs, dynamic>;
            ArticleType articleType = args[ArticleScreenArgs.articleType];

            return BlocProvider<ArticleScreenBloc>(
              create: (ctx) => ArticleScreenBloc(
                  ssRepository: RepositoryProvider.of<SsRepository>(context),
                  articleType: articleType)
                ..add(ArticleScreenGetArticleEvent(articleType: articleType)),
              child: const ArticleScreen(),
            );

          case songDetailScreen:
            final args =
                settings.arguments as Map<SongDetailScreenArgs, dynamic>;
            SongModel song = args[SongDetailScreenArgs.songModel];

            return BlocProvider<SongDetailScreenBloc>(
              create: (ctx) => SongDetailScreenBloc(
                songRepository: RepositoryProvider.of<SongRepository>(context),
                songModel: song,
              )..add(SongDetailScreenStartedEvent()),
              child: const SongDetailScreen(),
            );
          case transactionHistoryScreen:
            // final args =
            //     settings.arguments as Map<TransactionHistoryScreenArgs, dynamic>;

            return BlocProvider<TransactionHistoryScreenBloc>(
              create: (ctx) => TransactionHistoryScreenBloc()..add(const GetTransactionHistoryEvent()),
              child: const TransactionHistoryScreen(),
            );
          case marketDetailScreen:
            return BlocProvider<DetailMarketScreenBloc>(
              create: (ctx) => DetailMarketScreenBloc(),
              child: const DetailMarketScreen(),
            );
          case detailNftS2EScreen:
            MicModel? micModel;
            SuperPassNftModel? superPassNftModel;
            if (settings.arguments != null) {
              final args =
                  settings.arguments as Map<DetailNftS2EScreenArgs, dynamic>;
              if (args.containsKey(DetailNftS2EScreenArgs.superPassModel)) {
                superPassNftModel = args[DetailNftS2EScreenArgs.superPassModel];
              }
              if (args.containsKey(DetailNftS2EScreenArgs.micModel)) {
                micModel = args[DetailNftS2EScreenArgs.micModel];
              }
            }
            return BlocProvider<DetailNftS2EScreenBloc>(
              create: (ctx) => DetailNftS2EScreenBloc(
                micModel: micModel, /*superPassModel: superPassNftModel*/
              )..add(DetailNftS2EScreenStartedEvent()),
              child: const DetailNftS2EScreen(),
            );
          case userProfileScreen:
            return BlocProvider<ProfileScreenBloc>(
              create: (context) => ProfileScreenBloc(
                  ssRepository: RepositoryProvider.of<SsRepository>(context),
                  mediaRepository:
                      RepositoryProvider.of<MediaRepository>(context),
                  rootBloc: BlocProvider.of<RootBloc>(context))
                ..add(const ProfileScreenEventStarted()),
              child: const UserProfileScreen(),
            );
          // return BlocProvider<ProfileScreenBloc>(
          //   create: (ctx) => ProfileScreenBloc(),
          //   child: const UserProfileScreen(),
          // );
          case singToEarnScreen:
            final args =
                settings.arguments as Map<SingToEarnScreenArgs, dynamic>;
            SongModel songModel = args[SingToEarnScreenArgs.songModel];
            return BlocProvider<SingToEarnScreenBloc>(
              create: (context) => SingToEarnScreenBloc(songModel: songModel),
              child: const SingToEarnScreen(),
            );
          case calculateScoreS2EScreen:
            final args =
                settings.arguments as Map<SingToEarnScreenArgs, dynamic>;
            SongModel songModel = args[SingToEarnScreenArgs.songModel];
            return BlocProvider<CalculateScoreS2EScreenBloc>(
              create: (context) =>
                  CalculateScoreS2EScreenBloc(songModel: songModel)
                    ..add(CalculateScoreS2EScreenStartedEvent()),
              child: const CalculateScoreS2EScreen(),
            );
          case singResultScreen:
            final args =
                settings.arguments as Map<SingToEarnScreenArgs, dynamic>;
            SongModel songModel = args[SingToEarnScreenArgs.songModel];
            return BlocProvider<SingResultScreenBloc>(
              create: (context) => SingResultScreenBloc(songModel: songModel),
              child: const SingResultScreen(),
            );
        }
        return const Scaffold();
      },
    );
  }
}
