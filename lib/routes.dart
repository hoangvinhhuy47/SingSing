import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/select_language/select_language_bloc.dart';
import 'package:sing_app/blocs/select_language/select_language_event.dart';
import 'package:sing_app/blocs/send_nft/send_nft_screen_bloc.dart';
import 'package:sing_app/blocs/send_nft/send_nft_screen_event.dart';
import 'package:sing_app/blocs/send_token_confirm/send_token_confirm_screen_bloc.dart';
import 'package:sing_app/blocs/send_token_confirm/send_token_confirm_screen_event.dart';
import 'package:sing_app/blocs/token_detail/token_detail_screen_bloc.dart';
import 'package:sing_app/blocs/token_detail/token_detail_screen_event.dart';
import 'package:sing_app/blocs/wallet_detail/wallet_detail_bloc.dart';
import 'package:sing_app/blocs/wallet_detail/wallet_detail_event.dart';
import 'package:sing_app/blocs/wallet_detail/wallet_detail_nft_bloc.dart';
import 'package:sing_app/blocs/wallet_detail/wallet_detail_token_bloc.dart';
import 'package:sing_app/data/models/balance.dart';
import 'package:sing_app/data/models/covalent_log_transaction.dart';
import 'package:sing_app/data/models/wallet.dart';
import 'package:sing_app/data/repository/singnft_repository.dart';
import 'package:sing_app/data/repository/wallet_repository.dart';
import 'package:sing_app/root.dart';
import 'package:sing_app/screens/add_custom_token_screen.dart';
import 'package:sing_app/screens/change_password_screen.dart';
import 'package:sing_app/screens/change_wallet_name_screen.dart';
import 'package:sing_app/screens/edit_profile_screen.dart';
import 'package:sing_app/screens/nft_detail_screen.dart';
import 'package:sing_app/screens/receive_token_screen.dart';
import 'package:sing_app/screens/scan_qrcode_screen.dart';
import 'package:sing_app/screens/select_language_screen.dart';
import 'package:sing_app/screens/select_token_screen.dart';
import 'package:sing_app/screens/send_nft_screen.dart';
import 'package:sing_app/screens/send_token_confirm_screen.dart';
import 'package:sing_app/screens/send_token_scan_qrcode_screen.dart';
import 'package:sing_app/screens/send_token_screen.dart';
import 'package:sing_app/screens/setting_wallet_screen.dart';
import 'package:sing_app/screens/tabbar_screen.dart';
import 'package:sing_app/screens/token_detail_screen.dart';
import 'package:sing_app/screens/transaction_detail_screen.dart';
import 'package:sing_app/screens/video_player_screen.dart';
import 'package:sing_app/screens/wallet_detail_screen.dart';
import 'package:sing_app/screens/web_view_screen.dart';
import 'package:sing_app/utils/logger_util.dart';

