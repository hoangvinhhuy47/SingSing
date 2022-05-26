
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sing_app/data/data_provider/api_manager.dart';
import 'package:sing_app/data/data_provider/base_api.dart';
import 'package:sing_app/data/response/api_response.dart';
import 'package:sing_app/data/response/singnft_metadata_api_response.dart';
import 'package:sing_app/utils/logger_util.dart';
import 'package:path/path.dart' as path_manager;
import 'package:http_parser/http_parser.dart';

class SingNftApiProvider {
  late BaseAPI _baseAPI;

  SingNftApiProvider(BaseAPI baseAPI) {
    _baseAPI = baseAPI;
  }

  Future<SingNftMetadataResponse> getNftMetadata(List<int> tokenIds) async {
    try {
      final responseJson = await _baseAPI.request(
        manager: ApiManager(ApiType.nftMetadata),
        isUseAccessToken: false,
        bodyParams: {
          'tokens' : tokenIds
        }
      );
      LoggerUtil.info('nft meta data response: $responseJson');
      final response = SingNftMetadataResponse.fromJson(responseJson);
      return response;
    } catch (exception) {
      LoggerUtil.info('exception exception: $exception');
      return SingNftMetadataResponse.withError(
        Error(message: exception.toString()),
      );
    }
  }
}