

import 'package:sing_app/data/data_provider/base_api.dart';
import 'package:sing_app/data/data_provider/covalent_api_provider.dart';
import 'package:sing_app/data/models/covalent_log_transaction.dart';
import 'package:sing_app/data/models/covalent_nft.dart';
import 'package:sing_app/data/models/covalent_token_price.dart';
import 'package:sing_app/data/response/covalent_api_response.dart';

abstract class BaseCovalentRepository {

  // Future<CovalentPaginationResponse<CovalentNftDetail>>fetchNFts(String chainId, String address, Map<String, dynamic> params);
  Future<CovalentPaginationResponse<CovalentTokenPrice>> fetchTokenPrice (List<String> tokens, String currency);
}

class CovalentRepository extends BaseCovalentRepository {
  late CovalentApiProvider _covalentApiProvider;

  CovalentRepository(BaseAPI baseAPI) {
    _covalentApiProvider = CovalentApiProvider(baseAPI);
  }

  // @override
  // Future<CovalentPaginationResponse<CovalentNftDetail>> fetchNFts(String chainId, String address, Map<String, dynamic> params) {
  //   return _covalentApiProvider.fetchNfts(chainId: chainId, address: address, params: params);
  // }

  @override
  Future<CovalentPaginationResponse<CovalentTokenPrice>> fetchTokenPrice(List<String> tokens, String currency) {
    return _covalentApiProvider.fetchTokenPrice(tokens: tokens, currency: currency);
  }
}