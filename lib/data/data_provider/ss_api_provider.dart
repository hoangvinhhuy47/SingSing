import 'dart:convert';

import 'package:sing_app/config/app_config.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/data_provider/ss_api.dart';
import 'package:sing_app/data/models/admin_keycloark_user_info.dart';
import 'package:sing_app/data/models/nft.dart';
import 'package:sing_app/data/models/nft_data.dart';
import 'package:sing_app/data/response/ss_response.dart';
import 'package:sing_app/oauth2/oauth2_response.dart';
import 'package:sing_app/utils/logger_util.dart';

import 'package:http/http.dart' as http;

class SsApiProvider {
  late SsAPI _ssAPI;
  final tag = 'SsApiProvider';

  SsApiProvider(SsAPI ssAPI) {
    _ssAPI = ssAPI;
  }

  Future<DefaultSsResponse<Nft>> fetchNftMetadata({
    required String chainId,
    required String address,
    required String nftId,
  }) async {
    try {
      String rootUrl =
          '${AppConfig.instance.values.sraSingSingUrl}/v1/$chainId/tokens/$address/nft_meta/$nftId';
      final Map responseJson = await _ssAPI.get(url: rootUrl);

      final DefaultSsResponse response =
          DefaultSsResponse.fromMap(responseJson);

      if (response.success && response.data != null) {
        final item = Nft.fromJson(response.data['nft_data']['external_data']);
        return DefaultSsResponse<Nft>(data: item);
      } else {
        return DefaultSsResponse<Nft>(
            error: response.error,
            success: false
        );
      }
    } catch (exception) {
      LoggerUtil.error('fetchNftMetadata error: ${exception.toString()}');
      return DefaultSsResponse<Nft>.withError(
        SsError(message: exception.toString()),
      );
    }
  }

  Future<PaginatorSsResponse<NftData>> fetchNftsMetadata({
    required String chainId,
    required String address,
    required String nftsId,
  }) async {
    try {
      String rootUrl =
          '${AppConfig.instance.values.sraSingSingUrl}/v1/$chainId/tokens/$address/nft_metas';
      Map<String, dynamic> params = {};
      params['token_ids'] = nftsId;
      final Map responseJson = await _ssAPI.get(url: rootUrl, params: params);

      // LoggerUtil.info('fetchNftsMetadata responseJson: $responseJson');
      final PaginatorSsResponse response =
          PaginatorSsResponse.fromMap(responseJson);
      LoggerUtil.info('fetchNftsMetadata: ${response.data?.length}');
      if (response.success && response.data != null) {
        final List<NftData> items = [];
        for (final itemJson in response.data ?? []) {
          if (itemJson['nft_data'] != null) {
            final item = NftData.fromJson(itemJson['nft_data']);
            items.add(item);
            LoggerUtil.info('fetchNftsMetadata: add new ${item.tokenId}');
          }
        }

        // Map<String, dynamic> nftMetadata= response.data['nft_data']['external_data'];
        return PaginatorSsResponse<NftData>(data: items);
      } else {
        return PaginatorSsResponse<NftData>(
            error: response.error,
            success: false
        );
      }
    } catch (exception) {
      LoggerUtil.error('fetchNftsMetadata error: ${exception.toString()}');
      return PaginatorSsResponse<NftData>.withError(
        SsError(message: exception.toString()),
      );
    }
  }

  Future<DefaultSsResponse<String>> changeUserInfo({
    // required String email,
    required String firstName,
    required String lastName,
  }) async {
    try {
      String rootUrl = '${AppConfig.instance.values.singApiUrl}/user/update';

      Map<String, String> headers = {};
      headers['Content-Type'] = 'application/json';
      headers['x-lang'] = AppLocalization.instance.currentLangCode.code;

      Map<String, String> params = {};
      // params['email'] = email;
      params['first_name'] = firstName;
      params['last_name'] = lastName;

      final Map responseJson = await _ssAPI.post(url: rootUrl, headers: headers, params: params, isUseAccessToken: true);
      LoggerUtil.info('changeUserInfo responseJson: $responseJson');
      final DefaultSsResponse response = DefaultSsResponse.fromMap(responseJson);

      LoggerUtil.info('changeUserInfo response: ${response.success} - data: ${response.data}');
      if (response.success && response.data != null) {
        String result = l("User information changed successfully");
        if(response.data['message'] != null) {
          result = response.data['message'];
          LoggerUtil.info('result: $result');
        }
        return DefaultSsResponse<String>(data: result);
      } else {
        return DefaultSsResponse<String>(
            error: response.error,
            success: false
        );
      }
    } catch (exception) {
      LoggerUtil.error('changeUserInfo error: ${exception.toString()}');
      return DefaultSsResponse<String>.withError(
        SsError(message: exception.toString()),
      );
    }
  }

  Future<DefaultSsResponse<String>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      String rootUrl = '${AppConfig.instance.values
          .singApiUrl}/user/change-pass';

      Map<String, String> headers = {};
      headers['Content-Type'] = 'application/json';
      headers['x-lang'] = AppLocalization.instance.currentLangCode.code;

      Map<String, dynamic> params = {};
      params['old_password'] = oldPassword;
      params['password'] = newPassword;

      final Map responseJson = await _ssAPI.post(url: rootUrl,
          headers: headers,
          params: params,
          isUseAccessToken: true);
      final DefaultSsResponse response = DefaultSsResponse.fromMap(
          responseJson);

      LoggerUtil.info(
          'changePassword response.data: ${response.success} - data: ${response
              .data} response.errorMessage ${response.error?.message}');
      if (response.success && response.data != null) {
        String result = l("Password changed successfully");
        if (response.data['message'] != null) {
          result = response.data['message'];
          LoggerUtil.info('result: $result');
        }
        return DefaultSsResponse<String>(data: result);
      } else {
        return DefaultSsResponse<String>(
            error: response.error,
            success: false
        );
      }
    } catch (exception) {
      LoggerUtil.error('changePassword error: ${exception.toString()}');
      return DefaultSsResponse<String>.withError(
        SsError(message: exception.toString()),
      );
    }
  }

  Future<DefaultSsResponse<Map<String, dynamic>>> getCloudConfig(int versionCode, String os) async {
    try {
      String rootUrl = '${AppConfig.instance.values.singApiUrl}/app/config';
      Map<String, dynamic> params = {};
      params['version_code'] = versionCode;
      params['os'] = os;

      final Map responseJson = await _ssAPI.get(url: rootUrl, params: params);
      final DefaultSsResponse response = DefaultSsResponse.fromMap(responseJson);

      LoggerUtil.info('getCloudConfig: ${response.data}');
      if (response.success && response.data != null) {
        return DefaultSsResponse<Map<String, dynamic>>(data: response.data);
      } else {
        return DefaultSsResponse<Map<String, dynamic>>(
            error: response.error,
            success: false
        );
      }
    } catch (exception) {
      LoggerUtil.error('getCloudConfig error: ${exception.toString()}');
      return DefaultSsResponse<Map<String, dynamic>>.withError(
        SsError(message: exception.toString()),
      );
    }
  }



}
