
import 'package:sing_app/utils/parse_util.dart';

class Oauth2Token {
  String accessToken = '';
  String refreshToken = '';

  Oauth2Token({
    required this.accessToken,
    required this.refreshToken,
  });

  Oauth2Token.fromJson(Map<String, dynamic> json) {
    accessToken = Parse.toStringValue(json['access_token']);
    refreshToken = Parse.toStringValue(json['refresh_token']);
  }

  Map<String, dynamic> toJson(){
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }
}