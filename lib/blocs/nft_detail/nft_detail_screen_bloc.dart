import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sing_app/data/models/covalent_nft.dart';
import 'package:sing_app/data/models/moralis_nft.dart';
import 'package:sing_app/data/repository/bscscan_repository.dart';
import 'package:sing_app/data/repository/covalent_repository.dart';
import 'package:sing_app/data/repository/wallet_repository.dart';

import 'nft_detail_screen_state.dart';
import 'nft_detail_screen_event.dart';

class NftDetailScreenBloc extends Bloc<NtfDetailScreenEvent, NftDetailScreenState> {
  final BaseWalletRepository walletRepository;
  final BaseCovalentRepository covalentRepository;
  final MoralisNft nft;

  NftDetailScreenBloc({
    required this.walletRepository,
    required this.covalentRepository,
    required this.nft,
  }) : super(NftDetailScreenStateInitial()){
    on<NtfDetailScreenEvent>((event, emit) async {
      await _mapNftDetailScreenEventStartedToState(emit);
    });
  }

  Future<void> _mapNftDetailScreenEventStartedToState(Emitter<NftDetailScreenState> emit) async {
    emit(NftDetailScreenStateLoading());

    emit(NftDetailScreenStateLoaded());
  }


}
