import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/constants/extension_constant.dart';

class UserProfile {
  String userId = '';
  bool hasMasterPin = false;
  String username = '';
  String email = '';
  String firstName = '';
  String lastName = '';
  String nickname = '';
  String googleId = '';
  String facebookId = '';
  Map<String, String> attributes = {};
  String avatar = '';
  int type = UserType.normal.value;
  String symbol = '';
  int amount = 0;
  String? cover = '';
  bool emailVerified = false;

  UserProfile({
    required this.userId,
    required this.hasMasterPin,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.nickname,
    required this.googleId,
    required this.facebookId,
    required this.attributes,
    required this.avatar,
    required this.type,
    required this.symbol,
    required this.amount,
    required this.emailVerified,
  });

  UserProfile.fromJson(Map<String, dynamic> json) {
    userId = json['userId'] ?? json['user_id'] ?? '';
    hasMasterPin = json['hasMasterPin'] ?? false;
    username = json['username'] ?? '';
    email = json['email'] ?? '';
    firstName = json['firstName'] ?? json['first_name'] ?? '';
    lastName = json['lastName'] ?? json['last_name'] ?? '';
    nickname = json['nickname'] ?? '';
    googleId = json['googleId'] ?? '';
    facebookId = json['facebookId'] ?? '';
    if (json['attributes'] != null) {
      final map = json['attributes'] as Map<String, dynamic>;
      map.forEach((key, value) {
        attributes[key] = value as String;
      });
    }
    avatar = json['avatar'] ?? '';
    type = json['type'] ?? 0;
    symbol = json['symbol'] ?? '';
    amount = json['amount'] ?? 0;
    cover = json['cover'] ?? '';
    emailVerified = json['email_verified'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['userId'] = userId;
    data['hasMasterPin'] = hasMasterPin;
    data['username'] = username;
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['nickname'] = nickname;
    data['googleId'] = googleId;
    data['facebookId'] = facebookId;
    data['attributes'] = attributes;
    data['avatar'] = avatar;
    data['type'] = type;
    data['symbol'] = symbol;
    data['amount'] = amount;
    data['cover'] = cover;
    data['emailVerified'] = emailVerified;
    return data;
  }

  String getFullName() {
    // var name = '';
    // if (firstName.isNotEmpty && lastName.isNotEmpty) {
    //   name = '$firstName $lastName';
    // } else {
    //   name = username;
    // }
    return username;
  }

  String getPosition() {
    if (type == UserType.mod.value) {
      return l('SuperMod') + " | ";
    } else if (type == UserType.admin.value) {
      return l('Admin') + " | ";
    } else {
      return '';
    }
  }

  bool isMod() => type == UserType.mod.value || type == UserType.admin.value;

}
