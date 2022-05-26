abstract class TransactionHistoryScreenState {
  const TransactionHistoryScreenState();
}

class TransactionHistoryScreenInitialState
    extends TransactionHistoryScreenState {}

class GetTransactionsHistoryDoneState
    extends TransactionHistoryScreenState {
  final bool isDone;
  final String error;

  const GetTransactionsHistoryDoneState(
      {required this.isDone, this.error = ''});
}
