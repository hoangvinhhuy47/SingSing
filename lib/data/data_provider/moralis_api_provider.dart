

import 'package:sing_app/data/models/moralis_nft.dart';
import 'package:sing_app/data/response/moralis_api_response.dart';
import 'package:sing_app/utils/logger_util.dart';

import 'api_manager.dart';
import 'base_api.dart';

class MoralisApiProvider {
  late BaseAPI _baseAPI;

  MoralisApiProvider(BaseAPI baseAPI) {
    _baseAPI = baseAPI;
  }

  Future<MoralisPaginationResponse<MoralisNft>> fetchNfts({
    required String chainId,
    required String address,
    required Map<String, dynamic> params
  }) async {
    try {
      final Map responseJson = await _baseAPI.request(
        manager: ApiManager(
          ApiType.fetchMoralisNfts,
          additionalPath: '/$address/nft',
        ),
        queryParams: params,
        isUseAccessToken: false,
      );
      final MoralisPaginationResponse response = MoralisPaginationResponse.fromJson(responseJson);
      if (!response.isError) {
        final List<MoralisNft> items = [];
        for (final itemJson in response.result ?? []) {
          final item = MoralisNft.fromJson(itemJson);
          items.add(item);
        }

        return MoralisPaginationResponse<MoralisNft>(
          result: items,
          isError: false,
        );
      } else {
        return MoralisPaginationResponse<MoralisNft>(
            isError: true,
            errorMessage: response.errorMessage
        );
      }
    } catch (exception) {
      LoggerUtil.error(exception.toString());

      return MoralisPaginationResponse<MoralisNft>(
          isError: true,
          errorMessage: exception.toString()
      );
    }
  }


}