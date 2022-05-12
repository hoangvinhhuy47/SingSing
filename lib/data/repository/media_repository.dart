import 'dart:io';
import 'package:sing_app/data/data_provider/base_api.dart';
import 'package:sing_app/data/data_provider/media_api_provider.dart';
import 'package:sing_app/data/response/ss_response.dart';
import 'package:sing_app/data/response/wallet_api_response.dart';

abstract class BaseMediaRepository {
  Future<DefaultSsResponse> uploadAvatar({
    required File file,
    required String mimeType
  });

}

class MediaRepository extends BaseMediaRepository {
  late MediaApiProvider _mediaApiProvider;

  MediaRepository(BaseAPI baseAPI) {
    _mediaApiProvider = MediaApiProvider(baseAPI);
  }

  @override
  Future<DefaultSsResponse> uploadAvatar({
    required File file,
    required String mimeType
  }) {
    return _mediaApiProvider.uploadAvatar(file: file, mimeType: mimeType);
  }

}

