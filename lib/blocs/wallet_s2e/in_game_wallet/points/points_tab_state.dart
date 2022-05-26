abstract class PointsTabState {
  const PointsTabState();
}

class PointsTabInitialState extends PointsTabState {}

class PointsTabGetTransactionState extends PointsTabState {}

class PointsTabGetTransactionDoneState extends PointsTabState {
  final bool isDone;
  final String error;

  const PointsTabGetTransactionDoneState(
      {required this.isDone, this.error = ''});
}
