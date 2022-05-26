abstract class SingScreenEvent{
  const SingScreenEvent();
}

class SingScreenGetSongsEvent extends SingScreenEvent {
  final bool isRefresh;

  const SingScreenGetSongsEvent({this.isRefresh = false});
}