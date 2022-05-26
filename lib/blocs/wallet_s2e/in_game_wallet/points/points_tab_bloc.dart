import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/transaction.dart';
import 'points_tab_event.dart';
import 'points_tab_state.dart';

class PointsTabBloc extends Bloc<PointsTabEvent, PointsTabState> {
  List<TransactionModel> transactionList = [];
  int _total = 100; //todo fix to 0
  bool _isLoadingTransaction = false;

  int get total => _total;
  bool get isLoadingTransaction => _isLoadingTransaction;

  PointsTabBloc() : super(PointsTabInitialState()) {
    on<PointTabStartedEvent>(_mapPointTabStartedEventToState);
    on<PointTabGetPointTransactionEvent>(
        _mapPointsTabGetPointsTransactionEventToState);
  }

  Future<void> _mapPointTabStartedEventToState(
      PointTabStartedEvent event, Emitter<PointsTabState> emit) async {
   await _mapPointsTabGetPointsTransactionEventToState(null,emit);
  }

  Future<void> _mapPointsTabGetPointsTransactionEventToState(
      PointTabGetPointTransactionEvent? event,
      Emitter<PointsTabState> emit) async {
    _isLoadingTransaction = true;

    if (event?.isRefresh == true) {
      transactionList.clear();
    }

    // todo replace this by call api
    await Future.delayed(const Duration(seconds: 1));
    int length = transactionList.length;
    for (int i = length; i < length + 10; i++) {
      transactionList.add(TransactionModel(
        id: '$i',
        name: "Song $i",
        date: "17-7-2077",
        token: "${i + 1}",
      ));
    }

    _isLoadingTransaction = false;
    emit(const PointsTabGetTransactionDoneState(isDone: true));
    emit(PointsTabInitialState());
  }

  bool isHasMoreTransactions() => transactionList.length < _total;
}
