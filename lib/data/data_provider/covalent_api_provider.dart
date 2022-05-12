

import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/models/covalent_log_transaction.dart';
import 'package:sing_app/data/models/covalent_nft.dart';
import 'package:sing_app/data/models/covalent_token_price.dart';
import 'package:sing_app/data/response/covalent_api_response.dart';
import 'package:sing_app/utils/logger_util.dart';

import 'api_manager.dart';
import 'base_api.dart';

class CovalentApiProvider {
  late BaseAPI _baseAPI;

  CovalentApiProvider(BaseAPI baseAPI) {
    _baseAPI = baseAPI;
  }

  // Future<CovalentPaginationResponse<CovalentNftDetail>> fetchNfts({
  //   required String chainId,
  //   required String address,
  //   required Map<String, dynamic> params
  // }) async {
  //   try {
  //     final Map responseJson = await _baseAPI.request(
  //       manager: ApiManager(
  //         ApiType.fetchNfts,
  //         additionalPath: '/$chainId/address/$address/balances_v2/',
  //       ),
  //       queryParams: params,
  //       isUseAccessToken: false,
  //     );
  //     final CovalentPaginationResponse response = CovalentPaginationResponse.fromJson(responseJson);
  //     if (!response.isError) {
  //       final List<CovalentNft> items = [];
  //       for (final itemJson in response.data ?? []) {
  //         if(itemJson['type'] == 'nft') {
  //           final item = CovalentNft.fromJson(itemJson);
  //           items.add(item);
  //         }
  //       }
  //
  //       final List<CovalentNftDetail> listNftDetail = [];
  //       for(final covalentNft in items) {
  //         for( final nftDetail in covalentNft.nftData ?? []) {
  //           listNftDetail.add(nftDetail);
  //         }
  //       }
  //
  //       return CovalentPaginationResponse<CovalentNftDetail>(
  //         data: listNftDetail,
  //         isError: false,
  //       );
  //     } else {
  //       return CovalentPaginationResponse<CovalentNftDetail>(
  //           isError: true,
  //           errorMessage: response.errorMessage
  //       );
  //     }
  //   } catch (exception) {
  //     LoggerUtil.error(exception.toString());
  //
  //     return CovalentPaginationResponse<CovalentNftDetail>(
  //         isError: true,
  //         errorMessage: exception.toString()
  //     );
  //   }
  // }

  Future<CovalentPaginationResponse<CovalentTokenPrice>> fetchTokenPrice({
    required List<String> tokens,
    required String currency,
  }) async {
    try {
      final Map responseJson = await _baseAPI.request(
        manager: ApiManager(
          ApiType.fetchTokenPrice,
          additionalPath: '/pricing/tickers/',
        ),
        queryParams: {
          'quote-currency': currency,
          'tickers': tokens.join(','),
          'key': cKey,
          'format': 'JSON'
        },
        isUseAccessToken: false
      );
      final CovalentPaginationResponse response = CovalentPaginationResponse.fromJson(responseJson);
      if (!response.isError) {
        final List<CovalentTokenPrice> items = [];
        for (final itemJson in response.data ?? []) {
          final item = CovalentTokenPrice.fromJson(itemJson);
          items.add(item);
        }
        return CovalentPaginationResponse<CovalentTokenPrice>(
          data: items,
          isError: false,
        );
      } else {
        return CovalentPaginationResponse<CovalentTokenPrice>(
            isError: true,
            errorMessage: response.errorMessage
        );
      }
    } catch (exception) {
      LoggerUtil.error(exception.toString());

      return CovalentPaginationResponse<CovalentTokenPrice>(
          isError: true,
          errorMessage: exception.toString()
      );
    }
  }

}