
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/wallet_s2e/wallet_s2e_screen_event.dart';
import 'package:sing_app/blocs/wallet_s2e/wallet_s2e_screen_state.dart';

class WalletS2EScreenBloc extends Bloc<WalletS2EScreenEvent, WalletS2EScreenState> {
  WalletS2EScreenBloc() : super(WalletS2EScreenInitialState());
}