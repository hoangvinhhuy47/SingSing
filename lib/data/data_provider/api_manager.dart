import 'package:flutter/foundation.dart';
import 'package:sing_app/constants/constants.dart';

enum HttpMethod { get, post, put, del }
enum ApiType {
  // AUTH
  userProfile,

  // Wallet
  wallets,
  tokenBalances,
  tokenPrice,
  networkGasFee,
  sendToken,
  addCustomToken,
  getContractInfo,
  updateName,

  //Sing nft
  nftMetadata,
  uploadCover,
  nftUserProfile,

  //media
  uploadAvatar,

  // covalent
  // fetchLogTransactions,
  fetchNfts,
  fetchTokenPrice,

  //bsc scan
  bscScanApi,

  // moralus
  fetchMoralisNfts
}

class ApiConfig {
  String path;
  HttpMethod method;
  Map<String, String> headers;

  ApiConfig({
    required this.path,
    required this.method,
    required this.headers,
  });
}

class ApiManager {
  final ApiType type;
  String? additionalPath;

  ApiManager(
    this.type, {
      this.additionalPath,
  });

  ApiConfig getConfig() {
    ApiConfig config;
    switch (type) {
      case ApiType.wallets:
        config = ApiConfig(
            path: '/api/wallets',
            method: HttpMethod.get,
            headers: _defaultHeaders);
        break;
      case ApiType.tokenBalances:
        config = ApiConfig(
            path: '/api/wallets',
            method: HttpMethod.get,
            headers: _defaultHeaders);
        break;
      case ApiType.nftMetadata:
        config = ApiConfig(
            path: '/nft/metadata',
            method: HttpMethod.post,
            headers: _defaultHeaders);
        break;
      case ApiType.tokenPrice:
        config = ApiConfig(
            path: '/queue/price',
            method: HttpMethod.get,
            headers: _defaultHeaders);
        break;
      case ApiType.networkGasFee:
        config = ApiConfig(
            path: '/nft/gas_fee',
            method: HttpMethod.post,
            headers: _defaultHeaders);
        break;
      case ApiType.sendToken:
        config = ApiConfig(
            path: '/api/wallets/',
            method: HttpMethod.post,
            headers: _defaultHeaders);
        break;
      case ApiType.addCustomToken:
        config = ApiConfig(
            path: '/api/wallets/$additionalPath/token',
            method: HttpMethod.post,
            headers: _defaultHeaders);
        break;
      case ApiType.getContractInfo:
        config = ApiConfig(
            path: '/api/token/info',
            method: HttpMethod.get,
            headers: _defaultHeaders);
        break;
      case ApiType.userProfile:
        config = ApiConfig(
            path: '/api/profile',
            method: HttpMethod.get,
            headers: _defaultHeaders);
        break;
      case ApiType.updateName:
        config = ApiConfig(
            path: '/api/wallets/$additionalPath/update',
            method: HttpMethod.post,
            headers: _defaultHeaders);
        break;
      case ApiType.uploadAvatar:
        config = ApiConfig(
            path: '/avatar',
            method: HttpMethod.post,
            headers: _defaultHeaders);
        break;

      // case ApiType.fetchLogTransactions:
      //   config = ApiConfig(
      //       path: '$additionalPath',
      //       method: HttpMethod.get,
      //       headers: _defaultHeaders);
      //   break;
      case ApiType.fetchNfts:
        config = ApiConfig(
            path: '$additionalPath',
            method: HttpMethod.get,
            headers: _defaultHeaders);
        break;
      case ApiType.bscScanApi:
        config = ApiConfig(
            path: '',
            method: HttpMethod.get,
            headers: _defaultHeaders);
        break;
      case ApiType.fetchTokenPrice:
        config = ApiConfig(
            path: '$additionalPath',
            method: HttpMethod.get,
            headers: _defaultHeaders);
        break;

      case ApiType.uploadCover:
        config = ApiConfig(
            path: '/user/update/cover',
            method: HttpMethod.post,
            headers: _defaultHeaders);
        break;
      case ApiType.nftUserProfile:
        config = ApiConfig(
            path: '/auth/check',
            method: HttpMethod.post,
            headers: _defaultHeaders);
        break;
      case ApiType.fetchMoralisNfts:
        config = ApiConfig(
            path: '$additionalPath',
            method: HttpMethod.get,
            headers: _moralisHeaders);
        break;
    }
    return config;
  }

  Map<String, String> get _defaultHeaders {
    return {'Content-Type': 'application/json'};
  }

  Map<String, String> get _moralisHeaders {
    return {
      'Content-Type': 'application/json',
      'X-API-Key' : moralisApiKey,
    };
  }
}
