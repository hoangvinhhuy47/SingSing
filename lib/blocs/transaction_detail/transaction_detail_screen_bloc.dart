import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sing_app/blocs/transaction_detail/transaction_detail_screen_event.dart';
import 'package:sing_app/blocs/transaction_detail/transaction_detail_screen_state.dart';
import 'package:sing_app/data/models/balance.dart';
import 'package:sing_app/data/repository/covalent_repository.dart';


class TransactionDetailScreenBloc extends Bloc<TransactionDetailScreenEvent, TransactionDetailScreenState> {

  final BaseCovalentRepository covalentRepository;
  final Balance _balance;

  double _price = 0;
  double get price => _price;

  TransactionDetailScreenBloc({
    required this.covalentRepository,
    required balance,
  }) :
        _balance = balance,
        super(TransactionDetailScreenStateInitial()){
    on<TransactionDetailScreenEventStarted>((event, emit) async {
      await _mapTransactionDetailScreenEventStartedToState(emit);
    });
  }

  Future<void> _mapTransactionDetailScreenEventStartedToState(Emitter<TransactionDetailScreenState> emit) async {
    emit(TransactionDetailScreenStateLoading());

    //get wallet balance btc and dollar
    final List<String> tokenSymbols = [];
    tokenSymbols.add(_balance.symbol);

    final responseTokenPrice = await covalentRepository.fetchTokenPrice(tokenSymbols, 'USD');
    if (!responseTokenPrice.isError && responseTokenPrice.data != null) {
      if(responseTokenPrice.data!.isNotEmpty) {
        final item = responseTokenPrice.data!.first;
        _price = item.quoteRate ?? 0.0;
      }
    }

    emit(TransactionDetailScreenStateLoaded());
  }

}
