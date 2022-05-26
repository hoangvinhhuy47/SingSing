
import 'package:event_bus/event_bus.dart';
import 'package:sing_app/utils/logger_util.dart';

import 'data/models/balance.dart';
import 'data/models/user_profile.dart';
import 'data/models/wallet.dart';
import 'db/db_manager.dart';

class App {
  String tag = 'App';

  App._privateConstructor() {
    eventBus.on().listen((event) {
      // Print the runtime type. Such a set up could be used for logging.
      LoggerUtil.info('listen event: ${event.runtimeType}', tag: 'event_bus');
    });
  }

  static final App _instance = App._privateConstructor();
  static App get instance => _instance;

  Wallet? currentWallet;

  // include hide contract address
  List<Balance> allBalances = [];
  List<Balance> availableBalances = [];
  final Map<String, double> priceTable = {};
  String appName = '';
  String appVersion = '';
  String appBuildNumber = '';
  EventBus eventBus = EventBus();

  // USER
  UserProfile? userApp;
  bool get isLoggedIn => App.instance.userApp != null;

  bool hasNewNotification = false;


  onLogout() {
    userApp = null;
    hasNewNotification = false;
  }

  updateBalances(String walletId, List<Balance> balances) async {
    List<String> hiddenContractAddress =
        await DbManager.instance.getListHideToken(walletId);
    availableBalances = [];
    allBalances = [];
    for (Balance item in balances) {
      bool isHidden = false;
      for (String contractAddress in hiddenContractAddress) {
        if (item.tokenAddress?.isNotEmpty ?? false) {
          if (item.tokenAddress == contractAddress) {
            isHidden = true;
            break;
          }
        } else {
          if (item.secretType == contractAddress) {
            isHidden = true;
            break;
          }
        }
      }
      item.isHidden = isHidden;
      allBalances.add(item);
      if (!isHidden) availableBalances.add(item);
    }
  }


}
