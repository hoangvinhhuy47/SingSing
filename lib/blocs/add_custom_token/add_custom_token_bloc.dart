import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/config/app_config.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/models/contract_info.dart';
import 'package:sing_app/data/repository/singnft_repository.dart';
import 'package:sing_app/data/repository/wallet_repository.dart';
import 'package:sing_app/event_bus/event_bus_event.dart';

import '../../application.dart';
import 'add_custom_token_event.dart';
import 'add_custom_token_state.dart';

class AddCustomTokenBloc extends Bloc<AddCustomTokenEvent, AddCustomTokenState> {
  String tag = 'AddCustomTokenBloc';
  bool _needReload = false;
  bool get needReload => _needReload;

  final BaseWalletRepository walletRepository;
  final BaseSingNftRepository singNftRepository;

  ContractInfo? _contractInfo;
  ContractInfo? get contractInfo => _contractInfo;

  AddCustomTokenBloc({
    required this.walletRepository,
    required this.singNftRepository,
  }) : super(AddCustomTokenStateInitial()){
    on<AddCustomTokenEventStart>((event, emit) async {

    });
    on<PressAddCustomTokenEvent>((event, emit) async {
      await _mapPressAddCustomTokenEventToState(event, emit);
    });
    on<OnContractAddressEvent>((event, emit) async {
      await _mapOnContractAddressEventToState(event, emit);
    });
  }

  Future<void> _mapPressAddCustomTokenEventToState(
      PressAddCustomTokenEvent event, Emitter<AddCustomTokenState> emit) async {
    emit(AddCustomTokenLoadingState());

    // await Future.delayed(const Duration(seconds: 3));
    Map<String, dynamic> params = {
      'token_contract': event.contractAddress,
      'decimals': event.decimals,
    };
    final response = await walletRepository.addCustomToken(
        App.instance.currentWallet?.id ?? '', params);
    if (response.success) {
      _needReload = true;

      final response = await walletRepository.getTokenBalances(App.instance.currentWallet?.id ?? '');

      if(response.success && response.data != null){
        await App.instance.updateBalances(App.instance.currentWallet?.id ?? '', response.data!);
      }

      emit(AddCustomTokenSuccessState());
      emit(AddCustomTokenLoadedState());
      // send event to screen update UI
      App.instance.eventBus.fire(EventBusAddCustomTokenSuccess());
    } else {
      emit(AddCustomTokenErrorState(error: response.error?.message ?? l('Add custom wallet error')));
    }
  }

  Future<void> _mapOnContractAddressEventToState(OnContractAddressEvent event, Emitter<AddCustomTokenState> emit) async {
    if(event.contractAddress.length != 42 && _contractInfo != null) {
      _contractInfo = null;
      emit(GetContractInfoSuccessState());
      return;
    }

    if(App.instance.currentWallet?.secretType == secretTypeEth) {

    } else if(App.instance.currentWallet?.secretType == secretTypeBsc) {

    }

    Map<String, dynamic> params = {
      'token_contract': event.contractAddress,
    };
    AppConfig.instance.values.supportChains.forEach((key, value) {
      if(key == App.instance.currentWallet?.secretType) {
        params['chain_id'] = value.chainId;
      }
    });

    final response = await walletRepository.getContractInfo(params);
    if(response.success){
      _contractInfo = response.data;
      emit(GetContractInfoSuccessState());
    } else {
      emit(GetContractInfoErrorState(error: response.error?.message ?? l('Add custom wallet error')));
    }
  }
}
