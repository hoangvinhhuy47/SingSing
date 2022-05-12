import 'package:sing_app/utils/parse_util.dart';

class Oauth2Response {

  String? accessToken;
  int? expiresIn;
  int? refreshExpiresIn;
  String? refreshToken;
  String? tokenType;
  String? idToken;
  String? sessionState;
  String? scope;

  Oauth2Response({
    this.accessToken,
    this.expiresIn,
    this.refreshExpiresIn,
    this.refreshToken,
    this.tokenType,
    this.idToken,
    this.sessionState,
    this.scope
  });

  Oauth2Response.fromJson(Map<String, dynamic> json) {
    accessToken = Parse.toStringValue(json['access_token']);
    expiresIn = Parse.toIntValue(json['expires_in']);
    refreshExpiresIn = Parse.toIntValue(json['refresh_expires_in']);
    refreshToken = Parse.toStringValue(json['refresh_token']);
    tokenType = Parse.toStringValue(json['token_type']);
    idToken = Parse.toStringValue(json['id_token']);
    sessionState = Parse.toStringValue(json['session_state']);
    scope = Parse.toStringValue(json['scope']);
  }

}