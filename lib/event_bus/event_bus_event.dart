
class EventBusAddCustomTokenSuccess {}
class EventBusTransferTokenSuccessful {}
class EventBusTransferNftSuccessful {}

class EventBusChangeWalletNameSuccessful {
  final String walletId;
  final String name;
  const EventBusChangeWalletNameSuccessful({
    required this.walletId,
    required this.name,
  });
}


class EventBusChangeUserInfoSuccessful {
  final String email;
  const EventBusChangeUserInfoSuccessful({
    required this.email,
  });
}