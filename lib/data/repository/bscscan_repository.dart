

import 'package:sing_app/data/data_provider/base_api.dart';
import 'package:sing_app/data/data_provider/bscscan_api_provider.dart';
import 'package:sing_app/data/models/bscscan_log_transaction.dart';
import 'package:sing_app/data/response/bscscan_response.dart';

abstract class BaseBscScanRepository {
  Future<DefaultBscScanResponse<BscScanLogTransaction>> fetchLogTransactions(Map<String, dynamic> params);
}

class BscScanRepository extends BaseBscScanRepository {
  late BscScanApiProvider _bscScanApiProvider;

  BscScanRepository(BaseAPI baseAPI) {
    _bscScanApiProvider = BscScanApiProvider(baseAPI);
  }

  @override
  Future<DefaultBscScanResponse<BscScanLogTransaction>> fetchLogTransactions(Map<String, dynamic> params) async {
    return _bscScanApiProvider.fetchLogTransactions(params: params);
  }

}