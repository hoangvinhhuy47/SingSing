import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sing_app/application.dart';
import 'package:sing_app/blocs/send_token_confirm/send_token_confirm_screen_event.dart';
import 'package:sing_app/blocs/send_token_confirm/send_token_confirm_screen_state.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/models/network_gas_fee.dart';
import 'package:sing_app/data/models/wallet.dart';
import 'package:sing_app/data/repository/wallet_repository.dart';
import 'package:sing_app/db/db_manager.dart';
import 'package:sing_app/event_bus/event_bus_event.dart';
import 'package:sing_app/utils/logger_util.dart';

class SendTokenConfirmScreenBloc extends Bloc<SendTokenConfirmScreenEvent, SendTokenConfirmScreenState> {
  final BaseWalletRepository walletRepository;
  final Wallet wallet;
  final double amount;
  final double price;
  final String address;
  final String tokenAddress;
  final String symbol;
  final String secretType;
  bool gasFeeCalculated = false;
  bool isSending = false;
  NetworkGasFee? networkGasFee;

  SendTokenConfirmScreenBloc({
    required this.walletRepository,
    required this.wallet,
    required this.amount,
    required this.price,
    required this.address,
    required this.symbol,
    required this.tokenAddress,
    required this.secretType,
  }) : super(SendTokenConfirmScreenStateInitial()){
    on<SendTokenConfirmScreenStarted>((event, emit) async {
      await _mapSendTokenConfirmScreenStartedToState(emit);
    });
    on<SendTokenConfirmScreenSending>((event, emit) async {
      await _mapSendTokenConfirmScreenSendingToState(emit);
    });
  }

  Future<void> _mapSendTokenConfirmScreenStartedToState(Emitter<SendTokenConfirmScreenState> emit) async {
    //get wallet bnb amount
    var bnbBalance = wallet.balance?.balance ?? 0;
    bnbBalance = bnbBalance / 2;
    LoggerUtil.info('calculateNetworkGasFee bnbBalance: $bnbBalance');
    final response = await walletRepository.calculateNetworkGasFee(price: bnbBalance, priceSymbol: secretType == secretTypeBsc ? 'BNB' : 'ETH', walletId: wallet.id);
    if(response.success){
      gasFeeCalculated = true;
      networkGasFee = response.data;
      emit(SendTokenConfirmScreenStateNetworkGasFeeCalculated());
    } else {
      emit(SendTokenConfirmScreenStateErrorSending(message: response.error?.message ?? l('Unknown error')));
    }
  }

  Future<void> _mapSendTokenConfirmScreenSendingToState(Emitter<SendTokenConfirmScreenState> emit) async {
    isSending = true;
    emit(SendTokenConfirmScreenStateSending());
  LoggerUtil.info('sendToken: tokenContract: $tokenAddress, amount: $amount, to address: $address, walletId: ${wallet.id}');
    final response = await walletRepository.sendToken(tokenContract: tokenAddress, amount: amount, address: address, walletId: wallet.id);
    isSending = false;
    if(response.success){
      LoggerUtil.info('response.transactionHash: ${response.data}', tag: '$this');
      // save to db
      if(response.data?.transactionHash?.isNotEmpty ?? false) {
        await DbManager.instance.insertTransaction(
            walletId: wallet.id,
            sendTokenAddress: wallet.secretType,
            receiveAddress: address,
            amount: amount.toString(),
            transactionHash: response.data!.transactionHash,
            timestamp: DateTime.now().microsecondsSinceEpoch,
        );
        await DbManager.instance.showTableLogTransactions();
      }
      App.instance.eventBus.fire(EventBusTransferTokenSuccessful());
      emit(SendTokenConfirmScreenStateSent());
    } else {
      emit(SendTokenConfirmScreenStateErrorSending(message: response.error?.message ?? 'Error sending token'));
    }
  }

}
