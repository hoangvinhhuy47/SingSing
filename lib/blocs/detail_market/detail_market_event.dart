abstract class DetailMarketScreenEvent {
  const DetailMarketScreenEvent();
}

class DetailMarketReloadEvent extends DetailMarketScreenEvent {
  final bool isRefresh;

  const DetailMarketReloadEvent({this.isRefresh = false});
}

class DetailMarketScreenStartedEvent extends DetailMarketScreenEvent {}
