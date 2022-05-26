
import 'package:sing_app/utils/parse_util.dart';

class AdminKeycloarkUserInfo {
  String id = '';
  bool emailVerified = false;
  String username = '';
  String firstName = '';
  String lastName = '';
  String email = '';

  AdminKeycloarkUserInfo({
    required this.id,
    required this.emailVerified,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email
  });

  AdminKeycloarkUserInfo.fromJson(Map<String, dynamic> json) {
    id = Parse.toStringValue(json['id']);
    emailVerified = Parse.toBoolValue(json['email_verified']);
    username = Parse.toStringValue(json['username']);
    firstName = Parse.toStringValue(json['firstName']);
    lastName = Parse.toStringValue(json['lastName']);
    email = Parse.toStringValue(json['email']);
  }

  // Map<String, dynamic> toJson(){
  //   return {
  //     'sub': sub,
  //     'email_verified': emailVerified,
  //     'name': name,
  //     'preferred_username': preferredUsername,
  //     'given_name': givenName,
  //     'family_name': familyName,
  //     'email': email,
  //   };
  // }
}