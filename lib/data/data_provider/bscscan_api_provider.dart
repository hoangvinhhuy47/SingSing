

import 'package:sing_app/data/models/bscscan_log_transaction.dart';
import 'package:sing_app/data/response/bscscan_response.dart';
import 'package:sing_app/utils/logger_util.dart';

import 'api_manager.dart';
import 'base_api.dart';

class BscScanApiProvider {
  late BaseAPI _baseAPI;

  BscScanApiProvider(BaseAPI baseAPI) {
    _baseAPI = baseAPI;
  }

  Future<DefaultBscScanResponse<BscScanLogTransaction>> fetchLogTransactions({required Map<String, dynamic> params}) async {
    try {

      final Map responseJson = await _baseAPI.request(
        manager: ApiManager(ApiType.bscScanApi),
        queryParams: params,
        isUseAccessToken: false
      );

      final DefaultBscScanResponse response = DefaultBscScanResponse.fromJson(responseJson);

      if (response.status == '1') {
        final List<BscScanLogTransaction> items = [];
        for (final itemJson in response.result ?? []) {
          final item = BscScanLogTransaction.fromJson(itemJson);
          items.add(item);
        }
        return DefaultBscScanResponse<BscScanLogTransaction>(
          result: items,
          status: '1',
        );
      } else {
        return DefaultBscScanResponse<BscScanLogTransaction>(
            status: '0',
            message: response.message
        );
      }
    } catch (exception) {
      LoggerUtil.error(exception.toString());
      return DefaultBscScanResponse<BscScanLogTransaction>(
          status: '-1',
          message: exception.toString()
      );
    }
  }

}