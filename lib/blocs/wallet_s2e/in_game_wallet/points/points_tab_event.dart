abstract class PointsTabEvent {
  const PointsTabEvent();
}

class PointTabStartedEvent extends PointsTabEvent {}

class PointTabGetPointTransactionEvent extends PointsTabEvent {
  final bool isRefresh;

  const PointTabGetPointTransactionEvent({this.isRefresh = false});
}

class PointTabGetPointEvent extends PointsTabEvent {}
