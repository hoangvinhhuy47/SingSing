import 'package:sing_app/data/models/nft.dart';
import 'package:sing_app/data/models/user_profile.dart';
import 'package:sing_app/data/response/api_response.dart';

class SingNftMetadataResponse extends BaseResponse {
  List<Nft> result = [];
  Error? error;

  SingNftMetadataResponse({
    required this.result,
    required this.error,
  });

  SingNftMetadataResponse.fromJson(dynamic json) {
    //try check error
    try {
      if(json['error'] != null){
        error = Error(message: json['message'], code: json['statusCode']);
      }
    } catch (exception) {
      error = null;
    }

    if(error == null){
      for (final itemJson in json) {
        final nft = Nft.fromJson(itemJson);
        result.add(nft);
      }
    }
  }

  SingNftMetadataResponse.withError(Error err) {
    result = [];
    error = err;
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'error': error?.toJson(),
    };
  }
}

class SingNftUpdateCoverResponse extends BaseResponse {
  String image = '';
  String path = '';
  String hash = '';
  Error? error;

  SingNftUpdateCoverResponse({
    this.image = '',
    this.path = '',
    this.hash = '',
    this.error,
  });

  SingNftUpdateCoverResponse.fromJson(dynamic json) {
    //try check error
    try {
      if(json['error'] != null){
        error = Error(message: json['message'], code: json['statusCode']);
      }
    } catch (exception) {
      error = null;
    }

    if(error == null){
      image = json['image'] ?? '';
      path = json['path'] ?? '';
      hash = json['hash'] ?? '';
    }
  }

  SingNftUpdateCoverResponse.withError(Error err) {
    error = err;
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'path': path,
      'hash': hash,
      'error': error?.toJson(),
    };
  }
}

class SingNftProfileResponse extends BaseResponse {
  UserProfile? user;
  Error? error;

  SingNftProfileResponse({
    this.user,
    this.error,
  });

  SingNftProfileResponse.fromJson(dynamic json) {
    //try check error
    try {
      if(json['error'] != null){
        error = Error(message: json['message'], code: json['code']);
      }
    } catch (exception) {
      error = null;
    }

    if(error == null){
      user = UserProfile.fromJson(json);
    }
  }

  SingNftProfileResponse.withError(Error err) {
    error = err;
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'error': error?.toJson(),
    };
  }
}
