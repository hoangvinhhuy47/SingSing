abstract class TransactionHistoryScreenEvent {
  const TransactionHistoryScreenEvent();
}

class GetTransactionHistoryEvent
    extends TransactionHistoryScreenEvent {
  final bool isRefresh;

  const GetTransactionHistoryEvent(
      {this.isRefresh = false});
}