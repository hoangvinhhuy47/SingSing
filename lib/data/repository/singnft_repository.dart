import 'dart:io';

import 'package:sing_app/data/data_provider/base_api.dart';
import 'package:sing_app/data/data_provider/singnft_api_provider.dart';
import 'package:sing_app/data/response/singnft_metadata_api_response.dart';

abstract class BaseSingNftRepository {
  Future<SingNftMetadataResponse> getNftMetadata(List<int> tokenIds);
  Future<SingNftUpdateCoverResponse> uploadCover({
    required File file,
    required String mimeType
  });
  Future<SingNftProfileResponse> getUserProfile();
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

  @override
  Future<SingNftUpdateCoverResponse> uploadCover({
    required File file,
    required String mimeType
  }) {
    return _singNftApiProvider.uploadCover(file: file, mimeType: mimeType);
  }

  @override
  Future<SingNftProfileResponse> getUserProfile() {
    return _singNftApiProvider.getUserProfile();
  }

}

