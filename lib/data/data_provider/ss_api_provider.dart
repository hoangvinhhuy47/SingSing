import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sing_app/config/app_config.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/data/data_provider/ss_api.dart';
import 'package:sing_app/data/models/graph_url_info_model.dart';
import 'package:sing_app/data/models/nft.dart';
import 'package:sing_app/data/models/nft_data.dart';
import 'package:sing_app/data/response/api_response.dart';
import 'package:sing_app/data/response/ss_response.dart';
import 'package:sing_app/utils/logger_util.dart';
import 'package:path/path.dart' as path_manager;
import 'package:http_parser/http_parser.dart';

import '../../constants/constants.dart';
import '../models/article.dart';
import '../models/notification_info.dart';
import '../models/user_profile.dart';
import '../response/singnft_metadata_api_response.dart';

class SsApiProvider {
  late SsAPI _ssAPI;
  final tag = 'SsApiProvider';

  SsApiProvider(SsAPI ssAPI) {
    _ssAPI = ssAPI;
  }

  // Map<String, String> _defaultHeader() {
  //   Map<String, String> headers = {};
  //   headers['Content-Type'] = 'application/json';
  //   headers['x-lang'] = AppLocalization.instance.currentLangCode.code;
  //   return headers;
  // }

  Future<DefaultSsResponse<Nft>> fetchNftMetadata({
    required String chainId,
    required String address,
    required String nftId,
  }) async {
    try {
      String rootUrl =
          '${AppConfig.instance.values.sraSingSingUrl}/v2/$chainId/tokens/$address/nft_meta/$nftId';
      final Map responseJson = await _ssAPI.get(url: rootUrl);

      final DefaultSsResponse response =
          DefaultSsResponse.fromMap(responseJson);

      if (response.success && response.data != null) {
        final item = Nft.fromJson(response.data['nft_data']['external_data']);
        return DefaultSsResponse<Nft>(data: item);
      } else {
        return DefaultSsResponse<Nft>(error: response.error, success: false);
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
          '${AppConfig.instance.values.sraSingSingUrl}/v2/$chainId/tokens/$address/nft_metas';
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
            error: response.error, success: false);
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

      final Map responseJson = await _ssAPI.post(
          url: rootUrl,
          headers: headers,
          params: params,
          isUseAccessToken: true);
      LoggerUtil.info('changeUserInfo responseJson: $responseJson');
      final DefaultSsResponse response =
          DefaultSsResponse.fromMap(responseJson);

      LoggerUtil.info(
          'changeUserInfo response: ${response.success} - data: ${response.data}');
      if (response.success && response.data != null) {
        String result = l("User information changed successfully");
        if (response.data['message'] != null) {
          result = response.data['message'];
          LoggerUtil.info('result: $result');
        }
        return DefaultSsResponse<String>(data: result);
      } else {
        return DefaultSsResponse<String>(error: response.error, success: false);
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
      String rootUrl =
          '${AppConfig.instance.values.singApiUrl}/user/change-pass';

      Map<String, String> headers = {};
      headers['Content-Type'] = 'application/json';
      headers['x-lang'] = AppLocalization.instance.currentLangCode.code;

      Map<String, dynamic> params = {};
      params['old_password'] = oldPassword;
      params['password'] = newPassword;

      final Map responseJson = await _ssAPI.post(
          url: rootUrl,
          headers: headers,
          params: params,
          isUseAccessToken: true);
      final DefaultSsResponse response =
          DefaultSsResponse.fromMap(responseJson);

      LoggerUtil.info(
          'changePassword response.data: ${response.success} - data: ${response.data} response.errorMessage ${response.error?.message}');
      if (response.success && response.data != null) {
        String result = l("Password changed successfully");
        if (response.data['message'] != null) {
          result = response.data['message'];
          LoggerUtil.info('result: $result');
        }
        return DefaultSsResponse<String>(data: result);
      } else {
        return DefaultSsResponse<String>(error: response.error, success: false);
      }
    } catch (exception) {
      LoggerUtil.error('changePassword error: ${exception.toString()}');
      return DefaultSsResponse<String>.withError(
        SsError(message: exception.toString()),
      );
    }
  }

  Future<DefaultSsResponse<String>> changeEmail({
    required String email,
  }) async {
    try {
      String rootUrl = '${AppConfig.instance.values.singApiUrl}/user/update-email';

      Map<String, String> headers = {};
      headers['Content-Type'] = 'application/json';
      headers['x-lang'] = AppLocalization.instance.currentLangCode.code;

      Map<String, dynamic> params = {};
      params['email'] = email;

      final Map responseJson = await _ssAPI.post(
          url: rootUrl,
          headers: headers,
          params: params,
          isUseAccessToken: true);
      final DefaultSsResponse response = DefaultSsResponse.fromMap(responseJson);

      LoggerUtil.info(
          'changeEmail response.data: ${response.success} - data: ${response.data} response.errorMessage ${response.error?.message}');
      if (response.success && response.data != null) {
        String result = l("Email changed successfully");
        if (response.data['message'] != null) {
          result = response.data['message'];
          LoggerUtil.info('result: $result');
        }
        return DefaultSsResponse<String>(data: result);
      } else {
        return DefaultSsResponse<String>(error: response.error, success: false);
      }
    } catch (exception) {
      LoggerUtil.error('changeEmail error: ${exception.toString()}');
      return DefaultSsResponse<String>.withError(
        SsError(message: exception.toString()),
      );
    }
  }

  Future<DefaultSsResponse<Map<String, dynamic>>> getCloudConfig(
      int versionCode, String os) async {
    try {
      String rootUrl = '${AppConfig.instance.values.singApiUrl}/app/config';
      Map<String, dynamic> params = {};
      params['version_code'] = versionCode;
      params['os'] = os;

      final Map responseJson = await _ssAPI.get(url: rootUrl, params: params);
      final DefaultSsResponse response =
          DefaultSsResponse.fromMap(responseJson);

      LoggerUtil.info('getCloudConfig: ${response.data}');
      if (response.success && response.data != null) {
        return DefaultSsResponse<Map<String, dynamic>>(data: response.data);
      } else {
        return DefaultSsResponse<Map<String, dynamic>>(
            error: response.error, success: false);
      }
    } catch (exception) {
      LoggerUtil.error('getCloudConfig error: ${exception.toString()}');
      return DefaultSsResponse<Map<String, dynamic>>.withError(
        SsError(message: exception.toString()),
      );
    }
  }

  Future<DefaultSsResponse<String>> addDeviceToken(
      {required String deviceToken}) async {
    try {
      String rootUrl =
          '${AppConfig.instance.values.singApiUrl}/notification/register';

      Map<String, String> headers = {};
      headers['Content-Type'] = 'application/json';
      headers['x-lang'] = AppLocalization.instance.currentLangCode.code;

      Map<String, dynamic> params = {};
      params['token'] = deviceToken;

      final Map responseJson = await _ssAPI.post(
          url: rootUrl,
          headers: headers,
          params: params,
          isUseAccessToken: true);
      final DefaultSsResponse response =
          DefaultSsResponse.fromMap(responseJson);

      // LoggerUtil.info('addDeviceToken response.data: ${response.success} - data: ${response.data} response.errorMessage ${response.error?.message}');
      if (response.success && response.data != null) {
        String result = l("Password changed successfully");
        if (response.data['message'] != null) {
          result = response.data['message'];
        }
        return DefaultSsResponse<String>(data: result);
      } else {
        return DefaultSsResponse<String>(error: response.error, success: false);
      }
    } catch (exception) {
      LoggerUtil.error('addDeviceToken error: ${exception.toString()}');
      return DefaultSsResponse<String>.withError(
        SsError(message: exception.toString()),
      );
    }
  }

  Future<DefaultSsResponse<String>> deleteDeviceToken(
      {required String deviceToken}) async {
    try {
      String rootUrl =
          '${AppConfig.instance.values.singApiUrl}/notification/register';

      Map<String, String> headers = {};
      headers['Content-Type'] = 'application/json';
      headers['x-lang'] = AppLocalization.instance.currentLangCode.code;

      Map<String, dynamic> params = {};
      params['token'] = deviceToken;

      final Map responseJson = await _ssAPI.post(
          url: rootUrl,
          headers: headers,
          params: params,
          isUseAccessToken: false);
      final DefaultSsResponse response =
          DefaultSsResponse.fromMap(responseJson);

      LoggerUtil.info(
          'deleteDeviceToken response.data: ${response.success} - data: ${response.data} response.errorMessage ${response.error?.message}');
      if (response.success && response.data != null) {
        String result = l("Password changed successfully");
        if (response.data['message'] != null) {
          result = response.data['message'];
          LoggerUtil.info('result: $result');
        }
        return DefaultSsResponse<String>(data: result);
      } else {
        return DefaultSsResponse<String>(error: response.error, success: false);
      }
    } catch (exception) {
      LoggerUtil.error('deleteDeviceToken error: ${exception.toString()}');
      return DefaultSsResponse<String>.withError(
        SsError(message: exception.toString()),
      );
    }
  }

  Future<DefaultSsResponse<GraphUrlInfo>> getUrlInfo(
      {required String url}) async {
    try {
      final Map responseJson = await _ssAPI.get(
          url: '${AppConfig.instance.values.singApiUrl}/graph?url=$url',
          isUseAccessToken: true);
      final DefaultSsResponse response =
          DefaultSsResponse.fromMap(responseJson);
      if (response.success && response.data != null) {
        final result = GraphUrlInfo.fromJson(response.data!);
        return DefaultSsResponse<GraphUrlInfo>(data: result);
      } else {
        return DefaultSsResponse<GraphUrlInfo>(
            error: response.error, success: false);
      }
    } catch (e) {
      return DefaultSsResponse.withError(
        SsError(message: e.toString()),
      );
    }
  }

  Future<DefaultSsResponse<UserProfile>> getUserProfile() async {
    try {
      final Map responseJson = await _ssAPI.get(
          url: AppConfig.instance.values.singApiUrl + '/user/profile',
          isUseAccessToken: true);
      final DefaultSsResponse response =
          DefaultSsResponse.fromMap(responseJson);
      LoggerUtil.printLog(message: "get user profile response $responseJson");
      if (response.success && response.data != null) {
        final result = UserProfile.fromJson(response.data!);
        return DefaultSsResponse<UserProfile>(data: result);
      } else {
        return DefaultSsResponse<UserProfile>(
            error: response.error, success: false);
      }
    } catch (e) {
      return DefaultSsResponse.withError(
        SsError(message: e.toString()),
      );
    }
  }

  Future<SingNftUpdateCoverResponse> uploadCover({
    required File file,
    required String mimeType
  }) async {
    try {
      final fileType = mimeType.split('/');
      final FormData formData = FormData.fromMap(
        {
          'file': await MultipartFile.fromFile(
            file.path,
            filename: path_manager.basename(file.path),
            contentType: fileType.length >= 2 ? MediaType(fileType[0], fileType[1]) : MediaType('',''),
          ),
        },
      );

      final Map responseJson = await _ssAPI.post(
        url: AppConfig.instance.values.singApiUrl + '/user/update/cover',
        bodyParams: formData,
        isUseAccessToken: true,
      );
      LoggerUtil.info('upload cover res: $responseJson');
      final response = SingNftUpdateCoverResponse.fromJson(responseJson);
      return response;
    } catch (exception) {
      LoggerUtil.info('upload avatar res error: $exception');
      return SingNftUpdateCoverResponse.withError(
        Error(message: exception.toString()),
      );
    }
  }

  Future<PaginatorSsResponse<NotificationInfo>> getNotifications({
    required int offset,
    required int limit,
  }) async {
    try {
      Map<String, dynamic> params = {'offset': offset, 'limit': limit};

      LoggerUtil.info('getNotifications');

      final Map responseJson = await _ssAPI.get(
          url: AppConfig.instance.values.singApiUrl + '/notification',
          params: params,
          isUseAccessToken: true);
      LoggerUtil.info('getNotifications responseJson: $responseJson');

      final res = PaginatorSsResponse.fromMap(responseJson);
      if (res.success && res.data != null) {
        final List<NotificationInfo> notifications = [];
        for (final itemJson in res.data ?? []) {
          final post = NotificationInfo.fromJson(itemJson);
          notifications.add(post);
        }
        return PaginatorSsResponse<NotificationInfo>(
            data: notifications, pagination: res.pagination);
      }
      return PaginatorSsResponse(error: res.error, success: false);
    } catch (e) {
      return PaginatorSsResponse.withError(SsError(message: e.toString()));
    }
  }

  Future<DefaultSsResponse<bool>> readNotifications({
    required List<String> listNotificationIds,
  }) async {
    try {
      Map<String, dynamic> params = {};
      params['ids'] = listNotificationIds;

      final Map responseJson = await _ssAPI.post(
          url: AppConfig.instance.values.singApiUrl +
              '/notification/update-state',
          params: params,
          isUseAccessToken: true);

      final res = DefaultSsResponse.fromMap(responseJson);
      if (res.success && res.data != null) {
        return DefaultSsResponse<bool>(
          data: true,
        );
      }
      return DefaultSsResponse(error: res.error, success: false);
    } catch (e) {
      return DefaultSsResponse.withError(SsError(message: e.toString()));
    }
  }

  Future<DefaultSsResponse<ArticleModel>> getArticle(
      {required ArticleType type}) async {
    try {
      String additionalUrl ;
      switch (type) {
        case ArticleType.whatIsSecretPhrase:
          additionalUrl = '/what-is-secret-phrase';
          break;
        case ArticleType.privacyPolicy:
          additionalUrl = '/policy';
          break;
        case ArticleType.termAndService:
          additionalUrl = '/term';
          break;
      }

      final Map responseJson = await _ssAPI.get(
          url: AppConfig.instance.values.singApiUrl +'/article'+ additionalUrl,
          isUseAccessToken: true);
      LoggerUtil.printLog(message: 'RES ${AppConfig.instance.values.singApiUrl +'/article'+ additionalUrl} $responseJson');
      final res = DefaultSsResponse.fromMap(responseJson);

      if (res.success && res.data != null) {
        return DefaultSsResponse<ArticleModel>(
          data: ArticleModel.fromJson(res.data),
        );
      }
      return DefaultSsResponse(error: res.error, success: false);
    } catch (e) {
      return DefaultSsResponse.withError(SsError(message: e.toString()));
    }
  }
}
