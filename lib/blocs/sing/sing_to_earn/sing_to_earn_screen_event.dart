abstract class SingToEarnScreenEvent {
  const SingToEarnScreenEvent();
}

class SingToEarnScreenStartedEvent extends SingToEarnScreenEvent {}

class SingToEarnScreenDecreaseCountDownTimeEvent extends SingToEarnScreenEvent {
}

class SingToEarnScreenUpdateIsShowTipsEvent extends SingToEarnScreenEvent {
  final bool isShowTips;

  const SingToEarnScreenUpdateIsShowTipsEvent({required this.isShowTips});
}

class SingToEarnScreenUpdateIsSingingEvent extends SingToEarnScreenEvent {
  final bool isSinging;

  const SingToEarnScreenUpdateIsSingingEvent({required this.isSinging});
}

class SingToEarnScreenIncreaseSingTimeEvent extends SingToEarnScreenEvent {}
class SingToEarnScreenDetectHeadphoneEvent extends SingToEarnScreenEvent {}
