import 'package:sing_app/data/data_provider/ss_api.dart';
import 'package:sing_app/data/data_provider/ss_api_provider.dart';
import 'package:sing_app/data/models/nft.dart';
import 'package:sing_app/data/models/nft_data.dart';
import 'package:sing_app/data/response/ss_response.dart';

abstract class BaseSsRepository {
  Future<DefaultSsResponse<Nft>> fetchNftMetadata(
      String chainId, String address, String nftId);
  Future<PaginatorSsResponse<NftData>> fetchNftsMetadata(
      String chainId, String address, String nftsId);

  Future<DefaultSsResponse<String>> changeUserInfo({
    // required String email,
    required String firstName,
    required String lastName
  });

  Future<DefaultSsResponse<String>> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  // Future<DefaultSsResponse<Oauth2Response>> getAdminToken();

  // Future<DefaultSsResponse<AdminKeycloarkUserInfo>> getAdminKeycloarkUserInfo(
  //     {required String accessToken, required String userId});

  Future<DefaultSsResponse<Map<String, dynamic>?>> getCloudConfig(
      {required int versionCode, required String os});
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
  Future<DefaultSsResponse<String>> changeUserInfo({
    // required String email,
    required String firstName,
    required String lastName
  }) {
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
  Future<DefaultSsResponse<String>> changePassword({
    required String oldPassword,
    required String newPassword
  }) {
    return _ssApiProvider.changePassword(oldPassword: oldPassword, newPassword: newPassword);
  }
}