import 'blocs/add_custom_token/add_custom_token_bloc.dart';
import 'blocs/add_custom_token/add_custom_token_event.dart';
import 'blocs/change_password/change_password_bloc.dart';
import 'blocs/change_password/change_password_event.dart';
import 'blocs/change_wallet_name/change_wallet_name_bloc.dart';
import 'blocs/change_wallet_name/change_wallet_name_event.dart';
import 'blocs/edit_profile/edit_profile_bloc.dart';
import 'blocs/edit_profile/edit_profile_event.dart';
import 'blocs/nft_detail/nft_detail_screen_bloc.dart';
import 'blocs/nft_detail/nft_detail_screen_event.dart';
import 'blocs/scan_qrcode/scan_qrcode_bloc.dart';
import 'blocs/scan_qrcode/scan_qrcode_event.dart';
import 'blocs/select_token/select_token_bloc.dart';
import 'blocs/select_token/select_token_event.dart';
import 'blocs/setting_wallet/setting_wallet_bloc.dart';
import 'blocs/setting_wallet/setting_wallet_event.dart';
import 'blocs/transaction_detail/transaction_detail_screen_bloc.dart';
import 'blocs/transaction_detail/transaction_detail_screen_event.dart';
import 'blocs/video_player/video_player_bloc.dart';
import 'blocs/video_player/video_player_event.dart';
import 'data/models/internal_web_view.dart';
import 'data/repository/bscscan_repository.dart';
import 'data/repository/covalent_repository.dart';
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
  static const String sendNftScreen = '/sendNftScreen';
  static const String videoPlayerScreen = '/videoPlayerScreen';
  static const String transactionDetailScreen = '/transactionDetailScreen';
  static const String selectLanguageScreen = '/selectLanguageScreen';
  static const String WEB_VIEW = '/web_view';

  CupertinoPageRoute routePage(RouteSettings settings) {
    return CupertinoPageRoute(
      settings: settings,
      builder: (BuildContext context) {
        switch (settings.name) {
          case root:
            return const Root();
          case selectTokenScreen:
            final Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
            // return SelectTokenScreen(
            //   screenType: args['type'],
            //   priceTable: args['price_table'],
            // );

            return BlocProvider<SelectTokenBloc>(
              create: (ctx) => SelectTokenBloc()..add(SelectTokenEventStart()),
              child: SelectTokenScreen(
                screenType: args['type'],
                priceTable: args['price_table'],
              ),
            );

          case sendTokenScreen:
            return SendTokenScreen(args: settings.arguments as Map<String, dynamic>,);
          case receiveTokenScreen:
            return ReceiveTokenScreen(args: settings.arguments as Map<String, dynamic>);
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
                secretType: args['secret_type'] ?? 'BSC',
                walletRepository:
                    RepositoryProvider.of<WalletRepository>(context),
              )..add(SendTokenConfirmScreenStarted()),
              child: const SendTokenConfirmScreen(),
            );
          case walletDetailScreen:
            final walletRepository = RepositoryProvider.of<WalletRepository>(context);
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
                    covalentRepository: RepositoryProvider.of<CovalentRepository>(context),
                  ),
                ),
                BlocProvider<WalletDetailNftBloc>(
                  create: (ctx) => WalletDetailNftBloc(
                    wallet: args['wallet'],
                    walletRepository: walletRepository,
                    // singNftRepository: RepositoryProvider.of<SingNftRepository>(context),
                    ssRepository: RepositoryProvider.of<SsRepository>(context),
                    moralisRepository: RepositoryProvider.of<MoralisRepository>(context),
                  ),
                ),
              ],
              child:  const WalletDetailScreen(),
            );
          case settingWalletScreen:
            final Map<String, dynamic> args =
            settings.arguments as Map<String, dynamic>;
            return BlocProvider<SettingWalletBloc>(
              create: (ctx) => SettingWalletBloc(
                walletRepository: RepositoryProvider.of<WalletRepository>(context),
                singNftRepository: RepositoryProvider.of<SingNftRepository>(context),
                wallet: args['wallet'],
              )..add(SettingWalletEventStart()),
              child: const SettingWalletScreen(),
            );
          case addCustomTokenScreen:
            return BlocProvider<AddCustomTokenBloc>(
              create: (ctx) => AddCustomTokenBloc(
                walletRepository: RepositoryProvider.of<WalletRepository>(context),
                singNftRepository: RepositoryProvider.of<SingNftRepository>(context),
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
                walletRepository: RepositoryProvider.of<WalletRepository>(context),
                singNftRepository: RepositoryProvider.of<SingNftRepository>(context),
                currentName: args['current_name'],
                wallet: args['wallet'],
              )..add(ChangeWalletNameEventStart()),
              child: const ChangeWalletNameScreen(),
            );
          case sendTokenScanQrCodeScreen:
            return const SendTokenScanQrCodeScreen();
          case tokenDetailScreen:
            final Map<String, dynamic> args =
            settings.arguments as Map<String, dynamic>;
            return BlocProvider<TokenDetailScreenBloc>(
              create: (ctx) => TokenDetailScreenBloc(
                walletRepository: RepositoryProvider.of<WalletRepository>(context),
                covalentRepository: RepositoryProvider.of<CovalentRepository>(context),
                bscScanRepository: RepositoryProvider.of<BscScanRepository>(context),
                priceTable: args['price_table'],
                token: args['token'],
              )..add(TokenDetailScreenEventStarted()),
              child: const TokenDetailScreen(),
            );
          case nftDetailScreen:
            final Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
            return BlocProvider<NftDetailScreenBloc>(
              create: (ctx) => NftDetailScreenBloc(
                walletRepository: RepositoryProvider.of<WalletRepository>(context),
                covalentRepository: RepositoryProvider.of<CovalentRepository>(context),
                nft: args['nft'],
              )..add(NtfDetailScreenEventStarted()),
              child: const NftDetailScreen(),
            );
          case editProfileScreen:
            return BlocProvider<EditProfileBloc>(
              create: (ctx) => EditProfileBloc(
                ssRepository: RepositoryProvider.of<SsRepository>(context),
                walletRepository: RepositoryProvider.of<WalletRepository>(context),
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
              )..add(VideoPlayerEventStarted()),
              child: VideoPlayerScreen(args: settings.arguments as Map<String, dynamic>),
            );
          case transactionDetailScreen:
            final args = settings.arguments as Map<String, dynamic>;
            return BlocProvider<TransactionDetailScreenBloc>(
              create: (ctx) => TransactionDetailScreenBloc(
                covalentRepository: RepositoryProvider.of<CovalentRepository>(context),
                balance: args['balance']
              )..add(TransactionDetailScreenEventStarted()),
              child: TransactionDetailScreen(args: args),
            );
          case selectLanguageScreen:
            return BlocProvider<SelectLanguageBloc>(
              create: (ctx) => SelectLanguageBloc()..add(SelectLanguageEventStarted()),
              child:  const SelectLanguageScreen(),
            );
          case WEB_VIEW:
            final InternalWebViewModel webView = settings.arguments as InternalWebViewModel;
            return WebViewWidget(webViewModel: webView);
        }
        return const Scaffold();
      },
    );
  }
}
