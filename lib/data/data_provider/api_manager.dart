import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';

enum HttpMethod { get, post, put, del }

enum ApiType {
  // AUTH
  // userProfile,

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

  //media
  uploadAvatar,

  // covalent
  // fetchLogTransactions,
  fetchNfts,
  fetchTokenPrice,

  //bsc scan
  bscScanApi,

  // moralus
  fetchMoralisNfts,

  ///Forum
  getForums,
  createPost,
  updatePost,
  getForumDetail,
  getForumPosts,
  getForumPinnedPosts,
  getForumMembers,

  //posts
  getPostDetail,
  getPostComments,
  likePost,
  unlikePost,
  pinPost,
  removePinPost,
  deletePost,
  commentPost,
  reportPost,
  likeComment,
  unLikeComment,
  getReplyComment,

  ///MEDIA
  uploadPhoto,
  uploadVideo,
  deleteMedia,

  /// NOTIFICATIONS
  getForumNotifications,
  realAllNotifications,

  ///S2E_SONG
  getSongs,
  getSongDetail,
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
      // case ApiType.userProfile:
      //   config = ApiConfig(
      //       path: '/api/profile',
      //       method: HttpMethod.get,
      //       headers: _defaultHeaders);
      //   break;
      case ApiType.updateName:
        config = ApiConfig(
            path: '/api/wallets/$additionalPath/update',
            method: HttpMethod.post,
            headers: _defaultHeaders);
        break;
      case ApiType.uploadAvatar:
        config = ApiConfig(
            path: '/avatar', method: HttpMethod.post, headers: _defaultHeaders);
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
            path: '', method: HttpMethod.get, headers: _defaultHeaders);
        break;
      case ApiType.fetchTokenPrice:
        config = ApiConfig(
            path: '$additionalPath',
            method: HttpMethod.get,
            headers: _defaultHeaders);
        break;
      case ApiType.fetchMoralisNfts:
        config = ApiConfig(
            path: '$additionalPath',
            method: HttpMethod.get,
            headers: _moralisHeaders);
        break;
      case ApiType.getForums:
        config = ApiConfig(
            path: '/groups', method: HttpMethod.get, headers: _defaultHeaders);
        break;
      case ApiType.createPost:
        config = ApiConfig(
            path: '/groups', method: HttpMethod.post, headers: _defaultHeaders);
        break;
      case ApiType.updatePost:
        config = ApiConfig(
            path: '/posts/$additionalPath',
            method: HttpMethod.post,
            headers: _defaultHeaders);
        break;
      case ApiType.getForumDetail:
        config = ApiConfig(
            path: '/groups/$additionalPath',
            method: HttpMethod.get,
            headers: _defaultHeaders);
        break;
      case ApiType.getForumPosts:
        config = ApiConfig(
            path: '/groups/$additionalPath/feed',
            method: HttpMethod.get,
            headers: _defaultHeaders);
        break;
      case ApiType.getForumPinnedPosts:
        config = ApiConfig(
            path: '/groups/$additionalPath/pins',
            method: HttpMethod.get,
            headers: _defaultHeaders);
        break;
      case ApiType.getForumMembers:
        config = ApiConfig(
            path: '/groups/$additionalPath/members',
            method: HttpMethod.get,
            headers: _defaultHeaders);
        break;
      case ApiType.getPostDetail:
        config = ApiConfig(
            path: '/posts/$additionalPath',
            method: HttpMethod.get,
            headers: _defaultHeaders);
        break;
      case ApiType.getPostComments:
        config = ApiConfig(
            path: '/posts/$additionalPath/comments',
            method: HttpMethod.get,
            headers: _defaultHeaders);
        break;
      case ApiType.likePost:
        config = ApiConfig(
            path: '/posts/$additionalPath/like',
            method: HttpMethod.post,
            headers: _defaultHeaders);
        break;
      case ApiType.unlikePost:
        config = ApiConfig(
            path: '/posts/$additionalPath/like',
            method: HttpMethod.del,
            headers: _defaultHeaders);
        break;
      case ApiType.pinPost:
        config = ApiConfig(
            path: '/posts/$additionalPath/pin',
            method: HttpMethod.post,
            headers: _defaultHeaders);
        break;
      case ApiType.removePinPost:
        config = ApiConfig(
            path: '/posts/$additionalPath/pin',
            method: HttpMethod.del,
            headers: _defaultHeaders);
        break;
      case ApiType.deletePost:
        config = ApiConfig(
            path: '/posts/$additionalPath',
            method: HttpMethod.del,
            headers: _defaultHeaders);
        break;
      case ApiType.commentPost:
        config = ApiConfig(
            path: '/posts/$additionalPath/comments',
            method: HttpMethod.post,
            headers: _defaultHeaders);
        break;
      case ApiType.reportPost:
        config = ApiConfig(
            path: '/posts/$additionalPath/report',
            method: HttpMethod.post,
            headers: _defaultHeaders);
        break;
      case ApiType.uploadPhoto:
        config = ApiConfig(
            path: '/media/photo',
            method: HttpMethod.post,
            headers: _defaultHeaders);
        break;
      case ApiType.uploadVideo:
        config = ApiConfig(
            path: '/media/video',
            method: HttpMethod.post,
            headers: _defaultHeaders);
        break;
      case ApiType.deleteMedia:
        config = ApiConfig(
            path: '/media/$additionalPath',
            method: HttpMethod.del,
            headers: _defaultHeaders);
        break;
      case ApiType.getForumNotifications:
        config = ApiConfig(
            path: '/notification',
            method: HttpMethod.get,
            headers: _defaultHeaders);
        break;
      case ApiType.realAllNotifications:
        config = ApiConfig(
            path: '/notification/update-state',
            method: HttpMethod.post,
            headers: _defaultHeaders);
        break;
      case ApiType.likeComment:
        config = ApiConfig(
            path: '/posts/$additionalPath/like',
            method: HttpMethod.post,
            headers: _defaultHeaders);
        break;
      case ApiType.unLikeComment:
        config = ApiConfig(
            path: '/posts/$additionalPath/like',
            method: HttpMethod.del,
            headers: _defaultHeaders);
        break;
      case ApiType.getReplyComment:
        config = ApiConfig(
            path: '/posts/$additionalPath',
            method: HttpMethod.get,
            headers: _defaultHeaders);
        break;
        ///S2E
      case ApiType.getSongs:
        config = ApiConfig(
            path: '/song',
            method: HttpMethod.get,
            headers: _defaultHeaders);
        break;
        case ApiType.getSongDetail:
        config = ApiConfig(
            path: '/song/$additionalPath',
            method: HttpMethod.get,
            headers: _defaultHeaders);
        break;
    }
    return config;
  }

  Map<String, String> get _defaultHeaders {
    return {
      'Content-Type': 'application/json',
      'lang': AppLocalization.instance.locale.languageCode
    };
  }

  Map<String, String> get _moralisHeaders {
    return {
      'Content-Type': 'application/json',
      'X-API-Key': moralisApiKey,
    };
  }
}
