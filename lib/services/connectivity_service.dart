import 'dart:async';

import 'package:connectivity/connectivity.dart';

class ConnectivityService {

  Future<bool> hasConnection() async {
    final bool internet = await _checkConnection();
    return (internet != null && internet);
  }

  Future<bool> _checkConnection() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}
