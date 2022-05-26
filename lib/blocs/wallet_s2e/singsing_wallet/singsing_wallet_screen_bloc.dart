import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/wallet_s2e/singsing_wallet/singsing_wallet_screen_event.dart';
import 'package:sing_app/blocs/wallet_s2e/singsing_wallet/singsing_wallet_screen_state.dart';

class SingSingWalletScreenBloc
    extends Bloc<SingSingWalletScreenEvent, SingSingWalletScreenState> {
  SingSingWalletScreenBloc() : super(SingSingWalletScreenInitialState());
}
