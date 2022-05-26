import 'dart:io';

import 'package:sing_app/data/data_provider/base_api.dart';
import 'package:sing_app/data/data_provider/singnft_api_provider.dart';
import 'package:sing_app/data/response/singnft_metadata_api_response.dart';

abstract class BaseSingNftRepository {
  Future<SingNftMetadataResponse> getNftMetadata(List<int> tokenIds);
}

class SingNftRepository extends BaseSingNftRepository {
  late SingNftApiProvider _singNftApiProvider;

  SingNftRepository(BaseAPI baseAPI) {
    _singNftApiProvider = SingNftApiProvider(baseAPI);
  }

  @override
  Future<SingNftMetadataResponse> getNftMetadata(List<int> tokenIds) async {
    return _singNftApiProvider.getNftMetadata(tokenIds);
  }

}

