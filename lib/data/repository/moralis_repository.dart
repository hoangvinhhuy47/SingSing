

import 'package:sing_app/data/data_provider/base_api.dart';
import 'package:sing_app/data/data_provider/moralis_api_provider.dart';
import 'package:sing_app/data/models/moralis_nft.dart';
import 'package:sing_app/data/response/moralis_api_response.dart';

abstract class BaseMoralisRepository {

  Future<MoralisPaginationResponse<MoralisNft>>fetchNFts(String chainId, String address, Map<String, dynamic> params);

}

class MoralisRepository extends BaseMoralisRepository {
  late MoralisApiProvider _moralisApiProvider;

  MoralisRepository(BaseAPI baseAPI) {
    _moralisApiProvider = MoralisApiProvider(baseAPI);
  }


  @override
  Future<MoralisPaginationResponse<MoralisNft>> fetchNFts(String chainId, String address, Map<String, dynamic> params) {
    return _moralisApiProvider.fetchNfts(chainId: chainId, address: address, params: params);
  }

}