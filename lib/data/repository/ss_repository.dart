import 'dart:io';

import 'package:sing_app/data/data_provider/ss_api.dart';
import 'package:sing_app/data/data_provider/ss_api_provider.dart';
import 'package:sing_app/data/models/article.dart';
import 'package:sing_app/data/models/graph_url_info_model.dart';
import 'package:sing_app/data/models/nft.dart';
import 'package:sing_app/data/models/nft_data.dart';
import 'package:sing_app/data/models/user_profile.dart';
import 'package:sing_app/data/response/ss_response.dart';

import '../../constants/constants.dart';
import '../models/notification_info.dart';
import '../response/singnft_metadata_api_response.dart';

abstract class BaseSsRepository {
  Future<DefaultSsResponse<Nft>> fetchNftMetadata(
      String chainId, String address, String nftId);

  Future<PaginatorSsResponse<NftData>> fetchNftsMetadata(
      String chainId, String address, String nftsId);

  Future<DefaultSsResponse<String>> changeUserInfo(
      {
      // required String email,
      required String firstName,
      required String lastName});

  Future<DefaultSsResponse<String>> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  Future<DefaultSsResponse<String>> changeEmail({
    required String email,
  });

  // Future<DefaultSsResponse<Oauth2Response>> getAdminToken();

  // Future<DefaultSsResponse<AdminKeycloarkUserInfo>> getAdminKeycloarkUserInfo(
  //     {required String accessToken, required String userId});

  Future<DefaultSsResponse<Map<String, dynamic>?>> getCloudConfig(
      {required int versionCode, required String os});

  Future<DefaultSsResponse<String>> addDeviceToken(
      {required String deviceToken});

  Future<DefaultSsResponse<String>> deleteDeviceToken(
      {required String deviceToken});

  Future<DefaultSsResponse<GraphUrlInfo>> getUrlInfo({required String url});

  Future<DefaultSsResponse<UserProfile>> getUserProfile();

  Future<SingNftUpdateCoverResponse> uploadCover(
      {required File file, required String mimeType});

  Future<DefaultSsResponse<ArticleModel>> getArticle(
      {required ArticleType type});

  /// NOTIFICATIONS
  Future<PaginatorSsResponse<NotificationInfo>> getNotifications(
      {required int offset, required int limit});

  Future<DefaultSsResponse<bool>> readNotifications(
      {required List<String> listNotificationIds});
}

class SsRepository extends BaseSsRepository {
  late SsApiProvider _ssApiProvider;

  SsRepository(SsAPI ssAPI) {
    _ssApiProvider = SsApiProvider(ssAPI);
  }

  @override
  Future<DefaultSsResponse<Nft>> fetchNftMetadata(
      String chainId, String address, String nftId) {
    return _ssApiProvider.fetchNftMetadata(
        chainId: chainId, address: address, nftId: nftId);
  }

  @override
  Future<PaginatorSsResponse<NftData>> fetchNftsMetadata(
      String chainId, String address, String nftsId) {
    return _ssApiProvider.fetchNftsMetadata(
        chainId: chainId, address: address, nftsId: nftsId);
  }

  @override
  Future<DefaultSsResponse<String>> changeUserInfo(
      {
      // required String email,
      required String firstName,
      required String lastName}) {
    return _ssApiProvider.changeUserInfo(
        // email: email,
        firstName: firstName,
        lastName: lastName);
  }

  @override
  Future<DefaultSsResponse<Map<String, dynamic>>> getCloudConfig(
      {required int versionCode, required String os}) {
    return _ssApiProvider.getCloudConfig(versionCode, os);
  }

  @override
  Future<DefaultSsResponse<String>> changePassword(
      {required String oldPassword, required String newPassword}) {
    return _ssApiProvider.changePassword(
        oldPassword: oldPassword, newPassword: newPassword);
  }

  @override
  Future<DefaultSsResponse<String>> changeEmail({required String email}) {
    return _ssApiProvider.changeEmail(email: email);
  }

  @override
  Future<DefaultSsResponse<String>> addDeviceToken(
      {required String deviceToken}) {
    return _ssApiProvider.addDeviceToken(deviceToken: deviceToken);
  }

  @override
  Future<DefaultSsResponse<String>> deleteDeviceToken(
      {required String deviceToken}) {
    return _ssApiProvider.deleteDeviceToken(deviceToken: deviceToken);
  }

  @override
  Future<DefaultSsResponse<GraphUrlInfo>> getUrlInfo({required String url}) {
    return _ssApiProvider.getUrlInfo(url: url);
  }

  @override
  Future<DefaultSsResponse<UserProfile>> getUserProfile() {
    return _ssApiProvider.getUserProfile();
  }

  @override
  Future<PaginatorSsResponse<NotificationInfo>> getNotifications(
      {required int offset, required int limit}) {
    return _ssApiProvider.getNotifications(offset: offset, limit: limit);
  }

  @override
  Future<DefaultSsResponse<bool>> readNotifications(
      {required List<String> listNotificationIds}) {
    return _ssApiProvider.readNotifications(
        listNotificationIds: listNotificationIds);
  }

  @override
  Future<SingNftUpdateCoverResponse> uploadCover(
      {required File file, required String mimeType}) {
    return _ssApiProvider.uploadCover(file: file, mimeType: mimeType);
  }

  @override
  Future<DefaultSsResponse<ArticleModel>> getArticle({required ArticleType type}) {
    return _ssApiProvider.getArticle(type: type);
  }
}
