
import 'package:sing_app/utils/parse_util.dart';

class Oauth2UserInfo {
  String sub = '';
  bool emailVerified = false;
  String name = '';
  String preferredUsername = '';
  String givenName = '';
  String familyName = '';
  String email = '';

  Oauth2UserInfo({
    required this.sub,
    required this.emailVerified,
    required this.name,
    required this.preferredUsername,
    required this.givenName,
    required this.familyName,
    required this.email
  });

  Oauth2UserInfo.fromJson(Map<String, dynamic> json) {
    sub = Parse.toStringValue(json['sub']);
    emailVerified = Parse.toBoolValue(json['email_verified']);
    name = Parse.toStringValue(json['name']);
    preferredUsername = Parse.toStringValue(json['preferred_username']);
    givenName = Parse.toStringValue(json['given_name']);
    familyName = Parse.toStringValue(json['family_name']);
    email = Parse.toStringValue(json['email']);
  }

  Map<String, dynamic> toJson(){
    return {
      'sub': sub,
      'email_verified': emailVerified,
      'name': name,
      'preferred_username': preferredUsername,
      'given_name': givenName,
      'family_name': familyName,
      'email': email,
    };
  }
}