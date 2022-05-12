import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sing_app/application.dart';
import 'package:sing_app/blocs/send_nft/send_nft_screen_event.dart';
import 'package:sing_app/blocs/send_nft/send_nft_screen_state.dart';
import 'package:sing_app/data/models/moralis_nft.dart';
import 'package:sing_app/data/models/wallet.dart';
import 'package:sing_app/data/repository/wallet_repository.dart';
import 'package:sing_app/db/db_manager.dart';
import 'package:sing_app/event_bus/event_bus_event.dart';

class SendNftScreenBloc extends Bloc<SendNftScreenEvent, SendNftScreenState> {
  final BaseWalletRepository walletRepository;
  final MoralisNft nft;
  final Wallet wallet;
  bool isSending = false;
  String address = '';
  String tokenContract = '';

  SendNftScreenBloc({
    required this.walletRepository,
    required this.nft,
    required this.wallet,
  }) : super(SendNftScreenStateInitial()){
    on<SendNftScreenEventStarted>((event, emit) async {
      await _mapSendNftScreenStartedToState(emit);
    });
    on<SendNftScreenEventSending>((event, emit) async {
      await _mapSendNftScreenSendingToState(emit);
    });
  }

  Future<void> _mapSendNftScreenStartedToState(Emitter<SendNftScreenState> emit) async {

  }

  Future<void> _mapSendNftScreenSendingToState(Emitter<SendNftScreenState> emit) async {
    isSending = true;
    emit(SendNftScreenStateSending());
    final response = await walletRepository.sendNft(tokenContract: nft.tokenAddress ?? '', tokenId: int.parse(nft.tokenId ?? '0'), address: address, walletId: wallet.id);
    isSending = false;
    if(response.success){
      // save to db
      if(response.data?.transactionHash?.isNotEmpty ?? false) {
        await DbManager.instance.insertTransaction(
            walletId: wallet.id,
            sendTokenAddress: tokenContract,
            receiveAddress: address,
            amount: "1",
            transactionHash: response.data!.transactionHash,
            timestamp: DateTime.now().microsecondsSinceEpoch,
        );
        await DbManager.instance.showTableLogTransactions();
      }
      App.instance.eventBus.fire(EventBusTransferNftSuccessful());
      emit(SendNftScreenStateSent());

    } else {
      emit(SendNftScreenStateErrorSending(message: response.error?.message ?? 'Error sending token'));
    }
  }

}
