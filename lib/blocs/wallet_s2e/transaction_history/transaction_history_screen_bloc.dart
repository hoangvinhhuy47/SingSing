import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/wallet_s2e/transaction_history/transaction_history_screen_event.dart';
import 'package:sing_app/blocs/wallet_s2e/transaction_history/transaction_history_screen_state.dart';

import '../../../data/models/transaction.dart';

class TransactionHistoryScreenBloc
    extends Bloc<TransactionHistoryScreenEvent, TransactionHistoryScreenState> {
  List<TransactionModel> transactionList = [];

  int _total = 100;
  bool _isLoading = false;

  int get total => _total;

  bool get isLoading => _isLoading;

  TransactionHistoryScreenBloc()
      : super(TransactionHistoryScreenInitialState()) {
    on<GetTransactionHistoryEvent>(
        _mapGetTransactionHistoryEventToState);
  }

  Future<void> _mapGetTransactionHistoryEventToState(
      GetTransactionHistoryEvent event,
      Emitter<TransactionHistoryScreenState> emit) async {
    _isLoading = true;

    await Future.delayed(const Duration(seconds: 1)); // todo remove this
    if (event.isRefresh) {
      transactionList.clear();
    }
    //todo replace this by call api
    int length = transactionList.length;
    for (int i = length; i < length + 10; i++) {
      transactionList.add(
        TransactionModel(
          id: '${i + 1}',
          date: '7-7-2077',
          name: 'Mic $i',
          token: '${i}',
        ),
      );
    }

    _isLoading = false;
    emit(const GetTransactionsHistoryDoneState(
        isDone: true));
    emit(TransactionHistoryScreenInitialState());
  }

  bool hasMore() => transactionList.length < _total;
}
