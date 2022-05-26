import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/wallet_s2e/in_game_wallet/in_game_wallet_screen_state.dart';

import 'in_game_wallet_screen_event.dart';

class InGameWalletScreenBloc
    extends Bloc<InGameWalletScreenEvent, InGameWalletScreenState> {
  InGameWalletScreenBloc() : super(InGameWalletScreenInitialState());
}
