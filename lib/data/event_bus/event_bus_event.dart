
import 'package:sing_app/config/app_localization.dart';

class EventBusAddCustomTokenSuccess {}
class EventBusTransferTokenSuccessful {}
class EventBusTransferNftSuccessful {}
class EventBusNewWalletCreatingSuccessful {}
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

class EventChangedLanguage {
  final LangCode langCode;
  const EventChangedLanguage({
    required this.langCode,
  });
}
class EventBusNavigateToForumSearch {}
class EventBusRefreshForumDetailScreenStateEvent {}
class EventBusForumDetailScreenDeletePostSuccessEvent {}
class EventBusFetchNewPostInPostDetailSuccessEvent {}
class EventBusFetchNewPostInForumDetailSuccessEvent {
  final String postId;
  final bool isAddPost;
  const EventBusFetchNewPostInForumDetailSuccessEvent({required this.postId,required this.isAddPost});
}

class EventBusOnNewNotificationEvent {}
class EventBusLoginLogoutSuccessEvent {}